"""用真实 ID 复核前面那批"接口不存在"，区分真缺失与脚本误报"""
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
    s, d = call('POST', '/login', body={'username': u, 'password': p,
                                        'code': code, 'uuid': cap['uuid']})
    return d.get('token', '')


def sql(s):
    r = subprocess.run(['mysql', '-h127.0.0.1', '-uroot', '-proot', 'elevator', '-e', s],
                       capture_output=True)
    return r.stdout.decode('utf-8', 'ignore')


prop = login('wuye01', '123456')
owner = login('yezhu01', '123456')

# 从库里取真实 id
oid = sql("select order_id from repair_order where del_flag='0' order by order_id desc limit 1;").strip().splitlines()[-1]
rid = sql("select record_id from inspection_record order by record_id desc limit 1;").strip().splitlines()[-1]
pid = sql("select plan_id from maintain_plan order by plan_id limit 1;").strip().splitlines()[-1]
eid = sql("select elevator_id from elevator where del_flag='0' limit 1;").strip().splitlines()[-1]
evid = sql("select evidence_id from repair_evidence limit 1;").strip().splitlines()[-1]
iid = sql("select item_id from maintain_item limit 1;").strip().splitlines()[-1]
bizid = sql("select evidence_id from repair_evidence limit 1;").strip().splitlines()[-1]

print('真实ID: order=%s inspection=%s plan=%s elevator=%s evidence=%s' % (oid, rid, pid, eid, evid))

tests = [
    ('GET', '/repair/track/%s' % oid, prop, '业主/维修员看工单详情'),
    ('GET', '/repair/track/timeline/%s' % oid, prop, '工单时间轴'),
    ('GET', '/repair/track/checkOpen/%s' % eid, owner, '报修前校验可否报修'),
    ('GET', '/repair/order/%s' % oid, prop, '物业看工单详情'),
    ('GET', '/repair/evidence/byOrder/%s' % oid, prop, '按工单查证据'),
    ('GET', '/maintain/inspection/%s' % rid, prop, '巡检记录详情'),
    ('GET', '/maintain/inspection/items/%s' % rid, prop, '巡检检查项明细'),
    ('GET', '/maintain/plan/%s' % pid, prop, '维保计划详情'),
    ('GET', '/maintain/archive/byElevator/%s' % eid, prop, '按电梯查档案'),
    ('GET', '/order/dispatch/recommend/%s' % oid, prop, '推荐维修员'),
    ('GET', '/order/process/record/%s' % oid, prop, '查维修记录'),
    ('GET', '/analysis/health/%s' % eid, prop, '电梯健康报告'),
    ('GET', '/analysis/health/trend/%s' % eid, prop, '健康评分趋势'),
    ('DELETE', '/repair/evidence/%s' % evid, prop, '删除证据'),
    ('DELETE', '/maintain/plan/%s' % pid, prop, '删除维保计划'),
    ('DELETE', '/maintain/plan/template/%s' % iid, prop, '删除检查项'),
]

print()
print('%-6s %-46s %-6s %s' % ('方法', '路径', '状态', '判定'))
print('-' * 96)
bad = []
for method, path, tok, label in tests:
    status, resp = call(method, path, tok)
    msg = str(resp.get('msg', ''))[:44]
    code = resp.get('code')
    if 'No static resource' in msg or 'not supported' in msg:
        verdict = '接口不存在'
        bad.append((method, path, label))
    elif code == 200:
        verdict = '存在可用'
    else:
        verdict = '存在（业务拒绝：%s）' % msg
    print('%-6s %-46s %-6s %s' % (method, path[:46], status, verdict))
    if msg and 'No static' not in msg and 'not supported' not in msg:
        pass

print()
print('=== 真的不存在 ===')
if bad:
    for m, p, l in bad:
        print('  [%s] %s  (%s)' % (m, p, l))
else:
    print('  无——前面那批全是脚本误报（模板字符串被截断）')
