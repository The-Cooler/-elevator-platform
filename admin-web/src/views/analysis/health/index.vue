<template>
  <div class="app-container">
    <el-card shadow="never">
      <template #header>
        <div class="page-card-header">
          <span class="page-card-title">电梯健康档案生成</span>
          <span class="page-card-desc">
            综合故障率、维保完成率、巡检合格率按权重生成健康评分，按评分升序排列，问题电梯前置
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
        <el-form-item label="小区" prop="queryCommunityId">
          <el-select v-model="queryParams.queryCommunityId" placeholder="全部小区" clearable style="width: 200px">
            <el-option
              v-for="item in communityList"
              :key="item.communityId"
              :label="item.communityName"
              :value="item.communityId"
            />
          </el-select>
        </el-form-item>
        <el-form-item label="健康等级" prop="healthLevel">
          <el-select v-model="queryParams.healthLevel" placeholder="健康等级" clearable style="width: 150px">
            <el-option label="优秀（90 分及以上）" value="excellent" />
            <el-option label="良好（80-89 分）" value="good" />
            <el-option label="一般（70-79 分）" value="fair" />
            <el-option label="较差（60-69 分）" value="poor" />
            <el-option label="危险（60 分以下）" value="danger" />
          </el-select>
        </el-form-item>
        <el-form-item label="统计周期" prop="statPeriod">
          <el-input v-model="queryParams.statPeriod" placeholder="如 2026-10" clearable style="width: 140px" />
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
            icon="Refresh"
            @click="handleRecalculate"
            v-hasPermi="['analysis:health:export']"
          >重算全部评分</el-button>
        </el-col>
        <el-col :span="1.5">
          <el-button plain icon="InfoFilled" @click="handleConfig">评分模型说明</el-button>
        </el-col>
        <right-toolbar v-model:showSearch="showSearch" @queryTable="getList"></right-toolbar>
      </el-row>

      <el-table v-loading="loading" :data="healthList">
        <el-table-column label="电梯编号" align="center" prop="elevatorCode" width="120" />
        <el-table-column label="品牌" align="center" prop="brand" width="90" />
        <el-table-column label="电梯位置" align="center" width="190" :show-overflow-tooltip="true">
          <template #default="scope">
            {{ scope.row.communityName }} {{ scope.row.buildingNo }} {{ scope.row.unitNo }}
          </template>
        </el-table-column>
        <el-table-column label="健康评分" align="center" width="130" sortable prop="healthScore">
          <template #default="scope">
            <span class="score" :style="{ color: scoreColor(scope.row.healthScore) }">
              {{ scope.row.healthScore }}
            </span>
          </template>
        </el-table-column>
        <el-table-column label="健康等级" align="center" width="110">
          <template #default="scope">
            <el-tag :type="levelTagType(scope.row.healthLevel)" size="small" effect="dark">
              {{ scope.row.healthLevelName }}
            </el-tag>
          </template>
        </el-table-column>
        <el-table-column label="故障率得分" align="center" width="120">
          <template #default="scope">
            {{ scope.row.faultScore }}<span class="weight">×40%</span>
          </template>
        </el-table-column>
        <el-table-column label="维保完成率" align="center" width="140">
          <template #default="scope">
            {{ scope.row.maintainRate }}%<span class="weight">×30%</span>
          </template>
        </el-table-column>
        <el-table-column label="巡检合格率" align="center" width="140">
          <template #default="scope">
            {{ scope.row.inspectRate }}%<span class="weight">×30%</span>
          </template>
        </el-table-column>
        <el-table-column label="维护建议" align="center" prop="suggestion" :show-overflow-tooltip="true" min-width="240" />
        <el-table-column label="操作" align="center" width="150" fixed="right">
          <template #default="scope">
            <el-button link type="primary" icon="View" @click="handleDetail(scope.row)">报告</el-button>
            <el-button link type="success" icon="Refresh" @click="handleRecalcOne(scope.row)">重算</el-button>
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

    <!-- 健康评分报告 -->
    <el-dialog v-model="detailOpen" title="电梯健康评分报告" width="880px" append-to-body destroy-on-close>
      <div v-loading="detailLoading">
        <template v-if="report">
          <!-- 总分 -->
          <div class="report-head">
            <div class="report-score">
              <el-progress
                type="dashboard"
                :percentage="Number(report.healthScore || 0)"
                :width="160"
                :stroke-width="12"
                :color="scoreColor(report.healthScore)"
              >
                <template #default="{ percentage }">
                  <span class="score-big" :style="{ color: scoreColor(report.healthScore) }">{{ percentage }}</span>
                  <span class="score-unit">分</span>
                </template>
              </el-progress>
              <el-tag :type="levelTagType(report.healthLevel)" size="large" effect="dark" class="mt8">
                {{ report.healthLevelName }}
              </el-tag>
            </div>
            <div class="report-meta">
              <p><span class="meta-label">电梯编号：</span>{{ report.elevatorCode }}</p>
              <p><span class="meta-label">电梯位置：</span>{{ report.communityName }} {{ report.buildingNo }} {{ report.unitNo }}</p>
              <p><span class="meta-label">统计周期：</span>{{ report.statPeriod }}（{{ formatDate(report.statStartDate) }} 至 {{ formatDate(report.statEndDate) }}）</p>
              <p><span class="meta-label">计算时间：</span>{{ report.calcTime }}</p>
            </div>
          </div>

          <!-- 指标构成明细 -->
          <h3 class="section-title">指标构成明细</h3>
          <el-table :data="indicatorRows" border size="small">
            <el-table-column label="指标" align="center" prop="name" width="150" />
            <el-table-column label="原始数据" align="center" prop="raw" min-width="200" />
            <el-table-column label="折算得分" align="center" prop="score" width="110" />
            <el-table-column label="权重" align="center" prop="weight" width="90" />
            <el-table-column label="加权得分" align="center" prop="weighted" width="110" />
          </el-table>

          <!-- 历史趋势 -->
          <h3 class="section-title">历史评分趋势</h3>
          <div ref="trendChartRef" v-loading="trendLoading" class="trend-box"></div>

          <!-- 维护建议 -->
          <h3 class="section-title">维护建议</h3>
          <el-alert
            :type="report.healthLevel === 'danger' || report.healthLevel === 'poor' ? 'error' : 'info'"
            :closable="false"
            show-icon
            :title="report.suggestion"
          />

          <div class="report-actions">
            <el-button type="danger" plain icon="Document" @click="handleExportPdf">导出 PDF</el-button>
            <el-button type="success" plain icon="Document" @click="handleExportExcel">导出 Excel</el-button>
          </div>
        </template>
      </div>
    </el-dialog>

    <!-- 评分模型说明 -->
    <el-dialog v-model="configOpen" title="评分模型说明" width="640px" append-to-body destroy-on-close>
      <el-descriptions :column="1" border v-if="config">
        <el-descriptions-item label="评分公式">{{ config.scoreModel }}</el-descriptions-item>
        <el-descriptions-item label="指标权重">
          故障率 {{ config.faultWeight }}，维保完成率 {{ config.maintainWeight }}，巡检合格率 {{ config.inspectWeight }}
        </el-descriptions-item>
        <el-descriptions-item label="统计周期">{{ config.periodDays }} 天（即一个季度）</el-descriptions-item>
        <el-descriptions-item label="健康等级划分">{{ config.levelRule }}</el-descriptions-item>
      </el-descriptions>
      <p class="config-note">
        故障率得分：统计周期内无故障得 100 分，每发生 1 次故障扣 10 分，紧急故障额外扣 5 分，下限 0 分；
        维保完成率得分与巡检合格率得分直接取对应百分比数值。
      </p>
    </el-dialog>
  </div>
