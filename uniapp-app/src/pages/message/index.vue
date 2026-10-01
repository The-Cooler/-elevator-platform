<template>
  <view class="page-wrap">
    <view class="toolbar">
      <text class="toolbar-title">未读 {{ unreadCount }} 条</text>
      <text class="toolbar-action" @click="handleReadAll">全部已读</text>
    </view>

    <view v-if="loading" class="empty"><text>加载中…</text></view>
    <view v-else-if="!noticeList.length" class="empty"><text>暂无消息</text></view>

    <view
      v-for="item in noticeList"
      :key="item.noticeId"
      class="card notice-item"
      :class="{ 'notice-item--unread': item.isRead === '0' }"
      @click="handleRead(item)"
    >
      <view class="row-between">
        <view class="notice-title-row">
          <view v-if="item.isRead === '0'" class="unread-dot" />
          <text class="notice-title">{{ item.title }}</text>
        </view>
        <text class="notice-time">{{ formatDateTime(item.createTime) }}</text>
      </view>
      <text class="notice-content">{{ item.content }}</text>
    </view>
  </view>
</template>

<script setup>
import { ref, onMounted } from 'vue'
import { onShow } from '@dcloudio/uni-app'
import { listNotice, getUnreadNoticeCount, readNotice, readAllNotice } from '../../api/analysis'
import { formatDateTime } from '../../utils/dict'

const loading = ref(true)
const noticeList = ref([])
const unreadCount = ref(0)

const loadList = async () => {
  loading.value = true
  try {
    const [listRes, countRes] = await Promise.all([
      listNotice({ pageNum: 1, pageSize: 30 }),
      getUnreadNoticeCount()
    ])
    noticeList.value = listRes.rows || []
    unreadCount.value = countRes.data || 0
  } catch (e) {
    noticeList.value = []
    unreadCount.value = 0
  } finally {
    loading.value = false
  }
}

/** 点击消息标记已读 */
const handleRead = async item => {
  if (item.isRead === '1') return
  try {
    await readNotice(item.noticeId)
    item.isRead = '1'
    unreadCount.value = Math.max(0, unreadCount.value - 1)
  } catch (e) {
    // 错误提示已在请求层统一处理
  }
}

/** 全部标记已读 */
const handleReadAll = async () => {
  if (!unreadCount.value) {
    uni.showToast({ title: '没有未读消息', icon: 'none' })
    return
  }
  try {
    await readAllNotice()
    uni.showToast({ title: '已全部标记为已读', icon: 'success' })
    loadList()
  } catch (e) {
    // 错误提示已在请求层统一处理
  }
}

onMounted(loadList)
onShow(() => {
  if (noticeList.value.length) {
    loadList()
  }
})
</script>

<style scoped>
.toolbar {
  display: flex;
  align-items: center;
  justify-content: space-between;
  padding: 20rpx 8rpx 24rpx;
}

.toolbar-title {
  font-size: 28rpx;
  color: #606266;
}

.toolbar-action {
  font-size: 26rpx;
  color: #0b3d91;
}

.notice-item {
  padding: 28rpx;
}

.notice-item--unread {
  border-left: 8rpx solid #0b3d91;
}

.notice-title-row {
  display: flex;
  align-items: center;
  flex: 1;
  min-width: 0;
}

.unread-dot {
  width: 14rpx;
  height: 14rpx;
  border-radius: 7rpx;
  background: #e5484d;
  margin-right: 12rpx;
  flex-shrink: 0;
}

.notice-title {
  font-size: 29rpx;
  font-weight: 600;
  color: #303133;
}

.notice-time {
  font-size: 22rpx;
  color: #98a1b0;
  margin-left: 16rpx;
  flex-shrink: 0;
}

.notice-content {
  display: block;
  margin-top: 14rpx;
  font-size: 26rpx;
  color: #606266;
  line-height: 1.6;
}
</style>
