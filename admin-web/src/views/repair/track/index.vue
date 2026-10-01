<template>
  <div class="app-container">
    <el-card shadow="never">
      <template #header>
        <div class="page-card-header">
          <span class="page-card-title">报修进度跟踪</span>
          <span class="page-card-desc">
            查看全部报修工单的全流程时间轴与各状态停留时长，掌握工单流转情况
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
        <el-form-item label="故障等级" prop="faultLevel">
          <dict-select v-model="queryParams.faultLevel" dict-type="fault_level" placeholder="故障等级" width="150px" />
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

      <el-table v-loading="loading" :data="orderList">
        <el-table-column label="工单编号" align="center" prop="orderNo" width="185" :show-overflow-tooltip="true" />
        <el-table-column label="当前状态" align="center" prop="orderStatus" width="110">
          <template #default="scope">
            <order-status-tag :status="scope.row.orderStatus" />
          </template>
        </el-table-column>
        <el-table-column label="故障等级" align="center" prop="faultLevel" width="95">
          <template #default="scope">
            <fault-level-tag :level="scope.row.faultLevel" />
          </template>
        </el-table-column>
        <el-table-column label="电梯编号" align="center" prop="elevatorCode" width="115" />
        <el-table-column label="故障现象" align="center" prop="faultDesc" :show-overflow-tooltip="true" min-width="170" />
        <el-table-column label="报修人" align="center" prop="reporterName" width="100" />
        <el-table-column label="维修员" align="center" prop="assigneeName" width="110" />
        <el-table-column label="报修时间" align="center" prop="reportTime" width="165" />
        <el-table-column label="耗时" align="center" width="120">
          <template #default="scope">
            {{ elapsed(scope.row) }}
          </template>
        </el-table-column>
        <el-table-column label="是否超期" align="center" width="100">
          <template #default="scope">
            <el-tag v-if="isOverdue(scope.row)" type="danger" size="small">已超期</el-tag>
            <el-tag v-else type="success" size="small">正常</el-tag>
          </template>
        </el-table-column>
        <el-table-column label="操作" align="center" width="110" fixed="right">
          <template #default="scope">
            <el-button link type="primary" icon="View" @click="handleTimeline(scope.row)">时间轴</el-button>
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

    <!-- 流程时间轴弹窗 -->
    <el-dialog v-model="timelineOpen" title="工单流程时间轴" width="780px" append-to-body destroy-on-close>
      <div v-loading="timelineLoading" class="timeline-wrap">
        <el-descriptions :column="2" border size="small" class="mb20" v-if="currentOrder">
          <el-descriptions-item label="工单编号">{{ currentOrder.orderNo }}</el-descriptions-item>
          <el-descriptions-item label="当前状态">
            <order-status-tag :status="currentOrder.orderStatus" />
          </el-descriptions-item>
          <el-descriptions-item label="电梯编号">{{ currentOrder.elevatorCode }}</el-descriptions-item>
          <el-descriptions-item label="电梯位置">
            {{ currentOrder.communityName }} {{ currentOrder.buildingNo }} {{ currentOrder.unitNo }}
          </el-descriptions-item>
          <el-descriptions-item label="故障现象" :span="2">{{ currentOrder.faultDesc }}</el-descriptions-item>
        </el-descriptions>

        <el-timeline v-if="timeline.length">
          <el-timeline-item
            v-for="(item, index) in timeline"
            :key="item.logId"
            :timestamp="item.operateTime"
            placement="top"
            :type="index === timeline.length - 1 ? 'primary' : 'success'"
          >
            <div class="timeline-card">
              <div class="timeline-head">
                <span class="timeline-status">
                  {{ statusName(item.toStatus) }}
                </span>
                <span class="timeline-role">{{ roleName(item.operatorRole) }}</span>
              </div>
              <p class="timeline-operator">操作人：{{ item.operatorName || '系统' }}</p>
              <p v-if="item.remark" class="timeline-remark">{{ item.remark }}</p>
              <p class="timeline-duration" v-if="index < timeline.length - 1">
                停留时长：{{ durationBetween(item.operateTime, timeline[index + 1].operateTime) }}
              </p>
            </div>
          </el-timeline-item>
        </el-timeline>
        <el-empty v-else-if="!timelineLoading" description="该工单暂无流转记录" />
      </div>
    </el-dialog>
  </div>
