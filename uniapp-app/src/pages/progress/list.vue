<template>
  <view class="page-wrap">
    <!-- 状态筛选 -->
    <view class="filter-bar">
      <view
        v-for="item in statusTabs"
        :key="item.value"
        class="filter-item"
        :class="{ 'filter-item--active': query.orderStatus === item.value }"
        @click="onFilter(item.value)"
      >
        <text>{{ item.label }}</text>
      </view>
    </view>

    <view v-if="loading" class="empty"><text>加载中…</text></view>
    <view v-else-if="!orderList.length" class="empty">
      <text>暂无报修记录</text>
      <button class="btn-outline empty-btn" @click="goReport">去报修</button>
    </view>

    <view v-else>
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
        <view class="row-between order-meta">
          <text class="meta-text">{{ item.communityName }} {{ item.buildingNo }} {{ item.unitNo }}</text>
        </view>
        <view class="row-between order-meta">
          <text class="meta-text">报修时间</text>
          <text class="meta-text">{{ formatDateTime(item.reportTime) }}</text>
        </view>
      </view>
    </view>
  </view>
</template>

<script setup>
import { ref, reactive, onMounted } from 'vue'
import { onShow } from '@dcloudio/uni-app'
import { getMyOrderPage } from '../../api/repair'
import { orderStatusText, orderStatusClass, FAULT_TYPE_TEXT, formatDateTime } from '../../utils/dict'

const loading = ref(true)
const orderList = ref([])

const query = reactive({
  pageNum: 1,
  pageSize: 20,
  orderStatus: ''
})

const statusTabs = [
  { label: '全部', value: '' },
  { label: '待处理', value: 'pending' },
  { label: '已派单', value: 'assigned' },
  { label: '维修中', value: 'repairing' },
  { label: '已完成', value: 'confirmed' }
]

const faultTypeText = type => FAULT_TYPE_TEXT[type] || '故障'

const loadList = async () => {
  loading.value = true
  try {
    const res = await getMyOrderPage({
      pageNum: query.pageNum,
      pageSize: query.pageSize,
      orderStatus: query.orderStatus || undefined
    })
    orderList.value = res.rows || []
  } catch (e) {
    orderList.value = []
  } finally {
    loading.value = false
  }
}

const onFilter = value => {
  query.orderStatus = value
  query.pageNum = 1
  loadList()
}

const goDetail = orderId => {
  uni.navigateTo({ url: `/pages/progress/detail?orderId=${orderId}` })
}

const goReport = () => {
  uni.navigateTo({ url: '/pages/report/index' })
}

onMounted(loadList)
onShow(() => {
  if (orderList.value.length) {
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

.empty-btn {
  width: 260rpx;
  margin: 40rpx auto 0;
}
</style>
