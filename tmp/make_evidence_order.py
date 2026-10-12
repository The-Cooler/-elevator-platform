"""造一张带证据的待接单：业主报修并上传照片，物业派给 weixiu01"""
import io
import json
import os
import struct
import subprocess
import urllib.request
import urllib.error
import uuid
import zlib

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


def make_png(w=200, h=150, rgb=(200, 60, 60)):
    def chunk(tag, data):
        c = tag + data
        return struct.pack('>I', len(data)) + c + struct.pack('>I', zlib.crc32(c) & 0xffffffff)
    raw = b''
    for y in range(h):
        raw += b'\x00' + bytes(rgb) * w
    return (b'\x89PNG\r\n\x1a\n'
            + chunk(b'IHDR', struct.pack('>IIBBBBB', w, h, 8, 2, 0, 0, 0))
            + chunk(b'IDAT', zlib.compress(raw))
            + chunk(b'IEND', b''))


def upload(token, png, name):
    boundary = '----t' + uuid.uuid4().hex
    parts = [
        ('--' + boundary + '\r\n').encode(),
        ('Content-Disposition: form-data; name="file"; filename="%s"\r\n' % name).encode(),
        b'Content-Type: image/png\r\n\r\n', png, b'\r\n',
        ('--' + boundary + '\r\n').encode(),
        b'Content-Disposition: form-data; name="bizType"\r\n\r\n', b'repair_evidence', b'\r\n',
        ('--' + boundary + '--\r\n').encode(),
    ]
    body = b''.join(parts)
    req = urllib.request.Request(BASE + '/common/file/upload', data=body, method='POST')
    req.add_header('Content-Type', 'multipart/form-data; boundary=' + boundary)
    req.add_header('Authorization', 'Bearer ' + token)
    with urllib.request.urlopen(req, timeout=30) as r:
        return json.loads(r.read().decode('utf-8'))


free = sql("""select e.elevator_id from elevator e where e.del_flag='0' and not exists (
  select 1 from repair_order o where o.elevator_id=e.elevator_id and o.del_flag='0'
  and o.order_status in ('pending','assigned','accepted','arrived','repairing','repaired','appealed')) limit 1;""").strip().splitlines()
free = [x for x in free if x.isdigit()]
if not free:
    print('没有空闲电梯')
    raise SystemExit(1)

owner = login('yezhu01', '123456')
prop = login('wuye01', '123456')
eid = int(free[0])

# 传两张图
f1 = upload(owner, make_png(200, 150, (200, 60, 60)), '现场照片1.png')
f2 = upload(owner, make_png(200, 150, (60, 120, 200)), '现场照片2.png')
print('上传两张:', f1.get('fileId'), f2.get('fileId'))

# 报修并绑定证据
r = http('POST', '/repair/track/report', owner, {
    'elevatorId': eid,
    'faultDesc': '电梯门关到一半卡住，反复开合，轿厢内有异响（验证用）',
    'faultType': 'door', 'faultLevel': '1', 'reporterPhone': '13800000003',
    'evidenceList': [
        {'fileId': f1.get('fileId'), 'evidenceType': 'image', 'fileName': '现场照片1.png'},
        {'fileId': f2.get('fileId'), 'evidenceType': 'image', 'fileName': '现场照片2.png'},
    ]
})
oid = sql("select max(order_id) from repair_order;").strip().splitlines()[-1]
# 派给 weixiu01，使其进入待接单
r2 = http('POST', '/order/dispatch/assign', prop, {'orderId': int(oid), 'assigneeId': 101})

ev = sql("select count(*) from repair_evidence where order_id=%s and del_flag='0';" % oid).strip().splitlines()[-1]
st = sql("select order_status, assignee_id from repair_order where order_id=%s;" % oid).strip().splitlines()[-1]
print('工单 %s 状态/负责人: %s，证据 %s 条' % (oid, st, ev))
