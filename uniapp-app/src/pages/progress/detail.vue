<template>
  <view class="page-wrap">
    <view v-if="loading" class="empty"><text>加载中…</text></view>

    <template v-else-if="order">
      <!-- 工单概要 -->
      <view class="card">
        <view class="row-between">
          <text class="order-no">{{ order.orderNo }}</text>
          <text class="tag" :class="orderStatusClass(order.orderStatus)">
            {{ orderStatusText(order.orderStatus) }}
          </text>
        </view>
        <view class="order-title">
          <text>{{ faultTypeText(order.faultType) }}：{{ order.faultDesc }}</text>
        </view>
        <view class="info-row">
          <text class="label">故障电梯</text>
          <text class="value">{{ order.elevatorCode || '—' }}</text>
        </view>
        <view class="info-row">
          <text class="label">电梯位置</text>
          <text class="value">{{ order.communityName }} {{ order.buildingNo }} {{ order.unitNo }}</text>
        </view>
        <view class="info-row">
          <text class="label">报修时间</text>
          <text class="value">{{ formatDateTime(order.reportTime) }}</text>
        </view>
        <view class="info-row">
          <text class="label">维修员</text>
          <text class="value">{{ order.assigneeName || '待派单' }}</text>
        </view>
        <view v-if="order.rejectReason" class="reject-box">
          <text>驳回原因：{{ order.rejectReason }}</text>
        </view>
      </view>

      <!-- 处理进度时间轴 -->
      <view class="card">
        <view class="card-title">处理进度</view>
        <view v-if="!order.statusLogs || !order.statusLogs.length" class="empty"><text>暂无流转记录</text></view>
        <view v-else class="timeline">
          <view v-for="(item, index) in order.statusLogs" :key="item.logId" class="timeline-item">
            <view class="timeline-left">
              <view class="timeline-dot" :class="{ 'timeline-dot--active': index === order.statusLogs.length - 1 }" />
              <view v-if="index !== order.statusLogs.length - 1" class="timeline-line" />
            </view>
            <view class="timeline-body">
              <view class="row-between">
                <text class="timeline-status">{{ orderStatusText(item.toStatus) }}</text>
                <text class="timeline-time">{{ formatDateTime(item.operateTime) }}</text>
              </view>
              <text class="timeline-operator">操作人：{{ item.operatorName || '系统' }}</text>
              <text v-if="item.remark" class="timeline-remark">{{ item.remark }}</text>
            </view>
          </view>
        </view>
      </view>

      <!-- 维修记录 -->
      <view v-if="order.repairRecord" class="card">
        <view class="card-title">维修记录</view>
        <view class="info-row">
          <text class="label">维修员</text>
          <text class="value">{{ order.repairRecord.workerName || '—' }}</text>
        </view>
        <view class="info-row">
          <text class="label">到场时间</text>
          <text class="value">{{ formatDateTime(order.repairRecord.arriveTime) || '—' }}</text>
        </view>
        <view class="info-row">
          <text class="label">排查记录</text>
          <text class="value">{{ order.repairRecord.investigateNote || '—' }}</text>
        </view>
        <view class="info-row">
          <text class="label">处理说明</text>
          <text class="value">{{ order.repairRecord.repairDesc || '—' }}</text>
        </view>
        <view class="info-row">
          <text class="label">更换配件</text>
          <text class="value">{{ order.repairRecord.replaceParts || '无' }}</text>
        </view>
      </view>

      <!-- 现场证据 -->
      <view class="card">
        <view class="card-title">现场证据</view>
        <view v-if="!order.evidenceList || !order.evidenceList.length" class="empty"><text>本次报修未上传现场证据</text></view>
        <view v-else class="photo-grid">
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

      <!-- 业主确认与申诉 -->
      <view v-if="order.orderStatus === 'repaired'" class="card">
        <view class="card-title">确认维修结果</view>
        <text class="tip-muted">请确认故障是否已消除。确认后工单闭环；若仍有问题可提交申诉</text>
        <button class="btn-primary action-btn" :loading="acting" :disabled="acting" @click="handleConfirm">
          确认故障已消除
        </button>
        <button class="btn-outline action-btn" :disabled="acting" @click="showAppeal = true">
          仍有问题，提交申诉
        </button>
      </view>

      <view v-else-if="order.orderStatus === 'appealed'" class="card">
        <view class="tip-warn-box">
          <text>您已提交申诉，物业将重新安排处理，请耐心等待</text>
        </view>
      </view>
    </template>

    <view v-else class="empty"><text>工单不存在或无权查看</text></view>

    <!-- 申诉弹窗 -->
    <view v-if="showAppeal" class="modal-mask" @click.self="showAppeal = false">
      <view class="modal-body">
        <view class="card-title">提交申诉</view>
        <textarea v-model="appealReason" class="textarea" placeholder="请说明故障未解决的具体情况" maxlength="500" />
        <view class="modal-footer">
          <button class="btn-outline modal-btn" @click="showAppeal = false">取消</button>
          <button class="btn-primary modal-btn" :loading="acting" @click="handleAppeal">提交</button>
        </view>
      </view>
    </view>
  </view>
</template>

