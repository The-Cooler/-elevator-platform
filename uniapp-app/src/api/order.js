import { httpGet, httpPost } from '../utils/request'

/**
 * 工单调度与执行接口
 * 对应论文模块三：物业派单、维修员接单与维修过程
 */

// ==================== 物业：智能派单 ====================

/** 待派单工单池 */
export const getPendingList = params => httpGet('/order/dispatch/pendingList', params)

/** 按区域与技能推荐候选维修员 */
export const recommendWorker = orderId => httpGet(`/order/dispatch/recommend/${orderId}`)

/** 确认派单 */
export const assignOrder = data => httpPost('/order/dispatch/assign', data)

/** 批量派单 */
export const batchAssignOrder = data => httpPost('/order/dispatch/batchAssign', data)

/** 全部维修员及其技能与负责区域 */
export const listWorkers = params => httpGet('/order/dispatch/workers', params)

// ==================== 维修员：接单 ====================

/** 指派给本人的待接单列表 */
export const getMyAcceptList = params => httpGet('/order/accept/myList', params)

/** 指派给本人的全部工单 */
export const getMyAcceptAll = params => httpGet('/order/accept/myAll', params)

/** 确认接单并反馈预计到场时间 */
export const confirmAccept = data => httpPost('/order/accept/confirm', data)

/** 拒绝接单，工单回到待派单池 */
export const refuseAccept = data => httpPost('/order/accept/refuse', data)

// ==================== 维修员：维修过程 ====================

/** 指派给本人的在办工单 */
export const getMyProcessList = params => httpGet('/order/process/myList', params)

/** 登记到达现场，可带定位 */
export const arriveProcess = data => httpPost('/order/process/arrive', data)

/** 填写排查记录，工单进入维修中 */
export const investigateProcess = data => httpPost('/order/process/investigate', data)

/** 维修完成，提交处理说明与更换配件 */
export const finishProcess = data => httpPost('/order/process/finish', data)

/** 查询指定工单的维修记录 */
export const getProcessRecord = orderId => httpGet(`/order/process/record/${orderId}`)

// ==================== 物业：工单异常处理 ====================

/** 异常工单列表，按四类超时识别 */
export const getExceptionList = params => httpGet('/order/exception/list', params)

/** 异常类型统计 */
export const getExceptionStatistics = params => httpGet('/order/exception/statistics', params)

/** 重新指派 */
export const reassignException = data => httpPost('/order/exception/reassign', data)

/** 驳回重审 */
export const rejectException = data => httpPost('/order/exception/reject', data)

/** 维修员上报异常 */
export const reportException = data => httpPost('/order/exception/report', data)

/** 升级为紧急处理 */
export const escalateException = data => httpPost('/order/exception/escalate', data)
