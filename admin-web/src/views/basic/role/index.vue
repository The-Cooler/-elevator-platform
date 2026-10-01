<template>
  <div class="app-container">
    <el-card shadow="never">
      <template #header>
        <div class="page-card-header">
          <span class="page-card-title">角色权限管理</span>
          <span class="page-card-desc">四类角色维护，按五个模块分组分配菜单与按钮权限</span>
        </div>
      </template>

      <el-form :model="queryParams" ref="queryRef" :inline="true" v-show="showSearch">
        <el-form-item label="角色名称" prop="roleName">
          <el-input
            v-model="queryParams.roleName"
            placeholder="请输入角色名称"
            clearable
            style="width: 200px"
            @keyup.enter="handleQuery"
          />
        </el-form-item>
        <el-form-item label="权限字符" prop="roleKey">
          <el-input
            v-model="queryParams.roleKey"
            placeholder="请输入权限字符"
            clearable
            style="width: 200px"
            @keyup.enter="handleQuery"
          />
        </el-form-item>
        <el-form-item label="角色状态" prop="status">
          <el-select v-model="queryParams.status" placeholder="角色状态" clearable style="width: 200px">
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
            v-hasPermi="['basic:role:add']"
          >新增</el-button>
        </el-col>
        <el-col :span="1.5">
          <el-button
            type="success"
            plain
            icon="Edit"
            :disabled="single"
            @click="handleUpdate"
            v-hasPermi="['basic:role:edit']"
          >修改</el-button>
        </el-col>
        <el-col :span="1.5">
          <el-button
            type="danger"
            plain
            icon="Delete"
            :disabled="multiple"
            @click="handleDelete"
            v-hasPermi="['basic:role:remove']"
          >删除</el-button>
        </el-col>
        <right-toolbar v-model:showSearch="showSearch" @queryTable="getList"></right-toolbar>
      </el-row>

      <el-table v-loading="loading" :data="roleList" @selection-change="handleSelectionChange">
        <el-table-column type="selection" width="55" align="center" />
        <el-table-column label="角色编号" align="center" prop="roleId" width="100" />
        <el-table-column label="角色名称" align="center" prop="roleName" :show-overflow-tooltip="true" />
        <el-table-column label="权限字符" align="center" prop="roleKey" :show-overflow-tooltip="true" />
        <el-table-column label="数据范围" align="center" prop="dataScope" width="140">
          <template #default="scope">
            <span>{{ formatDataScope(scope.row.dataScope) }}</span>
          </template>
        </el-table-column>
        <el-table-column label="显示顺序" align="center" prop="roleSort" width="100" />
        <el-table-column label="角色状态" align="center" prop="status" width="100">
          <template #default="scope">
            <el-tag :type="scope.row.status === '0' ? 'success' : 'info'">
              {{ scope.row.status === '0' ? '正常' : '停用' }}
            </el-tag>
          </template>
        </el-table-column>
        <el-table-column label="创建时间" align="center" prop="createTime" width="180">
          <template #default="scope">
            <span>{{ parseTime(scope.row.createTime, '{y}-{m}-{d} {h}:{i}:{s}') }}</span>
          </template>
        </el-table-column>
        <el-table-column label="操作" align="center" width="260" class-name="small-padding fixed-width">
          <template #default="scope">
            <el-button link type="primary" icon="Edit" @click="handleUpdate(scope.row)" v-hasPermi="['basic:role:edit']">修改</el-button>
            <el-button link type="primary" icon="Key" @click="handleMenuTree(scope.row)" v-hasPermi="['basic:role:edit']">权限分配</el-button>
            <el-button link type="primary" icon="Delete" @click="handleDelete(scope.row)" v-hasPermi="['basic:role:remove']">删除</el-button>
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

      <!-- 新增或修改角色 -->
      <el-dialog :title="title" v-model="open" width="640px" append-to-body>
        <el-form ref="roleRef" :model="form" :rules="rules" label-width="100px">
          <el-row>
            <el-col :span="12">
              <el-form-item label="角色名称" prop="roleName">
                <el-input v-model="form.roleName" placeholder="请输入角色名称" />
              </el-form-item>
            </el-col>
            <el-col :span="12">
              <el-form-item label="权限字符" prop="roleKey">
                <el-input v-model="form.roleKey" placeholder="请输入权限字符，如 property" />
              </el-form-item>
            </el-col>
          </el-row>
          <el-row>
            <el-col :span="12">
              <el-form-item label="显示顺序" prop="roleSort">
                <el-input-number v-model="form.roleSort" :min="0" controls-position="right" />
              </el-form-item>
            </el-col>
            <el-col :span="12">
              <el-form-item label="角色状态" prop="status">
                <el-radio-group v-model="form.status">
                  <el-radio value="0">正常</el-radio>
                  <el-radio value="1">停用</el-radio>
                </el-radio-group>
              </el-form-item>
            </el-col>
          </el-row>
          <el-form-item label="数据范围" prop="dataScope">
            <el-select v-model="form.dataScope" placeholder="请选择数据范围" style="width: 100%">
              <el-option label="全部数据" value="1" />
              <el-option label="本小区数据" value="2" />
              <el-option label="仅本人数据" value="3" />
            </el-select>
          </el-form-item>
          <el-form-item label="备注" prop="remark">
            <el-input v-model="form.remark" type="textarea" placeholder="请输入备注" />
          </el-form-item>
        </el-form>
        <template #footer>
          <div class="dialog-footer">
            <el-button type="primary" @click="submitForm">确 定</el-button>
            <el-button @click="cancel">取 消</el-button>
          </div>
        </template>
      </el-dialog>

      <!-- 菜单权限分配 -->
      <el-dialog :title="menuTitle" v-model="menuOpen" width="620px" append-to-body>
        <el-form label-width="100px">
          <el-form-item label="角色名称">
            <el-input v-model="menuForm.roleName" disabled />
          </el-form-item>
          <el-form-item label="权限字符">
            <el-input v-model="menuForm.roleKey" disabled />
          </el-form-item>
          <el-form-item label="菜单权限">
            <div class="tree-toolbar">
              <el-checkbox v-model="menuExpand" @change="handleExpandAll">展开/折叠</el-checkbox>
              <el-checkbox v-model="menuNodeAll" @change="handleCheckAll">全选/全不选</el-checkbox>
            </div>
            <el-tree
              ref="menuTreeRef"
              :data="menuOptions"
              :props="{ label: 'label', children: 'children' }"
              :check-strictly="!menuCheckStrictly"
              show-checkbox
              node-key="id"
              empty-text="加载中，请稍候"
              class="permission-tree"
            />
          </el-form-item>
        </el-form>
        <template #footer>
          <div class="dialog-footer">
            <el-button type="primary" @click="submitMenuTree">确 定</el-button>
            <el-button @click="menuOpen = false">取 消</el-button>
          </div>
        </template>
      </el-dialog>
    </el-card>
  </div>
