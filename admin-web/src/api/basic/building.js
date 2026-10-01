import request from '@/utils/request'

// 查询楼栋列表
export function listBuilding(query) {
  return request({
    url: '/basic/building/list',
    method: 'get',
    params: query
  })
}

// 新增楼栋
export function addBuilding(data) {
  return request({
    url: '/basic/building',
    method: 'post',
    data: data
  })
}

// 修改楼栋
export function updateBuilding(data) {
  return request({
    url: '/basic/building',
    method: 'put',
    data: data
  })
}

// 删除楼栋
export function delBuilding(ids) {
  return request({
    url: '/basic/building/' + ids,
    method: 'delete'
  })
}
