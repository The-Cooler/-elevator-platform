<template>
  <div class="app-container">
    <el-card shadow="never">
      <template #header>
        <div class="page-card-header">
          <span class="page-card-title">维修过程管理</span>
          <span class="page-card-desc">
            维修员依次推进工单状态：已接单 → 已到场 → 维修中 → 已修复，完成后提交处理说明等待业主确认
          </span>
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
        <el-form-item label="工单状态" prop="orderStatus">
          <dict-select v-model="queryParams.orderStatus" dict-type="repair_order_status" placeholder="工单状态" width="170px" />
        </el-form-item>
        <el-form-item>
          <el-button type="primary" icon="Search" @click="handleQuery">搜索</el-button>
          <el-button icon="Refresh" @click="resetQuery">重置</el-button>
        </el-form-item>
      </el-form>

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
        <el-table-column label="故障现象" align="center" prop="faultDesc" :show-overflow-tooltip="true" min-width="180" />
        <el-table-column label="报修人" align="center" prop="reporterName" width="100" />
        <el-table-column label="接单时间" align="center" prop="acceptTime" width="165" />
        <el-table-column label="到场时间" align="center" prop="arriveTime" width="165" />
        <el-table-column label="操作" align="center" width="220" fixed="right">
          <template #default="scope">
            <el-button
              v-if="scope.row.orderStatus === 'accepted'"
              link
              type="primary"
              icon="Location"
              @click="handleArrive(scope.row)"
              v-hasPermi="['order:process:edit']"
            >到场</el-button>
            <el-button
              v-if="scope.row.orderStatus === 'arrived'"
              link
              type="primary"
              icon="Search"
              @click="handleInvestigate(scope.row)"
              v-hasPermi="['order:process:edit']"
            >排查</el-button>
            <el-button
              v-if="scope.row.orderStatus === 'repairing'"
              link
              type="success"
              icon="Check"
              @click="handleFinish(scope.row)"
              v-hasPermi="['order:process:edit']"
            >完工</el-button>
            <el-button link type="info" icon="View" @click="handleRecord(scope.row)">维修记录</el-button>
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

    <!-- 到场登记 -->
    <el-dialog v-model="arriveOpen" title="登记到场" width="520px" append-to-body destroy-on-close>
      <el-form :model="arriveForm" label-width="100px">
        <el-form-item label="工单编号">
          <span>{{ arriveForm.orderNo }}</span>
        </el-form-item>
        <el-form-item label="到场定位" prop="arriveLocation">
          <el-input v-model="arriveForm.arriveLocation" placeholder="如：阳光家园小区1号楼1单元" />
          <span class="form-tip">可结合定位记录实际到场位置，作为到场凭证</span>
        </el-form-item>
      </el-form>
      <template #footer>
        <div class="dialog-footer">
          <el-button @click="arriveOpen = false">取消</el-button>
          <el-button type="primary" :loading="submitting" @click="submitArrive">确认到场</el-button>
        </div>
      </template>
    </el-dialog>

    <!-- 排查记录 -->
    <el-dialog v-model="investigateOpen" title="填写排查记录" width="560px" append-to-body destroy-on-close>
      <el-form :model="investigateForm" label-width="100px">
        <el-form-item label="工单编号">
          <span>{{ investigateForm.orderNo }}</span>
        </el-form-item>
        <el-form-item label="排查记录">
          <el-input
            v-model="investigateForm.investigateNote"
            type="textarea"
            :rows="5"
            maxlength="1000"
            show-word-limit
            placeholder="记录排查过程与初步判断，如：检查发现导轨润滑不足，导靴有轻微磨损"
          />
        </el-form-item>
      </el-form>
      <template #footer>
        <div class="dialog-footer">
          <el-button @click="investigateOpen = false">取消</el-button>
          <el-button type="primary" :loading="submitting" @click="submitInvestigate">提交并进入维修中</el-button>
        </div>
      </template>
    </el-dialog>

    <!-- 完工提交 -->
    <el-dialog v-model="finishOpen" title="提交完工信息" width="620px" append-to-body destroy-on-close>
      <el-form ref="finishRef" :model="finishForm" :rules="finishRules" label-width="110px">
        <el-form-item label="工单编号">
          <span>{{ finishForm.orderNo }}</span>
        </el-form-item>
        <el-form-item label="故障原因" prop="faultReason">
          <el-select v-model="finishForm.faultReason" placeholder="请选择故障原因" style="width: 100%">
            <el-option label="正常磨损" value="normal_wear" />
            <el-option label="配件损坏" value="parts_damage" />
            <el-option label="使用不当" value="improper_use" />
            <el-option label="外部因素" value="external" />
            <el-option label="其他" value="other" />
          </el-select>
        </el-form-item>
        <el-form-item label="处理说明" prop="repairDesc">
          <el-input
            v-model="finishForm.repairDesc"
            type="textarea"
            :rows="4"
            maxlength="1000"
            show-word-limit
            placeholder="填写维修措施与处理结果，如：补充导轨润滑脂，调整导靴间隙，试运行正常"
          />
        </el-form-item>
        <el-form-item label="更换配件">
          <el-input
            v-model="finishForm.replaceParts"
            placeholder="如：导轨润滑脂 1 罐、导靴 2 个，无更换可留空"
          />
        </el-form-item>
      </el-form>
      <template #footer>
        <div class="dialog-footer">
          <el-button @click="finishOpen = false">取消</el-button>
          <el-button type="primary" :loading="submitting" @click="submitFinish">提交完工</el-button>
        </div>
      </template>
    </el-dialog>

    <!-- 维修记录查看 -->
    <el-dialog v-model="recordOpen" title="维修记录" width="700px" append-to-body destroy-on-close>
      <el-descriptions :column="2" border v-if="record">
        <el-descriptions-item label="维修员">{{ record.workerName || '—' }}</el-descriptions-item>
        <el-descriptions-item label="到场时间">{{ record.arriveTime || '—' }}</el-descriptions-item>
        <el-descriptions-item label="到场位置" :span="2">{{ record.arriveLocation || '—' }}</el-descriptions-item>
        <el-descriptions-item label="排查记录" :span="2">{{ record.investigateNote || '—' }}</el-descriptions-item>
        <el-descriptions-item label="故障原因" :span="2">{{ faultReasonName(record.faultReason) }}</el-descriptions-item>
        <el-descriptions-item label="处理说明" :span="2">{{ record.repairDesc || '—' }}</el-descriptions-item>
        <el-descriptions-item label="更换配件" :span="2">{{ record.replaceParts || '无' }}</el-descriptions-item>
        <el-descriptions-item label="完工时间" :span="2">{{ record.finishTime || '—' }}</el-descriptions-item>
      </el-descriptions>
      <el-empty v-else description="该工单暂无维修记录" />
    </el-dialog>
  </div>
