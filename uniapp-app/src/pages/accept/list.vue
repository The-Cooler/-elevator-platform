<template>
  <view class="page-wrap">
    <view v-if="loading" class="empty"><text>加载中…</text></view>
    <view v-else-if="!orderList.length" class="empty"><text>当前没有待接单工单</text></view>

    <view v-for="item in orderList" :key="item.orderId" class="card order-item">
      <view class="row-between">
        <text class="order-no">{{ item.orderNo }}</text>
        <text class="tag" :class="item.faultLevel === '0' ? 'tag-danger' : 'tag-pending'">
          {{ item.faultLevel === '0' ? '紧急' : '一般' }}
        </text>
      </view>
      <view class="order-title">
        <text>{{ faultTypeText(item.faultType) }}：{{ item.faultDesc }}</text>
      </view>
      <view class="row-between order-meta">
        <text class="meta-text">{{ item.elevatorCode || '—' }}</text>
        <text class="meta-text">{{ item.reporterName || '' }}</text>
      </view>
      <view class="order-meta">
        <text class="meta-text">{{ item.communityName }} {{ item.buildingNo }} {{ item.unitNo }}</text>
      </view>
      <view class="row-between order-meta">
        <text class="meta-text">派单时间</text>
        <text class="meta-text">{{ formatDateTime(item.assignTime) }}</text>
      </view>

      <view class="btn-row">
        <button class="btn-outline btn-half" @click="handleRefuse(item)">拒 单</button>
        <button class="btn-primary btn-half" @click="handleAccept(item)">接 单</button>
      </view>
    </view>
  </view>
</template>

<script setup>
import { ref, onMounted } from 'vue'
import { onShow } from '@dcloudio/uni-app'
import { getMyAcceptList, confirmAccept, refuseAccept } from '../../api/order'
import { FAULT_TYPE_TEXT, formatDateTime } from '../../utils/dict'

const loading = ref(true)
const orderList = ref([])

const faultTypeText = type => FAULT_TYPE_TEXT[type] || '故障'

const loadList = async () => {
  loading.value = true
  try {
    const res = await getMyAcceptList({ pageNum: 1, pageSize: 30 })
    orderList.value = res.rows || []
  } catch (e) {
    orderList.value = []
  } finally {
    loading.value = false
  }
}

/** 确认接单，选择预计到场时间 */
const handleAccept = item => {
  const options = ['15 分钟', '30 分钟', '1 小时', '2 小时']
  const minutes = [15, 30, 60, 120]
  uni.showActionSheet({
    itemList: options,
    success: async res => {
      try {
        await confirmAccept({
          orderId: item.orderId,
          arriveMinutes: minutes[res.tapIndex]
        })
        uni.showToast({ title: '接单成功', icon: 'success' })
        loadList()
      } catch (e) {
        // 错误提示已在请求层统一处理
      }
    }
  })
}

/** 拒绝接单，工单回到待派单池 */
const handleRefuse = item => {
  uni.showModal({
    title: '拒绝接单',
    editable: true,
    placeholderText: '请输入拒单原因',
    success: async res => {
      if (!res.confirm) return
      const reason = (res.content || '').trim()
      if (!reason) {
        uni.showToast({ title: '拒单原因不能为空', icon: 'none' })
        return
      }
      try {
        await refuseAccept({ orderId: item.orderId, remark: reason })
        uni.showToast({ title: '已拒单', icon: 'success' })
        loadList()
      } catch (e) {
        // 错误提示已在请求层统一处理
      }
    }
  })
}

onMounted(loadList)
onShow(() => {
  if (orderList.value.length) {
    loadList()
  }
})
</script>

<style scoped>
.order-item {
  padding: 28rpx;
}

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

.order-meta {
  margin-top: 12rpx;
}

.meta-text {
  font-size: 25rpx;
  color: #909399;
}

.btn-row {
  display: flex;
  margin-top: 28rpx;
}

.btn-half {
  flex: 1;
  margin: 0 10rpx;
  font-size: 28rpx;
  line-height: 76rpx;
}
</style>
