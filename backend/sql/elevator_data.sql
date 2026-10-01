-- ============================================================
-- 老旧小区电梯故障报修与维保跟踪平台 - 初始化数据脚本
-- 适用库：elevator
-- 前置：先执行 ry_20260417.sql、quartz.sql、elevator_schema.sql
-- 内容：角色、菜单权限、业务基础数据、演示数据
-- 说明：本脚本设计为可重复执行，业务数据段会先清空再插入
-- ============================================================
USE `elevator`;

-- ============================================================
-- 一、角色
-- ============================================================
-- 1  超级管理员 admin      （RuoYi 自带）
-- 3  物业    property
-- 4  维修员  worker
-- 5  业主    owner
delete from sys_role where role_id in (3, 4, 5);
insert into sys_role values(3, '物业', 'property', 2, '1', 1, 1, '0', '0', 'admin', sysdate(), '', null, '物业管理人员，负责审核报修单、派发工单、管理维保计划、查看统计报表');
insert into sys_role values(4, '维修员', 'worker', 3, '1', 1, 1, '0', '0', 'admin', sysdate(), '', null, '维保单位人员，负责接单、反馈到场时间、记录维修过程、执行巡检任务');
insert into sys_role values(5, '业主', 'owner', 4, '5', 1, 1, '0', '0', 'admin', sysdate(), '', null, '电梯使用者，负责提交故障报修、上传证据、查看报修进度、确认维修结果');

-- ============================================================
-- 二、菜单与权限
-- 一级目录 menu_id 2000-2004，二级菜单 2100 起，按钮 2200 起
-- ============================================================
delete from sys_menu where menu_id >= 2000;
delete from sys_role_menu where menu_id >= 2000;

-- ---------- 模块一 基础数据与权限管理 ----------
insert into sys_menu values('2000', '基础数据与权限管理', '0', '1', 'basic', null, '', '', 1, 0, 'M', '0', '0', '', 'peoples', 'admin', sysdate(), '', null, '模块一目录');
insert into sys_menu values('2100', '用户注册与登录', '2000', '1', 'user', 'basic/user/index', '', '', 1, 0, 'C', '0', '0', 'basic:user:list', 'user', 'admin', sysdate(), '', null, '用户注册与登录菜单');
insert into sys_menu values('2101', '角色权限管理', '2000', '2', 'role', 'basic/role/index', '', '', 1, 0, 'C', '0', '0', 'basic:role:list', 'people', 'admin', sysdate(), '', null, '角色权限管理菜单');
insert into sys_menu values('2102', '基础信息管理', '2000', '3', 'info', 'basic/info/index', '', '', 1, 0, 'C', '0', '0', 'basic:info:list', 'tree', 'admin', sysdate(), '', null, '基础信息管理菜单');

-- ---------- 模块二 故障报修与跟踪 ----------
insert into sys_menu values('2001', '故障报修与跟踪', '0', '2', 'repair', null, '', '', 1, 0, 'M', '0', '0', '', 'message', 'admin', sysdate(), '', null, '模块二目录');
insert into sys_menu values('2103', '故障一键报修', '2001', '1', 'order', 'repair/order/index', '', '', 1, 0, 'C', '0', '0', 'repair:order:list', 'form', 'admin', sysdate(), '', null, '故障一键报修菜单');
insert into sys_menu values('2104', '故障分级管理', '2001', '2', 'level', 'repair/level/index', '', '', 1, 0, 'C', '0', '0', 'repair:level:list', 'star', 'admin', sysdate(), '', null, '故障分级管理菜单');
insert into sys_menu values('2105', '多媒体证据上传', '2001', '3', 'evidence', 'repair/evidence/index', '', '', 1, 0, 'C', '0', '0', 'repair:evidence:list', 'upload', 'admin', sysdate(), '', null, '多媒体证据上传菜单');
insert into sys_menu values('2106', '报修进度跟踪', '2001', '4', 'track', 'repair/track/index', '', '', 1, 0, 'C', '0', '0', 'repair:track:list', 'time-range', 'admin', sysdate(), '', null, '报修进度跟踪菜单');

-- ---------- 模块三 工单调度与执行 ----------
insert into sys_menu values('2002', '工单调度与执行', '0', '3', 'order', null, '', '', 1, 0, 'M', '0', '0', '', 'job', 'admin', sysdate(), '', null, '模块三目录');
insert into sys_menu values('2107', '智能派单', '2002', '1', 'dispatch', 'order/dispatch/index', '', '', 1, 0, 'C', '0', '0', 'order:dispatch:list', 'guide', 'admin', sysdate(), '', null, '智能派单菜单');
insert into sys_menu values('2108', '维保人员接单', '2002', '2', 'accept', 'order/accept/index', '', '', 1, 0, 'C', '0', '0', 'order:accept:list', 'checkbox', 'admin', sysdate(), '', null, '维保人员接单菜单');
insert into sys_menu values('2109', '维修过程管理', '2002', '3', 'process', 'order/process/index', '', '', 1, 0, 'C', '0', '0', 'order:process:list', 'edit', 'admin', sysdate(), '', null, '维修过程管理菜单');
insert into sys_menu values('2110', '工单异常处理', '2002', '4', 'exception', 'order/exception/index', '', '', 1, 0, 'C', '0', '0', 'order:exception:list', 'bug', 'admin', sysdate(), '', null, '工单异常处理菜单');

