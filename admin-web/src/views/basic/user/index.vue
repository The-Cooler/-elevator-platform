<template>
  <div class="app-container">
    <el-card shadow="never">
      <template #header>
        <div class="page-card-header">
          <span class="page-card-title">用户注册与登录</span>
          <span class="page-card-desc">四类角色账号列表，支持查询、新增账号、重置密码与启用停用</span>
        </div>
      </template>

      <el-form :model="queryParams" ref="queryRef" :inline="true" v-show="showSearch">
        <el-form-item label="用户账号" prop="userName">
          <el-input
            v-model="queryParams.userName"
            placeholder="请输入用户账号"
            clearable
            style="width: 200px"
            @keyup.enter="handleQuery"
          />
        </el-form-item>
        <el-form-item label="用户姓名" prop="nickName">
          <el-input
            v-model="queryParams.nickName"
            placeholder="请输入用户姓名"
            clearable
            style="width: 200px"
            @keyup.enter="handleQuery"
          />
        </el-form-item>
        <el-form-item label="手机号" prop="phonenumber">
          <el-input
            v-model="queryParams.phonenumber"
            placeholder="请输入手机号"
            clearable
            style="width: 200px"
            @keyup.enter="handleQuery"
          />
        </el-form-item>
        <el-form-item label="账号状态" prop="status">
          <el-select v-model="queryParams.status" placeholder="账号状态" clearable style="width: 200px">
            <el-option label="正常" value="0" />
            <el-option label="停用" value="1" />
          </el-select>
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
            @click="handleAdd"
            v-hasPermi="['basic:user:add']"
          >新增</el-button>
        </el-col>
        <el-col :span="1.5">
          <el-button
            type="success"
            plain
            icon="Edit"
            :disabled="single"
            @click="handleUpdate"
            v-hasPermi="['basic:user:edit']"
          >修改</el-button>
        </el-col>
        <right-toolbar v-model:showSearch="showSearch" @queryTable="getList"></right-toolbar>
      </el-row>

      <el-table v-loading="loading" :data="userList" @selection-change="handleSelectionChange">
        <el-table-column type="selection" width="55" align="center" />
        <el-table-column label="用户编号" align="center" prop="userId" width="100" />
        <el-table-column label="用户账号" align="center" prop="userName" :show-overflow-tooltip="true" />
        <el-table-column label="用户姓名" align="center" prop="nickName" :show-overflow-tooltip="true" />
        <el-table-column label="手机号" align="center" prop="phonenumber" width="130" />
        <el-table-column label="所属角色" align="center" :show-overflow-tooltip="true">
          <template #default="scope">
            <span>{{ formatRoles(scope.row) }}</span>
          </template>
        </el-table-column>
        <el-table-column label="账号状态" align="center" prop="status" width="100">
          <template #default="scope">
            <el-switch
              v-model="scope.row.status"
              active-value="0"
              inactive-value="1"
              @change="handleStatusChange(scope.row)"
              v-hasPermi="['basic:user:edit']"
            />
          </template>
        </el-table-column>
        <el-table-column label="创建时间" align="center" prop="createTime" width="180">
          <template #default="scope">
            <span>{{ parseTime(scope.row.createTime, '{y}-{m}-{d} {h}:{i}:{s}') }}</span>
          </template>
        </el-table-column>
        <el-table-column label="操作" align="center" width="220" class-name="small-padding fixed-width">
          <template #default="scope">
            <el-button link type="primary" icon="Edit" @click="handleUpdate(scope.row)" v-hasPermi="['basic:user:edit']">修改</el-button>
            <el-button link type="primary" icon="Key" @click="handleResetPwd(scope.row)" v-hasPermi="['basic:user:resetPwd']">重置密码</el-button>
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

      <el-dialog :title="title" v-model="open" width="680px" append-to-body>
        <el-form ref="userRef" :model="form" :rules="rules" label-width="100px">
          <el-row>
            <el-col :span="12">
              <el-form-item label="用户账号" prop="userName">
                <el-input v-model="form.userName" placeholder="请输入用户账号" :disabled="form.userId != undefined" />
              </el-form-item>
            </el-col>
            <el-col :span="12">
              <el-form-item label="用户姓名" prop="nickName">
                <el-input v-model="form.nickName" placeholder="请输入用户姓名" />
              </el-form-item>
            </el-col>
          </el-row>
          <el-row>
            <el-col :span="12">
              <el-form-item label="手机号" prop="phonenumber">
                <el-input v-model="form.phonenumber" placeholder="请输入手机号" maxlength="11" />
              </el-form-item>
            </el-col>
            <el-col :span="12">
              <el-form-item label="所属角色" prop="roleIds">
                <el-select v-model="form.roleIds" multiple placeholder="请选择所属角色" style="width: 100%">
                  <el-option
                    v-for="role in roleOptions"
                    :key="role.roleId"
                    :label="role.roleName"
                    :value="role.roleId"
                  />
                </el-select>
              </el-form-item>
            </el-col>
          </el-row>
          <el-row>
            <el-col :span="12">
              <el-form-item label="所属小区" prop="communityId">
                <el-select v-model="form.communityId" placeholder="请选择所属小区" clearable style="width: 100%">
                  <el-option
                    v-for="item in communityOptions"
                    :key="item.communityId"
                    :label="item.communityName"
                    :value="item.communityId"
                  />
                </el-select>
              </el-form-item>
            </el-col>
            <el-col :span="12">
              <el-form-item label="账号状态" prop="status">
                <el-radio-group v-model="form.status">
                  <el-radio value="0">正常</el-radio>
                  <el-radio value="1">停用</el-radio>
                </el-radio-group>
              </el-form-item>
            </el-col>
          </el-row>
          <el-row v-if="form.userId == undefined">
            <el-col :span="12">
              <el-form-item label="初始密码" prop="password">
                <el-input v-model="form.password" type="password" placeholder="请输入初始密码" show-password />
              </el-form-item>
            </el-col>
          </el-row>
        </el-form>
        <template #footer>
          <div class="dialog-footer">
            <el-button type="primary" @click="submitForm">确 定</el-button>
            <el-button @click="cancel">取 消</el-button>
          </div>
        </template>
      </el-dialog>
    </el-card>
  </div>
