<template>
  <div class="app-container">
    <el-card shadow="never">
      <template #header>
        <div class="page-card-header">
          <span class="page-card-title">定期巡检执行</span>
          <span class="page-card-desc">
            系统按维保周期自动生成巡检工单并派发，维修员现场打卡、逐项勾选检查结果并上传，提交后自动归档
          </span>
        </div>
      </template>

      <el-form :model="queryParams" ref="queryRef" :inline="true" v-show="showSearch">
        <el-form-item label="巡检单号" prop="recordNo">
          <el-input
            v-model="queryParams.recordNo"
            placeholder="请输入巡检单号"
            clearable
            style="width: 180px"
            @keyup.enter="handleQuery"
          />
        </el-form-item>
        <el-form-item label="维保类型" prop="maintainType">
          <dict-select v-model="queryParams.maintainType" dict-type="maintain_type" placeholder="维保类型" width="160px" />
        </el-form-item>
        <el-form-item label="执行状态" prop="recordStatus">
          <el-select v-model="queryParams.recordStatus" placeholder="执行状态" clearable style="width: 150px">
            <el-option label="待执行" value="pending" />
            <el-option label="已完成" value="finished" />
            <el-option label="已超期" value="overdue" />
          </el-select>
        </el-form-item>
        <el-form-item label="计划日期">
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
            icon="Plus"
            @click="handleGenerate"
            v-hasPermi="['maintain:inspection:execute']"
          >手动生成巡检工单</el-button>
        </el-col>
        <el-col :span="1.5">
          <el-button
            type="warning"
            plain
            icon="Download"
            @click="handleExport"
            v-hasPermi="['maintain:inspection:export']"
          >导出</el-button>
        </el-col>
        <el-col :span="1.5">
          <el-checkbox v-model="onlyMine" @change="handleQuery">只看指派给我的</el-checkbox>
        </el-col>
        <right-toolbar v-model:showSearch="showSearch" @queryTable="getList"></right-toolbar>
      </el-row>

      <el-table v-loading="loading" :data="recordList">
        <el-table-column label="巡检单号" align="center" prop="recordNo" width="185" :show-overflow-tooltip="true" />
        <el-table-column label="电梯编号" align="center" prop="elevatorCode" width="120" />
        <el-table-column label="电梯位置" align="center" width="190" :show-overflow-tooltip="true">
          <template #default="scope">
            {{ scope.row.communityName }} {{ scope.row.buildingNo }} {{ scope.row.unitNo }}
          </template>
        </el-table-column>
        <el-table-column label="维保类型" align="center" width="105">
          <template #default="scope">{{ maintainTypeName(scope.row.maintainType) }}</template>
        </el-table-column>
        <el-table-column label="计划日期" align="center" prop="planDate" width="120" />
        <el-table-column label="执行人" align="center" prop="executorName" width="120" />
        <el-table-column label="打卡时间" align="center" prop="clockInTime" width="165" />
        <el-table-column label="执行状态" align="center" width="110">
          <template #default="scope">
            <el-tag :type="statusTagType(scope.row.recordStatus)" size="small">
              {{ statusName(scope.row.recordStatus) }}
            </el-tag>
          </template>
        </el-table-column>
        <el-table-column label="检查结果" align="center" width="130">
          <template #default="scope">
            <template v-if="scope.row.recordStatus === 'finished'">
              <span class="result-normal">正常 {{ scope.row.normalCount }}</span>
              <span v-if="scope.row.abnormalCount" class="result-abnormal">
                ／异常 {{ scope.row.abnormalCount }}
              </span>
              <span v-else-if="scope.row.naCount" class="result-na">／不适用 {{ scope.row.naCount }}</span>
            </template>
            <span v-else class="result-pending">—</span>
          </template>
        </el-table-column>
        <el-table-column label="操作" align="center" width="170" fixed="right">
          <template #default="scope">
            <el-button
              v-if="scope.row.recordStatus !== 'finished'"
              link
              type="primary"
              icon="Edit"
              @click="handleExecute(scope.row)"
              v-hasPermi="['maintain:inspection:execute']"
            >执行巡检</el-button>
            <el-button link type="info" icon="View" @click="handleDetail(scope.row)">详情</el-button>
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

    <!-- 巡检执行 -->
    <el-dialog
      v-model="executeOpen"
      :title="`执行巡检 - ${executeForm.recordNo || ''}`"
      width="880px"
      append-to-body
      destroy-on-close
      :close-on-click-modal="false"
    >
      <div v-loading="executeLoading">
        <el-alert type="info" :closable="false" show-icon class="mb20">
          <template #title>
            电梯 {{ executeForm.elevatorCode }}｜{{ executeForm.communityName }} {{ executeForm.buildingNo }}
            {{ executeForm.unitNo }}｜{{ maintainTypeName(executeForm.maintainType) }}
          </template>
        </el-alert>

        <!-- 打卡区 -->
        <div class="clock-block">
          <div class="clock-info">
            <p class="clock-label">现场打卡</p>
            <p v-if="executeForm.clockInTime" class="clock-time">
              已打卡：{{ executeForm.clockInTime }}
              <span v-if="executeForm.clockInLocation">｜{{ executeForm.clockInLocation }}</span>
            </p>
            <p v-else class="clock-tip">请先完成现场打卡，再逐项填写检查结果</p>
          </div>
          <el-button
            v-if="!executeForm.clockInTime"
            type="primary"
            icon="Location"
            :loading="clockingIn"
            @click="handleClockIn"
          >现场打卡</el-button>
        </div>

        <el-form :model="clockForm" label-width="90px" class="clock-form">
          <el-form-item label="打卡位置">
            <el-input
              v-model="clockForm.location"
              placeholder="如：阳光家园小区1号楼1单元"
              :disabled="!!executeForm.clockInTime"
              style="max-width: 420px"
            />
          </el-form-item>
        </el-form>

        <!-- 检查项清单 -->
        <el-table :data="itemList" max-height="420" :row-class-name="rowClassName">
          <el-table-column label="序号" align="center" prop="orderNum" width="65" />
          <el-table-column label="检查项" align="center" prop="itemName" :show-overflow-tooltip="true" min-width="170" />
          <el-table-column label="检查标准" align="center" prop="checkStandard" :show-overflow-tooltip="true" min-width="190" />
          <el-table-column label="检查结果" align="center" width="230">
            <template #default="scope">
              <el-radio-group v-model="scope.row.checkResult" size="small">
                <el-radio-button value="normal">正常</el-radio-button>
                <el-radio-button value="abnormal">异常</el-radio-button>
                <el-radio-button value="na">不适用</el-radio-button>
              </el-radio-group>
            </template>
          </el-table-column>
          <el-table-column label="异常说明" align="center" min-width="180">
            <template #default="scope">
              <el-input
                v-model="scope.row.abnormalDesc"
                size="small"
                placeholder="异常时填写"
                :disabled="scope.row.checkResult !== 'abnormal'"
              />
            </template>
          </el-table-column>
          <el-table-column label="现场照片" align="center" width="130">
            <template #default="scope">
              <div class="upload-cell">
                <template v-if="scope.row.fileId">
                  <el-image
                    :src="previewUrl(scope.row.fileId)"
                    :preview-src-list="[previewUrl(scope.row.fileId)]"
                    fit="cover"
                    class="upload-thumb"
                  />
                  <el-button link type="danger" size="small" @click="removeItemPhoto(scope.row)">移除</el-button>
                </template>
                <el-upload
                  v-else
                  :show-file-list="false"
                  :http-request="options => uploadItemPhoto(options, scope.row)"
                  accept="image/jpeg,image/png,image/webp,image/bmp"
                >
                  <el-button size="small" icon="Camera" :loading="scope.row.uploading">上传</el-button>
                </el-upload>
              </div>
            </template>
          </el-table-column>
        </el-table>

        <div class="summary-bar">
          <span>共 {{ itemList.length }} 项</span>
          <span class="result-normal">正常 {{ normalCount }}</span>
          <span class="result-abnormal">异常 {{ abnormalCount }}</span>
          <span class="result-na">不适用 {{ naCount }}</span>
        </div>
      </div>

      <template #footer>
        <div class="dialog-footer">
          <el-button @click="executeOpen = false">取消</el-button>
          <el-button
            type="primary"
            :loading="submitting"
            :disabled="!executeForm.clockInTime"
            @click="submitExecute"
          >提交巡检结果</el-button>
        </div>
      </template>
    </el-dialog>

    <!-- 巡检详情 -->
    <el-dialog v-model="detailOpen" title="巡检详情" width="820px" append-to-body destroy-on-close>
      <el-descriptions :column="2" border size="small" class="mb20" v-if="detailRecord">
        <el-descriptions-item label="巡检单号">{{ detailRecord.recordNo }}</el-descriptions-item>
        <el-descriptions-item label="执行状态">{{ statusName(detailRecord.recordStatus) }}</el-descriptions-item>
        <el-descriptions-item label="电梯编号">{{ detailRecord.elevatorCode }}</el-descriptions-item>
        <el-descriptions-item label="维保类型">{{ maintainTypeName(detailRecord.maintainType) }}</el-descriptions-item>
        <el-descriptions-item label="计划日期">{{ detailRecord.planDate }}</el-descriptions-item>
        <el-descriptions-item label="执行人">{{ detailRecord.executorName || '—' }}</el-descriptions-item>
        <el-descriptions-item label="打卡时间">{{ detailRecord.clockInTime || '—' }}</el-descriptions-item>
        <el-descriptions-item label="打卡位置">{{ detailRecord.clockInLocation || '—' }}</el-descriptions-item>
        <el-descriptions-item label="检查结果" :span="2">
          正常 {{ detailRecord.normalCount }} 项，异常 {{ detailRecord.abnormalCount }} 项，不适用 {{ detailRecord.naCount }} 项
        </el-descriptions-item>
        <el-descriptions-item v-if="detailRecord.abnormalDesc" label="异常说明" :span="2">
          {{ detailRecord.abnormalDesc }}
        </el-descriptions-item>
      </el-descriptions>

      <el-table :data="detailItems" max-height="380">
        <el-table-column label="序号" align="center" prop="orderNum" width="65" />
        <el-table-column label="检查项" align="center" prop="itemName" :show-overflow-tooltip="true" min-width="170" />
        <el-table-column label="检查标准" align="center" prop="checkStandard" :show-overflow-tooltip="true" min-width="180" />
        <el-table-column label="结果" align="center" width="95">
          <template #default="scope">
            <el-tag :type="resultTagType(scope.row.checkResult)" size="small">
              {{ resultName(scope.row.checkResult) }}
            </el-tag>
          </template>
        </el-table-column>
        <el-table-column label="异常说明" align="center" prop="abnormalDesc" :show-overflow-tooltip="true" min-width="160" />
      </el-table>
    </el-dialog>
  </div>
