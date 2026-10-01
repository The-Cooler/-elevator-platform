<template>
  <div class="app-container">
    <el-card shadow="never">
      <template #header>
        <div class="page-card-header">
          <span class="page-card-title">维保人员接单</span>
          <span class="page-card-desc">维修员确认接单并反馈预计到场时间，或拒绝接单让工单回到待派单池</span>
        </div>
      </template>

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
        <el-form-item label="工单状态" prop="orderStatus">
          <dict-select v-model="queryParams.orderStatus" dict-type="repair_order_status" placeholder="工单状态" width="170px" />
        </el-form-item>
        <el-form-item>
          <el-button type="primary" icon="Search" @click="handleQuery">搜索</el-button>
          <el-button icon="Refresh" @click="resetQuery">重置</el-button>
        </el-form-item>
      </el-form>

      <el-row :gutter="10" class="mb8">
        <el-col :span="1.5">
          <el-checkbox v-model="onlyMine" @change="handleQuery">只看指派给我的</el-checkbox>
        </el-col>
        <right-toolbar v-model:showSearch="showSearch" @queryTable="getList"></right-toolbar>
      </el-row>

      <el-table v-loading="loading" :data="orderList">
        <el-table-column label="工单编号" align="center" prop="orderNo" width="185" :show-overflow-tooltip="true" />
        <el-table-column label="工单状态" align="center" prop="orderStatus" width="110">
          <template #default="scope">
            <order-status-tag :status="scope.row.orderStatus" />
          </template>
        </el-table-column>
        <el-table-column label="故障等级" align="center" prop="faultLevel" width="100">
          <template #default="scope">
            <fault-level-tag :level="scope.row.faultLevel" />
          </template>
        </el-table-column>
        <el-table-column label="电梯编号" align="center" prop="elevatorCode" width="120" />
        <el-table-column label="电梯位置" align="center" width="200" :show-overflow-tooltip="true">
          <template #default="scope">
            {{ scope.row.communityName }} {{ scope.row.buildingNo }} {{ scope.row.unitNo }}
          </template>
        </el-table-column>
        <el-table-column label="故障现象" align="center" prop="faultDesc" :show-overflow-tooltip="true" min-width="180" />
        <el-table-column label="维修员" align="center" prop="assigneeName" width="110" />
        <el-table-column label="派单时间" align="center" prop="assignTime" width="165" />
        <el-table-column label="接单时间" align="center" prop="acceptTime" width="165" />
        <el-table-column label="操作" align="center" width="160" fixed="right">
          <template #default="scope">
            <el-button
              v-if="scope.row.orderStatus === 'assigned'"
              link
              type="primary"
              icon="Check"
              @click="handleConfirm(scope.row)"
              v-hasPermi="['order:accept:confirm']"
            >接单</el-button>
            <el-button
              v-if="scope.row.orderStatus === 'assigned'"
              link
              type="danger"
              icon="Close"
              @click="handleRefuse(scope.row)"
              v-hasPermi="['order:accept:confirm']"
            >拒单</el-button>
            <el-button
              v-if="scope.row.orderStatus !== 'assigned'"
              link
              type="info"
              icon="View"
              @click="handleDetail(scope.row)"
            >详情</el-button>
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

    <!-- 接单弹窗，填写预计到场时间 -->
    <el-dialog v-model="acceptOpen" title="确认接单" width="520px" append-to-body destroy-on-close>
      <el-form ref="acceptRef" :model="acceptForm" :rules="acceptRules" label-width="110px">
        <el-form-item label="工单编号">
          <span>{{ acceptForm.orderNo }}</span>
        </el-form-item>
        <el-form-item label="预计到场" prop="arriveMinutes">
          <el-radio-group v-model="acceptForm.arriveMinutes">
            <el-radio-button :value="15">15 分钟</el-radio-button>
            <el-radio-button :value="30">30 分钟</el-radio-button>
            <el-radio-button :value="60">1 小时</el-radio-button>
            <el-radio-button :value="120">2 小时</el-radio-button>
          </el-radio-group>
        </el-form-item>
        <el-form-item label="自定义分钟">
          <el-input-number v-model="acceptForm.arriveMinutes" :min="1" :max="1440" controls-position="right" />
          <span class="form-tip">接单后向业主推送预计到场时间</span>
        </el-form-item>
      </el-form>
      <template #footer>
        <div class="dialog-footer">
          <el-button @click="acceptOpen = false">取消</el-button>
          <el-button type="primary" :loading="submitting" @click="submitAccept">确认接单</el-button>
        </div>
      </template>
    </el-dialog>

    <!-- 工单详情 -->
    <el-dialog v-model="detailOpen" title="工单详情" width="760px" append-to-body destroy-on-close>
      <el-descriptions :column="2" border v-if="currentOrder">
        <el-descriptions-item label="工单编号">{{ currentOrder.orderNo }}</el-descriptions-item>
        <el-descriptions-item label="工单状态">
          <order-status-tag :status="currentOrder.orderStatus" />
        </el-descriptions-item>
        <el-descriptions-item label="电梯编号">{{ currentOrder.elevatorCode }}</el-descriptions-item>
        <el-descriptions-item label="故障等级">
          <fault-level-tag :level="currentOrder.faultLevel" />
        </el-descriptions-item>
        <el-descriptions-item label="电梯位置" :span="2">
          {{ currentOrder.communityName }} {{ currentOrder.buildingNo }} {{ currentOrder.unitNo }}
        </el-descriptions-item>
        <el-descriptions-item label="故障现象" :span="2">{{ currentOrder.faultDesc }}</el-descriptions-item>
        <el-descriptions-item label="报修人">{{ currentOrder.reporterName }}</el-descriptions-item>
        <el-descriptions-item label="联系电话">{{ currentOrder.reporterPhoneNo }}</el-descriptions-item>
        <el-descriptions-item label="报修时间">{{ currentOrder.reportTime }}</el-descriptions-item>
        <el-descriptions-item label="派单时间">{{ currentOrder.assignTime || '—' }}</el-descriptions-item>
        <el-descriptions-item label="接单时间">{{ currentOrder.acceptTime || '—' }}</el-descriptions-item>
        <el-descriptions-item label="维修员">{{ currentOrder.assigneeName || '—' }}</el-descriptions-item>
      </el-descriptions>

      <div class="evidence-block" v-if="evidenceList.length">
        <p class="evidence-title">业主上传的现场证据</p>
        <media-preview :file-ids="evidenceList" show-caption />
      </div>
      <p v-else class="evidence-empty">该工单没有上传现场证据</p>
    </el-dialog>
  </div>