-- ---------- 模块四 预防性维保 ----------
insert into sys_menu values('2003', '预防性维保', '0', '4', 'maintain', null, '', '', 1, 0, 'M', '0', '0', '', 'server', 'admin', sysdate(), '', null, '模块四目录');
insert into sys_menu values('2111', '维保计划管理', '2003', '1', 'plan', 'maintain/plan/index', '', '', 1, 0, 'C', '0', '0', 'maintain:plan:list', 'date', 'admin', sysdate(), '', null, '维保计划管理菜单');
insert into sys_menu values('2112', '定期巡检执行', '2003', '2', 'inspection', 'maintain/inspection/index', '', '', 1, 0, 'C', '0', '0', 'maintain:inspection:list', 'validCode', 'admin', sysdate(), '', null, '定期巡检执行菜单');
insert into sys_menu values('2113', '维保档案归档', '2003', '3', 'archive', 'maintain/archive/index', '', '', 1, 0, 'C', '0', '0', 'maintain:archive:list', 'documentation', 'admin', sysdate(), '', null, '维保档案归档菜单');

-- ---------- 模块五 数据分析与预警 ----------
insert into sys_menu values('2004', '数据分析与预警', '0', '5', 'analysis', null, '', '', 1, 0, 'M', '0', '0', '', 'chart', 'admin', sysdate(), '', null, '模块五目录');
insert into sys_menu values('2114', '故障频次统计', '2004', '1', 'frequency', 'analysis/frequency/index', '', '', 1, 0, 'C', '0', '0', 'analysis:frequency:list', 'chart', 'admin', sysdate(), '', null, '故障频次统计菜单');
insert into sys_menu values('2115', '超期预警监控', '2004', '2', 'warning', 'analysis/warning/index', '', '', 1, 0, 'C', '0', '0', 'analysis:warning:list', 'bell', 'admin', sysdate(), '', null, '超期预警监控菜单');
insert into sys_menu values('2116', '电梯健康档案生成', '2004', '3', 'health', 'analysis/health/index', '', '', 1, 0, 'C', '0', '0', 'analysis:health:list', 'monitor', 'admin', sysdate(), '', null, '电梯健康档案生成菜单');

-- ---------- 按钮权限 ----------
-- 模块一
insert into sys_menu values('2200', '用户查询', '2100', '1', '', '', '', '', 1, 0, 'F', '0', '0', 'basic:user:query', '#', 'admin', sysdate(), '', null, '');
insert into sys_menu values('2201', '用户新增', '2100', '2', '', '', '', '', 1, 0, 'F', '0', '0', 'basic:user:add', '#', 'admin', sysdate(), '', null, '');
insert into sys_menu values('2202', '用户修改', '2100', '3', '', '', '', '', 1, 0, 'F', '0', '0', 'basic:user:edit', '#', 'admin', sysdate(), '', null, '');
insert into sys_menu values('2203', '重置密码', '2100', '4', '', '', '', '', 1, 0, 'F', '0', '0', 'basic:user:resetPwd', '#', 'admin', sysdate(), '', null, '');
insert into sys_menu values('2204', '角色查询', '2101', '1', '', '', '', '', 1, 0, 'F', '0', '0', 'basic:role:query', '#', 'admin', sysdate(), '', null, '');
insert into sys_menu values('2205', '角色新增', '2101', '2', '', '', '', '', 1, 0, 'F', '0', '0', 'basic:role:add', '#', 'admin', sysdate(), '', null, '');
insert into sys_menu values('2206', '角色修改', '2101', '3', '', '', '', '', 1, 0, 'F', '0', '0', 'basic:role:edit', '#', 'admin', sysdate(), '', null, '');
insert into sys_menu values('2207', '角色删除', '2101', '4', '', '', '', '', 1, 0, 'F', '0', '0', 'basic:role:remove', '#', 'admin', sysdate(), '', null, '');
insert into sys_menu values('2208', '小区楼栋电梯查询', '2102', '1', '', '', '', '', 1, 0, 'F', '0', '0', 'basic:info:query', '#', 'admin', sysdate(), '', null, '');
insert into sys_menu values('2209', '基础信息新增', '2102', '2', '', '', '', '', 1, 0, 'F', '0', '0', 'basic:info:add', '#', 'admin', sysdate(), '', null, '');
insert into sys_menu values('2210', '基础信息修改', '2102', '3', '', '', '', '', 1, 0, 'F', '0', '0', 'basic:info:edit', '#', 'admin', sysdate(), '', null, '');
insert into sys_menu values('2211', '基础信息删除', '2102', '4', '', '', '', '', 1, 0, 'F', '0', '0', 'basic:info:remove', '#', 'admin', sysdate(), '', null, '');
insert into sys_menu values('2212', '基础信息导出', '2102', '5', '', '', '', '', 1, 0, 'F', '0', '0', 'basic:info:export', '#', 'admin', sysdate(), '', null, '');

