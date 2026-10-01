import request from '@/utils/request'
import { download } from '@/utils/request'

// 查询报修工单列表
export function listRepairOrder(query) {
  return request({
    url: '/repair/order/list',
    method: 'get',
    params: query
  })
}

// 查询报修工单详细
export function getRepairOrder(orderId) {
  return request({
    url: '/repair/order/' + orderId,
    method: 'get'
  })
}

// 管理端代业主提交报修
export function reportOrder(data) {
  return request({
    url: '/repair/order/report',
    method: 'post',
    data: data
  })
}

// 驳回报修单，工单回到业主处待补充
export function rejectOrder(data) {
  return request({
    url: '/repair/order/reject',
    method: 'put',
    data: data
  })
}

// 调整工单故障等级与优先级
export function changeOrderLevel(data) {
  return request({
    url: '/repair/order/changeLevel',
    method: 'put',
    data: data
  })
}

// 查询工单全流程时间轴
export function getOrderTimeline(orderId) {
  return request({
    url: '/repair/order/timeline/' + orderId,
    method: 'get'
  })
}

// 导出报修工单
export function exportRepairOrder(query) {
  return download('/repair/order/export', query, `repair_order_${new Date().getTime()}.xlsx`)
}
