# 老旧小区电梯故障报修与维保跟踪平台

本科毕业设计项目。面向业主、物业、维修员、管理员四类角色，覆盖电梯故障报修、工单调度、预防性维保与数据分析预警的完整业务闭环。

## 一、项目结构

```
项目/
├── backend/          后端服务（SpringBoot）
│   ├── ruoyi-admin/      启动模块与配置文件
│   ├── ruoyi-framework/  框架配置（安全、拦截器）
│   ├── ruoyi-system/     若依系统模块
│   ├── ruoyi-common/     公共工具
│   ├── ruoyi-quartz/     定时任务
│   ├── ruoyi-elevator/   电梯业务模块（本项目主要代码）
│   └── sql/
│       ├── elevator_schema.sql   建表脚本（只含结构，不含数据）
│       └── elevator_init.sql     建表脚本 + 演示数据
├── admin-web/        管理端前端（Vue3）
├── web-portal/       用户端前端（Vue3，业主/物业/维修员）
└── docs/             开发文档
```

## 二、技术栈

| 分层 | 技术 |
| --- | --- |
| 后端 | SpringBoot 3.5.16、Spring Security、JWT、MyBatis、Quartz |
| 数据库 | MySQL 8.0 |
| 缓存 | Redis |
| 管理端前端 | Vue 3、Vite 6、Pinia、Element Plus、ECharts |
| 用户端前端 | Vue 3、Vite 6、Pinia、Element Plus、ECharts |
| 地图 | 高德地图 JS API v2.0 |
| 权限模型 | RBAC |

后端基础工程基于 RuoYi-Vue（springboot3 分支）改造，管理端前端基于 RuoYi-Vue3 改造。

## 三、环境要求

| 依赖 | 版本 |
| --- | --- |
| JDK | 21 |
| Maven | 3.9 及以上 |
| Node.js | 20 及以上 |
| MySQL | 8.0 |
| Redis | 5.0 及以上 |

## 四、启动步骤

### 1. 建库

```bash
mysql -uroot -p < backend/sql/elevator_schema.sql
```

脚本会自动创建 `elevator` 库并建好全部 43 张表（含 Quartz 调度表），不含任何数据。

如需带演示数据的完整初始化（会清空并重建 `elevator` 库的全部表）：

```bash
mysql -uroot -p < backend/sql/elevator_init.sql
```

注意：`elevator_init.sql` 内部自带 `CREATE DATABASE` 与 `USE`，并会对 43 张表逐一 `drop table if exists` 后重建，执行前请确认目标库中没有需要保留的数据。

### 2. 启动 Redis

```bash
redis-server
```

默认连接 `localhost:6379`，无密码，库 0。

### 3. 修改后端数据库配置

编辑 `backend/ruoyi-admin/src/main/resources/application-druid.yml`：

```yaml
url: jdbc:mysql://localhost:3306/elevator?useUnicode=true&characterEncoding=utf8&zeroDateTimeBehavior=convertToNull&useSSL=true&serverTimezone=GMT%2B8
username: root
password: root          # 改成自己的 MySQL 密码
```

### 4. 启动后端

```bash
cd backend
mvn clean package -DskipTests
java -jar ruoyi-admin/target/ruoyi-admin.jar
```

后端端口 8080。

### 5. 配置高德地图密钥

业主报修、维修员到场打卡、管理员录入电梯坐标都要用高德地图，需自行申请密钥（不配置只影响定位与地图选点，其余功能正常）。

申请地址：https://console.amap.com/dev/index ，密钥类型必须选 **Web端（JS API）**，并同时拿到配套的安全密钥。

填入两个前端的环境文件：

`admin-web/.env.development` 与 `web-portal/.env.development`

```
VITE_AMAP_KEY = 你的Key
VITE_AMAP_SECURITY_CODE = 你的安全密钥
```

生产环境同理，改 `.env.production`。

### 6. 启动管理端前端

```bash
cd admin-web
npm install
npm run dev
```

访问 http://localhost:80

打包：`npm run build:prod`

### 7. 启动用户端前端

```bash
cd web-portal
npm install
npm run dev
```

访问 http://localhost:81

打包：`npm run build`

## 五、演示账号

管理端（http://localhost:80）

| 账号 | 密码 | 角色 |
| --- | --- | --- |
| admin | admin123 | 超级管理员 |

用户端（http://localhost:81）

| 账号 | 密码 | 角色 | 所属小区 |
| --- | --- | --- | --- |
| wuye01 | 123456 | 物业 | 阳光家园小区 |
| weixiu01 | 123456 | 维修员 | 阳光家园小区 |
| weixiu02 | 123456 | 维修员 | 和平里小区 |
| weixiu03 | 123456 | 维修员 | 铁路新村小区 |
| yezhu01 | 123456 | 业主 | 阳光家园小区 |

若用 `elevator_schema.sql` 建库（无数据），需先自行录入小区、楼栋、电梯与账号，或改用 `elevator_init.sql`。

## 六、功能模块

系统划分为 5 个模块、17 个子功能。

### 模块一 基础数据与权限管理

| 子功能 | 说明 | 使用者 |
| --- | --- | --- |
| 用户注册与登录 | 四类角色注册、账号密码登录、图形验证码、JWT 令牌 | 全部 |
| 角色权限管理 | RBAC 模型，用户关联角色、角色关联菜单与按钮权限 | 管理员 |
| 基础信息管理 | 小区、楼栋、电梯三级台账，电梯坐标地图选点，年检报告上传 | 管理员 |

### 模块二 故障报修与跟踪

