<template>
  <div class="app-container">
    <el-card shadow="never">
      <template #header>
        <div class="page-card-header">
          <span class="page-card-title">基础信息管理</span>
          <span class="page-card-desc">小区、楼栋、电梯三级台账维护，电梯证件附件上传</span>
        </div>
      </template>

      <el-tabs v-model="activeTab" @tab-change="handleTabChange">
        <!-- 小区台账 -->
        <el-tab-pane label="小区台账" name="community">
          <el-form :model="communityQuery" ref="communityQueryRef" :inline="true" v-show="showSearch">
            <el-form-item label="小区名称" prop="communityName">
              <el-input v-model="communityQuery.communityName" placeholder="请输入小区名称" clearable style="width: 200px" @keyup.enter="handleCommunityQuery" />
            </el-form-item>
            <el-form-item label="状态" prop="status">
              <el-select v-model="communityQuery.status" placeholder="状态" clearable style="width: 200px">
                <el-option label="正常" value="0" />
                <el-option label="停用" value="1" />
              </el-select>
            </el-form-item>
            <el-form-item>
              <el-button type="primary" icon="Search" @click="handleCommunityQuery">搜索</el-button>
              <el-button icon="Refresh" @click="resetCommunityQuery">重置</el-button>
            </el-form-item>
          </el-form>
          <el-row :gutter="10" class="mb8">
            <el-col :span="1.5">
              <el-button type="primary" plain icon="Plus" @click="handleCommunityAdd" v-hasPermi="['basic:info:add']">新增</el-button>
            </el-col>
            <el-col :span="1.5">
              <el-button type="success" plain icon="Edit" :disabled="communitySingle" @click="handleCommunityUpdate" v-hasPermi="['basic:info:edit']">修改</el-button>
            </el-col>
            <el-col :span="1.5">
              <el-button type="danger" plain icon="Delete" :disabled="communityMultiple" @click="handleCommunityDelete" v-hasPermi="['basic:info:remove']">删除</el-button>
            </el-col>
            <right-toolbar v-model:showSearch="showSearch" @queryTable="getCommunityList"></right-toolbar>
          </el-row>
          <el-table v-loading="communityLoading" :data="communityList" @selection-change="handleCommunitySelection">
            <el-table-column type="selection" width="55" align="center" />
            <el-table-column label="小区编号" align="center" prop="communityId" width="100" />
            <el-table-column label="小区名称" align="center" prop="communityName" :show-overflow-tooltip="true" />
            <el-table-column label="小区地址" align="center" prop="address" :show-overflow-tooltip="true" />
            <el-table-column label="建成时间" align="center" prop="buildYear" width="120" />
            <el-table-column label="物业联系人" align="center" prop="propertyContact" width="120" />
            <el-table-column label="联系电话" align="center" prop="propertyPhone" width="140" />
            <el-table-column label="状态" align="center" prop="status" width="90">
              <template #default="scope">
                <el-tag :type="scope.row.status === '0' ? 'success' : 'info'">{{ scope.row.status === '0' ? '正常' : '停用' }}</el-tag>
              </template>
            </el-table-column>
            <el-table-column label="操作" align="center" width="150" class-name="small-padding fixed-width">
              <template #default="scope">
                <el-button link type="primary" icon="Edit" @click="handleCommunityUpdate(scope.row)" v-hasPermi="['basic:info:edit']">修改</el-button>
                <el-button link type="primary" icon="Delete" @click="handleCommunityDelete(scope.row)" v-hasPermi="['basic:info:remove']">删除</el-button>
              </template>
            </el-table-column>
          </el-table>
          <pagination v-show="communityTotal > 0" :total="communityTotal" v-model:page="communityQuery.pageNum" v-model:limit="communityQuery.pageSize" @pagination="getCommunityList" />
        </el-tab-pane>

        <!-- 楼栋台账 -->
        <el-tab-pane label="楼栋台账" name="building">
          <el-form :model="buildingQuery" ref="buildingQueryRef" :inline="true" v-show="showSearch">
            <el-form-item label="所属小区" prop="communityId">
              <el-select v-model="buildingQuery.communityId" placeholder="请选择小区" clearable style="width: 200px">
                <el-option v-for="item in communityOptions" :key="item.communityId" :label="item.communityName" :value="item.communityId" />
              </el-select>
            </el-form-item>
            <el-form-item label="楼栋号" prop="buildingNo">
              <el-input v-model="buildingQuery.buildingNo" placeholder="请输入楼栋号" clearable style="width: 200px" @keyup.enter="handleBuildingQuery" />
            </el-form-item>
            <el-form-item>
              <el-button type="primary" icon="Search" @click="handleBuildingQuery">搜索</el-button>
              <el-button icon="Refresh" @click="resetBuildingQuery">重置</el-button>
            </el-form-item>
          </el-form>
          <el-row :gutter="10" class="mb8">
            <el-col :span="1.5">
              <el-button type="primary" plain icon="Plus" @click="handleBuildingAdd" v-hasPermi="['basic:info:add']">新增</el-button>
            </el-col>
            <el-col :span="1.5">
              <el-button type="success" plain icon="Edit" :disabled="buildingSingle" @click="handleBuildingUpdate" v-hasPermi="['basic:info:edit']">修改</el-button>
            </el-col>
            <el-col :span="1.5">
              <el-button type="danger" plain icon="Delete" :disabled="buildingMultiple" @click="handleBuildingDelete" v-hasPermi="['basic:info:remove']">删除</el-button>
            </el-col>
            <right-toolbar v-model:showSearch="showSearch" @queryTable="getBuildingList"></right-toolbar>
          </el-row>
          <el-table v-loading="buildingLoading" :data="buildingList" @selection-change="handleBuildingSelection">
            <el-table-column type="selection" width="55" align="center" />
            <el-table-column label="楼栋编号" align="center" prop="buildingId" width="100" />
            <el-table-column label="所属小区" align="center" prop="communityName" :show-overflow-tooltip="true" />
            <el-table-column label="楼栋号" align="center" prop="buildingNo" width="120" />
            <el-table-column label="单元号" align="center" prop="unitNo" width="120" />
            <el-table-column label="楼层数" align="center" prop="floorCount" width="100" />
            <el-table-column label="状态" align="center" prop="status" width="90">
              <template #default="scope">
                <el-tag :type="scope.row.status === '0' ? 'success' : 'info'">{{ scope.row.status === '0' ? '正常' : '停用' }}</el-tag>
              </template>
            </el-table-column>
            <el-table-column label="操作" align="center" width="150" class-name="small-padding fixed-width">
              <template #default="scope">
                <el-button link type="primary" icon="Edit" @click="handleBuildingUpdate(scope.row)" v-hasPermi="['basic:info:edit']">修改</el-button>
                <el-button link type="primary" icon="Delete" @click="handleBuildingDelete(scope.row)" v-hasPermi="['basic:info:remove']">删除</el-button>
              </template>
            </el-table-column>
          </el-table>
          <pagination v-show="buildingTotal > 0" :total="buildingTotal" v-model:page="buildingQuery.pageNum" v-model:limit="buildingQuery.pageSize" @pagination="getBuildingList" />
        </el-tab-pane>

        <!-- 电梯台账 -->
        <el-tab-pane label="电梯台账" name="elevator">
          <el-form :model="elevatorQuery" ref="elevatorQueryRef" :inline="true" v-show="showSearch">
            <el-form-item label="所属小区" prop="communityId">
              <el-select v-model="elevatorQuery.communityId" placeholder="请选择小区" clearable style="width: 180px">
                <el-option v-for="item in communityOptions" :key="item.communityId" :label="item.communityName" :value="item.communityId" />
              </el-select>
            </el-form-item>
            <el-form-item label="所在楼栋" prop="buildingId">
              <el-select v-model="elevatorQuery.buildingId" placeholder="请选择楼栋" clearable style="width: 180px">
                <el-option v-for="item in buildingOptions" :key="item.buildingId" :label="item.buildingNo" :value="item.buildingId" />
              </el-select>
            </el-form-item>
            <el-form-item label="电梯编号" prop="elevatorCode">
              <el-input v-model="elevatorQuery.elevatorCode" placeholder="请输入电梯编号" clearable style="width: 180px" @keyup.enter="handleElevatorQuery" />
            </el-form-item>
            <el-form-item label="电梯状态" prop="status">
              <dict-select v-model="elevatorQuery.status" dict-type="elevator_status" placeholder="电梯状态" width="180px" />
            </el-form-item>
            <el-form-item>
              <el-button type="primary" icon="Search" @click="handleElevatorQuery">搜索</el-button>
              <el-button icon="Refresh" @click="resetElevatorQuery">重置</el-button>
            </el-form-item>
          </el-form>
          <el-row :gutter="10" class="mb8">
            <el-col :span="1.5">
              <el-button type="primary" plain icon="Plus" @click="handleElevatorAdd" v-hasPermi="['basic:info:add']">新增</el-button>
            </el-col>
            <el-col :span="1.5">
              <el-button type="success" plain icon="Edit" :disabled="elevatorSingle" @click="handleElevatorUpdate" v-hasPermi="['basic:info:edit']">修改</el-button>
            </el-col>
            <el-col :span="1.5">
              <el-button type="danger" plain icon="Delete" :disabled="elevatorMultiple" @click="handleElevatorDelete" v-hasPermi="['basic:info:remove']">删除</el-button>
            </el-col>
            <el-col :span="1.5">
              <el-button type="warning" plain icon="Download" @click="handleElevatorExport" v-hasPermi="['basic:info:export']">导出</el-button>
            </el-col>
            <right-toolbar v-model:showSearch="showSearch" @queryTable="getElevatorList"></right-toolbar>
          </el-row>
          <el-table v-loading="elevatorLoading" :data="elevatorList" @selection-change="handleElevatorSelection">
            <el-table-column type="selection" width="55" align="center" />
            <el-table-column label="电梯编号" align="center" prop="elevatorCode" width="140" />
            <el-table-column label="品牌" align="center" prop="brand" width="110" />
            <el-table-column label="型号" align="center" prop="model" width="120" />
            <el-table-column label="所属小区" align="center" prop="communityName" :show-overflow-tooltip="true" />
            <el-table-column label="所在楼栋" align="center" prop="buildingNo" width="110" />
            <el-table-column label="单元号" align="center" prop="unitNo" width="90" />
            <el-table-column label="维保单位" align="center" prop="maintainUnit" :show-overflow-tooltip="true" />
            <el-table-column label="投用日期" align="center" prop="installDate" width="120" />
            <el-table-column label="使用年限" align="center" prop="serviceYears" width="100" />
            <el-table-column label="电梯状态" align="center" prop="status" width="110">
              <template #default="scope">
                <dict-tag :options="elevator_status" :value="scope.row.status" />
              </template>
            </el-table-column>
            <el-table-column label="年检报告" align="center" prop="certFileId" width="110">
              <template #default="scope">
                <el-link v-if="scope.row.certFileId" type="primary" :href="previewUrl(scope.row.certFileId)" target="_blank">查看</el-link>
                <span v-else>-</span>
              </template>
            </el-table-column>
            <el-table-column label="操作" align="center" width="200" class-name="small-padding fixed-width">
              <template #default="scope">
                <el-button link type="primary" icon="Edit" @click="handleElevatorUpdate(scope.row)" v-hasPermi="['basic:info:edit']">修改</el-button>
                <el-button link type="primary" icon="Upload" @click="handleUploadCert(scope.row)" v-hasPermi="['basic:info:edit']">上传证件</el-button>
                <el-button link type="primary" icon="Delete" @click="handleElevatorDelete(scope.row)" v-hasPermi="['basic:info:remove']">删除</el-button>
              </template>
            </el-table-column>
          </el-table>
          <pagination v-show="elevatorTotal > 0" :total="elevatorTotal" v-model:page="elevatorQuery.pageNum" v-model:limit="elevatorQuery.pageSize" @pagination="getElevatorList" />
        </el-tab-pane>
      </el-tabs>

      <!-- 小区表单 -->
      <el-dialog :title="communityTitle" v-model="communityOpen" width="620px" append-to-body>
        <el-form ref="communityRef" :model="communityForm" :rules="communityRules" label-width="100px">
          <el-form-item label="小区名称" prop="communityName">
            <el-input v-model="communityForm.communityName" placeholder="请输入小区名称" />
          </el-form-item>
          <el-form-item label="小区地址" prop="address">
            <el-input v-model="communityForm.address" placeholder="请输入小区地址" />
          </el-form-item>
          <el-form-item label="建成时间" prop="buildYear">
            <el-input v-model="communityForm.buildYear" placeholder="如 1998" />
          </el-form-item>
          <el-form-item label="物业联系人" prop="propertyContact">
            <el-input v-model="communityForm.propertyContact" placeholder="请输入物业联系人" />
          </el-form-item>
          <el-form-item label="联系电话" prop="propertyPhone">
            <el-input v-model="communityForm.propertyPhone" placeholder="请输入联系电话" />
          </el-form-item>
          <el-form-item label="状态" prop="status">
            <el-radio-group v-model="communityForm.status">
              <el-radio value="0">正常</el-radio>
              <el-radio value="1">停用</el-radio>
            </el-radio-group>
          </el-form-item>
        </el-form>
        <template #footer>
          <div class="dialog-footer">
            <el-button type="primary" @click="submitCommunity">确 定</el-button>
            <el-button @click="communityOpen = false">取 消</el-button>
          </div>
        </template>
      </el-dialog>

      <!-- 楼栋表单 -->
      <el-dialog :title="buildingTitle" v-model="buildingOpen" width="620px" append-to-body>
        <el-form ref="buildingRef" :model="buildingForm" :rules="buildingRules" label-width="100px">
          <el-form-item label="所属小区" prop="communityId">
            <el-select v-model="buildingForm.communityId" placeholder="请选择小区" style="width: 100%">
              <el-option v-for="item in communityOptions" :key="item.communityId" :label="item.communityName" :value="item.communityId" />
            </el-select>
          </el-form-item>
          <el-form-item label="楼栋号" prop="buildingNo">
            <el-input v-model="buildingForm.buildingNo" placeholder="请输入楼栋号" />
          </el-form-item>
          <el-form-item label="单元号" prop="unitNo">
            <el-input v-model="buildingForm.unitNo" placeholder="请输入单元号" />
          </el-form-item>
          <el-form-item label="楼层数" prop="floorCount">
            <el-input-number v-model="buildingForm.floorCount" :min="1" controls-position="right" />
          </el-form-item>
          <el-form-item label="状态" prop="status">
            <el-radio-group v-model="buildingForm.status">
              <el-radio value="0">正常</el-radio>
              <el-radio value="1">停用</el-radio>
            </el-radio-group>
          </el-form-item>
        </el-form>
        <template #footer>
          <div class="dialog-footer">
            <el-button type="primary" @click="submitBuilding">确 定</el-button>
            <el-button @click="buildingOpen = false">取 消</el-button>
          </div>
        </template>
      </el-dialog>

      <!-- 电梯表单 -->
      <el-dialog :title="elevatorTitle" v-model="elevatorOpen" width="680px" append-to-body>
        <el-form ref="elevatorRef" :model="elevatorForm" :rules="elevatorRules" label-width="100px">
          <el-row>
            <el-col :span="12">
              <el-form-item label="电梯编号" prop="elevatorCode">
                <el-input v-model="elevatorForm.elevatorCode" placeholder="请输入电梯编号" />
              </el-form-item>
            </el-col>
            <el-col :span="12">
              <el-form-item label="所在楼栋" prop="buildingId">
                <el-select v-model="elevatorForm.buildingId" placeholder="请选择楼栋" style="width: 100%">
                  <el-option v-for="item in buildingOptions" :key="item.buildingId" :label="item.buildingNo" :value="item.buildingId" />
                </el-select>
              </el-form-item>
            </el-col>
          </el-row>
          <el-row>
            <el-col :span="12">
              <el-form-item label="品牌" prop="brand">
                <el-input v-model="elevatorForm.brand" placeholder="请输入品牌" />
              </el-form-item>
            </el-col>
            <el-col :span="12">
              <el-form-item label="型号" prop="model">
                <el-input v-model="elevatorForm.model" placeholder="请输入型号" />
              </el-form-item>
            </el-col>
          </el-row>
          <el-row>
            <el-col :span="12">
              <el-form-item label="单元号" prop="unitNo">
                <el-input v-model="elevatorForm.unitNo" placeholder="请输入单元号" />
              </el-form-item>
            </el-col>
            <el-col :span="12">
              <el-form-item label="维保单位" prop="maintainUnit">
                <el-input v-model="elevatorForm.maintainUnit" placeholder="请输入维保单位" />
              </el-form-item>
            </el-col>
          </el-row>
          <el-row>
            <el-col :span="12">
              <el-form-item label="投用日期" prop="installDate">
                <el-date-picker v-model="elevatorForm.installDate" type="date" value-format="YYYY-MM-DD" placeholder="请选择投用日期" style="width: 100%" />
              </el-form-item>
            </el-col>
            <el-col :span="12">
              <el-form-item label="使用年限" prop="serviceYears">
                <el-input-number v-model="elevatorForm.serviceYears" :min="0" controls-position="right" />
              </el-form-item>
            </el-col>
          </el-row>
          <el-form-item label="电梯状态" prop="status">
            <dict-select v-model="elevatorForm.status" dict-type="elevator_status" placeholder="请选择电梯状态" width="100%" />
          </el-form-item>
        </el-form>
        <template #footer>
          <div class="dialog-footer">
            <el-button type="primary" @click="submitElevator">确 定</el-button>
            <el-button @click="elevatorOpen = false">取 消</el-button>
          </div>
        </template>
      </el-dialog>

      <!-- 证件上传 -->
      <el-dialog title="上传年检报告" v-model="certOpen" width="520px" append-to-body>
        <el-form label-width="100px">
          <el-form-item label="电梯编号">
            <el-input v-model="certForm.elevatorCode" disabled />
          </el-form-item>
          <el-form-item label="证件附件">
            <el-upload
              ref="certUploadRef"
              :auto-upload="false"
              :limit="1"
              :on-change="handleCertChange"
              :on-remove="handleCertRemove"
              :file-list="certFileList"
            >
              <el-button type="primary" icon="Upload">选择文件</el-button>
              <template #tip>
                <div class="el-upload__tip">支持 PDF、图片格式，单个文件不超过 10MB</div>
              </template>
            </el-upload>
          </el-form-item>
        </el-form>
        <template #footer>
          <div class="dialog-footer">
            <el-button type="primary" @click="submitCert">确 定</el-button>
            <el-button @click="certOpen = false">取 消</el-button>
          </div>
        </template>
      </el-dialog>
    </el-card>
  </div>
