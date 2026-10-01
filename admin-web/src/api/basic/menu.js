import request from '@/utils/request'

// 查询菜单权限树，供角色分配权限使用
export function menuTreeselect() {
  return request({
    url: '/basic/menu/treeselect',
    method: 'get'
  })
}
