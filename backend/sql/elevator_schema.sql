-- ============================================================
-- 老旧小区电梯故障报修与维保跟踪平台 - 业务表建表脚本（仅结构）
-- 适用库：elevator
-- 前置：先执行 ry_20260417.sql 与 quartz.sql 建立若依框架表
-- 数据请导入 elevator_data.sql
-- ============================================================
CREATE DATABASE IF NOT EXISTS `elevator` CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci;
USE `elevator`;

-- ----------------------------
-- 1、小区表
-- ----------------------------
drop table if exists community;
create table community (
  community_id      bigint(20)      not null auto_increment    comment '小区ID',
  community_name    varchar(100)    not null                   comment '小区名称',
  address           varchar(200)    default ''                 comment '小区地址',
  build_year        varchar(10)     default ''                 comment '建成时间',
  property_contact  varchar(20)     default ''                 comment '物业联系人',
  property_phone    varchar(20)     default ''                 comment '物业联系电话',
  status            char(1)         default '0'                comment '状态（0正常 1停用）',
  del_flag          char(1)         default '0'                comment '删除标志（0代表存在 2代表删除）',
  create_by         varchar(64)     default ''                 comment '创建者',
  create_time       datetime                                   comment '创建时间',
  update_by         varchar(64)     default ''                 comment '更新者',
  update_time       datetime                                   comment '更新时间',
  remark            varchar(500)    default null               comment '备注',
  primary key (community_id)
) engine=innodb auto_increment=1 comment = '小区信息表';

-- ----------------------------
-- 2、楼栋表
-- ----------------------------
drop table if exists building;
create table building (
  building_id       bigint(20)      not null auto_increment    comment '楼栋ID',
  community_id      bigint(20)      not null                   comment '所属小区ID',
  building_no       varchar(30)     not null                   comment '楼栋号',
  unit_no           varchar(30)     default ''                 comment '单元号',
  floor_count       int(4)          default 0                  comment '楼层数',
  status            char(1)         default '0'                comment '状态（0正常 1停用）',
  del_flag          char(1)         default '0'                comment '删除标志（0代表存在 2代表删除）',
  create_by         varchar(64)     default ''                 comment '创建者',
  create_time       datetime                                   comment '创建时间',
  update_by         varchar(64)     default ''                 comment '更新者',
  update_time       datetime                                   comment '更新时间',
  remark            varchar(500)    default null               comment '备注',
  primary key (building_id),
  key idx_building_community (community_id)
) engine=innodb auto_increment=1 comment = '楼栋信息表';

-- ----------------------------
-- 3、电梯表
-- ----------------------------
drop table if exists elevator;
create table elevator (
  elevator_id       bigint(20)      not null auto_increment    comment '电梯ID',
  elevator_code     varchar(50)     not null                   comment '电梯编号',
  brand             varchar(50)     default ''                 comment '品牌',
  model             varchar(50)     default ''                 comment '型号',
  building_id       bigint(20)      not null                   comment '所在楼栋ID',
  unit_no           varchar(10)     default ''                 comment '单元号',
  maintain_unit     varchar(100)    default ''                 comment '维保单位',
  install_date      date                                       comment '投用日期',
  service_years     int(4)          default 0                  comment '使用年限',
  cert_file_id      bigint(20)      default null               comment '年检报告附件ID',
  status            char(1)         default '0'                comment '状态（0正常运行 1停梯检修 2已报废）',
  del_flag          char(1)         default '0'                comment '删除标志（0代表存在 2代表删除）',
  create_by         varchar(64)     default ''                 comment '创建者',
  create_time       datetime                                   comment '创建时间',
  update_by         varchar(64)     default ''                 comment '更新者',
  update_time       datetime                                   comment '更新时间',
  remark            varchar(500)    default null               comment '备注',
  primary key (elevator_id),
  key idx_elevator_building (building_id)
) engine=innodb auto_increment=1 comment = '电梯信息表';

