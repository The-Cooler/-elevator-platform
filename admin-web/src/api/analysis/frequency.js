import request from '@/utils/request'
import { download } from '@/utils/request'

// 按电梯统计故障次数
export function frequencyByElevator(query) {
  return request({
    url: '/analysis/frequency/byElevator',
    method: 'get',
    params: query
  })
}

// 按楼栋统计故障次数
export function frequencyByBuilding(query) {
  return request({
    url: '/analysis/frequency/byBuilding',
    method: 'get',
    params: query
  })
}

// 按时间段统计故障趋势，粒度 day / week / month
export function frequencyTrend(query) {
  return request({
    url: '/analysis/frequency/trend',
    method: 'get',
    params: query
  })
}

// 按故障等级维度拆分统计
export function frequencyByLevel(query) {
  return request({
    url: '/analysis/frequency/byLevel',
    method: 'get',
    params: query
  })
}

// 按故障现象类型统计
export function frequencyByFaultType(query) {
  return request({
    url: '/analysis/frequency/byFaultType',
    method: 'get',
    params: query
  })
}

// 汇总指标：总故障数、紧急故障数、平均响应时长、平均维修时长
export function frequencySummary(query) {
  return request({
    url: '/analysis/frequency/summary',
    method: 'get',
    params: query
  })
}

// 导出统计结果
export function exportFrequency(query) {
  return download('/analysis/frequency/export', query, `fault_frequency_${new Date().getTime()}.xlsx`)
}
