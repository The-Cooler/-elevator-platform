<template>
  <div class="app-container">
    <el-card shadow="never">
      <template #header>
        <div class="page-card-header">
          <span class="page-card-title">维保档案归档</span>
          <span class="page-card-desc">
            汇总每次维保与巡检详情，形成电梯全生命周期历史维保记录，支持按电梯、时间、执行人检索与导出
          </span>
        </div>
      </template>

      <el-form :model="queryParams" ref="queryRef" :inline="true" v-show="showSearch">
        <el-form-item label="电梯编号" prop="elevatorCode">
          <el-input
            v-model="queryParams.elevatorCode"
            placeholder="请输入电梯编号"
            clearable
            style="width: 170px"
            @keyup.enter="handleQuery"
          />
        </el-form-item>
        <el-form-item label="归档类型" prop="archiveType">
          <el-select v-model="queryParams.archiveType" placeholder="归档类型" clearable style="width: 140px">
            <el-option label="巡检" value="inspection" />
            <el-option label="维保" value="maintain" />
            <el-option label="维修" value="repair" />
          </el-select>
        </el-form-item>
        <el-form-item label="维保类型" prop="maintainType">
          <dict-select v-model="queryParams.maintainType" dict-type="maintain_type" placeholder="维保类型" width="150px" />
        </el-form-item>
        <el-form-item label="执行人" prop="executorName">
          <el-input
            v-model="queryParams.executorName"
            placeholder="请输入执行人"
            clearable
            style="width: 150px"
            @keyup.enter="handleQuery"
          />
        </el-form-item>
        <el-form-item label="执行日期">
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
            type="warning"
            plain
            icon="Download"
            @click="handleExport"
            v-hasPermi="['maintain:archive:export']"
          >导出档案</el-button>
        </el-col>
        <el-col :span="1.5">
          <el-button type="info" plain icon="View" :disabled="single" @click="handleElevatorArchive">
            查看该电梯履历
          </el-button>
        </el-col>
        <right-toolbar v-model:showSearch="showSearch" @queryTable="getList"></right-toolbar>
      </el-row>

      <el-table v-loading="loading" :data="archiveList" @selection-change="handleSelectionChange">
        <el-table-column type="selection" width="55" align="center" />
        <el-table-column label="电梯编号" align="center" prop="elevatorCode" width="120" />
        <el-table-column label="电梯位置" align="center" width="190" :show-overflow-tooltip="true">
          <template #default="scope">
            {{ scope.row.communityName }} {{ scope.row.buildingNo }} {{ scope.row.unitNo }}
          </template>
        </el-table-column>
        <el-table-column label="归档类型" align="center" width="100">
          <template #default="scope">
            <el-tag :type="archiveTypeTag(scope.row.archiveType)" size="small">
              {{ archiveTypeName(scope.row.archiveType) }}
            </el-tag>
          </template>
        </el-table-column>
        <el-table-column label="维保类型" align="center" width="105">
          <template #default="scope">{{ maintainTypeName(scope.row.maintainType) }}</template>
        </el-table-column>
        <el-table-column label="执行日期" align="center" prop="executeDate" width="120" />
        <el-table-column label="执行人" align="center" prop="executorName" width="120" />
        <el-table-column label="记录摘要" align="center" prop="summary" :show-overflow-tooltip="true" min-width="260" />
        <el-table-column label="状态" align="center" width="100">
          <template #default="scope">
            <el-tag v-if="scope.row.isAbnormal === '1'" type="warning" size="small">含异常</el-tag>
            <el-tag v-else type="success" size="small">正常</el-tag>
          </template>
        </el-table-column>
        <el-table-column label="归档时间" align="center" prop="archiveTime" width="165" />
        <el-table-column label="操作" align="center" width="100" fixed="right">
          <template #default="scope">
            <el-button link type="primary" icon="View" @click="handleDetail(scope.row)">详情</el-button>
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

    <!-- 电梯全生命周期履历 -->
    <el-dialog v-model="historyOpen" title="电梯维保履历" width="860px" append-to-body destroy-on-close>
      <div v-loading="historyLoading">
        <el-alert type="info" :closable="false" show-icon class="mb20"
          :title="`电梯 ${historyElevatorCode} 的全部历史维保记录，共 ${historyList.length} 条`" />

        <!-- 维保完成率与巡检合格率 -->
        <el-row :gutter="16" class="mb20" v-if="statistics">
          <el-col :span="12">
            <div class="rate-card">
              <p class="rate-label">维保完成率</p>
              <el-progress
                type="dashboard"
                :percentage="Number(statistics.maintainRate || 0)"
                :color="rateColor(statistics.maintainRate)"
              />
            </div>
          </el-col>
          <el-col :span="12">
            <div class="rate-card">
              <p class="rate-label">巡检合格率</p>
              <el-progress
                type="dashboard"
                :percentage="Number(statistics.inspectPassRate || 0)"
                :color="rateColor(statistics.inspectPassRate)"
              />
            </div>
          </el-col>
        </el-row>

        <el-timeline v-if="historyList.length">
          <el-timeline-item
            v-for="item in historyList"
            :key="item.archiveId"
            :timestamp="item.executeDate"
            placement="top"
            :type="item.isAbnormal === '1' ? 'warning' : 'success'"
          >
            <div class="history-item">
              <div class="history-head">
                <span class="history-type">{{ maintainTypeName(item.maintainType) }}</span>
                <el-tag v-if="item.isAbnormal === '1'" type="warning" size="small">含异常项</el-tag>
              </div>
              <p class="history-summary">{{ item.summary }}</p>
              <p class="history-meta">执行人：{{ item.executorName || '—' }}｜归档时间：{{ item.archiveTime }}</p>
            </div>
          </el-timeline-item>
        </el-timeline>
        <el-empty v-else-if="!historyLoading" description="该电梯暂无历史维保记录" />
      </div>
    </el-dialog>

    <!-- 档案详情 -->
    <el-dialog v-model="detailOpen" title="档案详情" width="760px" append-to-body destroy-on-close>
      <el-descriptions :column="2" border v-if="detailRecord">
        <el-descriptions-item label="电梯编号">{{ detailRecord.elevatorCode }}</el-descriptions-item>
        <el-descriptions-item label="归档类型">{{ archiveTypeName(detailRecord.archiveType) }}</el-descriptions-item>
        <el-descriptions-item label="维保类型">{{ maintainTypeName(detailRecord.maintainType) }}</el-descriptions-item>
        <el-descriptions-item label="执行日期">{{ detailRecord.executeDate }}</el-descriptions-item>
        <el-descriptions-item label="执行人">{{ detailRecord.executorName || '—' }}</el-descriptions-item>
        <el-descriptions-item label="归档时间">{{ detailRecord.archiveTime }}</el-descriptions-item>
        <el-descriptions-item label="电梯位置" :span="2">
          {{ detailRecord.communityName }} {{ detailRecord.buildingNo }} {{ detailRecord.unitNo }}
        </el-descriptions-item>
        <el-descriptions-item label="记录摘要" :span="2">{{ detailRecord.summary }}</el-descriptions-item>
      </el-descriptions>
    </el-dialog>
  </div>