-- ----------------------------
-- 4、文件表
-- ----------------------------
drop table if exists sys_file;
create table sys_file (
  file_id           bigint(20)      not null auto_increment    comment '文件ID',
  file_name         varchar(200)    not null                   comment '原文件名',
  file_path         varchar(500)    not null                   comment '存储路径',
  file_url          varchar(500)    default ''                 comment '访问地址',
  file_type         varchar(20)     default ''                 comment '文件类型（image图片 video视频 doc文档 excel表格 pdf文档）',
  file_suffix       varchar(20)     default ''                 comment '文件后缀',
  file_size         bigint(20)      default 0                  comment '文件大小（字节）',
  biz_type          varchar(30)     default ''                 comment '业务类型（elevator_cert电梯证件 repair_evidence报修证据 inspection巡检结果 report导出报表）',
  biz_id            bigint(20)      default null               comment '关联业务ID',
  upload_by         varchar(64)     default ''                 comment '上传人',
  upload_time       datetime                                   comment '上传时间',
  del_flag          char(1)         default '0'                comment '删除标志（0代表存在 2代表删除）',
  primary key (file_id),
  key idx_file_biz (biz_type, biz_id)
) engine=innodb auto_increment=1 comment = '文件信息表';

-- ----------------------------
-- 5、报修工单表
-- ----------------------------
drop table if exists repair_order;
create table repair_order (
  order_id          bigint(20)      not null auto_increment    comment '工单ID',
  order_no          varchar(50)     not null                   comment '工单编号',
  user_id           bigint(20)      not null                   comment '报修人ID',
  elevator_id       bigint(20)      not null                   comment '故障电梯ID',
  fault_desc        varchar(500)    not null                   comment '故障现象描述',
  fault_type        varchar(30)     default ''                 comment '故障类型（abnormal_noise异响 stop停梯 trapped困人 door门故障 button按钮失灵 other其他）',
  fault_level       char(1)         default '1'                comment '故障等级（0紧急 1一般）',
  order_status      varchar(20)     default 'pending'          comment '工单状态（pending待处理 assigned已派单 accepted已接单 arrived已到场 repairing维修中 repaired已修复 confirmed已完成 rejected已驳回 appealed已申诉）',
  reporter_phone    varchar(20)     default ''                 comment '报修人联系电话',
  report_time       datetime                                   comment '报修时间',
  assign_time       datetime                                   comment '派单时间',
  accept_time       datetime                                   comment '接单时间',
  arrive_time       datetime                                   comment '到场时间',
  finish_time       datetime                                   comment '维修完成时间',
  confirm_time      datetime                                   comment '业主确认时间',
  assignee_id       bigint(20)      default null               comment '维修员ID',
  assigner_id       bigint(20)      default null               comment '派单人ID',
  reject_reason     varchar(500)    default ''                 comment '驳回原因',
  deadline_time     datetime                                   comment '处理时限',
  del_flag          char(1)         default '0'                comment '删除标志（0代表存在 2代表删除）',
  create_by         varchar(64)     default ''                 comment '创建者',
  create_time       datetime                                   comment '创建时间',
  update_by         varchar(64)     default ''                 comment '更新者',
  update_time       datetime                                   comment '更新时间',
  remark            varchar(500)    default null               comment '备注',
  primary key (order_id),
  unique key uk_order_no (order_no),
  key idx_order_elevator (elevator_id),
  key idx_order_user (user_id),
  key idx_order_assignee (assignee_id),
  key idx_order_status (order_status)
) engine=innodb auto_increment=1 comment = '报修工单表';

-- ----------------------------
-- 6、报修证据附件表
-- ----------------------------
drop table if exists repair_evidence;
create table repair_evidence (
  evidence_id       bigint(20)      not null auto_increment    comment '证据ID',
  order_id          bigint(20)      not null                   comment '关联工单ID',
  file_id           bigint(20)      not null                   comment '文件ID',
  evidence_type     varchar(20)     default 'image'            comment '证据类型（image图片 video视频）',
  upload_time       datetime                                   comment '上传时间',
  create_by         varchar(64)     default ''                 comment '创建者',
  del_flag          char(1)         default '0'                comment '删除标志（0代表存在 2代表删除）',
  primary key (evidence_id),
  key idx_evidence_order (order_id)
) engine=innodb auto_increment=1 comment = '报修证据附件表';

