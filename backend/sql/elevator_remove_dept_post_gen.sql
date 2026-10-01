-- ============================================================
-- 老旧小区电梯故障报修与维保跟踪平台 - 移除部门/岗位/代码生成器
-- 适用库：elevator
-- 用途：删除论文中没有出处的组织架构（部门、岗位）与开发期工具（代码生成器）
-- 依据：论文 3.2.2 节数据库表设计仅列 5 张表，用户表 8 个字段，
--       均无 dept_id、部门、岗位；代码生成器为开发工具，不属于交付系统
-- 说明：本脚本可重复执行，重复执行不会报错
-- ============================================================
USE `elevator`;

-- ----------------------------
-- 1、删除菜单与按钮权限
-- 部门管理、岗位管理、系统工具（表单构建/代码生成/系统接口）及其下按钮权限
-- 先清角色关联，再删菜单，避免留下孤儿授权记录
-- ----------------------------
DELETE FROM sys_role_menu WHERE menu_id IN (
  SELECT menu_id FROM (
    SELECT menu_id FROM sys_menu
    WHERE menu_id IN (3, 103, 104, 115, 116, 117)
       OR perms LIKE 'system:dept:%'
       OR perms LIKE 'system:post:%'
       OR perms LIKE 'tool:gen:%'
       OR perms LIKE 'tool:build:%'
       OR perms LIKE 'tool:swagger:%'
  ) t
);

DELETE FROM sys_menu
WHERE menu_id IN (3, 103, 104, 115, 116, 117)
   OR perms LIKE 'system:dept:%'
   OR perms LIKE 'system:post:%'
   OR perms LIKE 'tool:gen:%'
   OR perms LIKE 'tool:build:%'
   OR perms LIKE 'tool:swagger:%'
   OR (menu_type = 'M' AND menu_name = '系统工具');

-- 清理因菜单删除而产生的孤儿角色关联
DELETE FROM sys_role_menu WHERE menu_id NOT IN (SELECT menu_id FROM sys_menu);

-- ----------------------------
-- 2、删除岗位相关表
-- ----------------------------
DROP TABLE IF EXISTS sys_user_post;
DROP TABLE IF EXISTS sys_post;

-- ----------------------------
-- 3、删除部门相关表
-- ----------------------------
DROP TABLE IF EXISTS sys_role_dept;
DROP TABLE IF EXISTS sys_dept;

-- ----------------------------
-- 4、删除代码生成器表
-- ----------------------------
DROP TABLE IF EXISTS gen_table_column;
DROP TABLE IF EXISTS gen_table;

-- ----------------------------
-- 5、删除 sys_user.dept_id 字段
-- ----------------------------
SET @exist := (SELECT COUNT(*) FROM information_schema.COLUMNS
               WHERE TABLE_SCHEMA = 'elevator' AND TABLE_NAME = 'sys_user' AND COLUMN_NAME = 'dept_id');
SET @sql := IF(@exist > 0,
  'ALTER TABLE sys_user DROP COLUMN dept_id',
  'SELECT ''sys_user.dept_id 已不存在'' AS msg');
PREPARE stmt FROM @sql;
EXECUTE stmt;
DEALLOCATE PREPARE stmt;

-- ----------------------------
-- 6、删除 sys_role.dept_check_strictly 字段
-- 该字段仅服务于角色的部门数据权限勾选，部门功能移除后已无用途
-- ----------------------------
SET @exist := (SELECT COUNT(*) FROM information_schema.COLUMNS
               WHERE TABLE_SCHEMA = 'elevator' AND TABLE_NAME = 'sys_role' AND COLUMN_NAME = 'dept_check_strictly');
SET @sql := IF(@exist > 0,
  'ALTER TABLE sys_role DROP COLUMN dept_check_strictly',
  'SELECT ''sys_role.dept_check_strictly 已不存在'' AS msg');
PREPARE stmt FROM @sql;
EXECUTE stmt;
DEALLOCATE PREPARE stmt;

-- ----------------------------
-- 7、删除 sys_oper_log.dept_name 字段
-- 操作日志的部门名来源于登录用户的部门对象，部门功能移除后已无来源
-- ----------------------------
SET @exist := (SELECT COUNT(*) FROM information_schema.COLUMNS
               WHERE TABLE_SCHEMA = 'elevator' AND TABLE_NAME = 'sys_oper_log' AND COLUMN_NAME = 'dept_name');
SET @sql := IF(@exist > 0,
  'ALTER TABLE sys_oper_log DROP COLUMN dept_name',
  'SELECT ''sys_oper_log.dept_name 已不存在'' AS msg');
PREPARE stmt FROM @sql;
EXECUTE stmt;
DEALLOCATE PREPARE stmt;
