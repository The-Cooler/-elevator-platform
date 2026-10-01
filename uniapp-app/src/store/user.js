import { defineStore } from 'pinia'
import {
  login as loginApi,
  phoneLogin as phoneLoginApi,
  logout as logoutApi,
  getUserInfo
} from '../api/auth'
import { getToken, setToken, removeToken, getCachedUser, setCachedUser } from '../utils/request'

/**
 * 用户状态管理
 * token 与用户信息持久化到本地存储，刷新后自动恢复
 */
export const useUserStore = defineStore('user', {
  state: () => ({
    token: getToken(),
    userInfo: getCachedUser()
  }),

  getters: {
    isLogin: state => !!state.token,
    /** 主角色标识：owner 业主 / property 物业 / worker 维修员 / admin 管理员 */
    roleKey: state => (state.userInfo && state.userInfo.roleKey) || '',
    /** 导航展示名，优先昵称 */
    displayName: state =>
      (state.userInfo && (state.userInfo.nickName || state.userInfo.userName)) || '',
    isOwner: state => !!state.userInfo && state.userInfo.roleKey === 'owner',
    isProperty: state => !!state.userInfo && state.userInfo.roleKey === 'property',
    isWorker: state => !!state.userInfo && state.userInfo.roleKey === 'worker'
  },

  actions: {
    /** 写入登录态 */
    setLoginState(token, userInfo) {
      this.token = token
      setToken(token)
      this.setUserInfo(userInfo)
    },

    /** 更新用户信息并落本地缓存 */
    setUserInfo(userInfo) {
      this.userInfo = userInfo || null
      setCachedUser(userInfo || null)
    },

    /** 账号密码登录 */
    async login(params) {
      const res = await loginApi(params)
      this.setLoginState(res.token, res.userInfo || null)
      if (!res.userInfo) {
        await this.fetchUserInfo()
      }
      return res
    },

    /** 手机号密码登录 */
    async phoneLogin(params) {
      const res = await phoneLoginApi(params)
      this.setLoginState(res.token, res.userInfo || null)
      if (!res.userInfo) {
        await this.fetchUserInfo()
      }
      return res
    },

    /** 拉取当前登录用户信息 */
    async fetchUserInfo() {
      const res = await getUserInfo()
      this.setUserInfo(res.data)
      return res.data
    },

    /** 清空登录态 */
    clearLoginState() {
      this.token = ''
      this.userInfo = null
      removeToken()
      setCachedUser(null)
    },

    /** 退出登录，先通知后端清除令牌缓存 */
    async logout() {
      try {
        await logoutApi()
      } catch (e) {
        // 令牌已失效时同样按已退出处理
      } finally {
        this.clearLoginState()
      }
    }
  }
})