</template>

<script setup name="BasicRole">
import { listRole, addRole, updateRole, delRole, getRoleMenuTree } from '@/api/basic/role'
import { menuTreeselect } from '@/api/basic/menu'

const { proxy } = getCurrentInstance()

const roleList = ref([])
const menuOptions = ref([])
const open = ref(false)
const menuOpen = ref(false)
const loading = ref(true)
const showSearch = ref(true)
const ids = ref([])
const single = ref(true)
const multiple = ref(true)
const total = ref(0)
const title = ref('')
const menuTitle = ref('')
const menuExpand = ref(false)
const menuNodeAll = ref(false)
const menuCheckStrictly = ref(true)

const DATA_SCOPE = {
  '1': '全部数据',
  '2': '本小区数据',
  '3': '仅本人数据'
}

const data = reactive({
  form: {},
  menuForm: {},
  queryParams: {
    pageNum: 1,
    pageSize: 10,
    roleName: undefined,
    roleKey: undefined,
    status: undefined
  },
  rules: {
    roleName: [{ required: true, message: '角色名称不能为空', trigger: 'blur' }],
    roleKey: [{ required: true, message: '权限字符不能为空', trigger: 'blur' }],
    roleSort: [{ required: true, message: '显示顺序不能为空', trigger: 'blur' }]
  }
})

