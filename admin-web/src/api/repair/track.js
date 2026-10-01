import request from '@/utils/request'

// 查询全部工单的报修进度跟踪列表
export function listTrack(query) {
  return request({
    url: '/repair/track/list',
    method: 'get',
    params: query
  })
}

// 查询本人报修进度列表
export function listMyTrack(query) {
  return request({
    url: '/repair/track/myList',
    method: 'get',
    params: query
  })
}

// 查询单张工单的进度跟踪详情
export function getTrack(orderId) {
  return request({
    url: '/repair/track/' + orderId,
    method: 'get'
  })
}

// 业主确认故障消除，工单闭环
export function confirmTrack(data) {
  return request({
    url: '/repair/track/confirm',
    method: 'post',
    data: data
  })
}

// 业主对维修结果提交申诉
export function appealTrack(data) {
  return request({
    url: '/repair/track/appeal',
    method: 'post',
    data: data
  })
}
