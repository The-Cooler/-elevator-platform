<template>
  <view class="page-wrap">
    <!-- 顶部问候 -->
    <view class="hero">
      <view class="hero-row">
        <view>
          <text class="hero-hello">您好，{{ userStore.displayName || '用户' }}</text>
          <text class="hero-role">{{ roleName }} · {{ communityName || '未绑定小区' }}</text>
        </view>
      </view>
      <!-- 数据概览 -->
      <view class="hero-stats">
        <view class="hero-stat">
          <text class="hero-stat-value">{{ overview.elevatorCount ?? 0 }}</text>
          <text class="hero-stat-label">电梯总数</text>
        </view>
        <view class="hero-stat">
          <text class="hero-stat-value">{{ overview.monthRepairCount ?? 0 }}</text>
          <text class="hero-stat-label">本月报修</text>
        </view>
        <view class="hero-stat">
          <text class="hero-stat-value">{{ todoCount }}</text>
          <text class="hero-stat-label">我的待办</text>
        </view>
      </view>
    </view>

    <!-- 快捷入口，按角色展示 -->
    <view class="card">
      <view class="card-title">{{ roleName }}功能</view>
      <view class="entry-grid">
        <view v-for="item in entries" :key="item.url" class="entry" @click="goPage(item.url)">
          <view class="entry-icon" :style="{ background: item.bg }">
            <text class="entry-icon-text">{{ item.icon }}</text>
          </view>
          <text class="entry-text">{{ item.text }}</text>
          <text v-if="item.badge" class="entry-badge">{{ item.badge }}</text>
        </view>
      </view>
    </view>

    <!-- 最新动态：业主看报修进度，其余角色看待办 -->
    <view class="card">
      <view class="card-title">{{ listTitle }}</view>
      <view v-if="loading" class="empty"><text>加载中…</text></view>
      <view v-else-if="!recentList.length" class="empty"><text>{{ emptyText }}</text></view>
      <view v-else>
        <view
          v-for="item in recentList"
          :key="item.orderId || item.recordId"
          class="list-item"
          @click="openItem(item)"
        >
          <view class="list-main">
            <view class="row">
              <text class="list-code">{{ item.orderNo || item.recordNo }}</text>
              <text class="tag" :class="statusClass(item)">
                {{ statusText(item) }}
              </text>
            </view>
            <text class="list-desc">{{ item.faultDesc || item.elevatorCode }}</text>
          </view>
          <text class="list-time">{{ item.reportTime || item.planDate || '' }}</text>
        </view>
      </view>
    </view>
  </view>
</template>

<script setup>
import { ref, computed, onMounted } from 'vue'
import { onShow } from '@dcloudio/uni-app'
import { useUserStore } from '../../store/user'
import { getOverview, getUnreadNoticeCount } from '../../api/analysis'
import { getMyOrderPage } from '../../api/repair'
import { getPendingList, getMyAcceptList, getMyProcessList } from '../../api/order'
import { listMyInspection } from '../../api/maintain'
import {
  orderStatusText,
  orderStatusClass,
  RECORD_STATUS_TEXT,
  RECORD_STATUS_CLASS
} from '../../utils/dict'

const userStore = useUserStore()

const overview = ref({})
const loading = ref(true)
const recentList = ref([])
const pendingCount = ref(0)
const acceptCount = ref(0)
const inspectionCount = ref(0)
const unreadNotice = ref(0)

const roleName = computed(() => {
  const map = { owner: '业主', property: '物业', worker: '维修员', admin: '管理员' }
  return map[userStore.roleKey] || '用户'
})

const communityName = computed(() => (userStore.userInfo && userStore.userInfo.communityName) || '')

const todoCount = computed(() => {
  if (userStore.isOwner) return 0
  if (userStore.isProperty) return pendingCount.value
  if (userStore.isWorker) return acceptCount.value + inspectionCount.value
  return 0
})

/** 各角色的功能入口 */
const entries = computed(() => {
  if (userStore.isOwner) {
    return [
      { icon: '报', text: '我要报修', url: '/pages/report/index', bg: '#0B3D91' },
      { icon: '进', text: '报修进度', url: '/pages/progress/list', bg: '#3F6BB4' },
      { icon: '信', text: '消息中心', url: '/pages/message/index', bg: '#17A673', badge: unreadNotice.value }
    ]
  }
  if (userStore.isProperty) {
    return [
      { icon: '派', text: '待派单池', url: '/pages/dispatch/pending', bg: '#E5484D', badge: pendingCount.value },
      { icon: '单', text: '报修工单', url: '/pages/order/list', bg: '#0B3D91' },
      { icon: '划', text: '维保计划', url: '/pages/plan/list', bg: '#3F6BB4' },
      { icon: '异', text: '工单异常', url: '/pages/exception/list', bg: '#F5A623' },
      { icon: '统', text: '统计分析', url: '/pages/analysis/index', bg: '#17A673' },
      { icon: '信', text: '消息中心', url: '/pages/message/index', bg: '#6B7688', badge: unreadNotice.value }
    ]
  }
  if (userStore.isWorker) {
    return [
      { icon: '接', text: '待接单', url: '/pages/accept/list', bg: '#E5484D', badge: acceptCount.value },
      { icon: '修', text: '在办工单', url: '/pages/process/list', bg: '#0B3D91' },
      { icon: '巡', text: '巡检任务', url: '/pages/inspection/list', bg: '#3F6BB4', badge: inspectionCount.value },
      { icon: '信', text: '消息中心', url: '/pages/message/index', bg: '#17A673', badge: unreadNotice.value }
    ]
  }
  return [
    { icon: '信', text: '消息中心', url: '/pages/message/index', bg: '#0B3D91', badge: unreadNotice.value }
  ]
})