</template>

<script setup name="BasicInfo">
import {
  listCommunity, addCommunity, updateCommunity, delCommunity
} from '@/api/basic/community'
import {
  listBuilding, addBuilding, updateBuilding, delBuilding
} from '@/api/basic/building'
import {
  listElevator, addElevator, updateElevator, delElevator, uploadElevatorCert, exportElevator
} from '@/api/basic/elevator'
import { previewUrl } from '@/api/common/file'

const { proxy } = getCurrentInstance()
const { elevator_status } = useDict('elevator_status')

const activeTab = ref('community')
const showSearch = ref(true)

/* ---------------- 小区 ---------------- */
const communityList = ref([])
const communityOptions = ref([])
const communityLoading = ref(false)
const communityOpen = ref(false)
const communityTotal = ref(0)
const communityTitle = ref('')
const communityIds = ref([])
const communitySingle = ref(true)
const communityMultiple = ref(true)

/* ---------------- 楼栋 ---------------- */
const buildingList = ref([])
const buildingOptions = ref([])
const buildingLoading = ref(false)
const buildingOpen = ref(false)
const buildingTotal = ref(0)
const buildingTitle = ref('')
const buildingIds = ref([])
const buildingSingle = ref(true)
const buildingMultiple = ref(true)

/* ---------------- 电梯 ---------------- */
const elevatorList = ref([])
const elevatorLoading = ref(false)
const elevatorOpen = ref(false)
const elevatorTotal = ref(0)
const elevatorTitle = ref('')
const elevatorIds = ref([])
const elevatorSingle = ref(true)
const elevatorMultiple = ref(true)

