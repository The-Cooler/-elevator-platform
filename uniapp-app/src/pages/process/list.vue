<template>
  <view class="page-wrap">
    <view v-if="loading" class="empty"><text>加载中…</text></view>
    <view v-else-if="!orderList.length" class="empty"><text>当前没有在办工单</text></view>

    <view
      v-for="item in orderList"
      :key="item.orderId"
      class="card order-item"
      @click="goDetail(item.orderId)"
    >
      <view class="row-between">
        <text class="order-no">{{ item.orderNo }}</text>
        <text class="tag" :class="orderStatusClass(item.orderStatus)">
          {{ orderStatusText(item.orderStatus) }}
        </text>
      </view>
      <view class="order-title">
        <text>{{ faultTypeText(item.faultType) }}：{{ item.faultDesc }}</text>
      </view>
      <view class="row-between order-meta">
        <text class="meta-text">{{ item.elevatorCode || '—' }}</text>
        <text class="tag" :class="item.faultLevel === '0' ? 'tag-danger' : 'tag-pending'">
          {{ item.faultLevel === '0' ? '紧急' : '一般' }}
        </text>
      </view>
      <view class="order-meta">
        <text class="meta-text">{{ item.communityName }} {{ item.buildingNo }} {{ item.unitNo }}</text>
      </view>
      <view class="action-row">
        <text class="action-tip">点击进入维修过程 →</text>
      </view>
    </view>
  </view>
</template>

<script setup>
import { ref, onMounted } from 'vue'
import { onShow } from '@dcloudio/uni-app'
import { getMyProcessList } from '../../api/order'
import { orderStatusText, orderStatusClass, FAULT_TYPE_TEXT } from '../../utils/dict'

const loading = ref(true)
const orderList = ref([])

const faultTypeText = type => FAULT_TYPE_TEXT[type] || '故障'

const loadList = async () => {
  loading.value = true
  try {
    const res = await getMyProcessList({ pageNum: 1, pageSize: 30 })
    orderList.value = res.rows || []
  } catch (e) {
    orderList.value = []
  } finally {
    loading.value = false
  }
}

const goDetail = orderId => {
  uni.navigateTo({ url: `/pages/process/detail?orderId=${orderId}` })
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
