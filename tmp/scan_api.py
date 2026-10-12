"""扫出前端所有页面调用的接口，逐个实测，找不存在的、报错的"""
import io
import json
import os
import re
import subprocess
import urllib.request
import urllib.error

BASE = 'http://localhost:8080'
ROOT = r'E:\Desktop\2023毕设\董\项目\web-portal\src'


def http(method, path, token=None, body=None):
    data = json.dumps(body).encode('utf-8') if body is not None else None
    req = urllib.request.Request(BASE + path, data=data, method=method)
    req.add_header('Content-Type', 'application/json')
    if token:
        req.add_header('Authorization', 'Bearer ' + token)
    try:
        with urllib.request.urlopen(req, timeout=20) as r:
            return r.status, json.loads(r.read().decode('utf-8'))
    except urllib.error.HTTPError as e:
        try:
            return e.code, json.loads(e.read().decode('utf-8'))
        except Exception:
            return e.code, {}
    except Exception as e:
        return -1, {'msg': str(e)}


def login(u, p):
    r = subprocess.run(['curl', '-s', BASE + '/captchaImage'], capture_output=True)
    cap = json.loads(r.stdout.decode('utf-8'))
    code = subprocess.run(['redis-cli', 'get', 'captcha_codes:' + cap['uuid']],
                          capture_output=True, text=True).stdout.strip().strip('"')
    s, d = http('POST', '/login', body={
        'username': u, 'password': p, 'code': code, 'uuid': cap['uuid']})
    return d.get('token', '')


print('=== 收集前端调用的所有接口 ===')
calls = set()
for dirpath, dirnames, filenames in os.walk(ROOT):
    if 'node_modules' in dirpath:
        continue
    for fn in filenames:
        if not fn.endswith(('.js', '.vue')):
            continue
        p = os.path.join(dirpath, fn)
        try:
            s = io.open(p, encoding='utf-8').read()
        except Exception:
            continue
        # httpGet/httpPost/httpPut/httpDelete(httpDownload)('/xxx'
        for m in re.finditer(r"http(Get|Post|Put|Delete|Download)\(\s*['\"]([^'\"]+)['\"]", s):
            calls.add((m.group(1).lower(), m.group(2)))
        # 模板字符串拼接的
        for m in re.finditer(r"http(Get|Post|Put|Delete|Download)\(\s*`([^`]+)`", s):
            raw = m.group(2)
            # 把 ${...} 换成占位
            raw = re.sub(r'\$\{[^}]*\}', '{id}', raw)
            calls.add((m.group(1).lower(), raw))
        # service({url: '...'}) 形式
        for m in re.finditer(r"url:\s*['\"]([^'\"]+)['\"]", s):
            calls.add(('get', m.group(1)))

print('  共 %d 个不同的调用' % len(calls))

tok = login('wuye01', '123456')
print('  物业 token:', len(tok) > 100)

print()
print('=== 逐个实测（GET 直接打，其余用空体探测是否存在）===')
bad_404 = []
bad_500 = []
ok = 0

for method, path in sorted(calls):
    # 把 {id} 占位换成 1，把模板里的变量替换掉
    test = path
    test = re.sub(r'/\{[^}]+\}', '/1', test)
    test = re.sub(r'/\$\{[^}]+\}', '/1', test)
    test = test.split('?')[0]

    if method in ('get', 'download'):
        status, resp = http('GET', test, tok)
    else:
        status, resp = http(method.upper(), test, tok)

    msg = str(resp.get('msg', ''))[:60]
    if 'No static resource' in msg or 'not supported' in msg:
        bad_404.append((method, path, msg))
    elif status >= 500 or resp.get('code') == 500:
        # 业务失败也可能正常，这里只记接口不存在类的
        if not any(x in msg for x in ['不能从', '无权', '不存在', '重复', '请', '该', '未']):
            bad_500.append((method, path, msg))
    else:
        ok += 1

print('  正常: %d' % ok)
print()
print('=== 接口不存在 ===')
if bad_404:
    for m, p, msg in bad_404:
        print('  [%s] %s' % (m.upper(), p))
        print('        %s' % msg)
else:
    print('  无')

print()
print('=== 其他异常 ===')
if bad_500:
    for m, p, msg in bad_500:
        print('  [%s] %s  -> %s' % (m.upper(), p, msg))
else:
    print('  无')
