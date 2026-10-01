<template>
  <view class="page-wrap">
    <!-- 汇总指标 -->
    <view class="summary-card">
      <view class="summary-item">
        <text class="summary-value">{{ summary.totalFault ?? 0 }}</text>
        <text class="summary-label">故障总数</text>
      </view>
      <view class="summary-item">
        <text class="summary-value summary-danger">{{ summary.urgentFault ?? 0 }}</text>
        <text class="summary-label">紧急故障</text>
      </view>
      <view class="summary-item">
        <text class="summary-value">{{ summary.avgAssignMinutes ?? 0 }}</text>
        <text class="summary-label">平均响应(分)</text>
      </view>
      <view class="summary-item">
        <text class="summary-value">{{ summary.avgRepairMinutes ?? 0 }}</text>
        <text class="summary-label">平均维修(分)</text>
      </view>
    </view>

    <!-- 各电梯故障次数，用横向条形表示 -->
    <view class="card">
      <view class="card-title">各电梯故障次数</view>
      <view v-if="loading" class="empty"><text>加载中…</text></view>
      <view v-else-if="!elevatorStats.length" class="empty"><text>暂无统计数据</text></view>
      <view v-else>
        <view v-for="item in elevatorStats" :key="item.elevatorId" class="bar-row">
          <text class="bar-label">{{ item.elevatorCode }}</text>
          <view class="bar-track">
            <view class="bar-inner" :style="{ width: barWidth(item.faultCount) }" />
          </view>
          <text class="bar-value">{{ item.faultCount }}</text>
        </view>
      </view>
    </view>

    <!-- 电梯健康评分 -->
    <view class="card">
      <view class="card-title">电梯健康评分</view>
      <view v-if="healthLoading" class="empty"><text>加载中…</text></view>
      <view v-else-if="!healthList.length" class="empty"><text>暂无健康评分</text></view>
      <view v-else>
        <view v-for="item in healthList" :key="item.healthId" class="health-row">
          <view class="health-main">
            <text class="health-code">{{ item.elevatorCode }}</text>
            <text class="health-desc">
              故障 {{ item.faultCount }} 次｜维保完成率 {{ item.maintainRate }}%｜巡检合格率 {{ item.inspectRate }}%
            </text>
          </view>
          <view class="health-score-box">
            <text class="health-score" :style="{ color: scoreColor(item.healthScore) }">{{ item.healthScore }}</text>
            <text class="health-level">{{ item.healthLevelName }}</text>
          </view>
        </view>
      </view>
    </view>
  </view>
</template>

<script setup>
import { ref, onMounted } from 'vue'
import { frequencyByElevator, frequencySummary, listHealth } from '../../api/analysis'

const loading = ref(true)
const healthLoading = ref(true)
const summary = ref({})
const elevatorStats = ref([])
const healthList = ref([])

/** 条形宽度按最大故障次数等比换算 */
const barWidth = count => {
  const max = Math.max(...elevatorStats.value.map(i => i.faultCount || 0), 1)
  return `${Math.round(((count || 0) / max) * 100)}%`
}

const scoreColor = score => {
  const value = Number(score || 0)
  if (value >= 90) return '#17a673'
  if (value >= 80) return '#67c23a'
  if (value >= 70) return '#e6a23c'
  if (value >= 60) return '#d98d12'
  return '#e5484d'
}

const loadData = async () => {
  loading.value = true
  try {
    const [summaryRes, elevatorRes] = await Promise.all([
      frequencySummary({}),
      frequencyByElevator({})
    ])
    summary.value = summaryRes.data || {}
    elevatorStats.value = (elevatorRes.data || []).filter(item => item.faultCount > 0)
  } catch (e) {
    summary.value = {}
    elevatorStats.value = []
  } finally {
    loading.value = false
  }

  healthLoading.value = true
  try {
    const res = await listHealth({ pageNum: 1, pageSize: 20 })
    healthList.value = res.rows || []
  } catch (e) {
    healthList.value = []
  } finally {
    healthLoading.value = false
  }
}

onMounted(loadData)
</script>

<style scoped>
.summary-card {
  display: flex;
  background: linear-gradient(135deg, #0b3d91 0%, #3f6bb4 100%);
  border-radius: 20rpx;
  padding: 32rpx 0;
  margin-bottom: 24rpx;
}

.summary-item {
  flex: 1;
  display: flex;
  flex-direction: column;
  align-items: center;
}

.summary-value {
  font-size: 38rpx;
  font-weight: 700;
  color: #ffffff;
}

.summary-danger {
  color: #ffb4b4;
}

.summary-label {
  margin-top: 10rpx;
  font-size: 22rpx;
  color: #d6e0f3;
}

.bar-row {
  display: flex;
  align-items: center;
  margin-bottom: 22rpx;
}

.bar-label {
  width: 150rpx;
  font-size: 24rpx;
  color: #606266;
}

.bar-track {
  flex: 1;
  height: 24rpx;
  background: #f5f7fa;
  border-radius: 12rpx;
  overflow: hidden;
  margin: 0 16rpx;
}

.bar-inner {
  height: 100%;
  background: #0b3d91;
  border-radius: 12rpx;
}

.bar-value {
  width: 60rpx;
  text-align: right;
  font-size: 26rpx;
  color: #303133;
  font-weight: 600;
}

.health-row {
  display: flex;
  align-items: center;
  justify-content: space-between;
  padding: 24rpx 0;
  border-bottom: 2rpx solid #f5f7fa;
}

.health-row:last-child {
  border-bottom: none;
}

.health-main {
  flex: 1;
  min-width: 0;
}

.health-code {
  font-size: 28rpx;
  font-weight: 600;
  color: #303133;
}

.health-desc {
  display: block;
  margin-top: 8rpx;
  font-size: 23rpx;
  color: #909399;
}

.health-score-box {
  display: flex;
  flex-direction: column;
  align-items: center;
  margin-left: 20rpx;
}

.health-score {
  font-size: 40rpx;
  font-weight: 700;
}

.health-level {
  margin-top: 4rpx;
  font-size: 22rpx;
  color: #909399;
}
</style>