</template>

<script setup name="Health">
import { ref, reactive, toRefs, computed, nextTick, onBeforeUnmount, getCurrentInstance } from 'vue'
import * as echarts from 'echarts'
import {
  listHealth,
  getHealth,
  getHealthTrend,
  getHealthConfig,
  exportHealthPdf,
  exportHealthExcel
} from '@/api/analysis/health'
import { listCommunity } from '@/api/basic/community'
import request from '@/utils/request'

const { proxy } = getCurrentInstance()

const loading = ref(true)
const showSearch = ref(true)
const healthList = ref([])
const total = ref(0)
const communityList = ref([])

const detailOpen = ref(false)
const detailLoading = ref(false)
const report = ref(null)
const trendLoading = ref(false)
const trendChartRef = ref(null)
let trendChart = null

const configOpen = ref(false)
const config = ref(null)

const data = reactive({
  queryParams: {
    pageNum: 1,
    pageSize: 10,
    elevatorCode: undefined,
    queryCommunityId: undefined,
    healthLevel: undefined,
    statPeriod: undefined
  }
})
const { queryParams } = toRefs(data)

/** 指标构成明细表数据 */
const indicatorRows = computed(() => {
  if (!report.value) return []
  const r = report.value
  return [
    {
      name: '故障率',
      raw: `统计周期内故障 ${r.faultCount} 次`,
      score: r.faultScore,
      weight: '40%',
      weighted: (Number(r.faultScore || 0) * 0.4).toFixed(2)
    },
    {
      name: '维保完成率',
      raw: `应执行 ${r.maintainDone} 次，实际执行 ${r.maintainFinish} 次`,
      score: `${r.maintainRate}%`,
      weight: '30%',
      weighted: (Number(r.maintainRate || 0) * 0.3).toFixed(2)
    },
    {
      name: '巡检合格率',
      raw: `检查项 ${r.inspectTotal} 项，正常 ${r.inspectNormal} 项`,
      score: `${r.inspectRate}%`,
      weight: '30%',
      weighted: (Number(r.inspectRate || 0) * 0.3).toFixed(2)
    }
  ]
})

