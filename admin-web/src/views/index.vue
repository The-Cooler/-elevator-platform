<template>
  <div class="app-container home">
    <!-- 统计卡片 -->
    <el-row :gutter="20" v-loading="loading">
      <el-col :xs="12" :sm="12" :md="6" v-for="card in statCards" :key="card.key">
        <div class="stat-card" :class="card.tone">
          <div class="stat-card__icon">
            <el-icon :size="26"><component :is="card.icon" /></el-icon>
          </div>
          <div class="stat-card__body">
            <p class="stat-card__label">{{ card.label }}</p>
            <p class="stat-card__value">
              {{ overview[card.key] ?? 0 }}<span class="stat-card__unit">{{ card.unit }}</span>
            </p>
          </div>
        </div>
      </el-col>
    </el-row>

    <el-row :gutter="20" class="mt20">
      <!-- 最近报修工单 -->
      <el-col :xs="24" :lg="16">
        <el-card shadow="never" class="panel">
          <template #header>
            <div class="panel-header">
              <span class="panel-title">最近报修工单</span>
              <el-link type="primary" :underline="false" @click="goPage('/repair/track')">
                查看全部
              </el-link>
            </div>
          </template>

          <el-table :data="recentOrders" v-loading="orderLoading" size="small">
            <el-table-column label="工单编号" align="center" prop="orderNo" width="180" :show-overflow-tooltip="true" />
            <el-table-column label="电梯编号" align="center" prop="elevatorCode" width="115" />
            <el-table-column label="故障现象" align="center" prop="faultDesc" :show-overflow-tooltip="true" min-width="160" />
            <el-table-column label="等级" align="center" prop="faultLevel" width="90">
              <template #default="scope">
                <el-tag :type="scope.row.faultLevel === '0' ? 'danger' : 'warning'" size="small">
                  {{ scope.row.faultLevel === '0' ? '紧急' : '一般' }}
                </el-tag>
              </template>
            </el-table-column>
            <el-table-column label="状态" align="center" width="100">
              <template #default="scope">
                <el-tag :type="statusTagType(scope.row.orderStatus)" size="small">
                  {{ statusName(scope.row.orderStatus) }}
                </el-tag>
              </template>
            </el-table-column>
            <el-table-column label="报修时间" align="center" prop="reportTime" width="160" />
          </el-table>

          <el-empty v-if="!orderLoading && !recentOrders.length" description="暂无报修工单" :image-size="80" />
        </el-card>
      </el-col>

      <!-- 待办事项 -->
      <el-col :xs="24" :lg="8">
        <el-card shadow="never" class="panel">
          <template #header>
            <div class="panel-header">
              <span class="panel-title">我的待办</span>
              <el-tag v-if="pendingCount > 0" type="danger" size="small">{{ pendingCount }} 项</el-tag>
            </div>
          </template>

          <ul class="todo-list">
            <li class="todo-item" @click="goPage('/order/dispatch')">
              <div class="todo-item__main">
                <el-icon class="todo-item__icon todo-item__icon--danger"><BellFilled /></el-icon>
                <div>
                  <p class="todo-item__title">待派单工单</p>
                  <p class="todo-item__desc">报修后需及时审核并指派维修员</p>
                </div>
              </div>
              <span class="todo-item__count" :class="{ 'todo-item__count--active': pendingCount > 0 }">
                {{ pendingCount }}
              </span>
            </li>

            <li class="todo-item" @click="goPage('/analysis/warning')">
              <div class="todo-item__main">
                <el-icon class="todo-item__icon todo-item__icon--warning"><WarningFilled /></el-icon>
                <div>
                  <p class="todo-item__title">未读预警</p>
                  <p class="todo-item__desc">工单超时与维保临期提醒</p>
                </div>
              </div>
              <span class="todo-item__count" :class="{ 'todo-item__count--active': unreadWarning > 0 }">
                {{ unreadWarning }}
              </span>
            </li>

            <li class="todo-item" @click="goPage('/maintain/inspection')">
              <div class="todo-item__main">
                <el-icon class="todo-item__icon todo-item__icon--primary"><Calendar /></el-icon>
                <div>
                  <p class="todo-item__title">待执行巡检</p>
                  <p class="todo-item__desc">按维保周期生成的巡检任务</p>
                </div>
              </div>
              <span class="todo-item__count">{{ inspectionCount }}</span>
            </li>

            <li class="todo-item" @click="goPage('/analysis/health')">
              <div class="todo-item__main">
                <el-icon class="todo-item__icon todo-item__icon--success"><DataAnalysis /></el-icon>
                <div>
                  <p class="todo-item__title">电梯健康档案</p>
                  <p class="todo-item__desc">查看健康评分与维护建议</p>
                </div>
              </div>
              <span class="todo-item__count">{{ overview.elevatorCount ?? 0 }}</span>
            </li>
          </ul>
        </el-card>

        <!-- 维保完成率 -->
        <el-card shadow="never" class="panel mt20">
          <template #header>
            <span class="panel-title">维保完成率</span>
          </template>
          <div class="rate-block">
            <el-progress
              type="dashboard"
              :percentage="Number(overview.maintainCompleteRate || 0)"
              :color="rateColor"
            />
            <p class="rate-desc">
              统计全部维保计划的已执行次数与应执行次数之比，反映周期性维保的落实情况
            </p>
          </div>
        </el-card>
      </el-col>
    </el-row>
  </div>
</template>

