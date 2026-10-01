import { httpGet, httpPost } from '../utils/request'

/**
 * 认证接口
 * 对应论文模块一用户注册与登录
 */

/** 图形验证码 */
export const getCaptcha = () => httpGet('/basic/auth/captcha')

/**
 * 账号密码登录
 * @param {Object} data { username, password, code, uuid }
 */
export const login = data => httpPost('/basic/auth/login', data)

/**
 * 手机号密码登录
 * 对应论文「通过手机号或账号密码登录」
 * @param {Object} data { phonenumber, password, code, uuid }
 */
export const phoneLogin = data => httpPost('/basic/auth/phoneLogin', data)

/** 注册，支持业主、物业、维修员、管理员四类角色 */
export const register = data => httpPost('/basic/auth/register', data)

/** 退出登录 */
export const logout = () => httpPost('/basic/auth/logout')

/** 当前登录用户信息 */
export const getUserInfo = () => httpGet('/basic/auth/userInfo')

/** 小区列表，注册与报修时选择 */
export const getCommunityList = () => httpGet('/common/cascade/community/list')

/** 楼栋列表，按小区筛选 */
export const getBuildingList = communityId => httpGet('/common/cascade/building/list', { communityId })

/** 可报修电梯列表，按小区与楼栋筛选 */
export const getElevatorList = params => httpGet('/basic/elevator/location', params)
