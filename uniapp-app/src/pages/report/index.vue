<template>
  <view class="page-wrap">
    <view class="card">
      <view class="card-title">选择故障电梯</view>

      <view class="field">
        <text class="field-label">所属小区</text>
        <picker :range="communityNames" :value="communityIndex" @change="onCommunityChange">
          <view class="picker-box">
            <text>{{ communityNames[communityIndex] || '请选择小区' }}</text>
            <text class="picker-arrow">▾</text>
          </view>
        </picker>
      </view>

      <view class="field">
        <text class="field-label">所在楼栋</text>
        <picker :range="buildingNames" :value="buildingIndex" :disabled="!buildingNames.length" @change="onBuildingChange">
          <view class="picker-box">
            <text>{{ buildingNames[buildingIndex] || '请先选择小区' }}</text>
            <text class="picker-arrow">▾</text>
          </view>
        </picker>
      </view>

      <view class="field">
        <text class="field-label">故障电梯</text>
        <picker :range="elevatorNames" :value="elevatorIndex" :disabled="!elevatorNames.length" @change="onElevatorChange">
          <view class="picker-box">
            <text>{{ elevatorNames[elevatorIndex] || '请先选择楼栋' }}</text>
            <text class="picker-arrow">▾</text>
          </view>
        </picker>
        <text v-if="elevatorTip" class="tip-warn">{{ elevatorTip }}</text>
      </view>
    </view>

    <view class="card">
      <view class="card-title">故障情况</view>

      <view class="field">
        <text class="field-label">故障现象</text>
        <view class="chip-group">
          <view
            v-for="item in faultTypes"
            :key="item.value"
            class="chip"
            :class="{ 'chip--active': form.faultType === item.value }"
            @click="onFaultType(item.value)"
          >
            <text>{{ item.label }}</text>
          </view>
        </view>
      </view>

      <view class="field">
        <text class="field-label">故障等级</text>
        <view class="chip-group">
          <view
            class="chip"
            :class="{ 'chip--active': form.faultLevel === '0' }"
            @click="form.faultLevel = '0'"
          >
            <text>紧急</text>
          </view>
          <view
            class="chip"
            :class="{ 'chip--active': form.faultLevel === '1' }"
            @click="form.faultLevel = '1'"
          >
            <text>一般</text>
          </view>
        </view>
        <text class="tip-muted">困人、停梯等危及人身安全的情形请选择紧急</text>
      </view>

      <view class="field">
        <text class="field-label">详细描述</text>
        <textarea
          v-model="form.faultDesc"
          class="textarea"
          placeholder="请描述故障的具体情况，例如：电梯运行到 3 楼时出现明显异响并伴有抖动"
          maxlength="500"
        />
        <text class="counter">{{ form.faultDesc.length }}/500</text>
      </view>

      <view class="field">
        <text class="field-label">联系电话</text>
        <input v-model="form.reporterPhone" class="input" type="number" maxlength="11" placeholder="便于维修员联系您" />
      </view>
    </view>

    <view class="card">
      <view class="card-title">现场证据</view>
      <view class="photo-grid">
        <view v-for="(item, index) in evidenceList" :key="item.fileId" class="photo-item">
          <image class="photo" :src="item.preview" mode="aspectFill" @click="previewEvidence(index)" />
          <view class="photo-remove" @click="removeEvidence(index)"><text>×</text></view>
        </view>
        <view v-if="evidenceList.length < 5" class="photo-add" @click="chooseImage">
          <text class="photo-add-icon">+</text>
          <text class="photo-add-text">{{ uploading ? '上传中…' : '添加照片' }}</text>
        </view>
      </view>
      <text class="tip-muted">图片单张不超过 10MB，最多 5 张。上传证据有助于维修员提前判断故障</text>
    </view>

    <button class="btn-primary submit-btn" :loading="submitting" :disabled="submitting" @click="handleSubmit">
      {{ submitting ? '提交中…' : '提交报修' }}
    </button>
  </view>
</template>

<script setup>
import { ref, reactive, computed, onMounted } from 'vue'
import { getCommunityList, getBuildingList, getElevatorList } from '../../api/auth'
import { submitReport, checkElevatorOpen, EVIDENCE_BIZ_TYPE } from '../../api/repair'
import { uploadFile } from '../../utils/request'
import { useUserStore } from '../../store/user'