</template>

<script setup name="Track">
import { ref, reactive, toRefs, getCurrentInstance } from 'vue'
import { listTrack, getTrack } from '@/api/repair/track'
import DictSelect from '@/views/components/DictSelect.vue'
import OrderStatusTag from '@/views/components/OrderStatusTag.vue'
import FaultLevelTag from '@/views/components/FaultLevelTag.vue'

const { proxy } = getCurrentInstance()

const loading = ref(true)
const showSearch = ref(true)
const orderList = ref([])
const total = ref(0)
const dateRange = ref([])

const timelineOpen = ref(false)
const timelineLoading = ref(false)
const timeline = ref([])
const currentOrder = ref(null)

const data = reactive({
  queryParams: {
    pageNum: 1,
    pageSize: 10,
    orderNo: undefined,
    orderStatus: undefined,
    faultLevel: undefined,
    beginTime: undefined,
    endTime: undefined
  }
})
const { queryParams } = toRefs(data)

const statusMap = {
  pending: '待处理',
  assigned: '已派单',
  accepted: '已接单',
  arrived: '已到场',
  repairing: '维修中',
  repaired: '已修复',
  confirmed: '已完成',
  rejected: '已驳回',
  appealed: '已申诉'
}
const statusName = status => statusMap[status] || status

const roleMap = {
  owner: '业主',
  property: '物业',
  worker: '维修员',
  admin: '管理员'
}
const roleName = role => roleMap[role] || '系统'

/** 查询工单进度列表 */
function getList() {
  loading.value = true
  queryParams.value.beginTime = dateRange.value?.[0]
  queryParams.value.endTime = dateRange.value?.[1]
  listTrack(queryParams.value)
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
  dateRange.value = []
  handleQuery()
}

/** 计算工单从报修至今的耗时 */
function elapsed(row) {
  if (!row.reportTime) return '—'
  const end = row.confirmTime || new Date()
  return durationBetween(row.reportTime, end)
}

/** 判断工单是否已超期 */
function isOverdue(row) {
  if (row.orderStatus === 'confirmed') return false
  if (!row.deadlineTime) return false
  return new Date(row.deadlineTime.replace(/-/g, '/')) < new Date()
}

/** 计算两个时间点之间的时长 */
function durationBetween(start, end) {
  if (!start || !end) return '—'
  const s = new Date(String(start).replace(/-/g, '/')).getTime()
  const e = new Date(String(end).replace(/-/g, '/')).getTime()
  if (Number.isNaN(s) || Number.isNaN(e) || e < s) return '—'
  const minutes = Math.floor((e - s) / 60000)
  if (minutes < 60) return `${minutes} 分钟`
  if (minutes < 1440) return `${Math.floor(minutes / 60)} 小时 ${minutes % 60} 分钟`
  return `${Math.floor(minutes / 1440)} 天 ${Math.floor((minutes % 1440) / 60)} 小时`
}

/** 查看工单全流程时间轴 */
function handleTimeline(row) {
  currentOrder.value = row
  timeline.value = []
  timelineOpen.value = true
  timelineLoading.value = true
  getTrack(row.orderId)
    .then(response => {
      const detail = response.data || {}
      timeline.value = detail.statusLogs || []
      if (detail.orderNo) {
        currentOrder.value = detail
      }
    })
    .finally(() => {
      timelineLoading.value = false
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
.mb20 {
  margin-bottom: 16px;
}
.timeline-wrap {
  max-height: 60vh;
  overflow-y: auto;
}
.timeline-card {
  padding: 12px 16px;
  border: 1px solid #ebeef5;
  border-radius: 6px;
  background: #fafafa;
}
.timeline-head {
  display: flex;
  align-items: center;
  gap: 10px;
}
.timeline-status {
  font-size: 14px;
  font-weight: 600;
  color: #303133;
}
.timeline-role {
  padding: 1px 8px;
  font-size: 12px;
  color: #409eff;
  background: #ecf5ff;
  border-radius: 10px;
}
.timeline-operator {
  margin-top: 6px;
  font-size: 13px;
  color: #606266;
}
.timeline-remark {
  margin-top: 4px;
  font-size: 13px;
  color: #909399;
}
.timeline-duration {
  margin-top: 6px;
  font-size: 12px;
  color: #c0c4cc;
}
</style>
