/**
 * 业务字典与状态文案
 * 与后端 OrderStatusUtil、字典表 sys_dict_data 保持一致
 */

/** 工单状态中文名 */
export const ORDER_STATUS_TEXT = {
  pending: '待处理',
  assigned: '已派单',
  accepted: '已接单',
  arrived: '已到场',
  repairing: '维修中',
  repaired: '已修复',
  confirmed: '已完成',
  rejected: '已驳回',
  appealed: '已申诉'
}

/** 工单状态对应的样式类 */
export const ORDER_STATUS_CLASS = {
  pending: 'tag-pending',
  assigned: 'tag-assigned',
  accepted: 'tag-assigned',
  arrived: 'tag-assigned',
  repairing: 'tag-repairing',
  repaired: 'tag-done',
  confirmed: 'tag-done',
  rejected: 'tag-danger',
  appealed: 'tag-danger'
}

/** 故障类型中文名 */
export const FAULT_TYPE_TEXT = {
  abnormal_noise: '异响',
  stop: '停梯',
  trapped: '困人',
  door: '门故障',
  button: '按钮失灵',
  other: '其他'
}

/** 维保类型中文名 */
export const MAINTAIN_TYPE_TEXT = {
  half_month: '半月保',
  quarter: '季度检',
  half_year: '半年保',
  annual: '年检'
}

/** 故障等级中文名 */
export const FAULT_LEVEL_TEXT = {
  0: '紧急',
  1: '一般'
}

/** 故障等级样式类 */
export const FAULT_LEVEL_CLASS = {
  0: 'tag-danger',
  1: 'tag-pending'
}

/** 检查项分类中文名 */
export const ITEM_CATEGORY_TEXT = {
  traction: '曳引机',
  door_system: '门系统',
  safety: '安全装置',
  control: '控制系统',
  car: '轿厢',
  other: '其他'
}

/** 故障原因中文名 */
export const FAULT_REASON_TEXT = {
  normal_wear: '正常磨损',
  parts_damage: '配件损坏',
  improper_use: '使用不当',
  external: '外部因素',
  other: '其他'
}

/** 巡检记录状态中文名 */
export const RECORD_STATUS_TEXT = {
  pending: '待执行',
  finished: '已完成',
  overdue: '已超期'
}

/** 巡检记录状态样式类 */
export const RECORD_STATUS_CLASS = {
  pending: 'tag-pending',
  finished: 'tag-done',
  overdue: 'tag-danger'
}

/** 取状态中文名，未命中时返回原值 */
export const orderStatusText = status => ORDER_STATUS_TEXT[status] || status || ''

/** 取状态样式类 */
export const orderStatusClass = status => ORDER_STATUS_CLASS[status] || 'tag-muted'

/** 格式化日期时间，取到分钟 */
export const formatDateTime = value => {
  if (!value) return ''
  return String(value).replace('T', ' ').substring(0, 16)
}

/** 格式化日期，取到天 */
export const formatDate = value => {
  if (!value) return ''
  return String(value).substring(0, 10)
}
