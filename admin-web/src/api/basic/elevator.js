import request from '@/utils/request'
import { download } from '@/utils/request'

// 查询电梯台账列表
export function listElevator(query) {
  return request({
    url: '/basic/elevator/list',
    method: 'get',
    params: query
  })
}

// 查询电梯详细
export function getElevator(elevatorId) {
  return request({
    url: '/basic/elevator/' + elevatorId,
    method: 'get'
  })
}

// 新增电梯
export function addElevator(data) {
  return request({
    url: '/basic/elevator',
    method: 'post',
    data: data
  })
}

// 修改电梯
export function updateElevator(data) {
  return request({
    url: '/basic/elevator',
    method: 'put',
    data: data
  })
}

// 删除电梯
export function delElevator(ids) {
  return request({
    url: '/basic/elevator/' + ids,
    method: 'delete'
  })
}

// 上传电梯年检报告等证件附件
export function uploadElevatorCert(file, elevatorId) {
  const data = new FormData()
  data.append('file', file)
  data.append('bizType', 'elevator_cert')
  if (elevatorId !== undefined && elevatorId !== null && elevatorId !== '') {
    data.append('bizId', elevatorId)
  }
  return request({
    url: '/basic/elevator/uploadCert',
    method: 'post',
    headers: { 'Content-Type': 'multipart/form-data' },
    data: data
  })
}

// 导出电梯台账
export function exportElevator(query) {
  return download('/basic/elevator/export', query, `elevator_${new Date().getTime()}.xlsx`)
}
