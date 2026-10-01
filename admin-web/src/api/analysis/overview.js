import request from '@/utils/request'

// 首页数据概览：电梯总数、本月报修数、待处理工单数、超期工单数、维保完成率
export function getOverview() {
  return request({
    url: '/analysis/frequency/overview',
    method: 'get'
  })
}

// 最近报修工单，用于首页列表展示
export function getRecentOrders(limit = 10) {
  return request({
    url: '/repair/order/recent',
    method: 'get',
    params: { limit }
  })
}

// 待处理工单池，用于首页待办展示
export function getPendingOrders(query) {
  return request({
    url: '/order/dispatch/pendingList',
    method: 'get',
    params: query
  })
}

// 未读预警数量，用于首页待办角标
export function getUnreadWarningCount() {
  return request({
    url: '/analysis/warning/unreadCount',
    method: 'get'
  })
}