/* ---------------- 证件上传 ---------------- */
const certOpen = ref(false)
const certFileList = ref([])
const certForm = reactive({ elevatorId: undefined, elevatorCode: undefined })
let certRawFile = null

const data = reactive({
  communityQuery: { pageNum: 1, pageSize: 10, communityName: undefined, status: undefined },
  communityForm: {},
  communityRules: {
    communityName: [{ required: true, message: '小区名称不能为空', trigger: 'blur' }],
    propertyPhone: [{ pattern: /^[0-9-]{6,20}$/, message: '联系电话格式不正确', trigger: 'blur' }]
  },
  buildingQuery: { pageNum: 1, pageSize: 10, communityId: undefined, buildingNo: undefined },
  buildingForm: {},
  buildingRules: {
    communityId: [{ required: true, message: '请选择所属小区', trigger: 'change' }],
    buildingNo: [{ required: true, message: '楼栋号不能为空', trigger: 'blur' }]
  },
  elevatorQuery: { pageNum: 1, pageSize: 10, communityId: undefined, buildingId: undefined, elevatorCode: undefined, status: undefined },
  elevatorForm: {},
  elevatorRules: {
    elevatorCode: [{ required: true, message: '电梯编号不能为空', trigger: 'blur' }],
    buildingId: [{ required: true, message: '请选择所在楼栋', trigger: 'change' }],
    status: [{ required: true, message: '请选择电梯状态', trigger: 'change' }]
  }
})

