<template>
  <div class="app-container">
    <el-card shadow="never">
      <template #header>
        <div class="page-card-header">
          <span class="page-card-title">多媒体证据上传</span>
          <span class="page-card-desc">
            汇总业主在报修时上传的现场照片与短视频，按工单、类型与上传时间检索，支持在线预览
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
        <el-form-item label="电梯编号" prop="elevatorCode">
          <el-input
            v-model="queryParams.elevatorCode"
            placeholder="请输入电梯编号"
            clearable
            style="width: 180px"
            @keyup.enter="handleQuery"
          />
        </el-form-item>
        <el-form-item label="证据类型" prop="evidenceType">
          <el-select v-model="queryParams.evidenceType" placeholder="请选择类型" clearable style="width: 140px">
            <el-option label="图片" value="image" />
            <el-option label="视频" value="video" />
          </el-select>
        </el-form-item>
        <el-form-item label="上传时间">
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
          <el-button type="primary" plain icon="Picture" @click="toggleView">
            {{ gridView ? '列表视图' : '缩略图视图' }}
          </el-button>
        </el-col>
        <el-col :span="1.5">
          <el-button
            type="danger"
            plain
            icon="Delete"
            :disabled="multiple"
            @click="handleDelete"
            v-hasPermi="['repair:evidence:remove']"
          >删除</el-button>
        </el-col>
        <right-toolbar v-model:showSearch="showSearch" @queryTable="getList"></right-toolbar>
      </el-row>

      <!-- 列表视图 -->
      <el-table v-if="!gridView" v-loading="loading" :data="evidenceList" @selection-change="handleSelectionChange">
        <el-table-column type="selection" width="55" align="center" />
        <el-table-column label="预览" align="center" width="100">
          <template #default="scope">
            <media-preview :file-ids="[scope.row]" />
          </template>
        </el-table-column>
        <el-table-column label="文件名" align="center" prop="fileName" :show-overflow-tooltip="true" min-width="200" />
        <el-table-column label="类型" align="center" prop="evidenceType" width="90">
          <template #default="scope">
            <el-tag :type="scope.row.evidenceType === 'video' ? 'warning' : 'success'" size="small">
              {{ scope.row.evidenceType === 'video' ? '视频' : '图片' }}
            </el-tag>
          </template>
        </el-table-column>
        <el-table-column label="大小" align="center" width="110">
          <template #default="scope">{{ formatFileSize(scope.row.fileSize) }}</template>
        </el-table-column>
        <el-table-column label="关联工单" align="center" prop="orderNo" width="185" :show-overflow-tooltip="true" />
        <el-table-column label="电梯编号" align="center" prop="elevatorCode" width="120" />
        <el-table-column label="上传人" align="center" prop="createBy" width="120" />
        <el-table-column label="上传时间" align="center" prop="uploadTime" width="165" />
        <el-table-column label="操作" align="center" width="140" fixed="right">
          <template #default="scope">
            <el-button link type="primary" icon="Download" @click="handleDownload(scope.row)">下载</el-button>
            <el-button
              link
              type="danger"
              icon="Delete"
              @click="handleDelete(scope.row)"
              v-hasPermi="['repair:evidence:remove']"
            >删除</el-button>
          </template>
        </el-table-column>
      </el-table>

      <!-- 缩略图视图 -->
      <div v-else v-loading="loading" class="evidence-grid">
        <div v-for="item in evidenceList" :key="item.evidenceId" class="evidence-item">
          <media-preview :file-ids="[item]" />
          <div class="evidence-meta">
            <p class="evidence-name" :title="item.fileName">{{ item.fileName }}</p>
            <p class="evidence-sub">{{ item.orderNo }}</p>
            <p class="evidence-sub">{{ item.uploadTime }}</p>
          </div>
        </div>
        <el-empty v-if="!loading && !evidenceList.length" description="暂无证据附件" />
      </div>

      <pagination
        v-show="total > 0"
        :total="total"
        v-model:page="queryParams.pageNum"
        v-model:limit="queryParams.pageSize"
        @pagination="getList"
      />
    </el-card>
  </div>
</template>

<script setup name="Evidence">
import { ref, reactive, toRefs, getCurrentInstance } from 'vue'
import { listEvidence, delEvidence } from '@/api/repair/evidence'
import MediaPreview from '@/views/components/MediaPreview.vue'

const { proxy } = getCurrentInstance()

const loading = ref(true)
const showSearch = ref(true)
const gridView = ref(false)
const evidenceList = ref([])
const total = ref(0)
const ids = ref([])
const multiple = ref(true)
const dateRange = ref([])

const data = reactive({
  queryParams: {
    pageNum: 1,
    pageSize: 12,
    orderNo: undefined,
    elevatorCode: undefined,
    evidenceType: undefined,
    beginTime: undefined,
    endTime: undefined
  }
})
const { queryParams } = toRefs(data)

/** 查询证据附件库 */
function getList() {
  loading.value = true
  queryParams.value.beginTime = dateRange.value?.[0]
  queryParams.value.endTime = dateRange.value?.[1]
  listEvidence(queryParams.value)
    .then(response => {
      evidenceList.value = response.rows
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
  ids.value = selection.map(item => item.evidenceId)
  multiple.value = !selection.length
}

function toggleView() {
  gridView.value = !gridView.value
  queryParams.value.pageSize = gridView.value ? 12 : 10
  queryParams.value.pageNum = 1
  getList()
}

/** 文件大小格式化 */
function formatFileSize(size) {
  if (!size) return '—'
  if (size < 1024) return `${size} B`
  if (size < 1024 * 1024) return `${(size / 1024).toFixed(1)} KB`
  return `${(size / 1024 / 1024).toFixed(1)} MB`
}

/** 下载文件 */
function handleDownload(row) {
  proxy.download(`/common/file/download/${row.fileId}`, {}, row.fileName)
}

/** 删除证据 */
function handleDelete(row) {
  const evidenceIds = row ? [row.evidenceId] : ids.value
  if (!evidenceIds.length) {
    proxy.$modal.msgWarning('请选择需要删除的证据')
    return
  }
  proxy
    .$confirm(`确认删除选中的 ${evidenceIds.length} 条证据附件吗？`, '提示', { type: 'warning' })
    .then(() => Promise.all(evidenceIds.map(id => delEvidence(id))))
    .then(() => {
      proxy.$modal.msgSuccess('删除成功')
      getList()
    })
    .catch(() => {})
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
.evidence-grid {
  display: grid;
  grid-template-columns: repeat(auto-fill, minmax(200px, 1fr));
  gap: 16px;
  min-height: 120px;
}
.evidence-item {
  border: 1px solid #ebeef5;
  border-radius: 8px;
  overflow: hidden;
  background: #fff;
}
.evidence-meta {
  padding: 8px 10px;
}
.evidence-name {
  font-size: 13px;
  color: #303133;
  overflow: hidden;
  text-overflow: ellipsis;
  white-space: nowrap;
}
.evidence-sub {
  margin-top: 2px;
  font-size: 12px;
  color: #909399;
}
</style>