const userStore = useUserStore()

const faultTypes = [
  { label: '异响', value: 'abnormal_noise' },
  { label: '停梯', value: 'stop' },
  { label: '困人', value: 'trapped' },
  { label: '门故障', value: 'door' },
  { label: '按钮失灵', value: 'button' },
  { label: '其他', value: 'other' }
]

const communities = ref([])
const buildings = ref([])
const elevators = ref([])
const communityIndex = ref(0)
const buildingIndex = ref(0)
const elevatorIndex = ref(0)
const elevatorTip = ref('')

const evidenceList = ref([])
const uploading = ref(false)
const submitting = ref(false)

const form = reactive({
  faultType: 'abnormal_noise',
  faultLevel: '1',
  faultDesc: '',
  reporterPhone: (userStore.userInfo && userStore.userInfo.phonenumber) || ''
})

const communityNames = computed(() => communities.value.map(item => item.communityName))
const buildingNames = computed(() => buildings.value.map(item => `${item.buildingNo} ${item.unitNo}`))
const elevatorNames = computed(() =>
  elevators.value.map(item => `${item.elevatorCode}（${item.brand}）`)
)

/** 故障类型改变时按语义给出默认等级建议 */
const onFaultType = value => {
  form.faultType = value
  form.faultLevel = value === 'trapped' || value === 'stop' ? '0' : '1'
}

/** 小区变化时重新加载楼栋 */
const onCommunityChange = async e => {
  communityIndex.value = Number(e.detail.value)
  buildingIndex.value = 0
  elevatorIndex.value = 0
  buildings.value = []
  elevators.value = []
  elevatorTip.value = ''
  await loadBuildings()
}

/** 楼栋变化时重新加载电梯 */
const onBuildingChange = async e => {
  buildingIndex.value = Number(e.detail.value)
  elevatorIndex.value = 0
  elevators.value = []
  elevatorTip.value = ''
  await loadElevators()
}

/** 选择电梯后校验是否存在未结工单 */
const onElevatorChange = async e => {
  elevatorIndex.value = Number(e.detail.value)
  elevatorTip.value = ''
  const target = elevators.value[elevatorIndex.value]
  if (!target) return
  try {
    const res = await checkElevatorOpen(target.elevatorId)
    if (!res.data.allowReport) {
      elevatorTip.value = `该电梯已有 ${res.data.openCount} 个未处理完的工单，请勿重复报修`
    }
  } catch (err) {
    // 预校验失败不阻塞提交，提交时后端仍会校验
  }
}

const loadCommunities = async () => {
  try {
    const res = await getCommunityList()
    communities.value = res.data || []
    // 已绑定小区的账号自动定位
    const boundName = userStore.userInfo && userStore.userInfo.communityName
    if (boundName) {
      const idx = communities.value.findIndex(item => item.communityName === boundName)
      if (idx >= 0) {
        communityIndex.value = idx
        await loadBuildings()
      }
    }
  } catch (e) {
    communities.value = []
  }
}

const loadBuildings = async () => {
  const target = communities.value[communityIndex.value]
  if (!target) return
  try {
    const res = await getBuildingList(target.communityId)
    buildings.value = res.data || []
  } catch (e) {
    buildings.value = []
  }
}

const loadElevators = async () => {
  const target = buildings.value[buildingIndex.value]
  if (!target) return
  try {
    const res = await getElevatorList({ buildingId: target.buildingId })
    elevators.value = res.data || []
  } catch (e) {
    elevators.value = []
  }
}

/** 选择并上传现场照片 */
const chooseImage = () => {
  if (uploading.value) return
  uni.chooseImage({
    count: 5 - evidenceList.value.length,
    sizeType: ['compressed'],
    success: async res => {
      uploading.value = true
      try {
        for (const path of res.tempFilePaths) {
          const uploaded = await uploadFile(path, EVIDENCE_BIZ_TYPE)
          evidenceList.value.push({
            fileId: uploaded.fileId,
            fileType: 'image',
            preview: path
          })
        }
      } catch (e) {
        // 错误提示已在请求层统一处理
      } finally {
        uploading.value = false
      }
    }
  })
}

const previewEvidence = index => {
  uni.previewImage({
    urls: evidenceList.value.map(item => item.preview),
    current: index
  })
}

const removeEvidence = index => {
  evidenceList.value.splice(index, 1)
}