</template>

<script setup name="Accept">
import { ref, reactive, toRefs, getCurrentInstance } from 'vue'
import { listMyAccept, listAccept, getAcceptOrder, confirmAccept, refuseAccept } from '@/api/order/accept'
import { listEvidenceByOrder } from '@/api/repair/evidence'
import DictSelect from '@/views/components/DictSelect.vue'
import OrderStatusTag from '@/views/components/OrderStatusTag.vue'
import FaultLevelTag from '@/views/components/FaultLevelTag.vue'
import MediaPreview from '@/views/components/MediaPreview.vue'

const { proxy } = getCurrentInstance()

const loading = ref(true)
const showSearch = ref(true)
const orderList = ref([])
const total = ref(0)
const onlyMine = ref(true)

const acceptOpen = ref(false)
const detailOpen = ref(false)
const submitting = ref(false)
const currentOrder = ref(null)
const evidenceList = ref([])

const data = reactive({
  queryParams: {
    pageNum: 1,
    pageSize: 10,
    orderNo: undefined,
    elevatorCode: undefined,
    orderStatus: undefined
  },
  acceptForm: {
    orderId: undefined,
    orderNo: '',
    arriveMinutes: 30
  },
  acceptRules: {
    arriveMinutes: [{ required: true, message: '请选择预计到场时间', trigger: 'change' }]
  }
})
const { queryParams, acceptForm, acceptRules } = toRefs(data)

/** 查询接单列表，onlyMine 为真时只查指派给当前登录维修员的工单 */
function getList() {
  loading.value = true
  const request = onlyMine.value ? listMyAccept : listAccept
  request(queryParams.value)
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

/** 打开接单弹窗 */
function handleConfirm(row) {
  acceptForm.value = {
    orderId: row.orderId,
    orderNo: row.orderNo,
    arriveMinutes: 30
  }
  acceptOpen.value = true
}

function submitAccept() {
  proxy.$refs['acceptRef'].validate(valid => {
    if (!valid) return
    submitting.value = true
    confirmAccept({
      orderId: acceptForm.value.orderId,
      arriveMinutes: acceptForm.value.arriveMinutes
    })
      .then(() => {
        proxy.$modal.msgSuccess('接单成功')
        acceptOpen.value = false
        getList()
      })
      .finally(() => {
        submitting.value = false
      })
  })
}

/** 拒绝接单，填写原因后工单回到待派单池 */
function handleRefuse(row) {
  proxy
    .$prompt('请输入拒单原因', '拒绝接单', {
      confirmButtonText: '确定',
      cancelButtonText: '取消',
      inputPattern: /\S+/,
      inputErrorMessage: '拒单原因不能为空'
    })
    .then(({ value }) => refuseAccept({ orderId: row.orderId, remark: value }))
    .then(() => {
      proxy.$modal.msgSuccess('已拒单，工单回到待派单池')
      getList()
    })
    .catch(() => {})
}

/** 查看工单详情与业主上传的证据 */
function handleDetail(row) {
  currentOrder.value = row
  evidenceList.value = []
  detailOpen.value = true
  listEvidenceByOrder(row.orderId)
    .then(response => {
      evidenceList.value = response.data || []
    })
    .catch(() => {
      evidenceList.value = []
    })
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
.form-tip {
  margin-left: 12px;
  font-size: 13px;
  color: #909399;
}
.evidence-block {
  margin-top: 20px;
}
.evidence-title {
  margin-bottom: 12px;
  font-size: 14px;
  font-weight: 600;
  color: #303133;
}
.evidence-empty {
  margin-top: 20px;
  font-size: 13px;
  color: #909399;
}
</style>
