import request from '@/utils/request'

// 查询小区列表
export function listCommunity(query) {
  return request({
    url: '/basic/community/list',
    method: 'get',
    params: query
  })
}

// 新增小区
export function addCommunity(data) {
  return request({
    url: '/basic/community',
    method: 'post',
    data: data
  })
}

// 修改小区
export function updateCommunity(data) {
  return request({
    url: '/basic/community',
    method: 'put',
    data: data
  })
}

// 删除小区
export function delCommunity(ids) {
  return request({
    url: '/basic/community/' + ids,
    method: 'delete'
  })
}
