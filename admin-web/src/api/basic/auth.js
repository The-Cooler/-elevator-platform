import request from '@/utils/request'

// 图形验证码
export function getCaptcha() {
  return request({
    url: '/basic/auth/captcha',
    method: 'get'
  })
}

// 用户端注册，支持业主、物业、维修员三类角色
export function register(data) {
  return request({
    url: '/basic/auth/register',
    method: 'post',
    data: data
  })
}

// 账号密码登录
export function login(data) {
  return request({
    url: '/basic/auth/login',
    method: 'post',
    data: data
  })
}

// 退出登录
export function logout() {
  return request({
    url: '/basic/auth/logout',
    method: 'post'
  })
}

// 查询当前登录用户信息
export function getUserInfo() {
  return request({
    url: '/basic/auth/userInfo',
    method: 'get'
  })
}
