<template>
  <view class="page-wrap">
    <view class="filter-bar">
      <view
        v-for="item in statusTabs"
        :key="item.value"
        class="filter-item"
        :class="{ 'filter-item--active': query.recordStatus === item.value }"
        @click="onFilter(item.value)"
      >
        <text>{{ item.label }}</text>
      </view>
    </view>

    <view v-if="loading" class="empty"><text>加载中…</text></view>
    <view v-else-if="!recordList.length" class="empty"><text>当前没有巡检任务</text></view>

    <view
      v-for="item in recordList"
      :key="item.recordId"
      class="card record-item"
      @click="goExecute(item)"
    >
      <view class="row-between">
        <text class="record-no">{{ item.recordNo }}</text>
        <text class="tag" :class="RECORD_STATUS_CLASS[item.recordStatus] || 'tag-muted'">
          {{ RECORD_STATUS_TEXT[item.recordStatus] || item.recordStatus }}
        </text>
      </view>
      <view class="record-title">
        <text>{{ item.elevatorCode || '—' }}｜{{ maintainTypeText(item.maintainType) }}</text>
      </view>
      <view class="record-meta">
        <text class="meta-text">{{ item.communityName }} {{ item.buildingNo }} {{ item.unitNo }}</text>
      </view>
      <view class="row-between record-meta">
        <text class="meta-text">计划日期</text>
        <text class="meta-text">{{ item.planDate || '—' }}</text>
      </view>
      <view v-if="item.clockInTime" class="row-between record-meta">
        <text class="meta-text">打卡时间</text>
        <text class="meta-text">{{ formatDateTime(item.clockInTime) }}</text>
      </view>
      <view v-if="item.recordStatus === 'finished'" class="row-between record-meta">
        <text class="meta-text">检查结果</text>
        <text class="meta-text">正常 {{ item.normalCount }}｜异常 {{ item.abnormalCount }}</text>
      </view>
      <view v-if="item.recordStatus !== 'finished'" class="action-row">
        <text class="action-tip">点击执行巡检 →</text>
      </view>
    </view>
  </view>
</template>

<script setup>
import { ref, reactive, onMounted } from 'vue'
import { onShow } from '@dcloudio/uni-app'
import { listMyInspection } from '../../api/maintain'
import { MAINTAIN_TYPE_TEXT, RECORD_STATUS_TEXT, RECORD_STATUS_CLASS, formatDateTime } from '../../utils/dict'

const loading = ref(true)
const recordList = ref([])

const query = reactive({
  pageNum: 1,
  pageSize: 30,
  recordStatus: ''
})

const statusTabs = [
  { label: '全部', value: '' },
  { label: '待执行', value: 'pending' },
  { label: '已完成', value: 'finished' },
  { label: '已超期', value: 'overdue' }
]

const maintainTypeText = type => MAINTAIN_TYPE_TEXT[type] || type || ''

const loadList = async () => {
  loading.value = true
  try {
    const res = await listMyInspection({
      pageNum: query.pageNum,
      pageSize: query.pageSize,
      recordStatus: query.recordStatus || undefined
    })
    recordList.value = res.rows || []
  } catch (e) {
    recordList.value = []
  } finally {
    loading.value = false
  }
}

const onFilter = value => {
  query.recordStatus = value
  query.pageNum = 1
  loadList()
}

const goExecute = item => {
  uni.navigateTo({ url: `/pages/inspection/execute?recordId=${item.recordId}` })
}

onMounted(loadList)
onShow(() => {
  if (recordList.value.length) {
    loadList()
  }
})
</script>

<style scoped>
.filter-bar {
  display: flex;
  background: #ffffff;
  border-radius: 16rpx;
  padding: 12rpx;
  margin-bottom: 24rpx;
}

.filter-item {
  flex: 1;
  text-align: center;
  padding: 16rpx 0;
  border-radius: 12rpx;
  font-size: 26rpx;
  color: #6b7688;
}

.filter-item--active {
  background: #0b3d91;
  color: #ffffff;
}

.record-item {
  padding: 28rpx;
}

.record-no {
  font-size: 26rpx;
  color: #6b7688;
}

.record-title {
  margin: 20rpx 0 12rpx;
  font-size: 30rpx;
  color: #303133;
}

.record-meta {
  margin-top: 12rpx;
}

.meta-text {
  font-size: 25rpx;
  color: #909399;
}

.action-row {
  margin-top: 20rpx;
  padding-top: 20rpx;
  border-top: 2rpx solid #f5f7fa;
  text-align: right;
}

.action-tip {
  font-size: 26rpx;
  color: #0b3d91;
}
</style>