const {
  communityQuery, communityForm, communityRules,
  buildingQuery, buildingForm, buildingRules,
  elevatorQuery, elevatorForm, elevatorRules
} = toRefs(data)

/* ---------------- 小区操作 ---------------- */
function getCommunityList() {
  communityLoading.value = true
  listCommunity(communityQuery.value).then(response => {
    communityList.value = response.rows
    communityTotal.value = response.total
    communityLoading.value = false
  }).catch(() => {
    communityLoading.value = false
  })
}

function handleCommunityQuery() {
  communityQuery.value.pageNum = 1
  getCommunityList()
}

function resetCommunityQuery() {
  proxy.resetForm('communityQueryRef')
  handleCommunityQuery()
}

function handleCommunitySelection(selection) {
  communityIds.value = selection.map(item => item.communityId)
  communitySingle.value = selection.length != 1
  communityMultiple.value = !selection.length
}

function resetCommunityForm() {
  communityForm.value = {
    communityId: undefined,
    communityName: undefined,
    address: undefined,
    buildYear: undefined,
    propertyContact: undefined,
    propertyPhone: undefined,
    status: '0'
  }
  proxy.resetForm('communityRef')
}

function handleCommunityAdd() {
  resetCommunityForm()
  communityOpen.value = true
  communityTitle.value = '新增小区'
}

