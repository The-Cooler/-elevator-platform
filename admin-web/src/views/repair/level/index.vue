<template>
  <div class="app-container">
    <el-card shadow="never">
      <template #header>
        <div class="page-card-header">
          <span class="page-card-title">故障分级管理</span>
          <span class="page-card-desc">故障等级字典配置与工单优先级调整，等级变更记入工单状态流转表</span>
        </div>
      </template>

      <el-tabs v-model="activeTab">
        <el-tab-pane label="故障等级配置" name="level">
          <el-form :model="levelQuery" ref="levelQueryRef" :inline="true" v-show="showSearch">
            <el-form-item label="字典标签" prop="dictLabel">
              <el-input v-model="levelQuery.dictLabel" placeholder="请输入等级名称" clearable style="width: 200px" @keyup.enter="handleLevelQuery" />
            </el-form-item>
            <el-form-item label="字典状态" prop="status">
              <el-select v-model="levelQuery.status" placeholder="字典状态" clearable style="width: 200px">
                <el-option label="正常" value="0" />
                <el-option label="停用" value="1" />
              </el-select>
            </el-form-item>
            <el-form-item>
              <el-button type="primary" icon="Search" @click="handleLevelQuery">搜索</el-button>
              <el-button icon="Refresh" @click="resetLevelQuery">重置</el-button>
            </el-form-item>
          </el-form>

          <el-row :gutter="10" class="mb8">
            <el-col :span="1.5">
              <el-button type="primary" plain icon="Plus" @click="handleLevelAdd" v-hasPermi="['repair:level:edit']">新增</el-button>
            </el-col>
            <el-col :span="1.5">
              <el-button type="success" plain icon="Edit" :disabled="levelSingle" @click="handleLevelUpdate" v-hasPermi="['repair:level:edit']">修改</el-button>
            </el-col>
            <el-col :span="1.5">
              <el-button type="danger" plain icon="Delete" :disabled="levelMultiple" @click="handleLevelDelete" v-hasPermi="['repair:level:edit']">删除</el-button>
            </el-col>
            <right-toolbar v-model:showSearch="showSearch" @queryTable="getLevelList"></right-toolbar>
          </el-row>

          <el-table v-loading="levelLoading" :data="levelList" @selection-change="handleLevelSelection">
            <el-table-column type="selection" width="55" align="center" />
            <el-table-column label="字典编码" align="center" prop="dictCode" width="100" />
            <el-table-column label="等级名称" align="center" prop="dictLabel" width="140" />
            <el-table-column label="等级值" align="center" prop="dictValue" width="100" />
            <el-table-column label="等级标识" align="center" prop="dictValue" width="140">
              <template #default="scope">
                <fault-level-tag :level="scope.row.dictValue" />
              </template>
            </el-table-column>
            <el-table-column label="颜色标识" align="center" prop="listClass" width="140">
              <template #default="scope">
                <el-tag :type="scope.row.listClass || 'info'">{{ scope.row.listClass || '无' }}</el-tag>
              </template>
            </el-table-column>
            <el-table-column label="排序号" align="center" prop="dictSort" width="90" />
            <el-table-column label="状态" align="center" prop="status" width="90">
              <template #default="scope">
                <el-tag :type="scope.row.status === '0' ? 'success' : 'info'">{{ scope.row.status === '0' ? '正常' : '停用' }}</el-tag>
              </template>
            </el-table-column>
            <el-table-column label="等级说明" align="center" prop="remark" :show-overflow-tooltip="true" />
            <el-table-column label="操作" align="center" width="150" class-name="small-padding fixed-width">
              <template #default="scope">
                <el-button link type="primary" icon="Edit" @click="handleLevelUpdate(scope.row)" v-hasPermi="['repair:level:edit']">修改</el-button>
                <el-button link type="primary" icon="Delete" @click="handleLevelDelete(scope.row)" v-hasPermi="['repair:level:edit']">删除</el-button>
              </template>
            </el-table-column>
          </el-table>

          <pagination v-show="levelTotal > 0" :total="levelTotal" v-model:page="levelQuery.pageNum" v-model:limit="levelQuery.pageSize" @pagination="getLevelList" />
        </el-tab-pane>

        <el-tab-pane label="工单优先级调整" name="priority">
          <el-form :model="orderQuery" ref="orderQueryRef" :inline="true">
            <el-form-item label="工单编号" prop="orderNo">
              <el-input v-model="orderQuery.orderNo" placeholder="请输入工单编号" clearable style="width: 180px" @keyup.enter="handleOrderQuery" />
            </el-form-item>
            <el-form-item label="当前等级" prop="faultLevel">
              <dict-select v-model="orderQuery.faultLevel" dict-type="fault_level" placeholder="故障等级" width="180px" />
            </el-form-item>
            <el-form-item label="工单状态" prop="orderStatus">
              <dict-select v-model="orderQuery.orderStatus" dict-type="repair_order_status" placeholder="工单状态" width="180px" />
            </el-form-item>
            <el-form-item>
              <el-button type="primary" icon="Search" @click="handleOrderQuery">搜索</el-button>
              <el-button icon="Refresh" @click="resetOrderQuery">重置</el-button>
            </el-form-item>
          </el-form>

          <el-table v-loading="orderLoading" :data="orderList">
            <el-table-column label="工单编号" align="center" prop="orderNo" width="180" :show-overflow-tooltip="true" />
            <el-table-column label="电梯编号" align="center" prop="elevatorCode" width="130" />
            <el-table-column label="故障现象" align="center" prop="faultDesc" :show-overflow-tooltip="true" />
            <el-table-column label="当前等级" align="center" prop="faultLevel" width="110">
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
            <el-table-column label="操作" align="center" width="140" class-name="small-padding fixed-width">
              <template #default="scope">
                <el-button link type="primary" icon="Edit" @click="handleChangeLevel(scope.row)" v-hasPermi="['repair:order:changeLevel']">调整等级</el-button>
              </template>
            </el-table-column>
          </el-table>

          <pagination v-show="orderTotal > 0" :total="orderTotal" v-model:page="orderQuery.pageNum" v-model:limit="orderQuery.pageSize" @pagination="getOrderList" />
        </el-tab-pane>
      </el-tabs>
    </el-card>

    <!-- 等级表单 -->
    <el-dialog :title="levelTitle" v-model="levelOpen" width="560px" append-to-body>
      <el-form ref="levelRef" :model="levelForm" :rules="levelRules" label-width="100px">
        <el-form-item label="等级名称" prop="dictLabel">
          <el-input v-model="levelForm.dictLabel" placeholder="如 紧急、一般" />
        </el-form-item>
        <el-form-item label="等级值" prop="dictValue">
          <el-input v-model="levelForm.dictValue" placeholder="0 紧急 / 1 一般" />
        </el-form-item>
        <el-form-item label="颜色标识" prop="listClass">
          <el-select v-model="levelForm.listClass" placeholder="请选择颜色标识" style="width: 100%">
            <el-option label="红色 danger" value="danger" />
            <el-option label="橙色 warning" value="warning" />
            <el-option label="蓝色 primary" value="primary" />
            <el-option label="绿色 success" value="success" />
            <el-option label="灰色 info" value="info" />
          </el-select>
        </el-form-item>
        <el-form-item label="排序号" prop="dictSort">
          <el-input-number v-model="levelForm.dictSort" :min="0" controls-position="right" />
        </el-form-item>
        <el-form-item label="状态" prop="status">
          <el-radio-group v-model="levelForm.status">
            <el-radio value="0">正常</el-radio>
            <el-radio value="1">停用</el-radio>
          </el-radio-group>
        </el-form-item>
        <el-form-item label="等级说明" prop="remark">
          <el-input v-model="levelForm.remark" type="textarea" :rows="3" placeholder="请输入等级适用说明" />
        </el-form-item>
      </el-form>
      <template #footer>
        <div class="dialog-footer">
          <el-button type="primary" @click="submitLevel">确 定</el-button>
          <el-button @click="levelOpen = false">取 消</el-button>
        </div>
      </template>
    </el-dialog>

    <!-- 优先级调整 -->
    <el-dialog title="调整工单优先级" v-model="changeOpen" width="520px" append-to-body>
      <el-form ref="changeRef" :model="changeForm" :rules="changeRules" label-width="100px">
        <el-form-item label="工单编号">
          <el-input v-model="changeForm.orderNo" disabled />
        </el-form-item>
        <el-form-item label="当前等级">
          <fault-level-tag :level="changeForm.oldLevel" />
        </el-form-item>
        <el-form-item label="调整后等级" prop="faultLevel">
          <dict-select v-model="changeForm.faultLevel" dict-type="fault_level" placeholder="请选择调整后的等级" width="100%" />
        </el-form-item>
        <el-form-item label="调整说明" prop="remark">
          <el-input v-model="changeForm.remark" type="textarea" :rows="3" placeholder="请填写等级调整说明，变更将记入状态流转表" />
        </el-form-item>
        <el-alert
          v-if="changeForm.faultLevel === '0'"
          title="调整为紧急等级后，工单将在派单池置顶并高亮提示"
          type="warning"
          :closable="false"
          show-icon
        />
      </el-form>
      <template #footer>
        <div class="dialog-footer">
          <el-button type="primary" @click="submitChangeLevel">确 定</el-button>
          <el-button @click="changeOpen = false">取 消</el-button>
        </div>
      </template>
    </el-dialog>
  </div>