<script setup name="Index">
import { ref, onMounted } from 'vue'
import { useRouter } from 'vue-router'
import { getOverview, getPendingOrders, getRecentOrders, getUnreadWarningCount } from '@/api/analysis/overview'
import { listInspection } from '@/api/maintain/inspection'

const router = useRouter()

const loading = ref(true)
const orderLoading = ref(true)
const overview = ref({})
const recentOrders = ref([])
const pendingCount = ref(0)
const unreadWarning = ref(0)
const inspectionCount = ref(0)

const statCards = [
  { key: 'elevatorCount', label: '电梯总数', unit: '台', icon: 'OfficeBuilding', tone: 'stat-card--primary' },
  { key: 'monthRepairCount', label: '本月报修', unit: '单', icon: 'Document', tone: 'stat-card--warning' },
  { key: 'pendingCount', label: '待处理工单', unit: '单', icon: 'Bell', tone: 'stat-card--danger' },
  { key: 'overdueCount', label: '超期工单', unit: '单', icon: 'WarningFilled', tone: 'stat-card--info' }
]

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

const statusTagType = status => {
  if (status === 'confirmed') return 'success'
  if (status === 'pending') return 'warning'
  if (status === 'rejected' || status === 'appealed') return 'danger'
  return 'primary'
}

const rateColor = percentage => {
  if (percentage >= 80) return '#17A673'
  if (percentage >= 50) return '#F5A623'
  return '#E5484D'
}

const goPage = path => {
  router.push(path)
}

/** 加载首页概览指标 */
const loadOverview = async () => {
  try {
    const res = await getOverview()
    overview.value = res.data || {}
  } catch {
    overview.value = {}
  } finally {
    loading.value = false
  }
}

/** 加载最近报修工单 */
const loadRecentOrders = async () => {
  try {
    const res = await getRecentOrders(8)
    recentOrders.value = res.data || []
  } catch {
    recentOrders.value = []
  } finally {
    orderLoading.value = false
  }
}

/** 加载待办数量：待派单、未读预警、待执行巡检 */
const loadTodo = async () => {
  try {
    const res = await getPendingOrders({ pageNum: 1, pageSize: 1 })
    pendingCount.value = res.total || 0
  } catch {
    pendingCount.value = 0
  }

  try {
    const res = await getUnreadWarningCount()
    unreadWarning.value = res.data || 0
  } catch {
    unreadWarning.value = 0
  }

  try {
    const res = await listInspection({ pageNum: 1, pageSize: 1, recordStatus: 'pending' })
    inspectionCount.value = res.total || 0
  } catch {
    inspectionCount.value = 0
  }
}

onMounted(() => {
  loadOverview()
  loadRecentOrders()
  loadTodo()
})
</script>

<style scoped lang="scss">
.home {
  padding: 20px;
}

.mt20 {
  margin-top: 20px;
}

.stat-card {
  display: flex;
  align-items: center;
  gap: 16px;
  padding: 20px;
  margin-bottom: 16px;
  border-radius: 8px;
  background: #fff;
  border: 1px solid #ebeef5;
  transition: box-shadow 0.2s;

  &:hover {
    box-shadow: 0 4px 16px rgba(11, 61, 145, 0.1);
  }

  &__icon {
    display: flex;
    align-items: center;
    justify-content: center;
    width: 56px;
    height: 56px;
    border-radius: 12px;
    flex-shrink: 0;
  }

  &__label {
    font-size: 13px;
    color: #909399;
  }

  &__value {
    margin-top: 6px;
    font-size: 28px;
    font-weight: 600;
    color: #303133;
    line-height: 1.2;
  }

  &__unit {
    margin-left: 4px;
    font-size: 13px;
    font-weight: 400;
    color: #909399;
  }

  &--primary .stat-card__icon {
    color: #0b3d91;
    background: #ebf0fa;
  }

  &--warning .stat-card__icon {
    color: #f5a623;
    background: #fef5e7;
  }

  &--danger .stat-card__icon {
    color: #e5484d;
    background: #fdecec;
  }

  &--info .stat-card__icon {
    color: #17a673;
    background: #e8f6f0;
  }
}

.panel {
  &-header {
    display: flex;
    align-items: center;
    justify-content: space-between;
  }

  &-title {
    font-size: 15px;
    font-weight: 600;
    color: #303133;
  }
}

.todo-list {
  display: flex;
  flex-direction: column;
  gap: 4px;
}

.todo-item {
  display: flex;
  align-items: center;
  justify-content: space-between;
  gap: 12px;
  padding: 12px;
  border-radius: 6px;
  cursor: pointer;
  transition: background 0.2s;

  &:hover {
    background: #f5f7fa;
  }

  &__main {
    display: flex;
    align-items: center;
    gap: 12px;
    min-width: 0;
  }

  &__icon {
    font-size: 20px;

    &--danger {
      color: #e5484d;
    }

    &--warning {
      color: #f5a623;
    }

    &--primary {
      color: #0b3d91;
    }

    &--success {
      color: #17a673;
    }
  }

  &__title {
    font-size: 14px;
    color: #303133;
  }

  &__desc {
    margin-top: 2px;
    font-size: 12px;
    color: #909399;
  }

  &__count {
    font-size: 18px;
    font-weight: 600;
    color: #909399;

    &--active {
      color: #e5484d;
    }
  }
}

.rate-block {
  display: flex;
  flex-direction: column;
  align-items: center;
}

.rate-desc {
  margin-top: 12px;
  font-size: 12px;
  line-height: 1.8;
  color: #909399;
  text-align: center;
}
</style>
