<template>
  <div class="app-container">
    <el-card shadow="never">
      <template #header>
        <div class="page-card-header">
          <span class="page-card-title">维保计划管理</span>
          <span class="page-card-desc">
            制定半月保、季度检等周期性维保任务，系统按周期自动推算下次维保日期并生成巡检工单
          </span>
        </div>
      </template>

      <el-form :model="queryParams" ref="queryRef" :inline="true" v-show="showSearch">
        <el-form-item label="计划名称" prop="planName">
          <el-input
            v-model="queryParams.planName"
            placeholder="请输入计划名称"
            clearable
            style="width: 180px"
            @keyup.enter="handleQuery"
          />
        </el-form-item>
        <el-form-item label="维保类型" prop="maintainType">
          <dict-select v-model="queryParams.maintainType" dict-type="maintain_type" placeholder="维保类型" width="160px" />
        </el-form-item>
        <el-form-item label="计划状态" prop="planStatus">
          <el-select v-model="queryParams.planStatus" placeholder="计划状态" clearable style="width: 140px">
            <el-option label="启用" value="0" />
            <el-option label="停用" value="1" />
          </el-select>
        </el-form-item>
        <el-form-item label="小区" prop="communityId">
          <el-select v-model="queryParams.communityId" placeholder="请选择小区" clearable style="width: 190px">
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

      <el-row :gutter="10" class="mb8">
        <el-col :span="1.5">
          <el-button
            type="primary"
            plain
            icon="Plus"
            @click="handleAdd"
            v-hasPermi="['maintain:plan:add']"
          >新增计划</el-button>
        </el-col>
        <el-col :span="1.5">
          <el-button
            type="success"
            plain
            icon="Plus"
            @click="handleBatchAdd"
            v-hasPermi="['maintain:plan:add']"
          >批量创建</el-button>
        </el-col>
        <el-col :span="1.5">
          <el-button
            type="danger"
            plain
            icon="Delete"
            :disabled="multiple"
            @click="handleDelete"
            v-hasPermi="['maintain:plan:remove']"
          >删除</el-button>
        </el-col>
        <right-toolbar v-model:showSearch="showSearch" @queryTable="getList"></right-toolbar>
      </el-row>

      <el-table v-loading="loading" :data="planList" @selection-change="handleSelectionChange">
        <el-table-column type="selection" width="55" align="center" />
        <el-table-column label="计划名称" align="center" prop="planName" :show-overflow-tooltip="true" min-width="180" />
        <el-table-column label="电梯编号" align="center" prop="elevatorCode" width="120" />
        <el-table-column label="电梯位置" align="center" width="190" :show-overflow-tooltip="true">
          <template #default="scope">
            {{ scope.row.communityName }} {{ scope.row.buildingNo }} {{ scope.row.unitNo }}
          </template>
        </el-table-column>
        <el-table-column label="维保类型" align="center" width="105">
          <template #default="scope">{{ maintainTypeName(scope.row.maintainType) }}</template>
        </el-table-column>
        <el-table-column label="周期" align="center" prop="cycleDays" width="90">
          <template #default="scope">{{ scope.row.cycleDays }} 天</template>
        </el-table-column>
        <el-table-column label="下次维保" align="center" width="140">
          <template #default="scope">
            <span :class="{ 'date-warn': scope.row.remainingDays !== null && scope.row.remainingDays <= 3 }">
              {{ scope.row.nextDate || '—' }}
            </span>
            <el-tag v-if="scope.row.dueSoon && scope.row.planStatus === '0'" type="warning" size="small" class="ml4">
              {{ scope.row.remainingDays < 0 ? '已超期' : '临期' }}
            </el-tag>
          </template>
        </el-table-column>
        <el-table-column label="负责人" align="center" prop="ownerName" width="120" />
        <el-table-column label="完成率" align="center" width="150">
          <template #default="scope">
            <el-progress
              :percentage="Number(scope.row.completeRate || 0)"
              :stroke-width="12"
              :color="rateColor(scope.row.completeRate)"
            />
          </template>
        </el-table-column>
        <el-table-column label="计划状态" align="center" prop="planStatus" width="100">
          <template #default="scope">
            <el-switch
              v-model="scope.row.planStatus"
              active-value="0"
              inactive-value="1"
              @change="handleStatusChange(scope.row)"
            />
          </template>
        </el-table-column>
        <el-table-column label="操作" align="center" width="190" fixed="right">
          <template #default="scope">
            <el-button link type="primary" icon="Edit" @click="handleUpdate(scope.row)" v-hasPermi="['maintain:plan:edit']">
              修改
            </el-button>
            <el-button link type="info" icon="List" @click="handleTemplate(scope.row)">检查项</el-button>
            <el-button link type="danger" icon="Delete" @click="handleDelete(scope.row)" v-hasPermi="['maintain:plan:remove']">
              删除
            </el-button>
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

    <!-- 新增/修改维保计划 -->
    <el-dialog v-model="open" :title="title" width="680px" append-to-body destroy-on-close>
      <el-form ref="planRef" :model="form" :rules="rules" label-width="110px">
        <el-form-item label="计划名称" prop="planName">
          <el-input v-model="form.planName" placeholder="如：1号楼电梯半月保" maxlength="100" />
        </el-form-item>

        <el-form-item label="电梯" prop="elevatorId" v-if="!form.planId">
          <el-select v-model="form.elevatorId" placeholder="请选择电梯" filterable style="width: 100%">
            <el-option
              v-for="item in elevatorList"
              :key="item.elevatorId"
              :label="`${item.elevatorCode}（${item.brand}，${item.communityName} ${item.buildingNo} ${item.unitNo}）`"
              :value="item.elevatorId"
            />
          </el-select>
        </el-form-item>

        <el-form-item label="维保类型" prop="maintainType">
          <el-select v-model="form.maintainType" placeholder="请选择维保类型" style="width: 100%" @change="handleTypeChange">
            <el-option label="半月保（15 天）" value="half_month" />
            <el-option label="季度检（90 天）" value="quarter" />
            <el-option label="半年保（180 天）" value="half_year" />
            <el-option label="年检（365 天）" value="annual" />
          </el-select>
        </el-form-item>

        <el-form-item label="周期天数" prop="cycleDays">
          <el-input-number v-model="form.cycleDays" :min="1" :max="365" controls-position="right" />
          <span class="form-tip">按维保类型自动带出，可手动调整</span>
        </el-form-item>

        <el-form-item label="检查项模板" prop="templateName">
          <el-select v-model="form.templateName" placeholder="请选择检查项模板" style="width: 100%">
            <el-option label="半月保标准模板" value="半月保标准模板" />
            <el-option label="季度检标准模板" value="季度检标准模板" />
          </el-select>
        </el-form-item>

        <el-form-item label="生效日期" prop="startDate">
          <el-date-picker
            v-model="form.startDate"
            type="date"
            value-format="YYYY-MM-DD"
            placeholder="请选择生效日期"
            style="width: 100%"
          />
        </el-form-item>

        <el-form-item label="失效日期" prop="endDate">
          <el-date-picker
            v-model="form.endDate"
            type="date"
            value-format="YYYY-MM-DD"
            placeholder="留空表示长期有效"
            style="width: 100%"
          />
        </el-form-item>

        <el-form-item label="负责人" prop="ownerId">
          <el-select v-model="form.ownerId" placeholder="请选择负责的维修员" filterable style="width: 100%">
            <el-option
              v-for="item in workerList"
              :key="item.workerId"
              :label="`${item.workerName}（${item.communityName || '未分配'}）`"
              :value="item.workerId"
            />
          </el-select>
        </el-form-item>

        <el-form-item label="备注">
          <el-input v-model="form.remark" type="textarea" :rows="2" maxlength="500" placeholder="选填" />
        </el-form-item>
      </el-form>
      <template #footer>
        <div class="dialog-footer">
          <el-button @click="open = false">取消</el-button>
          <el-button type="primary" :loading="submitting" @click="submitForm">确定</el-button>
        </div>
      </template>
    </el-dialog>

    <!-- 批量创建 -->
    <el-dialog v-model="batchOpen" title="批量创建维保计划" width="680px" append-to-body destroy-on-close>
      <el-form ref="batchRef" :model="batchForm" :rules="batchRules" label-width="110px">
        <el-form-item label="计划名称" prop="planName">
          <el-input v-model="batchForm.planName" placeholder="如：2026 年第四季度半月保" maxlength="100" />
        </el-form-item>
        <el-form-item label="选择电梯" prop="elevatorIds">
          <el-select
            v-model="batchForm.elevatorIds"
            multiple
            filterable
            placeholder="可多选电梯"
            style="width: 100%"
          >
            <el-option
              v-for="item in elevatorList"
              :key="item.elevatorId"
              :label="`${item.elevatorCode}（${item.communityName} ${item.buildingNo}）`"
              :value="item.elevatorId"
            />
          </el-select>
          <span class="form-tip">已存在相同维保类型启用计划的电梯会自动跳过</span>
        </el-form-item>
        <el-form-item label="维保类型" prop="maintainType">
          <el-select v-model="batchForm.maintainType" placeholder="请选择维保类型" style="width: 100%" @change="handleBatchTypeChange">
            <el-option label="半月保（15 天）" value="half_month" />
            <el-option label="季度检（90 天）" value="quarter" />
            <el-option label="半年保（180 天）" value="half_year" />
            <el-option label="年检（365 天）" value="annual" />
          </el-select>
        </el-form-item>
        <el-form-item label="周期天数" prop="cycleDays">
          <el-input-number v-model="batchForm.cycleDays" :min="1" :max="365" controls-position="right" />
        </el-form-item>
        <el-form-item label="生效日期" prop="startDate">
          <el-date-picker
            v-model="batchForm.startDate"
            type="date"
            value-format="YYYY-MM-DD"
            placeholder="请选择生效日期"
            style="width: 100%"
          />
        </el-form-item>
        <el-form-item label="负责人" prop="ownerId">
          <el-select v-model="batchForm.ownerId" placeholder="请选择负责的维修员" filterable style="width: 100%">
            <el-option
              v-for="item in workerList"
              :key="item.workerId"
              :label="item.workerName"
              :value="item.workerId"
            />
          </el-select>
        </el-form-item>
      </el-form>
      <template #footer>
        <div class="dialog-footer">
          <el-button @click="batchOpen = false">取消</el-button>
          <el-button type="primary" :loading="submitting" @click="submitBatch">确定</el-button>
        </div>
      </template>
    </el-dialog>

    <!-- 检查项模板查看 -->
    <el-dialog v-model="templateOpen" title="检查项清单" width="760px" append-to-body destroy-on-close>
      <el-alert type="info" :closable="false" show-icon class="mb20"
        :title="`计划：${templatePlanName}　模板：${templateQuery.templateName}　类型：${maintainTypeName(templateQuery.maintainType)}`" />
      <el-table :data="templateItems" v-loading="templateLoading" max-height="420">
        <el-table-column label="序号" align="center" prop="orderNum" width="70" />
        <el-table-column label="检查项" align="center" prop="itemName" :show-overflow-tooltip="true" min-width="180" />
        <el-table-column label="分类" align="center" width="110">
          <template #default="scope">{{ categoryName(scope.row.itemCategory) }}</template>
        </el-table-column>
        <el-table-column label="检查标准" align="center" prop="checkStandard" :show-overflow-tooltip="true" min-width="200" />
      </el-table>
    </el-dialog>
  </div>
