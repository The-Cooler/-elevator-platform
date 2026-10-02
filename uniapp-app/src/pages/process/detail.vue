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
          <text class="label">电梯</text>
          <text class="value">{{ order.elevatorCode }}（{{ order.communityName }} {{ order.buildingNo }} {{ order.unitNo }}）</text>
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

      <!-- 已提交的维修记录 -->
      <view v-if="order.repairRecord" class="card">
        <view class="card-title">维修记录</view>
        <view class="info-row">
          <text class="label">到场时间</text>
          <text class="value">{{ formatDateTime(order.repairRecord.arriveTime) || '—' }}</text>
        </view>
        <view class="info-row">
          <text class="label">到场位置</text>
          <text class="value">{{ order.repairRecord.arriveLocation || '—' }}</text>
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

      <!-- 作业操作，按当前状态展示可执行的下一步 -->
      <view class="card">
        <view class="card-title">作业操作</view>

        <!-- 已接单 -> 登记到场 -->
        <template v-if="order.orderStatus === 'accepted'">
          <text class="tip-muted">到达现场后登记到场时间与位置</text>
          <view class="field">
            <text class="field-label">到场位置</text>
            <input v-model="arriveLocation" class="input" placeholder="如：阳光家园小区1号楼1单元" />
          </view>
          <button class="btn-primary action-btn" :loading="acting" @click="handleArrive">登记到场</button>
        </template>

        <!-- 已到场 -> 填写排查记录 -->
        <template v-else-if="order.orderStatus === 'arrived'">
          <text class="tip-muted">填写排查情况后工单进入维修中</text>
          <textarea v-model="investigateNote" class="textarea" placeholder="记录排查过程与初步判断" maxlength="1000" />
          <button class="btn-primary action-btn" :loading="acting" @click="handleInvestigate">提交并进入维修中</button>
        </template>

        <!-- 维修中 -> 提交完工 -->
        <template v-else-if="order.orderStatus === 'repairing'">
          <text class="tip-muted">维修完成后提交处理说明，等待业主确认</text>
          <view class="field">
            <text class="field-label">故障原因</text>
            <picker :range="faultReasonLabels" :value="reasonIndex" @change="e => (reasonIndex = Number(e.detail.value))">
              <view class="picker-box">
                <text>{{ faultReasonLabels[reasonIndex] }}</text>
                <text class="picker-arrow">▾</text>
              </view>
            </picker>
          </view>
          <view class="field">
            <text class="field-label">处理说明</text>
            <textarea v-model="repairDesc" class="textarea" placeholder="填写维修措施与处理结果" maxlength="1000" />
          </view>
          <view class="field">
            <text class="field-label">更换配件</text>
            <input v-model="replaceParts" class="input" placeholder="如：门机皮带 1 条，无更换可留空" />
          </view>
          <button class="btn-primary action-btn" :loading="acting" @click="handleFinish">提交完工</button>
        </template>

        <!-- 其他状态 -->
        <template v-else>
          <text class="tip-muted">{{ statusTip }}</text>
        </template>
      </view>

      <!-- 上报异常 -->
      <view v-if="canReportException" class="card">
        <view class="card-title">无法现场修复</view>
        <text class="tip-muted">上报后工单转物业处理</text>
        <textarea v-model="exceptionReason" class="textarea" placeholder="说明无法修复的原因" maxlength="500" />
        <button class="btn-outline action-btn" :loading="acting" @click="handleReportException">上报异常</button>
      </view>
    </template>

    <view v-else class="empty"><text>工单不存在或无权操作</text></view>
  </view>
</template>

<script setup>
import { ref, computed, onMounted } from 'vue'
import {
  getMyProcessList,
  arriveProcess,
  investigateProcess,
  finishProcess,
  reportException
} from '../../api/order'
import { orderStatusText, orderStatusClass, FAULT_TYPE_TEXT, FAULT_REASON_TEXT, formatDateTime } from '../../utils/dict'
import { fullUrl } from '../../utils/request'

const orderId = ref('')
const order = ref(null)
const loading = ref(true)
const acting = ref(false)

const arriveLocation = ref('')
const investigateNote = ref('')
const repairDesc = ref('')
const replaceParts = ref('')
const exceptionReason = ref('')