</template>

<script setup name="Inspection">
import { ref, reactive, toRefs, computed, getCurrentInstance } from 'vue'
import {
  listInspection,
  listMyInspection,
  listInspectionItems,
  clockIn,
  submitInspection,
  generateInspection,
  exportInspection,
  uploadInspectionPhoto
} from '@/api/maintain/inspection'
import DictSelect from '@/views/components/DictSelect.vue'

const { proxy } = getCurrentInstance()

const loading = ref(true)
const showSearch = ref(true)
const submitting = ref(false)
const onlyMine = ref(false)
const recordList = ref([])
const total = ref(0)
const dateRange = ref([])

const executeOpen = ref(false)
const executeLoading = ref(false)
const clockingIn = ref(false)
const itemList = ref([])
const clockForm = reactive({ location: '' })

const detailOpen = ref(false)
const detailRecord = ref(null)
const detailItems = ref([])

const data = reactive({
  queryParams: {
    pageNum: 1,
    pageSize: 10,
    recordNo: undefined,
    maintainType: undefined,
    recordStatus: undefined,
    beginTime: undefined,
    endTime: undefined
  },
  executeForm: {}
})
const { queryParams, executeForm } = toRefs(data)

const maintainTypeMap = {
  half_month: '半月保',
  quarter: '季度检',
  half_year: '半年保',
  annual: '年检'
}
const maintainTypeName = type => maintainTypeMap[type] || type || '—'