function handleCommunityUpdate(row) {
  resetCommunityForm()
  const communityId = row && row.communityId ? row.communityId : communityIds.value[0]
  const target = communityList.value.find(item => item.communityId === communityId)
  if (target) {
    communityForm.value = { ...target }
  }
  communityOpen.value = true
  communityTitle.value = '修改小区'
}

function submitCommunity() {
  proxy.$refs['communityRef'].validate(valid => {
    if (!valid) {
      return
    }
    const request = communityForm.value.communityId != undefined ? updateCommunity : addCommunity
    request(communityForm.value).then(() => {
      proxy.$modal.msgSuccess(communityForm.value.communityId != undefined ? '修改成功' : '新增成功')
      communityOpen.value = false
      getCommunityList()
      loadCommunityOptions()
    })
  })
}

function handleCommunityDelete(row) {
  const ids = row && row.communityId ? row.communityId : communityIds.value
  proxy.$modal.confirm('是否确认删除小区编号为"' + ids + '"的数据项？').then(() => {
    return delCommunity(ids)
  }).then(() => {
    getCommunityList()
    loadCommunityOptions()
    proxy.$modal.msgSuccess('删除成功')
  }).catch(() => {})
}

/* ---------------- 楼栋操作 ---------------- */
function getBuildingList() {
  buildingLoading.value = true
  listBuilding(buildingQuery.value).then(response => {
    buildingList.value = response.rows
    buildingTotal.value = response.total
    buildingLoading.value = false
  }).catch(() => {
    buildingLoading.value = false
  })
}

