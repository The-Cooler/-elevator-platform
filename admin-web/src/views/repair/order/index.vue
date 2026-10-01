<template>
  <div class="app-container">
    <el-card shadow="never">
      <template #header>
        <div class="page-card-header">
          <span class="page-card-title">故障一键报修</span>
          <span class="page-card-desc">报修工单列表，支持查询、查看详情、驳回重审与导出</span>
        </div>
      </template>

      <el-form :model="queryParams" ref="queryRef" :inline="true" v-show="showSearch">
        <el-form-item label="工单编号" prop="orderNo">
          <el-input v-model="queryParams.orderNo" placeholder="请输入工单编号" clearable style="width: 180px" @keyup.enter="handleQuery" />
        </el-form-item>
        <el-form-item label="电梯编号" prop="elevatorCode">
          <el-input v-model="queryParams.elevatorCode" placeholder="请输入电梯编号" clearable style="width: 180px" @keyup.enter="handleQuery" />
        </el-form-item>
        <el-form-item label="工单状态" prop="orderStatus">
          <dict-select v-model="queryParams.orderStatus" dict-type="repair_order_status" placeholder="工单状态" width="180px" />
        </el-form-item>
        <el-form-item label="故障等级" prop="faultLevel">
          <dict-select v-model="queryParams.faultLevel" dict-type="fault_level" placeholder="故障等级" width="180px" />
        </el-form-item>
        <el-form-item label="故障类型" prop="faultType">
          <dict-select v-model="queryParams.faultType" dict-type="fault_type" placeholder="故障类型" width="180px" />
        </el-form-item>
        <el-form-item label="报修时间">
          <el-date-picker
            v-model="dateRange"
            value-format="YYYY-MM-DD"
            type="daterange"
            range-separator="-"
            start-placeholder="开始日期"
            end-placeholder="结束日期"
            style="width: 240px"
          />
        </el-form-item>
        <el-form-item>
          <el-button type="primary" icon="Search" @click="handleQuery">搜索</el-button>
          <el-button icon="Refresh" @click="resetQuery">重置</el-button>
        </el-form-item>
      </el-form>

      <el-row :gutter="10" class="mb8">
        <el-col :span="1.5">
          <el-button type="primary" plain icon="View" :disabled="single" @click="handleDetail" v-hasPermi="['repair:order:query']">详情</el-button>
        </el-col>
        <el-col :span="1.5">
          <el-button type="danger" plain icon="Close" :disabled="single" @click="handleReject" v-hasPermi="['repair:order:reject']">驳回重审</el-button>
        </el-col>
        <el-col :span="1.5">
          <el-button type="warning" plain icon="Download" @click="handleExport" v-hasPermi="['repair:order:export']">导出</el-button>
        </el-col>
        <right-toolbar v-model:showSearch="showSearch" @queryTable="getList"></right-toolbar>
      </el-row>

      <el-table v-loading="loading" :data="orderList" @selection-change="handleSelectionChange">
        <el-table-column type="selection" width="55" align="center" />
        <el-table-column label="工单编号" align="center" prop="orderNo" width="180" :show-overflow-tooltip="true" />
        <el-table-column label="电梯编号" align="center" prop="elevatorCode" width="130" />
        <el-table-column label="报修人" align="center" prop="reporterName" width="100" />
        <el-table-column label="故障现象" align="center" prop="faultDesc" :show-overflow-tooltip="true" />
        <el-table-column label="故障类型" align="center" prop="faultType" width="110">
          <template #default="scope">
            <dict-tag :options="fault_type" :value="scope.row.faultType" />
          </template>
        </el-table-column>
        <el-table-column label="故障等级" align="center" prop="faultLevel" width="100">
          <template #default="scope">
            <fault-level-tag :level="scope.row.faultLevel" />
          </template>
        </el-table-column>
        <el-table-column label="工单状态" align="center" prop="orderStatus" width="110">
          <template #default="scope">
            <order-status-tag :status="scope.row.orderStatus" />
          </template>
        </el-table-column>
        <el-table-column label="报修时间" align="center" prop="reportTime" width="170">
          <template #default="scope">
            <span>{{ parseTime(scope.row.reportTime, '{y}-{m}-{d} {h}:{i}:{s}') }}</span>
          </template>
        </el-table-column>
        <el-table-column label="操作" align="center" width="200" class-name="small-padding fixed-width">
          <template #default="scope">
            <el-button link type="primary" icon="View" @click="handleDetail(scope.row)" v-hasPermi="['repair:order:query']">详情</el-button>
            <el-button link type="primary" icon="Close" @click="handleReject(scope.row)" v-hasPermi="['repair:order:reject']">驳回</el-button>
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

    <!-- 工单详情 -->
    <el-drawer v-model="detailOpen" title="报修工单详情" size="52%">
      <el-descriptions :column="2" border v-if="detail.orderId">
        <el-descriptions-item label="工单编号">{{ detail.orderNo }}</el-descriptions-item>
        <el-descriptions-item label="工单状态">
          <order-status-tag :status="detail.orderStatus" />
        </el-descriptions-item>
        <el-descriptions-item label="故障等级">
          <fault-level-tag :level="detail.faultLevel" />
        </el-descriptions-item>
        <el-descriptions-item label="故障类型">
          <dict-tag :options="fault_type" :value="detail.faultType" />
        </el-descriptions-item>
        <el-descriptions-item label="电梯编号">{{ detail.elevatorCode || '-' }}</el-descriptions-item>
        <el-descriptions-item label="报修人">{{ detail.reporterName || '-' }}</el-descriptions-item>
        <el-descriptions-item label="报修电话">{{ detail.reporterPhone || '-' }}</el-descriptions-item>
        <el-descriptions-item label="报修时间">{{ parseTime(detail.reportTime, '{y}-{m}-{d} {h}:{i}:{s}') }}</el-descriptions-item>
        <el-descriptions-item label="维修员">{{ detail.assigneeName || '未派单' }}</el-descriptions-item>
        <el-descriptions-item label="处理时限">{{ parseTime(detail.deadlineTime, '{y}-{m}-{d} {h}:{i}:{s}') || '-' }}</el-descriptions-item>
        <el-descriptions-item label="故障现象" :span="2">{{ detail.faultDesc }}</el-descriptions-item>
        <el-descriptions-item label="驳回原因" :span="2" v-if="detail.rejectReason">{{ detail.rejectReason }}</el-descriptions-item>
      </el-descriptions>

      <el-divider content-position="left">现场证据附件</el-divider>
      <media-preview :file-ids="evidenceList" :show-caption="true" />

      <el-divider content-position="left">处理流程</el-divider>
      <el-timeline class="order-timeline">
        <el-timeline-item
          v-for="item in timeline"
          :key="item.logId"
          :timestamp="parseTime(item.operateTime, '{y}-{m}-{d} {h}:{i}:{s}')"
          placement="top"
        >
          <div class="timeline-title">{{ formatOperate(item) }}</div>
          <div class="timeline-desc">{{ item.operatorName || '-' }} · {{ item.remark || '无备注' }}</div>
        </el-timeline-item>
      </el-timeline>
    </el-drawer>

    <!-- 驳回 -->
    <el-dialog title="驳回报修单" v-model="rejectOpen" width="520px" append-to-body>
      <el-form ref="rejectRef" :model="rejectForm" :rules="rejectRules" label-width="90px">
        <el-form-item label="工单编号">
          <el-input v-model="rejectForm.orderNo" disabled />
        </el-form-item>
        <el-form-item label="驳回原因" prop="rejectReason">
          <el-input v-model="rejectForm.rejectReason" type="textarea" :rows="4" placeholder="请填写驳回原因，工单将回到业主处待补充" />
        </el-form-item>
      </el-form>
      <template #footer>
        <div class="dialog-footer">
          <el-button type="primary" @click="submitReject">确 定</el-button>
          <el-button @click="rejectOpen = false">取 消</el-button>
        </div>
      </template>
    </el-dialog>
  </div>
