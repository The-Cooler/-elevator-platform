<template>
  <view class="login-page">
    <view class="login-header">
      <view class="login-logo">
        <text class="login-logo-text">电</text>
      </view>
      <text class="login-title">电梯故障报修与维保跟踪平台</text>
      <text class="login-subtitle">老旧小区电梯安全，居民出门第一步</text>
    </view>

    <view class="login-body">
      <!-- 登录方式切换 -->
      <view class="login-tabs">
        <view
          class="login-tab"
          :class="{ 'login-tab--active': loginType === 'username' }"
          @click="switchType('username')"
        >
          <text>账号密码</text>
        </view>
        <view
          class="login-tab"
          :class="{ 'login-tab--active': loginType === 'phone' }"
          @click="switchType('phone')"
        >
          <text>手机号密码</text>
        </view>
      </view>

      <view class="card">
        <view class="field">
          <text class="field-label">{{ loginType === 'username' ? '用户名' : '手机号' }}</text>
          <input
            v-model="form.account"
            class="input"
            :placeholder="loginType === 'username' ? '请输入用户名' : '请输入 11 位手机号'"
            :maxlength="loginType === 'username' ? 20 : 11"
          />
        </view>

        <view class="field">
          <text class="field-label">密码</text>
          <input v-model="form.password" class="input" password placeholder="请输入密码" />
        </view>

        <view class="field">
          <text class="field-label">验证码</text>
          <view class="captcha-row">
            <input v-model="form.code" class="input captcha-input" placeholder="请输入验证码" maxlength="6" />
            <image
              v-if="captchaImg"
              class="captcha-img"
              :src="captchaImg"
              mode="aspectFit"
              @click="loadCaptcha"
            />
            <view v-else class="captcha-refresh" @click="loadCaptcha">
              <text>获取验证码</text>
            </view>
          </view>
        </view>

        <button class="btn-primary login-btn" :loading="submitting" :disabled="submitting" @click="handleLogin">
          {{ submitting ? '登录中…' : '登 录' }}
        </button>

        <view class="login-footer">
          <text class="login-link" @click="goRegister">还没有账号？立即注册</text>
        </view>
      </view>
    </view>
  </view>
</template>

<script setup>
import { ref, reactive, onMounted } from 'vue'
import { getCaptcha } from '../../api/auth'
import { useUserStore } from '../../store/user'

const userStore = useUserStore()

const loginType = ref('username')
const captchaImg = ref('')
const captchaUuid = ref('')
const submitting = ref(false)

const form = reactive({
  account: '',
  password: '',
  code: ''
})

/** 切换登录方式时清空已填内容 */
const switchType = type => {
  if (loginType.value === type) return
  loginType.value = type
  form.account = ''
  form.code = ''
}

/** 拉取图形验证码 */
const loadCaptcha = async () => {
  try {
    const res = await getCaptcha()
    captchaImg.value = res.img ? `data:image/jpeg;base64,${res.img}` : ''
    captchaUuid.value = res.uuid || ''
  } catch (e) {
    // 错误提示已在请求层统一处理
  }
}

const handleLogin = async () => {
  if (!form.account.trim()) {
    uni.showToast({ title: loginType.value === 'username' ? '请输入用户名' : '请输入手机号', icon: 'none' })
    return
  }
  if (!form.password) {
    uni.showToast({ title: '请输入密码', icon: 'none' })
    return
  }
  if (!form.code.trim()) {
    uni.showToast({ title: '请输入验证码', icon: 'none' })
    return
  }

  submitting.value = true
  try {
    const params = {
      password: form.password,
      code: form.code.trim(),
      uuid: captchaUuid.value
    }
    if (loginType.value === 'username') {
      params.username = form.account.trim()
      await userStore.login(params)
    } else {
      params.phonenumber = form.account.trim()
      await userStore.phoneLogin(params)
    }
    uni.showToast({ title: '登录成功', icon: 'success' })
    setTimeout(() => {
      uni.reLaunch({ url: '/pages/home/index' })
    }, 500)
  } catch (e) {
    form.code = ''
    loadCaptcha()
  } finally {
    submitting.value = false
  }
}

const goRegister = () => {
  uni.navigateTo({ url: '/pages/register/index' })
}

onMounted(loadCaptcha)
</script>

<style scoped>
.login-page {
  min-height: 100vh;
  background: linear-gradient(180deg, #0b3d91 0%, #3f6bb4 42%, #f5f7fa 42%, #f5f7fa 100%);
}

.login-header {
  display: flex;
  flex-direction: column;
  align-items: center;
  padding: 90rpx 40rpx 70rpx;
}

.login-logo {
  width: 120rpx;
  height: 120rpx;
  border-radius: 28rpx;
  background: #ffffff;
  display: flex;
  align-items: center;
  justify-content: center;
  margin-bottom: 28rpx;
}

.login-logo-text {
  font-size: 56rpx;
  font-weight: 700;
  color: #0b3d91;
}

.login-title {
  font-size: 38rpx;
  font-weight: 600;
  color: #ffffff;
}

.login-subtitle {
  margin-top: 14rpx;
  font-size: 26rpx;
  color: #d6e0f3;
}

.login-body {
  padding: 0 40rpx;
}

.login-tabs {
  display: flex;
  background: #ffffff;
  border-radius: 16rpx 16rpx 0 0;
  overflow: hidden;
}

.login-tab {
  flex: 1;
  text-align: center;
  padding: 26rpx 0;
  font-size: 30rpx;
  color: #6b7688;
}

.login-tab--active {
  color: #0b3d91;
  font-weight: 600;
  border-bottom: 6rpx solid #0b3d91;
}

.card {
  border-radius: 0 0 16rpx 16rpx;
  padding-top: 36rpx;
}

.input {
  width: 100%;
  height: 88rpx;
  background: #f5f7fa;
  border-radius: 12rpx;
  padding: 0 24rpx;
  font-size: 28rpx;
  box-sizing: border-box;
}

.captcha-row {
  display: flex;
  align-items: center;
}

.captcha-input {
  flex: 1;
}

.captcha-img {
  width: 200rpx;
  height: 88rpx;
  margin-left: 20rpx;
  border-radius: 12rpx;
  background: #f5f7fa;
}

.captcha-refresh {
  width: 200rpx;
  height: 88rpx;
  margin-left: 20rpx;
  border-radius: 12rpx;
  background: #ebf0fa;
  display: flex;
  align-items: center;
  justify-content: center;
  font-size: 24rpx;
  color: #0b3d91;
}

.login-btn {
  margin-top: 20rpx;
}

.login-footer {
  text-align: center;
  padding: 32rpx 0 40rpx;
}

.login-link {
  font-size: 26rpx;
  color: #0b3d91;
}
</style>
