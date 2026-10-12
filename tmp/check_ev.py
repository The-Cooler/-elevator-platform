"""核对：维修员取工单详情时，evidenceList 是否真的返回"""
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


def sql(s):
    r = subprocess.run(['mysql', '-h127.0.0.1', '-uroot', '-proot', 'elevator', '-e', s],
                       capture_output=True)
    return r.stdout.decode('utf-8', 'ignore')


print('=== 库里有哪些证据 ===')
print(sql("""select e.evidence_id, e.order_id, e.file_id, o.order_no, o.assignee_id, o.order_status
from repair_evidence e join repair_order o on e.order_id=o.order_id order by e.evidence_id;"""))

w1 = login('weixiu01', '123456')
owner = login('yezhu01', '123456')
print('维修员 token:', len(w1) > 100, ' 业主 token:', len(owner) > 100)

print()
print('=== 维修员读带证据的工单详情 ===')
ids = sql("select distinct order_id from repair_evidence order by order_id;").strip().splitlines()
for line in ids[1:]:
    oid = line.strip()
    if not oid.isdigit():
        continue
    r = http('GET', '/repair/track/%s' % oid, w1)
    d = r.get('data') or {}
    ev = d.get('evidenceList')
    print('  工单 %-4s code=%s 证据=%s 负责人=%s 状态=%s' % (
        oid, r.get('code'),
        len(ev) if isinstance(ev, list) else ev,
        d.get('assigneeId'), d.get('orderStatus')))

print()
print('=== 业主读同一个工单（对照）===')
for line in ids[1:]:
    oid = line.strip()
    if not oid.isdigit():
        continue
    r = http('GET', '/repair/track/%s' % oid, owner)
    d = r.get('data') or {}
    ev = d.get('evidenceList')
    print('  工单 %-4s code=%s 证据=%s' % (oid, r.get('code'), len(ev) if isinstance(ev, list) else ev))
