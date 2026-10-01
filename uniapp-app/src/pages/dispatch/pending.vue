<template>
  <view class="page-wrap">
    <view v-if="loading" class="empty"><text>加载中…</text></view>
    <view v-else-if="!orderList.length" class="empty"><text>当前没有待派单工单</text></view>

    <view
      v-for="item in orderList"
      :key="item.orderId"
      class="card order-item"
      @click="goAssign(item)"
    >
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
        <text class="meta-text">报修时间</text>
        <text class="meta-text">{{ formatDateTime(item.reportTime) }}</text>
      </view>
      <view class="action-row">
        <text class="action-tip">点击进入派单 →</text>
      </view>
    </view>
  </view>
</template>

<script setup>
import { ref, onMounted } from 'vue'
import { onShow } from '@dcloudio/uni-app'
import { getPendingList } from '../../api/order'
import { FAULT_TYPE_TEXT, formatDateTime } from '../../utils/dict'

const loading = ref(true)
const orderList = ref([])

const faultTypeText = type => FAULT_TYPE_TEXT[type] || '故障'

const loadList = async () => {
  loading.value = true
  try {
    const res = await getPendingList({ pageNum: 1, pageSize: 30 })
    orderList.value = res.rows || []
  } catch (e) {
    orderList.value = []
  } finally {
    loading.value = false
  }
}

const goAssign = item => {
  uni.navigateTo({ url: `/pages/dispatch/assign?orderId=${item.orderId}` })
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