| 子功能 | 说明 | 使用者 |
| --- | --- | --- |
| 故障一键报修 | 选择小区楼栋电梯、填写故障现象、选择故障等级、上传照片与短视频、提交 | 业主 |
| 故障分级管理 | 预设紧急与一般两级，物业可调整工单优先级，变更留痕 | 物业 |
| 多媒体证据上传 | 图片与视频上传，图片限 10MB、视频限 50MB，单工单各限 5 个，在线预览 | 业主 |
| 报修进度跟踪 | 全流程时间轴、各状态停留时长、流转记录 | 业主 |

### 模块三 工单调度与执行

| 子功能 | 说明 | 使用者 |
| --- | --- | --- |
| 智能派单 | 待派单池，按负责区域与技能标签推荐维修员，支持手动指定与批量派单 | 物业 |
| 维修人员接单 | 确认接单并反馈预计到场时间，或拒绝接单并填写原因 | 维修员 |
| 维修过程管理 | 登记到场（含定位与距离校验）、填写排查记录、提交完工说明与更换配件 | 维修员 |
| 工单异常处理 | 四类超时工单识别（派单、接单、到场、维修），重新指派、驳回、升级 | 物业 |

### 模块四 预防性维保

| 子功能 | 说明 | 使用者 |
| --- | --- | --- |
| 维保计划管理 | 半月保、季度检、半年保、年检四类周期计划，检查项模板配置，计划启停 | 物业 |
| 定期巡检执行 | 按周期自动生成巡检任务，现场打卡（含定位）、逐项勾选检查项、异常项上传照片 | 维修员 |
| 维保档案归档 | 汇总维保与巡检详情，按电梯形成全生命周期记录，支持检索与导出 | 管理员 |

### 模块五 数据分析与预警

| 子功能 | 说明 | 使用者 |
| --- | --- | --- |
| 故障频次统计 | 按电梯、楼栋、时间段统计故障次数，柱状图与趋势图 | 物业、管理员 |
| 超期预警监控 | 工单超时与维保临期自动预警，预警规则配置，已读未读处理 | 物业 |
| 电梯健康档案生成 | 综合故障率、维保完成率、巡检合格率生成健康评分，支持 PDF 与 Excel 导出 | 物业、管理员 |

## 七、业务流程

主流程（工单状态流转）：

```
业主报修 → 待处理 → 物业派单 → 已派单 → 维修员接单 → 已接单
→ 到场打卡 → 已到场 → 排查记录 → 维修中 → 完工提交 → 已修复
→ 业主确认 → 已完成
```

分支流程：

- 物业审核不通过，驳回并备注原因，工单回到业主处待补充
- 维修员拒绝接单，工单回到待派单池
- 维修员无法修复，提交异常说明，工单转物业处理
- 业主对维修结果不满意，提交申诉，工单进入返工
- 工单超过预设时限未流转，系统自动生成预警

## 八、角色与入口

| 角色 | 使用端 | 主要操作 |
| --- | --- | --- |
| 业主 | 用户端 | 提交报修、上传证据、查看进度、确认维修结果或申诉 |
| 物业 | 用户端 | 审核报修单、派发工单、管理维保计划、处理异常、查看统计 |
| 维修员 | 用户端 | 接单、记录维修过程、执行巡检任务 |
| 管理员 | 管理端 | 维护基础信息、配置角色权限、管理用户、查看全量数据 |

## 九、数据库

共 43 张表。

| 分类 | 数量 | 说明 |
| --- | --- | --- |
| 电梯业务表 | 17 | community、building、elevator、repair_order、repair_record、repair_evidence、order_status_log、maintain_plan、maintain_item、inspection_record、inspection_item_result、maintain_archive、elevator_health、warning_rule、warning_info、worker_skill、elevator_notice |
| 若依框架表 | 15 | sys_user、sys_role、sys_menu、sys_user_role、sys_role_menu、sys_dict_type、sys_dict_data、sys_config、sys_job、sys_job_log、sys_logininfor、sys_oper_log、sys_notice、sys_notice_read、sys_file |
| Quartz 调度表 | 11 | qrtz_ 前缀，由 Quartz 使用 |

项目已移除若依自带的部门表、岗位表与代码生成器表。

## 十、定时任务

业务定时任务共 3 个：

| 任务 | 说明 |
| --- | --- |
| 巡检工单自动生成 | 按维保计划周期自动生成巡检任务并指派负责人 |
| 超期预警扫描 | 按预警规则检查工单超时与维保临期，生成预警信息并推送 |
| 电梯健康评分重算 | 按故障率、维保完成率、巡检合格率重算各电梯的健康评分 |

另有 3 条若依框架自带的演示任务（`ryTask.ryNoParams` 等），不影响业务，可在管理端「定时任务」页停用或删除。

## 十一、权限与数据隔离

- 后端接口通过 `@PreAuthorize` 校验权限标识，权限数据存于 `sys_menu` 表
- 数据权限按所属小区隔离：非管理员角色的工单、电梯等数据自动限定在本人所属小区内
- 业主只能查看本人提交的工单
- 维修员只能查看派给本人的工单
- 前端路由另有角色校验，但仅作界面便利，真正的权限控制在后端

## 十二、注意事项

1. **高德密钥**：仓库中的 `.env` 文件里密钥为占位符 `xx`，需自行申请后填入，否则地图与定位功能不可用。
2. **数据库账号**：`application-druid.yml` 中默认为 `root/root`，请改为实际密码。
3. **Redis**：后端强依赖 Redis，用于登录令牌、验证码与缓存，未启动时后端无法正常登录。
4. **定位功能**：浏览器仅在 `localhost` 与 HTTPS 下允许获取地理位置。部署到局域网 IP 时，维修员到场打卡与巡检打卡的自动定位不可用，需手动处理。
5. **建库脚本**：`elevator_init.sql` 会对 `elevator` 库的表执行 `drop table if exists` 后重建，请勿在存有数据的库上直接执行。
