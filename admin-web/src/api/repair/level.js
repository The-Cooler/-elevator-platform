import request from '@/utils/request'

// 故障等级属于字典数据，复用若依框架原生的字典接口维护，
// 不另建平行接口，避免功能重复

// 查询故障等级字典数据列表
export function listLevel(query) {
  return request({
    url: '/system/dict/data/list',
    method: 'get',
    params: { dictType: 'fault_level', ...query }
  })
}

// 新增故障等级
export function addLevel(data) {
  return request({
    url: '/system/dict/data',
    method: 'post',
    data: { dictType: 'fault_level', ...data }
  })
}

// 修改故障等级
export function updateLevel(data) {
  return request({
    url: '/system/dict/data',
    method: 'put',
    data: data
  })
}

// 删除故障等级
export function delLevel(dictCodes) {
  return request({
    url: '/system/dict/data/' + dictCodes,
    method: 'delete'
  })
}

// 查询故障类型字典数据列表
export function listFaultType(query) {
  return request({
    url: '/system/dict/data/list',
    method: 'get',
    params: { dictType: 'fault_type', ...query }
  })
}

// 调整工单的故障等级
export function changeOrderLevel(data) {
  return request({
    url: '/repair/level/changeLevel',
    method: 'put',
    data: data
  })
}

// 按故障等级统计工单数量
export function levelStatistics() {
  return request({
    url: '/repair/level/statistics',
    method: 'get'
  })
}
