"""验证 token 有效期已改长，以及 AOF 已生效"""
import json
import subprocess
import urllib.request
import urllib.error

BASE = 'http://localhost:8080'


def http(method, path, body=None):
    data = json.dumps(body).encode('utf-8') if body is not None else None
    req = urllib.request.Request(BASE + path, data=data, method=method)
    req.add_header('Content-Type', 'application/json')
    try:
        with urllib.request.urlopen(req, timeout=20) as r:
            return json.loads(r.read().decode('utf-8'))
    except urllib.error.HTTPError as e:
        try:
            return json.loads(e.read().decode('utf-8'))
        except Exception:
            return {'code': e.code}
    except Exception as e:
        return {'code': -1, 'msg': str(e)}


def redis(*args):
    r = subprocess.run(['redis-cli'] + list(args), capture_output=True)
    return r.stdout.decode('utf-8', 'ignore').strip()


print('=== 登录，观察新会话的 TTL ===')
cap = http('GET', '/captchaImage')
code = redis('get', 'captcha_codes:' + cap['uuid']).strip('"')
res = http('POST', '/login', {
    'username': 'yezhu01', 'password': '123456', 'code': code, 'uuid': cap['uuid']})
token = res.get('token', '')
print('  登录:', '成功' if token else '失败 ' + str(res.get('msg')))

print()
print('=== 会话 TTL ===')
keys = redis('keys', 'login_tokens:*').split('\n')
keys = [k for k in keys if k.strip()]
print('  当前会话数:', len(keys))
for k in keys[:5]:
    ttl = redis('ttl', k)
    try:
        mins = int(ttl) // 60
        print('    %s ... TTL=%s 秒（约 %s 分钟）' % (k.split(':')[1][:8], ttl, mins))
    except ValueError:
        print('    %s ... TTL=%s' % (k.split(':')[1][:8], ttl))

print()
print('=== Redis AOF 状态 ===')
print('  appendonly:', redis('config', 'get', 'appendonly').split('\n')[-1])
info = redis('info', 'persistence')
for line in info.split('\n'):
    if any(x in line for x in ['aof_enabled', 'aof_last_write_status', 'aof_last_bgrewrite_status', 'rdb_last_bgsave_status']):
        print('  ' + line.strip())