</template>

<script setup name="RepairLevel">
import { listLevel, addLevel, updateLevel, delLevel } from '@/api/repair/level'
import { listRepairOrder, changeOrderLevel } from '@/api/repair/order'
import OrderStatusTag from '@/views/components/OrderStatusTag.vue'
import FaultLevelTag from '@/views/components/FaultLevelTag.vue'

const { proxy } = getCurrentInstance()

const activeTab = ref('level')
const showSearch = ref(true)

/* ---------------- 等级字典 ---------------- */
const levelList = ref([])
const levelLoading = ref(false)
const levelOpen = ref(false)
const levelTotal = ref(0)
const levelTitle = ref('')
const levelIds = ref([])
const levelSingle = ref(true)
const levelMultiple = ref(true)

/* ---------------- 工单优先级 ---------------- */
const orderList = ref([])
const orderLoading = ref(false)
const orderTotal = ref(0)
const changeOpen = ref(false)

const data = reactive({
  levelQuery: { pageNum: 1, pageSize: 10, dictType: 'fault_level', dictLabel: undefined, status: undefined },
  levelForm: {},
  levelRules: {
    dictLabel: [{ required: true, message: '等级名称不能为空', trigger: 'blur' }],
    dictValue: [{ required: true, message: '等级值不能为空', trigger: 'blur' }],
    dictSort: [{ required: true, message: '排序号不能为空', trigger: 'blur' }]
  },
  orderQuery: { pageNum: 1, pageSize: 10, orderNo: undefined, faultLevel: undefined, orderStatus: undefined },
  changeForm: {},
  changeRules: {
    faultLevel: [{ required: true, message: '请选择调整后的等级', trigger: 'change' }]
  }
})