</template>

<script setup name="Plan">
import { ref, reactive, toRefs, getCurrentInstance } from 'vue'
import {
  listPlan,
  getPlan,
  addPlan,
  updatePlan,
  delPlan,
  changePlanStatus,
  batchAddPlan,
  listTemplateItems
} from '@/api/maintain/plan'
import { listElevator } from '@/api/basic/elevator'
import { listCommunity } from '@/api/basic/community'
import { listWorkerSkills } from '@/api/order/dispatch'
import DictSelect from '@/views/components/DictSelect.vue'

const { proxy } = getCurrentInstance()

const loading = ref(true)
const showSearch = ref(true)
const submitting = ref(false)
const planList = ref([])
const total = ref(0)
const ids = ref([])
const multiple = ref(true)
const communityList = ref([])
const elevatorList = ref([])
const workerList = ref([])

const open = ref(false)
const batchOpen = ref(false)
const templateOpen = ref(false)
const templateLoading = ref(false)
const templateItems = ref([])
const templateQuery = reactive({ maintainType: '', templateName: '' })
const templatePlanName = ref('')
const title = ref('')

const data = reactive({
  queryParams: {
    pageNum: 1,
    pageSize: 10,
    planName: undefined,
    maintainType: undefined,
    planStatus: undefined,
    communityId: undefined
  },
  form: {},
  batchForm: {},
  rules: {
    planName: [{ required: true, message: '计划名称不能为空', trigger: 'blur' }],
    elevatorId: [{ required: true, message: '请选择电梯', trigger: 'change' }],
    maintainType: [{ required: true, message: '请选择维保类型', trigger: 'change' }],
    cycleDays: [{ required: true, message: '请填写周期天数', trigger: 'blur' }],
    startDate: [{ required: true, message: '请选择生效日期', trigger: 'change' }]
  },
  batchRules: {
    planName: [{ required: true, message: '计划名称不能为空', trigger: 'blur' }],
    elevatorIds: [{ required: true, message: '请至少选择一台电梯', trigger: 'change' }],
    maintainType: [{ required: true, message: '请选择维保类型', trigger: 'change' }],
    cycleDays: [{ required: true, message: '请填写周期天数', trigger: 'blur' }],
    startDate: [{ required: true, message: '请选择生效日期', trigger: 'change' }]
  }
})
const { queryParams, form, batchForm, rules, batchRules } = toRefs(data)

