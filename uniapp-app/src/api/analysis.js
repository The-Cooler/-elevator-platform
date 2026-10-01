import { httpGet, httpPost, httpPut } from '../utils/request'

/**
 * 数据分析与预警、站内通知接口
 * 对应论文模块五，以及模块三的工单通知
 */

// ==================== 故障频次统计 ====================

/** 按电梯统计故障次数 */
export const frequencyByElevator = params => httpGet('/analysis/frequency/byElevator', params)

/** 按楼栋统计故障次数 */
export const frequencyByBuilding = params => httpGet('/analysis/frequency/byBuilding', params)

/** 按时间段统计故障趋势，granularity 取 day / week / month */
export const frequencyTrend = params => httpGet('/analysis/frequency/trend', params)

/** 汇总统计指标 */
export const frequencySummary = params => httpGet('/analysis/frequency/summary', params)

/** 数据概览，含电梯总数、本月报修数、待处理数与超期数 */
export const getOverview = () => httpGet('/analysis/frequency/overview')

// ==================== 超期预警 ====================

/** 预警信息列表 */
export const listWarning = params => httpGet('/analysis/warning/list', params)

/** 当前用户未读预警数量 */
export const getUnreadWarningCount = () => httpGet('/analysis/warning/unreadCount')

/** 标记指定预警已读 */
export const readWarning = warningIds => httpPut(`/analysis/warning/read/${warningIds}`)

/** 全部标记已读 */
export const readAllWarning = () => httpPut('/analysis/warning/readAll')

/** 预警规则列表 */
export const listWarningRule = params => httpGet('/analysis/warning/rule/list', params)

// ==================== 电梯健康档案 ====================

/** 健康评分列表，按评分升序 */
export const listHealth = params => httpGet('/analysis/health/list', params)

/** 指定电梯的健康评分报告 */
export const getHealth = elevatorId => httpGet(`/analysis/health/${elevatorId}`)

// ==================== 站内通知 ====================

/** 当前用户的通知列表 */
export const listNotice = params => httpGet('/message/notice/myList', params)

/** 当前用户未读通知数量 */
export const getUnreadNoticeCount = () => httpGet('/message/notice/unreadCount')

/** 标记指定通知已读 */
export const readNotice = noticeIds => httpPut(`/message/notice/read/${noticeIds}`)

/** 全部标记已读 */
export const readAllNotice = () => httpPut('/message/notice/readAll')