const faultReasonKeys = ['normal_wear', 'parts_damage', 'improper_use', 'external', 'other']
const faultReasonLabels = faultReasonKeys.map(key => FAULT_REASON_TEXT[key])
const reasonIndex = ref(0)

const faultTypeText = type => FAULT_TYPE_TEXT[type] || '故障'

const statusTip = computed(() => {
  if (!order.value) return ''
  const map = {
    assigned: '请先在待接单中确认接单',
    repaired: '已提交完工，等待业主确认',
    confirmed: '业主已确认，工单已完成',
    appealed: '业主已申诉，等待物业安排返工',
    pending: '工单已回到待派单池，等待物业重新指派'
  }
  return map[order.value.orderStatus] || '当前状态无需作业操作'
})

/** 处于维修阶段时允许上报异常 */
const canReportException = computed(() => {
  if (!order.value) return false
  return ['accepted', 'arrived', 'repairing'].includes(order.value.orderStatus)
})

const previewUrl = fileId => fullUrl(`/common/file/preview/${fileId}`)

const previewEvidence = index => {
  uni.previewImage({
    urls: order.value.evidenceList.map(item => previewUrl(item.fileId)),
    current: index
  })
}

const loadDetail = async () => {
  loading.value = true
  try {
    // 从本人在办工单中定位该工单，保证只能操作指派给自己的工单
    const res = await getMyProcessList({ pageNum: 1, pageSize: 100 })
    const found = (res.rows || []).find(item => String(item.orderId) === String(orderId.value))
    order.value = found || null
    if (found) {
      arriveLocation.value = `${found.communityName || ''}${found.buildingNo || ''}${found.unitNo || ''}`
    }
  } catch (e) {
    order.value = null
  } finally {
    loading.value = false
  }
}

const handleArrive = async () => {
  acting.value = true
  try {
    await arriveProcess({ orderId: Number(orderId.value), arriveLocation: arriveLocation.value })
    uni.showToast({ title: '已登记到场', icon: 'success' })
    await loadDetail()
  } catch (e) {
    // 错误提示已在请求层统一处理
  } finally {
    acting.value = false
  }
}

const handleInvestigate = async () => {
  if (!investigateNote.value.trim()) {
    uni.showToast({ title: '请填写排查记录', icon: 'none' })
    return
  }
  acting.value = true
  try {
    await investigateProcess({ orderId: Number(orderId.value), investigateNote: investigateNote.value })
    uni.showToast({ title: '已提交', icon: 'success' })
    await loadDetail()
  } catch (e) {
    // 错误提示已在请求层统一处理
  } finally {
    acting.value = false
  }
}

const handleFinish = async () => {
  if (!repairDesc.value.trim()) {
    uni.showToast({ title: '请填写处理说明', icon: 'none' })
    return
  }
  acting.value = true
  try {
    await finishProcess({
      orderId: Number(orderId.value),
      faultReason: faultReasonKeys[reasonIndex.value],
      repairDesc: repairDesc.value,
      replaceParts: replaceParts.value
    })
    uni.showToast({ title: '已提交完工', icon: 'success' })
    await loadDetail()
  } catch (e) {
    // 错误提示已在请求层统一处理
  } finally {
    acting.value = false
  }
}

const handleReportException = async () => {
  if (!exceptionReason.value.trim()) {
    uni.showToast({ title: '请填写异常说明', icon: 'none' })
    return
  }
  acting.value = true
  try {
    await reportException({ orderId: Number(orderId.value), remark: exceptionReason.value })
    uni.showToast({ title: '已上报，工单转物业处理', icon: 'success' })
    exceptionReason.value = ''
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
  font-size: 25rpx;
  color: #98a1b0;
  margin-bottom: 20rpx;
}

.input,
.picker-box {
  width: 100%;
  height: 88rpx;
  background: #f5f7fa;
  border-radius: 12rpx;
  padding: 0 24rpx;
  font-size: 28rpx;
  color: #303133;
  box-sizing: border-box;
}

.picker-box {
  display: flex;
  align-items: center;
  justify-content: space-between;
}

.picker-arrow {
  color: #98a1b0;
}

.textarea {
  width: 100%;
  height: 180rpx;
  background: #f5f7fa;
  border-radius: 12rpx;
  padding: 20rpx 24rpx;
  font-size: 28rpx;
  margin-bottom: 24rpx;
  box-sizing: border-box;
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

.action-btn {
  margin-top: 8rpx;
}
</style>