</template>

<script setup name="RepairOrder">
import {
  listRepairOrder, getRepairOrder, rejectOrder, exportRepairOrder, getOrderTimeline
} from '@/api/repair/order'
import { listEvidenceByOrder } from '@/api/repair/evidence'
import OrderStatusTag from '@/views/components/OrderStatusTag.vue'
import FaultLevelTag from '@/views/components/FaultLevelTag.vue'
import MediaPreview from '@/views/components/MediaPreview.vue'

const { proxy } = getCurrentInstance()
const { fault_type } = useDict('fault_type')

const orderList = ref([])
const evidenceList = ref([])
const timeline = ref([])
const loading = ref(true)
const showSearch = ref(true)
const ids = ref([])
const single = ref(true)
const total = ref(0)
const dateRange = ref([])
const detailOpen = ref(false)
const detail = ref({})
const rejectOpen = ref(false)

const OPERATE_LABEL = {
  report: '提交报修',
  reject: '驳回',
  assign: '派单',
  accept: '接单',
  arrive: '到场',
  investigate: '排查',
  finish: '维修完成',
  confirm: '业主确认',
  appeal: '申诉',
  reassign: '重新指派',
  escalate: '升级处理'
}

const data = reactive({
  queryParams: {
    pageNum: 1,
    pageSize: 10,
    orderNo: undefined,
    elevatorCode: undefined,
    orderStatus: undefined,
    faultLevel: undefined,
    faultType: undefined,
    beginTime: undefined,
    endTime: undefined
  },
  rejectForm: {},
  rejectRules: {
    rejectReason: [{ required: true, message: '驳回原因不能为空', trigger: 'blur' }]
  }
})

