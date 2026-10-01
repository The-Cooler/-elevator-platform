/**
 * 请求封装
 * 与后端 RuoYi 约定保持一致：token 放在 Authorization 头，返回值 { code, msg, data } 或 { code, msg, rows, total }
 */

/** 后端接口地址，开发环境经 vite 代理转发 */
const BASE_URL = import.meta.env.VITE_APP_BASE_API || '/dev-api'

const TOKEN_KEY = 'elevator-uniapp-token'
const USER_KEY = 'elevator-uniapp-user'

export const getToken = () => uni.getStorageSync(TOKEN_KEY) || ''

export const setToken = token => uni.setStorageSync(TOKEN_KEY, token)

export const removeToken = () => uni.removeStorageSync(TOKEN_KEY)

export const getCachedUser = () => {
  const raw = uni.getStorageSync(USER_KEY)
  return raw || null
}

export const setCachedUser = user => {
  if (user) {
    uni.setStorageSync(USER_KEY, user)
  } else {
    uni.removeStorageSync(USER_KEY)
  }
}

/** 登录失效时统一跳转登录页 */
const redirectToLogin = () => {
  removeToken()
  setCachedUser(null)
  const pages = getCurrentPages()
  const current = pages.length ? pages[pages.length - 1].route : ''
  if (current === 'pages/login/index') {
    return
  }
  uni.reLaunch({ url: '/pages/login/index' })
}

/**
 * 通用请求
 * @param {Object} options { url, method, data, header }
 */
export const request = options => {
  const { url, method = 'GET', data = {}, header = {} } = options
  const token = getToken()

  return new Promise((resolve, reject) => {
    uni.request({
      url: BASE_URL + url,
      method,
      data,
      header: {
        'Content-Type': 'application/json;charset=utf-8',
        ...(token ? { Authorization: token } : {}),
        ...header
      },
      success: res => {
        const body = res.data
        // 非标准结构原样返回
        if (!body || typeof body !== 'object' || body.code === undefined) {
          resolve(body)
          return
        }
        if (body.code === 200) {
          resolve(body)
          return
        }
        if (body.code === 401) {
          redirectToLogin()
          reject(new Error(body.msg || '登录状态已过期'))
          return
        }
        uni.showToast({ title: body.msg || '请求失败', icon: 'none' })
        reject(new Error(body.msg || '请求失败'))
      },
      fail: err => {
        uni.showToast({ title: '网络异常，请稍后重试', icon: 'none' })
        reject(new Error(err.errMsg || '网络异常'))
      }
    })
  })
}

export const httpGet = (url, data) => request({ url, method: 'GET', data })

export const httpPost = (url, data) => request({ url, method: 'POST', data })

export const httpPut = (url, data) => request({ url, method: 'PUT', data })

export const httpDelete = (url, data) => request({ url, method: 'DELETE', data })

/**
 * 文件上传
 * @param {String} filePath 本地文件路径
 * @param {String} bizType 业务类型，与后端 FileService 的常量对应
 * @param {Number} bizId 关联业务ID，可为空
 */
export const uploadFile = (filePath, bizType, bizId) => {
  const token = getToken()
  return new Promise((resolve, reject) => {
    uni.uploadFile({
      url: BASE_URL + '/common/file/upload',
      filePath,
      name: 'file',
      formData: {
        bizType,
        ...(bizId ? { bizId: String(bizId) } : {})
      },
      header: token ? { Authorization: token } : {},
      success: res => {
        let body
        try {
          body = JSON.parse(res.data)
        } catch (e) {
          reject(new Error('上传响应解析失败'))
          return
        }
        if (body.code === 200) {
          resolve(body)
        } else {
          uni.showToast({ title: body.msg || '上传失败', icon: 'none' })
          reject(new Error(body.msg || '上传失败'))
        }
      },
      fail: err => {
        uni.showToast({ title: '上传失败', icon: 'none' })
        reject(new Error(err.errMsg || '上传失败'))
      }
    })
  })
}
