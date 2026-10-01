import request from '@/utils/request'

// 查询异常工单列表，可按异常类型与紧急程度筛选
export function listException(query) {
  return request({
    url: '/order/exception/list',
    method: 'get',
    params: query
  })
}

// 重新指派给其他维修员
export function reassignException(data) {
  return request({
    url: '/order/exception/reassign',
    method: 'post',
    data: data
  })
}

// 驳回重审，填写驳回原因
export function rejectException(data) {
  return request({
    url: '/order/exception/reject',
    method: 'post',
    data: data
  })
}

// 维修员现场提交异常说明，工单转物业处理
export function reportException(data) {
  return request({
    url: '/order/exception/report',
    method: 'post',
    data: data
  })
}

// 升级为紧急等级、协调外部单位或标记暂缓处理
export function escalateException(data) {
  return request({
    url: '/order/exception/escalate',
    method: 'post',
    data: data
  })
}

// 异常工单统计：按异常类型、小区、时间段统计发生次数
export function exceptionStatistics(query) {
  return request({
    url: '/order/exception/statistics',
    method: 'get',
    params: query
  })
}
