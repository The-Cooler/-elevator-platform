<template>
  <div class="app-container">
    <el-card shadow="never">
      <template #header>
        <div class="page-card-header">
          <span class="page-card-title">故障频次统计</span>
          <span class="page-card-desc">
            按电梯、楼栋、时间段统计故障次数，生成柱状图与趋势图，为维保决策提供数据支撑
          </span>
        </div>
      </template>

      <!-- 统计条件 -->
      <el-form :inline="true" class="mb16">
        <el-form-item label="小区">
          <el-select v-model="query.communityId" placeholder="全部小区" clearable style="width: 200px" @change="loadAll">
            <el-option
              v-for="item in communityList"
              :key="item.communityId"
              :label="item.communityName"
              :value="item.communityId"
            />
          </el-select>
        </el-form-item>
        <el-form-item label="时间范围">
          <el-date-picker
            v-model="dateRange"
            value-format="YYYY-MM-DD"
            type="daterange"
            range-separator="-"
            start-placeholder="开始日期"
            end-placeholder="结束日期"
            style="width: 250px"
            @change="loadAll"
          />
        </el-form-item>
        <el-form-item label="趋势粒度">
          <el-radio-group v-model="query.granularity" @change="loadTrend">
            <el-radio-button value="day">按日</el-radio-button>
            <el-radio-button value="week">按周</el-radio-button>
            <el-radio-button value="month">按月</el-radio-button>
          </el-radio-group>
        </el-form-item>
        <el-form-item>
          <el-button type="primary" icon="Search" @click="loadAll">查询</el-button>
          <el-button icon="Refresh" @click="handleReset">重置</el-button>
          <el-button
            type="warning"
            icon="Download"
            @click="handleExport"
            v-hasPermi="['analysis:frequency:export']"
          >导出统计</el-button>
        </el-form-item>
      </el-form>

      <!-- 汇总指标 -->
      <el-row :gutter="16" class="mb16">
        <el-col :span="6">
          <div class="summary-card">
            <p class="summary-label">故障总数</p>
            <p class="summary-value">{{ summary.totalFault ?? '—' }}</p>
          </div>
        </el-col>
        <el-col :span="6">
          <div class="summary-card">
            <p class="summary-label">紧急故障</p>
            <p class="summary-value summary-value--danger">{{ summary.urgentFault ?? '—' }}</p>
          </div>
        </el-col>
        <el-col :span="6">
          <div class="summary-card">
            <p class="summary-label">平均响应时长</p>
            <p class="summary-value">{{ summary.avgAssignMinutes ?? '—' }}<span class="unit"> 分钟</span></p>
          </div>
        </el-col>
        <el-col :span="6">
          <div class="summary-card">
            <p class="summary-label">平均维修时长</p>
            <p class="summary-value">{{ summary.avgRepairMinutes ?? '—' }}<span class="unit"> 分钟</span></p>
          </div>
        </el-col>
      </el-row>

      <!-- 图表区 -->
      <el-row :gutter="16">
        <el-col :span="12">
          <div class="chart-card">
            <h3 class="chart-title">故障趋势</h3>
            <div ref="trendChartRef" v-loading="trendLoading" class="chart-box"></div>
          </div>
        </el-col>
        <el-col :span="12">
          <div class="chart-card">
            <h3 class="chart-title">各电梯故障次数</h3>
            <div ref="elevatorChartRef" v-loading="elevatorLoading" class="chart-box"></div>
          </div>
        </el-col>
      </el-row>

      <el-row :gutter="16" class="mt16">
        <el-col :span="12">
          <div class="chart-card">
            <h3 class="chart-title">各楼栋故障分布</h3>
            <div ref="buildingChartRef" v-loading="buildingLoading" class="chart-box"></div>
          </div>
        </el-col>
        <el-col :span="12">
          <div class="chart-card">
            <h3 class="chart-title">故障类型占比</h3>
            <div ref="faultTypeChartRef" v-loading="faultTypeLoading" class="chart-box"></div>
          </div>
        </el-col>
      </el-row>

      <p class="stat-note">
        统计口径：按报修工单的报修时间归集，未指定时间范围时统计全部历史数据；平均响应时长为报修到派单的间隔，平均维修时长为到场到完工的间隔
      </p>
    </el-card>
  </div>