/** 健康评分列表 */
function getList() {
  loading.value = true
  listHealth(queryParams.value)
    .then(response => {
      healthList.value = response.rows
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

const scoreColor = score => {
  const value = Number(score || 0)
  if (value >= 90) return '#17A673'
  if (value >= 80) return '#67c23a'
  if (value >= 70) return '#e6a23c'
  if (value >= 60) return '#f59e0b'
  return '#E5484D'
}

const levelTagType = level => {
  if (level === 'excellent' || level === 'good') return 'success'
  if (level === 'fair') return 'warning'
  return 'danger'
}

const formatDate = value => (value ? String(value).substring(0, 10) : '—')

/** 重算全部电梯的健康评分 */
function handleRecalculate() {
  proxy
    .$confirm('将按当前统计周期重算全部电梯的健康评分，确认继续吗？', '重算评分', { type: 'info' })
    .then(() => request({ url: '/analysis/health/recalculate', method: 'post' }))
    .then(response => {
      proxy.$modal.msgSuccess(response.msg || '重算完成')
      getList()
    })
    .catch(() => {})
}

/** 重算单台电梯 */
function handleRecalcOne(row) {
  request({ url: `/analysis/health/recalculate/${row.elevatorId}`, method: 'post' })
    .then(() => {
      proxy.$modal.msgSuccess('已重算')
      getList()
    })
    .catch(() => {})
}

/** 打开健康评分报告 */
function handleDetail(row) {
  report.value = null
  detailOpen.value = true
  detailLoading.value = true

  Promise.all([getHealth(row.elevatorId), getHealthTrend(row.elevatorId, 12)])
    .then(([reportRes, trendRes]) => {
      report.value = reportRes.data || null
      return nextTick(() => {
        renderTrend(trendRes.data || [])
      })
    })
    .catch(() => {
      report.value = null
    })
    .finally(() => {
      detailLoading.value = false
    })
}

/** 渲染历史评分趋势折线图 */
function renderTrend(rows) {
  if (!trendChartRef.value) return
  if (!trendChart) {
    trendChart = echarts.init(trendChartRef.value)
  }
  trendChart.setOption({
    tooltip: { trigger: 'axis' },
    grid: { left: 45, right: 20, top: 30, bottom: 40 },
    xAxis: { type: 'category', data: rows.map(r => r.statPeriod) },
    yAxis: { type: 'value', min: 0, max: 100, name: '健康评分' },
    series: [
      {
        name: '健康评分',
        type: 'line',
        smooth: true,
        areaStyle: { opacity: 0.15 },
        itemStyle: { color: '#0B3D91' },
        markLine: {
          silent: true,
          data: [
            { yAxis: 90, name: '优秀线', lineStyle: { color: '#17A673' }, label: { formatter: '优秀 90' } },
            { yAxis: 60, name: '危险线', lineStyle: { color: '#E5484D' }, label: { formatter: '危险 60' } }
          ]
        },
        data: rows.map(r => r.healthScore)
      }
    ]
  }, true)
}

/** 评分模型说明 */
function handleConfig() {
  if (config.value) {
    configOpen.value = true
    return
  }
  getHealthConfig()
    .then(response => {
      config.value = response.data || response
      configOpen.value = true
    })
    .catch(() => {
      proxy.$modal.msgError('评分模型信息加载失败')
    })
}

function handleExportPdf() {
  if (!report.value) return
  exportHealthPdf(report.value.elevatorId).then(response => {
    proxy.$modal.msgSuccess(response.msg || 'PDF 报告已生成')
  })
}

function handleExportExcel() {
  if (!report.value) return
  exportHealthExcel(report.value.elevatorId).then(response => {
    proxy.$modal.msgSuccess(response.msg || 'Excel 报告已生成')
  })
}

onBeforeUnmount(() => {
  trendChart?.dispose()
})

listCommunity({ pageNum: 1, pageSize: 200 })
  .then(response => {
    communityList.value = response.rows || []
  })
  .catch(() => {})

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
.score {
  font-size: 18px;
  font-weight: 600;
}
.weight {
  margin-left: 4px;
  font-size: 12px;
  color: #c0c4cc;
}
.report-head {
  display: flex;
  gap: 32px;
  padding-bottom: 20px;
  border-bottom: 1px solid #ebeef5;
}
.report-score {
  display: flex;
  flex-direction: column;
  align-items: center;
}
.score-big {
  font-size: 32px;
  font-weight: 700;
}
.score-unit {
  margin-left: 2px;
  font-size: 13px;
  color: #909399;
}
.mt8 {
  margin-top: 8px;
}
.report-meta {
  flex: 1;
  padding-top: 20px;
  font-size: 13px;
  line-height: 2;
  color: #606266;
}
.meta-label {
  color: #909399;
}
.section-title {
  margin: 20px 0 12px;
  font-size: 14px;
  font-weight: 600;
  color: #303133;
}
.trend-box {
  height: 240px;
}
.report-actions {
  display: flex;
  justify-content: flex-end;
  gap: 12px;
  margin-top: 20px;
}
.config-note {
  margin-top: 16px;
  padding: 12px 16px;
  font-size: 13px;
  line-height: 1.9;
  color: #909399;
  background: #f5f7fa;
  border-radius: 6px;
}
</style>