-- 模块二
insert into sys_menu values('2213', '报修单查询', '2103', '1', '', '', '', '', 1, 0, 'F', '0', '0', 'repair:order:query', '#', 'admin', sysdate(), '', null, '');
insert into sys_menu values('2214', '报修单驳回', '2103', '2', '', '', '', '', 1, 0, 'F', '0', '0', 'repair:order:reject', '#', 'admin', sysdate(), '', null, '');
insert into sys_menu values('2215', '报修单导出', '2103', '3', '', '', '', '', 1, 0, 'F', '0', '0', 'repair:order:export', '#', 'admin', sysdate(), '', null, '');
insert into sys_menu values('2216', '故障等级查询', '2104', '1', '', '', '', '', 1, 0, 'F', '0', '0', 'repair:level:query', '#', 'admin', sysdate(), '', null, '');
insert into sys_menu values('2217', '调整故障等级', '2104', '2', '', '', '', '', 1, 0, 'F', '0', '0', 'repair:order:changeLevel', '#', 'admin', sysdate(), '', null, '');
insert into sys_menu values('2218', '证据查询', '2105', '1', '', '', '', '', 1, 0, 'F', '0', '0', 'repair:evidence:query', '#', 'admin', sysdate(), '', null, '');
insert into sys_menu values('2219', '证据删除', '2105', '2', '', '', '', '', 1, 0, 'F', '0', '0', 'repair:evidence:remove', '#', 'admin', sysdate(), '', null, '');
insert into sys_menu values('2220', '进度查询', '2106', '1', '', '', '', '', 1, 0, 'F', '0', '0', 'repair:track:query', '#', 'admin', sysdate(), '', null, '');

-- 模块三
insert into sys_menu values('2221', '待派单查询', '2107', '1', '', '', '', '', 1, 0, 'F', '0', '0', 'order:dispatch:query', '#', 'admin', sysdate(), '', null, '');
insert into sys_menu values('2222', '执行派单', '2107', '2', '', '', '', '', 1, 0, 'F', '0', '0', 'order:dispatch:assign', '#', 'admin', sysdate(), '', null, '');
insert into sys_menu values('2223', '接单查询', '2108', '1', '', '', '', '', 1, 0, 'F', '0', '0', 'order:accept:query', '#', 'admin', sysdate(), '', null, '');
insert into sys_menu values('2224', '确认接单', '2108', '2', '', '', '', '', 1, 0, 'F', '0', '0', 'order:accept:confirm', '#', 'admin', sysdate(), '', null, '');
insert into sys_menu values('2225', '维修过程查询', '2109', '1', '', '', '', '', 1, 0, 'F', '0', '0', 'order:process:query', '#', 'admin', sysdate(), '', null, '');
insert into sys_menu values('2226', '推进维修状态', '2109', '2', '', '', '', '', 1, 0, 'F', '0', '0', 'order:process:edit', '#', 'admin', sysdate(), '', null, '');
insert into sys_menu values('2227', '异常工单查询', '2110', '1', '', '', '', '', 1, 0, 'F', '0', '0', 'order:exception:query', '#', 'admin', sysdate(), '', null, '');
insert into sys_menu values('2228', '异常工单处理', '2110', '2', '', '', '', '', 1, 0, 'F', '0', '0', 'order:exception:edit', '#', 'admin', sysdate(), '', null, '');

-- 模块四
insert into sys_menu values('2229', '维保计划查询', '2111', '1', '', '', '', '', 1, 0, 'F', '0', '0', 'maintain:plan:query', '#', 'admin', sysdate(), '', null, '');
insert into sys_menu values('2230', '维保计划新增', '2111', '2', '', '', '', '', 1, 0, 'F', '0', '0', 'maintain:plan:add', '#', 'admin', sysdate(), '', null, '');
insert into sys_menu values('2231', '维保计划修改', '2111', '3', '', '', '', '', 1, 0, 'F', '0', '0', 'maintain:plan:edit', '#', 'admin', sysdate(), '', null, '');
insert into sys_menu values('2232', '维保计划删除', '2111', '4', '', '', '', '', 1, 0, 'F', '0', '0', 'maintain:plan:remove', '#', 'admin', sysdate(), '', null, '');
insert into sys_menu values('2233', '巡检任务查询', '2112', '1', '', '', '', '', 1, 0, 'F', '0', '0', 'maintain:inspection:query', '#', 'admin', sysdate(), '', null, '');
insert into sys_menu values('2234', '巡检打卡执行', '2112', '2', '', '', '', '', 1, 0, 'F', '0', '0', 'maintain:inspection:execute', '#', 'admin', sysdate(), '', null, '');
insert into sys_menu values('2235', '巡检记录导出', '2112', '3', '', '', '', '', 1, 0, 'F', '0', '0', 'maintain:inspection:export', '#', 'admin', sysdate(), '', null, '');
insert into sys_menu values('2236', '维保档案查询', '2113', '1', '', '', '', '', 1, 0, 'F', '0', '0', 'maintain:archive:query', '#', 'admin', sysdate(), '', null, '');
insert into sys_menu values('2237', '维保档案导出', '2113', '2', '', '', '', '', 1, 0, 'F', '0', '0', 'maintain:archive:export', '#', 'admin', sysdate(), '', null, '');