-- ----------------------------
-- 7、维修记录表
-- ----------------------------
drop table if exists repair_record;
create table repair_record (
  record_id         bigint(20)      not null auto_increment    comment '记录ID',
  order_id          bigint(20)      not null                   comment '关联工单ID',
  worker_id         bigint(20)      not null                   comment '维修员ID',
  arrive_time       datetime                                   comment '到场时间',
  arrive_location   varchar(200)    default ''                 comment '到场定位',
  investigate_note  varchar(1000)   default ''                 comment '排查记录',
  repair_desc       varchar(1000)   default ''                 comment '维修说明',
  fault_reason      varchar(30)     default ''                 comment '故障原因（normal_wear正常磨损 parts_damage配件损坏 improper_use使用不当 external外因 other其他）',
  replace_parts     varchar(500)    default ''                 comment '更换配件',
  finish_time       datetime                                   comment '完工时间',
  result_file_id    bigint(20)      default null               comment '完工凭证文件ID',
  create_by         varchar(64)     default ''                 comment '创建者',
  create_time       datetime                                   comment '创建时间',
  update_by         varchar(64)     default ''                 comment '更新者',
  update_time       datetime                                   comment '更新时间',
  primary key (record_id),
  key idx_record_order (order_id),
  key idx_record_worker (worker_id)
) engine=innodb auto_increment=1 comment = '维修记录表';

-- ----------------------------
-- 8、工单状态流转表
-- ----------------------------
drop table if exists order_status_log;
create table order_status_log (
  log_id            bigint(20)      not null auto_increment    comment '日志ID',
  order_id          bigint(20)      not null                   comment '关联工单ID',
  from_status       varchar(20)     default ''                 comment '原状态',
  to_status         varchar(20)     not null                   comment '新状态',
  operate_type      varchar(30)     default ''                 comment '操作类型（report报修 reject驳回 assign派单 accept接单 arrive到场 investigate排查 finish维修完成 confirm业主确认 appeal申诉 reassign重新指派 escalate升级）',
  operator_id       bigint(20)      default null               comment '操作人ID',
  operator_name     varchar(64)     default ''                 comment '操作人姓名',
  operator_role     varchar(30)     default ''                 comment '操作人角色',
  operate_time      datetime                                   comment '操作时间',
  remark            varchar(500)    default ''                 comment '备注',
  primary key (log_id),
  key idx_log_order (order_id)
) engine=innodb auto_increment=1 comment = '工单状态流转表';

-- ----------------------------
-- 9、维修员技能与区域表
-- ----------------------------
drop table if exists worker_skill;
create table worker_skill (
  skill_id          bigint(20)      not null auto_increment    comment '技能ID',
  worker_id         bigint(20)      not null                   comment '维修员ID',
  community_id      bigint(20)      default null               comment '负责小区ID',
  skill_tags        varchar(200)    default ''                 comment '技能标签（多个用逗号分隔，如 曳引机,门系统,控制系统）',
  work_status       char(1)         default '0'                comment '在岗状态（0在岗 1休息 2请假）',
  current_load      int(4)          default 0                  comment '当前在手工单数',
  total_finished    int(8)          default 0                  comment '累计完成工单数',
  avg_response      int(8)          default 0                  comment '平均响应时长（分钟）',
  create_by         varchar(64)     default ''                 comment '创建者',
  create_time       datetime                                   comment '创建时间',
  update_by         varchar(64)     default ''                 comment '更新者',
  update_time       datetime                                   comment '更新时间',
  primary key (skill_id),
  key idx_skill_worker (worker_id),
  key idx_skill_community (community_id)
) engine=innodb auto_increment=1 comment = '维修员技能与负责区域表';

-- ----------------------------
-- 10、维保检查项模板表
-- ----------------------------
drop table if exists maintain_item;
create table maintain_item (
  item_id           bigint(20)      not null auto_increment    comment '检查项ID',
  template_name     varchar(100)    not null                   comment '模板名称',
  maintain_type     varchar(30)     default ''                 comment '适用维保类型（half_month半月保 quarter季度检 half_year半年保 annual年检）',
  item_name         varchar(100)    not null                   comment '检查项名称',
  item_category     varchar(30)     default ''                 comment '检查项分类（traction曳引机 door_system门系统 safety安全装置 control控制系统 car轿厢 other其他）',
  check_standard    varchar(500)    default ''                 comment '检查标准',
  order_num         int(4)          default 0                  comment '排序号',
  status            char(1)         default '0'                comment '状态（0正常 1停用）',
  create_by         varchar(64)     default ''                 comment '创建者',
  create_time       datetime                                   comment '创建时间',
  update_by         varchar(64)     default ''                 comment '更新者',
  update_time       datetime                                   comment '更新时间',
  primary key (item_id),
  key idx_item_type (maintain_type)
) engine=innodb auto_increment=1 comment = '维保检查项模板表';

