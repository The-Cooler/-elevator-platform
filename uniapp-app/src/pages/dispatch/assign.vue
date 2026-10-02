<template>
  <view class="page-wrap">
    <!-- 工单概要 -->
    <view class="card" v-if="order">
      <view class="card-title">工单 {{ order.orderNo }}</view>
      <view class="info-row">
        <text class="label">电梯</text>
        <text class="value">{{ order.elevatorCode }}（{{ order.communityName }} {{ order.buildingNo }} {{ order.unitNo }}）</text>
      </view>
      <view class="info-row">
        <text class="label">故障现象</text>
        <text class="value">{{ order.faultDesc }}</text>
      </view>
      <view class="info-row">
        <text class="label">故障等级</text>
        <text class="tag" :class="order.faultLevel === '0' ? 'tag-danger' : 'tag-pending'">
          {{ order.faultLevel === '0' ? '紧急' : '一般' }}
        </text>
      </view>
      <view class="info-row">
        <text class="label">报修人</text>
        <text class="value">{{ order.reporterName || '—' }} {{ order.reporterPhoneNo || '' }}</text>
      </view>
      <view v-if="order.evidenceList && order.evidenceList.length" class="info-row">
        <text class="label">现场证据</text>
        <view class="photo-grid">
          <image
            v-for="(item, index) in order.evidenceList"
            :key="item.evidenceId"
            class="photo"
            :src="previewUrl(item.fileId)"
            mode="aspectFill"
            @click="previewEvidence(index)"
          />
        </view>
      </view>
    </view>

    <!-- 推荐维修员 -->
    <view class="card">
      <view class="card-title">推荐维修员</view>
      <text class="tip-muted">按负责区域与技能匹配排序，可手动改选</text>

      <view v-if="workerLoading" class="empty"><text>加载中…</text></view>
      <view v-else-if="!workerList.length" class="empty"><text>暂无可用维修员</text></view>

      <view
        v-for="item in workerList"
        :key="item.workerId"
        class="worker-item"
        :class="{ 'worker-item--active': selectedWorkerId === item.workerId }"
        @click="selectedWorkerId = item.workerId"
      >
        <view class="worker-main">
          <view class="row">
            <text class="worker-name">{{ item.workerName }}</text>
            <text v-if="item.skillMatched" class="tag tag-done">技能匹配</text>
          </view>
          <text class="worker-desc">{{ item.communityName || '未分配小区' }}｜{{ item.skillTags || '无技能标签' }}</text>
          <text class="worker-desc">在手工单 {{ item.currentLoad || 0 }} 单｜匹配度 {{ item.matchScore || 0 }}</text>
        </view>
        <text class="worker-check" v-if="selectedWorkerId === item.workerId">✓</text>
      </view>
    </view>

    <view class="card">
      <view class="card-title">派单备注</view>
      <textarea v-model="remark" class="textarea" placeholder="选填，如：该电梯属老旧设备，请携带常用配件" maxlength="200" />
    </view>

    <button
      class="btn-primary submit-btn"
      :loading="submitting"
      :disabled="submitting || !selectedWorkerId"
      @click="handleAssign"
    >
      {{ submitting ? '派单中…' : '确认派单' }}
    </button>
    <button class="btn-outline reject-btn" :disabled="submitting" @click="handleReject">驳回报修单</button>
  </view>
</template>

<script setup>
import { ref, onMounted } from 'vue'
import { recommendWorker, assignOrder } from '../../api/order'
import { getOrderDetail } from '../../api/repair'
import { httpPut, fullUrl } from '../../utils/request'

const orderId = ref('')
const order = ref(null)
const workerList = ref([])
const workerLoading = ref(true)
const selectedWorkerId = ref(null)
const remark = ref('')
const submitting = ref(false)

const previewUrl = fileId => fullUrl(`/common/file/preview/${fileId}`)

const previewEvidence = index => {
  uni.previewImage({
    urls: order.value.evidenceList.map(item => previewUrl(item.fileId)),
    current: index
  })
}

const loadData = async () => {
  try {
    const res = await getOrderDetail(orderId.value)
    order.value = res.data || null
  } catch (e) {
    order.value = null
  }

  workerLoading.value = true
  try {
    const res = await recommendWorker(orderId.value)
    workerList.value = res.data || []
    if (workerList.value.length) {
      selectedWorkerId.value = workerList.value[0].workerId
    }
  } catch (e) {
    workerList.value = []
  } finally {
    workerLoading.value = false
  }
}

const handleAssign = async () => {
  if (!selectedWorkerId.value) {
    uni.showToast({ title: '请选择维修员', icon: 'none' })
    return
  }
  submitting.value = true
  try {
    await assignOrder({
      orderId: Number(orderId.value),
      assigneeId: selectedWorkerId.value,
      remark: remark.value
    })
    uni.showToast({ title: '派单成功', icon: 'success' })
    setTimeout(() => {
      uni.navigateBack()
    }, 800)
  } catch (e) {
    // 错误提示已在请求层统一处理
  } finally {
    submitting.value = false
  }
}

/** 驳回报修单，工单回到业主处待补充 */
const handleReject = () => {
  uni.showModal({
    title: '驳回报修单',
    editable: true,
    placeholderText: '请输入驳回原因',
    success: async res => {
      if (!res.confirm) return
      const reason = (res.content || '').trim()
      if (!reason) {
        uni.showToast({ title: '驳回原因不能为空', icon: 'none' })
        return
      }
      submitting.value = true
      try {
        await httpPut('/repair/order/reject', { orderId: Number(orderId.value), rejectReason: reason })
        uni.showToast({ title: '已驳回', icon: 'success' })
        setTimeout(() => {
          uni.navigateBack()
        }, 800)
      } catch (e) {
        // 错误提示已在请求层统一处理
      } finally {
        submitting.value = false
      }
    }
  })
}

onMounted(() => {
  const pages = getCurrentPages()
  const current = pages[pages.length - 1]
  orderId.value = current.options.orderId || ''
  if (!orderId.value) {
    uni.showToast({ title: '缺少工单参数', icon: 'none' })
    return
  }
  loadData()
})
</script>

<style scoped>
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

.tip-muted {
  display: block;
  font-size: 24rpx;
  color: #98a1b0;
  margin-bottom: 20rpx;
}

.worker-item {
  display: flex;
  align-items: center;
  justify-content: space-between;
  padding: 24rpx;
  border: 2rpx solid #ebeef5;
  border-radius: 12rpx;
  margin-bottom: 16rpx;
}

.worker-item--active {
  border-color: #0b3d91;
  background: #ebf0fa;
}

.worker-main {
  flex: 1;
  min-width: 0;
}

.worker-name {
  font-size: 30rpx;
  font-weight: 600;
  color: #303133;
  margin-right: 12rpx;
}

.worker-desc {
  display: block;
  margin-top: 8rpx;
  font-size: 24rpx;
  color: #909399;
}

.worker-check {
  color: #0b3d91;
  font-size: 36rpx;
  font-weight: 700;
  margin-left: 20rpx;
}

.photo-grid {
  display: flex;
  flex-wrap: wrap;
  flex: 1;
}

.photo {
  width: 150rpx;
  height: 150rpx;
  border-radius: 12rpx;
  margin: 0 16rpx 16rpx 0;
}

.textarea {
  width: 100%;
  height: 160rpx;
  background: #f5f7fa;
  border-radius: 12rpx;
  padding: 20rpx 24rpx;
  font-size: 28rpx;
  box-sizing: border-box;
}

.submit-btn {
  margin-top: 20rpx;
}

.reject-btn {
  margin: 20rpx 0 40rpx;
}
</style>
