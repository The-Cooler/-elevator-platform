import request from '@/utils/request'

// 查询用户列表
export function listUser(query) {
  return request({
    url: '/basic/user/list',
    method: 'get',
    params: query
  })
}

// 新增用户
export function addUser(data) {
  return request({
    url: '/basic/user',
    method: 'post',
    data: data
  })
}

// 修改用户
export function updateUser(data) {
  return request({
    url: '/basic/user',
    method: 'put',
    data: data
  })
}

// 重置用户密码
export function resetUserPwd(userId, password) {
  return request({
    url: '/basic/user/resetPwd',
    method: 'put',
    data: { userId: userId, password: password }
  })
}

// 启用停用用户账号
export function changeUserStatus(userId, status) {
  return request({
    url: '/basic/user/changeStatus',
    method: 'put',
    data: { userId: userId, status: status }
  })
}