function handleBuildingQuery() {
  buildingQuery.value.pageNum = 1
  getBuildingList()
}

function resetBuildingQuery() {
  proxy.resetForm('buildingQueryRef')
  handleBuildingQuery()
}

function handleBuildingSelection(selection) {
  buildingIds.value = selection.map(item => item.buildingId)
  buildingSingle.value = selection.length != 1
  buildingMultiple.value = !selection.length
}

function resetBuildingForm() {
  buildingForm.value = {
    buildingId: undefined,
    communityId: undefined,
    buildingNo: undefined,
    unitNo: undefined,
    floorCount: 1,
    status: '0'
  }
  proxy.resetForm('buildingRef')
}

function handleBuildingAdd() {
  resetBuildingForm()
  buildingOpen.value = true
  buildingTitle.value = '新增楼栋'
}

function handleBuildingUpdate(row) {
  resetBuildingForm()
  const buildingId = row && row.buildingId ? row.buildingId : buildingIds.value[0]
  const target = buildingList.value.find(item => item.buildingId === buildingId)
  if (target) {
    buildingForm.value = { ...target }
  }
  buildingOpen.value = true
  buildingTitle.value = '修改楼栋'
}

function submitBuilding() {
  proxy.$refs['buildingRef'].validate(valid => {
    if (!valid) {
      return
    }
    const request = buildingForm.value.buildingId != undefined ? updateBuilding : addBuilding
    request(buildingForm.value).then(() => {
      proxy.$modal.msgSuccess(buildingForm.value.buildingId != undefined ? '修改成功' : '新增成功')
      buildingOpen.value = false
      getBuildingList()
      loadBuildingOptions()
    })
  })
}

