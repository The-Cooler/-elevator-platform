<template>
  <view class="page-wrap">
    <view v-if="loading" class="empty"><text>加载中…</text></view>

    <template v-else-if="record">
      <!-- 任务概要 -->
      <view class="card">
        <view class="row-between">
          <text class="record-no">{{ record.recordNo }}</text>
          <text class="tag" :class="RECORD_STATUS_CLASS[record.recordStatus] || 'tag-muted'">
            {{ RECORD_STATUS_TEXT[record.recordStatus] || record.recordStatus }}
          </text>
        </view>
        <view class="info-row">
          <text class="label">电梯</text>
          <text class="value">{{ record.elevatorCode }}（{{ record.communityName }} {{ record.buildingNo }} {{ record.unitNo }}）</text>
        </view>
        <view class="info-row">
          <text class="label">维保类型</text>
          <text class="value">{{ maintainTypeText(record.maintainType) }}</text>
        </view>
        <view class="info-row">
          <text class="label">计划日期</text>
          <text class="value">{{ record.planDate || '—' }}</text>
        </view>
      </view>

      <!-- 现场打卡 -->
      <view class="card">
        <view class="card-title">现场打卡</view>
        <view v-if="record.clockInTime" class="clock-done">
          <text>已打卡：{{ formatDateTime(record.clockInTime) }}</text>
          <text v-if="record.clockInLocation" class="clock-location">{{ record.clockInLocation }}</text>
        </view>
        <template v-else>
          <text class="tip-muted">到达现场后先打卡，再逐项填写检查结果</text>
          <view class="field">
            <text class="field-label">打卡位置</text>
            <input v-model="clockLocation" class="input" placeholder="如：阳光家园小区2号楼1单元" />
          </view>
          <button class="btn-primary action-btn" :loading="clocking" @click="handleClockIn">现场打卡</button>
        </template>
      </view>

      <!-- 检查项清单 -->
      <view v-if="itemList.length" class="card">
        <view class="card-title">检查项（共 {{ itemList.length }} 项）</view>

        <view v-for="(item, index) in itemList" :key="item.itemId" class="item-block">
          <view class="row-between">
            <text class="item-name">{{ index + 1 }}. {{ item.itemName }}</text>
          </view>
          <text v-if="item.checkStandard" class="item-standard">{{ item.checkStandard }}</text>

          <view class="result-group">
            <view
              v-for="opt in resultOptions"
              :key="opt.value"
              class="result-chip"
              :class="{ 'result-chip--active': item.checkResult === opt.value }"
              @click="onResult(item, opt.value)"
            >
              <text>{{ opt.label }}</text>
            </view>
          </view>

          <textarea
            v-if="item.checkResult === 'abnormal'"
            v-model="item.abnormalDesc"
            class="item-textarea"
            placeholder="请填写异常说明"
            maxlength="500"
          />

          <view class="item-photo-row">
            <image
              v-if="item.fileId"
              class="item-photo"
              :src="previewUrl(item.fileId)"
              mode="aspectFill"
              @click="previewItemPhoto(item.fileId)"
            />
            <view v-else class="item-photo-add" @click="chooseItemPhoto(item)">
              <text class="item-photo-icon">+</text>
              <text class="item-photo-text">现场照片</text>
            </view>
            <view v-if="item.fileId" class="item-photo-remove" @click="item.fileId = null">
              <text>移除照片</text>
            </view>
          </view>
        </view>
      </view>

      <!-- 汇总与提交 -->
      <view v-if="itemList.length" class="card">
        <view class="summary-bar">
          <text>正常 {{ normalCount }}</text>
          <text class="summary-abnormal">异常 {{ abnormalCount }}</text>
          <text class="summary-na">不适用 {{ naCount }}</text>
        </view>
        <button
          class="btn-primary action-btn"
          :loading="submitting"
          :disabled="submitting || !record.clockInTime"
          @click="handleSubmit"
        >
          {{ record.clockInTime ? '提交巡检结果' : '请先完成打卡' }}
        </button>
      </view>
    </template>

    <view v-else class="empty"><text>巡检任务不存在</text></view>
  </view>
