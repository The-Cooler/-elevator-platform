<template>
  <el-select
    :model-value="modelValue"
    :placeholder="placeholder"
    :clearable="clearable"
    :disabled="disabled"
    :multiple="multiple"
    :style="{ width: width }"
    @update:model-value="handleChange"
  >
    <el-option
      v-for="dict in options"
      :key="dict.value"
      :label="dict.label"
      :value="dict.value"
    />
  </el-select>
</template>

<script setup name="DictSelect">
/**
 * 字典下拉选择器
 * 按字典类型取 sys_dict_data 渲染选项，供故障等级、维保类型、电梯状态等下拉复用
 * 字典数据按类型共享缓存，同一页面多处使用只请求一次
 */
import { useSharedDict } from './useSharedDict'

const props = defineProps({
  // 绑定值，multiple 为 true 时是数组
  modelValue: {
    type: [String, Number, Array],
    default: undefined
  },
  // 字典类型，如 fault_level、maintain_type、elevator_status
  dictType: {
    type: String,
    required: true
  },
  placeholder: {
    type: String,
    default: '请选择'
  },
  clearable: {
    type: Boolean,
    default: true
  },
  disabled: {
    type: Boolean,
    default: false
  },
  multiple: {
    type: Boolean,
    default: false
  },
  width: {
    type: String,
    default: '200px'
  }
})

const emit = defineEmits(['update:modelValue', 'change'])

const options = useSharedDict(props.dictType)

function handleChange(value) {
  emit('update:modelValue', value)
  emit('change', value)
}
</script>