-- ----------------------------
-- 11、维保计划表
-- ----------------------------
drop table if exists maintain_plan;
create table maintain_plan (
  plan_id           bigint(20)      not null auto_increment    comment '计划ID',
  plan_name         varchar(100)    not null                   comment '计划名称',
  elevator_id       bigint(20)      not null                   comment '电梯ID',
  maintain_type     varchar(30)     not null                   comment '维保类型（half_month半月保 quarter季度检 half_year半年保 annual年检）',
  cycle_days        int(4)          not null                   comment '周期天数',
  template_name     varchar(100)    default ''                 comment '检查项模板名称',
  start_date        date                                       comment '生效日期',
  end_date          date                                       comment '失效日期',
  next_date         date                                       comment '下次维保日期',
  last_date         date                                       comment '上次维保日期',
  owner_id          bigint(20)      default null               comment '负责人ID',
  plan_status       char(1)         default '0'                comment '计划状态（0启用 1停用）',
  expect_count      int(8)          default 0                  comment '应执行次数',
  finish_count      int(8)          default 0                  comment '已执行次数',
  del_flag          char(1)         default '0'                comment '删除标志（0代表存在 2代表删除）',
  create_by         varchar(64)     default ''                 comment '创建者',
  create_time       datetime                                   comment '创建时间',
  update_by         varchar(64)     default ''                 comment '更新者',
  update_time       datetime                                   comment '更新时间',
  remark            varchar(500)    default null               comment '备注',
  primary key (plan_id),
  key idx_plan_elevator (elevator_id),
  key idx_plan_next_date (next_date)
) engine=innodb auto_increment=1 comment = '维保计划表';

-- ----------------------------
-- 12、巡检记录表
-- ----------------------------
drop table if exists inspection_record;
create table inspection_record (
  record_id         bigint(20)      not null auto_increment    comment '巡检记录ID',
  record_no         varchar(50)     not null                   comment '巡检工单编号',
  plan_id           bigint(20)      default null               comment '关联维保计划ID',
  elevator_id       bigint(20)      not null                   comment '电梯ID',
  maintain_type     varchar(30)     default ''                 comment '维保类型',
  plan_date         date                                       comment '计划维保日期',
  executor_id       bigint(20)      default null               comment '执行人ID',
  clock_in_time     datetime                                   comment '打卡时间',
  clock_in_location varchar(200)    default ''                 comment '打卡位置',
  execute_date      date                                       comment '实际执行日期',
  execute_result    varchar(20)     default 'pending'          comment '执行结果（pending待执行 normal正常 abnormal异常）',
  abnormal_desc     varchar(1000)   default ''                 comment '异常说明',
  normal_count      int(4)          default 0                  comment '正常项数',
  abnormal_count    int(4)          default 0                  comment '异常项数',
  na_count          int(4)          default 0                  comment '不适用项数',
  record_status     varchar(20)     default 'pending'          comment '记录状态（pending待执行 finished已完成 overdue已超期）',
  del_flag          char(1)         default '0'                comment '删除标志（0代表存在 2代表删除）',
  create_by         varchar(64)     default ''                 comment '创建者',
  create_time       datetime                                   comment '创建时间',
  update_by         varchar(64)     default ''                 comment '更新者',
  update_time       datetime                                   comment '更新时间',
  primary key (record_id),
  unique key uk_record_no (record_no),
  key idx_inspection_elevator (elevator_id),
  key idx_inspection_plan (plan_id),
  key idx_inspection_executor (executor_id)
) engine=innodb auto_increment=1 comment = '巡检记录表';

-- ----------------------------
-- 13、巡检检查项结果表
-- ----------------------------
drop table if exists inspection_item_result;
create table inspection_item_result (
  result_id         bigint(20)      not null auto_increment    comment '结果ID',
  record_id         bigint(20)      not null                   comment '巡检记录ID',
  item_id           bigint(20)      default null               comment '检查项ID',
  item_name         varchar(100)    not null                   comment '检查项名称',
  item_category     varchar(30)     default ''                 comment '检查项分类',
  check_result      varchar(20)     default 'normal'           comment '检查结果（normal正常 abnormal异常 na不适用）',
  abnormal_desc     varchar(500)    default ''                 comment '异常说明',
  file_id           bigint(20)      default null               comment '现场照片文件ID',
  order_num         int(4)          default 0                  comment '排序号',
  primary key (result_id),
  key idx_result_record (record_id)
) engine=innodb auto_increment=1 comment = '巡检检查项结果表';

