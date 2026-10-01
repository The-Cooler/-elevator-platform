<template>
  <div class="app-container">
    <el-card shadow="never">
      <template #header>
        <div class="page-card-header">
          <span class="page-card-title">智能派单</span>
          <span class="page-card-desc">审核报修单后按区域与技能匹配合适的维修员，确认派单后通知维修员接单</span>
        </div>
      </template>

      <!-- 查询条件 -->
      <el-form :model="queryParams" ref="queryRef" :inline="true" v-show="showSearch">
        <el-form-item label="工单编号" prop="orderNo">
          <el-input
            v-model="queryParams.orderNo"
            placeholder="请输入工单编号"
            clearable
            style="width: 180px"
            @keyup.enter="handleQuery"
          />
        </el-form-item>
        <el-form-item label="电梯编号" prop="elevatorCode">
          <el-input
            v-model="queryParams.elevatorCode"
            placeholder="请输入电梯编号"
            clearable
            style="width: 180px"
            @keyup.enter="handleQuery"
          />
        </el-form-item>
        <el-form-item label="故障等级" prop="faultLevel">
          <dict-select v-model="queryParams.faultLevel" dict-type="fault_level" placeholder="故障等级" width="160px" />
        </el-form-item>
        <el-form-item>
          <el-button type="primary" icon="Search" @click="handleQuery">搜索</el-button>
          <el-button icon="Refresh" @click="resetQuery">重置</el-button>
        </el-form-item>
      </el-form>

      <el-row :gutter="10" class="mb8">
        <el-col :span="1.5">
          <el-button
            type="primary"
            plain
            icon="User"
            :disabled="single"
            @click="handleAssign()"
            v-hasPermi="['order:dispatch:assign']"
          >派单</el-button>
        </el-col>
        <el-col :span="1.5">
          <el-button
            type="warning"
            plain
            icon="Close"
            :disabled="single"
            @click="handleReject"
            v-hasPermi="['order:dispatch:assign']"
          >驳回重审</el-button>
        </el-col>
        <el-col :span="1.5">
          <el-button
            type="danger"
            plain
            icon="UserFilled"
            :disabled="multiple"
            @click="handleBatchAssign"
            v-hasPermi="['order:dispatch:assign']"
          >批量派单</el-button>
        </el-col>
        <right-toolbar v-model:showSearch="showSearch" @queryTable="getList"></right-toolbar>
      </el-row>

      <!-- 待派单工单池 -->
      <el-table v-loading="loading" :data="orderList" @selection-change="handleSelectionChange">
        <el-table-column type="selection" width="55" align="center" />
        <el-table-column label="工单编号" align="center" prop="orderNo" width="185" :show-overflow-tooltip="true" />
        <el-table-column label="故障等级" align="center" prop="faultLevel" width="100">
          <template #default="scope">
            <fault-level-tag :level="scope.row.faultLevel" />
          </template>
        </el-table-column>
        <el-table-column label="电梯编号" align="center" prop="elevatorCode" width="120" />
        <el-table-column label="电梯位置" align="center" width="220" :show-overflow-tooltip="true">
          <template #default="scope">
            {{ scope.row.communityName }} {{ scope.row.buildingNo }} {{ scope.row.unitNo }}
          </template>
        </el-table-column>
        <el-table-column label="故障现象" align="center" prop="faultDesc" :show-overflow-tooltip="true" min-width="180" />
        <el-table-column label="报修人" align="center" prop="reporterName" width="100" />
        <el-table-column label="联系电话" align="center" prop="reporterPhoneNo" width="130" />
        <el-table-column label="报修时间" align="center" prop="reportTime" width="165" />
        <el-table-column label="操作" align="center" width="150" fixed="right">
          <template #default="scope">
            <el-button
              link
              type="primary"
              icon="User"
              @click="handleAssign(scope.row)"
              v-hasPermi="['order:dispatch:assign']"
            >派单</el-button>
            <el-button
              link
              type="warning"
              icon="Close"
              @click="handleReject(scope.row)"
              v-hasPermi="['order:dispatch:assign']"
            >驳回</el-button>
          </template>
        </el-table-column>
      </el-table>

      <pagination
        v-show="total > 0"
        :total="total"
        v-model:page="queryParams.pageNum"
        v-model:limit="queryParams.pageSize"
        @pagination="getList"
      />
    </el-card>

    <!-- 派单弹窗，展示推荐维修员列表 -->
    <el-dialog v-model="assignOpen" :title="assignTitle" width="900px" append-to-body destroy-on-close>
      <div v-loading="recommendLoading">
        <el-alert
          v-if="currentOrder"
          type="info"
          :closable="false"
          show-icon
          class="mb20"
        >
          <template #title>
            工单 {{ currentOrder.orderNo }}｜{{ currentOrder.elevatorCode }}｜{{ currentOrder.faultDesc }}
          </template>
        </el-alert>

        <p class="dispatch-tip">
          推荐结果按匹配度排序，综合考虑负责区域、技能匹配、在手工单数与平均响应时长
        </p>

        <el-table :data="workerList" highlight-current-row @current-change="handleWorkerSelect">
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
          <el-table-column label="技能匹配" align="center" width="100">
            <template #default="scope">
              <el-tag v-if="scope.row.skillMatched" type="success" size="small">匹配</el-tag>
              <el-tag v-else type="info" size="small">未匹配</el-tag>
            </template>
          </el-table-column>
          <el-table-column label="在手工单" align="center" prop="currentLoad" width="100" />
          <el-table-column label="累计完成" align="center" prop="totalFinished" width="100" />
          <el-table-column label="平均响应" align="center" width="110">
            <template #default="scope">
              {{ scope.row.avgResponse ? `${scope.row.avgResponse} 分钟` : '—' }}
            </template>
          </el-table-column>
          <el-table-column label="匹配度" align="center" prop="matchScore" width="90" sortable />
        </el-table>

        <el-empty v-if="!recommendLoading && !workerList.length" description="当前小区暂无在岗维修员，可在下方手动指定" />
      </div>

      <template #footer>
        <div class="dialog-footer">
          <el-button @click="assignOpen = false">取消</el-button>
          <el-button type="primary" :disabled="!selectedWorkerId" :loading="submitting" @click="submitAssign">
            确认派单
          </el-button>
        </div>
      </template>
    </el-dialog>
  </div>