-- 模块五
insert into sys_menu values('2238', '频次统计查询', '2114', '1', '', '', '', '', 1, 0, 'F', '0', '0', 'analysis:frequency:query', '#', 'admin', sysdate(), '', null, '');
insert into sys_menu values('2239', '频次统计导出', '2114', '2', '', '', '', '', 1, 0, 'F', '0', '0', 'analysis:frequency:export', '#', 'admin', sysdate(), '', null, '');
insert into sys_menu values('2240', '预警查询', '2115', '1', '', '', '', '', 1, 0, 'F', '0', '0', 'analysis:warning:query', '#', 'admin', sysdate(), '', null, '');
insert into sys_menu values('2241', '预警规则配置', '2115', '2', '', '', '', '', 1, 0, 'F', '0', '0', 'analysis:warning:rule', '#', 'admin', sysdate(), '', null, '');
insert into sys_menu values('2242', '健康档案查询', '2116', '1', '', '', '', '', 1, 0, 'F', '0', '0', 'analysis:health:query', '#', 'admin', sysdate(), '', null, '');
insert into sys_menu values('2243', '健康档案导出', '2116', '2', '', '', '', '', 1, 0, 'F', '0', '0', 'analysis:health:export', '#', 'admin', sysdate(), '', null, '');

-- ---------- 角色菜单授权 ----------
-- 超级管理员：全部菜单
insert into sys_role_menu select 1, menu_id from sys_menu where menu_id >= 2000;

-- 物业：除用户管理、角色权限管理外的全部业务菜单
insert into sys_role_menu
select 3, menu_id from sys_menu
where menu_id >= 2000
  and menu_id not in (2100, 2101);

-- 维修员：接单、维修过程、巡检执行、报修进度查询
insert into sys_role_menu values(4, 2001),(4, 2002),(4, 2003),(4, 2106),(4, 2108),(4, 2109),(4, 2112),(4, 2220),(4, 2223),(4, 2224),(4, 2225),(4, 2226),(4, 2233),(4, 2234);

-- 业主：仅报修进度查询（业主主要使用用户端）
insert into sys_role_menu values(5, 2001),(5, 2106),(5, 2220);

-- ============================================================
-- 三、字典
-- ============================================================
delete from sys_dict_data where dict_type in ('repair_order_status','fault_level','fault_type','maintain_type','elevator_status','order_operation','health_level','warning_type');
delete from sys_dict_type where dict_type in ('repair_order_status','fault_level','fault_type','maintain_type','elevator_status','order_operation','health_level','warning_type');

insert into sys_dict_type values(100, '工单状态', 'repair_order_status', '0', 'admin', sysdate(), '', null, '报修工单状态列表');
insert into sys_dict_type values(101, '故障等级', 'fault_level', '0', 'admin', sysdate(), '', null, '故障等级列表');
insert into sys_dict_type values(102, '故障类型', 'fault_type', '0', 'admin', sysdate(), '', null, '故障现象类型列表');
insert into sys_dict_type values(103, '维保类型', 'maintain_type', '0', 'admin', sysdate(), '', null, '维保类型列表');
insert into sys_dict_type values(104, '电梯状态', 'elevator_status', '0', 'admin', sysdate(), '', null, '电梯状态列表');
insert into sys_dict_type values(105, '工单操作类型', 'order_operation', '0', 'admin', sysdate(), '', null, '工单状态流转操作类型');
insert into sys_dict_type values(106, '健康等级', 'health_level', '0', 'admin', sysdate(), '', null, '电梯健康等级列表');
insert into sys_dict_type values(107, '预警类型', 'warning_type', '0', 'admin', sysdate(), '', null, '预警类型列表');

