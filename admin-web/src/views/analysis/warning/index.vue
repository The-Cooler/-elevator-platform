<template>
  <div class="app-container">
    <el-card shadow="never">
      <template #header>
        <div class="page-card-header">
          <span class="page-card-title">超期预警监控</span>
          <span class="page-card-desc">
            工单超过预设时限自动触发提醒，维保临近计划日期时提前通知相关责任人，预警规则可配置
          </span>
        </div>
      </template>

      <el-tabs v-model="activeTab">
        <!-- 预警信息 -->
        <el-tab-pane label="预警信息" name="info">
          <el-form :model="queryParams" ref="queryRef" :inline="true" v-show="showSearch">
            <el-form-item label="预警类型" prop="warningType">
              <el-select v-model="queryParams.warningType" placeholder="预警类型" clearable style="width: 160px">
                <el-option label="工单超时" value="order_timeout" />
                <el-option label="维保临期" value="maintain_due" />
              </el-select>
            </el-form-item>
            <el-form-item label="读取状态" prop="isRead">
              <el-select v-model="queryParams.isRead" placeholder="读取状态" clearable style="width: 140px">
                <el-option label="未读" value="0" />
                <el-option label="已读" value="1" />
              </el-select>
            </el-form-item>
            <el-form-item label="电梯编号" prop="elevatorCode">
              <el-input
                v-model="queryParams.elevatorCode"
                placeholder="请输入电梯编号"
                clearable
                style="width: 170px"
                @keyup.enter="handleQuery"
              />
            </el-form-item>
            <el-form-item label="预警时间">
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
              <el-button
                type="primary"
                plain
                icon="Bell"
                @click="handleScan"
                v-hasPermi="['analysis:warning:rule']"
              >立即扫描</el-button>
            </el-col>
            <el-col :span="1.5">
              <el-button
                type="success"
                plain
                icon="Check"
                :disabled="multiple"
                @click="handleRead"
              >标记已读</el-button>
            </el-col>
            <el-col :span="1.5">
              <el-button type="warning" plain icon="Select" @click="handleReadAll">全部已读</el-button>
            </el-col>
            <right-toolbar v-model:showSearch="showSearch" @queryTable="getList"></right-toolbar>
          </el-row>

          <el-table v-loading="loading" :data="warningList" @selection-change="handleSelectionChange">
            <el-table-column type="selection" width="55" align="center" />
            <el-table-column label="读取状态" align="center" width="90">
              <template #default="scope">
                <el-tag :type="scope.row.isRead === '0' ? 'danger' : 'info'" size="small">
                  {{ scope.row.isRead === '0' ? '未读' : '已读' }}
                </el-tag>
              </template>
            </el-table-column>
            <el-table-column label="预警类型" align="center" prop="warningTypeName" width="110">
              <template #default="scope">
                <el-tag type="warning" size="small">{{ scope.row.warningTypeName }}</el-tag>
              </template>
            </el-table-column>
            <el-table-column label="预警内容" align="center" prop="warningContent" :show-overflow-tooltip="true" min-width="300" />
            <el-table-column label="电梯编号" align="center" prop="elevatorCode" width="120" />
            <el-table-column label="接收人" align="center" prop="receiverName" width="120" />
            <el-table-column label="接收角色" align="center" width="100">
              <template #default="scope">{{ roleName(scope.row.receiverRole) }}</template>
            </el-table-column>
            <el-table-column label="预警时间" align="center" prop="warningTime" width="165" />
            <el-table-column label="操作" align="center" width="100" fixed="right">
              <template #default="scope">
                <el-button
                  v-if="scope.row.isRead === '0'"
                  link
                  type="primary"
                  icon="Check"
                  @click="handleRead(scope.row)"
                >标记已读</el-button>
                <span v-else class="read-time">{{ scope.row.readTime }}</span>
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
        </el-tab-pane>

        <!-- 预警规则配置 -->
        <el-tab-pane label="预警规则配置" name="rule">
          <el-row :gutter="10" class="mb8">
            <el-col :span="1.5">
              <el-button
                type="primary"
                plain
                icon="Plus"
                @click="handleAddRule"
                v-hasPermi="['analysis:warning:rule']"
              >新增规则</el-button>
            </el-col>
            <el-col :span="1.5">
              <el-button icon="Refresh" @click="getRuleList">刷新</el-button>
            </el-col>
          </el-row>

          <el-table v-loading="ruleLoading" :data="ruleList">
            <el-table-column label="规则名称" align="center" prop="ruleName" min-width="160" />
            <el-table-column label="规则类型" align="center" width="120">
              <template #default="scope">{{ ruleTypeName(scope.row.ruleType) }}</template>
            </el-table-column>
            <el-table-column label="触发环节" align="center" width="120">
              <template #default="scope">{{ subTypeName(scope.row.bizSubType) }}</template>
            </el-table-column>
            <el-table-column label="阈值" align="center" width="130">
              <template #default="scope">
                {{ scope.row.thresholdValue }} {{ unitName(scope.row.thresholdUnit) }}
              </template>
            </el-table-column>
            <el-table-column label="通知对象" align="center" min-width="160">
              <template #default="scope">{{ rolesName(scope.row.notifyRoles) }}</template>
            </el-table-column>
            <el-table-column label="重复推送间隔" align="center" width="140">
              <template #default="scope">
                {{ scope.row.repeatInterval ? `${scope.row.repeatInterval} 分钟` : '不重复推送' }}
              </template>
            </el-table-column>
            <el-table-column label="状态" align="center" width="100">
              <template #default="scope">
                <el-switch
                  v-model="scope.row.enabled"
                  active-value="0"
                  inactive-value="1"
                  @change="handleRuleStatusChange(scope.row)"
                />
              </template>
            </el-table-column>
            <el-table-column label="备注" align="center" prop="remark" :show-overflow-tooltip="true" min-width="180" />
            <el-table-column label="操作" align="center" width="100" fixed="right">
              <template #default="scope">
                <el-button
                  link
                  type="primary"
                  icon="Edit"
                  @click="handleEditRule(scope.row)"
                  v-hasPermi="['analysis:warning:rule']"
                >修改</el-button>
              </template>
            </el-table-column>
          </el-table>
        </el-tab-pane>
      </el-tabs>
    </el-card>

    <!-- 新增/修改预警规则 -->
    <el-dialog v-model="ruleOpen" :title="ruleTitle" width="620px" append-to-body destroy-on-close>
      <el-form ref="ruleFormRef" :model="ruleForm" :rules="ruleRules" label-width="120px">
        <el-form-item label="规则名称" prop="ruleName">
          <el-input v-model="ruleForm.ruleName" placeholder="如：派单超时预警" maxlength="100" />
        </el-form-item>
        <el-form-item label="规则类型" prop="ruleType">
          <el-select v-model="ruleForm.ruleType" placeholder="请选择规则类型" style="width: 100%">
            <el-option label="工单超时" value="order_timeout" />
            <el-option label="维保临期" value="maintain_due" />
          </el-select>
        </el-form-item>
        <el-form-item label="触发环节" prop="bizSubType">
          <el-select v-model="ruleForm.bizSubType" placeholder="请选择触发环节" style="width: 100%">
            <el-option label="派单超时" value="assign" />
            <el-option label="接单超时" value="accept" />
            <el-option label="到场超时" value="arrive" />
            <el-option label="维修超时" value="repair" />
            <el-option label="维保临期" value="due_soon" />
            <el-option label="维保超期" value="overdue" />
          </el-select>
        </el-form-item>
        <el-form-item label="阈值" prop="thresholdValue">
          <el-input-number v-model="ruleForm.thresholdValue" :min="0" :max="9999" controls-position="right" />
          <el-select v-model="ruleForm.thresholdUnit" style="width: 120px; margin-left: 12px">
            <el-option label="分钟" value="minute" />
            <el-option label="小时" value="hour" />
            <el-option label="天" value="day" />
          </el-select>
        </el-form-item>
        <el-form-item label="通知对象" prop="notifyRoles">
          <el-select v-model="notifyRoleList" multiple placeholder="请选择通知角色" style="width: 100%">
            <el-option label="物业" value="property" />
            <el-option label="维修员" value="worker" />
            <el-option label="管理员" value="admin" />
          </el-select>
        </el-form-item>
        <el-form-item label="重复推送间隔">
          <el-input-number v-model="ruleForm.repeatInterval" :min="0" :max="10080" controls-position="right" />
          <span class="form-tip">分钟，填 0 表示同一业务对象只推送一次，避免频繁打扰</span>
        </el-form-item>
        <el-form-item label="备注">
          <el-input v-model="ruleForm.remark" type="textarea" :rows="2" maxlength="500" placeholder="选填" />
        </el-form-item>
      </el-form>
      <template #footer>
        <div class="dialog-footer">
          <el-button @click="ruleOpen = false">取消</el-button>
          <el-button type="primary" :loading="submitting" @click="submitRule">确定</el-button>
        </div>
      </template>
    </el-dialog>
  </div>