</template>

<script setup name="Archive">
import { ref, reactive, toRefs, getCurrentInstance } from 'vue'
import { listArchive, listArchiveByElevator, getArchiveStatistics } from '@/api/maintain/archive'
import DictSelect from '@/views/components/DictSelect.vue'

const { proxy } = getCurrentInstance()

const loading = ref(true)
const showSearch = ref(true)
const archiveList = ref([])
const total = ref(0)
const ids = ref([])
const single = ref(true)
const dateRange = ref([])

const historyOpen = ref(false)
const historyLoading = ref(false)
const historyList = ref([])
const historyElevatorCode = ref('')
const statistics = ref(null)

const detailOpen = ref(false)
const detailRecord = ref(null)

const data = reactive({
  queryParams: {
    pageNum: 1,
    pageSize: 10,
    elevatorCode: undefined,
    archiveType: undefined,
    maintainType: undefined,
    executorName: undefined,
    beginTime: undefined,
    endTime: undefined
  }
})
const { queryParams } = toRefs(data)

const maintainTypeMap = {
  half_month: '半月保',
  quarter: '季度检',
  half_year: '半年保',
  annual: '年检'
}
const maintainTypeName = type => maintainTypeMap[type] || type || '—'

const archiveTypeMap = { inspection: '巡检', maintain: '维保', repair: '维修' }
const archiveTypeName = type => archiveTypeMap[type] || type || '—'
const archiveTypeTag = type => {
  if (type === 'inspection') return 'primary'
  if (type === 'maintain') return 'success'
  return 'warning'
}

/** 查询维保档案列表 */
function getList() {
  loading.value = true
  queryParams.value.beginTime = dateRange.value?.[0]
  queryParams.value.endTime = dateRange.value?.[1]
  listArchive(queryParams.value)
    .then(response => {
      archiveList.value = response.rows
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
  ids.value = selection.map(item => item.archiveId)
  single.value = selection.length !== 1
}

function rateColor(rate) {
  const value = Number(rate || 0)
  if (value >= 80) return '#67c23a'
  if (value >= 50) return '#e6a23c'
  return '#f56c6c'
}

/** 查看选中电梯的全生命周期维保履历与完成情况统计 */
function handleElevatorArchive() {
  const row = archiveList.value.find(item => item.archiveId === ids.value[0])
  if (!row) return
  historyElevatorCode.value = row.elevatorCode
  historyList.value = []
  statistics.value = null
  historyOpen.value = true
  historyLoading.value = true

  Promise.all([
    listArchiveByElevator(row.elevatorId),
    getArchiveStatistics(row.elevatorId)
  ])
    .then(([archiveRes, statRes]) => {
      historyList.value = archiveRes.data || []
      statistics.value = statRes.data || null
    })
    .catch(() => {
      historyList.value = []
      statistics.value = null
    })
    .finally(() => {
      historyLoading.value = false
    })
}

function handleDetail(row) {
  detailRecord.value = row
  detailOpen.value = true
}

function handleExport() {
  proxy.download('/maintain/archive/export', { ...queryParams.value }, `维保档案_${new Date().getTime()}.xlsx`)
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
.rate-card {
  display: flex;
  flex-direction: column;
  align-items: center;
  padding: 16px;
  background: #f5f7fa;
  border-radius: 8px;
}
.rate-label {
  margin-bottom: 8px;
  font-size: 14px;
  font-weight: 600;
  color: #303133;
}
.history-item {
  padding: 12px 16px;
  border: 1px solid #ebeef5;
  border-radius: 6px;
  background: #fafafa;
}
.history-head {
  display: flex;
  align-items: center;
  gap: 10px;
}
.history-type {
  font-size: 14px;
  font-weight: 600;
  color: #303133;
}
.history-summary {
  margin-top: 6px;
  font-size: 13px;
  color: #606266;
}
.history-meta {
  margin-top: 6px;
  font-size: 12px;
  color: #909399;
}
</style>