insert into sys_dict_data values(100, 1, '待处理', 'pending', 'repair_order_status', '', 'warning', 'Y', '0', 'admin', sysdate(), '', null, '报修已提交，等待物业审核');
insert into sys_dict_data values(101, 2, '已派单', 'assigned', 'repair_order_status', '', 'primary', 'N', '0', 'admin', sysdate(), '', null, '物业已指派维修员');
insert into sys_dict_data values(102, 3, '已接单', 'accepted', 'repair_order_status', '', 'info', 'N', '0', 'admin', sysdate(), '', null, '维修员已确认接单');
insert into sys_dict_data values(103, 4, '已到场', 'arrived', 'repair_order_status', '', 'info', 'N', '0', 'admin', sysdate(), '', null, '维修员已到达现场');
insert into sys_dict_data values(104, 5, '维修中', 'repairing', 'repair_order_status', '', 'info', 'N', '0', 'admin', sysdate(), '', null, '正在排查与维修');
insert into sys_dict_data values(105, 6, '已修复', 'repaired', 'repair_order_status', '', 'success', 'N', '0', 'admin', sysdate(), '', null, '维修完成，等待业主确认');
insert into sys_dict_data values(106, 7, '已完成', 'confirmed', 'repair_order_status', '', 'success', 'N', '0', 'admin', sysdate(), '', null, '业主已确认，工单闭环');
insert into sys_dict_data values(107, 8, '已驳回', 'rejected', 'repair_order_status', '', 'danger', 'N', '0', 'admin', sysdate(), '', null, '物业驳回，待业主补充');
insert into sys_dict_data values(108, 9, '已申诉', 'appealed', 'repair_order_status', '', 'danger', 'N', '0', 'admin', sysdate(), '', null, '业主对结果不满意，转物业处理');

insert into sys_dict_data values(110, 1, '紧急', '0', 'fault_level', '', 'danger', 'N', '0', 'admin', sysdate(), '', null, '困人、停梯、溜梯等危及人身安全的情形');
insert into sys_dict_data values(111, 2, '一般', '1', 'fault_level', '', 'warning', 'N', '0', 'admin', sysdate(), '', null, '异响、按键失灵、照明故障等不影响安全的情形');

insert into sys_dict_data values(120, 1, '异响', 'abnormal_noise', 'fault_type', '', '', 'N', '0', 'admin', sysdate(), '', null, '');
insert into sys_dict_data values(121, 2, '停梯', 'stop', 'fault_type', '', '', 'N', '0', 'admin', sysdate(), '', null, '');
insert into sys_dict_data values(122, 3, '困人', 'trapped', 'fault_type', '', '', 'N', '0', 'admin', sysdate(), '', null, '');
insert into sys_dict_data values(123, 4, '门故障', 'door', 'fault_type', '', '', 'N', '0', 'admin', sysdate(), '', null, '');
insert into sys_dict_data values(124, 5, '按钮失灵', 'button', 'fault_type', '', '', 'N', '0', 'admin', sysdate(), '', null, '');
insert into sys_dict_data values(125, 6, '其他', 'other', 'fault_type', '', '', 'N', '0', 'admin', sysdate(), '', null, '');

insert into sys_dict_data values(130, 1, '半月保', 'half_month', 'maintain_type', '', '', 'N', '0', 'admin', sysdate(), '', null, '每15天一次');
insert into sys_dict_data values(131, 2, '季度检', 'quarter', 'maintain_type', '', '', 'N', '0', 'admin', sysdate(), '', null, '每90天一次');
insert into sys_dict_data values(132, 3, '半年保', 'half_year', 'maintain_type', '', '', 'N', '0', 'admin', sysdate(), '', null, '每180天一次');
insert into sys_dict_data values(133, 4, '年检', 'annual', 'maintain_type', '', '', 'N', '0', 'admin', sysdate(), '', null, '每365天一次');

insert into sys_dict_data values(140, 1, '正常运行', '0', 'elevator_status', '', 'success', 'N', '0', 'admin', sysdate(), '', null, '');
insert into sys_dict_data values(141, 2, '停梯检修', '1', 'elevator_status', '', 'warning', 'N', '0', 'admin', sysdate(), '', null, '');
insert into sys_dict_data values(142, 3, '已报废', '2', 'elevator_status', '', 'danger', 'N', '0', 'admin', sysdate(), '', null, '');

insert into sys_dict_data values(150, 1, '提交报修', 'report', 'order_operation', '', '', 'N', '0', 'admin', sysdate(), '', null, '');
insert into sys_dict_data values(151, 2, '驳回', 'reject', 'order_operation', '', '', 'N', '0', 'admin', sysdate(), '', null, '');
insert into sys_dict_data values(152, 3, '派单', 'assign', 'order_operation', '', '', 'N', '0', 'admin', sysdate(), '', null, '');
insert into sys_dict_data values(153, 4, '接单', 'accept', 'order_operation', '', '', 'N', '0', 'admin', sysdate(), '', null, '');
insert into sys_dict_data values(154, 5, '到场', 'arrive', 'order_operation', '', '', 'N', '0', 'admin', sysdate(), '', null, '');
insert into sys_dict_data values(155, 6, '排查', 'investigate', 'order_operation', '', '', 'N', '0', 'admin', sysdate(), '', null, '');
insert into sys_dict_data values(156, 7, '维修完成', 'finish', 'order_operation', '', '', 'N', '0', 'admin', sysdate(), '', null, '');
insert into sys_dict_data values(157, 8, '业主确认', 'confirm', 'order_operation', '', '', 'N', '0', 'admin', sysdate(), '', null, '');
insert into sys_dict_data values(158, 9, '申诉', 'appeal', 'order_operation', '', '', 'N', '0', 'admin', sysdate(), '', null, '');
insert into sys_dict_data values(159, 10, '重新指派', 'reassign', 'order_operation', '', '', 'N', '0', 'admin', sysdate(), '', null, '');
insert into sys_dict_data values(160, 11, '升级处理', 'escalate', 'order_operation', '', '', 'N', '0', 'admin', sysdate(), '', null, '');