</template>

<script setup name="Warning">
import { ref, reactive, toRefs, watch, getCurrentInstance } from 'vue'
import {
  listWarning,
  readWarning,
  readAllWarning,
  listWarningRule,
  addWarningRule,
  updateWarningRule,
  changeWarningRuleStatus
} from '@/api/analysis/warning'
import request from '@/utils/request'

const { proxy } = getCurrentInstance()

const activeTab = ref('info')

const loading = ref(true)
const showSearch = ref(true)
const warningList = ref([])
const total = ref(0)
const ids = ref([])
const multiple = ref(true)
const dateRange = ref([])

const ruleLoading = ref(false)
const ruleList = ref([])
const ruleOpen = ref(false)
const ruleTitle = ref('')
const submitting = ref(false)
const notifyRoleList = ref([])

const data = reactive({
  queryParams: {
    pageNum: 1,
    pageSize: 10,
    warningType: undefined,
    isRead: undefined,
    elevatorCode: undefined,
    beginTime: undefined,
    endTime: undefined
  },
  ruleForm: {},
  ruleRules: {
    ruleName: [{ required: true, message: '规则名称不能为空', trigger: 'blur' }],
    ruleType: [{ required: true, message: '请选择规则类型', trigger: 'change' }],
    bizSubType: [{ required: true, message: '请选择触发环节', trigger: 'change' }],
    thresholdValue: [{ required: true, message: '请填写阈值', trigger: 'blur' }]
  }
})
const { queryParams, ruleForm, ruleRules } = toRefs(data)