const statusMap = { pending: '待执行', finished: '已完成', overdue: '已超期' }
const statusName = status => statusMap[status] || status || '—'
const statusTagType = status => {
  if (status === 'finished') return 'success'
  if (status === 'overdue') return 'danger'
  return 'warning'
}

const resultMap = { normal: '正常', abnormal: '异常', na: '不适用' }
const resultName = result => resultMap[result] || result || '—'
const resultTagType = result => {
  if (result === 'normal') return 'success'
  if (result === 'abnormal') return 'danger'
  return 'info'
}

/** 汇总当前已填写的检查结果数量 */
const normalCount = computed(() => itemList.value.filter(i => i.checkResult === 'normal').length)
const abnormalCount = computed(() => itemList.value.filter(i => i.checkResult === 'abnormal').length)
const naCount = computed(() => itemList.value.filter(i => i.checkResult === 'na').length)

const rowClassName = ({ row }) => (row.checkResult === 'abnormal' ? 'row-abnormal' : '')

/** 检查项现场照片的预览地址，走文件预览接口 */
function previewUrl(fileId) {
  const base = import.meta.env.VITE_APP_BASE_API || ''
  return `${base}/common/file/preview/${fileId}`
}

/**
 * 上传检查项现场照片
 * 对应论文模块四「发现异常项填写异常说明并上传现场照片」
 */
