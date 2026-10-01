import request from '@/utils/request'
import { download } from '@/utils/request'

// 查询本人的巡检任务列表
export function listMyInspection(query) {
  return request({
    url: '/maintain/inspection/myList',
    method: 'get',
    params: query
  })
}

// 查询巡检任务列表
export function listInspection(query) {
  return request({
    url: '/maintain/inspection/list',
    method: 'get',
    params: query
  })
}

// 手动触发巡检工单生成，扫描到期维保计划并按周期派发
export function generateInspection() {
  return request({
    url: '/maintain/inspection/generate',
    method: 'post'
  })
}

// 上传检查项现场照片，返回 fileId 供提交巡检结果时携带
export function uploadInspectionPhoto(file, bizId) {
  const formData = new FormData()
  formData.append('file', file)
  formData.append('bizType', 'inspection')
  if (bizId) {
    formData.append('bizId', bizId)
  }
  return request({
    url: '/common/file/upload',
    method: 'post',
    headers: { 'Content-Type': 'multipart/form-data' },
    data: formData
  })
}

// 查询巡检记录详细
export function getInspection(recordId) {
  return request({
    url: '/maintain/inspection/' + recordId,
    method: 'get'
  })
}

// 按电梯类型加载对应的检查项清单
export function listInspectionItems(elevatorId) {
  return request({
    url: '/maintain/inspection/items/' + elevatorId,
    method: 'get'
  })
}

// 现场打卡，记录打卡时间与位置
export function clockIn(data) {
  return request({
    url: '/maintain/inspection/clockIn',
    method: 'post',
    data: data
  })
}

// 提交巡检结果，系统归档形成巡检记录
export function submitInspection(data) {
  return request({
    url: '/maintain/inspection/submit',
    method: 'post',
    data: data
  })
}

// 导出巡检记录
export function exportInspection(query) {
  return download('/maintain/inspection/export', query, `inspection_${new Date().getTime()}.xlsx`)
}