</template>

<script setup name="BasicUser">
import { listUser, addUser, updateUser, resetUserPwd, changeUserStatus } from '@/api/basic/user'
import { listRole } from '@/api/basic/role'
import { listCommunity } from '@/api/basic/community'

const { proxy } = getCurrentInstance()

const userList = ref([])
const roleOptions = ref([])
const communityOptions = ref([])
const open = ref(false)
const loading = ref(true)
const showSearch = ref(true)
const ids = ref([])
const single = ref(true)
const total = ref(0)
const title = ref('')

const data = reactive({
  form: {},
  queryParams: {
    pageNum: 1,
    pageSize: 10,
    userName: undefined,
    nickName: undefined,
    phonenumber: undefined,
    status: undefined
  },
  rules: {
    userName: [{ required: true, message: '用户账号不能为空', trigger: 'blur' }],
    nickName: [{ required: true, message: '用户姓名不能为空', trigger: 'blur' }],
    phonenumber: [
      { required: true, message: '手机号不能为空', trigger: 'blur' },
      { pattern: /^1[3-9]\d{9}$/, message: '手机号格式不正确', trigger: 'blur' }
    ],
    password: [{ required: true, message: '初始密码不能为空', trigger: 'blur' }],
    roleIds: [{ required: true, message: '请至少选择一个角色', trigger: 'change' }]
  }
})

const { queryParams, form, rules } = toRefs(data)

/** 查询用户列表 */
function getList() {
  loading.value = true
  listUser(queryParams.value).then(response => {
    userList.value = response.rows
    total.value = response.total
    loading.value = false
  }).catch(() => {
    loading.value = false
  })
}

/** 查询可分配角色 */
function getRoleOptions() {
  listRole({ pageNum: 1, pageSize: 200 }).then(response => {
    roleOptions.value = response.rows || []
  })
}

/** 查询小区列表，用于数据范围归属 */
function getCommunityOptions() {
  listCommunity({ pageNum: 1, pageSize: 200 }).then(response => {
    communityOptions.value = response.rows || []
  })
}

/** 角色列展示 */
function formatRoles(row) {
  if (row.roleNames) {
    return row.roleNames
  }
  if (Array.isArray(row.roles)) {
    return row.roles.map(item => item.roleName).join('、')
  }
  return '-'
}

/** 取消按钮 */
function cancel() {
  open.value = false
  reset()
}

/** 表单重置 */
function reset() {
  form.value = {
    userId: undefined,
    userName: undefined,
    nickName: undefined,
    phonenumber: undefined,
    password: undefined,
    communityId: undefined,
    roleIds: [],
    status: '0'
  }
  proxy.resetForm('userRef')
}

/** 搜索按钮操作 */
function handleQuery() {
  queryParams.value.pageNum = 1
  getList()
}

/** 重置按钮操作 */
function resetQuery() {
  proxy.resetForm('queryRef')
  handleQuery()
}

/** 多选框选中数据 */
function handleSelectionChange(selection) {
  ids.value = selection.map(item => item.userId)
  single.value = selection.length != 1
}

/** 新增按钮操作 */
function handleAdd() {
  reset()
  open.value = true
  title.value = '新增账号'
}

/** 修改按钮操作 */
function handleUpdate(row) {
  reset()
  const userId = row.userId || ids.value[0]
  const target = userList.value.find(item => item.userId === userId)
  if (target) {
    form.value = {
      ...target,
      roleIds: Array.isArray(target.roles) ? target.roles.map(item => item.roleId) : []
    }
  }
  open.value = true
  title.value = '修改账号'
}

/** 提交按钮 */
function submitForm() {
  proxy.$refs['userRef'].validate(valid => {
    if (!valid) {
      return
    }
    if (form.value.userId != undefined) {
      updateUser(form.value).then(() => {
        proxy.$modal.msgSuccess('修改成功')
        open.value = false
        getList()
      })
    } else {
      addUser(form.value).then(() => {
        proxy.$modal.msgSuccess('新增成功')
        open.value = false
        getList()
      })
    }
  })
}

/** 重置密码 */
function handleResetPwd(row) {
  proxy.$modal.prompt('请输入「' + row.userName + '」的新密码', '重置密码', {
    inputPattern: /^.{5,20}$/,
    inputErrorMessage: '密码长度必须介于 5 和 20 之间'
  }).then(({ value }) => {
    return resetUserPwd(row.userId, value)
  }).then(() => {
    proxy.$modal.msgSuccess('密码重置成功')
  }).catch(() => {})
}

/** 启用停用账号 */
function handleStatusChange(row) {
  const text = row.status === '0' ? '启用' : '停用'
  proxy.$modal.confirm('确认要「' + text + '」账号「' + row.userName + '」吗？').then(() => {
    return changeUserStatus(row.userId, row.status)
  }).then(() => {
    proxy.$modal.msgSuccess(text + '成功')
  }).catch(() => {
    row.status = row.status === '0' ? '1' : '0'
  })
}

getList()
getRoleOptions()
getCommunityOptions()
</script>