-- ----------------------------
-- 14、维保档案表
-- ----------------------------
drop table if exists maintain_archive;
create table maintain_archive (
  archive_id        bigint(20)      not null auto_increment    comment '档案ID',
  elevator_id       bigint(20)      not null                   comment '电梯ID',
  archive_type      varchar(30)     not null                   comment '归档类型（inspection巡检 maintain维保 repair维修）',
  maintain_type     varchar(30)     default ''                 comment '维保类型',
  biz_id            bigint(20)      default null               comment '关联业务ID，指向巡检记录或维修记录',
  archive_time      datetime                                   comment '归档时间',
  summary           varchar(1000)   default ''                 comment '记录摘要',
  executor_name     varchar(64)     default ''                 comment '执行人姓名',
  execute_date      date                                       comment '执行日期',
  is_abnormal       char(1)         default '0'                comment '是否含异常（0正常 1异常）',
  create_time       datetime                                   comment '创建时间',
  primary key (archive_id),
  key idx_archive_elevator (elevator_id),
  key idx_archive_type (archive_type)
) engine=innodb auto_increment=1 comment = '维保档案表';

-- ----------------------------
-- 15、预警规则表
-- ----------------------------
drop table if exists warning_rule;
create table warning_rule (
  rule_id           bigint(20)      not null auto_increment    comment '规则ID',
  rule_name         varchar(100)    not null                   comment '规则名称',
  rule_type         varchar(30)     not null                   comment '规则类型（order_timeout工单超时 maintain_due维保临期）',
  biz_sub_type      varchar(30)     default ''                 comment '业务子类型（assign派单超时 accept接单超时 arrive到场超时 repair维修超时 confirm确认超时 due_soon临近维保 overdue已超维保）',
  threshold_value   int(8)          not null                   comment '阈值',
  threshold_unit    varchar(10)     default 'minute'           comment '阈值单位（minute分钟 hour小时 day天）',
  notify_roles      varchar(100)    default ''                 comment '通知对象角色（多个用逗号分隔，如 property,worker）',
  enabled           char(1)         default '0'                comment '是否启用（0启用 1停用）',
  repeat_interval   int(8)          default 0                  comment '重复推送间隔（分钟），0表示同周期不重复推送',
  create_by         varchar(64)     default ''                 comment '创建者',
  create_time       datetime                                   comment '创建时间',
  update_by         varchar(64)     default ''                 comment '更新者',
  update_time       datetime                                   comment '更新时间',
  remark            varchar(500)    default null               comment '备注',
  primary key (rule_id)
) engine=innodb auto_increment=1 comment = '预警规则表';

-- ----------------------------
-- 16、预警信息表
-- ----------------------------
drop table if exists warning_info;
create table warning_info (
  warning_id        bigint(20)      not null auto_increment    comment '预警ID',
  rule_id           bigint(20)      default null               comment '触发规则ID',
  warning_type      varchar(30)     not null                   comment '预警类型（order_timeout工单超时 maintain_due维保临期）',
  biz_sub_type      varchar(30)     default ''                 comment '业务子类型',
  biz_id            bigint(20)      default null               comment '关联业务ID，指向工单或维保计划',
  biz_no            varchar(50)     default ''                 comment '关联业务编号',
  warning_content   varchar(500)    not null                   comment '预警内容',
  elevator_id       bigint(20)      default null               comment '关联电梯ID',
  receiver_id       bigint(20)      default null               comment '接收人ID',
  receiver_role     varchar(30)     default ''                 comment '接收人角色',
  is_read           char(1)         default '0'                comment '是否已读（0未读 1已读）',
  read_time         datetime                                   comment '阅读时间',
  warning_time      datetime                                   comment '预警生成时间',
  create_time       datetime                                   comment '创建时间',
  primary key (warning_id),
  key idx_warning_receiver (receiver_id, is_read),
  key idx_warning_biz (biz_id)
) engine=innodb auto_increment=1 comment = '预警信息表';

