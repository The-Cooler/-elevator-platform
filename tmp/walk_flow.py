"""站在每个角色位置上，把九步流程走完。

每一步记录：该角色这时能不能看到业主上传的现场照片。
这是流程走查，不是接口测试——重点看"做决定时手里有没有该有的东西"。
"""
import json
import subprocess
import urllib.request
import urllib.error

BASE = 'http://localhost:8080'
OID = None


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


def evCount(obj):
    """从返回体里取证据条数"""
    if not isinstance(obj, dict):
        return None
    ev = obj.get('evidenceList')
    return len(ev) if isinstance(ev, list) else None


def row(label, role, api, resp, root=None):
    """打印一条走查记录"""
    d = resp
    if root:
        d = (resp.get('data') or {})
    ev = evCount(d) if not root else evCount(d)
    code = resp.get('code')
    status = d.get('orderStatus') if isinstance(d, dict) else None
    mark = '有照片' if ev else '看不到照片'
    print('  %-26s %-8s %-10s code=%s 状态=%-9s 证据=%s  %s'
          % (label, role, api, code, status, ev, mark))
    return ev


def rowsEv(listResp, label, role, api):
    """列表里逐条看证据"""
    rows = listResp.get('rows') or []
    hit = [r for r in rows if isinstance(r.get('evidenceList'), list) and r['evidenceList']]
    print('  %-26s %-8s %-10s 共 %d 条，其中带证据 %d 条  %s'
          % (label, role, api, len(rows), len(hit), '有照片' if hit else '看不到照片'))
    return len(hit)


# ---------- 登录四个角色 ----------
owner = login('yezhu01', '123456')
prop = login('wuye01', '123456')
worker = login('weixiu01', '123456')

OID = sql("select max(order_id) from repair_order where order_status='pending';").strip().splitlines()[-1]
EV = sql("select count(*) from repair_evidence where order_id=%s and del_flag='0';" % OID).strip().splitlines()[-1]

print('=== 走查对象：工单 %s，业主上传了 %s 张照片 ===' % (OID, EV))
print('=== 电梯坐标 ===')
print(sql("""select e.elevator_code, e.longitude, e.latitude, c.community_name, b.building_no, e.unit_no
from elevator e join building b on e.building_id=b.building_id join community c on b.community_id=c.community_id
where e.elevator_id=(select elevator_id from repair_order where order_id=%s);""" % OID))

print()
print('=' * 100)
print('第 1 步  业主报修提交后 —— 业主看自己的报修')
print('=' * 100)
row('业主·我的报修列表', '业主', '/repair/track/myList', http('GET', '/repair/track/myList?pageNum=1&pageSize=5', owner))
row('业主·工单详情', '业主', '/repair/track/{id}', http('GET', '/repair/track/%s' % OID, owner), root='data')

print()
print('=' * 100)
print('第 2 步  物业审核（工单还在 pending）—— 物业要判断这单真不真、急不急')
print('=' * 100)
rowsEv(http('GET', '/order/dispatch/pendingList?pageNum=1&pageSize=10', prop),
       '物业·待派单池(列表)', '物业', '/order/dispatch/pendingList')
rowsEv(http('GET', '/repair/order/list?pageNum=1&pageSize=20', prop),
       '物业·报修工单总表', '物业', '/repair/order/list')
row('物业·工单详情', '物业', '/repair/order/{id}', http('GET', '/repair/order/%s' % OID, prop), root='data')
row('物业·派单页取数', '物业', '/repair/track/{id}', http('GET', '/repair/track/%s' % OID, prop), root='data')

print()
print('=' * 100)
print('第 3 步  物业派单 —— 派给 weixiu01')
print('=' * 100)
r = http('POST', '/order/dispatch/assign', prop, {'orderId': int(OID), 'assigneeId': 101,
                                                  'remark': '流程走查：请尽快处理'})
print('  派单:', r.get('code'), r.get('msg'))
st = sql("select order_status from repair_order where order_id=%s;" % OID).strip().splitlines()[-1]
print('  工单状态 ->', st)

print()
print('=' * 100)
print('第 4 步  维修员接单前 —— 他要判断带什么工具、能不能修')
print('=' * 100)
rowsEv(http('GET', '/order/accept/myList?pageNum=1&pageSize=10', worker),
       '维修员·待接单(列表)', '维修员', '/order/accept/myList')
rowsEv(http('GET', '/order/accept/myAll?pageNum=1&pageSize=10', worker),
       '维修员·全部工单', '维修员', '/order/accept/myAll')
rowsEv(http('GET', '/order/process/myList?pageNum=1&pageSize=10', worker),
       '维修员·在办工单', '维修员', '/order/process/myList')
row('维修员·工单详情', '维修员', '/repair/track/{id}', http('GET', '/repair/track/%s' % OID, worker), root='data')

print()
print('=' * 100)
print('第 5-8 步  接单 → 到场 → 排查 → 完工')
print('=' * 100)
r = http('POST', '/order/accept/confirm', worker, {'orderId': int(OID), 'arriveMinutes': 30})
print('  接单:', r.get('code'), r.get('msg'))

el = sql("""select e.longitude, e.latitude from elevator e
where e.elevator_id=(select elevator_id from repair_order where order_id=%s);""" % OID).strip().splitlines()[-1]
elng, elat = [float(x) for x in el.split('\t')]
r = http('POST', '/order/process/arrive', worker, {
    'orderId': int(OID), 'arriveLocation': '黑龙江省哈尔滨市测试地址',
    'arriveLongitude': elng + 0.00005, 'arriveLatitude': elat + 0.00005, 'demoFlag': '0'})
print('  到场:', r.get('code'), r.get('msg'))

r = http('POST', '/order/process/investigate', worker, {
    'orderId': int(OID), 'investigateNote': '流程走查：导靴磨损导致抖动'})
print('  排查:', r.get('code'), r.get('msg'))

r = http('POST', '/order/process/finish', worker, {
    'orderId': int(OID), 'repairDesc': '流程走查：更换导靴，抖动消除',
    'faultReason': '导靴磨损', 'replaceParts': '导靴 4 只'})
print('  完工:', r.get('code'), r.get('msg'))

st = sql("select order_status from repair_order where order_id=%s;" % OID).strip().splitlines()[-1]
print('  工单状态 ->', st)

print()
print('=' * 100)
print('第 9 步  业主确认闭环 —— 业主这时该看到什么')
print('=' * 100)
row('业主·工单详情', '业主', '/repair/track/{id}', http('GET', '/repair/track/%s' % OID, owner), root='data')
rowsEv(http('GET', '/repair/track/myList?pageNum=1&pageSize=5', owner),
       '业主·我的报修', '业主', '/repair/track/myList')

print()
print('=' * 100)
print('走查结束后：物业侧回看这单')
print('=' * 100)
rowsEv(http('GET', '/order/accept/list?pageNum=1&pageSize=20', prop),
       '物业·接单情况', '物业', '/order/accept/list')
rowsEv(http('GET', '/order/process/list?pageNum=1&pageSize=20', prop),
       '物业·维修过程', '物业', '/order/process/list')
row('物业·工单详情', '物业', '/repair/order/{id}', http('GET', '/repair/order/%s' % OID, prop), root='data')

print()
print('ORDER_ID=%s' % OID)
