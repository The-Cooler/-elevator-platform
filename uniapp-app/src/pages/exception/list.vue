<template>
  <view class="page-wrap">
    <!-- 异常类型统计 -->
    <view class="stat-grid">
      <view
        v-for="item in statistics"
        :key="item.exceptionType"
        class="stat-item"
        :class="{ 'stat-item--active': query.exceptionType === item.exceptionType }"
        @click="onTypeFilter(item.exceptionType)"
      >
        <text class="stat-value" :class="{ 'stat-value--warn': item.count > 0 }">{{ item.count }}</text>
        <text class="stat-label">{{ item.exceptionTypeName }}</text>
      </view>
    </view>

    <view v-if="loading" class="empty"><text>加载中…</text></view>
    <view v-else-if="!exceptionList.length" class="empty"><text>暂无异常工单，各工单均在时限内流转</text></view>

    <view v-for="item in exceptionList" :key="item.orderId + item.exceptionType" class="card exception-item">
      <view class="row-between">
        <text class="exception-type">{{ item.exceptionTypeName }}</text>
        <text class="timeout-text">已超时 {{ formatTimeout(item.timeoutMinutes) }}</text>
      </view>
      <view class="row-between exception-meta">
        <text class="order-no">{{ item.orderNo }}</text>
        <text class="tag" :class="item.faultLevel === '0' ? 'tag-danger' : 'tag-pending'">
          {{ item.faultLevel === '0' ? '紧急' : '一般' }}
        </text>
      </view>
      <view class="exception-title">
        <text>{{ item.faultDesc }}</text>
      </view>
      <view class="exception-meta">
        <text class="meta-text">{{ item.elevatorCode }}｜{{ item.communityName }} {{ item.buildingNo }} {{ item.unitNo }}</text>
      </view>
      <view class="row-between exception-meta">
        <text class="meta-text">当前状态：{{ item.orderStatusName }}</text>
        <text class="meta-text">维修员：{{ item.assigneeName || '未派单' }}</text>
      </view>

      <view class="btn-row">
        <button class="btn-outline btn-third" @click="handleReassign(item)">改派</button>
        <button class="btn-outline btn-third" @click="handleReject(item)">驳回</button>
        <button class="btn-outline btn-third" @click="handleEscalate(item)">升级</button>
      </view>
    </view>
  </view>
</template>

<script setup>
import { ref, reactive, onMounted } from 'vue'
import {
  getExceptionList,
  getExceptionStatistics,
  reassignException,
  rejectException,
  escalateException,
  listWorkers
} from '../../api/order'

const loading = ref(true)
const exceptionList = ref([])
const statistics = ref([])
const workerList = ref([])

const query = reactive({
  exceptionType: undefined
})

/** 超时时长格式化 */
const formatTimeout = minutes => {
  if (minutes === null || minutes === undefined) return '—'
  if (minutes < 60) return `${minutes} 分钟`
  if (minutes < 1440) return `${Math.floor(minutes / 60)} 小时`
  return `${Math.floor(minutes / 1440)} 天`
}

const loadList = async () => {
  loading.value = true
  try {
    const res = await getExceptionList({ exceptionType: query.exceptionType })
    exceptionList.value = res.data || []
  } catch (e) {
    exceptionList.value = []
  } finally {
    loading.value = false
  }
}

const loadStatistics = async () => {
  try {
    const res = await getExceptionStatistics({})
    statistics.value = res.data || []
  } catch (e) {
    statistics.value = []
  }
}

const loadWorkers = async () => {
  try {
    const res = await listWorkers({})
    workerList.value = res.data || []
  } catch (e) {
    workerList.value = []
  }
}

/** 点击统计卡片按异常类型筛选 */
const onTypeFilter = type => {
  query.exceptionType = query.exceptionType === type ? undefined : type
  loadList()
}

/** 重新指派给其他维修员 */
const handleReassign = item => {
  if (!workerList.value.length) {
    uni.showToast({ title: '暂无可选维修员', icon: 'none' })
    return
  }
  const candidates = workerList.value.filter(w => w.workerId !== item.assigneeId)
  if (!candidates.length) {
    uni.showToast({ title: '暂无可改派的维修员', icon: 'none' })
    return
  }
  const labels = candidates.map(w => `${w.workerName}（在工 ${w.currentLoad || 0} 单）`)
  uni.showActionSheet({
    itemList: labels,
    success: async res => {
      const target = candidates[res.tapIndex]
      try {
        await reassignException({ orderId: item.orderId, assigneeId: target.workerId })
        uni.showToast({ title: '已改派', icon: 'success' })
        loadList()
        loadStatistics()
      } catch (e) {
        // 错误提示已在请求层统一处理
      }
    }
  })
}

/** 驳回重审 */
const handleReject = item => {
  uni.showModal({
    title: '驳回重审',
    editable: true,
    placeholderText: '请输入驳回原因',
    success: async res => {
      if (!res.confirm) return
      const reason = (res.content || '').trim()
      if (!reason) {
        uni.showToast({ title: '驳回原因不能为空', icon: 'none' })
        return
      }
      try {
        await rejectException({ orderId: item.orderId, rejectReason: reason })
        uni.showToast({ title: '已驳回', icon: 'success' })
        loadList()
        loadStatistics()
      } catch (e) {
        // 错误提示已在请求层统一处理
      }
    }
  })
}

/** 升级为紧急处理 */
const handleEscalate = item => {
  uni.showModal({
    title: '升级处理',
    editable: true,
    placeholderText: '请输入升级说明',
    success: async res => {
      if (!res.confirm) return
      try {
        await escalateException({ orderId: item.orderId, remark: res.content || '' })
        uni.showToast({ title: '已升级为紧急', icon: 'success' })
        loadList()
      } catch (e) {
        // 错误提示已在请求层统一处理
      }
    }
  })
}

onMounted(() => {
  loadList()
  loadStatistics()
  loadWorkers()
})
</script>

<style scoped>
.stat-grid {
  display: flex;
  margin-bottom: 24rpx;
}

.stat-item {
  flex: 1;
  background: #ffffff;
  border-radius: 16rpx;
  padding: 24rpx 0;
  margin-right: 16rpx;
  display: flex;
  flex-direction: column;
  align-items: center;
}

.stat-item:last-child {
  margin-right: 0;
}

.stat-item--active {
  background: #ebf0fa;
}

.stat-value {
  font-size: 38rpx;
  font-weight: 700;
  color: #303133;
}

.stat-value--warn {
  color: #e5484d;
}

.stat-label {
  margin-top: 8rpx;
  font-size: 22rpx;
  color: #909399;
}

.exception-item {
  padding: 28rpx;
}

.exception-type {
  font-size: 28rpx;
  font-weight: 600;
  color: #e5484d;
}

.timeout-text {
  font-size: 24rpx;
  color: #d98d12;
}

.order-no {
  font-size: 25rpx;
  color: #6b7688;
}

.exception-title {
  margin: 16rpx 0;
  font-size: 29rpx;
  color: #303133;
  line-height: 1.5;
}

.exception-meta {
  margin-top: 12rpx;
}

.meta-text {
  font-size: 25rpx;
  color: #909399;
}

.btn-row {
  display: flex;
  margin-top: 24rpx;
}

.btn-third {
  flex: 1;
  margin: 0 8rpx;
  font-size: 26rpx;
  line-height: 68rpx;
}
</style>
