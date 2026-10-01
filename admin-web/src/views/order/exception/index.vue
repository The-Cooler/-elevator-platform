<template>
  <div class="app-container">
    <el-card shadow="never">
      <template #header>
        <div class="page-card-header">
          <span class="page-card-title">工单异常处理</span>
          <span class="page-card-desc">
            系统按预警规则识别超时未处理的工单，物业可重新指派、驳回重审，维修员可上报现场无法修复的异常
          </span>
        </div>
      </template>

      <!-- 异常统计 -->
      <el-row :gutter="16" class="mb16">
        <el-col :span="6" v-for="item in statistics" :key="item.exceptionType">
          <div class="stat-card" :class="{ 'stat-card--active': queryParams.exceptionType === item.exceptionType }"
               @click="handleTypeFilter(item.exceptionType)">
            <p class="stat-label">{{ item.exceptionTypeName }}</p>
            <p class="stat-value" :class="{ 'stat-value--warn': item.count > 0 }">{{ item.count }}</p>
          </div>
        </el-col>
      </el-row>

      <el-form :model="queryParams" ref="queryRef" :inline="true" v-show="showSearch">
        <el-form-item label="电梯编号" prop="elevatorCode">
          <el-input
            v-model="queryParams.elevatorCode"
            placeholder="请输入电梯编号"
            clearable
            style="width: 180px"
            @keyup.enter="getList"
          />
        </el-form-item>
        <el-form-item label="小区" prop="communityId">
          <el-select v-model="queryParams.communityId" placeholder="请选择小区" clearable style="width: 200px">
            <el-option
              v-for="item in communityList"
              :key="item.communityId"
              :label="item.communityName"
              :value="item.communityId"
            />
          </el-select>
        </el-form-item>
        <el-form-item>
          <el-button type="primary" icon="Search" @click="handleQuery">搜索</el-button>
          <el-button icon="Refresh" @click="resetQuery">重置</el-button>
        </el-form-item>
      </el-form>

      <el-table v-loading="loading" :data="exceptionList">
        <el-table-column label="异常类型" align="center" prop="exceptionTypeName" width="110">
          <template #default="scope">
            <el-tag type="danger" size="small">{{ scope.row.exceptionTypeName }}</el-tag>
          </template>
        </el-table-column>
        <el-table-column label="已超时" align="center" width="110">
          <template #default="scope">
            <span class="timeout-text">{{ formatTimeout(scope.row.timeoutMinutes) }}</span>
          </template>
        </el-table-column>
        <el-table-column label="工单编号" align="center" prop="orderNo" width="185" :show-overflow-tooltip="true" />
        <el-table-column label="当前状态" align="center" prop="orderStatusName" width="100" />
        <el-table-column label="故障等级" align="center" prop="faultLevel" width="95">
          <template #default="scope">
            <fault-level-tag :level="scope.row.faultLevel" />
          </template>
        </el-table-column>
        <el-table-column label="电梯编号" align="center" prop="elevatorCode" width="115" />
        <el-table-column label="电梯位置" align="center" width="190" :show-overflow-tooltip="true">
          <template #default="scope">
            {{ scope.row.communityName }} {{ scope.row.buildingNo }} {{ scope.row.unitNo }}
          </template>
        </el-table-column>
        <el-table-column label="故障现象" align="center" prop="faultDesc" :show-overflow-tooltip="true" min-width="160" />
        <el-table-column label="维修员" align="center" prop="assigneeName" width="110" />
        <el-table-column label="报修时间" align="center" prop="reportTime" width="165" />
        <el-table-column label="操作" align="center" width="230" fixed="right">
          <template #default="scope">
            <el-button
              link
              type="primary"
              icon="UserFilled"
              @click="handleReassign(scope.row)"
              v-hasPermi="['order:exception:edit']"
            >重新指派</el-button>
            <el-button
              link
              type="warning"
              icon="Close"
              @click="handleReject(scope.row)"
              v-hasPermi="['order:exception:edit']"
            >驳回</el-button>
            <el-button
              link
              type="danger"
              icon="Top"
              @click="handleEscalate(scope.row)"
              v-hasPermi="['order:exception:edit']"
            >升级</el-button>
          </template>
        </el-table-column>
      </el-table>

      <el-empty v-if="!loading && !exceptionList.length" description="暂无异常工单，各工单均在时限内正常流转" />
    </el-card>

    <!-- 重新指派 -->
    <el-dialog v-model="reassignOpen" title="重新指派" width="760px" append-to-body destroy-on-close>
      <el-alert
        v-if="currentRow"
        type="warning"
        :closable="false"
        show-icon
        class="mb20"
        :title="`工单 ${currentRow.orderNo} ${currentRow.exceptionTypeName}，已超时 ${formatTimeout(currentRow.timeoutMinutes)}`"
      />
      <el-form label-width="100px">
        <el-form-item label="改派原因">
          <el-input
            v-model="reassignRemark"
            type="textarea"
            :rows="2"
            maxlength="500"
            placeholder="填写改派原因，如：原维修员接单后未及时到场"
          />
        </el-form-item>
      </el-form>

      <p class="dialog-tip">选择新的维修员，推荐结果按区域与技能匹配度排序</p>
      <el-table :data="workerList" v-loading="workerLoading" highlight-current-row @current-change="handleWorkerSelect">
        <el-table-column width="50" align="center">
          <template #default="scope">
            <el-radio :model-value="selectedWorkerId" :value="scope.row.workerId" @change="selectedWorkerId = scope.row.workerId">
              <span></span>
            </el-radio>
          </template>
        </el-table-column>
        <el-table-column label="维修员" align="center" prop="workerName" width="120" />
        <el-table-column label="联系电话" align="center" prop="workerPhone" width="130" />
        <el-table-column label="负责小区" align="center" prop="communityName" width="150" />
        <el-table-column label="技能标签" align="center" prop="skillTags" :show-overflow-tooltip="true" min-width="180" />
        <el-table-column label="在手工单" align="center" prop="currentLoad" width="100" />
        <el-table-column label="匹配度" align="center" prop="matchScore" width="90" sortable />
      </el-table>

      <template #footer>
        <div class="dialog-footer">
          <el-button @click="reassignOpen = false">取消</el-button>
          <el-button type="primary" :disabled="!selectedWorkerId" :loading="submitting" @click="submitReassign">
            确认改派
          </el-button>
        </div>
      </template>
    </el-dialog>
  </div>
