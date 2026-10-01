import request from '@/utils/request'

// 查询派给本人的待接单列表
export function listMyAccept(query) {
  return request({
    url: '/order/accept/myList',
    method: 'get',
    params: query
  })
}

// 查询全部工单的接单情况，供物业查看
export function listAccept(query) {
  return request({
    url: '/order/accept/list',
    method: 'get',
    params: query
  })
}

// 查询工单详情，含业主上传的证据附件
export function getAcceptOrder(orderId) {
  return request({
    url: '/order/accept/' + orderId,
    method: 'get'
  })
}

// 确认接单，可填写预计到场时间
export function confirmAccept(data) {
  return request({
    url: '/order/accept/confirm',
    method: 'post',
    data: data
  })
}

// 拒绝接单，工单回到待派单池
export function refuseAccept(data) {
  return request({
    url: '/order/accept/refuse',
    method: 'post',
    data: data
  })
}