const { queryParams, form, menuForm, rules } = toRefs(data)

/** 查询角色列表 */
function getList() {
  loading.value = true
  listRole(queryParams.value).then(response => {
    roleList.value = response.rows
    total.value = response.total
    loading.value = false
  }).catch(() => {
    loading.value = false
  })
}

function formatDataScope(value) {
  return DATA_SCOPE[value] || '未设置'
}

/** 取消按钮 */
function cancel() {
  open.value = false
  reset()
}

/** 表单重置 */
function reset() {
  form.value = {
    roleId: undefined,
    roleName: undefined,
    roleKey: undefined,
    roleSort: 0,
    dataScope: '1',
    status: '0',
    remark: undefined
  }
  proxy.resetForm('roleRef')
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
  ids.value = selection.map(item => item.roleId)
  single.value = selection.length != 1
  multiple.value = !selection.length
}

/** 新增按钮操作 */
function handleAdd() {
  reset()
  open.value = true
  title.value = '新增角色'
}

/** 修改按钮操作 */
function handleUpdate(row) {
  reset()
  const roleId = row.roleId || ids.value[0]
  const target = roleList.value.find(item => item.roleId === roleId)
  if (target) {
    form.value = { ...target }
  }
  open.value = true
  title.value = '修改角色'
}

/** 提交按钮 */
function submitForm() {
  proxy.$refs['roleRef'].validate(valid => {
    if (!valid) {
      return
    }
    if (form.value.roleId != undefined) {
      updateRole(form.value).then(() => {
        proxy.$modal.msgSuccess('修改成功')
        open.value = false
        getList()
      })
    } else {
      addRole(form.value).then(() => {
        proxy.$modal.msgSuccess('新增成功')
        open.value = false
        getList()
      })
    }
  })
}

/** 删除按钮操作 */
function handleDelete(row) {
  const roleIds = row.roleId || ids.value
  proxy.$modal.confirm('是否确认删除角色编号为"' + roleIds + '"的数据项？').then(() => {
    return delRole(roleIds)
  }).then(() => {
    getList()
    proxy.$modal.msgSuccess('删除成功')
  }).catch(() => {})
}

/** 打开权限分配面板 */
function handleMenuTree(row) {
  menuForm.value = { ...row }
  menuTitle.value = '分配权限 - ' + row.roleName
  Promise.all([menuTreeselect(), getRoleMenuTree(row.roleId)]).then(([treeRes, checkedRes]) => {
    menuOptions.value = treeRes.data || treeRes.menus || []
    const checkedKeys = checkedRes.data || checkedRes.checkedKeys || []
    menuOpen.value = true
    nextTick(() => {
      checkedKeys.forEach(key => {
        proxy.$refs['menuTreeRef'].setChecked(key, true, false)
      })
    })
  })
}

/** 展开与折叠全部节点 */
function handleExpandAll(expand) {
  const nodes = proxy.$refs['menuTreeRef'].store.nodesMap
  Object.keys(nodes).forEach(key => {
    nodes[key].expanded = expand
  })
}

/** 全选与全不选 */
function handleCheckAll(checked) {
  proxy.$refs['menuTreeRef'].setCheckedNodes(checked ? menuOptions.value : [])
}

/** 提交权限分配 */
function submitMenuTree() {
  const checkedKeys = proxy.$refs['menuTreeRef'].getCheckedKeys()
  const halfCheckedKeys = proxy.$refs['menuTreeRef'].getHalfCheckedKeys()
  updateRole({
    roleId: menuForm.value.roleId,
    menuIds: checkedKeys.concat(halfCheckedKeys)
  }).then(() => {
    proxy.$modal.msgSuccess('权限分配成功')
    menuOpen.value = false
  })
}

getList()
</script>

<style scoped lang="scss">
.tree-toolbar {
  display: flex;
  gap: 16px;
  margin-bottom: 6px;
}

.permission-tree {
  width: 100%;
  max-height: 320px;
  overflow: auto;
  border: 1px solid #ebeef5;
  border-radius: 4px;
  padding: 6px;
}
</style>