const { levelQuery, levelForm, levelRules, orderQuery, changeForm, changeRules } = toRefs(data)

/* ---------------- 等级字典操作 ---------------- */
function getLevelList() {
  levelLoading.value = true
  listLevel(levelQuery.value).then(response => {
    levelList.value = response.rows
    levelTotal.value = response.total
    levelLoading.value = false
  }).catch(() => {
    levelLoading.value = false
  })
}

function handleLevelQuery() {
  levelQuery.value.pageNum = 1
  getLevelList()
}

function resetLevelQuery() {
  proxy.resetForm('levelQueryRef')
  handleLevelQuery()
}

function handleLevelSelection(selection) {
  levelIds.value = selection.map(item => item.dictCode)
  levelSingle.value = selection.length != 1
  levelMultiple.value = !selection.length
}

function resetLevelForm() {
  levelForm.value = {
    dictCode: undefined,
    dictType: 'fault_level',
    dictLabel: undefined,
    dictValue: undefined,
    listClass: 'warning',
    dictSort: 0,
    status: '0',
    remark: undefined
  }
  proxy.resetForm('levelRef')
}

function handleLevelAdd() {
  resetLevelForm()
  levelOpen.value = true
  levelTitle.value = '新增故障等级'
}

function handleLevelUpdate(row) {
  resetLevelForm()
  const dictCode = row && row.dictCode ? row.dictCode : levelIds.value[0]
  const target = levelList.value.find(item => item.dictCode === dictCode)
  if (target) {
    levelForm.value = { ...target }
  }
  levelOpen.value = true
  levelTitle.value = '修改故障等级'
}

function submitLevel() {
  proxy.$refs['levelRef'].validate(valid => {
    if (!valid) {
      return
    }
    const request = levelForm.value.dictCode != undefined ? updateLevel : addLevel
    request(levelForm.value).then(() => {
      proxy.$modal.msgSuccess(levelForm.value.dictCode != undefined ? '修改成功' : '新增成功')
      levelOpen.value = false
      getLevelList()
    })
  })
}

function handleLevelDelete(row) {
  const ids = row && row.dictCode ? row.dictCode : levelIds.value
  proxy.$modal.confirm('是否确认删除故障等级"' + ids + '"？').then(() => {
    return delLevel(ids)
  }).then(() => {
    getLevelList()
    proxy.$modal.msgSuccess('删除成功')
  }).catch(() => {})
}

/* ---------------- 工单优先级操作 ---------------- */
function getOrderList() {
  orderLoading.value = true
  listRepairOrder(orderQuery.value).then(response => {
    orderList.value = response.rows
    orderTotal.value = response.total
    orderLoading.value = false
  }).catch(() => {
    orderLoading.value = false
  })
}

function handleOrderQuery() {
  orderQuery.value.pageNum = 1
  getOrderList()
}

function resetOrderQuery() {
  proxy.resetForm('orderQueryRef')
  handleOrderQuery()
}

function handleChangeLevel(row) {
  changeForm.value = {
    orderId: row.orderId,
    orderNo: row.orderNo,
    oldLevel: row.faultLevel,
    faultLevel: row.faultLevel,
    remark: undefined
  }
  changeOpen.value = true
}

function submitChangeLevel() {
  proxy.$refs['changeRef'].validate(valid => {
    if (!valid) {
      return
    }
    changeOrderLevel(changeForm.value).then(() => {
      proxy.$modal.msgSuccess('等级调整成功')
      changeOpen.value = false
      getOrderList()
    })
  })
}

getLevelList()
getOrderList()
</script>
