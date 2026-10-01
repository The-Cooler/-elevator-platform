import request from '@/utils/request'

// 查询本人待处理的维修工单列表
export function listMyProcess(query) {
  return request({
    url: '/order/process/myList',
    method: 'get',
    params: query
  })
}

// 查询工单维修过程详情
export function getProcessOrder(orderId) {
  return request({
    url: '/order/process/' + orderId,
    method: 'get'
  })
}

// 记录到达现场
export function arriveProcess(data) {
  return request({
    url: '/order/process/arrive',
    method: 'post',
    data: data
  })
}

// 提交排查记录，可分多次追加
export function investigateProcess(data) {
  return request({
    url: '/order/process/investigate',
    method: 'post',
    data: data
  })
}

// 提交完工，填写故障原因、处理措施与更换配件
export function finishProcess(data) {
  return request({
    url: '/order/process/finish',
    method: 'post',
    data: data
  })
}

// 上传维修后的现场照片作为完工凭证
export function uploadProcessResult(file, orderId) {
  const data = new FormData()
  data.append('file', file)
  if (orderId !== undefined && orderId !== null && orderId !== '') {
    data.append('orderId', orderId)
  }
  return request({
    url: '/order/process/uploadResult',
    method: 'post',
    headers: { 'Content-Type': 'multipart/form-data' },
    data: data
  })
}

// 查询工单的维修记录
export function getProcessRecord(orderId) {
  return request({
    url: '/order/process/record/' + orderId,
    method: 'get'
  })
}