</template>

<script setup name="Exception">
import { ref, reactive, toRefs, getCurrentInstance } from 'vue'
import {
  listException,
  reassignException,
  rejectException,
  escalateException,
  exceptionStatistics
} from '@/api/order/exception'
import { recommendWorker } from '@/api/order/dispatch'
import { listCommunity } from '@/api/basic/community'
import FaultLevelTag from '@/views/components/FaultLevelTag.vue'

const { proxy } = getCurrentInstance()

const loading = ref(true)
const showSearch = ref(true)
const submitting = ref(false)
const exceptionList = ref([])
const statistics = ref([])
const communityList = ref([])

const reassignOpen = ref(false)
const workerLoading = ref(false)
const workerList = ref([])
const selectedWorkerId = ref(null)
const reassignRemark = ref('')
const currentRow = ref(null)

const data = reactive({
  queryParams: {
    elevatorCode: undefined,
    communityId: undefined,
    exceptionType: undefined
  }
})
const { queryParams } = toRefs(data)

/** 查询异常工单列表 */
function getList() {
  loading.value = true
  listException(queryParams.value)
    .then(response => {
      exceptionList.value = response.data || []
    })
    .finally(() => {
      loading.value = false
    })
}

/** 查询四类异常的数量统计 */
function getStatistics() {
  exceptionStatistics()
    .then(response => {
      statistics.value = response.data || []
    })
    .catch(() => {
      statistics.value = []
    })
}

/** 点击统计卡片按异常类型筛选 */
function handleTypeFilter(type) {
  queryParams.value.exceptionType = queryParams.value.exceptionType === type ? undefined : type
  getList()
}

function handleQuery() {
  getList()
}

function resetQuery() {
  proxy.resetForm('queryRef')
  queryParams.value.exceptionType = undefined
  getList()
}

