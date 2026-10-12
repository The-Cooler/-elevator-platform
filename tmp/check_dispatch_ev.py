"""核对物业待派单有关的三个接口是否带证据"""
import json
import subprocess
import urllib.request
import urllib.error

BASE = 'http://localhost:8080'


def http(method, path, token=None, body=None):
    data = json.dumps(body).encode('utf-8') if body is not None else None
    req = urllib.request.Request(BASE + path, data=data, method=method)
    req.add_header('Content-Type', 'application/json')
    if token:
        req.add_header('Authorization', 'Bearer ' + token)
    try:
        with urllib.request.urlopen(req, timeout=25) as r:
            return json.loads(r.read().decode('utf-8'))
    except urllib.error.HTTPError as e:
        try:
            return json.loads(e.read().decode('utf-8'))
        except Exception:
            return {'code': e.code}
    except Exception as e:
        return {'code': -1, 'msg': str(e)}


def login(u, p):
    cap = http('GET', '/captchaImage')
    code = subprocess.run(['redis-cli', 'get', 'captcha_codes:' + cap['uuid']],
                          capture_output=True, text=True).stdout.strip().strip('"')
    return http('POST', '/login', body={
        'username': u, 'password': p, 'code': code, 'uuid': cap['uuid']}).get('token', '')


prop = login('wuye01', '123456')
print('物业 token:', len(prop) > 100)

print()
print('=== 1. 待派单池 /order/dispatch/pendingList ===')
r = http('GET', '/order/dispatch/pendingList?pageNum=1&pageSize=10', prop)
for row in (r.get('rows') or []):
    ev = row.get('evidenceList')
    print('  工单 %-4s %s 证据=%s' % (row.get('orderId'), row.get('orderNo'),
                                    len(ev) if isinstance(ev, list) else ev))

print()
print('=== 2. 工单详情 /repair/order/{id}（物业看单张）===')
for oid in [53, 60]:
    r = http('GET', '/repair/order/%s' % oid, prop)
    d = r.get('data') or {}
    ev = d.get('evidenceList')
    print('  工单 %-4s code=%s 证据=%s' % (oid, r.get('code'), len(ev) if isinstance(ev, list) else ev))

print()
print('=== 3. 派单页取数 /repair/track/{id} ===')
for oid in [53, 60]:
    r = http('GET', '/repair/track/%s' % oid, prop)
    d = r.get('data') or {}
    ev = d.get('evidenceList')
    print('  工单 %-4s code=%s 证据=%s' % (oid, r.get('code'), len(ev) if isinstance(ev, list) else ev))

print()
print('=== 4. 报修工单列表 /repair/order/list（物业总表）===')
r = http('GET', '/repair/order/list?pageNum=1&pageSize=10', prop)
rows = r.get('rows') or []
withEv = [x for x in rows if isinstance(x.get('evidenceList'), list) and x['evidenceList']]
print('  本页 %d 条，带证据 %d 条' % (len(rows), len(withEv)))
