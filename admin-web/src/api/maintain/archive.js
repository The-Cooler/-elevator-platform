import request from '@/utils/request'
import { download } from '@/utils/request'

// 查询维保档案列表
export function listArchive(query) {
  return request({
    url: '/maintain/archive/list',
    method: 'get',
    params: query
  })
}

// 按电梯查询全生命周期维保履历
export function listArchiveByElevator(elevatorId) {
  return request({
    url: '/maintain/archive/byElevator/' + elevatorId,
    method: 'get'
  })
}

// 查询单条归档明细
export function getArchive(archiveId) {
  return request({
    url: '/maintain/archive/' + archiveId,
    method: 'get'
  })
}

// 查询电梯的维保完成率与巡检合格率
export function getArchiveStatistics(elevatorId) {
  return request({
    url: '/maintain/archive/statistics/' + elevatorId,
    method: 'get'
  })
}

// 导出维保档案
export function exportArchive(query) {
  return download('/maintain/archive/export', query, `maintain_archive_${new Date().getTime()}.xlsx`)
}
