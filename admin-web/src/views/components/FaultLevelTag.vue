<template>
  <el-tag
    disable-transitions
    effect="light"
    :style="tagStyle"
  >{{ label }}</el-tag>
</template>

<script setup name="FaultLevelTag">
/**
 * 故障等级标签
 * 数据字典 fault_level，0 紧急（红）、1 一般（橙）
 */
const props = defineProps({
  // 故障等级值，0 紧急 1 一般
  level: {
    type: [String, Number],
    default: ''
  }
})

import { useSharedDict } from './useSharedDict'

const fault_level = useSharedDict('fault_level')

const LEVEL_STYLE = {
  '0': { label: '紧急', color: '#F56C6C', background: '#FEF0EF', border: '#FBC4C4' },
  '1': { label: '一般', color: '#E6A23C', background: '#FDF6EC', border: '#F5DAB1' }
}

const DEFAULT_STYLE = { label: '', color: '#909399', background: '#F4F4F5', border: '#D3D4D6' }

const current = computed(() => LEVEL_STYLE[String(props.level)] || DEFAULT_STYLE)

// 字典标签优先，取不到时用内置文案
const label = computed(() => {
  const options = fault_level.value || []
  const matched = options.find(item => item.value == props.level)
  return matched ? matched.label.trim() : (current.value.label || String(props.level))
})

const tagStyle = computed(() => ({
  color: current.value.color,
  backgroundColor: current.value.background,
  borderColor: current.value.border
}))
</script>