async function uploadItemPhoto(options, row) {
  row.uploading = true
  try {
    const response = await uploadInspectionPhoto(options.file, executeForm.value.recordId)
    row.fileId = response.fileId
    proxy.$modal.msgSuccess('照片上传成功')
  } catch (e) {
    proxy.$modal.msgError(e.message || '照片上传失败')
  } finally {
    row.uploading = false
  }
}

/** 移除已上传的现场照片 */
function removeItemPhoto(row) {
  row.fileId = null
}

/** 查询巡检记录列表 */
function getList() {
  loading.value = true
  queryParams.value.beginTime = dateRange.value?.[0]
  queryParams.value.endTime = dateRange.value?.[1]
  const request = onlyMine.value ? listMyInspection : listInspection
  request(queryParams.value)
    .then(response => {
      recordList.value = response.rows
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

/** 手动触发生成到期巡检工单 */
function handleGenerate() {
  proxy
    .$confirm('将扫描所有到期的维保计划并按周期生成巡检工单，确认继续吗？', '生成巡检工单', { type: 'info' })
    .then(() => generateInspection())
    .then(response => {
      proxy.$modal.msgSuccess(response.msg || '生成完成')
      getList()
    })
    .catch(() => {})
}

/** 打开巡检执行弹窗，加载检查项清单 */
function handleExecute(row) {
  executeForm.value = { ...row }
  clockForm.location = `${row.communityName || ''}${row.buildingNo || ''}${row.unitNo || ''}`
  itemList.value = []
  executeOpen.value = true
  executeLoading.value = true
  listInspectionItems(row.recordId)
    .then(response => {
      const items = response.data || []
      itemList.value = items.map(item => ({
        itemId: item.itemId,
        itemName: item.itemName,
        itemCategory: item.itemCategory,
        checkStandard: item.checkStandard,
        orderNum: item.orderNum,
        checkResult: 'normal',
        abnormalDesc: '',
        fileId: item.fileId || null,
        uploading: false
      }))
    })
    .finally(() => {
      executeLoading.value = false
    })
}

/** 现场打卡 */
function handleClockIn() {
  clockingIn.value = true
  clockIn(executeForm.value.recordId, clockForm.location)
    .then(() => {
      proxy.$modal.msgSuccess('打卡成功')
      // 打卡成功后刷新弹窗内的打卡信息
      return listInspection(executeForm.value.recordId ? { pageNum: 1, pageSize: 1, recordNo: executeForm.value.recordNo } : {})
    })
    .then(response => {
      const fresh = response?.rows?.[0]
      if (fresh) {
        executeForm.value = { ...executeForm.value, ...fresh }
      }
    })
    .catch(() => {
      // 打卡成功但刷新失败时，本地补上时间，保证可继续提交
      if (!executeForm.value.clockInTime) {
        executeForm.value.clockInTime = new Date().toLocaleString('zh-CN', { hour12: false })
        executeForm.value.clockInLocation = clockForm.location
      }
    })
    .finally(() => {
      clockingIn.value = false
    })
}

/** 提交巡检结果 */
function submitExecute() {
  const abnormalMissing = itemList.value.filter(i => i.checkResult === 'abnormal' && !i.abnormalDesc.trim())
  if (abnormalMissing.length) {
    proxy.$modal.msgWarning(`请为以下异常项填写说明：${abnormalMissing.map(i => i.itemName).join('、')}`)
    return
  }
  submitting.value = true
  submitInspection({
    recordId: executeForm.value.recordId,
    submitItems: itemList.value.map(item => ({
      itemId: item.itemId,
      itemName: item.itemName,
      itemCategory: item.itemCategory,
      checkResult: item.checkResult,
      abnormalDesc: item.abnormalDesc,
      fileId: item.fileId || null,
      orderNum: item.orderNum
    }))
  })
    .then(() => {
      proxy.$modal.msgSuccess('巡检已提交并归档')
      executeOpen.value = false
      getList()
    })
    .finally(() => {
      submitting.value = false
    })
}

/** 查看巡检详情与检查项结果 */
function handleDetail(row) {
  detailRecord.value = row
  detailItems.value = []
  detailOpen.value = true
  listInspectionItems(row.recordId)
    .then(response => {
      detailItems.value = response.data || []
    })
    .catch(() => {
      detailItems.value = []
    })
}

function handleExport() {
  proxy.download('/maintain/inspection/export', { ...queryParams.value }, `巡检记录_${new Date().getTime()}.xlsx`)
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
.mb20 {
  margin-bottom: 16px;
}
.clock-block {
  display: flex;
  align-items: center;
  justify-content: space-between;
  padding: 14px 16px;
  background: #f5f7fa;
  border-radius: 6px;
}
.clock-label {
  font-size: 14px;
  font-weight: 600;
  color: #303133;
}
.clock-time {
  margin-top: 4px;
  font-size: 13px;
  color: #67c23a;
}
.clock-tip {
  margin-top: 4px;
  font-size: 13px;
  color: #909399;
}
.clock-form {
  margin-top: 12px;
}
.summary-bar {
  display: flex;
  gap: 20px;
  margin-top: 12px;
  padding: 10px 16px;
  font-size: 13px;
  color: #606266;
  background: #f5f7fa;
  border-radius: 6px;
}
.result-normal {
  color: #67c23a;
}
.result-abnormal {
  color: #f56c6c;
}
.result-na {
  color: #909399;
}
.result-pending {
  color: #c0c4cc;
}
:deep(.row-abnormal) {
  background: #fef0f0;
}
</style>