</template>

<script setup>
import { ref, computed, onMounted } from 'vue'
import { getInspection, listInspectionItems, clockIn, submitInspection, INSPECTION_BIZ_TYPE } from '../../api/maintain'
import { uploadFile, fullUrl } from '../../utils/request'
import { MAINTAIN_TYPE_TEXT, RECORD_STATUS_TEXT, RECORD_STATUS_CLASS, formatDateTime } from '../../utils/dict'

const recordId = ref('')
const record = ref(null)
const loading = ref(true)
const clocking = ref(false)
const submitting = ref(false)

const clockLocation = ref('')
const itemList = ref([])

const resultOptions = [
  { label: '正常', value: 'normal' },
  { label: '异常', value: 'abnormal' },
  { label: '不适用', value: 'na' }
]

const maintainTypeText = type => MAINTAIN_TYPE_TEXT[type] || type || ''

const normalCount = computed(() => itemList.value.filter(i => i.checkResult === 'normal').length)
const abnormalCount = computed(() => itemList.value.filter(i => i.checkResult === 'abnormal').length)
const naCount = computed(() => itemList.value.filter(i => i.checkResult === 'na').length)

const previewUrl = fileId => fullUrl(`/common/file/preview/${fileId}`)

const previewItemPhoto = fileId => {
  uni.previewImage({ urls: [previewUrl(fileId)] })
}

/** 切换检查结果，非异常时清空异常说明 */
const onResult = (item, value) => {
  item.checkResult = value
  if (value !== 'abnormal') {
    item.abnormalDesc = ''
  }
}

const loadData = async () => {
  loading.value = true
  try {
    const res = await getInspection(recordId.value)
    record.value = res.data || null
    if (record.value) {
      clockLocation.value = `${record.value.communityName || ''}${record.value.buildingNo || ''}${record.value.unitNo || ''}`
    }
  } catch (e) {
    record.value = null
    loading.value = false
    return
  }

  try {
    const res = await listInspectionItems(recordId.value)
    const items = res.data || []
    itemList.value = items.map(item => ({
      itemId: item.itemId,
      itemName: item.itemName,
      itemCategory: item.itemCategory,
      checkStandard: item.checkStandard,
      orderNum: item.orderNum,
      checkResult: 'normal',
      abnormalDesc: '',
      fileId: item.fileId || null
    }))
  } catch (e) {
    itemList.value = []
  } finally {
    loading.value = false
  }
}

/** 现场打卡 */
const handleClockIn = async () => {
  clocking.value = true
  try {
    await clockIn(recordId.value, clockLocation.value)
    uni.showToast({ title: '打卡成功', icon: 'success' })
    const res = await getInspection(recordId.value)
    record.value = res.data || record.value
  } catch (e) {
    // 错误提示已在请求层统一处理
  } finally {
    clocking.value = false
  }
}

/** 上传检查项现场照片 */
const chooseItemPhoto = item => {
  uni.chooseImage({
    count: 1,
    sizeType: ['compressed'],
    success: async res => {
      try {
        const uploaded = await uploadFile(res.tempFilePaths[0], INSPECTION_BIZ_TYPE, recordId.value)
        item.fileId = uploaded.fileId
        uni.showToast({ title: '照片上传成功', icon: 'success' })
      } catch (e) {
        // 错误提示已在请求层统一处理
      }
    }
  })
}

/** 提交巡检结果 */
const handleSubmit = async () => {
  const missing = itemList.value.filter(i => i.checkResult === 'abnormal' && !i.abnormalDesc.trim())
  if (missing.length) {
    uni.showToast({ title: `请为 ${missing[0].itemName} 填写异常说明`, icon: 'none' })
    return
  }

  submitting.value = true
  try {
    await submitInspection({
      recordId: Number(recordId.value),
      submitItems: itemList.value.map(item => ({
        itemId: item.itemId,
        itemName: item.itemName,
        itemCategory: item.itemCategory,
        checkResult: item.checkResult,
        abnormalDesc: item.abnormalDesc,
        fileId: item.fileId || null,
        orderNum: item.orderNum
      }))
    })
    uni.showModal({
      title: '提交成功',
      content: '巡检结果已归档，维保档案已更新',
      showCancel: false,
      success: () => {
        uni.navigateBack()
      }
    })
  } catch (e) {
    // 错误提示已在请求层统一处理
  } finally {
    submitting.value = false
  }
}

