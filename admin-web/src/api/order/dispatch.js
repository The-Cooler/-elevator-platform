import request from '@/utils/request'

// 查询待派单工单池，按报修时间倒序，紧急工单置顶
export function listPendingDispatch(query) {
  return request({
    url: '/order/dispatch/pendingList',
    method: 'get',
    params: query
  })
}

// 按维修员负责区域与技能推荐候选维修员，结果按匹配度排序
export function recommendWorker(orderId) {
  return request({
    url: '/order/dispatch/recommend/' + orderId,
    method: 'get'
  })
}

// 确认派单，工单状态由待处理变为已派单
export function assignOrder(data) {
  return request({
    url: '/order/dispatch/assign',
    method: 'post',
    data: data
  })
}

// 批量派单
export function batchAssignOrder(data) {
  return request({
    url: '/order/dispatch/batchAssign',
    method: 'post',
    data: data
  })
}

// 物业驳回报修单，备注驳回原因
export function rejectDispatch(data) {
  return request({
    url: '/order/dispatch/reject',
    method: 'post',
    data: data
  })
}

// 查询全部维修员及其技能与负责区域，供派单页与计划负责人下拉使用
export function listWorkerSkills(query) {
  return request({
    url: '/order/dispatch/workers',
    method: 'get',
    params: query
  })
}