</template>

<script setup name="Frequency">
import { ref, reactive, onMounted, onBeforeUnmount, nextTick, getCurrentInstance } from 'vue'
import * as echarts from 'echarts'
import {
  frequencyByElevator,
  frequencyByBuilding,
  frequencyTrend,
  frequencyByFaultType,
  frequencySummary
} from '@/api/analysis/frequency'
import { listCommunity } from '@/api/basic/community'

const { proxy } = getCurrentInstance()

const communityList = ref([])
const dateRange = ref([])
const summary = ref({})

const trendLoading = ref(false)
const elevatorLoading = ref(false)
const buildingLoading = ref(false)
const faultTypeLoading = ref(false)

const trendChartRef = ref(null)
const elevatorChartRef = ref(null)
const buildingChartRef = ref(null)
const faultTypeChartRef = ref(null)

let trendChart = null
let elevatorChart = null
let buildingChart = null
let faultTypeChart = null

const query = reactive({
  communityId: undefined,
  granularity: 'day'
})

const faultTypeMap = {
  abnormal_noise: '异响',
  stop: '停梯',
  trapped: '困人',
  door: '门故障',
  button: '按钮失灵',
  other: '其他'
}

/** 组装后端请求参数 */
const buildParams = () => ({
  communityId: query.communityId,
  beginTime: dateRange.value?.[0],
  endTime: dateRange.value?.[1]
})

/** 初始化四个图表实例 */
const initCharts = () => {
  if (trendChartRef.value && !trendChart) trendChart = echarts.init(trendChartRef.value)
  if (elevatorChartRef.value && !elevatorChart) elevatorChart = echarts.init(elevatorChartRef.value)
  if (buildingChartRef.value && !buildingChart) buildingChart = echarts.init(buildingChartRef.value)
  if (faultTypeChartRef.value && !faultTypeChart) faultTypeChart = echarts.init(faultTypeChartRef.value)
}

/** 故障趋势折线图 */
const loadTrend = () => {
  trendLoading.value = true
  frequencyTrend({ ...buildParams(), granularity: query.granularity })
    .then(response => {
      const rows = response.data || []
      trendChart?.setOption({
        tooltip: { trigger: 'axis' },
        grid: { left: 40, right: 20, top: 30, bottom: 40 },
        xAxis: { type: 'category', data: rows.map(r => r.timeLabel), axisLabel: { rotate: 30 } },
        yAxis: { type: 'value', minInterval: 1, name: '故障次数' },
        series: [
          {
            name: '故障次数',
            type: 'line',
            smooth: true,
            areaStyle: { opacity: 0.15 },
            itemStyle: { color: '#0B3D91' },
            data: rows.map(r => r.faultCount)
          }
        ]
      }, true)
    })
    .finally(() => {
      trendLoading.value = false
    })
}

/** 各电梯故障次数柱状图，点击柱条可下钻查看该电梯趋势 */
const loadByElevator = () => {
  elevatorLoading.value = true
  frequencyByElevator(buildParams())
    .then(response => {
      const rows = response.data || []
      elevatorChart?.setOption({
        tooltip: { trigger: 'axis', axisPointer: { type: 'shadow' } },
        grid: { left: 50, right: 20, top: 30, bottom: 70 },
        xAxis: { type: 'category', data: rows.map(r => r.elevatorCode), axisLabel: { rotate: 40 } },
        yAxis: { type: 'value', minInterval: 1, name: '故障次数' },
        series: [
          {
            name: '故障次数',
            type: 'bar',
            barMaxWidth: 36,
            itemStyle: { color: '#3F6BB4', borderRadius: [4, 4, 0, 0] },
            data: rows.map(r => r.faultCount)
          }
        ]
      }, true)

      elevatorChart?.off('click')
      elevatorChart?.on('click', params => {
        const row = rows[params.dataIndex]
        if (row) {
          proxy.$modal.msgInfo(
            `电梯 ${row.elevatorCode}（${row.communityName || ''} ${row.buildingNo || ''}）共 ${row.faultCount} 次故障`
          )
        }
      })
    })
    .finally(() => {
      elevatorLoading.value = false
    })
}

