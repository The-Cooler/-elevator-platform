import request from '@/utils/request'

// 查询角色列表
export function listRole(query) {
  return request({
    url: '/basic/role/list',
    method: 'get',
    params: query
  })
}

// 新增角色
export function addRole(data) {
  return request({
    url: '/basic/role',
    method: 'post',
    data: data
  })
}

// 修改角色
export function updateRole(data) {
  return request({
    url: '/basic/role',
    method: 'put',
    data: data
  })
}

// 删除角色
export function delRole(roleIds) {
  return request({
    url: '/basic/role/' + roleIds,
    method: 'delete'
  })
}

// 查询角色已分配的菜单权限树
export function getRoleMenuTree(roleId) {
  return request({
    url: '/basic/role/menuTree/' + roleId,
    method: 'get'
  })
}

// 修改角色数据权限（按所属小区隔离）
export function updateRoleDataScope(data) {
  return request({
    url: '/basic/role/dataScope',
    method: 'put',
    data: data
  })
}
