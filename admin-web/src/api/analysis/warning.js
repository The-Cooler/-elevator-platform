import request from '@/utils/request'

// 查询预警信息列表
export function listWarning(query) {
  return request({
    url: '/analysis/warning/list',
    method: 'get',
    params: query
  })
}

// 查询未读预警数量，用于消息中心角标
export function getUnreadCount() {
  return request({
    url: '/analysis/warning/unreadCount',
    method: 'get'
  })
}

// 标记预警已读
export function readWarning(warningIds) {
  const data = Array.isArray(warningIds) ? warningIds : [warningIds]
  return request({
    url: '/analysis/warning/read',
    method: 'put',
    data: data
  })
}

// 全部标记已读
export function readAllWarning() {
  return request({
    url: '/analysis/warning/readAll',
    method: 'put'
  })
}

// 查询预警规则列表
export function listWarningRule(query) {
  return request({
    url: '/analysis/warning/rule/list',
    method: 'get',
    params: query
  })
}

// 新增预警规则
export function addWarningRule(data) {
  return request({
    url: '/analysis/warning/rule',
    method: 'post',
    data: data
  })
}

// 修改预警规则
export function updateWarningRule(data) {
  return request({
    url: '/analysis/warning/rule',
    method: 'put',
    data: data
  })
}

// 预警规则启用停用
export function changeWarningRuleStatus(data) {
  return request({
    url: '/analysis/warning/rule/changeStatus',
    method: 'put',
    data: data
  })
}
