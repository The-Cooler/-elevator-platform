import request from '@/utils/request'
import { download } from '@/utils/request'

// 查询电梯健康评分列表，按评分升序、问题电梯前置
export function listHealth(query) {
  return request({
    url: '/analysis/health/list',
    method: 'get',
    params: query
  })
}

// 查询电梯健康评分报告，含三项指标得分与构成明细
export function getHealth(elevatorId) {
  return request({
    url: '/analysis/health/' + elevatorId,
    method: 'get'
  })
}

// 查询健康评分历史趋势
export function getHealthTrend(elevatorId) {
  return request({
    url: '/analysis/health/trend/' + elevatorId,
    method: 'get'
  })
}

// 查询健康评分权重配置
export function getHealthConfig() {
  return request({
    url: '/analysis/health/config',
    method: 'get'
  })
}

// 保存健康评分权重配置
export function updateHealthConfig(data) {
  return request({
    url: '/analysis/health/config',
    method: 'put',
    data: data
  })
}

// 导出健康评分报告为 PDF
export function exportHealthPdf(query) {
  return download('/analysis/health/exportPdf', query, `elevator_health_${new Date().getTime()}.pdf`)
}

// 导出健康评分报告为 Excel
export function exportHealthExcel(query) {
  return download('/analysis/health/exportExcel', query, `elevator_health_${new Date().getTime()}.xlsx`)
}