insert into sys_dict_data values(170, 1, '优秀', 'excellent', 'health_level', '', 'success', 'N', '0', 'admin', sysdate(), '', null, '90分及以上');
insert into sys_dict_data values(171, 2, '良好', 'good', 'health_level', '', 'success', 'N', '0', 'admin', sysdate(), '', null, '80-89分');
insert into sys_dict_data values(172, 3, '一般', 'fair', 'health_level', '', 'warning', 'N', '0', 'admin', sysdate(), '', null, '70-79分');
insert into sys_dict_data values(173, 4, '较差', 'poor', 'health_level', '', 'warning', 'N', '0', 'admin', sysdate(), '', null, '60-69分');
insert into sys_dict_data values(174, 5, '危险', 'danger', 'health_level', '', 'danger', 'N', '0', 'admin', sysdate(), '', null, '60分以下');

insert into sys_dict_data values(180, 1, '工单超时', 'order_timeout', 'warning_type', '', 'warning', 'N', '0', 'admin', sysdate(), '', null, '');
insert into sys_dict_data values(181, 2, '维保临期', 'maintain_due', 'warning_type', '', 'warning', 'N', '0', 'admin', sysdate(), '', null, '');

-- ============================================================
-- 四、演示账号
-- 统一密码 admin123，BCrypt 加密存储
-- 采用显式列名插入，避免 sys_user 增列后按位置插入错位
-- community_id 为论文表3-1 要求的所属小区字段
-- ============================================================
delete from sys_user_role where user_id in (100, 101, 102, 103, 104);
delete from sys_user where user_id in (100, 101, 102, 103, 104);

insert into sys_user
  (user_id, dept_id, community_id, user_name, nick_name, user_type, email, phonenumber, sex, avatar, password,
   status, del_flag, login_ip, login_date, pwd_update_date, create_by, create_time, remark)
values
  (100, 103, 1, 'wuye01', '物业管理员', '00', 'wuye01@elevator.com', '13800000001', '1', '',
   '$2a$10$gyEgAsudVRZUUksP49d6geVDVNz6W5gWBdzlJ7ssKxdf07z1XwRIi',
   '0', '0', '127.0.0.1', sysdate(), sysdate(), 'admin', sysdate(), '阳光家园小区物业管理员');

insert into sys_user
  (user_id, dept_id, community_id, user_name, nick_name, user_type, email, phonenumber, sex, avatar, password,
   status, del_flag, login_ip, login_date, pwd_update_date, create_by, create_time, remark)
values
  (101, 103, 1, 'weixiu01', '维修员王师傅', '00', 'weixiu01@elevator.com', '13800000002', '1', '',
   '$2a$10$gyEgAsudVRZUUksP49d6geVDVNz6W5gWBdzlJ7ssKxdf07z1XwRIi',
   '0', '0', '127.0.0.1', sysdate(), sysdate(), 'admin', sysdate(), '黑龙江安捷电梯维保有限公司，负责阳光家园小区');

insert into sys_user
  (user_id, dept_id, community_id, user_name, nick_name, user_type, email, phonenumber, sex, avatar, password,
   status, del_flag, login_ip, login_date, pwd_update_date, create_by, create_time, remark)
values
  (102, 103, 1, 'yezhu01', '业主张阿姨', '00', 'yezhu01@elevator.com', '13800000003', '1', '',
   '$2a$10$gyEgAsudVRZUUksP49d6geVDVNz6W5gWBdzlJ7ssKxdf07z1XwRIi',
   '0', '0', '127.0.0.1', sysdate(), sysdate(), 'admin', sysdate(), '阳光家园小区1号楼1单元业主');

insert into sys_user
  (user_id, dept_id, community_id, user_name, nick_name, user_type, email, phonenumber, sex, avatar, password,
   status, del_flag, login_ip, login_date, pwd_update_date, create_by, create_time, remark)
values
  (103, 103, 2, 'weixiu02', '维修员李师傅', '00', 'weixiu02@elevator.com', '13800000004', '1', '',
   '$2a$10$gyEgAsudVRZUUksP49d6geVDVNz6W5gWBdzlJ7ssKxdf07z1XwRIi',
   '0', '0', '127.0.0.1', sysdate(), sysdate(), 'admin', sysdate(), '哈尔滨华信机电设备有限公司，负责和平里小区');

insert into sys_user
  (user_id, dept_id, community_id, user_name, nick_name, user_type, email, phonenumber, sex, avatar, password,
   status, del_flag, login_ip, login_date, pwd_update_date, create_by, create_time, remark)
