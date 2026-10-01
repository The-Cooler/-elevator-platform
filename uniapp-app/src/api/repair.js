import { httpGet, httpPost } from '../utils/request'

/**
 * 报修与进度接口
 * 对应论文模块二故障报修与跟踪
 */

/** 业主提交故障报修 */
export const submitReport = data => httpPost('/repair/track/report', data)

/** 业主本人的报修记录分页查询 */
export const getMyOrderPage = params => httpGet('/repair/track/myList', params)

/** 报修工单进度详情，含证据、状态时间轴与维修记录 */
export const getOrderDetail = orderId => httpGet(`/repair/track/${orderId}`)

/** 业主确认故障消除，工单闭环 */
export const confirmOrder = orderId => httpPost('/repair/track/confirm', { orderId })

/** 业主对维修结果提交申诉 */
export const appealOrder = (orderId, remark) => httpPost('/repair/track/appeal', { orderId, remark })

/** 校验指定电梯是否存在未结工单 */
export const checkElevatorOpen = elevatorId => httpGet(`/repair/track/checkOpen/${elevatorId}`)

/** 报修证据上传，bizType 固定为 repair_evidence */
export const EVIDENCE_BIZ_TYPE = 'repair_evidence'
