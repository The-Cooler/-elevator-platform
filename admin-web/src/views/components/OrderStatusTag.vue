<template>
  <el-tag
    disable-transitions
    effect="light"
    :style="tagStyle"
  >{{ label }}</el-tag>
</template>

<script setup name="OrderStatusTag">
/**
 * 工单状态标签
 * 数据字典 repair_order_status，字典标签优先，配色由状态值决定
 * 待处理橙、已派单蓝、维修中青、已完成绿、已驳回红
 */
const props = defineProps({
  // 工单状态值，见 repair_order_status 字典
  status: {
    type: String,
    default: ''
  }
})

import { useSharedDict } from './useSharedDict'

const repair_order_status = useSharedDict('repair_order_status')
// 各状态的配色与兜底文案，字典未加载完成时使用
const STATUS_STYLE = {
  pending:   { label: '待处理', color: '#E6A23C', background: '#FDF6EC', border: '#F5DAB1' },
  assigned:  { label: '已派单', color: '#409EFF', background: '#ECF5FF', border: '#B3D8FF' },
  accepted:  { label: '已接单', color: '#409EFF', background: '#ECF5FF', border: '#B3D8FF' },
  arrived:   { label: '已到场', color: '#13C2C2', background: '#E6FFFB', border: '#9CE6E0' },
  repairing: { label: '维修中', color: '#13C2C2', background: '#E6FFFB', border: '#9CE6E0' },
  repaired:  { label: '已修复', color: '#67C23A', background: '#F0F9EB', border: '#C2E7B0' },
  confirmed: { label: '已完成', color: '#67C23A', background: '#F0F9EB', border: '#C2E7B0' },
  rejected:  { label: '已驳回', color: '#F56C6C', background: '#FEF0EF', border: '#FBC4C4' },
  appealed:  { label: '已申诉', color: '#9254DE', background: '#F9F0FF', border: '#D3ADF7' }
}

const DEFAULT_STYLE = { label: '', color: '#909399', background: '#F4F4F5', border: '#D3D4D6' }

const current = computed(() => STATUS_STYLE[props.status] || DEFAULT_STYLE)

// 字典标签优先，取不到时用内置文案
const label = computed(() => {
  const options = repair_order_status.value || []
  const matched = options.find(item => item.value == props.status)
  return matched ? matched.label.trim() : (current.value.label || props.status || '未知')
})

const tagStyle = computed(() => ({
  color: current.value.color,
  backgroundColor: current.value.background,
  borderColor: current.value.border
}))
</script>
