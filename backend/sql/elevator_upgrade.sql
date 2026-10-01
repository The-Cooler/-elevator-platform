-- ============================================================
-- 老旧小区电梯故障报修与维保跟踪平台 - 数据库升级脚本
-- 适用库：elevator
-- 用途：在已建库的基础上补齐论文要求的字段与定时任务注册
-- 说明：本脚本可重复执行，重复执行不会报错
-- ============================================================
USE `elevator`;

-- ----------------------------
-- 1、sys_user 增加所属小区字段
-- 论文表3-1 用户信息表要求 community_id「所属小区ID」字段，
-- 用于数据权限按小区隔离，替代原来把小区名称写进 remark 的做法
-- ----------------------------
SET @exist := (SELECT COUNT(*) FROM information_schema.COLUMNS
               WHERE TABLE_SCHEMA = 'elevator' AND TABLE_NAME = 'sys_user' AND COLUMN_NAME = 'community_id');
SET @sql := IF(@exist = 0,
  'ALTER TABLE sys_user ADD COLUMN community_id bigint(20) DEFAULT NULL COMMENT ''所属小区ID'' AFTER dept_id',
  'SELECT ''sys_user.community_id 已存在'' AS msg');
PREPARE stmt FROM @sql;
EXECUTE stmt;
DEALLOCATE PREPARE stmt;

-- 手机号唯一索引，供手机号登录使用
SET @idx := (SELECT COUNT(*) FROM information_schema.STATISTICS
             WHERE TABLE_SCHEMA = 'elevator' AND TABLE_NAME = 'sys_user' AND INDEX_NAME = 'uk_user_phonenumber');
SET @sql := IF(@idx = 0,
  'ALTER TABLE sys_user ADD UNIQUE KEY uk_user_phonenumber (phonenumber)',
  'SELECT ''uk_user_phonenumber 已存在'' AS msg');
PREPARE stmt FROM @sql;
EXECUTE stmt;
DEALLOCATE PREPARE stmt;

-- 已有用户的所属小区回填：按 remark 中记录的「所属小区：xxx」匹配
UPDATE sys_user u
  INNER JOIN community c ON u.remark LIKE CONCAT('%所属小区：', c.community_name, '%')
SET u.community_id = c.community_id
WHERE u.community_id IS NULL AND u.remark IS NOT NULL AND u.remark <> '';

-- ----------------------------
-- 2、注册三个业务定时任务
-- 论文要求：系统按周期自动生成巡检工单并派发、工单超时自动触发提醒、健康评分定时重算
-- 这三个任务类已实现，此前未注册到 sys_job，导致只能手工触发
-- cron 表达式与 Quartz 格式一致，6 位或 7 位均可被 RuoYi 识别
-- ----------------------------
DELETE FROM sys_job WHERE invoke_target IN
  ('inspectionGenerateTask.execute()', 'warningScanTask.execute()', 'healthScoreTask.execute()');

INSERT INTO sys_job (job_name, job_group, invoke_target, cron_expression, misfire_policy, concurrent, status, create_by, create_time, remark)
VALUES ('巡检工单自动生成', 'DEFAULT', 'inspectionGenerateTask.execute()', '0 0 1 * * ?', '3', '1', '0', 'admin', sysdate(), '每日 01:00 扫描到期维保计划，自动生成巡检工单并标记超期任务');

INSERT INTO sys_job (job_name, job_group, invoke_target, cron_expression, misfire_policy, concurrent, status, create_by, create_time, remark)
VALUES ('超期预警扫描', 'DEFAULT', 'warningScanTask.execute()', '0 0/30 * * * ?', '3', '1', '0', 'admin', sysdate(), '每 30 分钟扫描工单超时与维保临期，按启用规则生成预警并推送');

INSERT INTO sys_job (job_name, job_group, invoke_target, cron_expression, misfire_policy, concurrent, status, create_by, create_time, remark)
VALUES ('电梯健康评分重算', 'DEFAULT', 'healthScoreTask.execute()', '0 0 2 * * ?', '3', '1', '0', 'admin', sysdate(), '每日 02:00 按统计周期重算全部电梯的健康评分');

-- ----------------------------
-- 3、删除已废弃的资讯表
-- 资讯功能论文中没有出处，已从项目移除
-- ----------------------------
DROP TABLE IF EXISTS news;
