<template>
  <view class="page-wrap">
    <view class="card">
      <view class="card-title">注册账号</view>

      <view class="field">
        <text class="field-label">注册角色</text>
        <picker :range="roleLabels" :value="roleIndex" @change="onRoleChange">
          <view class="picker-box">
            <text>{{ roleLabels[roleIndex] }}</text>
            <text class="picker-arrow">▾</text>
          </view>
        </picker>
      </view>

      <view class="field">
        <text class="field-label">用户名</text>
        <input v-model="form.userName" class="input" placeholder="2-20 个字符，登录时使用" maxlength="20" />
      </view>

      <view class="field">
        <text class="field-label">姓名</text>
        <input v-model="form.nickName" class="input" placeholder="请输入真实姓名" maxlength="30" />
      </view>

      <view class="field">
        <text class="field-label">手机号</text>
        <input v-model="form.phonenumber" class="input" type="number" placeholder="请输入 11 位手机号" maxlength="11" />
      </view>

      <view class="field">
        <text class="field-label">密码</text>
        <input v-model="form.password" class="input" password placeholder="5-20 个字符" maxlength="20" />
      </view>

      <view class="field">
        <text class="field-label">所属小区</text>
        <picker :range="communityNames" :value="communityIndex" @change="onCommunityChange">
          <view class="picker-box">
            <text>{{ communityNames[communityIndex] || '请选择所属小区' }}</text>
            <text class="picker-arrow">▾</text>
          </view>
        </picker>
      </view>

      <view class="field">
        <text class="field-label">验证码</text>
        <view class="captcha-row">
          <input v-model="form.code" class="input captcha-input" placeholder="请输入验证码" maxlength="6" />
          <image v-if="captchaImg" class="captcha-img" :src="captchaImg" mode="aspectFit" @click="loadCaptcha" />
          <view v-else class="captcha-refresh" @click="loadCaptcha">
            <text>获取验证码</text>
          </view>
        </view>
      </view>

      <button class="btn-primary register-btn" :loading="submitting" :disabled="submitting" @click="handleRegister">
        {{ submitting ? '提交中…' : '注 册' }}
      </button>

      <view class="register-footer">
        <text class="link" @click="goLogin">已有账号？返回登录</text>
      </view>
    </view>
  </view>
</template>

<script setup>
import { ref, reactive, computed, onMounted } from 'vue'
import { getCaptcha, register, getCommunityList } from '../../api/auth'

const roleKeys = ['owner', 'property', 'worker', 'admin']
const roleLabels = ['业主', '物业', '维修员', '管理员']
const roleIndex = ref(0)

const communities = ref([])
const communityIndex = ref(0)
const communityNames = computed(() => communities.value.map(item => item.communityName))

const captchaImg = ref('')
const captchaUuid = ref('')
const submitting = ref(false)

const form = reactive({
  userName: '',
  nickName: '',
  phonenumber: '',
  password: '',
  code: ''
})

const onRoleChange = e => {
  roleIndex.value = Number(e.detail.value)
}

const onCommunityChange = e => {
  communityIndex.value = Number(e.detail.value)
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

/** 拉取小区列表 */
const loadCommunities = async () => {
  try {
    const res = await getCommunityList()
    communities.value = res.data || []
  } catch (e) {
    communities.value = []
  }
}

const handleRegister = async () => {
  if (!form.userName.trim()) {
    uni.showToast({ title: '请输入用户名', icon: 'none' })
    return
  }
  if (!form.nickName.trim()) {
    uni.showToast({ title: '请输入姓名', icon: 'none' })
    return
  }
  if (!/^1[3-9]\d{9}$/.test(form.phonenumber)) {
    uni.showToast({ title: '请填写正确的手机号', icon: 'none' })
    return
  }
  if (form.password.length < 5) {
    uni.showToast({ title: '密码长度至少 5 个字符', icon: 'none' })
    return
  }
  if (!form.code.trim()) {
    uni.showToast({ title: '请输入验证码', icon: 'none' })
    return
  }

  submitting.value = true
  try {
    await register({
      userName: form.userName.trim(),
      nickName: form.nickName.trim(),
      phonenumber: form.phonenumber,
      password: form.password,
      roleKey: roleKeys[roleIndex.value],
      communityId: communities.value[communityIndex.value]
        ? communities.value[communityIndex.value].communityId
        : undefined,
      code: form.code.trim(),
      uuid: captchaUuid.value
    })
    uni.showToast({ title: '注册成功，请登录', icon: 'success' })
    setTimeout(() => {
      uni.reLaunch({ url: '/pages/login/index' })
    }, 800)
  } catch (e) {
    form.code = ''
    loadCaptcha()
  } finally {
    submitting.value = false
  }
}

const goLogin = () => {
  uni.reLaunch({ url: '/pages/login/index' })
}

onMounted(() => {
  loadCaptcha()
  loadCommunities()
})
</script>

<style scoped>
.input {
  width: 100%;
  height: 88rpx;
  background: #f5f7fa;
  border-radius: 12rpx;
  padding: 0 24rpx;
  font-size: 28rpx;
  box-sizing: border-box;
}

.picker-box {
  height: 88rpx;
  background: #f5f7fa;
  border-radius: 12rpx;
  padding: 0 24rpx;
  display: flex;
  align-items: center;
  justify-content: space-between;
  font-size: 28rpx;
  color: #303133;
}

.picker-arrow {
  color: #98a1b0;
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

.register-btn {
  margin-top: 20rpx;
}

.register-footer {
  text-align: center;
  padding: 32rpx 0 10rpx;
}

.link {
  font-size: 26rpx;
  color: #0b3d91;
}
</style>