values
  (104, 103, 3, 'weixiu03', '维修员赵师傅', '00', 'weixiu03@elevator.com', '13800000005', '1', '',
   '$2a$10$gyEgAsudVRZUUksP49d6geVDVNz6W5gWBdzlJ7ssKxdf07z1XwRIi',
   '0', '0', '127.0.0.1', sysdate(), sysdate(), 'admin', sysdate(), '黑龙江广日电梯工程有限公司，负责铁路新村小区');
insert into sys_user_role values(100, 3);
insert into sys_user_role values(101, 4);
insert into sys_user_role values(102, 5);
insert into sys_user_role values(103, 4);
insert into sys_user_role values(104, 4);

-- ============================================================
-- 五、业务基础数据（可重复执行，先清空）
-- ============================================================
delete from inspection_item_result;
delete from inspection_record;
delete from maintain_archive;
delete from maintain_plan;
delete from maintain_item;
delete from warning_info;
delete from warning_rule;
delete from elevator_health;
delete from elevator_notice;
delete from order_status_log;
delete from repair_record;
delete from repair_evidence;
delete from repair_order;
delete from worker_skill;
delete from sys_file;
delete from elevator;
delete from building;
delete from community;

-- ---------- 小区 ----------
insert into community values(1, '阳光家园小区', '哈尔滨市南岗区学府路128号', '2003', '张建国', '0451-86001122', '0', '0', 'admin', sysdate(), '', null, '典型老旧小区，无电梯加装于2021年');
insert into community values(2, '和平里小区', '哈尔滨市道里区和平路56号', '1998', '李秀兰', '0451-86003344', '0', '0', 'admin', sysdate(), '', null, '老旧小区，老年居民占比高');
insert into community values(3, '铁路新村小区', '哈尔滨市香坊区红旗大街211号', '2001', '王海涛', '0451-86005566', '0', '0', 'admin', sysdate(), '', null, '原铁路系统职工住宅');

-- ---------- 楼栋 ----------
insert into building values(1, 1, '1号楼', '1单元', 7, '0', '0', 'admin', sysdate(), '', null, null);
insert into building values(2, 1, '1号楼', '2单元', 7, '0', '0', 'admin', sysdate(), '', null, null);
insert into building values(3, 1, '2号楼', '1单元', 6, '0', '0', 'admin', sysdate(), '', null, null);
insert into building values(4, 2, '3号楼', '1单元', 6, '0', '0', 'admin', sysdate(), '', null, null);
insert into building values(5, 2, '4号楼', '1单元', 8, '0', '0', 'admin', sysdate(), '', null, null);
insert into building values(6, 3, 'A座', '1单元', 11, '0', '0', 'admin', sysdate(), '', null, null);

-- ---------- 电梯 ----------
insert into elevator values(1, 'DT-A-001', '日立', 'HGE-1000', 1, '1单元', '黑龙江安捷电梯维保有限公司', '2010-06-01', 15, null, '0', '0', 'admin', sysdate(), '', null, '运行平稳，钢丝绳有轻微磨损');
insert into elevator values(2, 'DT-A-002', '日立', 'HGE-1000', 2, '2单元', '黑龙江安捷电梯维保有限公司', '2010-06-01', 15, null, '0', '0', 'admin', sysdate(), '', null, '门系统偶有异响');
insert into elevator values(3, 'DT-B-001', '三菱', 'LEHY-III', 3, '1单元', '哈尔滨华信机电设备有限公司', '2012-09-15', 13, null, '0', '0', 'admin', sysdate(), '', null, '');
insert into elevator values(4, 'DT-C-001', '通力', 'KONE-3000', 4, '1单元', '哈尔滨华信机电设备有限公司', '2008-03-20', 18, null, '1', '0', 'admin', sysdate(), '', null, '使用年限长，已停梯待大修');
insert into elevator values(5, 'DT-C-002', '奥的斯', 'OTIS-3200', 5, '1单元', '黑龙江安捷电梯维保有限公司', '2015-11-08', 10, null, '0', '0', 'admin', sysdate(), '', null, '');
insert into elevator values(6, 'DT-D-001', '迅达', 'Schindler-3300', 6, '1单元', '黑龙江广日电梯工程有限公司', '2006-05-12', 20, null, '0', '0', 'admin', sysdate(), '', null, '老旧电梯，故障率偏高，重点监控');

-- ---------- 维修员技能与区域 ----------
insert into worker_skill values(1, 101, 1, '曳引机,门系统,控制系统', '0', 0, 0, 0, 'admin', sysdate(), '', null);
insert into worker_skill values(2, 103, 2, '门系统,轿厢,安全装置', '0', 0, 0, 0, 'admin', sysdate(), '', null);
insert into worker_skill values(3, 104, 3, '控制系统,曳引机,电气', '0', 0, 0, 0, 'admin', sysdate(), '', null);

