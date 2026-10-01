import request from '@/utils/request'

// 查询证据附件库列表
export function listEvidence(query) {
  return request({
    url: '/repair/evidence/list',
    method: 'get',
    params: query
  })
}

// 按工单查询证据附件
export function listEvidenceByOrder(orderId) {
  return request({
    url: '/repair/evidence/byOrder/' + orderId,
    method: 'get'
  })
}

// 上传证据附件
export function uploadEvidence(file, orderId) {
  const data = new FormData()
  data.append('file', file)
  if (orderId !== undefined && orderId !== null && orderId !== '') {
    data.append('orderId', orderId)
  }
  return request({
    url: '/repair/evidence/upload',
    method: 'post',
    headers: { 'Content-Type': 'multipart/form-data' },
    data: data
  })
}

// 删除证据附件
export function delEvidence(evidenceId) {
  return request({
    url: '/repair/evidence/' + evidenceId,
    method: 'delete'
  })
}