/** 各楼栋故障分布饼图 */
const loadByBuilding = () => {
  buildingLoading.value = true
  frequencyByBuilding(buildParams())
    .then(response => {
      const rows = (response.data || []).filter(r => r.faultCount > 0)
      buildingChart?.setOption({
        tooltip: { trigger: 'item', formatter: '{b}<br/>故障 {c} 次（{d}%）' },
        legend: { type: 'scroll', bottom: 0 },
        series: [
          {
            name: '楼栋故障分布',
            type: 'pie',
            radius: ['40%', '68%'],
            center: ['50%', '45%'],
            data: rows.map(r => ({ name: r.buildingName, value: r.faultCount })),
            label: { formatter: '{b}\n{c} 次' }
          }
        ]
      }, true)
    })
    .finally(() => {
      buildingLoading.value = false
    })
}

/** 故障类型占比横向柱状图 */
const loadByFaultType = () => {
  faultTypeLoading.value = true
  frequencyByFaultType(buildParams())
    .then(response => {
      const rows = (response.data || []).slice().reverse()
      faultTypeChart?.setOption({
        tooltip: { trigger: 'axis', axisPointer: { type: 'shadow' } },
        grid: { left: 80, right: 30, top: 20, bottom: 30 },
        xAxis: { type: 'value', minInterval: 1, name: '次数' },
        yAxis: { type: 'category', data: rows.map(r => faultTypeMap[r.faultType] || r.faultType) },
        series: [
          {
            name: '故障次数',
            type: 'bar',
            barMaxWidth: 22,
            itemStyle: { color: '#F5A623', borderRadius: [0, 4, 4, 0] },
            label: { show: true, position: 'right' },
            data: rows.map(r => r.faultCount)
          }
        ]
      }, true)
    })
    .finally(() => {
      faultTypeLoading.value = false
    })
}

/** 汇总指标 */
const loadSummary = () => {
  frequencySummary(buildParams())
    .then(response => {
      summary.value = response.data || {}
    })
    .catch(() => {
      summary.value = {}
    })
}

const loadAll = () => {
  loadSummary()
  loadTrend()
  loadByElevator()
  loadByBuilding()
  loadByFaultType()
}

const handleReset = () => {
  query.communityId = undefined
  query.granularity = 'day'
  dateRange.value = []
  loadAll()
}

const handleExport = () => {
  proxy.download('/analysis/frequency/export', { ...buildParams() }, `故障频次统计_${new Date().getTime()}.json`)
}

const handleResize = () => {
  trendChart?.resize()
  elevatorChart?.resize()
  buildingChart?.resize()
  faultTypeChart?.resize()
}

onMounted(async () => {
  await nextTick()
  initCharts()
  window.addEventListener('resize', handleResize)

  listCommunity({ pageNum: 1, pageSize: 200 })
    .then(response => {
      communityList.value = response.rows || []
    })
    .catch(() => {})

  loadAll()
})

onBeforeUnmount(() => {
  window.removeEventListener('resize', handleResize)
  trendChart?.dispose()
  elevatorChart?.dispose()
  buildingChart?.dispose()
  faultTypeChart?.dispose()
})
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
.mb16 {
  margin-bottom: 16px;
}
.mt16 {
  margin-top: 16px;
}
.summary-card {
  padding: 18px 20px;
  background: linear-gradient(135deg, #f5f7fa 0%, #eef2f8 100%);
  border-radius: 8px;
}
.summary-label {
  font-size: 13px;
  color: #606266;
}
.summary-value {
  margin-top: 8px;
  font-size: 26px;
  font-weight: 600;
  color: #0b3d91;
}
.summary-value--danger {
  color: #f56c6c;
}
.unit {
  font-size: 13px;
  font-weight: 400;
  color: #909399;
}
.chart-card {
  padding: 16px;
  border: 1px solid #ebeef5;
  border-radius: 8px;
  background: #fff;
}
.chart-title {
  margin-bottom: 8px;
  font-size: 14px;
  font-weight: 600;
  color: #303133;
}
.chart-box {
  height: 320px;
}
.stat-note {
  margin-top: 16px;
  padding: 10px 14px;
  font-size: 12px;
  line-height: 1.8;
  color: #909399;
  background: #f5f7fa;
  border-radius: 6px;
}
</style>