-- ---------- 维保检查项模板 ----------
insert into maintain_item values(1, '半月保标准模板', 'half_month', '曳引机运行状态检查', 'traction', '运行平稳无异响，无异常振动', 1, '0', 'admin', sysdate(), '', null);
insert into maintain_item values(2, '半月保标准模板', 'half_month', '钢丝绳磨损与断丝检查', 'traction', '断丝数不超过标准要求，无锈蚀', 2, '0', 'admin', sysdate(), '', null);
insert into maintain_item values(3, '半月保标准模板', 'half_month', '层门与轿门开合检查', 'door_system', '开合顺畅，无卡阻，闭合到位', 3, '0', 'admin', sysdate(), '', null);
insert into maintain_item values(4, '半月保标准模板', 'half_month', '门锁电气触点检查', 'door_system', '触点接触良好，无烧蚀', 4, '0', 'admin', sysdate(), '', null);
insert into maintain_item values(5, '半月保标准模板', 'half_month', '限速器与安全钳检查', 'safety', '动作可靠，无卡阻', 5, '0', 'admin', sysdate(), '', null);
insert into maintain_item values(6, '半月保标准模板', 'half_month', '制动器动作检查', 'safety', '制动可靠，间隙符合要求', 6, '0', 'admin', sysdate(), '', null);
insert into maintain_item values(7, '半月保标准模板', 'half_month', '控制柜运行状态检查', 'control', '无异味，接触器动作正常', 7, '0', 'admin', sysdate(), '', null);
insert into maintain_item values(8, '半月保标准模板', 'half_month', '轿厢照明与通风检查', 'car', '照明正常，通风良好', 8, '0', 'admin', sysdate(), '', null);
insert into maintain_item values(9, '半月保标准模板', 'half_month', '报警装置与对讲检查', 'car', '报警按钮有效，对讲清晰', 9, '0', 'admin', sysdate(), '', null);
insert into maintain_item values(10, '半月保标准模板', 'half_month', '轿厢内应急照明检查', 'car', '断电后应急照明自动点亮', 10, '0', 'admin', sysdate(), '', null);

insert into maintain_item values(11, '季度检标准模板', 'quarter', '曳引机减速箱油质检查', 'traction', '油位正常，无乳化变质', 1, '0', 'admin', sysdate(), '', null);
insert into maintain_item values(12, '季度检标准模板', 'quarter', '钢丝绳张力均衡检查', 'traction', '各绳张力偏差不超过5%', 2, '0', 'admin', sysdate(), '', null);
insert into maintain_item values(13, '季度检标准模板', 'quarter', '导轨与导靴磨损检查', 'traction', '导靴磨损量在允许范围内', 3, '0', 'admin', sysdate(), '', null);
insert into maintain_item values(14, '季度检标准模板', 'quarter', '平层准确度检查', 'control', '平层误差不超过正负5毫米', 4, '0', 'admin', sysdate(), '', null);
insert into maintain_item values(15, '季度检标准模板', 'quarter', '超载装置动作检查', 'safety', '超载报警与保护动作可靠', 5, '0', 'admin', sysdate(), '', null);
insert into maintain_item values(16, '季度检标准模板', 'quarter', '接地保护与绝缘检查', 'control', '接地良好，绝缘电阻符合标准', 6, '0', 'admin', sysdate(), '', null);
insert into maintain_item values(17, '季度检标准模板', 'quarter', '井道照明与底坑检查', 'other', '照明正常，底坑无积水杂物', 7, '0', 'admin', sysdate(), '', null);
insert into maintain_item values(18, '季度检标准模板', 'quarter', '补偿链与随行电缆检查', 'other', '无破损，固定牢靠', 8, '0', 'admin', sysdate(), '', null);

-- ---------- 预警规则 ----------
insert into warning_rule values(1, '派单超时预警', 'order_timeout', 'assign', 30, 'minute', 'property', '0', 0, 'admin', sysdate(), '', null, '工单报修后30分钟未派单');
insert into warning_rule values(2, '接单超时预警', 'order_timeout', 'accept', 30, 'minute', 'worker,property', '0', 0, 'admin', sysdate(), '', null, '派单后30分钟未接单');
insert into warning_rule values(3, '到场超时预警', 'order_timeout', 'arrive', 120, 'minute', 'worker,property', '0', 0, 'admin', sysdate(), '', null, '接单后2小时未到场');
insert into warning_rule values(4, '维修超时预警', 'order_timeout', 'repair', 24, 'hour', 'worker,property', '0', 0, 'admin', sysdate(), '', null, '到场后24小时未完成维修');
insert into warning_rule values(5, '维保临期预警', 'maintain_due', 'due_soon', 3, 'day', 'property,worker', '0', 0, 'admin', sysdate(), '', null, '距离计划维保日期不足3天');
insert into warning_rule values(6, '维保超期预警', 'maintain_due', 'overdue', 0, 'day', 'property,worker', '0', 0, 'admin', sysdate(), '', null, '已超过计划维保日期未执行');