onMounted(() => {
  const pages = getCurrentPages()
  const current = pages[pages.length - 1]
  recordId.value = current.options.recordId || ''
  if (!recordId.value) {
    uni.showToast({ title: '缺少巡检参数', icon: 'none' })
    return
  }
  loadData()
})
</script>

<style scoped>
.record-no {
  font-size: 26rpx;
  color: #6b7688;
}

.info-row {
  display: flex;
  margin-top: 16rpx;
}

.info-row .label {
  width: 150rpx;
  flex-shrink: 0;
  color: #909399;
  font-size: 26rpx;
}

.info-row .value {
  flex: 1;
  color: #303133;
  font-size: 26rpx;
}

.clock-done {
  padding: 24rpx;
  background: #e8f6f0;
  border-radius: 12rpx;
}

.clock-done text {
  display: block;
  font-size: 26rpx;
  color: #0f6e4c;
}

.clock-location {
  margin-top: 8rpx;
  font-size: 24rpx !important;
}

.tip-muted {
  display: block;
  font-size: 25rpx;
  color: #98a1b0;
  margin-bottom: 20rpx;
}

.input {
  width: 100%;
  height: 88rpx;
  background: #f5f7fa;
  border-radius: 12rpx;
  padding: 0 24rpx;
  font-size: 28rpx;
  box-sizing: border-box;
}

.item-block {
  padding: 24rpx 0;
  border-bottom: 2rpx solid #f5f7fa;
}

.item-block:last-child {
  border-bottom: none;
}

.item-name {
  font-size: 28rpx;
  font-weight: 600;
  color: #303133;
}

.item-standard {
  display: block;
  margin-top: 8rpx;
  font-size: 24rpx;
  color: #98a1b0;
}

.result-group {
  display: flex;
  margin-top: 16rpx;
}

.result-chip {
  padding: 10rpx 26rpx;
  margin-right: 16rpx;
  border-radius: 32rpx;
  background: #f5f7fa;
  font-size: 24rpx;
  color: #6b7688;
}

.result-chip--active {
  background: #0b3d91;
  color: #ffffff;
}

.item-textarea {
  width: 100%;
  height: 140rpx;
  background: #fef5e7;
  border-radius: 12rpx;
  padding: 16rpx 20rpx;
  font-size: 26rpx;
  margin-top: 16rpx;
  box-sizing: border-box;
}

.item-photo-row {
  display: flex;
  align-items: center;
  margin-top: 16rpx;
}

.item-photo {
  width: 140rpx;
  height: 140rpx;
  border-radius: 12rpx;
}

.item-photo-add {
  width: 140rpx;
  height: 140rpx;
  border: 2rpx dashed #c6ccd6;
  border-radius: 12rpx;
  display: flex;
  flex-direction: column;
  align-items: center;
  justify-content: center;
}

.item-photo-icon {
  font-size: 36rpx;
  color: #98a1b0;
  line-height: 36rpx;
}

.item-photo-text {
  margin-top: 6rpx;
  font-size: 20rpx;
  color: #98a1b0;
}

.item-photo-remove {
  margin-left: 20rpx;
}

.item-photo-remove text {
  font-size: 24rpx;
  color: #e5484d;
}

.summary-bar {
  display: flex;
  justify-content: space-around;
  padding: 20rpx;
  background: #f5f7fa;
  border-radius: 12rpx;
  font-size: 26rpx;
  color: #303133;
}

.summary-abnormal {
  color: #e5484d;
}

.summary-na {
  color: #909399;
}

.action-btn {
  margin-top: 20rpx;
}
</style>