const maintainTypeMap = {
  half_month: '半月保',
  quarter: '季度检',
  half_year: '半年保',
  annual: '年检'
}
const maintainTypeName = type => maintainTypeMap[type] || type || '—'

const cycleDaysMap = { half_month: 15, quarter: 90, half_year: 180, annual: 365 }

const categoryMap = {
  traction: '曳引机',
  door_system: '门系统',
  safety: '安全装置',
  control: '控制系统',
  car: '轿厢',
  other: '其他'
}
const categoryName = category => categoryMap[category] || category || '—'

/** 查询维保计划列表 */
function getList() {
  loading.value = true
  listPlan(queryParams.value)
    .then(response => {
      planList.value = response.rows
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
  ids.value = selection.map(item => item.planId)
  multiple.value = !selection.length
}

/** 完成率进度条配色 */
function rateColor(rate) {
  const value = Number(rate || 0)
  if (value >= 80) return '#67c23a'
  if (value >= 50) return '#e6a23c'
  return '#f56c6c'
}

/** 新增计划，重置表单 */
function handleAdd() {
  reset()
  open.value = true
  title.value = '新增维保计划'
}

/** 修改计划 */
function handleUpdate(row) {
  reset()
  getPlan(row.planId).then(response => {
    form.value = response.data
    open.value = true
    title.value = '修改维保计划'
  })
}

function reset() {
  form.value = {
    planId: undefined,
    planName: '',
    elevatorId: undefined,
    maintainType: 'half_month',
    cycleDays: 15,
    templateName: '半月保标准模板',
    startDate: undefined,
    endDate: undefined,
    ownerId: undefined,
    remark: ''
  }
}

/** 维保类型变化时带出默认周期与模板 */
function handleTypeChange(type) {
  form.value.cycleDays = cycleDaysMap[type] || 15
  form.value.templateName = type === 'quarter' ? '季度检标准模板' : '半月保标准模板'
}

function handleBatchTypeChange(type) {
  batchForm.value.cycleDays = cycleDaysMap[type] || 15
}

function submitForm() {
  proxy.$refs['planRef'].validate(valid => {
    if (!valid) return
    submitting.value = true
    const request = form.value.planId ? updatePlan(form.value) : addPlan(form.value)
    request
      .then(() => {
        proxy.$modal.msgSuccess(form.value.planId ? '修改成功' : '新增成功')
        open.value = false
        getList()
      })
      .finally(() => {
        submitting.value = false
      })
  })
}

/** 批量创建计划 */
function handleBatchAdd() {
  batchForm.value = {
    planName: '',
    elevatorIds: [],
    maintainType: 'half_month',
    cycleDays: 15,
    startDate: undefined,
    ownerId: undefined
  }
  batchOpen.value = true
}

function submitBatch() {
  proxy.$refs['batchRef'].validate(valid => {
    if (!valid) return
    submitting.value = true
    batchAddPlan(batchForm.value)
      .then(response => {
        const count = response.data || 0
        proxy.$modal.msgSuccess(`已成功创建 ${count} 条维保计划`)
        batchOpen.value = false
        getList()
      })
      .finally(() => {
        submitting.value = false
      })
  })
}

/** 启用或停用计划 */
function handleStatusChange(row) {
  const text = row.planStatus === '0' ? '启用' : '停用'
  changePlanStatus(row.planId, row.planStatus)
    .then(() => {
      proxy.$modal.msgSuccess(`已${text}`)
      getList()
    })
    .catch(() => {
      // 操作失败时回滚开关状态
      row.planStatus = row.planStatus === '0' ? '1' : '0'
    })
}

/** 删除计划 */
function handleDelete(row) {
  const planIds = row ? [row.planId] : ids.value
  if (!planIds.length) {
    proxy.$modal.msgWarning('请选择需要删除的计划')
    return
  }
  proxy
    .$confirm(`确认删除选中的 ${planIds.length} 个维保计划吗？`, '提示', { type: 'warning' })
    .then(() => delPlan(planIds.join(',')))
    .then(() => {
      proxy.$modal.msgSuccess('删除成功')
      getList()
    })
    .catch(() => {})
}

/** 查看计划绑定的检查项清单 */
function handleTemplate(row) {
  templatePlanName.value = row.planName
  templateQuery.maintainType = row.maintainType
  templateQuery.templateName = row.templateName || '半月保标准模板'
  templateItems.value = []
  templateOpen.value = true
  templateLoading.value = true
  listTemplateItems({ maintainType: row.maintainType, templateName: templateQuery.templateName })
    .then(response => {
      templateItems.value = response.data || []
    })
    .finally(() => {
      templateLoading.value = false
    })
}

/** 加载小区、电梯与维修员下拉数据 */
function loadOptions() {
  listCommunity({ pageNum: 1, pageSize: 200 }).then(response => {
    communityList.value = response.rows || []
  }).catch(() => {})

  listElevator({ pageNum: 1, pageSize: 500 }).then(response => {
    elevatorList.value = response.rows || []
  }).catch(() => {})

  listWorkerSkills({}).then(response => {
    workerList.value = response.data || []
  }).catch(() => {})
}

getList()
loadOptions()
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
.date-warn {
  color: #e6a23c;
  font-weight: 600;
}
.ml4 {
  margin-left: 4px;
}
.mb20 {
  margin-bottom: 16px;
}
</style>