</template>

<script setup name="Dispatch">
import { ref, reactive, toRefs, getCurrentInstance } from 'vue'
import {
  listPendingDispatch,
  recommendWorker,
  assignOrder,
  batchAssignOrder,
  rejectDispatch
} from '@/api/order/dispatch'
import DictSelect from '@/views/components/DictSelect.vue'
import FaultLevelTag from '@/views/components/FaultLevelTag.vue'

const { proxy } = getCurrentInstance()

const loading = ref(true)
const showSearch = ref(true)
const orderList = ref([])
const total = ref(0)
const ids = ref([])
const single = ref(true)
const multiple = ref(true)

const assignOpen = ref(false)
const assignTitle = ref('智能派单')
const recommendLoading = ref(false)
const submitting = ref(false)
const workerList = ref([])
const currentOrder = ref(null)
const selectedWorkerId = ref(null)
const batchOrderIds = ref([])

const data = reactive({
  queryParams: {
    pageNum: 1,
    pageSize: 10,
    orderNo: undefined,
    elevatorCode: undefined,
    faultLevel: undefined
  }
})
const { queryParams } = toRefs(data)

/** 查询待派单工单池 */
function getList() {
  loading.value = true
  listPendingDispatch(queryParams.value)
    .then(response => {
      orderList.value = response.rows
      total.value = response.total
    })
    .finally(() => {
      loading.value = false
    })
}

function handleQuery() {
  queryParams.value.pageNum = 1
  getList()
}

function resetQuery() {
  proxy.resetForm('queryRef')
  handleQuery()
}

function handleSelectionChange(selection) {
  ids.value = selection.map(item => item.orderId)
  single.value = selection.length !== 1
  multiple.value = !selection.length
}

/** 打开派单弹窗，加载推荐维修员 */
function handleAssign(row) {
  if (row) {
    currentOrder.value = row
    batchOrderIds.value = [row.orderId]
  } else {
    const selected = orderList.value.filter(item => ids.value.includes(item.orderId))
    currentOrder.value = selected[0]
    batchOrderIds.value = ids.value.slice()
  }
  if (!currentOrder.value) return

  selectedWorkerId.value = null
  workerList.value = []
  assignTitle.value = batchOrderIds.value.length > 1
    ? `批量派单（共 ${batchOrderIds.value.length} 个工单）`
    : `派单 - ${currentOrder.value.orderNo}`
  assignOpen.value = true
  recommendLoading.value = true
  recommendWorker(currentOrder.value.orderId)
    .then(response => {
      workerList.value = response.data || []
    })
    .finally(() => {
      recommendLoading.value = false
    })
}

function handleWorkerSelect(row) {
  if (row) {
    selectedWorkerId.value = row.workerId
  }
}

/** 批量派单，先选维修员 */
function handleBatchAssign() {
  if (!ids.value.length) {
    proxy.$modal.msgWarning('请先勾选需要派单的工单')
    return
  }
  handleAssign()
}

/** 提交派单 */
function submitAssign() {
  if (!selectedWorkerId.value) {
    proxy.$modal.msgWarning('请选择维修员')
    return
  }
  submitting.value = true
  const request = batchOrderIds.value.length > 1
    ? batchAssignOrder({ orderIds: batchOrderIds.value, assigneeId: selectedWorkerId.value })
    : assignOrder({ orderId: batchOrderIds.value[0], assigneeId: selectedWorkerId.value })

  request
    .then(() => {
      proxy.$modal.msgSuccess('派单成功')
      assignOpen.value = false
      getList()
    })
    .finally(() => {
      submitting.value = false
    })
}

/** 驳回报修单，工单回到业主处待补充 */
function handleReject(row) {
  const orderIds = row ? [row.orderId] : ids.value
  if (!orderIds.length) {
    proxy.$modal.msgWarning('请选择需要驳回的工单')
    return
  }
  proxy
    .$prompt('请输入驳回原因', '驳回重审', {
      confirmButtonText: '确定',
      cancelButtonText: '取消',
      inputPattern: /\S+/,
      inputErrorMessage: '驳回原因不能为空'
    })
    .then(({ value }) => {
      const tasks = orderIds.map(orderId => rejectDispatch({ orderId, rejectReason: value }))
      return Promise.all(tasks)
    })
    .then(() => {
      proxy.$modal.msgSuccess('已驳回')
      getList()
    })
    .catch(() => {})
}

getList()
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
.dispatch-tip {
  margin-bottom: 12px;
  font-size: 13px;
  color: #909399;
}
.mb20 {
  margin-bottom: 16px;
}
</style>