const roleMap = { owner: '业主', property: '物业', worker: '维修员', admin: '管理员' }
const roleName = role => roleMap[role] || role || '—'
const rolesName = roles =>
  !roles ? '—' : roles.split(',').map(r => roleMap[r.trim()] || r.trim()).join('、')

const ruleTypeMap = { order_timeout: '工单超时', maintain_due: '维保临期' }
const ruleTypeName = type => ruleTypeMap[type] || type || '—'

const subTypeMap = {
  assign: '派单超时',
  accept: '接单超时',
  arrive: '到场超时',
  repair: '维修超时',
  confirm: '确认超时',
  due_soon: '维保临期',
  overdue: '维保超期'
}
const subTypeName = type => subTypeMap[type] || type || '—'

const unitMap = { minute: '分钟', hour: '小时', day: '天' }
const unitName = unit => unitMap[unit] || unit || ''

/** 查询预警信息列表 */
function getList() {
  loading.value = true
  queryParams.value.beginTime = dateRange.value?.[0]
  queryParams.value.endTime = dateRange.value?.[1]
  listWarning(queryParams.value)
    .then(response => {
      warningList.value = response.rows
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
  dateRange.value = []
  handleQuery()
}

function handleSelectionChange(selection) {
  ids.value = selection.map(item => item.warningId)
  multiple.value = !selection.length
}

/** 标记选中预警为已读 */
function handleRead(row) {
  const warningIds = row ? [row.warningId] : ids.value
  if (!warningIds.length) {
    proxy.$modal.msgWarning('请选择需要标记的预警')
    return
  }
  readWarning(warningIds.join(',')).then(() => {
    proxy.$modal.msgSuccess('已标记为已读')
    getList()
  })
}

/** 全部标记已读 */
function handleReadAll() {
  readAllWarning().then(() => {
    proxy.$modal.msgSuccess('已全部标记为已读')
    getList()
  })
}

/** 立即触发一次预警扫描 */
function handleScan() {
  proxy
    .$confirm('将立即扫描全部工单与维保计划，按启用规则生成预警信息，确认继续吗？', '立即扫描', { type: 'info' })
    .then(() =>
      request({ url: '/analysis/warning/scan', method: 'post' })
    )
    .then(response => {
      proxy.$modal.msgSuccess(response.msg || '扫描完成')
      getList()
    })
    .catch(() => {})
}

/** 查询预警规则列表 */
function getRuleList() {
  ruleLoading.value = true
  listWarningRule({ pageNum: 1, pageSize: 100 })
    .then(response => {
      ruleList.value = response.rows || []
    })
    .finally(() => {
      ruleLoading.value = false
    })
}

/** 新增规则 */
function handleAddRule() {
  ruleForm.value = {
    ruleId: undefined,
    ruleName: '',
    ruleType: 'order_timeout',
    bizSubType: 'assign',
    thresholdValue: 30,
    thresholdUnit: 'minute',
    notifyRoles: 'property',
    enabled: '0',
    repeatInterval: 0,
    remark: ''
  }
  notifyRoleList.value = ['property']
  ruleTitle.value = '新增预警规则'
  ruleOpen.value = true
}

/** 修改规则 */
function handleEditRule(row) {
  ruleForm.value = { ...row }
  notifyRoleList.value = row.notifyRoles ? row.notifyRoles.split(',').filter(Boolean) : []
  ruleTitle.value = '修改预警规则'
  ruleOpen.value = true
}

watch(notifyRoleList, roles => {
  ruleForm.value.notifyRoles = roles.join(',')
})

function submitRule() {
  proxy.$refs['ruleFormRef'].validate(valid => {
    if (!valid) return
    if (!notifyRoleList.value.length) {
      proxy.$modal.msgWarning('请至少选择一个通知对象')
      return
    }
    submitting.value = true
    const request = ruleForm.value.ruleId ? updateWarningRule(ruleForm.value) : addWarningRule(ruleForm.value)
    request
      .then(() => {
        proxy.$modal.msgSuccess(ruleForm.value.ruleId ? '修改成功' : '新增成功')
        ruleOpen.value = false
        getRuleList()
      })
      .finally(() => {
        submitting.value = false
      })
  })
}

/** 启用或停用规则 */
function handleRuleStatusChange(row) {
  const text = row.enabled === '0' ? '启用' : '停用'
  changeWarningRuleStatus({ ruleId: row.ruleId, enabled: row.enabled })
    .then(() => {
      proxy.$modal.msgSuccess(`已${text}`)
      getRuleList()
    })
    .catch(() => {
      row.enabled = row.enabled === '0' ? '1' : '0'
    })
}

getList()
getRuleList()
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
.read-time {
  font-size: 12px;
  color: #c0c4cc;
}
</style>
