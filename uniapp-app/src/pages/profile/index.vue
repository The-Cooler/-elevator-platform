<template>
  <view class="page-wrap">
    <!-- 账号信息 -->
    <view class="card profile-card">
      <view class="avatar">
        <text class="avatar-text">{{ (userStore.displayName || '用')[0] }}</text>
      </view>
      <view class="profile-main">
        <text class="profile-name">{{ userStore.displayName || '未登录' }}</text>
        <text class="profile-role">{{ roleName }}<text v-if="communityName"> · {{ communityName }}</text></text>
      </view>
    </view>

    <view class="card">
      <view class="card-title">账号信息</view>
      <view class="info-row">
        <text class="label">用户名</text>
        <text class="value">{{ userInfo.userName || '—' }}</text>
      </view>
      <view class="info-row">
        <text class="label">姓名</text>
        <text class="value">{{ userInfo.nickName || '—' }}</text>
      </view>
      <view class="info-row">
        <text class="label">手机号</text>
        <text class="value">{{ userInfo.phonenumber || '—' }}</text>
      </view>
      <view class="info-row">
        <text class="label">角色</text>
        <text class="value">{{ userInfo.roleName || roleName }}</text>
      </view>
      <view class="info-row">
        <text class="label">所属小区</text>
        <text class="value">{{ userInfo.communityName || '未绑定' }}</text>
      </view>
    </view>

    <button class="btn-outline logout-btn" :loading="loggingOut" @click="handleLogout">退出登录</button>
  </view>
</template>

<script setup>
import { ref, computed, onMounted } from 'vue'
import { useUserStore } from '../../store/user'

const userStore = useUserStore()

const loggingOut = ref(false)

const userInfo = computed(() => userStore.userInfo || {})

const roleName = computed(() => {
  const map = { owner: '业主', property: '物业', worker: '维修员', admin: '管理员' }
  return map[userStore.roleKey] || '用户'
})

const communityName = computed(() => (userStore.userInfo && userStore.userInfo.communityName) || '')

const handleLogout = () => {
  uni.showModal({
    title: '退出登录',
    content: '确认退出当前账号吗？',
    success: async res => {
      if (!res.confirm) return
      loggingOut.value = true
      try {
        await userStore.logout()
        uni.showToast({ title: '已退出登录', icon: 'success' })
        setTimeout(() => {
          uni.reLaunch({ url: '/pages/login/index' })
        }, 500)
      } finally {
        loggingOut.value = false
      }
    }
  })
}

onMounted(async () => {
  if (!userStore.isLogin) {
    uni.reLaunch({ url: '/pages/login/index' })
    return
  }
  // 刷新一次用户信息，保证资料最新
  try {
    await userStore.fetchUserInfo()
  } catch (e) {
    // 拉取失败时沿用本地缓存
  }
})
</script>

<style scoped>
.profile-card {
  display: flex;
  align-items: center;
}

.avatar {
  width: 110rpx;
  height: 110rpx;
  border-radius: 55rpx;
  background: #0b3d91;
  display: flex;
  align-items: center;
  justify-content: center;
  margin-right: 26rpx;
}

.avatar-text {
  font-size: 46rpx;
  font-weight: 600;
  color: #ffffff;
}

.profile-main {
  flex: 1;
}

.profile-name {
  font-size: 34rpx;
  font-weight: 600;
  color: #303133;
}

.profile-role {
  display: block;
  margin-top: 10rpx;
  font-size: 26rpx;
  color: #909399;
}

.info-row {
  display: flex;
  margin-top: 16rpx;
}

.info-row .label {
  width: 170rpx;
  flex-shrink: 0;
}

.info-row .value {
  flex: 1;
}

.logout-btn {
  margin: 20rpx 0 40rpx;
}
</style>