<script setup>
import { ref, onMounted } from 'vue'
import { getOrderDetail, confirmOrder, appealOrder } from '../../api/repair'
import { orderStatusText, orderStatusClass, FAULT_TYPE_TEXT, formatDateTime } from '../../utils/dict'

const orderId = ref('')
const order = ref(null)
const loading = ref(true)
const acting = ref(false)
const showAppeal = ref(false)
const appealReason = ref('')

const faultTypeText = type => FAULT_TYPE_TEXT[type] || '故障'

/** 文件预览地址 */
const previewUrl = fileId => {
  const base = import.meta.env.VITE_APP_BASE_API || '/dev-api'
  return `${base}/common/file/preview/${fileId}`
}

const previewEvidence = index => {
  uni.previewImage({
    urls: order.value.evidenceList.map(item => previewUrl(item.fileId)),
    current: index
  })
}

const loadDetail = async () => {
  loading.value = true
  try {
    const res = await getOrderDetail(orderId.value)
    order.value = res.data || null
  } catch (e) {
    order.value = null
  } finally {
    loading.value = false
  }
}

/** 业主确认故障消除 */
const handleConfirm = async () => {
  acting.value = true
  try {
    await confirmOrder(orderId.value)
    uni.showToast({ title: '已确认，工单完成', icon: 'success' })
    await loadDetail()
  } catch (e) {
    // 错误提示已在请求层统一处理
  } finally {
    acting.value = false
  }
}

/** 提交申诉 */
const handleAppeal = async () => {
  if (!appealReason.value.trim()) {
    uni.showToast({ title: '请填写申诉说明', icon: 'none' })
    return
  }
  acting.value = true
  try {
    await appealOrder(orderId.value, appealReason.value.trim())
    uni.showToast({ title: '申诉已提交', icon: 'success' })
    showAppeal.value = false
    appealReason.value = ''
    await loadDetail()
  } catch (e) {
    // 错误提示已在请求层统一处理
  } finally {
    acting.value = false
  }
}

onMounted(() => {
  const pages = getCurrentPages()
  const current = pages[pages.length - 1]
  orderId.value = current.options.orderId || ''
  if (!orderId.value) {
    uni.showToast({ title: '缺少工单参数', icon: 'none' })
    return
  }
  loadDetail()
})
</script>

<style scoped>
.order-no {
  font-size: 26rpx;
  color: #6b7688;
}

.order-title {
  margin: 20rpx 0;
  font-size: 30rpx;
  color: #303133;
  line-height: 1.5;
}

.info-row {
  display: flex;
  margin-top: 16rpx;
}

.info-row .label {
  width: 160rpx;
  flex-shrink: 0;
}

.info-row .value {
  flex: 1;
}

.reject-box {
  margin-top: 20rpx;
  padding: 20rpx;
  background: #fdecec;
  border-radius: 12rpx;
  font-size: 26rpx;
  color: #a62e32;
}

.timeline-item {
  display: flex;
}

.timeline-left {
  width: 40rpx;
  display: flex;
  flex-direction: column;
  align-items: center;
}

.timeline-dot {
  width: 20rpx;
  height: 20rpx;
  border-radius: 10rpx;
  background: #c6ccd6;
  margin-top: 8rpx;
}

.timeline-dot--active {
  background: #0b3d91;
  width: 26rpx;
  height: 26rpx;
  border-radius: 13rpx;
}

.timeline-line {
  flex: 1;
  width: 2rpx;
  background: #dfe3ea;
  margin: 6rpx 0;
}

.timeline-body {
  flex: 1;
  padding-bottom: 36rpx;
}

.timeline-status {
  font-size: 28rpx;
  font-weight: 600;
  color: #303133;
}

.timeline-time {
  font-size: 24rpx;
  color: #98a1b0;
}

.timeline-operator {
  display: block;
  margin-top: 8rpx;
  font-size: 25rpx;
  color: #909399;
}

.timeline-remark {
  display: block;
  margin-top: 6rpx;
  font-size: 25rpx;
  color: #6b7688;
}

.photo-grid {
  display: flex;
  flex-wrap: wrap;
}

.photo {
  width: 200rpx;
  height: 200rpx;
  border-radius: 12rpx;
  margin: 0 20rpx 20rpx 0;
}

.tip-muted {
  display: block;
  font-size: 25rpx;
  color: #98a1b0;
  margin-bottom: 24rpx;
}

.tip-warn-box {
  padding: 24rpx;
  background: #fef5e7;
  border-radius: 12rpx;
  font-size: 26rpx;
  color: #b3730d;
}

.action-btn {
  margin-top: 20rpx;
}

.modal-mask {
  position: fixed;
  top: 0;
  left: 0;
  right: 0;
  bottom: 0;
  background: rgba(0, 0, 0, 0.5);
  display: flex;
  align-items: center;
  justify-content: center;
  z-index: 999;
}

.modal-body {
  width: 620rpx;
  background: #ffffff;
  border-radius: 20rpx;
  padding: 40rpx;
}

.textarea {
  width: 100%;
  height: 200rpx;
  background: #f5f7fa;
  border-radius: 12rpx;
  padding: 20rpx 24rpx;
  font-size: 28rpx;
  margin: 24rpx 0;
  box-sizing: border-box;
}

.modal-footer {
  display: flex;
}

.modal-btn {
  flex: 1;
  margin: 0 10rpx;
}
</style>