</template>

<script setup name="Process">
import { ref, reactive, toRefs, getCurrentInstance } from 'vue'
import {
  listMyProcess,
  arriveProcess,
  investigateProcess,
  finishProcess,
  getProcessRecord
} from '@/api/order/process'
import DictSelect from '@/views/components/DictSelect.vue'
import OrderStatusTag from '@/views/components/OrderStatusTag.vue'
import FaultLevelTag from '@/views/components/FaultLevelTag.vue'

const { proxy } = getCurrentInstance()

const loading = ref(true)
const showSearch = ref(true)
const orderList = ref([])
const total = ref(0)
const submitting = ref(false)

const arriveOpen = ref(false)
const investigateOpen = ref(false)
const finishOpen = ref(false)
const recordOpen = ref(false)
const record = ref(null)

const data = reactive({
  queryParams: {
    pageNum: 1,
    pageSize: 10,
    orderNo: undefined,
    orderStatus: undefined
  },
  arriveForm: {
    orderId: undefined,
    orderNo: '',
    arriveLocation: ''
  },
  investigateForm: {
    orderId: undefined,
    orderNo: '',
    investigateNote: ''
  },
  finishForm: {
    orderId: undefined,
    orderNo: '',
    faultReason: undefined,
    repairDesc: '',
    replaceParts: ''
  },
  finishRules: {
    faultReason: [{ required: true, message: '请选择故障原因', trigger: 'change' }],
    repairDesc: [{ required: true, message: '请填写维修处理说明', trigger: 'blur' }]
  }
})
const { queryParams, arriveForm, investigateForm, finishForm, finishRules } = toRefs(data)

const faultReasonMap = {
  normal_wear: '正常磨损',
  parts_damage: '配件损坏',
  improper_use: '使用不当',
  external: '外部因素',
  other: '其他'
}
const faultReasonName = reason => faultReasonMap[reason] || '—'

/** 查询指派给当前维修员的在办工单 */
function getList() {
  loading.value = true
  listMyProcess(queryParams.value)
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

/** 登记到场 */
function handleArrive(row) {
  arriveForm.value = {
    orderId: row.orderId,
    orderNo: row.orderNo,
    arriveLocation: `${row.communityName || ''}${row.buildingNo || ''}${row.unitNo || ''}`
  }
  arriveOpen.value = true
}

function submitArrive() {
  submitting.value = true
  arriveProcess({
    orderId: arriveForm.value.orderId,
    arriveLocation: arriveForm.value.arriveLocation
  })
    .then(() => {
      proxy.$modal.msgSuccess('已登记到场')
      arriveOpen.value = false
      getList()
    })
    .finally(() => {
      submitting.value = false
    })
}

/** 填写排查记录，工单进入维修中 */
function handleInvestigate(row) {
  investigateForm.value = {
    orderId: row.orderId,
    orderNo: row.orderNo,
    investigateNote: ''
  }
  investigateOpen.value = true
}

function submitInvestigate() {
  if (!investigateForm.value.investigateNote.trim()) {
    proxy.$modal.msgWarning('请填写排查记录')
    return
  }
  submitting.value = true
  investigateProcess({
    orderId: investigateForm.value.orderId,
    investigateNote: investigateForm.value.investigateNote
  })
    .then(() => {
      proxy.$modal.msgSuccess('已提交排查记录')
      investigateOpen.value = false
      getList()
    })
    .finally(() => {
      submitting.value = false
    })
}

/** 提交完工，工单进入已修复等待业主确认 */
function handleFinish(row) {
  finishForm.value = {
    orderId: row.orderId,
    orderNo: row.orderNo,
    faultReason: undefined,
    repairDesc: '',
    replaceParts: ''
  }
  finishOpen.value = true
}

function submitFinish() {
  proxy.$refs['finishRef'].validate(valid => {
    if (!valid) return
    submitting.value = true
    finishProcess({
      orderId: finishForm.value.orderId,
      faultReason: finishForm.value.faultReason,
      repairDesc: finishForm.value.repairDesc,
      replaceParts: finishForm.value.replaceParts
    })
      .then(() => {
        proxy.$modal.msgSuccess('已提交完工，等待业主确认')
        finishOpen.value = false
        getList()
      })
      .finally(() => {
        submitting.value = false
      })
  })
}

/** 查看维修记录 */
function handleRecord(row) {
  record.value = null
  recordOpen.value = true
  getProcessRecord(row.orderId)
    .then(response => {
      record.value = response.data || null
    })
    .catch(() => {
      record.value = null
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
  display: block;
  margin-top: 4px;
  font-size: 13px;
  color: #909399;
}
</style>