const handleSubmit = async () => {
  const elevator = elevators.value[elevatorIndex.value]
  if (!elevator) {
    uni.showToast({ title: '请选择故障电梯', icon: 'none' })
    return
  }
  if (!form.faultDesc.trim() || form.faultDesc.trim().length < 5) {
    uni.showToast({ title: '故障描述至少 5 个字', icon: 'none' })
    return
  }
  if (elevatorTip.value) {
    uni.showToast({ title: elevatorTip.value, icon: 'none' })
    return
  }

  submitting.value = true
  try {
    const res = await submitReport({
      elevatorId: elevator.elevatorId,
      faultDesc: form.faultDesc.trim(),
      faultType: form.faultType,
      faultLevel: form.faultLevel,
      reporterPhone: form.reporterPhone,
      evidenceList: evidenceList.value.map(item => ({
        fileId: item.fileId,
        evidenceType: 'image'
      }))
    })
    const orderNo = (res.data && res.data.orderNo) || ''
    uni.showModal({
      title: '报修提交成功',
      content: `工单编号：${orderNo}\n物业将尽快审核并派单，可在报修进度中查看处理进展`,
      showCancel: false,
      confirmText: '查看进度',
      success: () => {
        uni.redirectTo({ url: '/pages/progress/list' })
      }
    })
  } catch (e) {
    // 错误提示已在请求层统一处理
  } finally {
    submitting.value = false
  }
}

onMounted(async () => {
  if (!userStore.isLogin) {
    uni.reLaunch({ url: '/pages/login/index' })
    return
  }
  await loadCommunities()
  await loadBuildings()
  await loadElevators()
})
</script>

<style scoped>
.input,
.picker-box {
  width: 100%;
  height: 88rpx;
  background: #f5f7fa;
  border-radius: 12rpx;
  padding: 0 24rpx;
  font-size: 28rpx;
  color: #303133;
  box-sizing: border-box;
}

.picker-box {
  display: flex;
  align-items: center;
  justify-content: space-between;
}

.picker-arrow {
  color: #98a1b0;
}

.textarea {
  width: 100%;
  height: 200rpx;
  background: #f5f7fa;
  border-radius: 12rpx;
  padding: 20rpx 24rpx;
  font-size: 28rpx;
  box-sizing: border-box;
}

.counter {
  display: block;
  text-align: right;
  font-size: 24rpx;
  color: #98a1b0;
  margin-top: 8rpx;
}

.chip-group {
  display: flex;
  flex-wrap: wrap;
}

.chip {
  padding: 14rpx 30rpx;
  margin: 0 16rpx 16rpx 0;
  border-radius: 40rpx;
  background: #f5f7fa;
  font-size: 26rpx;
  color: #6b7688;
}

.chip--active {
  background: #0b3d91;
  color: #ffffff;
}

.tip-muted {
  display: block;
  margin-top: 8rpx;
  font-size: 24rpx;
  color: #98a1b0;
}

.tip-warn {
  display: block;
  margin-top: 8rpx;
  font-size: 24rpx;
  color: #d98d12;
}

.photo-grid {
  display: flex;
  flex-wrap: wrap;
}

.photo-item {
  position: relative;
  width: 180rpx;
  height: 180rpx;
  margin: 0 20rpx 20rpx 0;
}

.photo {
  width: 100%;
  height: 100%;
  border-radius: 12rpx;
}

.photo-remove {
  position: absolute;
  top: -10rpx;
  right: -10rpx;
  width: 40rpx;
  height: 40rpx;
  border-radius: 20rpx;
  background: rgba(0, 0, 0, 0.6);
  display: flex;
  align-items: center;
  justify-content: center;
}

.photo-remove text {
  color: #ffffff;
  font-size: 28rpx;
  line-height: 28rpx;
}

.photo-add {
  width: 180rpx;
  height: 180rpx;
  border: 2rpx dashed #c6ccd6;
  border-radius: 12rpx;
  display: flex;
  flex-direction: column;
  align-items: center;
  justify-content: center;
}

.photo-add-icon {
  font-size: 48rpx;
  color: #98a1b0;
  line-height: 48rpx;
}

.photo-add-text {
  margin-top: 8rpx;
  font-size: 22rpx;
  color: #98a1b0;
}

.submit-btn {
  margin: 20rpx 0 40rpx;
}
</style>