const { queryParams, rejectForm, rejectRules } = toRefs(data)

/** 查询工单列表 */
function getList() {
  loading.value = true
  const params = proxy.addDateRange(queryParams.value, dateRange.value)
  listRepairOrder(params).then(response => {
    orderList.value = response.rows
    total.value = response.total
    loading.value = false
  }).catch(() => {
    loading.value = false
  })
}

/** 搜索按钮操作 */
function handleQuery() {
  queryParams.value.pageNum = 1
  getList()
}

/** 重置按钮操作 */
function resetQuery() {
  dateRange.value = []
  proxy.resetForm('queryRef')
  handleQuery()
}

/** 多选框选中数据 */
function handleSelectionChange(selection) {
  ids.value = selection.map(item => item.orderId)
  single.value = selection.length != 1
}

/** 查看详情 */
function handleDetail(row) {
  const orderId = row && row.orderId ? row.orderId : ids.value[0]
  evidenceList.value = []
  timeline.value = []
  detail.value = {}
  detailOpen.value = true
  getRepairOrder(orderId).then(response => {
    detail.value = response.data || {}
  })
  listEvidenceByOrder(orderId).then(response => {
    const rows = response.rows || response.data || []
    evidenceList.value = rows.map(item => ({
      fileId: item.fileId,
      fileName: item.fileName,
      fileType: item.evidenceType || item.fileType || 'image'
    }))
  }).catch(() => {
    evidenceList.value = []
  })
  getOrderTimeline(orderId).then(response => {
    timeline.value = response.data || []
  }).catch(() => {
    timeline.value = []
  })
}

/** 流程节点标题 */
function formatOperate(item) {
  const label = OPERATE_LABEL[item.operateType] || item.operateType || '状态变更'
  const from = item.fromStatus || '无'
  const to = item.toStatus || '无'
  return label + '（' + from + ' → ' + to + '）'
}

/** 打开驳回框 */
function handleReject(row) {
  const target = row && row.orderId ? row : orderList.value.find(item => item.orderId === ids.value[0])
  if (!target) {
    proxy.$modal.msgWarning('请先选择一条工单')
    return
  }
  rejectForm.value = {
    orderId: target.orderId,
    orderNo: target.orderNo,
    rejectReason: undefined
  }
  rejectOpen.value = true
}

/** 提交驳回 */
function submitReject() {
  proxy.$refs['rejectRef'].validate(valid => {
    if (!valid) {
      return
    }
    rejectOrder(rejectForm.value).then(() => {
      proxy.$modal.msgSuccess('驳回成功')
      rejectOpen.value = false
      getList()
    })
  })
}

/** 导出 */
function handleExport() {
  const params = proxy.addDateRange(queryParams.value, dateRange.value)
  exportRepairOrder(params)
}

getList()
</script>

<style scoped lang="scss">
.timeline-title {
  font-size: 14px;
  font-weight: 600;
  color: #303133;
}

.timeline-desc {
  font-size: 12px;
  color: #909399;
  margin-top: 2px;
}
</style>