/** 超时时长格式化 */
function formatTimeout(minutes) {
  if (!minutes && minutes !== 0) return '—'
  if (minutes < 60) return `${minutes} 分钟`
  if (minutes < 1440) return `${Math.floor(minutes / 60)} 小时 ${minutes % 60} 分钟`
  return `${Math.floor(minutes / 1440)} 天 ${Math.floor((minutes % 1440) / 60)} 小时`
}

/** 打开重新指派弹窗并加载推荐维修员 */
function handleReassign(row) {
  currentRow.value = row
  selectedWorkerId.value = null
  reassignRemark.value = ''
  workerList.value = []
  reassignOpen.value = true
  workerLoading.value = true
  recommendWorker(row.orderId)
    .then(response => {
      workerList.value = (response.data || []).filter(w => w.workerId !== row.assigneeId)
    })
    .finally(() => {
      workerLoading.value = false
    })
}

function handleWorkerSelect(row) {
  if (row) {
    selectedWorkerId.value = row.workerId
  }
}

function submitReassign() {
  if (!selectedWorkerId.value) {
    proxy.$modal.msgWarning('请选择新的维修员')
    return
  }
  submitting.value = true
  reassignException({
    orderId: currentRow.value.orderId,
    assigneeId: selectedWorkerId.value,
    remark: reassignRemark.value
  })
    .then(() => {
      proxy.$modal.msgSuccess('已重新指派')
      reassignOpen.value = false
      getList()
      getStatistics()
    })
    .finally(() => {
      submitting.value = false
    })
}

/** 驳回重审 */
function handleReject(row) {
  proxy
    .$prompt('请输入驳回原因', '驳回重审', {
      confirmButtonText: '确定',
      cancelButtonText: '取消',
      inputPattern: /\S+/,
      inputErrorMessage: '驳回原因不能为空'
    })
    .then(({ value }) => rejectException({ orderId: row.orderId, rejectReason: value }))
    .then(() => {
      proxy.$modal.msgSuccess('已驳回')
      getList()
      getStatistics()
    })
    .catch(() => {})
}

/** 升级为紧急处理 */
function handleEscalate(row) {
  proxy
    .$prompt('请输入升级说明', '升级处理', {
      confirmButtonText: '确定',
      cancelButtonText: '取消',
      inputPlaceholder: '如：故障影响面较大，需优先处理'
    })
    .then(({ value }) => escalateException({ orderId: row.orderId, remark: value }))
    .then(() => {
      proxy.$modal.msgSuccess('已升级为紧急处理')
      getList()
    })
    .catch(() => {})
}

/** 加载小区列表供筛选 */
function getCommunityList() {
  listCommunity({ pageNum: 1, pageSize: 200 })
    .then(response => {
      communityList.value = response.rows || []
    })
    .catch(() => {
      communityList.value = []
    })
}

getList()
getStatistics()
getCommunityList()
</script>

<style scoped>
.page-card-header {
  display: flex;
  flex-direction: column;
  gap: 4px;
}
.page-card-title {
  font-size: 16px;
  font-weight: 600;
  color: #303133;
}
.page-card-desc {
  font-size: 13px;
  color: #909399;
}
.mb16 {
  margin-bottom: 16px;
}
.mb20 {
  margin-bottom: 16px;
}
.stat-card {
  padding: 16px 20px;
  border: 1px solid #ebeef5;
  border-radius: 8px;
  cursor: pointer;
  transition: all 0.2s;
  background: #fff;
}
.stat-card:hover {
  border-color: #c6e2ff;
  box-shadow: 0 2px 12px rgba(0, 0, 0, 0.06);
}
.stat-card--active {
  border-color: #409eff;
  background: #ecf5ff;
}
.stat-label {
  font-size: 13px;
  color: #909399;
}
.stat-value {
  margin-top: 8px;
  font-size: 26px;
  font-weight: 600;
  color: #303133;
}
.stat-value--warn {
  color: #f56c6c;
}
.timeout-text {
  color: #f56c6c;
  font-weight: 500;
}
.dialog-tip {
  margin-bottom: 12px;
  font-size: 13px;
  color: #909399;
}
</style>
