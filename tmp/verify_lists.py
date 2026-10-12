"""核对三个列表现在都带证据了"""
import json
import subprocess
import urllib.request
import urllib.error

BASE = 'http://localhost:8080'


def call(method, path, token=None, body=None):
    data = json.dumps(body).encode('utf-8') if body is not None else None
    req = urllib.request.Request(BASE + path, data=data, method=method)
    req.add_header('Content-Type', 'application/json')
    if token:
        req.add_header('Authorization', 'Bearer ' + token)
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


def login(u, p):
    r = subprocess.run(['curl', '-s', BASE + '/captchaImage'], capture_output=True)
    cap = json.loads(r.stdout.decode('utf-8'))
    code = subprocess.run(['redis-cli', 'get', 'captcha_codes:' + cap['uuid']],
                          capture_output=True, text=True).stdout.strip().strip('"')
    return call('POST', '/login', body={'username': u, 'password': p,
                                        'code': code, 'uuid': cap['uuid']}).get('token', '')


def sql(s):
    r = subprocess.run(['mysql', '-h127.0.0.1', '-uroot', '-proot', 'elevator', '-e', s],
                       capture_output=True)
    return r.stdout.decode('utf-8', 'ignore')


owner = login('yezhu01', '123456')
prop = login('wuye01', '123456')
worker = login('weixiu01', '123456')

print('=== 库里的证据分布 ===')
print(sql("""select o.order_id, o.order_no, o.order_status, o.assignee_id,
       (select count(*) from repair_evidence e where e.order_id=o.order_id and e.del_flag='0') as 证据
from repair_order o where o.del_flag='0'
having 证据 > 0 order by o.order_id;"""))

checks = [
    ('物业·待派单池', prop, '/order/dispatch/pendingList?pageNum=1&pageSize=20'),
    ('物业·报修工单总表', prop, '/repair/order/list?pageNum=1&pageSize=20'),
    ('物业·接单情况', prop, '/order/accept/list?pageNum=1&pageSize=20'),
    ('物业·维修过程', prop, '/order/process/list?pageNum=1&pageSize=20'),
    ('业主·我的报修', owner, '/repair/track/myList?pageNum=1&pageSize=20'),
    ('维修员·待接单', worker, '/order/accept/myList?pageNum=1&pageSize=20'),
    ('维修员·在办工单', worker, '/order/process/myList?pageNum=1&pageSize=20'),
]

print()
print('%-20s %-8s %s' % ('列表', '总条数', '带证据的条数'))
print('-' * 60)
for label, tok, path in checks:
    r = call('GET', path, tok)
    rows = r.get('rows') or []
    hit = [x for x in rows if isinstance(x.get('evidenceList'), list) and x['evidenceList']]
    mark = '有' if hit else '—'
    print('%-20s %-8s %-4d  %s' % (label, len(rows), len(hit), mark))
    for x in hit[:2]:
        print('      %s 证据 %d 条' % (x.get('orderNo'), len(x['evidenceList'])))
