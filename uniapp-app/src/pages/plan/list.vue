<template>
  <view class="page-wrap">
    <view v-if="loading" class="empty"><text>加载中…</text></view>
    <view v-else-if="!planList.length" class="empty"><text>暂无维保计划</text></view>

    <view v-for="item in planList" :key="item.planId" class="card plan-item">
      <view class="row-between">
        <text class="plan-name">{{ item.planName }}</text>
        <text class="tag" :class="item.planStatus === '0' ? 'tag-done' : 'tag-muted'">
          {{ item.planStatus === '0' ? '启用' : '停用' }}
        </text>
      </view>
      <view class="plan-meta">
        <text class="meta-text">{{ item.elevatorCode }}｜{{ maintainTypeText(item.maintainType) }}｜{{ item.cycleDays }} 天</text>
      </view>
      <view class="plan-meta">
        <text class="meta-text">{{ item.communityName }} {{ item.buildingNo }} {{ item.unitNo }}</text>
      </view>
      <view class="row-between plan-meta">
        <text class="meta-text">下次维保</text>
        <text class="meta-text" :class="{ 'meta-warn': item.dueSoon }">
          {{ item.nextDate || '—' }}
          <text v-if="item.dueSoon && item.planStatus === '0'" class="due-tip">
            （{{ item.remainingDays < 0 ? '已超期' : '临期' }}）
          </text>
        </text>
      </view>
      <view class="row-between plan-meta">
        <text class="meta-text">负责人：{{ item.ownerName || '—' }}</text>
        <text class="meta-text">完成率 {{ item.completeRate || 0 }}%</text>
      </view>
      <view class="progress-bar">
        <view class="progress-inner" :style="{ width: (item.completeRate || 0) + '%' }" />
      </view>
    </view>
  </view>
</template>

<script setup>
import { ref, onMounted } from 'vue'
import { listPlan } from '../../api/maintain'
import { MAINTAIN_TYPE_TEXT } from '../../utils/dict'

const loading = ref(true)
const planList = ref([])

const maintainTypeText = type => MAINTAIN_TYPE_TEXT[type] || type || ''

const loadList = async () => {
  loading.value = true
  try {
    const res = await listPlan({ pageNum: 1, pageSize: 30 })
    planList.value = res.rows || []
  } catch (e) {
    planList.value = []
  } finally {
    loading.value = false
  }
}

onMounted(loadList)
</script>

<style scoped>
.plan-item {
  padding: 28rpx;
}

.plan-name {
  font-size: 30rpx;
  font-weight: 600;
  color: #303133;
}

.plan-meta {
  margin-top: 12rpx;
}

.meta-text {
  font-size: 25rpx;
  color: #909399;
}

.meta-warn {
  color: #d98d12;
}

.due-tip {
  color: #d98d12;
  font-size: 24rpx;
}

.progress-bar {
  height: 12rpx;
  background: #f5f7fa;
  border-radius: 6rpx;
  margin-top: 20rpx;
  overflow: hidden;
}

.progress-inner {
  height: 100%;
  background: #0b3d91;
  border-radius: 6rpx;
}
</style>