const listTitle = computed(() => {
  if (userStore.isOwner) return '我的报修'
  if (userStore.isWorker) return '待接单工单'
  return '待派单工单'
})

const emptyText = computed(() => {
  if (userStore.isOwner) return '您还没有提交过报修'
  if (userStore.isWorker) return '当前没有待接单工单'
  return '当前没有待派单工单'
})

const statusText = item => {
  if (item.recordStatus) return RECORD_STATUS_TEXT[item.recordStatus] || item.recordStatus
  return orderStatusText(item.orderStatus)
}

const statusClass = item => {
  if (item.recordStatus) return RECORD_STATUS_CLASS[item.recordStatus] || 'tag-muted'
  return orderStatusClass(item.orderStatus)
}

const openItem = item => {
  if (item.orderId) {
    if (userStore.isWorker) {
      uni.navigateTo({ url: `/pages/process/detail?orderId=${item.orderId}` })
    } else {
      uni.navigateTo({ url: `/pages/progress/detail?orderId=${item.orderId}` })
    }
  }
}

const goPage = url => {
  const tabs = ['/pages/message/index', '/pages/profile/index', '/pages/home/index']
  if (tabs.includes(url)) {
    uni.switchTab({ url })
  } else {
    uni.navigateTo({ url })
  }
}

/** 加载首页数据，按角色拉取对应待办 */
const loadData = async () => {
  loading.value = true
  try {
    const res = await getOverview()
    overview.value = res.data || {}
  } catch (e) {
    overview.value = {}
  }

  try {
    const res = await getUnreadNoticeCount()
    unreadNotice.value = res.data || 0
  } catch (e) {
    unreadNotice.value = 0
  }

  // 按角色拉取待办与列表
  try {
    if (userStore.isOwner) {
      const res = await getMyOrderPage({ pageNum: 1, pageSize: 5 })
      recentList.value = res.rows || []
    } else if (userStore.isProperty) {
      const res = await getPendingList({ pageNum: 1, pageSize: 5 })
      recentList.value = res.rows || []
      pendingCount.value = res.total || 0
    } else if (userStore.isWorker) {
      const acceptRes = await getMyAcceptList({ pageNum: 1, pageSize: 5 })
      recentList.value = acceptRes.rows || []
      acceptCount.value = acceptRes.total || 0
      const inspectRes = await listMyInspection({ pageNum: 1, pageSize: 1, recordStatus: 'pending' })
      inspectionCount.value = inspectRes.total || 0
    }
  } catch (e) {
    recentList.value = []
  } finally {
    loading.value = false
  }
}

onMounted(() => {
  if (!userStore.isLogin) {
    uni.reLaunch({ url: '/pages/login/index' })
    return
  }
  loadData()
})

// 从其他页面返回时刷新待办
onShow(() => {
  if (userStore.isLogin) {
    loadData()
  }
})
</script>

<style scoped>
.hero {
  background: linear-gradient(135deg, #0b3d91 0%, #3f6bb4 100%);
  border-radius: 20rpx;
  padding: 40rpx 32rpx 32rpx;
  margin-bottom: 24rpx;
}

.hero-row {
  margin-bottom: 36rpx;
}

.hero-hello {
  display: block;
  font-size: 36rpx;
  font-weight: 600;
  color: #ffffff;
}

.hero-role {
  display: block;
  margin-top: 12rpx;
  font-size: 26rpx;
  color: #d6e0f3;
}

.hero-stats {
  display: flex;
}

.hero-stat {
  flex: 1;
  display: flex;
  flex-direction: column;
  align-items: center;
}

.hero-stat-value {
  font-size: 42rpx;
  font-weight: 700;
  color: #ffffff;
}

.hero-stat-label {
  margin-top: 8rpx;
  font-size: 24rpx;
  color: #d6e0f3;
}

.entry-grid {
  display: flex;
  flex-wrap: wrap;
}

.entry {
  width: 33.33%;
  display: flex;
  flex-direction: column;
  align-items: center;
  padding: 20rpx 0;
  position: relative;
}

.entry-icon {
  width: 88rpx;
  height: 88rpx;
  border-radius: 24rpx;
  display: flex;
  align-items: center;
  justify-content: center;
}

.entry-icon-text {
  font-size: 36rpx;
  color: #ffffff;
  font-weight: 600;
}

.entry-text {
  margin-top: 14rpx;
  font-size: 26rpx;
  color: #303133;
}

.entry-badge {
  position: absolute;
  top: 12rpx;
  right: 34rpx;
  min-width: 34rpx;
  height: 34rpx;
  line-height: 34rpx;
  padding: 0 8rpx;
  border-radius: 17rpx;
  background: #e5484d;
  color: #ffffff;
  font-size: 20rpx;
  text-align: center;
}

.list-item {
  display: flex;
  align-items: center;
  justify-content: space-between;
  padding: 24rpx 0;
  border-bottom: 2rpx solid #f5f7fa;
}

.list-item:last-child {
  border-bottom: none;
}

.list-main {
  flex: 1;
  min-width: 0;
}

.list-code {
  font-size: 26rpx;
  color: #6b7688;
}

.list-desc {
  display: block;
  margin-top: 12rpx;
  font-size: 28rpx;
  color: #303133;
  overflow: hidden;
  text-overflow: ellipsis;
  white-space: nowrap;
}

.list-time {
  margin-left: 20rpx;
  font-size: 24rpx;
  color: #98a1b0;
}
</style>