function handleBuildingDelete(row) {
  const ids = row && row.buildingId ? row.buildingId : buildingIds.value
  proxy.$modal.confirm('是否确认删除楼栋编号为"' + ids + '"的数据项？').then(() => {
    return delBuilding(ids)
  }).then(() => {
    getBuildingList()
    loadBuildingOptions()
    proxy.$modal.msgSuccess('删除成功')
  }).catch(() => {})
}

/* ---------------- 电梯操作 ---------------- */
function getElevatorList() {
  elevatorLoading.value = true
  listElevator(elevatorQuery.value).then(response => {
    elevatorList.value = response.rows
    elevatorTotal.value = response.total
    elevatorLoading.value = false
  }).catch(() => {
    elevatorLoading.value = false
  })
}

function handleElevatorQuery() {
  elevatorQuery.value.pageNum = 1
  getElevatorList()
}

function resetElevatorQuery() {
  proxy.resetForm('elevatorQueryRef')
  handleElevatorQuery()
}

function handleElevatorSelection(selection) {
  elevatorIds.value = selection.map(item => item.elevatorId)
  elevatorSingle.value = selection.length != 1
  elevatorMultiple.value = !selection.length
}

function resetElevatorForm() {
  elevatorForm.value = {
    elevatorId: undefined,
    elevatorCode: undefined,
    brand: undefined,
    model: undefined,
    buildingId: undefined,
    unitNo: undefined,
    maintainUnit: undefined,
    installDate: undefined,
    serviceYears: 0,
    status: '0'
  }
  proxy.resetForm('elevatorRef')
}

