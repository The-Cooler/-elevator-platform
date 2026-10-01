import request from '@/utils/request'

// 查询维保计划列表
export function listPlan(query) {
  return request({
    url: '/maintain/plan/list',
    method: 'get',
    params: query
  })
}

// 查询维保计划详细
export function getPlan(planId) {
  return request({
    url: '/maintain/plan/' + planId,
    method: 'get'
  })
}

// 新增维保计划
export function addPlan(data) {
  return request({
    url: '/maintain/plan',
    method: 'post',
    data: data
  })
}

// 修改维保计划
export function updatePlan(data) {
  return request({
    url: '/maintain/plan',
    method: 'put',
    data: data
  })
}

// 删除维保计划
export function delPlan(ids) {
  return request({
    url: '/maintain/plan/' + ids,
    method: 'delete'
  })
}

// 计划启用停用
export function changePlanStatus(data) {
  return request({
    url: '/maintain/plan/changeStatus',
    method: 'put',
    data: data
  })
}

// 查询检查项模板
export function getPlanTemplate(query) {
  return request({
    url: '/maintain/plan/template',
    method: 'get',
    params: query
  })
}

// 保存检查项模板
export function addPlanTemplate(data) {
  return request({
    url: '/maintain/plan/template',
    method: 'post',
    data: data
  })
}

// 批量创建维保计划，为多台电梯一次性建立相同计划
export function batchAddPlan(data) {
  return request({
    url: '/maintain/plan/batch',
    method: 'post',
    data: data
  })
}

// 按维保类型与模板名称查询检查项清单
export function listTemplateItems(query) {
  return request({
    url: '/maintain/plan/template/items',
    method: 'get',
    params: query
  })
}
