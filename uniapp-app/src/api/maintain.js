import { httpGet, httpPost } from '../utils/request'

/**
 * 预防性维保接口
 * 对应论文模块四：维保计划、定期巡检执行
 */

// ==================== 维保计划 ====================

/** 维保计划列表 */
export const listPlan = params => httpGet('/maintain/plan/list', params)

/** 维保计划详情 */
export const getPlan = planId => httpGet(`/maintain/plan/${planId}`)

/** 新增维保计划 */
export const addPlan = data => httpPost('/maintain/plan', data)

/** 修改维保计划 */
export const updatePlan = data => httpPost('/maintain/plan', data)

/** 批量创建维保计划 */
export const batchAddPlan = data => httpPost('/maintain/plan/batch', data)

/** 启用或停用维保计划 */
export const changePlanStatus = data => httpPost('/maintain/plan/changeStatus', data)

/** 按维保类型与模板查询检查项清单 */
export const listTemplateItems = params => httpGet('/maintain/plan/template/items', params)

// ==================== 巡检任务 ====================

/** 指派给本人的巡检任务 */
export const listMyInspection = params => httpGet('/maintain/inspection/myList', params)

/** 巡检记录列表 */
export const listInspection = params => httpGet('/maintain/inspection/list', params)

/** 巡检记录详情，含检查项结果明细 */
export const getInspection = recordId => httpGet(`/maintain/inspection/${recordId}`)

/** 查询巡检任务应执行的检查项清单 */
export const listInspectionItems = recordId => httpGet(`/maintain/inspection/items/${recordId}`)

/** 现场打卡，记录打卡时间与位置 */
export const clockIn = (recordId, location) =>
  httpPost(`/maintain/inspection/clockIn?recordId=${recordId}&location=${encodeURIComponent(location || '')}`)

/** 提交巡检结果，逐项记录检查结果并归档 */
export const submitInspection = data => httpPost('/maintain/inspection/submit', data)

/** 巡检结果现场照片上传的业务类型 */
export const INSPECTION_BIZ_TYPE = 'inspection'

// ==================== 维保档案 ====================

/** 维保档案列表 */
export const listArchive = params => httpGet('/maintain/archive/list', params)

/** 指定电梯的完整维保履历 */
export const listArchiveByElevator = elevatorId => httpGet(`/maintain/archive/byElevator/${elevatorId}`)

/** 指定电梯的维保完成率与巡检合格率 */
export const getArchiveStatistics = elevatorId => httpGet(`/maintain/archive/statistics/${elevatorId}`)