function handleElevatorAdd() {
  resetElevatorForm()
  elevatorOpen.value = true
  elevatorTitle.value = '新增电梯'
}

function handleElevatorUpdate(row) {
  resetElevatorForm()
  const elevatorId = row && row.elevatorId ? row.elevatorId : elevatorIds.value[0]
  const target = elevatorList.value.find(item => item.elevatorId === elevatorId)
  if (target) {
    elevatorForm.value = { ...target }
  }
  elevatorOpen.value = true
  elevatorTitle.value = '修改电梯'
}

function submitElevator() {
  proxy.$refs['elevatorRef'].validate(valid => {
    if (!valid) {
      return
    }
    const request = elevatorForm.value.elevatorId != undefined ? updateElevator : addElevator
    request(elevatorForm.value).then(() => {
      proxy.$modal.msgSuccess(elevatorForm.value.elevatorId != undefined ? '修改成功' : '新增成功')
      elevatorOpen.value = false
      getElevatorList()
    })
  })
}

function handleElevatorDelete(row) {
  const ids = row && row.elevatorId ? row.elevatorId : elevatorIds.value
  proxy.$modal.confirm('是否确认删除电梯编号为"' + ids + '"的数据项？').then(() => {
    return delElevator(ids)
  }).then(() => {
    getElevatorList()
    proxy.$modal.msgSuccess('删除成功')
  }).catch(() => {})
}

function handleElevatorExport() {
  exportElevator(elevatorQuery.value)
}

/* ---------------- 证件上传 ---------------- */
function handleUploadCert(row) {
  certForm.elevatorId = row.elevatorId
  certForm.elevatorCode = row.elevatorCode
  certRawFile = null
  certFileList.value = row.certFileId
    ? [{ name: '已上传的年检报告', url: previewUrl(row.certFileId) }]
    : []
  certOpen.value = true
}

function handleCertChange(file) {
  certRawFile = file.raw
  certFileList.value = [file]
}

function handleCertRemove() {
  certRawFile = null
  certFileList.value = []
}

function submitCert() {
  if (!certRawFile) {
    proxy.$modal.msgWarning('请先选择要上传的年检报告文件')
    return
  }
  uploadElevatorCert(certRawFile, certForm.elevatorId).then(() => {
    proxy.$modal.msgSuccess('上传成功')
    certOpen.value = false
    getElevatorList()
  })
}

/* ---------------- 级联数据 ---------------- */
function loadCommunityOptions() {
  listCommunity({ pageNum: 1, pageSize: 200 }).then(response => {
    communityOptions.value = response.rows || []
  })
}

function loadBuildingOptions() {
  listBuilding({ pageNum: 1, pageSize: 500 }).then(response => {
    buildingOptions.value = response.rows || []
  })
}

function handleTabChange(name) {
  if (name === 'community') {
    getCommunityList()
  } else if (name === 'building') {
    getBuildingList()
  } else if (name === 'elevator') {
    getElevatorList()
  }
}

getCommunityList()
getBuildingList()
getElevatorList()
loadCommunityOptions()
loadBuildingOptions()
</script>