-- ----------------------------
-- 17、电梯健康评分表
-- ----------------------------
drop table if exists elevator_health;
create table elevator_health (
  health_id         bigint(20)      not null auto_increment    comment '健康记录ID',
  elevator_id       bigint(20)      not null                   comment '电梯ID',
  stat_period       varchar(20)     not null                   comment '统计周期（如 2026-10 或 2026-Q4）',
  stat_start_date   date                                       comment '统计开始日期',
  stat_end_date     date                                       comment '统计结束日期',
  fault_count       int(8)          default 0                  comment '统计周期内故障次数',
  fault_rate        decimal(6,2)    default 0.00               comment '故障率指标得分',
  fault_score       decimal(5,2)    default 0.00               comment '故障率得分',
  maintain_done     int(8)          default 0                  comment '应执行维保次数',
  maintain_finish   int(8)          default 0                  comment '实际执行维保次数',
  maintain_rate     decimal(6,2)    default 0.00               comment '维保完成率（百分比）',
  maintain_score    decimal(5,2)    default 0.00               comment '维保完成率得分',
  inspect_total     int(8)          default 0                  comment '巡检检查项总数',
  inspect_normal    int(8)          default 0                  comment '巡检正常项数',
  inspect_rate      decimal(6,2)    default 0.00               comment '巡检合格率（百分比）',
  inspect_score     decimal(5,2)    default 0.00               comment '巡检合格率得分',
  health_score      decimal(5,2)    default 0.00               comment '健康评分',
  health_level      varchar(20)     default ''                 comment '健康等级（excellent优秀 good良好 fair一般 poor较差 danger危险）',
  calc_time         datetime                                   comment '计算时间',
  primary key (health_id),
  key idx_health_elevator (elevator_id),
  key idx_health_period (stat_period)
) engine=innodb auto_increment=1 comment = '电梯健康评分表';

-- ----------------------------
-- 18、通知消息表
-- ----------------------------
drop table if exists elevator_notice;
create table elevator_notice (
  notice_id         bigint(20)      not null auto_increment    comment '消息ID',
  notice_type       varchar(30)     not null                   comment '消息类型（assign派单 accept接单 progress进度 warning预警 appeal申诉）',
  title             varchar(200)    not null                   comment '消息标题',
  content           varchar(500)    default ''                 comment '消息内容',
  biz_id            bigint(20)      default null               comment '关联业务ID',
  receiver_id       bigint(20)      not null                   comment '接收人ID',
  is_read           char(1)         default '0'                comment '是否已读（0未读 1已读）',
  read_time         datetime                                   comment '阅读时间',
  create_time       datetime                                   comment '创建时间',
  primary key (notice_id),
  key idx_notice_receiver (receiver_id, is_read)
) engine=innodb auto_increment=1 comment = '通知消息表';

-- ----------------------------
-- 19、sys_user 扩展字段
-- 论文表3-1 用户信息表要求 community_id「所属小区ID」，
-- 用于数据权限按小区隔离。sys_user 由 ry_20260417.sql 建立，
-- 此处以 ALTER 方式补齐，不修改上游脚本
-- ----------------------------
SET @exist := (SELECT COUNT(*) FROM information_schema.COLUMNS
               WHERE TABLE_SCHEMA = DATABASE() AND TABLE_NAME = 'sys_user' AND COLUMN_NAME = 'community_id');
SET @sql := IF(@exist = 0,
  'ALTER TABLE sys_user ADD COLUMN community_id bigint(20) DEFAULT NULL COMMENT ''所属小区ID''',
  'SELECT ''sys_user.community_id 已存在'' AS msg');
PREPARE stmt FROM @sql;
EXECUTE stmt;
DEALLOCATE PREPARE stmt;

SET @idx := (SELECT COUNT(*) FROM information_schema.STATISTICS
             WHERE TABLE_SCHEMA = DATABASE() AND TABLE_NAME = 'sys_user' AND INDEX_NAME = 'uk_user_phonenumber');
SET @sql := IF(@idx = 0,
  'ALTER TABLE sys_user ADD UNIQUE KEY uk_user_phonenumber (phonenumber)',
  'SELECT ''uk_user_phonenumber 已存在'' AS msg');
PREPARE stmt FROM @sql;
EXECUTE stmt;
DEALLOCATE PREPARE stmt;
