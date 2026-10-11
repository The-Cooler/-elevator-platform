-- MySQL dump 10.13  Distrib 8.0.39, for Win64 (x86_64)
--
-- Host: 127.0.0.1    Database: elevator
-- ------------------------------------------------------
-- Server version	8.0.39

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!50503 SET NAMES utf8mb4 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `building`
--

DROP TABLE IF EXISTS `building`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `building` (
  `building_id` bigint NOT NULL AUTO_INCREMENT COMMENT '楼栋ID',
  `community_id` bigint NOT NULL COMMENT '所属小区ID',
  `building_no` varchar(30) COLLATE utf8mb4_general_ci NOT NULL COMMENT '楼栋号',
  `unit_no` varchar(30) COLLATE utf8mb4_general_ci DEFAULT '' COMMENT '单元号',
  `floor_count` int DEFAULT '0' COMMENT '楼层数',
  `status` char(1) COLLATE utf8mb4_general_ci DEFAULT '0' COMMENT '状态（0正常 1停用）',
  `del_flag` char(1) COLLATE utf8mb4_general_ci DEFAULT '0' COMMENT '删除标志（0代表存在 2代表删除）',
  `create_by` varchar(64) COLLATE utf8mb4_general_ci DEFAULT '' COMMENT '创建者',
  `create_time` datetime DEFAULT NULL COMMENT '创建时间',
  `update_by` varchar(64) COLLATE utf8mb4_general_ci DEFAULT '' COMMENT '更新者',
  `update_time` datetime DEFAULT NULL COMMENT '更新时间',
  `remark` varchar(500) COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '备注',
  PRIMARY KEY (`building_id`),
  KEY `idx_building_community` (`community_id`)
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='楼栋信息表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `building`
--

LOCK TABLES `building` WRITE;
/*!40000 ALTER TABLE `building` DISABLE KEYS */;
INSERT INTO `building` VALUES (1,1,'1号楼','1单元',7,'0','0','admin','2026-10-02 14:30:24',NULL,NULL,NULL),(2,1,'1号楼','2单元',7,'0','0','admin','2026-10-02 14:30:24','',NULL,NULL),(3,1,'2号楼','1单元',6,'0','0','admin','2026-10-02 14:30:24','',NULL,NULL),(4,2,'3号楼','1单元',6,'0','0','admin','2026-10-02 14:30:24','',NULL,NULL),(5,2,'4号楼','1单元',8,'0','0','admin','2026-10-02 14:30:24','',NULL,NULL),(6,3,'A座','1单元',11,'0','0','admin','2026-10-02 14:30:24','',NULL,NULL);
/*!40000 ALTER TABLE `building` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `community`
--

DROP TABLE IF EXISTS `community`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `community` (
  `community_id` bigint NOT NULL AUTO_INCREMENT COMMENT '小区ID',
  `community_name` varchar(100) COLLATE utf8mb4_general_ci NOT NULL COMMENT '小区名称',
  `address` varchar(200) COLLATE utf8mb4_general_ci DEFAULT '' COMMENT '小区地址',
  `build_year` varchar(10) COLLATE utf8mb4_general_ci DEFAULT '' COMMENT '建成时间',
  `property_contact` varchar(20) COLLATE utf8mb4_general_ci DEFAULT '' COMMENT '物业联系人',
  `property_phone` varchar(20) COLLATE utf8mb4_general_ci DEFAULT '' COMMENT '物业联系电话',
  `status` char(1) COLLATE utf8mb4_general_ci DEFAULT '0' COMMENT '状态（0正常 1停用）',
  `del_flag` char(1) COLLATE utf8mb4_general_ci DEFAULT '0' COMMENT '删除标志（0代表存在 2代表删除）',
  `create_by` varchar(64) COLLATE utf8mb4_general_ci DEFAULT '' COMMENT '创建者',
  `create_time` datetime DEFAULT NULL COMMENT '创建时间',
  `update_by` varchar(64) COLLATE utf8mb4_general_ci DEFAULT '' COMMENT '更新者',
  `update_time` datetime DEFAULT NULL COMMENT '更新时间',
  `remark` varchar(500) COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '备注',
  PRIMARY KEY (`community_id`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='小区信息表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `community`
--

LOCK TABLES `community` WRITE;
/*!40000 ALTER TABLE `community` DISABLE KEYS */;
INSERT INTO `community` VALUES (1,'阳光家园小区','哈尔滨市南岗区学府路128号','2003','张建国','0451-86001122','0','0','admin','2026-10-02 14:30:24','',NULL,'典型老旧小区，无电梯加装于2021年'),(2,'和平里小区','哈尔滨市道里区和平路56号','1998','李秀兰','0451-86003344','0','0','admin','2026-10-02 14:30:24','',NULL,'老旧小区，老年居民占比高'),(3,'铁路新村小区','哈尔滨市香坊区红旗大街211号','2001','王海涛','0451-86005566','0','0','admin','2026-10-02 14:30:24','',NULL,'原铁路系统职工住宅');
/*!40000 ALTER TABLE `community` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `elevator`
--

DROP TABLE IF EXISTS `elevator`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `elevator` (
  `elevator_id` bigint NOT NULL AUTO_INCREMENT COMMENT '电梯ID',
  `elevator_code` varchar(50) COLLATE utf8mb4_general_ci NOT NULL COMMENT '电梯编号',
  `brand` varchar(50) COLLATE utf8mb4_general_ci DEFAULT '' COMMENT '品牌',
  `model` varchar(50) COLLATE utf8mb4_general_ci DEFAULT '' COMMENT '型号',
  `building_id` bigint NOT NULL COMMENT '所在楼栋ID',
  `unit_no` varchar(10) COLLATE utf8mb4_general_ci DEFAULT '' COMMENT '单元号',
  `maintain_unit` varchar(100) COLLATE utf8mb4_general_ci DEFAULT '' COMMENT '维保单位',
  `install_date` date DEFAULT NULL COMMENT '投用日期',
  `service_years` int DEFAULT '0' COMMENT '使用年限',
  `cert_file_id` bigint DEFAULT NULL COMMENT '年检报告附件ID',
  `status` char(1) COLLATE utf8mb4_general_ci DEFAULT '0' COMMENT '状态（0正常运行 1停梯检修 2已报废）',
  `del_flag` char(1) COLLATE utf8mb4_general_ci DEFAULT '0' COMMENT '删除标志（0代表存在 2代表删除）',
  `create_by` varchar(64) COLLATE utf8mb4_general_ci DEFAULT '' COMMENT '创建者',
  `create_time` datetime DEFAULT NULL COMMENT '创建时间',
  `update_by` varchar(64) COLLATE utf8mb4_general_ci DEFAULT '' COMMENT '更新者',
  `update_time` datetime DEFAULT NULL COMMENT '更新时间',
  `remark` varchar(500) COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '备注',
  PRIMARY KEY (`elevator_id`),
  KEY `idx_elevator_building` (`building_id`)
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='电梯信息表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `elevator`
--

LOCK TABLES `elevator` WRITE;
/*!40000 ALTER TABLE `elevator` DISABLE KEYS */;
INSERT INTO `elevator` VALUES (1,'DT-A-001','日立','HGE-1000',1,'1单元','黑龙江安捷电梯维保有限公司','2010-06-01',15,NULL,'0','0','admin','2026-10-02 14:30:24',NULL,NULL,'运行平稳，钢丝绳有轻微磨损'),(2,'DT-A-002','日立','HGE-1000',2,'2单元','黑龙江安捷电梯维保有限公司','2010-06-01',15,NULL,'0','0','admin','2026-10-02 14:30:24','',NULL,'门系统偶有异响'),(3,'DT-B-001','三菱','LEHY-III',3,'1单元','哈尔滨华信机电设备有限公司','2012-09-15',13,NULL,'0','0','admin','2026-10-02 14:30:24','',NULL,''),(4,'DT-C-001','通力','KONE-3000',4,'1单元','哈尔滨华信机电设备有限公司','2008-03-20',18,NULL,'1','0','admin','2026-10-02 14:30:24','',NULL,'使用年限长，已停梯待大修'),(5,'DT-C-002','奥的斯','OTIS-3200',5,'1单元','黑龙江安捷电梯维保有限公司','2015-11-08',10,NULL,'0','0','admin','2026-10-02 14:30:24','',NULL,''),(6,'DT-D-001','迅达','Schindler-3300',6,'1单元','黑龙江广日电梯工程有限公司','2006-05-12',20,NULL,'0','0','admin','2026-10-02 14:30:24','',NULL,'老旧电梯，故障率偏高，重点监控');
/*!40000 ALTER TABLE `elevator` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `elevator_health`
--

DROP TABLE IF EXISTS `elevator_health`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `elevator_health` (
  `health_id` bigint NOT NULL AUTO_INCREMENT COMMENT '健康记录ID',
  `elevator_id` bigint NOT NULL COMMENT '电梯ID',
  `stat_period` varchar(20) COLLATE utf8mb4_general_ci NOT NULL COMMENT '统计周期（如 2026-10 或 2026-Q4）',
  `stat_start_date` date DEFAULT NULL COMMENT '统计开始日期',
  `stat_end_date` date DEFAULT NULL COMMENT '统计结束日期',
  `fault_count` int DEFAULT '0' COMMENT '统计周期内故障次数',
  `fault_rate` decimal(6,2) DEFAULT '0.00' COMMENT '故障率指标得分',
  `fault_score` decimal(5,2) DEFAULT '0.00' COMMENT '故障率得分',
  `maintain_done` int DEFAULT '0' COMMENT '应执行维保次数',
  `maintain_finish` int DEFAULT '0' COMMENT '实际执行维保次数',
  `maintain_rate` decimal(6,2) DEFAULT '0.00' COMMENT '维保完成率（百分比）',
  `maintain_score` decimal(5,2) DEFAULT '0.00' COMMENT '维保完成率得分',
  `inspect_total` int DEFAULT '0' COMMENT '巡检检查项总数',
  `inspect_normal` int DEFAULT '0' COMMENT '巡检正常项数',
  `inspect_rate` decimal(6,2) DEFAULT '0.00' COMMENT '巡检合格率（百分比）',
  `inspect_score` decimal(5,2) DEFAULT '0.00' COMMENT '巡检合格率得分',
  `maintain_applicable` tinyint(1) DEFAULT '1' COMMENT '维保完成率是否参与评分（0否 1是，统计周期内无维保计划时为0）',
  `inspect_applicable` tinyint(1) DEFAULT '1' COMMENT '巡检合格率是否参与评分（0否 1是，统计周期内无已完成巡检记录时为0）',
  `health_score` decimal(5,2) DEFAULT '0.00' COMMENT '健康评分',
  `health_level` varchar(20) COLLATE utf8mb4_general_ci DEFAULT '' COMMENT '健康等级（excellent优秀 good良好 fair一般 poor较差 danger危险）',
  `calc_time` datetime DEFAULT NULL COMMENT '计算时间',
  PRIMARY KEY (`health_id`),
  KEY `idx_health_elevator` (`elevator_id`),
  KEY `idx_health_period` (`stat_period`)
) ENGINE=InnoDB AUTO_INCREMENT=13 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='电梯健康评分表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `elevator_health`
--

LOCK TABLES `elevator_health` WRITE;
/*!40000 ALTER TABLE `elevator_health` DISABLE KEYS */;
INSERT INTO `elevator_health` VALUES (7,1,'2026-10','2026-07-04','2026-10-02',0,0.00,100.00,8,8,100.00,100.00,50,48,96.00,96.00,1,1,98.80,'excellent','2026-10-11 14:08:40'),(8,2,'2026-10','2026-07-04','2026-10-02',3,3.00,70.00,8,8,100.00,100.00,50,45,90.00,90.00,1,1,85.00,'good','2026-10-11 14:08:40'),(9,3,'2026-10','2026-07-04','2026-10-02',1,1.00,90.00,9,8,88.89,88.89,40,38,95.00,95.00,1,1,91.17,'excellent','2026-10-11 14:08:40'),(10,4,'2026-10','2026-07-04','2026-10-02',4,4.00,50.00,6,2,33.33,33.33,10,7,70.00,70.00,1,1,51.00,'danger','2026-10-11 14:08:40'),(11,5,'2026-10','2026-07-04','2026-10-02',0,0.00,100.00,9,9,100.00,100.00,68,66,97.06,97.06,1,1,99.12,'excellent','2026-10-11 14:08:40'),(12,6,'2026-10','2026-07-04','2026-10-02',5,5.00,35.00,12,6,50.00,50.00,50,40,80.00,80.00,1,1,53.00,'danger','2026-10-11 14:08:40');
/*!40000 ALTER TABLE `elevator_health` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `elevator_notice`
--

DROP TABLE IF EXISTS `elevator_notice`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `elevator_notice` (
  `notice_id` bigint NOT NULL AUTO_INCREMENT COMMENT '消息ID',
  `notice_type` varchar(30) COLLATE utf8mb4_general_ci NOT NULL COMMENT '消息类型（assign派单 accept接单 progress进度 warning预警 appeal申诉）',
  `title` varchar(200) COLLATE utf8mb4_general_ci NOT NULL COMMENT '消息标题',
  `content` varchar(500) COLLATE utf8mb4_general_ci DEFAULT '' COMMENT '消息内容',
  `biz_id` bigint DEFAULT NULL COMMENT '关联业务ID',
  `biz_type` varchar(20) COLLATE utf8mb4_general_ci DEFAULT '' COMMENT '关联业务类型（order报修工单 inspection巡检记录 plan维保计划 空无关联）',
  `receiver_id` bigint NOT NULL COMMENT '接收人ID',
  `is_read` char(1) COLLATE utf8mb4_general_ci DEFAULT '0' COMMENT '是否已读（0未读 1已读）',
  `read_time` datetime DEFAULT NULL COMMENT '阅读时间',
  `create_time` datetime DEFAULT NULL COMMENT '创建时间',
  PRIMARY KEY (`notice_id`),
  KEY `idx_notice_receiver` (`receiver_id`,`is_read`)
) ENGINE=InnoDB AUTO_INCREMENT=255 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='通知消息表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `elevator_notice`
--

LOCK TABLES `elevator_notice` WRITE;
/*!40000 ALTER TABLE `elevator_notice` DISABLE KEYS */;
INSERT INTO `elevator_notice` VALUES (1,'progress','维保超期预警','电梯【DT-C-001】半月保标准模板的维保计划【3号楼1单元半月保】已超期 78 天',4,'plan',100,'1','2026-10-02 18:51:08','2026-10-02 15:00:00'),(2,'progress','维保超期预警','电梯【DT-C-001】半月保标准模板的维保计划【3号楼1单元半月保】已超期 78 天',4,'plan',101,'1','2026-10-11 14:04:26','2026-10-02 15:00:00'),(3,'progress','维保超期预警','电梯【DT-C-001】半月保标准模板的维保计划【3号楼1单元半月保】已超期 78 天',4,'plan',103,'0',NULL,'2026-10-02 15:00:00'),(4,'progress','维保超期预警','电梯【DT-C-001】半月保标准模板的维保计划【3号楼1单元半月保】已超期 78 天',4,'plan',104,'0',NULL,'2026-10-02 15:00:00'),(5,'progress','维保超期预警','电梯【DT-A-001】季度检标准模板的维保计划【1号楼1单元季度检】已超期 1 天',7,'plan',100,'1','2026-10-02 18:51:08','2026-10-02 15:00:00'),(6,'progress','维保超期预警','电梯【DT-A-001】季度检标准模板的维保计划【1号楼1单元季度检】已超期 1 天',7,'plan',101,'1','2026-10-11 14:04:26','2026-10-02 15:00:00'),(7,'progress','维保超期预警','电梯【DT-A-001】季度检标准模板的维保计划【1号楼1单元季度检】已超期 1 天',7,'plan',103,'0',NULL,'2026-10-02 15:00:00'),(8,'progress','维保超期预警','电梯【DT-A-001】季度检标准模板的维保计划【1号楼1单元季度检】已超期 1 天',7,'plan',104,'0',NULL,'2026-10-02 15:00:00'),(9,'progress','维保超期预警','电梯【DT-A-002】季度检标准模板的维保计划【1号楼2单元季度检】已超期 1 天',8,'plan',100,'1','2026-10-02 18:51:08','2026-10-02 15:00:00'),(10,'progress','维保超期预警','电梯【DT-A-002】季度检标准模板的维保计划【1号楼2单元季度检】已超期 1 天',8,'plan',101,'1','2026-10-11 14:04:26','2026-10-02 15:00:00'),(11,'progress','维保超期预警','电梯【DT-A-002】季度检标准模板的维保计划【1号楼2单元季度检】已超期 1 天',8,'plan',103,'0',NULL,'2026-10-02 15:00:00'),(12,'progress','维保超期预警','电梯【DT-A-002】季度检标准模板的维保计划【1号楼2单元季度检】已超期 1 天',8,'plan',104,'0',NULL,'2026-10-02 15:00:00'),(13,'progress','维保超期预警','电梯【DT-B-001】季度检标准模板的维保计划【2号楼1单元季度检】已超期 1 天',9,'plan',100,'1','2026-10-02 18:51:08','2026-10-02 15:00:00'),(14,'progress','维保超期预警','电梯【DT-B-001】季度检标准模板的维保计划【2号楼1单元季度检】已超期 1 天',9,'plan',101,'1','2026-10-11 14:04:26','2026-10-02 15:00:00'),(15,'progress','维保超期预警','电梯【DT-B-001】季度检标准模板的维保计划【2号楼1单元季度检】已超期 1 天',9,'plan',103,'0',NULL,'2026-10-02 15:00:00'),(16,'progress','维保超期预警','电梯【DT-B-001】季度检标准模板的维保计划【2号楼1单元季度检】已超期 1 天',9,'plan',104,'0',NULL,'2026-10-02 15:00:00'),(17,'progress','维保超期预警','电梯【DT-C-002】季度检标准模板的维保计划【4号楼1单元季度检】已超期 1 天',10,'plan',100,'1','2026-10-02 18:51:08','2026-10-02 15:00:00'),(18,'progress','维保超期预警','电梯【DT-C-002】季度检标准模板的维保计划【4号楼1单元季度检】已超期 1 天',10,'plan',101,'1','2026-10-11 14:04:26','2026-10-02 15:00:00'),(19,'progress','维保超期预警','电梯【DT-C-002】季度检标准模板的维保计划【4号楼1单元季度检】已超期 1 天',10,'plan',103,'0',NULL,'2026-10-02 15:00:00'),(20,'progress','维保超期预警','电梯【DT-C-002】季度检标准模板的维保计划【4号楼1单元季度检】已超期 1 天',10,'plan',104,'0',NULL,'2026-10-02 15:00:00'),(21,'progress','新的故障报修','电梯【DT-A-001】报修：端到端测试：电梯运行中有明显异响',13,'order',100,'1','2026-10-02 18:51:08','2026-10-02 16:04:56'),(22,'progress','新的工单派给您','工单【BX20261002160456】已派给您，请及时接单',13,'order',101,'1','2026-10-11 14:04:26','2026-10-02 16:04:56'),(23,'progress','维修员已接单','您的报修单【BX20261002160456】维修员已接单，预计 30 分钟到场',13,'order',102,'1','2026-10-11 14:03:59','2026-10-02 16:04:57'),(24,'progress','维修员已到场','您的报修单【BX20261002160456】维修员已到达现场',13,'order',102,'1','2026-10-11 14:03:59','2026-10-02 16:04:57'),(25,'progress','维修已完成，请确认','您的报修单【BX20261002160456】维修已完成：更换导靴并加注润滑油，试运行异响消除，请确认故障是否消除',13,'order',102,'1','2026-10-11 14:03:59','2026-10-02 16:04:57'),(26,'progress','工单已确认完成','工单【BX20261002160456】业主已确认完成',13,'order',101,'1','2026-10-11 14:04:26','2026-10-02 16:04:57'),(27,'progress','业主申诉待处理','工单【BX20260922110505】业主提交申诉，请处理',5,'order',100,'1','2026-10-02 18:51:08','2026-10-02 16:05:16'),(29,'progress','新的故障报修','电梯【DT-A-001】报修：重复报修拦截测试',14,'order',100,'1','2026-10-02 18:51:08','2026-10-02 16:07:58'),(42,'progress','新的故障报修','电梯【DT-A-002】报修：验证证据库页面显示',16,'order',100,'0',NULL,'2026-10-02 19:59:32'),(43,'progress','报修被驳回','您的报修单【BX20261002195932】被驳回：故障描述不完整，请补充具体楼层',16,'order',102,'1','2026-10-11 14:03:59','2026-10-02 20:10:10'),(44,'progress','驳回工单已重新提交','工单【BX20261002195932】业主已补充信息并重新提交，请重新审核',16,'order',100,'0',NULL,'2026-10-02 20:10:10'),(45,'progress','报修被驳回','您的报修单【BX20261002195932】被驳回：故障描述不完整，请补充具体楼层',16,'order',102,'1','2026-10-11 14:03:59','2026-10-02 20:12:17'),(46,'progress','驳回工单已重新提交','工单【BX20261002195932】业主已补充信息并重新提交，请重新审核',16,'order',100,'1','2026-10-02 21:06:17','2026-10-02 20:12:17'),(57,'progress','新的故障报修','电梯【DT-C-001】报修：电梯坏了，呜呜呜',18,'order',100,'0',NULL,'2026-10-02 21:08:49'),(58,'progress','新的工单派给您','工单【BX20261002210849】已派给您，请及时接单。物业备注：电梯困人，请优先处理',18,'order',101,'1','2026-10-11 14:04:26','2026-10-02 21:38:13'),(59,'progress','维修员已接单','您的报修单【BX20261002210849】维修员已接单，预计 20 分钟到场',18,'order',102,'1','2026-10-11 14:03:59','2026-10-02 21:38:13'),(60,'progress','维修员已到场','您的报修单【BX20261002210849】维修员已到达现场',18,'order',102,'1','2026-10-11 14:03:59','2026-10-02 21:38:13'),(61,'progress','维修已完成，请确认','您的报修单【BX20261002210849】维修已完成：验证用：更换门锁触点，恢复正常，请确认故障是否消除',18,'order',102,'1','2026-10-11 14:03:59','2026-10-02 21:38:14'),(73,'progress','工单已确认完成','工单【BX20261002210849】业主已确认完成',18,'order',101,'1','2026-10-11 14:04:26','2026-10-11 13:38:25'),(81,'progress','维保超期预警','电梯【DT-D-001】半月保标准模板的维保计划【A座1单元半月保】已超期 2 天',6,'plan',100,'0',NULL,'2026-10-11 13:38:37'),(82,'progress','维保超期预警','电梯【DT-D-001】半月保标准模板的维保计划【A座1单元半月保】已超期 2 天',6,'plan',101,'1','2026-10-11 14:04:26','2026-10-11 13:38:37'),(83,'progress','维保超期预警','电梯【DT-D-001】半月保标准模板的维保计划【A座1单元半月保】已超期 2 天',6,'plan',103,'0',NULL,'2026-10-11 13:38:37'),(84,'progress','维保超期预警','电梯【DT-D-001】半月保标准模板的维保计划【A座1单元半月保】已超期 2 天',6,'plan',104,'0',NULL,'2026-10-11 13:38:37'),(148,'progress','新的故障报修','电梯【DT-C-002】报修：闭环验证-电梯运行中剧烈抖动并伴随异响',31,'order',100,'0',NULL,'2026-10-11 14:00:02'),(149,'progress','报修被驳回','您的报修单【BX20261011140002001】被驳回：故障描述不完整，请补充具体楼层与发生时间',31,'order',102,'1','2026-10-11 14:03:59','2026-10-11 14:00:03'),(150,'progress','驳回工单已重新提交','工单【BX20261011140002001】业主已补充信息并重新提交，请重新审核',31,'order',100,'0',NULL,'2026-10-11 14:00:03'),(151,'progress','新的工单派给您','工单【BX20261011140002001】已派给您，请及时接单。物业备注：闭环验证派单：请优先处理',31,'order',101,'1','2026-10-11 14:04:26','2026-10-11 14:00:04'),(152,'progress','维修员已接单','您的报修单【BX20261011140002001】维修员已接单，预计 30 分钟到场',31,'order',102,'1','2026-10-11 14:03:59','2026-10-11 14:00:05'),(153,'progress','维修员已到场','您的报修单【BX20261011140002001】维修员已到达现场',31,'order',102,'1','2026-10-11 14:03:59','2026-10-11 14:00:05'),(154,'progress','维修已完成，请确认','您的报修单【BX20261011140002001】维修已完成：更换曳引机导向轮轴承并加注润滑脂，试运行 20 分钟无异响，请确认故障是否消除',31,'order',102,'1','2026-10-11 14:03:59','2026-10-11 14:00:07'),(155,'progress','工单已确认完成','工单【BX20261011140002001】业主已确认完成',31,'order',101,'1','2026-10-11 14:04:26','2026-10-11 14:00:07'),(156,'progress','新的故障报修','电梯【DT-A-001】报修：异常分支验证-电梯故障 A-申诉返工',32,'order',100,'0',NULL,'2026-10-11 14:00:41'),(157,'progress','新的工单派给您','工单【BX20261011140041001】已派给您，请及时接单。物业备注：申诉返工验证',32,'order',101,'1','2026-10-11 14:04:26','2026-10-11 14:00:41'),(158,'progress','维修员已接单','您的报修单【BX20261011140041001】维修员已接单，预计 20 分钟到场',32,'order',102,'1','2026-10-11 14:03:59','2026-10-11 14:00:41'),(159,'progress','维修员已到场','您的报修单【BX20261011140041001】维修员已到达现场',32,'order',102,'1','2026-10-11 14:03:59','2026-10-11 14:00:41'),(160,'progress','维修已完成，请确认','您的报修单【BX20261011140041001】维修已完成：清理门锁触点，请确认故障是否消除',32,'order',102,'1','2026-10-11 14:03:59','2026-10-11 14:00:41'),(161,'progress','业主申诉待处理','工单【BX20261011140041001】业主提交申诉，请处理',32,'order',100,'0',NULL,'2026-10-11 14:00:42'),(162,'progress','维修已完成，请确认','您的报修单【BX20261011140041001】维修已完成：试探直接完工，请确认故障是否消除',32,'order',102,'1','2026-10-11 14:03:59','2026-10-11 14:00:42'),(163,'progress','工单已确认完成','工单【BX20261011140041001】业主已确认完成',32,'order',101,'1','2026-10-11 14:04:26','2026-10-11 14:00:42'),(164,'progress','新的故障报修','电梯【DT-C-002】报修：异常分支验证-电梯故障 B-驳回重提',33,'order',100,'0',NULL,'2026-10-11 14:00:43'),(165,'progress','报修被驳回','您的报修单【BX20261011140043001】被驳回：请补充故障发生的具体楼层',33,'order',102,'1','2026-10-11 14:03:59','2026-10-11 14:00:43'),(166,'progress','新的工单派给您','工单【BX20261011140043001】已派给您，请及时接单。物业备注：驳回态直接派单试探',33,'order',101,'1','2026-10-11 14:04:26','2026-10-11 14:00:43'),(167,'progress','新的故障报修','电梯【DT-B-001】报修：异常分支验证-电梯故障 C-拒单',34,'order',100,'0',NULL,'2026-10-11 14:00:43'),(168,'progress','新的工单派给您','工单【BX20261011140043002】已派给您，请及时接单。物业备注：拒单链路验证',34,'order',101,'1','2026-10-11 14:04:26','2026-10-11 14:00:43'),(169,'progress','工单被拒单','工单【BX20261011140043002】被维修员拒绝，请重新指派',34,'order',100,'0',NULL,'2026-10-11 14:00:44'),(170,'progress','新的工单派给您','工单【BX20261011140043002】已派给您，请及时接单。物业备注：改派后重新派单',34,'order',101,'1','2026-10-11 14:04:26','2026-10-11 14:00:44'),(187,'progress','新的巡检任务','电梯【DT-C-002】的季度检标准模板任务已生成，请按时执行',103,'inspection',103,'0',NULL,'2026-10-11 14:01:40'),(205,'progress','新的故障报修','电梯【DT-A-002】报修：预警扫描验证-电梯门异响',35,'order',100,'0',NULL,'2026-10-11 14:02:29'),(206,'progress','派单超时预警','工单【BX20261011140229001】派单超时，电梯【DT-A-002】，报修人【业主张阿姨】',35,'order',100,'0',NULL,'2026-10-11 14:02:30'),(212,'progress','维修员已接单','您的报修单【BX20261011140043001】维修员已接单，预计 30 分钟到场',33,'order',102,'1','2026-10-11 14:03:59','2026-10-11 14:03:22'),(213,'progress','维修员已到场','您的报修单【BX20261011140043001】维修员已到达现场',33,'order',102,'1','2026-10-11 14:03:59','2026-10-11 14:03:22'),(222,'progress','新的巡检任务','电梯【DT-B-001】的季度检标准模板任务已生成，请按时执行',133,'inspection',101,'1','2026-10-11 14:04:26','2026-10-11 14:03:44'),(231,'progress','新的故障报修','电梯【DT-A-001】报修：同秒编号测试第 1 次',38,'order',100,'0',NULL,'2026-10-11 14:08:15'),(236,'progress','新的巡检任务','电梯【DT-C-001】的半月保标准模板任务已生成，请按时执行',139,'inspection',103,'0',NULL,'2026-10-11 14:08:17'),(237,'progress','新的巡检任务','电梯【DT-A-001】的季度检标准模板任务已生成，请按时执行',140,'inspection',101,'1','2026-10-11 14:11:12','2026-10-11 14:08:17'),(238,'progress','新的巡检任务','电梯【DT-A-002】的季度检标准模板任务已生成，请按时执行',141,'inspection',101,'1','2026-10-11 14:11:12','2026-10-11 14:08:17'),(239,'progress','新的巡检任务','电梯【DT-D-001】的半月保标准模板任务已生成，请按时执行',142,'inspection',104,'0',NULL,'2026-10-11 14:08:17'),(240,'progress','报修被驳回','您的报修单【BX20261011140229001】被驳回：同秒编号测试前收尾（测试数据）',35,'order',102,'0',NULL,'2026-10-11 14:08:37'),(241,'progress','工单被拒单','工单【BX20261011140043002】被维修员拒绝，请重新指派',34,'order',100,'0',NULL,'2026-10-11 14:08:37'),(242,'progress','报修被驳回','您的报修单【BX20261011140043002】被驳回：同秒编号测试前收尾（测试数据）',34,'order',102,'0',NULL,'2026-10-11 14:08:37'),(243,'progress','新的故障报修','电梯【DT-A-002】报修：同秒编号测试 A（电梯2）',39,'order',100,'0',NULL,'2026-10-11 14:08:38'),(244,'progress','新的故障报修','电梯【DT-B-001】报修：同秒编号测试 B（电梯3）',40,'order',100,'0',NULL,'2026-10-11 14:08:38'),(245,'progress','新的故障报修','电梯【DT-C-001】报修：复验闭环-电梯门关闭后无法启动',41,'order',100,'0',NULL,'2026-10-11 14:09:00'),(246,'progress','报修被驳回','您的报修单【BX20261011140900001】被驳回：请补充故障具体表现',41,'order',102,'0',NULL,'2026-10-11 14:09:01'),(247,'progress','驳回工单已重新提交','工单【BX20261011140900001】业主已补充信息并重新提交，请重新审核',41,'order',100,'0',NULL,'2026-10-11 14:09:01'),(248,'progress','新的工单派给您','工单【BX20261011140900001】已派给您，请及时接单。物业备注：复验闭环派单',41,'order',101,'1','2026-10-11 14:11:12','2026-10-11 14:09:01'),(249,'progress','维修员已接单','您的报修单【BX20261011140900001】维修员已接单，预计 15 分钟到场',41,'order',102,'0',NULL,'2026-10-11 14:09:01'),(250,'progress','维修员已到场','您的报修单【BX20261011140900001】维修员已到达现场',41,'order',102,'0',NULL,'2026-10-11 14:09:01'),(251,'progress','维修已完成，请确认','您的报修单【BX20261011140900001】维修已完成：复位门机控制器参数并更换门锁触点，开关门测试 30 次正常，请确认故障是否消除',41,'order',102,'0',NULL,'2026-10-11 14:09:01'),(252,'progress','工单已确认完成','工单【BX20261011140900001】业主已确认完成',41,'order',101,'1','2026-10-11 14:11:12','2026-10-11 14:09:01');
/*!40000 ALTER TABLE `elevator_notice` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `inspection_item_result`
--

DROP TABLE IF EXISTS `inspection_item_result`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `inspection_item_result` (
  `result_id` bigint NOT NULL AUTO_INCREMENT COMMENT '结果ID',
  `record_id` bigint NOT NULL COMMENT '巡检记录ID',
  `item_id` bigint DEFAULT NULL COMMENT '检查项ID',
  `item_name` varchar(100) COLLATE utf8mb4_general_ci NOT NULL COMMENT '检查项名称',
  `item_category` varchar(30) COLLATE utf8mb4_general_ci DEFAULT '' COMMENT '检查项分类',
  `check_result` varchar(20) COLLATE utf8mb4_general_ci DEFAULT 'normal' COMMENT '检查结果（normal正常 abnormal异常 na不适用）',
  `abnormal_desc` varchar(500) COLLATE utf8mb4_general_ci DEFAULT '' COMMENT '异常说明',
  `file_id` bigint DEFAULT NULL COMMENT '现场照片文件ID',
  `order_num` int DEFAULT '0' COMMENT '排序号',
  PRIMARY KEY (`result_id`),
  KEY `idx_result_record` (`record_id`)
) ENGINE=InnoDB AUTO_INCREMENT=17 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='巡检检查项结果表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `inspection_item_result`
--

LOCK TABLES `inspection_item_result` WRITE;
/*!40000 ALTER TABLE `inspection_item_result` DISABLE KEYS */;
/*!40000 ALTER TABLE `inspection_item_result` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `inspection_record`
--

DROP TABLE IF EXISTS `inspection_record`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `inspection_record` (
  `record_id` bigint NOT NULL AUTO_INCREMENT COMMENT '巡检记录ID',
  `record_no` varchar(50) COLLATE utf8mb4_general_ci NOT NULL COMMENT '巡检工单编号',
  `plan_id` bigint DEFAULT NULL COMMENT '关联维保计划ID',
  `elevator_id` bigint NOT NULL COMMENT '电梯ID',
  `maintain_type` varchar(30) COLLATE utf8mb4_general_ci DEFAULT '' COMMENT '维保类型',
  `plan_date` date DEFAULT NULL COMMENT '计划维保日期',
  `executor_id` bigint DEFAULT NULL COMMENT '执行人ID',
  `clock_in_time` datetime DEFAULT NULL COMMENT '打卡时间',
  `clock_in_location` varchar(200) COLLATE utf8mb4_general_ci DEFAULT '' COMMENT '打卡位置',
  `execute_date` date DEFAULT NULL COMMENT '实际执行日期',
  `execute_result` varchar(20) COLLATE utf8mb4_general_ci DEFAULT 'pending' COMMENT '执行结果（pending待执行 normal正常 abnormal异常）',
  `abnormal_desc` varchar(1000) COLLATE utf8mb4_general_ci DEFAULT '' COMMENT '异常说明',
  `normal_count` int DEFAULT '0' COMMENT '正常项数',
  `abnormal_count` int DEFAULT '0' COMMENT '异常项数',
  `na_count` int DEFAULT '0' COMMENT '不适用项数',
  `record_status` varchar(20) COLLATE utf8mb4_general_ci DEFAULT 'pending' COMMENT '记录状态（pending待执行 finished已完成 overdue已超期）',
  `del_flag` char(1) COLLATE utf8mb4_general_ci DEFAULT '0' COMMENT '删除标志（0代表存在 2代表删除）',
  `create_by` varchar(64) COLLATE utf8mb4_general_ci DEFAULT '' COMMENT '创建者',
  `create_time` datetime DEFAULT NULL COMMENT '创建时间',
  `update_by` varchar(64) COLLATE utf8mb4_general_ci DEFAULT '' COMMENT '更新者',
  `update_time` datetime DEFAULT NULL COMMENT '更新时间',
  PRIMARY KEY (`record_id`),
  UNIQUE KEY `uk_record_no` (`record_no`),
  KEY `idx_inspection_elevator` (`elevator_id`),
  KEY `idx_inspection_plan` (`plan_id`),
  KEY `idx_inspection_executor` (`executor_id`)
) ENGINE=InnoDB AUTO_INCREMENT=143 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='巡检记录表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `inspection_record`
--

LOCK TABLES `inspection_record` WRITE;
/*!40000 ALTER TABLE `inspection_record` DISABLE KEYS */;
INSERT INTO `inspection_record` VALUES (1,'XJ20260716100001',1,1,'half_month','2026-07-16',101,'2026-07-16 09:12:00','阳光家园小区1号楼1单元电梯机房','2026-07-16','normal','',10,0,0,'finished','0','admin','2026-10-02 14:30:24','',NULL),(2,'XJ20260801090002',1,1,'half_month','2026-08-01',101,'2026-08-01 09:05:00','阳光家园小区1号楼1单元电梯机房','2026-08-01','normal','',10,0,0,'finished','0','admin','2026-10-02 14:30:24','',NULL),(3,'XJ20260816091003',1,1,'half_month','2026-08-16',101,'2026-08-16 09:20:00','阳光家园小区1号楼1单元电梯机房','2026-08-16','abnormal','钢丝绳有轻微磨损，未达换绳标准，已记录观察',9,1,0,'finished','0','admin','2026-10-02 14:30:24','',NULL),(4,'XJ20260901090504',1,1,'half_month','2026-09-01',101,'2026-09-01 09:02:00','阳光家园小区1号楼1单元电梯机房','2026-09-01','normal','',10,0,0,'finished','0','admin','2026-10-02 14:30:24','',NULL),(5,'XJ20260916091505',1,1,'quarter','2026-09-16',101,'2026-09-16 09:35:00','阳光家园小区1号楼1单元电梯机房','2026-09-16','abnormal','轿厢内应急照明电池电量偏低，已更换',9,1,0,'finished','0','admin','2026-10-02 14:30:24','',NULL),(6,'XJ20260716103006',2,2,'half_month','2026-07-16',101,'2026-07-16 10:30:00','阳光家园小区1号楼2单元电梯机房','2026-07-16','abnormal','层门开合有卡阻，已调整门机',9,1,0,'finished','0','admin','2026-10-02 14:30:24','',NULL),(7,'XJ20260801102007',2,2,'half_month','2026-08-01',101,'2026-08-01 10:22:00','阳光家园小区1号楼2单元电梯机房','2026-08-01','abnormal','门锁电气触点有轻微烧蚀，已打磨处理',9,1,0,'finished','0','admin','2026-10-02 14:30:24','',NULL),(8,'XJ20260816104508',2,2,'half_month','2026-08-16',101,'2026-08-16 10:45:00','阳光家园小区1号楼2单元电梯机房','2026-08-16','abnormal','层门闭合到位但仍有异响',9,1,0,'finished','0','admin','2026-10-02 14:30:24','',NULL),(9,'XJ20260901103209',2,2,'half_month','2026-09-01',101,'2026-09-01 10:32:00','阳光家园小区1号楼2单元电梯机房','2026-09-01','abnormal','门机皮带磨损，建议下次维保更换',9,1,0,'finished','0','admin','2026-10-02 14:30:24','',NULL),(10,'XJ20260916110010',2,2,'quarter','2026-09-16',101,'2026-09-16 11:00:00','阳光家园小区1号楼2单元电梯机房','2026-09-16','abnormal','平层准确度偏差接近上限，已重新校准',9,1,0,'finished','0','admin','2026-10-02 14:30:24','',NULL),(11,'XJ20260720140011',3,3,'half_month','2026-07-20',103,'2026-07-20 14:10:00','阳光家园小区2号楼1单元电梯机房','2026-07-20','normal','',10,0,0,'finished','0','admin','2026-10-02 14:30:24','',NULL),(12,'XJ20260805141012',3,3,'half_month','2026-08-05',103,'2026-08-05 14:12:00','阳光家园小区2号楼1单元电梯机房','2026-08-05','normal','',10,0,0,'finished','0','admin','2026-10-02 14:30:24','',NULL),(13,'XJ20260820142013',3,3,'half_month','2026-08-20',103,'2026-08-20 14:20:00','阳光家园小区2号楼1单元电梯机房','2026-08-20','abnormal','控制柜接触器动作有轻微异响',9,1,0,'finished','0','admin','2026-10-02 14:30:24','',NULL),(14,'XJ20260920143014',3,3,'quarter','2026-09-20',103,'2026-09-20 14:30:00','阳光家园小区2号楼1单元电梯机房','2026-09-20','abnormal','底坑有少量积水，已清理并疏通排水',9,1,0,'finished','0','admin','2026-10-02 14:30:24','',NULL),(15,'XJ20260710150015',4,4,'half_month','2026-07-10',103,'2026-07-10 15:05:00','和平里小区3号楼1单元电梯机房','2026-07-10','abnormal','曳引机减速箱油质乳化，钢丝绳锈蚀，已上报大修',7,3,0,'finished','0','admin','2026-10-02 14:30:24','',NULL),(16,'XJ20260725151016',4,4,'half_month','2026-07-25',103,'2026-07-25 15:10:00','和平里小区3号楼1单元电梯机房','2026-07-25','abnormal','制动器间隙超标，限速器动作不灵活，已停梯',7,3,0,'finished','0','admin','2026-10-02 14:30:24','',NULL),(17,'XJ20260715160017',5,5,'half_month','2026-07-15',104,'2026-07-15 16:00:00','和平里小区4号楼1单元电梯机房','2026-07-15','normal','',10,0,0,'finished','0','admin','2026-10-02 14:30:24','',NULL),(18,'XJ20260730160518',5,5,'half_month','2026-07-30',104,'2026-07-30 16:05:00','和平里小区4号楼1单元电梯机房','2026-07-30','normal','',10,0,0,'finished','0','admin','2026-10-02 14:30:24','',NULL),(19,'XJ20260814161019',5,5,'half_month','2026-08-14',104,'2026-08-14 16:10:00','和平里小区4号楼1单元电梯机房','2026-08-14','normal','',10,0,0,'finished','0','admin','2026-10-02 14:30:24','',NULL),(20,'XJ20260829161520',5,5,'half_month','2026-08-29',104,'2026-08-29 16:15:00','和平里小区4号楼1单元电梯机房','2026-08-29','normal','',10,0,0,'finished','0','admin','2026-10-02 14:30:24','',NULL),(21,'XJ20260913162021',5,5,'half_month','2026-09-13',104,'2026-09-13 16:20:00','和平里小区4号楼1单元电梯机房','2026-09-13','normal','',10,0,0,'finished','0','admin','2026-10-02 14:30:24','',NULL),(22,'XJ20260928162522',5,5,'quarter','2026-09-28',104,'2026-09-28 16:25:00','和平里小区4号楼1单元电梯机房','2026-09-28','normal','',10,0,0,'finished','0','admin','2026-10-02 14:30:24','',NULL),(23,'XJ20260708170023',6,6,'half_month','2026-07-08',104,'2026-07-08 17:00:00','铁路新村小区A座1单元电梯机房','2026-07-08','abnormal','曳引机运行振动偏大，钢丝绳断丝 3 根',8,2,0,'finished','0','admin','2026-10-02 14:30:24','',NULL),(24,'XJ20260722170524',6,6,'half_month','2026-07-22',104,'2026-07-22 17:05:00','铁路新村小区A座1单元电梯机房','2026-07-22','abnormal','制动器动作迟缓，平层偏差超标',8,2,0,'finished','0','admin','2026-10-02 14:30:24','',NULL),(25,'XJ20260805171025',6,6,'half_month','2026-08-05',104,'2026-08-05 17:10:00','铁路新村小区A座1单元电梯机房','2026-08-05','abnormal','层门卡阻，门锁触点烧蚀，已临时处理',8,2,0,'finished','0','admin','2026-10-02 14:30:24','',NULL),(26,'XJ20260819171526',6,6,'half_month','2026-08-19',104,'2026-08-19 17:15:00','铁路新村小区A座1单元电梯机房','2026-08-19','abnormal','控制柜接触器频繁动作，触点磨损明显',8,2,0,'finished','0','admin','2026-10-02 14:30:24','',NULL),(27,'XJ20260902172027',6,6,'half_month','2026-09-02',104,'2026-09-02 17:20:00','铁路新村小区A座1单元电梯机房','2026-09-02','abnormal','导轨润滑不足，导靴磨损量接近上限',8,2,0,'finished','0','admin','2026-10-02 14:30:24','',NULL),(28,'XJ20260916172528',6,6,'quarter','2026-09-16',104,'2026-09-16 17:25:00','铁路新村小区A座1单元电梯机房','2026-09-16','abnormal','补偿链磨损，随行电缆保护层破损',8,2,0,'finished','0','admin','2026-10-02 14:30:24','',NULL),(103,'XJ20261011140140005',10,5,'quarter','2026-10-01',103,NULL,'',NULL,'pending','',0,0,0,'pending','0','system','2026-10-11 14:01:40','',NULL),(133,'XJ20261011140344004',9,3,'quarter','2026-10-01',101,NULL,NULL,NULL,'pending',NULL,0,0,0,'pending','0','system','2026-10-11 14:03:44',NULL,NULL),(139,'XJ20261011140817005',4,4,'half_month','2026-07-16',103,NULL,'',NULL,'pending','',0,0,0,'pending','0','system','2026-10-11 14:08:17','',NULL),(140,'XJ20261011140817006',7,1,'quarter','2026-10-01',101,NULL,'',NULL,'pending','',0,0,0,'pending','0','system','2026-10-11 14:08:17','',NULL),(141,'XJ20261011140817007',8,2,'quarter','2026-10-01',101,NULL,'',NULL,'pending','',0,0,0,'pending','0','system','2026-10-11 14:08:17','',NULL),(142,'XJ20261011140817008',6,6,'half_month','2026-10-09',104,NULL,'',NULL,'pending','',0,0,0,'pending','0','system','2026-10-11 14:08:17','',NULL);
/*!40000 ALTER TABLE `inspection_record` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `maintain_archive`
--

DROP TABLE IF EXISTS `maintain_archive`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `maintain_archive` (
  `archive_id` bigint NOT NULL AUTO_INCREMENT COMMENT '档案ID',
  `elevator_id` bigint NOT NULL COMMENT '电梯ID',
  `archive_type` varchar(30) COLLATE utf8mb4_general_ci NOT NULL COMMENT '归档类型（inspection巡检 maintain维保 repair维修）',
  `maintain_type` varchar(30) COLLATE utf8mb4_general_ci DEFAULT '' COMMENT '维保类型',
  `biz_id` bigint DEFAULT NULL COMMENT '关联业务ID，指向巡检记录或维修记录',
  `archive_time` datetime DEFAULT NULL COMMENT '归档时间',
  `summary` varchar(1000) COLLATE utf8mb4_general_ci DEFAULT '' COMMENT '记录摘要',
  `executor_name` varchar(64) COLLATE utf8mb4_general_ci DEFAULT '' COMMENT '执行人姓名',
  `execute_date` date DEFAULT NULL COMMENT '执行日期',
  `is_abnormal` char(1) COLLATE utf8mb4_general_ci DEFAULT '0' COMMENT '是否含异常（0正常 1异常）',
  `create_time` datetime DEFAULT NULL COMMENT '创建时间',
  PRIMARY KEY (`archive_id`),
  KEY `idx_archive_elevator` (`elevator_id`),
  KEY `idx_archive_type` (`archive_type`)
) ENGINE=InnoDB AUTO_INCREMENT=14 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='维保档案表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `maintain_archive`
--

LOCK TABLES `maintain_archive` WRITE;
/*!40000 ALTER TABLE `maintain_archive` DISABLE KEYS */;
INSERT INTO `maintain_archive` VALUES (1,1,'repair','',13,'2026-10-02 16:04:57','报修工单BX20261002160456，电梯【DT-A-001】故障现象：端到端测试：电梯运行中有明显异响。处理说明：更换导靴并加注润滑油，试运行异响消除。更换配件：导靴 2 个','维修员王师傅','2026-10-02','0','2026-10-02 16:04:57'),(2,3,'repair','',17,'2026-10-02 20:34:56','报修工单BX20261002203455，电梯【DT-B-001】故障现象：最终验收测试：电梯运行异响。处理说明：更换导靴。更换配件：导靴2个','维修员王师傅','2026-10-02','0','2026-10-02 20:34:56'),(3,4,'repair','',18,'2026-10-02 21:38:14','报修工单BX20261002210849，电梯【DT-C-001】故障现象：电梯坏了，呜呜呜。处理说明：验证用：更换门锁触点，恢复正常。更换配件：门锁触点 2 套','维修员王师傅','2026-10-02','0','2026-10-02 21:38:14'),(4,5,'repair','',23,'2026-10-11 13:40:33','报修工单BX20261011134033，电梯【DT-C-002】故障现象：端到端验收：3层运行中轿厢有明显异响。处理说明：端到端验收：更换导靴并润滑，异响消除。更换配件：导靴 4 只','维修员王师傅','2026-10-11','0','2026-10-11 13:40:33'),(5,5,'repair','',25,'2026-10-11 13:40:52','报修工单BX20261011134052，电梯【DT-C-002】故障现象：端到端验收：3层运行中轿厢有明显异响。处理说明：端到端验收：更换导靴并润滑，异响消除。更换配件：导靴 4 只','维修员王师傅','2026-10-11','0','2026-10-11 13:40:52'),(8,5,'repair','',31,'2026-10-11 14:00:07','报修工单BX20261011140002001，电梯【DT-C-002】故障现象：补充：3号楼1单元，10月11日14时，电梯上行至5层时剧烈抖动并伴随金属摩擦异响。处理说明：更换曳引机导向轮轴承并加注润滑脂，试运行 20 分钟无异响。更换配件：导向轮轴承 型号6206 数量2','维修员王师傅','2026-10-11','0','2026-10-11 14:00:07'),(9,1,'repair','',32,'2026-10-11 14:00:41','报修工单BX20261011140041001，电梯【DT-A-001】故障现象：异常分支验证-电梯故障 A-申诉返工。处理说明：清理门锁触点。更换配件：无','维修员王师傅','2026-10-11','0','2026-10-11 14:00:41'),(10,5,'inspection','quarter',97,'2026-10-11 14:01:41','巡检工单XJ20261011140139005，检查项共8项，正常6项，异常1项，不适用1项。异常说明：曳引机减速箱油质检查：层门滑块磨损，开关门有轻微卡滞','维修员王师傅','2026-10-11','1','2026-10-11 14:01:41'),(11,3,'inspection','quarter',133,'2026-10-11 14:05:02','巡检工单XJ20261011140344004，检查项共8项，正常8项，异常0项','维修员王师傅','2026-10-11','0','2026-10-11 14:05:02'),(12,1,'repair','',36,'2026-10-11 14:06:52','报修工单BX20261011140634001，电梯【DT-A-001】故障现象：验收员核查-电梯运行异响。处理说明：更换门机皮带，已恢复正常','维修员王师傅','2026-10-11','0','2026-10-11 14:06:52'),(13,4,'repair','',41,'2026-10-11 14:09:01','报修工单BX20261011140900001，电梯【DT-C-001】故障现象：补充：电梯门关闭后反复自动开启，轿厢停在1层无法启动。处理说明：复位门机控制器参数并更换门锁触点，开关门测试 30 次正常。更换配件：门锁触点 2 只','维修员王师傅','2026-10-11','0','2026-10-11 14:09:01');
/*!40000 ALTER TABLE `maintain_archive` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `maintain_item`
--

DROP TABLE IF EXISTS `maintain_item`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `maintain_item` (
  `item_id` bigint NOT NULL AUTO_INCREMENT COMMENT '检查项ID',
  `template_name` varchar(100) COLLATE utf8mb4_general_ci NOT NULL COMMENT '模板名称',
  `maintain_type` varchar(30) COLLATE utf8mb4_general_ci DEFAULT '' COMMENT '适用维保类型（half_month半月保 quarter季度检 half_year半年保 annual年检）',
  `item_name` varchar(100) COLLATE utf8mb4_general_ci NOT NULL COMMENT '检查项名称',
  `item_category` varchar(30) COLLATE utf8mb4_general_ci DEFAULT '' COMMENT '检查项分类（traction曳引机 door_system门系统 safety安全装置 control控制系统 car轿厢 other其他）',
  `check_standard` varchar(500) COLLATE utf8mb4_general_ci DEFAULT '' COMMENT '检查标准',
  `order_num` int DEFAULT '0' COMMENT '排序号',
  `status` char(1) COLLATE utf8mb4_general_ci DEFAULT '0' COMMENT '状态（0正常 1停用）',
  `create_by` varchar(64) COLLATE utf8mb4_general_ci DEFAULT '' COMMENT '创建者',
  `create_time` datetime DEFAULT NULL COMMENT '创建时间',
  `update_by` varchar(64) COLLATE utf8mb4_general_ci DEFAULT '' COMMENT '更新者',
  `update_time` datetime DEFAULT NULL COMMENT '更新时间',
  PRIMARY KEY (`item_id`),
  KEY `idx_item_type` (`maintain_type`)
) ENGINE=InnoDB AUTO_INCREMENT=20 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='维保检查项模板表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `maintain_item`
--

LOCK TABLES `maintain_item` WRITE;
/*!40000 ALTER TABLE `maintain_item` DISABLE KEYS */;
INSERT INTO `maintain_item` VALUES (1,'半月保标准模板','half_month','曳引机运行状态检查','traction','运行平稳无异响，无异常振动',1,'0','admin','2026-10-02 14:30:24','',NULL),(2,'半月保标准模板','half_month','钢丝绳磨损与断丝检查','traction','断丝数不超过标准要求，无锈蚀',2,'0','admin','2026-10-02 14:30:24','',NULL),(3,'半月保标准模板','half_month','层门与轿门开合检查','door_system','开合顺畅，无卡阻，闭合到位',3,'0','admin','2026-10-02 14:30:24','',NULL),(4,'半月保标准模板','half_month','门锁电气触点检查','door_system','触点接触良好，无烧蚀',4,'0','admin','2026-10-02 14:30:24','',NULL),(5,'半月保标准模板','half_month','限速器与安全钳检查','safety','动作可靠，无卡阻',5,'0','admin','2026-10-02 14:30:24','',NULL),(6,'半月保标准模板','half_month','制动器动作检查','safety','制动可靠，间隙符合要求',6,'0','admin','2026-10-02 14:30:24','',NULL),(7,'半月保标准模板','half_month','控制柜运行状态检查','control','无异味，接触器动作正常',7,'0','admin','2026-10-02 14:30:24','',NULL),(8,'半月保标准模板','half_month','轿厢照明与通风检查','car','照明正常，通风良好',8,'0','admin','2026-10-02 14:30:24','',NULL),(9,'半月保标准模板','half_month','报警装置与对讲检查','car','报警按钮有效，对讲清晰',9,'0','admin','2026-10-02 14:30:24','',NULL),(10,'半月保标准模板','half_month','轿厢内应急照明检查','car','断电后应急照明自动点亮',10,'0','admin','2026-10-02 14:30:24','',NULL),(11,'季度检标准模板','quarter','曳引机减速箱油质检查','traction','油位正常，无乳化变质',1,'0','admin','2026-10-02 14:30:24','',NULL),(12,'季度检标准模板','quarter','钢丝绳张力均衡检查','traction','各绳张力偏差不超过5%',2,'0','admin','2026-10-02 14:30:24','',NULL),(13,'季度检标准模板','quarter','导轨与导靴磨损检查','traction','导靴磨损量在允许范围内',3,'0','admin','2026-10-02 14:30:24','',NULL),(14,'季度检标准模板','quarter','平层准确度检查','control','平层误差不超过正负5毫米',4,'0','admin','2026-10-02 14:30:24','',NULL),(15,'季度检标准模板','quarter','超载装置动作检查','safety','超载报警与保护动作可靠',5,'0','admin','2026-10-02 14:30:24','',NULL),(16,'季度检标准模板','quarter','接地保护与绝缘检查','control','接地良好，绝缘电阻符合标准',6,'0','admin','2026-10-02 14:30:24','',NULL),(17,'季度检标准模板','quarter','井道照明与底坑检查','other','照明正常，底坑无积水杂物',7,'0','admin','2026-10-02 14:30:24','',NULL),(18,'季度检标准模板','quarter','补偿链与随行电缆检查','other','无破损，固定牢靠',8,'0','admin','2026-10-02 14:30:24','',NULL);
/*!40000 ALTER TABLE `maintain_item` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `maintain_plan`
--

DROP TABLE IF EXISTS `maintain_plan`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `maintain_plan` (
  `plan_id` bigint NOT NULL AUTO_INCREMENT COMMENT '计划ID',
  `plan_name` varchar(100) COLLATE utf8mb4_general_ci NOT NULL COMMENT '计划名称',
  `elevator_id` bigint NOT NULL COMMENT '电梯ID',
  `maintain_type` varchar(30) COLLATE utf8mb4_general_ci NOT NULL COMMENT '维保类型（half_month半月保 quarter季度检 half_year半年保 annual年检）',
  `cycle_days` int NOT NULL COMMENT '周期天数',
  `template_name` varchar(100) COLLATE utf8mb4_general_ci DEFAULT '' COMMENT '检查项模板名称',
  `start_date` date DEFAULT NULL COMMENT '生效日期',
  `end_date` date DEFAULT NULL COMMENT '失效日期',
  `next_date` date DEFAULT NULL COMMENT '下次维保日期',
  `last_date` date DEFAULT NULL COMMENT '上次维保日期',
  `owner_id` bigint DEFAULT NULL COMMENT '负责人ID',
  `plan_status` char(1) COLLATE utf8mb4_general_ci DEFAULT '0' COMMENT '计划状态（0启用 1停用）',
  `expect_count` int DEFAULT '0' COMMENT '应执行次数',
  `finish_count` int DEFAULT '0' COMMENT '已执行次数',
  `del_flag` char(1) COLLATE utf8mb4_general_ci DEFAULT '0' COMMENT '删除标志（0代表存在 2代表删除）',
  `create_by` varchar(64) COLLATE utf8mb4_general_ci DEFAULT '' COMMENT '创建者',
  `create_time` datetime DEFAULT NULL COMMENT '创建时间',
  `update_by` varchar(64) COLLATE utf8mb4_general_ci DEFAULT '' COMMENT '更新者',
  `update_time` datetime DEFAULT NULL COMMENT '更新时间',
  `remark` varchar(500) COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '备注',
  PRIMARY KEY (`plan_id`),
  KEY `idx_plan_elevator` (`elevator_id`),
  KEY `idx_plan_next_date` (`next_date`)
) ENGINE=InnoDB AUTO_INCREMENT=12 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='维保计划表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `maintain_plan`
--

LOCK TABLES `maintain_plan` WRITE;
/*!40000 ALTER TABLE `maintain_plan` DISABLE KEYS */;
INSERT INTO `maintain_plan` VALUES (1,'1号楼1单元半月保',1,'half_month',15,'半月保标准模板','2026-07-01','2027-06-30','2026-10-16','2026-10-01',101,'0',6,6,'0','admin','2026-10-02 14:30:24',NULL,NULL,'业主反馈运行平稳，按周期正常维保'),(2,'1号楼2单元半月保',2,'half_month',15,'半月保标准模板','2026-07-01','2027-06-30','2026-10-16','2026-10-01',101,'0',6,6,'0','admin','2026-10-02 14:30:24','',NULL,'门系统有异响，维保时重点关注'),(3,'2号楼1单元半月保',3,'half_month',15,'半月保标准模板','2026-07-01','2027-06-30','2026-10-16','2026-09-16',101,'0',6,5,'0','admin','2026-10-02 14:30:24','',NULL,'有一次因配件到货延迟未按期执行，已补做'),(4,'3号楼1单元半月保',4,'half_month',15,'半月保标准模板','2026-07-01','2027-06-30','2026-07-16','2026-08-01',103,'0',6,2,'0','admin','2026-10-02 14:30:24','',NULL,'已停梯待大修，维保暂停，待大修完成恢复'),(5,'4号楼1单元半月保',5,'half_month',15,'半月保标准模板','2026-07-01','2027-06-30','2026-10-16','2026-10-01',103,'0',6,6,'0','admin','2026-10-02 14:30:24','',NULL,'投用年限较短，运行状况良好'),(6,'A座1单元半月保',6,'half_month',7,'半月保标准模板','2026-07-01','2027-06-30','2026-10-09','2026-09-11',104,'0',12,6,'0','admin','2026-10-02 14:30:24','',NULL,'老旧电梯故障率高，已缩短维保周期，但仍多次漏保'),(7,'1号楼1单元季度检',1,'quarter',90,'季度检标准模板','2026-07-01','2027-06-30','2026-10-01','2026-07-01',101,'0',2,2,'0','admin','2026-10-02 14:30:24','',NULL,'季度检正常执行'),(8,'1号楼2单元季度检',2,'quarter',90,'季度检标准模板','2026-07-01','2027-06-30','2026-10-01','2026-07-01',101,'0',2,2,'0','admin','2026-10-02 14:30:24','',NULL,'季度检正常执行'),(9,'2号楼1单元季度检',3,'quarter',90,'季度检标准模板','2026-07-01','2027-06-30','2027-01-09','2026-10-11',101,'0',3,3,'0','admin','2026-10-02 14:30:24','','2026-10-11 14:05:02','季度检正常执行'),(10,'4号楼1单元季度检',5,'quarter',90,'季度检标准模板','2026-07-01','2027-06-30','2027-01-09','2026-10-11',103,'0',3,3,'0','admin','2026-10-02 14:30:24','','2026-10-11 14:01:41','季度检正常执行');
/*!40000 ALTER TABLE `maintain_plan` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `order_status_log`
--

DROP TABLE IF EXISTS `order_status_log`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `order_status_log` (
  `log_id` bigint NOT NULL AUTO_INCREMENT COMMENT '日志ID',
  `order_id` bigint NOT NULL COMMENT '关联工单ID',
  `from_status` varchar(20) COLLATE utf8mb4_general_ci DEFAULT '' COMMENT '原状态',
  `to_status` varchar(20) COLLATE utf8mb4_general_ci NOT NULL COMMENT '新状态',
  `operate_type` varchar(30) COLLATE utf8mb4_general_ci DEFAULT '' COMMENT '操作类型（report报修 reject驳回 assign派单 accept接单 arrive到场 investigate排查 finish维修完成 confirm业主确认 appeal申诉 reassign重新指派 escalate升级）',
  `operator_id` bigint DEFAULT NULL COMMENT '操作人ID',
  `operator_name` varchar(64) COLLATE utf8mb4_general_ci DEFAULT '' COMMENT '操作人姓名',
  `operator_role` varchar(30) COLLATE utf8mb4_general_ci DEFAULT '' COMMENT '操作人角色',
  `operate_time` datetime DEFAULT NULL COMMENT '操作时间',
  `remark` varchar(500) COLLATE utf8mb4_general_ci DEFAULT '' COMMENT '备注',
  PRIMARY KEY (`log_id`),
  KEY `idx_log_order` (`order_id`)
) ENGINE=InnoDB AUTO_INCREMENT=127 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='工单状态流转表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `order_status_log`
--

LOCK TABLES `order_status_log` WRITE;
/*!40000 ALTER TABLE `order_status_log` DISABLE KEYS */;
INSERT INTO `order_status_log` VALUES (8,5,'repaired','appealed','appeal',102,'业主张阿姨','owner','2026-10-02 16:05:16','端到端测试：异响仍然存在，请重新检查'),(12,16,'','pending','report',102,'业主张阿姨','owner','2026-10-02 19:59:32','业主提交故障报修'),(13,16,'pending','rejected','reject',100,'物业管理员','property','2026-10-02 20:10:10','故障描述不完整，请补充具体楼层'),(14,16,'rejected','pending','report',102,'业主张阿姨','owner','2026-10-02 20:10:10','业主补充信息后重新提交'),(15,16,'pending','rejected','reject',100,'物业管理员','property','2026-10-02 20:12:17','故障描述不完整，请补充具体楼层'),(16,16,'rejected','pending','report',102,'业主张阿姨','owner','2026-10-02 20:12:17','业主补充信息后重新提交'),(24,18,'','pending','report',102,'业主张阿姨','owner','2026-10-02 21:08:49','业主提交故障报修'),(25,18,'pending','assigned','assign',100,'物业管理员','property','2026-10-02 21:38:13','派单给维修员【维修员王师傅】，备注：电梯困人，请优先处理'),(26,18,'assigned','accepted','accept',101,'维修员王师傅','worker','2026-10-02 21:38:13','维修员已接单，预计 20 分钟到场'),(27,18,'accepted','arrived','arrive',101,'维修员王师傅','worker','2026-10-02 21:38:13','维修员已到达现场，定位：和平里小区 3号楼 1单元 1层'),(28,18,'arrived','repairing','investigate',101,'维修员王师傅','worker','2026-10-02 21:38:13','验证用：检查发现门锁触点氧化'),(29,18,'repairing','repaired','finish',101,'维修员王师傅','worker','2026-10-02 21:38:14','维修完成：验证用：更换门锁触点，恢复正常'),(31,18,'repaired','confirmed','confirm',102,'业主张阿姨','owner','2026-10-11 13:38:25','业主确认故障已消除，工单闭环'),(71,31,'','pending','report',102,'业主张阿姨','owner','2026-10-11 14:00:02','业主提交故障报修'),(72,31,'pending','rejected','reject',100,'物业管理员','property','2026-10-11 14:00:03','故障描述不完整，请补充具体楼层与发生时间'),(73,31,'rejected','pending','report',102,'业主张阿姨','owner','2026-10-11 14:00:03','业主补充信息后重新提交'),(74,31,'pending','assigned','assign',100,'物业管理员','property','2026-10-11 14:00:04','派单给维修员【维修员王师傅】，备注：闭环验证派单：请优先处理'),(75,31,'assigned','accepted','accept',101,'维修员王师傅','worker','2026-10-11 14:00:05','维修员已接单，预计 30 分钟到场'),(76,31,'accepted','arrived','arrive',101,'维修员王师傅','worker','2026-10-11 14:00:05','维修员已到达现场，定位：哈尔滨市道里区和平路56号4号楼1单元'),(77,31,'arrived','repairing','investigate',101,'维修员王师傅','worker','2026-10-11 14:00:06','初步排查：曳引机导向轮轴承磨损，运行中产生周期性异响与抖动'),(78,31,'repairing','repaired','finish',101,'维修员王师傅','worker','2026-10-11 14:00:07','维修完成：更换曳引机导向轮轴承并加注润滑脂，试运行 20 分钟无异响'),(79,31,'repaired','confirmed','confirm',102,'业主张阿姨','owner','2026-10-11 14:00:07','业主确认故障已消除，工单闭环'),(80,32,'','pending','report',102,'业主张阿姨','owner','2026-10-11 14:00:41','业主提交故障报修'),(81,32,'pending','assigned','assign',100,'物业管理员','property','2026-10-11 14:00:41','派单给维修员【维修员王师傅】，备注：申诉返工验证'),(82,32,'assigned','accepted','accept',101,'维修员王师傅','worker','2026-10-11 14:00:41','维修员已接单，预计 20 分钟到场'),(83,32,'accepted','arrived','arrive',101,'维修员王师傅','worker','2026-10-11 14:00:41','维修员已到达现场，定位：阳光家园1号楼1单元'),(84,32,'arrived','repairing','investigate',101,'维修员王师傅','worker','2026-10-11 14:00:41','门锁触点氧化，清理后正常'),(85,32,'repairing','repaired','finish',101,'维修员王师傅','worker','2026-10-11 14:00:41','维修完成：清理门锁触点'),(86,32,'repaired','appealed','appeal',102,'业主张阿姨','owner','2026-10-11 14:00:42','异常分支验证：电梯门仍有异响，请返工重新检查'),(87,32,'appealed','repairing','investigate',101,'维修员王师傅','worker','2026-10-11 14:00:42','返工排查：门机皮带松动导致异响，重新张紧'),(88,32,'repairing','repaired','finish',101,'维修员王师傅','worker','2026-10-11 14:00:42','维修完成：试探直接完工'),(89,32,'repaired','confirmed','confirm',102,'业主张阿姨','owner','2026-10-11 14:00:42','业主确认故障已消除，工单闭环'),(90,33,'','pending','report',102,'业主张阿姨','owner','2026-10-11 14:00:43','业主提交故障报修'),(91,33,'pending','rejected','reject',100,'物业管理员','property','2026-10-11 14:00:43','请补充故障发生的具体楼层'),(92,33,'rejected','assigned','assign',100,'物业管理员','property','2026-10-11 14:00:43','派单给维修员【维修员王师傅】，备注：驳回态直接派单试探'),(93,34,'','pending','report',102,'业主张阿姨','owner','2026-10-11 14:00:43','业主提交故障报修'),(94,34,'pending','assigned','assign',100,'物业管理员','property','2026-10-11 14:00:43','派单给维修员【维修员王师傅】，备注：拒单链路验证'),(95,34,'assigned','pending','reassign',101,'维修员王师傅','worker','2026-10-11 14:00:44','维修员拒绝接单：异常分支验证：本人正在处理其他紧急工单，请求改派'),(96,34,'pending','assigned','assign',100,'物业管理员','property','2026-10-11 14:00:44','派单给维修员【维修员王师傅】，备注：改派后重新派单'),(97,35,'','pending','report',102,'业主张阿姨','owner','2026-10-11 14:02:29','业主提交故障报修'),(98,33,'assigned','accepted','accept',101,'维修员王师傅','worker','2026-10-11 14:03:22','维修员已接单，预计 30 分钟到场'),(99,33,'accepted','arrived','arrive',101,'维修员王师傅','worker','2026-10-11 14:03:22','维修员已到达现场'),(100,35,'pending','pending','escalate',100,'物业管理员','property','2026-10-11 14:03:22','异常工单升级为紧急处理'),(108,35,'pending','pending','changeLevel',100,'物业管理员','property','2026-10-11 14:07:41','故障等级调整为【紧急】，原因：验收员测试'),(110,38,'','pending','report',102,'业主张阿姨','owner','2026-10-11 14:08:15','业主提交故障报修'),(111,35,'pending','rejected','reject',100,'物业管理员','property','2026-10-11 14:08:37','同秒编号测试前收尾（测试数据）'),(112,34,'assigned','pending','reassign',101,'维修员王师傅','worker','2026-10-11 14:08:37','维修员拒绝接单：同秒编号测试前收尾（测试数据）'),(113,34,'pending','rejected','reject',100,'物业管理员','property','2026-10-11 14:08:37','同秒编号测试前收尾（测试数据）'),(114,39,'','pending','report',102,'业主张阿姨','owner','2026-10-11 14:08:38','业主提交故障报修'),(115,40,'','pending','report',102,'业主张阿姨','owner','2026-10-11 14:08:38','业主提交故障报修'),(116,41,'','pending','report',102,'业主张阿姨','owner','2026-10-11 14:09:00','业主提交故障报修'),(117,41,'pending','rejected','reject',100,'物业管理员','property','2026-10-11 14:09:01','请补充故障具体表现'),(118,41,'rejected','pending','report',102,'业主张阿姨','owner','2026-10-11 14:09:01','业主补充信息后重新提交'),(119,41,'pending','assigned','assign',100,'物业管理员','property','2026-10-11 14:09:01','派单给维修员【维修员王师傅】，备注：复验闭环派单'),(120,41,'assigned','accepted','accept',101,'维修员王师傅','worker','2026-10-11 14:09:01','维修员已接单，预计 15 分钟到场'),(121,41,'accepted','arrived','arrive',101,'维修员王师傅','worker','2026-10-11 14:09:01','维修员已到达现场，定位：和平里小区 3号楼1单元'),(122,41,'arrived','repairing','investigate',101,'维修员王师傅','worker','2026-10-11 14:09:01','门机控制器参数异常，门锁回路接触不良'),(123,41,'repairing','repaired','finish',101,'维修员王师傅','worker','2026-10-11 14:09:01','维修完成：复位门机控制器参数并更换门锁触点，开关门测试 30 次正常'),(124,41,'repaired','confirmed','confirm',102,'业主张阿姨','owner','2026-10-11 14:09:01','业主确认故障已消除，工单闭环');
/*!40000 ALTER TABLE `order_status_log` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `qrtz_blob_triggers`
--

DROP TABLE IF EXISTS `qrtz_blob_triggers`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `qrtz_blob_triggers` (
  `sched_name` varchar(120) COLLATE utf8mb4_general_ci NOT NULL COMMENT '调度名称',
  `trigger_name` varchar(200) COLLATE utf8mb4_general_ci NOT NULL COMMENT 'qrtz_triggers表trigger_name的外键',
  `trigger_group` varchar(200) COLLATE utf8mb4_general_ci NOT NULL COMMENT 'qrtz_triggers表trigger_group的外键',
  `blob_data` blob COMMENT '存放持久化Trigger对象',
  PRIMARY KEY (`sched_name`,`trigger_name`,`trigger_group`),
  CONSTRAINT `qrtz_blob_triggers_ibfk_1` FOREIGN KEY (`sched_name`, `trigger_name`, `trigger_group`) REFERENCES `qrtz_triggers` (`sched_name`, `trigger_name`, `trigger_group`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='Blob类型的触发器表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `qrtz_blob_triggers`
--

LOCK TABLES `qrtz_blob_triggers` WRITE;
/*!40000 ALTER TABLE `qrtz_blob_triggers` DISABLE KEYS */;
/*!40000 ALTER TABLE `qrtz_blob_triggers` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `qrtz_calendars`
--

DROP TABLE IF EXISTS `qrtz_calendars`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `qrtz_calendars` (
  `sched_name` varchar(120) COLLATE utf8mb4_general_ci NOT NULL COMMENT '调度名称',
  `calendar_name` varchar(200) COLLATE utf8mb4_general_ci NOT NULL COMMENT '日历名称',
  `calendar` blob NOT NULL COMMENT '存放持久化calendar对象',
  PRIMARY KEY (`sched_name`,`calendar_name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='日历信息表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `qrtz_calendars`
--

LOCK TABLES `qrtz_calendars` WRITE;
/*!40000 ALTER TABLE `qrtz_calendars` DISABLE KEYS */;
/*!40000 ALTER TABLE `qrtz_calendars` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `qrtz_cron_triggers`
--

DROP TABLE IF EXISTS `qrtz_cron_triggers`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `qrtz_cron_triggers` (
  `sched_name` varchar(120) COLLATE utf8mb4_general_ci NOT NULL COMMENT '调度名称',
  `trigger_name` varchar(200) COLLATE utf8mb4_general_ci NOT NULL COMMENT 'qrtz_triggers表trigger_name的外键',
  `trigger_group` varchar(200) COLLATE utf8mb4_general_ci NOT NULL COMMENT 'qrtz_triggers表trigger_group的外键',
  `cron_expression` varchar(200) COLLATE utf8mb4_general_ci NOT NULL COMMENT 'cron表达式',
  `time_zone_id` varchar(80) COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '时区',
  PRIMARY KEY (`sched_name`,`trigger_name`,`trigger_group`),
  CONSTRAINT `qrtz_cron_triggers_ibfk_1` FOREIGN KEY (`sched_name`, `trigger_name`, `trigger_group`) REFERENCES `qrtz_triggers` (`sched_name`, `trigger_name`, `trigger_group`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='Cron类型的触发器表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `qrtz_cron_triggers`
--

LOCK TABLES `qrtz_cron_triggers` WRITE;
/*!40000 ALTER TABLE `qrtz_cron_triggers` DISABLE KEYS */;
/*!40000 ALTER TABLE `qrtz_cron_triggers` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `qrtz_fired_triggers`
--

DROP TABLE IF EXISTS `qrtz_fired_triggers`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `qrtz_fired_triggers` (
  `sched_name` varchar(120) COLLATE utf8mb4_general_ci NOT NULL COMMENT '调度名称',
  `entry_id` varchar(95) COLLATE utf8mb4_general_ci NOT NULL COMMENT '调度器实例id',
  `trigger_name` varchar(200) COLLATE utf8mb4_general_ci NOT NULL COMMENT 'qrtz_triggers表trigger_name的外键',
  `trigger_group` varchar(200) COLLATE utf8mb4_general_ci NOT NULL COMMENT 'qrtz_triggers表trigger_group的外键',
  `instance_name` varchar(200) COLLATE utf8mb4_general_ci NOT NULL COMMENT '调度器实例名',
  `fired_time` bigint NOT NULL COMMENT '触发的时间',
  `sched_time` bigint NOT NULL COMMENT '定时器制定的时间',
  `priority` int NOT NULL COMMENT '优先级',
  `state` varchar(16) COLLATE utf8mb4_general_ci NOT NULL COMMENT '状态',
  `job_name` varchar(200) COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '任务名称',
  `job_group` varchar(200) COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '任务组名',
  `is_nonconcurrent` varchar(1) COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '是否并发',
  `requests_recovery` varchar(1) COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '是否接受恢复执行',
  PRIMARY KEY (`sched_name`,`entry_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='已触发的触发器表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `qrtz_fired_triggers`
--

LOCK TABLES `qrtz_fired_triggers` WRITE;
/*!40000 ALTER TABLE `qrtz_fired_triggers` DISABLE KEYS */;
/*!40000 ALTER TABLE `qrtz_fired_triggers` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `qrtz_job_details`
--

DROP TABLE IF EXISTS `qrtz_job_details`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `qrtz_job_details` (
  `sched_name` varchar(120) COLLATE utf8mb4_general_ci NOT NULL COMMENT '调度名称',
  `job_name` varchar(200) COLLATE utf8mb4_general_ci NOT NULL COMMENT '任务名称',
  `job_group` varchar(200) COLLATE utf8mb4_general_ci NOT NULL COMMENT '任务组名',
  `description` varchar(250) COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '相关介绍',
  `job_class_name` varchar(250) COLLATE utf8mb4_general_ci NOT NULL COMMENT '执行任务类名称',
  `is_durable` varchar(1) COLLATE utf8mb4_general_ci NOT NULL COMMENT '是否持久化',
  `is_nonconcurrent` varchar(1) COLLATE utf8mb4_general_ci NOT NULL COMMENT '是否并发',
  `is_update_data` varchar(1) COLLATE utf8mb4_general_ci NOT NULL COMMENT '是否更新数据',
  `requests_recovery` varchar(1) COLLATE utf8mb4_general_ci NOT NULL COMMENT '是否接受恢复执行',
  `job_data` blob COMMENT '存放持久化job对象',
  PRIMARY KEY (`sched_name`,`job_name`,`job_group`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='任务详细信息表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `qrtz_job_details`
--

LOCK TABLES `qrtz_job_details` WRITE;
/*!40000 ALTER TABLE `qrtz_job_details` DISABLE KEYS */;
/*!40000 ALTER TABLE `qrtz_job_details` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `qrtz_locks`
--

DROP TABLE IF EXISTS `qrtz_locks`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `qrtz_locks` (
  `sched_name` varchar(120) COLLATE utf8mb4_general_ci NOT NULL COMMENT '调度名称',
  `lock_name` varchar(40) COLLATE utf8mb4_general_ci NOT NULL COMMENT '悲观锁名称',
  PRIMARY KEY (`sched_name`,`lock_name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='存储的悲观锁信息表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `qrtz_locks`
--

LOCK TABLES `qrtz_locks` WRITE;
/*!40000 ALTER TABLE `qrtz_locks` DISABLE KEYS */;
/*!40000 ALTER TABLE `qrtz_locks` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `qrtz_paused_trigger_grps`
--

DROP TABLE IF EXISTS `qrtz_paused_trigger_grps`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `qrtz_paused_trigger_grps` (
  `sched_name` varchar(120) COLLATE utf8mb4_general_ci NOT NULL COMMENT '调度名称',
  `trigger_group` varchar(200) COLLATE utf8mb4_general_ci NOT NULL COMMENT 'qrtz_triggers表trigger_group的外键',
  PRIMARY KEY (`sched_name`,`trigger_group`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='暂停的触发器表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `qrtz_paused_trigger_grps`
--

LOCK TABLES `qrtz_paused_trigger_grps` WRITE;
/*!40000 ALTER TABLE `qrtz_paused_trigger_grps` DISABLE KEYS */;
/*!40000 ALTER TABLE `qrtz_paused_trigger_grps` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `qrtz_scheduler_state`
--

DROP TABLE IF EXISTS `qrtz_scheduler_state`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `qrtz_scheduler_state` (
  `sched_name` varchar(120) COLLATE utf8mb4_general_ci NOT NULL COMMENT '调度名称',
  `instance_name` varchar(200) COLLATE utf8mb4_general_ci NOT NULL COMMENT '实例名称',
  `last_checkin_time` bigint NOT NULL COMMENT '上次检查时间',
  `checkin_interval` bigint NOT NULL COMMENT '检查间隔时间',
  PRIMARY KEY (`sched_name`,`instance_name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='调度器状态表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `qrtz_scheduler_state`
--

LOCK TABLES `qrtz_scheduler_state` WRITE;
/*!40000 ALTER TABLE `qrtz_scheduler_state` DISABLE KEYS */;
/*!40000 ALTER TABLE `qrtz_scheduler_state` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `qrtz_simple_triggers`
--

DROP TABLE IF EXISTS `qrtz_simple_triggers`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `qrtz_simple_triggers` (
  `sched_name` varchar(120) COLLATE utf8mb4_general_ci NOT NULL COMMENT '调度名称',
  `trigger_name` varchar(200) COLLATE utf8mb4_general_ci NOT NULL COMMENT 'qrtz_triggers表trigger_name的外键',
  `trigger_group` varchar(200) COLLATE utf8mb4_general_ci NOT NULL COMMENT 'qrtz_triggers表trigger_group的外键',
  `repeat_count` bigint NOT NULL COMMENT '重复的次数统计',
  `repeat_interval` bigint NOT NULL COMMENT '重复的间隔时间',
  `times_triggered` bigint NOT NULL COMMENT '已经触发的次数',
  PRIMARY KEY (`sched_name`,`trigger_name`,`trigger_group`),
  CONSTRAINT `qrtz_simple_triggers_ibfk_1` FOREIGN KEY (`sched_name`, `trigger_name`, `trigger_group`) REFERENCES `qrtz_triggers` (`sched_name`, `trigger_name`, `trigger_group`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='简单触发器的信息表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `qrtz_simple_triggers`
--

LOCK TABLES `qrtz_simple_triggers` WRITE;
/*!40000 ALTER TABLE `qrtz_simple_triggers` DISABLE KEYS */;
/*!40000 ALTER TABLE `qrtz_simple_triggers` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `qrtz_simprop_triggers`
--

DROP TABLE IF EXISTS `qrtz_simprop_triggers`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `qrtz_simprop_triggers` (
  `sched_name` varchar(120) COLLATE utf8mb4_general_ci NOT NULL COMMENT '调度名称',
  `trigger_name` varchar(200) COLLATE utf8mb4_general_ci NOT NULL COMMENT 'qrtz_triggers表trigger_name的外键',
  `trigger_group` varchar(200) COLLATE utf8mb4_general_ci NOT NULL COMMENT 'qrtz_triggers表trigger_group的外键',
  `str_prop_1` varchar(512) COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT 'String类型的trigger的第一个参数',
  `str_prop_2` varchar(512) COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT 'String类型的trigger的第二个参数',
  `str_prop_3` varchar(512) COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT 'String类型的trigger的第三个参数',
  `int_prop_1` int DEFAULT NULL COMMENT 'int类型的trigger的第一个参数',
  `int_prop_2` int DEFAULT NULL COMMENT 'int类型的trigger的第二个参数',
  `long_prop_1` bigint DEFAULT NULL COMMENT 'long类型的trigger的第一个参数',
  `long_prop_2` bigint DEFAULT NULL COMMENT 'long类型的trigger的第二个参数',
  `dec_prop_1` decimal(13,4) DEFAULT NULL COMMENT 'decimal类型的trigger的第一个参数',
  `dec_prop_2` decimal(13,4) DEFAULT NULL COMMENT 'decimal类型的trigger的第二个参数',
  `bool_prop_1` varchar(1) COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT 'Boolean类型的trigger的第一个参数',
  `bool_prop_2` varchar(1) COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT 'Boolean类型的trigger的第二个参数',
  PRIMARY KEY (`sched_name`,`trigger_name`,`trigger_group`),
  CONSTRAINT `qrtz_simprop_triggers_ibfk_1` FOREIGN KEY (`sched_name`, `trigger_name`, `trigger_group`) REFERENCES `qrtz_triggers` (`sched_name`, `trigger_name`, `trigger_group`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='同步机制的行锁表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `qrtz_simprop_triggers`
--

LOCK TABLES `qrtz_simprop_triggers` WRITE;
/*!40000 ALTER TABLE `qrtz_simprop_triggers` DISABLE KEYS */;
/*!40000 ALTER TABLE `qrtz_simprop_triggers` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `qrtz_triggers`
--

DROP TABLE IF EXISTS `qrtz_triggers`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `qrtz_triggers` (
  `sched_name` varchar(120) COLLATE utf8mb4_general_ci NOT NULL COMMENT '调度名称',
  `trigger_name` varchar(200) COLLATE utf8mb4_general_ci NOT NULL COMMENT '触发器的名字',
  `trigger_group` varchar(200) COLLATE utf8mb4_general_ci NOT NULL COMMENT '触发器所属组的名字',
  `job_name` varchar(200) COLLATE utf8mb4_general_ci NOT NULL COMMENT 'qrtz_job_details表job_name的外键',
  `job_group` varchar(200) COLLATE utf8mb4_general_ci NOT NULL COMMENT 'qrtz_job_details表job_group的外键',
  `description` varchar(250) COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '相关介绍',
  `next_fire_time` bigint DEFAULT NULL COMMENT '上一次触发时间（毫秒）',
  `prev_fire_time` bigint DEFAULT NULL COMMENT '下一次触发时间（默认为-1表示不触发）',
  `priority` int DEFAULT NULL COMMENT '优先级',
  `trigger_state` varchar(16) COLLATE utf8mb4_general_ci NOT NULL COMMENT '触发器状态',
  `trigger_type` varchar(8) COLLATE utf8mb4_general_ci NOT NULL COMMENT '触发器的类型',
  `start_time` bigint NOT NULL COMMENT '开始时间',
  `end_time` bigint DEFAULT NULL COMMENT '结束时间',
  `calendar_name` varchar(200) COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '日程表名称',
  `misfire_instr` smallint DEFAULT NULL COMMENT '补偿执行的策略',
  `job_data` blob COMMENT '存放持久化job对象',
  PRIMARY KEY (`sched_name`,`trigger_name`,`trigger_group`),
  KEY `sched_name` (`sched_name`,`job_name`,`job_group`),
  CONSTRAINT `qrtz_triggers_ibfk_1` FOREIGN KEY (`sched_name`, `job_name`, `job_group`) REFERENCES `qrtz_job_details` (`sched_name`, `job_name`, `job_group`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='触发器详细信息表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `qrtz_triggers`
--

LOCK TABLES `qrtz_triggers` WRITE;
/*!40000 ALTER TABLE `qrtz_triggers` DISABLE KEYS */;
/*!40000 ALTER TABLE `qrtz_triggers` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `repair_evidence`
--

DROP TABLE IF EXISTS `repair_evidence`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `repair_evidence` (
  `evidence_id` bigint NOT NULL AUTO_INCREMENT COMMENT '证据ID',
  `order_id` bigint NOT NULL COMMENT '关联工单ID',
  `file_id` bigint NOT NULL COMMENT '文件ID',
  `evidence_type` varchar(20) COLLATE utf8mb4_general_ci DEFAULT 'image' COMMENT '证据类型（image图片 video视频）',
  `upload_time` datetime DEFAULT NULL COMMENT '上传时间',
  `create_by` varchar(64) COLLATE utf8mb4_general_ci DEFAULT '' COMMENT '创建者',
  `del_flag` char(1) COLLATE utf8mb4_general_ci DEFAULT '0' COMMENT '删除标志（0代表存在 2代表删除）',
  PRIMARY KEY (`evidence_id`),
  KEY `idx_evidence_order` (`order_id`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='报修证据附件表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `repair_evidence`
--

LOCK TABLES `repair_evidence` WRITE;
/*!40000 ALTER TABLE `repair_evidence` DISABLE KEYS */;
INSERT INTO `repair_evidence` VALUES (1,16,1,'image','2026-10-02 19:59:32','yezhu01','0'),(2,18,2,'image','2026-10-02 21:08:49','yezhu01','0');
/*!40000 ALTER TABLE `repair_evidence` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `repair_order`
--

DROP TABLE IF EXISTS `repair_order`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `repair_order` (
  `order_id` bigint NOT NULL AUTO_INCREMENT COMMENT '工单ID',
  `order_no` varchar(50) COLLATE utf8mb4_general_ci NOT NULL COMMENT '工单编号',
  `user_id` bigint NOT NULL COMMENT '报修人ID',
  `elevator_id` bigint NOT NULL COMMENT '故障电梯ID',
  `fault_desc` varchar(500) COLLATE utf8mb4_general_ci NOT NULL COMMENT '故障现象描述',
  `fault_type` varchar(30) COLLATE utf8mb4_general_ci DEFAULT '' COMMENT '故障类型（abnormal_noise异响 stop停梯 trapped困人 door门故障 button按钮失灵 other其他）',
  `fault_level` char(1) COLLATE utf8mb4_general_ci DEFAULT '1' COMMENT '故障等级（0紧急 1一般）',
  `order_status` varchar(20) COLLATE utf8mb4_general_ci DEFAULT 'pending' COMMENT '工单状态（pending待处理 assigned已派单 accepted已接单 arrived已到场 repairing维修中 repaired已修复 confirmed已完成 rejected已驳回 appealed已申诉）',
  `reporter_phone` varchar(20) COLLATE utf8mb4_general_ci DEFAULT '' COMMENT '报修人联系电话',
  `report_time` datetime DEFAULT NULL COMMENT '报修时间',
  `assign_time` datetime DEFAULT NULL COMMENT '派单时间',
  `accept_time` datetime DEFAULT NULL COMMENT '接单时间',
  `arrive_time` datetime DEFAULT NULL COMMENT '到场时间',
  `finish_time` datetime DEFAULT NULL COMMENT '维修完成时间',
  `confirm_time` datetime DEFAULT NULL COMMENT '业主确认时间',
  `assignee_id` bigint DEFAULT NULL COMMENT '维修员ID',
  `assigner_id` bigint DEFAULT NULL COMMENT '派单人ID',
  `reject_reason` varchar(500) COLLATE utf8mb4_general_ci DEFAULT '' COMMENT '驳回原因',
  `deadline_time` datetime DEFAULT NULL COMMENT '处理时限',
  `del_flag` char(1) COLLATE utf8mb4_general_ci DEFAULT '0' COMMENT '删除标志（0代表存在 2代表删除）',
  `create_by` varchar(64) COLLATE utf8mb4_general_ci DEFAULT '' COMMENT '创建者',
  `create_time` datetime DEFAULT NULL COMMENT '创建时间',
  `update_by` varchar(64) COLLATE utf8mb4_general_ci DEFAULT '' COMMENT '更新者',
  `update_time` datetime DEFAULT NULL COMMENT '更新时间',
  `remark` varchar(500) COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '备注',
  PRIMARY KEY (`order_id`),
  UNIQUE KEY `uk_order_no` (`order_no`),
  KEY `idx_order_elevator` (`elevator_id`),
  KEY `idx_order_user` (`user_id`),
  KEY `idx_order_assignee` (`assignee_id`),
  KEY `idx_order_status` (`order_status`)
) ENGINE=InnoDB AUTO_INCREMENT=42 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='报修工单表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `repair_order`
--

LOCK TABLES `repair_order` WRITE;
/*!40000 ALTER TABLE `repair_order` DISABLE KEYS */;
INSERT INTO `repair_order` VALUES (1,'BX20260722101501',102,6,'电梯运行中突然停梯，轿厢困人，需紧急救援','stop','0','confirmed','13800000003','2026-07-22 10:15:00','2026-07-22 10:22:00','2026-07-22 10:25:00','2026-07-22 10:48:00','2026-07-22 12:30:00','2026-07-22 14:00:00',104,100,NULL,'2026-07-22 10:35:00','0','admin','2026-10-02 14:30:24','',NULL,'困人事故，紧急救援后恢复运行'),(2,'BX20260803142002',102,6,'电梯门关不上，反复开合','door','1','confirmed','13800000003','2026-08-03 14:20:00','2026-08-03 14:40:00','2026-08-03 14:45:00','2026-08-03 15:30:00','2026-08-03 17:00:00','2026-08-03 18:00:00',104,100,NULL,'2026-08-03 15:00:00','0','admin','2026-10-02 14:30:24','',NULL,'层门卡阻，调整后恢复'),(3,'BX20260818093003',102,6,'电梯运行时异响明显，轿厢晃动','noise','1','confirmed','13800000003','2026-08-18 09:30:00','2026-08-18 09:50:00','2026-08-18 10:00:00','2026-08-18 11:20:00','2026-08-18 15:00:00','2026-08-18 16:00:00',104,100,NULL,'2026-08-18 10:10:00','0','admin','2026-10-02 14:30:24','',NULL,'导靴磨损，更换后异响消除'),(4,'BX20260905161004',102,6,'电梯急停后无法再启动，楼层显示异常','stop','0','confirmed','13800000003','2026-09-05 16:10:00','2026-09-05 16:18:00','2026-09-05 16:20:00','2026-09-05 16:50:00','2026-09-05 21:00:00','2026-09-06 09:00:00',104,100,NULL,'2026-09-05 16:30:00','0','admin','2026-10-02 14:30:24','',NULL,'控制柜接触器故障，更换接触器'),(5,'BX20260922110505',102,6,'电梯溜梯，轿厢下坠半层后停住','slip','0','appealed','13800000003','2026-09-22 11:05:00','2026-09-22 11:12:00','2026-09-22 11:15:00','2026-09-22 11:40:00','2026-09-22 18:00:00',NULL,104,100,NULL,'2026-09-22 11:25:00','0','admin','2026-10-02 14:30:24','yezhu01','2026-10-02 16:05:16','制动器间隙超标，已调整，待业主确认'),(6,'BX20260712103006',102,4,'电梯运行中突然停梯，乘客被困','stop','0','confirmed','13800000003','2026-07-12 10:30:00','2026-07-12 10:36:00','2026-07-12 10:40:00','2026-07-12 11:05:00','2026-07-12 13:00:00','2026-07-12 15:00:00',103,100,NULL,'2026-07-12 10:50:00','0','admin','2026-10-02 14:30:24','',NULL,'钢丝绳锈蚀卡阻，已停梯'),(7,'BX20260724150007',102,4,'电梯门无法关闭，多次反复','door','1','confirmed','13800000003','2026-07-24 15:00:00','2026-07-24 15:20:00','2026-07-24 15:25:00','2026-07-24 16:10:00','2026-07-24 18:00:00','2026-07-25 09:00:00',103,100,NULL,'2026-07-24 15:40:00','0','admin','2026-10-02 14:30:24','',NULL,'门锁触点烧蚀，更换后恢复'),(8,'BX20260811101508',102,4,'电梯制动时异响，停层不准','noise','1','confirmed','13800000003','2026-08-11 10:15:00','2026-08-11 10:30:00','2026-08-11 10:35:00','2026-08-11 11:30:00','2026-08-11 16:00:00','2026-08-12 09:00:00',103,100,NULL,'2026-08-11 10:45:00','0','admin','2026-10-02 14:30:24','',NULL,'制动器间隙超标，已调整'),(9,'BX20260915142009',102,4,'电梯困人，轿厢停在两层之间','stop','0','confirmed','13800000003','2026-09-15 14:20:00','2026-09-15 14:26:00','2026-09-15 14:30:00','2026-09-15 15:00:00','2026-09-15 17:30:00','2026-09-16 09:00:00',103,100,NULL,'2026-09-15 14:40:00','0','admin','2026-10-02 14:30:24','',NULL,'限速器动作异常，已检修，电梯停用待大修'),(10,'BX20260826103010',102,2,'电梯门开合时有异响','noise','1','confirmed','13800000003','2026-08-26 10:30:00','2026-08-26 10:50:00','2026-08-26 11:00:00','2026-08-26 11:40:00','2026-08-26 14:00:00','2026-08-26 16:00:00',101,100,NULL,'2026-08-26 11:10:00','0','admin','2026-10-02 14:30:24','',NULL,'层门滑道缺油，润滑后异响减轻'),(11,'BX20260919153011',102,2,'电梯按钮失灵，按了没反应','button','1','confirmed','13800000003','2026-09-19 15:30:00','2026-09-19 15:45:00','2026-09-19 15:50:00','2026-09-19 16:30:00','2026-09-19 18:00:00','2026-09-20 09:00:00',101,100,NULL,'2026-09-19 16:00:00','0','admin','2026-10-02 14:30:24','',NULL,'按钮触点氧化，更换按钮'),(12,'BX20260908110012',102,3,'电梯运行中有轻微异响','noise','1','confirmed','13800000003','2026-09-08 11:00:00','2026-09-08 11:20:00','2026-09-08 11:30:00','2026-09-08 14:00:00','2026-09-08 16:00:00','2026-09-09 09:00:00',103,100,NULL,'2026-09-08 11:40:00','0','admin','2026-10-02 14:30:24','',NULL,'控制柜接触器异响，已更换'),(16,'BX20261002195932',102,2,'电梯运行时轿厢内有明显异响，门开合时有卡顿','abnormal_noise','1','rejected','13800000003','2026-10-02 19:59:32',NULL,NULL,NULL,NULL,NULL,NULL,NULL,'现场照片不够清晰，请补充上传电梯门区域的照片','2026-10-03 19:59:32','0','yezhu01','2026-10-02 19:59:32','yezhu01','2026-10-02 20:12:17',NULL),(18,'BX20261002210849',102,4,'电梯门关门后无法启动，轿厢停在 1 层不动','trapped','0','confirmed','13800000003','2026-10-02 21:08:49','2026-10-02 21:38:13','2026-10-02 21:38:14','2026-10-02 21:38:14','2026-10-02 21:38:14','2026-10-11 13:38:25',101,100,'','2026-10-02 21:58:14','0','yezhu01','2026-10-02 21:08:49','yezhu01','2026-10-11 13:38:25',NULL),(31,'BX20261011140002001',102,5,'补充：3号楼1单元，10月11日14时，电梯上行至5层时剧烈抖动并伴随金属摩擦异响','abnormal_noise','0','confirmed','13800000003','2026-10-11 14:00:02','2026-10-11 14:00:04','2026-10-11 14:00:05','2026-10-11 14:00:06','2026-10-11 14:00:07','2026-10-11 14:00:08',101,100,'','2026-10-11 14:30:05','0','yezhu01','2026-10-11 14:00:02','yezhu01','2026-10-11 14:00:07',NULL),(32,'BX20261011140041001',102,1,'异常分支验证-电梯故障 A-申诉返工','door','1','confirmed','13800000003','2026-10-11 14:00:41','2026-10-11 14:00:41','2026-10-11 14:00:42','2026-10-11 14:00:42','2026-10-11 14:00:43','2026-10-11 14:00:43',101,100,'','2026-10-11 14:20:42','0','yezhu01','2026-10-11 14:00:41','yezhu01','2026-10-11 14:00:42',NULL),(33,'BX20261011140043001',102,5,'异常分支验证-电梯故障 B-驳回重提','door','1','arrived','13800000003','2026-10-11 14:00:43','2026-10-11 14:00:43','2026-10-11 14:03:22','2026-10-11 14:03:22',NULL,NULL,101,100,'请补充故障发生的具体楼层','2026-10-11 14:33:22','0','yezhu01','2026-10-11 14:00:43','weixiu01','2026-10-11 14:03:22',NULL),(34,'BX20261011140043002',102,3,'异常分支验证-电梯故障 C-拒单','door','1','rejected','13800000003','2026-10-11 14:00:43','2026-10-11 14:00:45',NULL,NULL,NULL,NULL,0,0,'同秒编号测试前收尾（测试数据）','2026-10-12 14:00:44','0','yezhu01','2026-10-11 14:00:43','wuye01','2026-10-11 14:08:37',NULL),(35,'BX20261011140229001',102,2,'预警扫描验证-电梯门异响','door','1','rejected','13800000003','2026-10-11 12:02:30',NULL,NULL,NULL,NULL,NULL,NULL,NULL,'同秒编号测试前收尾（测试数据）','2026-10-12 14:02:30','0','yezhu01','2026-10-11 14:02:29',NULL,NULL,'异常工单升级为紧急处理'),(38,'BX20261011140815001',102,1,'同秒编号测试第 1 次','door','1','pending','13800000003','2026-10-11 14:08:15',NULL,NULL,NULL,NULL,NULL,NULL,NULL,'','2026-10-12 14:08:16','0','yezhu01','2026-10-11 14:08:15',NULL,NULL,NULL),(39,'BX20261011140838001',102,2,'同秒编号测试 A（电梯2）','door','1','pending','13800000003','2026-10-11 14:08:38',NULL,NULL,NULL,NULL,NULL,NULL,NULL,'','2026-10-12 14:08:39','0','yezhu01','2026-10-11 14:08:38','',NULL,NULL),(40,'BX20261011140838002',102,3,'同秒编号测试 B（电梯3）','stop','1','pending','13800000003','2026-10-11 14:08:38',NULL,NULL,NULL,NULL,NULL,NULL,NULL,'','2026-10-12 14:08:39','0','yezhu01','2026-10-11 14:08:38','',NULL,NULL),(41,'BX20261011140900001',102,4,'补充：电梯门关闭后反复自动开启，轿厢停在1层无法启动','door','0','confirmed','13800000003','2026-10-11 14:09:00','2026-10-11 14:09:01','2026-10-11 14:09:01','2026-10-11 14:09:01','2026-10-11 14:09:01','2026-10-11 14:09:02',101,100,'','2026-10-11 14:24:01','0','yezhu01','2026-10-11 14:09:00','yezhu01','2026-10-11 14:09:01',NULL);
/*!40000 ALTER TABLE `repair_order` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `repair_record`
--

DROP TABLE IF EXISTS `repair_record`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `repair_record` (
  `record_id` bigint NOT NULL AUTO_INCREMENT COMMENT '记录ID',
  `order_id` bigint NOT NULL COMMENT '关联工单ID',
  `worker_id` bigint NOT NULL COMMENT '维修员ID',
  `arrive_time` datetime DEFAULT NULL COMMENT '到场时间',
  `arrive_location` varchar(200) COLLATE utf8mb4_general_ci DEFAULT '' COMMENT '到场定位',
  `investigate_note` varchar(1000) COLLATE utf8mb4_general_ci DEFAULT '' COMMENT '排查记录',
  `repair_desc` varchar(1000) COLLATE utf8mb4_general_ci DEFAULT '' COMMENT '维修说明',
  `fault_reason` varchar(30) COLLATE utf8mb4_general_ci DEFAULT '' COMMENT '故障原因（normal_wear正常磨损 parts_damage配件损坏 improper_use使用不当 external外因 other其他）',
  `replace_parts` varchar(500) COLLATE utf8mb4_general_ci DEFAULT '' COMMENT '更换配件',
  `finish_time` datetime DEFAULT NULL COMMENT '完工时间',
  `result_file_id` bigint DEFAULT NULL COMMENT '完工凭证文件ID',
  `create_by` varchar(64) COLLATE utf8mb4_general_ci DEFAULT '' COMMENT '创建者',
  `create_time` datetime DEFAULT NULL COMMENT '创建时间',
  `update_by` varchar(64) COLLATE utf8mb4_general_ci DEFAULT '' COMMENT '更新者',
  `update_time` datetime DEFAULT NULL COMMENT '更新时间',
  PRIMARY KEY (`record_id`),
  KEY `idx_record_order` (`order_id`),
  KEY `idx_record_worker` (`worker_id`)
) ENGINE=InnoDB AUTO_INCREMENT=25 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='维修记录表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `repair_record`
--

LOCK TABLES `repair_record` WRITE;
/*!40000 ALTER TABLE `repair_record` DISABLE KEYS */;
INSERT INTO `repair_record` VALUES (1,13,101,'2026-10-02 16:04:57','阳光家园小区1号楼1单元1层','检查发现导靴磨损，运行时产生异响','更换导靴并加注润滑油，试运行异响消除','导靴长期磨损未更换','导靴 2 个','2026-10-02 16:04:57',NULL,'weixiu01','2026-10-02 16:04:57','weixiu01','2026-10-02 16:04:57'),(2,17,101,'2026-10-02 20:34:56','最终验收测试位置','最终验收：排查发现导靴磨损','更换导靴','导靴磨损','导靴2个','2026-10-02 20:34:56',NULL,'weixiu01','2026-10-02 20:34:55','weixiu01','2026-10-02 20:34:56'),(3,1,104,'2026-07-22 10:48:00','铁路新村小区 A座 1单元 1层','到达现场确认轿厢停在 3 层与 4 层之间，两人被困，先手动盘车至平层放人','手动盘车放人后检查限速器与安全钳，复位安全回路，试运行恢复正常','限速器误动作触发安全回路','限速器复位弹簧 1 套','2026-07-22 12:30:00',NULL,'admin','2026-10-02 21:28:55','','2026-10-02 21:42:00'),(4,2,104,'2026-08-03 15:30:00','铁路新村小区 A座 1单元 1层','检查层门地坎有异物，门机力矩偏小','清理地坎异物并调整门机力矩，反复开合 20 次无卡阻','层门地坎卡阻','无','2026-08-03 17:00:00',NULL,'admin','2026-10-02 21:28:55','','2026-10-02 21:38:19'),(5,3,104,'2026-08-18 11:20:00','铁路新村小区 A座 1单元 6层','随梯运行听音定位，异响来自轿厢导靴与导轨摩擦','更换四只导靴并加注润滑油，试运行异响消除','导靴磨损超限','导靴 4 只、导轨油 1 桶','2026-08-18 15:00:00',NULL,'admin','2026-10-02 21:28:55','','2026-10-02 21:42:00'),(6,4,104,'2026-09-05 16:50:00','铁路新村小区 A座 1单元 1层','控制柜内接触器吸合时有明显打火痕迹，触点烧蚀','更换主接触器并紧固接线端子，恢复运行观察 2 小时无异常','主接触器触点烧蚀','交流接触器 1 台','2026-09-05 21:00:00',NULL,'admin','2026-10-02 21:28:55','','2026-10-02 21:42:00'),(7,5,104,'2026-09-22 11:40:00','铁路新村小区 A座 1单元 1层','用塞尺测量制动器间隙，左右两侧均超过 0.7mm 标准值','调整制动器间隙至 0.4mm 并做 125% 额定载荷制动试验，合格','制动器间隙超标','制动器闸瓦 2 副','2026-09-22 18:00:00',NULL,'admin','2026-10-02 21:28:55','','2026-10-02 21:42:00'),(8,6,103,'2026-07-12 11:05:00','和平里小区 3号楼 1单元 1层','检查发现曳引钢丝绳锈蚀，局部断丝超标，运行中卡阻导致急停','更换全部曳引钢丝绳，复检张力均匀后停梯待大修评估','钢丝绳锈蚀断丝','曳引钢丝绳 6 根','2026-07-12 13:00:00',NULL,'admin','2026-10-02 21:28:55','','2026-10-02 21:42:00'),(9,7,103,'2026-07-24 16:10:00','和平里小区 3号楼 1单元 1层','拆检门锁发现触点烧蚀发黑，接触电阻偏大','更换门锁触点组件，调整门锁啮合深度，开关门测试正常','门锁触点烧蚀','门锁触点 2 套','2026-07-24 18:00:00',NULL,'admin','2026-10-02 21:28:55','','2026-10-02 21:38:19'),(10,8,103,'2026-08-11 11:30:00','和平里小区 3号楼 1单元 1层','测量制动器间隙超标，制动时闸瓦与制动轮摩擦产生异响','调整制动器间隙并做制动试验，停层准确度恢复正常','制动器间隙超标','无','2026-08-11 16:00:00',NULL,'admin','2026-10-02 21:28:55','','2026-10-02 21:38:19'),(11,9,103,'2026-09-15 15:00:00','和平里小区 3号楼 1单元 1层','限速器动作后未正常复位，安全钳楔块卡滞','复位安全钳并检修限速器，因曳引机亦有异常，电梯停用待大修','限速器动作异常、安全钳卡滞','安全钳楔块 2 块','2026-09-15 17:30:00',NULL,'admin','2026-10-02 21:28:55','','2026-10-02 21:42:00'),(12,10,101,'2026-08-26 11:40:00','阳光家园小区 1号楼 2单元 1层','随梯听音确认异响来自层门滑道，滑道干涩','清理滑道并加注润滑脂，开关门异响明显减轻','层门滑道缺油','润滑脂 1 支','2026-08-26 14:00:00',NULL,'admin','2026-10-02 21:28:55','','2026-10-02 21:42:00'),(13,11,101,'2026-09-19 16:30:00','阳光家园小区 1号楼 2单元 3层','拆下按钮实测触点氧化，导通不良','更换该层外呼按钮并除尘，逐层测试信号正常','按钮触点氧化','外呼按钮 1 只','2026-09-19 18:00:00',NULL,'admin','2026-10-02 21:28:55','','2026-10-02 21:42:00'),(14,12,103,'2026-09-08 14:00:00','阳光家园小区 2号楼 1单元 1层','打开控制柜听音确认异响来自接触器，吸合时有轻微打火','更换控制柜接触器并紧固接线，试运行异响消除','控制柜接触器异响','交流接触器 1 台','2026-09-08 16:00:00',NULL,'admin','2026-10-02 21:37:52','','2026-10-02 21:42:00'),(15,18,101,'2026-10-02 21:38:14','和平里小区 3号楼 1单元 1层','拆检门锁发现触点氧化发黑，接触不良','更换门锁触点组件并调整啮合深度，开关门测试正常','门锁触点氧化','门锁触点 2 套','2026-10-02 21:38:14',NULL,'weixiu01','2026-10-02 21:38:13','weixiu01','2026-10-02 21:42:00'),(20,31,101,'2026-10-11 14:00:06','哈尔滨市道里区和平路56号4号楼1单元','初步排查：曳引机导向轮轴承磨损，运行中产生周期性异响与抖动','更换曳引机导向轮轴承并加注润滑脂，试运行 20 分钟无异响','bearing_wear','导向轮轴承 型号6206 数量2','2026-10-11 14:00:07',NULL,'weixiu01','2026-10-11 14:00:05','weixiu01','2026-10-11 14:00:07'),(21,32,101,'2026-10-11 14:00:42','阳光家园1号楼1单元','返工排查：门机皮带松动导致异响，重新张紧','试探直接完工',NULL,'无','2026-10-11 14:00:43',NULL,'weixiu01','2026-10-11 14:00:41','weixiu01','2026-10-11 14:00:42'),(22,33,101,'2026-10-11 14:03:22',NULL,NULL,NULL,NULL,NULL,NULL,NULL,'weixiu01','2026-10-11 14:03:22','',NULL),(24,41,101,'2026-10-11 14:09:01','和平里小区 3号楼1单元','门机控制器参数异常，门锁回路接触不良','复位门机控制器参数并更换门锁触点，开关门测试 30 次正常','controller_params','门锁触点 2 只','2026-10-11 14:09:01',NULL,'weixiu01','2026-10-11 14:09:01','weixiu01','2026-10-11 14:09:01');
/*!40000 ALTER TABLE `repair_record` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `sys_config`
--

DROP TABLE IF EXISTS `sys_config`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sys_config` (
  `config_id` int NOT NULL AUTO_INCREMENT COMMENT '参数主键',
  `config_name` varchar(100) COLLATE utf8mb4_general_ci DEFAULT '' COMMENT '参数名称',
  `config_key` varchar(100) COLLATE utf8mb4_general_ci DEFAULT '' COMMENT '参数键名',
  `config_value` varchar(500) COLLATE utf8mb4_general_ci DEFAULT '' COMMENT '参数键值',
  `config_type` char(1) COLLATE utf8mb4_general_ci DEFAULT 'N' COMMENT '系统内置（Y是 N否）',
  `create_by` varchar(64) COLLATE utf8mb4_general_ci DEFAULT '' COMMENT '创建者',
  `create_time` datetime DEFAULT NULL COMMENT '创建时间',
  `update_by` varchar(64) COLLATE utf8mb4_general_ci DEFAULT '' COMMENT '更新者',
  `update_time` datetime DEFAULT NULL COMMENT '更新时间',
  `remark` varchar(500) COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '备注',
  PRIMARY KEY (`config_id`)
) ENGINE=InnoDB AUTO_INCREMENT=100 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='参数配置表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `sys_config`
--

LOCK TABLES `sys_config` WRITE;
/*!40000 ALTER TABLE `sys_config` DISABLE KEYS */;
INSERT INTO `sys_config` VALUES (1,'主框架页-默认皮肤样式名称','sys.index.skinName','skin-blue','Y','admin','2026-10-02 14:30:22','',NULL,'蓝色 skin-blue、绿色 skin-green、紫色 skin-purple、红色 skin-red、黄色 skin-yellow'),(2,'用户管理-账号初始密码','sys.user.initPassword','123456','Y','admin','2026-10-02 14:30:22','',NULL,'初始化密码 123456'),(3,'主框架页-侧边栏主题','sys.index.sideTheme','theme-dark','Y','admin','2026-10-02 14:30:22','',NULL,'深色主题theme-dark，浅色主题theme-light'),(4,'账号自助-验证码开关','sys.account.captchaEnabled','true','Y','admin','2026-10-02 14:30:22','',NULL,'是否开启验证码功能（true开启，false关闭）'),(5,'账号自助-是否开启用户注册功能','sys.account.registerUser','false','Y','admin','2026-10-02 14:30:22','',NULL,'是否开启注册用户功能（true开启，false关闭）'),(6,'用户登录-黑名单列表','sys.login.blackIPList','','Y','admin','2026-10-02 14:30:22','',NULL,'设置登录IP黑名单限制，多个匹配项以;分隔，支持匹配（*通配、网段）'),(7,'用户管理-初始密码修改策略','sys.account.initPasswordModify','1','Y','admin','2026-10-02 14:30:22','',NULL,'0：初始密码修改策略关闭，没有任何提示，1：提醒用户，如果未修改初始密码，则在登录时就会提醒修改密码对话框'),(8,'用户管理-账号密码更新周期','sys.account.passwordValidateDays','0','Y','admin','2026-10-02 14:30:22','',NULL,'密码更新周期（填写数字，数据初始化值为0不限制，若修改必须为大于0小于365的正整数），如果超过这个周期登录系统时，则在登录时就会提醒修改密码对话框'),(9,'用户管理-密码字符范围','sys.account.chrtype','0','Y','admin','2026-10-02 14:30:22','',NULL,'默认任意字符范围，0任意（密码可以输入任意字符），1数字（密码只能为0-9数字），2英文字母（密码只能为a-z和A-Z字母），3字母和数字（密码必须包含字母，数字）,4字母数字和特殊字符（目前支持的特殊字符包括：~!@#$%^&*()-=_+）');
/*!40000 ALTER TABLE `sys_config` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `sys_dict_data`
--

DROP TABLE IF EXISTS `sys_dict_data`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sys_dict_data` (
  `dict_code` bigint NOT NULL AUTO_INCREMENT COMMENT '字典编码',
  `dict_sort` int DEFAULT '0' COMMENT '字典排序',
  `dict_label` varchar(100) COLLATE utf8mb4_general_ci DEFAULT '' COMMENT '字典标签',
  `dict_value` varchar(100) COLLATE utf8mb4_general_ci DEFAULT '' COMMENT '字典键值',
  `dict_type` varchar(100) COLLATE utf8mb4_general_ci DEFAULT '' COMMENT '字典类型',
  `css_class` varchar(100) COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '样式属性（其他样式扩展）',
  `list_class` varchar(100) COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '表格回显样式',
  `is_default` char(1) COLLATE utf8mb4_general_ci DEFAULT 'N' COMMENT '是否默认（Y是 N否）',
  `status` char(1) COLLATE utf8mb4_general_ci DEFAULT '0' COMMENT '状态（0正常 1停用）',
  `create_by` varchar(64) COLLATE utf8mb4_general_ci DEFAULT '' COMMENT '创建者',
  `create_time` datetime DEFAULT NULL COMMENT '创建时间',
  `update_by` varchar(64) COLLATE utf8mb4_general_ci DEFAULT '' COMMENT '更新者',
  `update_time` datetime DEFAULT NULL COMMENT '更新时间',
  `remark` varchar(500) COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '备注',
  PRIMARY KEY (`dict_code`)
) ENGINE=InnoDB AUTO_INCREMENT=182 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='字典数据表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `sys_dict_data`
--

LOCK TABLES `sys_dict_data` WRITE;
/*!40000 ALTER TABLE `sys_dict_data` DISABLE KEYS */;
INSERT INTO `sys_dict_data` VALUES (2,2,'女','1','sys_user_sex','','','N','0','admin','2026-10-02 14:30:22','',NULL,'性别女'),(3,3,'未知','2','sys_user_sex','','','N','0','admin','2026-10-02 14:30:22','',NULL,'性别未知'),(4,1,'显示','0','sys_show_hide','','primary','Y','0','admin','2026-10-02 14:30:22','',NULL,'显示菜单'),(5,2,'隐藏','1','sys_show_hide','','danger','N','0','admin','2026-10-02 14:30:22','',NULL,'隐藏菜单'),(6,1,'正常','0','sys_normal_disable','','primary','Y','0','admin','2026-10-02 14:30:22','',NULL,'正常状态'),(7,2,'停用','1','sys_normal_disable','','danger','N','0','admin','2026-10-02 14:30:22','',NULL,'停用状态'),(8,1,'正常','0','sys_job_status','','primary','Y','0','admin','2026-10-02 14:30:22','',NULL,'正常状态'),(9,2,'暂停','1','sys_job_status','','danger','N','0','admin','2026-10-02 14:30:22','',NULL,'停用状态'),(10,1,'默认','DEFAULT','sys_job_group','','','Y','0','admin','2026-10-02 14:30:22','',NULL,'默认分组'),(11,2,'系统','SYSTEM','sys_job_group','','','N','0','admin','2026-10-02 14:30:22','',NULL,'系统分组'),(12,1,'是','Y','sys_yes_no','','primary','Y','0','admin','2026-10-02 14:30:22','',NULL,'系统默认是'),(13,2,'否','N','sys_yes_no','','danger','N','0','admin','2026-10-02 14:30:22','',NULL,'系统默认否'),(14,1,'通知','1','sys_notice_type','','warning','Y','0','admin','2026-10-02 14:30:22','',NULL,'通知'),(15,2,'公告','2','sys_notice_type','','success','N','0','admin','2026-10-02 14:30:22','',NULL,'公告'),(16,1,'正常','0','sys_notice_status','','primary','Y','0','admin','2026-10-02 14:30:22','',NULL,'正常状态'),(17,2,'关闭','1','sys_notice_status','','danger','N','0','admin','2026-10-02 14:30:22','',NULL,'关闭状态'),(18,99,'其他','0','sys_oper_type','','info','N','0','admin','2026-10-02 14:30:22','',NULL,'其他操作'),(19,1,'新增','1','sys_oper_type','','info','N','0','admin','2026-10-02 14:30:22','',NULL,'新增操作'),(20,2,'修改','2','sys_oper_type','','info','N','0','admin','2026-10-02 14:30:22','',NULL,'修改操作'),(21,3,'删除','3','sys_oper_type','','danger','N','0','admin','2026-10-02 14:30:22','',NULL,'删除操作'),(22,4,'授权','4','sys_oper_type','','primary','N','0','admin','2026-10-02 14:30:22','',NULL,'授权操作'),(23,5,'导出','5','sys_oper_type','','warning','N','0','admin','2026-10-02 14:30:22','',NULL,'导出操作'),(24,6,'导入','6','sys_oper_type','','warning','N','0','admin','2026-10-02 14:30:22','',NULL,'导入操作'),(25,7,'强退','7','sys_oper_type','','danger','N','0','admin','2026-10-02 14:30:22','',NULL,'强退操作'),(26,8,'生成代码','8','sys_oper_type','','warning','N','0','admin','2026-10-02 14:30:22','',NULL,'生成操作'),(27,9,'清空数据','9','sys_oper_type','','danger','N','0','admin','2026-10-02 14:30:22','',NULL,'清空操作'),(28,1,'成功','0','sys_common_status','','primary','N','0','admin','2026-10-02 14:30:22','',NULL,'正常状态'),(29,2,'失败','1','sys_common_status','','danger','N','0','admin','2026-10-02 14:30:22','',NULL,'停用状态'),(100,1,'待处理','pending','repair_order_status','','warning','Y','0','admin','2026-10-02 14:30:24','',NULL,'报修已提交，等待物业审核'),(101,2,'已派单','assigned','repair_order_status','','primary','N','0','admin','2026-10-02 14:30:24','',NULL,'物业已指派维修员'),(102,3,'已接单','accepted','repair_order_status','','info','N','0','admin','2026-10-02 14:30:24','',NULL,'维修员已确认接单'),(103,4,'已到场','arrived','repair_order_status','','info','N','0','admin','2026-10-02 14:30:24','',NULL,'维修员已到达现场'),(104,5,'维修中','repairing','repair_order_status','','info','N','0','admin','2026-10-02 14:30:24','',NULL,'正在排查与维修'),(105,6,'已修复','repaired','repair_order_status','','success','N','0','admin','2026-10-02 14:30:24','',NULL,'维修完成，等待业主确认'),(106,7,'已完成','confirmed','repair_order_status','','success','N','0','admin','2026-10-02 14:30:24','',NULL,'业主已确认，工单闭环'),(107,8,'已驳回','rejected','repair_order_status','','danger','N','0','admin','2026-10-02 14:30:24','',NULL,'物业驳回，待业主补充'),(108,9,'已申诉','appealed','repair_order_status','','danger','N','0','admin','2026-10-02 14:30:24','',NULL,'业主对结果不满意，转物业处理'),(110,1,'紧急','0','fault_level','','danger','N','0','admin','2026-10-02 14:30:24','',NULL,'困人、停梯、溜梯等危及人身安全的情形'),(111,2,'一般','1','fault_level','','warning','N','0','admin','2026-10-02 14:30:24','',NULL,'异响、按键失灵、照明故障等不影响安全的情形'),(120,1,'异响','abnormal_noise','fault_type','','','N','0','admin','2026-10-02 14:30:24','',NULL,''),(121,2,'停梯','stop','fault_type','','','N','0','admin','2026-10-02 14:30:24','',NULL,''),(122,3,'困人','trapped','fault_type','','','N','0','admin','2026-10-02 14:30:24','',NULL,''),(123,4,'门故障','door','fault_type','','','N','0','admin','2026-10-02 14:30:24','',NULL,''),(124,5,'按钮失灵','button','fault_type','','','N','0','admin','2026-10-02 14:30:24','',NULL,''),(125,6,'其他','other','fault_type','','','N','0','admin','2026-10-02 14:30:24','',NULL,''),(130,1,'半月保','half_month','maintain_type','','','N','0','admin','2026-10-02 14:30:24','',NULL,'每15天一次'),(131,2,'季度检','quarter','maintain_type','','','N','0','admin','2026-10-02 14:30:24','',NULL,'每90天一次'),(132,3,'半年保','half_year','maintain_type','','','N','0','admin','2026-10-02 14:30:24','',NULL,'每180天一次'),(133,4,'年检','annual','maintain_type','','','N','0','admin','2026-10-02 14:30:24','',NULL,'每365天一次'),(140,1,'正常运行','0','elevator_status','','success','N','0','admin','2026-10-02 14:30:24','',NULL,''),(141,2,'停梯检修','1','elevator_status','','warning','N','0','admin','2026-10-02 14:30:24','',NULL,''),(142,3,'已报废','2','elevator_status','','danger','N','0','admin','2026-10-02 14:30:24','',NULL,''),(150,1,'提交报修','report','order_operation','','','N','0','admin','2026-10-02 14:30:24','',NULL,''),(151,2,'驳回','reject','order_operation','','','N','0','admin','2026-10-02 14:30:24','',NULL,''),(152,3,'派单','assign','order_operation','','','N','0','admin','2026-10-02 14:30:24','',NULL,''),(153,4,'接单','accept','order_operation','','','N','0','admin','2026-10-02 14:30:24','',NULL,''),(154,5,'到场','arrive','order_operation','','','N','0','admin','2026-10-02 14:30:24','',NULL,''),(155,6,'排查','investigate','order_operation','','','N','0','admin','2026-10-02 14:30:24','',NULL,''),(156,7,'维修完成','finish','order_operation','','','N','0','admin','2026-10-02 14:30:24','',NULL,''),(157,8,'业主确认','confirm','order_operation','','','N','0','admin','2026-10-02 14:30:24','',NULL,''),(158,9,'申诉','appeal','order_operation','','','N','0','admin','2026-10-02 14:30:24','',NULL,''),(159,10,'重新指派','reassign','order_operation','','','N','0','admin','2026-10-02 14:30:24','',NULL,''),(160,11,'升级处理','escalate','order_operation','','','N','0','admin','2026-10-02 14:30:24','',NULL,''),(170,1,'优秀','excellent','health_level','','success','N','0','admin','2026-10-02 14:30:24','',NULL,'90分及以上'),(171,2,'良好','good','health_level','','success','N','0','admin','2026-10-02 14:30:24','',NULL,'80-89分'),(172,3,'一般','fair','health_level','','warning','N','0','admin','2026-10-02 14:30:24','',NULL,'70-79分'),(173,4,'较差','poor','health_level','','warning','N','0','admin','2026-10-02 14:30:24','',NULL,'60-69分'),(174,5,'危险','danger','health_level','','danger','N','0','admin','2026-10-02 14:30:24','',NULL,'60分以下'),(180,1,'工单超时','order_timeout','warning_type','','warning','N','0','admin','2026-10-02 14:30:24','',NULL,''),(181,2,'维保临期','maintain_due','warning_type','','warning','N','0','admin','2026-10-02 14:30:24','',NULL,'');
/*!40000 ALTER TABLE `sys_dict_data` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `sys_dict_type`
--

DROP TABLE IF EXISTS `sys_dict_type`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sys_dict_type` (
  `dict_id` bigint NOT NULL AUTO_INCREMENT COMMENT '字典主键',
  `dict_name` varchar(100) COLLATE utf8mb4_general_ci DEFAULT '' COMMENT '字典名称',
  `dict_type` varchar(100) COLLATE utf8mb4_general_ci DEFAULT '' COMMENT '字典类型',
  `status` char(1) COLLATE utf8mb4_general_ci DEFAULT '0' COMMENT '状态（0正常 1停用）',
  `create_by` varchar(64) COLLATE utf8mb4_general_ci DEFAULT '' COMMENT '创建者',
  `create_time` datetime DEFAULT NULL COMMENT '创建时间',
  `update_by` varchar(64) COLLATE utf8mb4_general_ci DEFAULT '' COMMENT '更新者',
  `update_time` datetime DEFAULT NULL COMMENT '更新时间',
  `remark` varchar(500) COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '备注',
  PRIMARY KEY (`dict_id`),
  UNIQUE KEY `dict_type` (`dict_type`)
) ENGINE=InnoDB AUTO_INCREMENT=108 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='字典类型表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `sys_dict_type`
--

LOCK TABLES `sys_dict_type` WRITE;
/*!40000 ALTER TABLE `sys_dict_type` DISABLE KEYS */;
INSERT INTO `sys_dict_type` VALUES (1,'用户性别','sys_user_sex','0','admin','2026-10-02 14:30:22','',NULL,'用户性别列表'),(2,'菜单状态','sys_show_hide','0','admin','2026-10-02 14:30:22','',NULL,'菜单状态列表'),(3,'系统开关','sys_normal_disable','0','admin','2026-10-02 14:30:22','',NULL,'系统开关列表'),(4,'任务状态','sys_job_status','0','admin','2026-10-02 14:30:22','',NULL,'任务状态列表'),(5,'任务分组','sys_job_group','0','admin','2026-10-02 14:30:22','',NULL,'任务分组列表'),(6,'系统是否','sys_yes_no','0','admin','2026-10-02 14:30:22','',NULL,'系统是否列表'),(7,'通知类型','sys_notice_type','0','admin','2026-10-02 14:30:22','',NULL,'通知类型列表'),(8,'通知状态','sys_notice_status','0','admin','2026-10-02 14:30:22','',NULL,'通知状态列表'),(9,'操作类型','sys_oper_type','0','admin','2026-10-02 14:30:22','',NULL,'操作类型列表'),(10,'系统状态','sys_common_status','0','admin','2026-10-02 14:30:22','',NULL,'登录状态列表'),(100,'工单状态','repair_order_status','0','admin','2026-10-02 14:30:24','',NULL,'报修工单状态列表'),(101,'故障等级','fault_level','0','admin','2026-10-02 14:30:24','',NULL,'故障等级列表'),(102,'故障类型','fault_type','0','admin','2026-10-02 14:30:24','',NULL,'故障现象类型列表'),(103,'维保类型','maintain_type','0','admin','2026-10-02 14:30:24','',NULL,'维保类型列表'),(104,'电梯状态','elevator_status','0','admin','2026-10-02 14:30:24','',NULL,'电梯状态列表'),(105,'工单操作类型','order_operation','0','admin','2026-10-02 14:30:24','',NULL,'工单状态流转操作类型'),(106,'健康等级','health_level','0','admin','2026-10-02 14:30:24','',NULL,'电梯健康等级列表'),(107,'预警类型','warning_type','0','admin','2026-10-02 14:30:24','',NULL,'预警类型列表');
/*!40000 ALTER TABLE `sys_dict_type` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `sys_file`
--

DROP TABLE IF EXISTS `sys_file`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sys_file` (
  `file_id` bigint NOT NULL AUTO_INCREMENT COMMENT '文件ID',
  `file_name` varchar(200) COLLATE utf8mb4_general_ci NOT NULL COMMENT '原文件名',
  `file_path` varchar(500) COLLATE utf8mb4_general_ci NOT NULL COMMENT '存储路径',
  `file_url` varchar(500) COLLATE utf8mb4_general_ci DEFAULT '' COMMENT '访问地址',
  `file_type` varchar(20) COLLATE utf8mb4_general_ci DEFAULT '' COMMENT '文件类型（image图片 video视频 doc文档 excel表格 pdf文档）',
  `file_suffix` varchar(20) COLLATE utf8mb4_general_ci DEFAULT '' COMMENT '文件后缀',
  `file_size` bigint DEFAULT '0' COMMENT '文件大小（字节）',
  `biz_type` varchar(30) COLLATE utf8mb4_general_ci DEFAULT '' COMMENT '业务类型（elevator_cert电梯证件 repair_evidence报修证据 inspection巡检结果 report导出报表）',
  `biz_id` bigint DEFAULT NULL COMMENT '关联业务ID',
  `upload_by` varchar(64) COLLATE utf8mb4_general_ci DEFAULT '' COMMENT '上传人',
  `upload_time` datetime DEFAULT NULL COMMENT '上传时间',
  `del_flag` char(1) COLLATE utf8mb4_general_ci DEFAULT '0' COMMENT '删除标志（0代表存在 2代表删除）',
  PRIMARY KEY (`file_id`),
  KEY `idx_file_biz` (`biz_type`,`biz_id`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='文件信息表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `sys_file`
--

LOCK TABLES `sys_file` WRITE;
/*!40000 ALTER TABLE `sys_file` DISABLE KEYS */;
INSERT INTO `sys_file` VALUES (1,'_ev.png','/profile/upload/repair_evidence/2026/10/02/_ev_20261002195906A001.png','E:/Desktop/2023毕设/董/项目/backend/uploadPath','image','png',68,'repair_evidence',NULL,'yezhu01','2026-10-02 19:59:06','2'),(2,'0cc73a4c785b32a8261614e183df83d5.jpg','/profile/upload/repair_evidence/2026/10/02/0cc73a4c785b32a8261614e183df83d5_20261002210849A001.jpg','E:/Desktop/2023毕设/董/项目/backend/uploadPath','image','jpg',193994,'repair_evidence',NULL,'yezhu01','2026-10-02 21:08:49','0');
/*!40000 ALTER TABLE `sys_file` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `sys_job`
--

DROP TABLE IF EXISTS `sys_job`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sys_job` (
  `job_id` bigint NOT NULL AUTO_INCREMENT COMMENT '任务ID',
  `job_name` varchar(64) COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '任务名称',
  `job_group` varchar(64) COLLATE utf8mb4_general_ci NOT NULL DEFAULT 'DEFAULT' COMMENT '任务组名',
  `invoke_target` varchar(500) COLLATE utf8mb4_general_ci NOT NULL COMMENT '调用目标字符串',
  `cron_expression` varchar(255) COLLATE utf8mb4_general_ci DEFAULT '' COMMENT 'cron执行表达式',
  `misfire_policy` varchar(20) COLLATE utf8mb4_general_ci DEFAULT '3' COMMENT '计划执行错误策略（1立即执行 2执行一次 3放弃执行）',
  `concurrent` char(1) COLLATE utf8mb4_general_ci DEFAULT '1' COMMENT '是否并发执行（0允许 1禁止）',
  `status` char(1) COLLATE utf8mb4_general_ci DEFAULT '0' COMMENT '状态（0正常 1暂停）',
  `create_by` varchar(64) COLLATE utf8mb4_general_ci DEFAULT '' COMMENT '创建者',
  `create_time` datetime DEFAULT NULL COMMENT '创建时间',
  `update_by` varchar(64) COLLATE utf8mb4_general_ci DEFAULT '' COMMENT '更新者',
  `update_time` datetime DEFAULT NULL COMMENT '更新时间',
  `remark` varchar(500) COLLATE utf8mb4_general_ci DEFAULT '' COMMENT '备注信息',
  PRIMARY KEY (`job_id`,`job_name`,`job_group`)
) ENGINE=InnoDB AUTO_INCREMENT=103 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='定时任务调度表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `sys_job`
--

LOCK TABLES `sys_job` WRITE;
/*!40000 ALTER TABLE `sys_job` DISABLE KEYS */;
INSERT INTO `sys_job` VALUES (1,'系统默认（无参）','DEFAULT','ryTask.ryNoParams','0/10 * * * * ?','3','1','1','admin','2026-10-02 14:30:23','',NULL,''),(2,'系统默认（有参）','DEFAULT','ryTask.ryParams(\'ry\')','0/15 * * * * ?','3','1','1','admin','2026-10-02 14:30:23','',NULL,''),(3,'系统默认（多参）','DEFAULT','ryTask.ryMultipleParams(\'ry\', true, 2000L, 316.50D, 100)','0/20 * * * * ?','3','1','1','admin','2026-10-02 14:30:23','',NULL,''),(100,'巡检工单自动生成','DEFAULT','inspectionGenerateTask.execute()','0 0 1 * * ?','3','1','0','admin','2026-10-02 14:30:24','',NULL,'每日 01:00 扫描到期维保计划，自动生成巡检工单并标记超期任务'),(101,'超期预警扫描','DEFAULT','warningScanTask.execute()','0 0/30 * * * ?','3','1','0','admin','2026-10-02 14:30:24','',NULL,'每 30 分钟扫描工单超时与维保临期，按启用规则生成预警并推送'),(102,'电梯健康评分重算','DEFAULT','healthScoreTask.execute()','0 0 2 * * ?','3','1','0','admin','2026-10-02 14:30:24','',NULL,'每日 02:00 按统计周期重算全部电梯的健康评分');
/*!40000 ALTER TABLE `sys_job` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `sys_job_log`
--

DROP TABLE IF EXISTS `sys_job_log`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sys_job_log` (
  `job_log_id` bigint NOT NULL AUTO_INCREMENT COMMENT '任务日志ID',
  `job_name` varchar(64) COLLATE utf8mb4_general_ci NOT NULL COMMENT '任务名称',
  `job_group` varchar(64) COLLATE utf8mb4_general_ci NOT NULL COMMENT '任务组名',
  `invoke_target` varchar(500) COLLATE utf8mb4_general_ci NOT NULL COMMENT '调用目标字符串',
  `job_message` varchar(500) COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '日志信息',
  `status` char(1) COLLATE utf8mb4_general_ci DEFAULT '0' COMMENT '执行状态（0正常 1失败）',
  `exception_info` varchar(2000) COLLATE utf8mb4_general_ci DEFAULT '' COMMENT '异常信息',
  `start_time` datetime DEFAULT NULL COMMENT '执行开始时间',
  `end_time` datetime DEFAULT NULL COMMENT '执行结束时间',
  `create_time` datetime DEFAULT NULL COMMENT '创建时间',
  PRIMARY KEY (`job_log_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='定时任务调度日志表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `sys_job_log`
--

LOCK TABLES `sys_job_log` WRITE;
/*!40000 ALTER TABLE `sys_job_log` DISABLE KEYS */;
/*!40000 ALTER TABLE `sys_job_log` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `sys_logininfor`
--

DROP TABLE IF EXISTS `sys_logininfor`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sys_logininfor` (
  `info_id` bigint NOT NULL AUTO_INCREMENT COMMENT '访问ID',
  `user_name` varchar(50) COLLATE utf8mb4_general_ci DEFAULT '' COMMENT '用户账号',
  `ipaddr` varchar(128) COLLATE utf8mb4_general_ci DEFAULT '' COMMENT '登录IP地址',
  `login_location` varchar(255) COLLATE utf8mb4_general_ci DEFAULT '' COMMENT '登录地点',
  `browser` varchar(50) COLLATE utf8mb4_general_ci DEFAULT '' COMMENT '浏览器类型',
  `os` varchar(50) COLLATE utf8mb4_general_ci DEFAULT '' COMMENT '操作系统',
  `status` char(1) COLLATE utf8mb4_general_ci DEFAULT '0' COMMENT '登录状态（0成功 1失败）',
  `msg` varchar(255) COLLATE utf8mb4_general_ci DEFAULT '' COMMENT '提示消息',
  `login_time` datetime DEFAULT NULL COMMENT '访问时间',
  PRIMARY KEY (`info_id`),
  KEY `idx_sys_logininfor_s` (`status`),
  KEY `idx_sys_logininfor_lt` (`login_time`)
) ENGINE=InnoDB AUTO_INCREMENT=91 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='系统访问记录';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `sys_logininfor`
--

LOCK TABLES `sys_logininfor` WRITE;
/*!40000 ALTER TABLE `sys_logininfor` DISABLE KEYS */;
INSERT INTO `sys_logininfor` VALUES (1,NULL,'127.0.0.1','内网IP','Python-urllib 3.11','','1','验证码已失效','2026-10-11 14:01:57'),(2,'admin','127.0.0.1','内网IP','Python-urllib 3.11','','0','登录成功','2026-10-11 14:01:57'),(3,'admin','127.0.0.1','内网IP','Python-urllib 3.11','','0','退出成功','2026-10-11 14:01:57'),(4,'admin','127.0.0.1','内网IP','Python-urllib 3.11','','0','登录成功','2026-10-11 14:01:58'),(5,'yezhu01','127.0.0.1','内网IP','Chrome 154.0.0.0','Windows >=10','0','登录成功','2026-10-11 14:02:03'),(6,'admin','127.0.0.1','内网IP','Python-urllib 3.11','','0','登录成功','2026-10-11 14:02:04'),(7,'wuye01','127.0.0.1','内网IP','Chrome 154.0.0.0','Windows >=10','0','登录成功','2026-10-11 14:02:06'),(8,'weixiu01','127.0.0.1','内网IP','Chrome 154.0.0.0','Windows >=10','0','登录成功','2026-10-11 14:02:08'),(9,'adminadmin','127.0.0.1','内网IP','Chrome 154.0.0.0','Windows >=10','1','用户不存在/密码错误','2026-10-11 14:02:11'),(10,NULL,'127.0.0.1','内网IP','Python-urllib 3.11','','1','验证码已失效','2026-10-11 14:02:17'),(11,'admin','127.0.0.1','内网IP','Python-urllib 3.11','','0','登录成功','2026-10-11 14:02:17'),(12,NULL,'127.0.0.1','内网IP','Python-urllib 3.11','','1','验证码已失效','2026-10-11 14:02:26'),(13,'admin','127.0.0.1','内网IP','Python-urllib 3.11','','0','登录成功','2026-10-11 14:02:26'),(14,'yezhu01','127.0.0.1','内网IP','Python-urllib 3.11','','0','登录成功','2026-10-11 14:02:29'),(15,'admin','127.0.0.1','内网IP','Python-urllib 3.11','','0','登录成功','2026-10-11 14:02:30'),(16,'wuye01','127.0.0.1','内网IP','Python-urllib 3.11','','0','登录成功','2026-10-11 14:02:31'),(17,NULL,'127.0.0.1','内网IP','Python-urllib 3.11','','1','验证码已失效','2026-10-11 14:02:37'),(18,'admin','127.0.0.1','内网IP','Python-urllib 3.11','','0','登录成功','2026-10-11 14:02:37'),(19,'adminadmin','127.0.0.1','内网IP','Chrome 154.0.0.0','Windows >=10','1','用户不存在/密码错误','2026-10-11 14:02:48'),(20,'yezhu01','127.0.0.1','内网IP','Chrome 154.0.0.0','Windows >=10','0','登录成功','2026-10-11 14:03:05'),(21,'wuye01','127.0.0.1','内网IP','Chrome 154.0.0.0','Windows >=10','0','登录成功','2026-10-11 14:03:08'),(22,'weixiu01','127.0.0.1','内网IP','Chrome 154.0.0.0','Windows >=10','0','登录成功','2026-10-11 14:03:11'),(23,'admin','127.0.0.1','内网IP','Chrome 154.0.0.0','Windows >=10','0','登录成功','2026-10-11 14:03:14'),(24,'wuye01','127.0.0.1','内网IP','Python-urllib 3.11','','0','登录成功','2026-10-11 14:03:21'),(25,'weixiu01','127.0.0.1','内网IP','Python-urllib 3.11','','0','登录成功','2026-10-11 14:03:22'),(26,'yezhu01','127.0.0.1','内网IP','Chrome 154.0.0.0','Windows >=10','0','登录成功','2026-10-11 14:03:25'),(27,'wuye01','127.0.0.1','内网IP','Chrome 154.0.0.0','Windows >=10','0','登录成功','2026-10-11 14:03:27'),(28,'weixiu01','127.0.0.1','内网IP','Chrome 154.0.0.0','Windows >=10','0','登录成功','2026-10-11 14:03:29'),(29,NULL,'127.0.0.1','内网IP','Python-urllib 3.11','','1','验证码已失效','2026-10-11 14:03:32'),(30,'admin','127.0.0.1','内网IP','Python-urllib 3.11','','0','登录成功','2026-10-11 14:03:32'),(31,NULL,'127.0.0.1','内网IP','Python-urllib 3.11','','1','验证码已失效','2026-10-11 14:03:42'),(32,'admin','127.0.0.1','内网IP','Python-urllib 3.11','','0','登录成功','2026-10-11 14:03:42'),(33,'yezhu01','127.0.0.1','内网IP','Python-urllib 3.11','','0','登录成功','2026-10-11 14:03:57'),(34,NULL,'127.0.0.1','内网IP','Python-urllib 3.11','','1','验证码已失效','2026-10-11 14:03:58'),(35,'yezhu01','127.0.0.1','内网IP','Python-urllib 3.11','','0','登录成功','2026-10-11 14:03:59'),(36,'yezhu01','127.0.0.1','内网IP','Chrome 154.0.0.0','Windows >=10','0','登录成功','2026-10-11 14:04:07'),(37,'wuye01','127.0.0.1','内网IP','Chrome 154.0.0.0','Windows >=10','0','登录成功','2026-10-11 14:04:25'),(38,'owner2test','127.0.0.1','内网IP','Python-urllib 3.11','','1','用户不存在/密码错误','2026-10-11 14:04:45'),(39,'owner2test','127.0.0.1','内网IP','Python-urllib 3.11','','1','用户不存在/密码错误','2026-10-11 14:04:45'),(40,'weixiu01','127.0.0.1','内网IP','Chrome 154.0.0.0','Windows >=10','0','登录成功','2026-10-11 14:05:08'),(41,'owner2test','127.0.0.1','内网IP','Python-urllib 3.11','','0','登录成功','2026-10-11 14:05:09'),(42,'yezhu01','127.0.0.1','内网IP','Python-urllib 3.11','','0','登录成功','2026-10-11 14:05:10'),(43,'owner2test','127.0.0.1','内网IP','Python-urllib 3.11','','1','用户不存在/密码错误','2026-10-11 14:05:10'),(44,'owner2test','127.0.0.1','内网IP','Python-urllib 3.11','','0','登录成功','2026-10-11 14:05:10'),(45,'owner2test','127.0.0.1','内网IP','Python-urllib 3.11','','1','用户不存在/密码错误','2026-10-11 14:05:23'),(46,'owner2test','127.0.0.1','内网IP','Python-urllib 3.11','','0','登录成功','2026-10-11 14:05:56'),(47,'owner2test','127.0.0.1','内网IP','Python-urllib 3.11','','0','登录成功','2026-10-11 14:05:56'),(48,'owner2test','127.0.0.1','内网IP','Python-urllib 3.11','','0','登录成功','2026-10-11 14:06:00'),(49,'owner2test','127.0.0.1','内网IP','Python-urllib 3.11','','0','登录成功','2026-10-11 14:06:00'),(50,'owner2test','127.0.0.1','内网IP','Python-urllib 3.11','','0','登录成功','2026-10-11 14:06:04'),(51,'owner2test','127.0.0.1','内网IP','Python-urllib 3.11','','0','登录成功','2026-10-11 14:06:04'),(52,'owner2test','127.0.0.1','内网IP','Python-urllib 3.11','','0','登录成功','2026-10-11 14:06:07'),(53,'owner2test','127.0.0.1','内网IP','Python-urllib 3.11','','0','登录成功','2026-10-11 14:06:07'),(54,'owner2test','127.0.0.1','内网IP','Python-urllib 3.11','','0','登录成功','2026-10-11 14:06:11'),(55,'owner2test','127.0.0.1','内网IP','Python-urllib 3.11','','0','登录成功','2026-10-11 14:06:11'),(56,'owner2test','127.0.0.1','内网IP','Python-urllib 3.11','','0','登录成功','2026-10-11 14:06:15'),(57,'owner2test','127.0.0.1','内网IP','Python-urllib 3.11','','0','登录成功','2026-10-11 14:06:15'),(58,'owner2test','127.0.0.1','内网IP','Python-urllib 3.11','','0','登录成功','2026-10-11 14:06:18'),(59,'owner2test','127.0.0.1','内网IP','Python-urllib 3.11','','0','登录成功','2026-10-11 14:06:19'),(60,'owner2test','127.0.0.1','内网IP','Python-urllib 3.11','','0','登录成功','2026-10-11 14:06:22'),(61,'owner2test','127.0.0.1','内网IP','Python-urllib 3.11','','0','登录成功','2026-10-11 14:06:22'),(62,'owner2test','127.0.0.1','内网IP','Python-urllib 3.11','','1','用户不存在/密码错误','2026-10-11 14:06:37'),(63,'owner2test','127.0.0.1','内网IP','Python-urllib 3.11','','1','用户不存在/密码错误','2026-10-11 14:06:47'),(64,'owner2test','127.0.0.1','内网IP','Python-urllib 3.11','','0','登录成功','2026-10-11 14:06:47'),(65,'owner2test','127.0.0.1','内网IP','Python-urllib 3.11','','1','用户不存在/密码错误','2026-10-11 14:06:49'),(66,'owner2test','127.0.0.1','内网IP','Python-urllib 3.11','','0','登录成功','2026-10-11 14:06:49'),(67,'owner2test','127.0.0.1','内网IP','Python-urllib 3.11','','1','用户不存在/密码错误','2026-10-11 14:06:52'),(68,'owner2test','127.0.0.1','内网IP','Python-urllib 3.11','','0','登录成功','2026-10-11 14:06:52'),(69,'owner2test','127.0.0.1','内网IP','Python-urllib 3.11','','1','用户不存在/密码错误','2026-10-11 14:06:54'),(70,'owner2test','127.0.0.1','内网IP','Python-urllib 3.11','','0','登录成功','2026-10-11 14:06:54'),(71,'owner2test','127.0.0.1','内网IP','Python-urllib 3.11','','0','登录成功','2026-10-11 14:07:19'),(72,'yezhu01','127.0.0.1','内网IP','Python-urllib 3.11','','0','登录成功','2026-10-11 14:07:19'),(73,'weixiu03','127.0.0.1','内网IP','Python-urllib 3.11','','0','登录成功','2026-10-11 14:07:20'),(74,'wuye01','127.0.0.1','内网IP','Python-urllib 3.11','','0','登录成功','2026-10-11 14:07:21'),(75,'admin','127.0.0.1','内网IP','Chrome 154.0.0.0','Windows >=10','0','登录成功','2026-10-11 14:07:49'),(76,'yezhu01','127.0.0.1','内网IP','Python-urllib 3.11','','0','登录成功','2026-10-11 14:08:15'),(77,'admin','127.0.0.1','内网IP','Python-urllib 3.11','','0','登录成功','2026-10-11 14:08:17'),(78,'admin','127.0.0.1','内网IP','Python-urllib 3.11','','0','登录成功','2026-10-11 14:08:17'),(79,'wuye01','127.0.0.1','内网IP','Python-urllib 3.11','','0','登录成功','2026-10-11 14:08:37'),(80,'weixiu01','127.0.0.1','内网IP','Python-urllib 3.11','','0','登录成功','2026-10-11 14:08:37'),(81,'yezhu01','127.0.0.1','内网IP','Python-urllib 3.11','','0','登录成功','2026-10-11 14:08:38'),(82,'admin','127.0.0.1','内网IP','Python-urllib 3.11','','0','登录成功','2026-10-11 14:08:40'),(83,'yezhu01','127.0.0.1','内网IP','Python-urllib 3.11','','0','登录成功','2026-10-11 14:08:59'),(84,'weixiu01','127.0.0.1','内网IP','Python-urllib 3.11','','0','登录成功','2026-10-11 14:09:00'),(85,'wuye01','127.0.0.1','内网IP','Python-urllib 3.11','','0','登录成功','2026-10-11 14:09:01'),(86,'admin','127.0.0.1','内网IP','Chrome 154','Windows10','1','验证码错误','2026-10-11 14:09:18'),(87,'admin','127.0.0.1','内网IP','Chrome 154','Windows10','1','验证码已失效','2026-10-11 14:09:28'),(88,'admin','127.0.0.1','内网IP','Chrome 154','Windows10','0','登录成功','2026-10-11 14:09:39'),(89,NULL,'127.0.0.1','内网IP','Python-urllib 3.11','','1','验证码已失效','2026-10-11 14:11:11'),(90,'weixiu01','127.0.0.1','内网IP','Python-urllib 3.11','','0','登录成功','2026-10-11 14:11:11');
/*!40000 ALTER TABLE `sys_logininfor` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `sys_menu`
--

DROP TABLE IF EXISTS `sys_menu`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sys_menu` (
  `menu_id` bigint NOT NULL AUTO_INCREMENT COMMENT '菜单ID',
  `menu_name` varchar(50) COLLATE utf8mb4_general_ci NOT NULL COMMENT '菜单名称',
  `parent_id` bigint DEFAULT '0' COMMENT '父菜单ID',
  `order_num` int DEFAULT '0' COMMENT '显示顺序',
  `path` varchar(200) COLLATE utf8mb4_general_ci DEFAULT '' COMMENT '路由地址',
  `component` varchar(255) COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '组件路径',
  `query` varchar(255) COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '路由参数',
  `route_name` varchar(50) COLLATE utf8mb4_general_ci DEFAULT '' COMMENT '路由名称',
  `is_frame` int DEFAULT '1' COMMENT '是否为外链（0是 1否）',
  `is_cache` int DEFAULT '0' COMMENT '是否缓存（0缓存 1不缓存）',
  `menu_type` char(1) COLLATE utf8mb4_general_ci DEFAULT '' COMMENT '菜单类型（M目录 C菜单 F按钮）',
  `visible` char(1) COLLATE utf8mb4_general_ci DEFAULT '0' COMMENT '菜单状态（0显示 1隐藏）',
  `status` char(1) COLLATE utf8mb4_general_ci DEFAULT '0' COMMENT '菜单状态（0正常 1停用）',
  `perms` varchar(100) COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '权限标识',
  `icon` varchar(100) COLLATE utf8mb4_general_ci DEFAULT '#' COMMENT '菜单图标',
  `create_by` varchar(64) COLLATE utf8mb4_general_ci DEFAULT '' COMMENT '创建者',
  `create_time` datetime DEFAULT NULL COMMENT '创建时间',
  `update_by` varchar(64) COLLATE utf8mb4_general_ci DEFAULT '' COMMENT '更新者',
  `update_time` datetime DEFAULT NULL COMMENT '更新时间',
  `remark` varchar(500) COLLATE utf8mb4_general_ci DEFAULT '' COMMENT '备注',
  PRIMARY KEY (`menu_id`)
) ENGINE=InnoDB AUTO_INCREMENT=2244 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='菜单权限表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `sys_menu`
--

LOCK TABLES `sys_menu` WRITE;
/*!40000 ALTER TABLE `sys_menu` DISABLE KEYS */;
INSERT INTO `sys_menu` VALUES (1,'系统管理',0,1,'system',NULL,'','',1,0,'M','0','0','','system','admin','2026-10-02 14:30:22','',NULL,'系统管理目录'),(2,'系统监控',0,2,'monitor',NULL,'','',1,0,'M','0','0','','monitor','admin','2026-10-02 14:30:22','',NULL,'系统监控目录'),(100,'用户管理',1,1,'user','system/user/index','','',1,0,'C','0','0','system:user:list','user','admin','2026-10-02 14:30:22','',NULL,'用户管理菜单'),(101,'角色管理',1,2,'role','system/role/index','','',1,0,'C','0','0','system:role:list','peoples','admin','2026-10-02 14:30:22','',NULL,'角色管理菜单'),(102,'菜单管理',1,3,'menu','system/menu/index','','',1,0,'C','0','0','system:menu:list','tree-table','admin','2026-10-02 14:30:22','',NULL,'菜单管理菜单'),(105,'字典管理',1,6,'dict','system/dict/index','','',1,0,'C','0','0','system:dict:list','dict','admin','2026-10-02 14:30:22','',NULL,'字典管理菜单'),(106,'参数设置',1,7,'config','system/config/index','','',1,0,'C','0','0','system:config:list','edit','admin','2026-10-02 14:30:22','',NULL,'参数设置菜单'),(107,'通知公告',1,8,'notice','system/notice/index','','',1,0,'C','0','0','system:notice:list','message','admin','2026-10-02 14:30:22','',NULL,'通知公告菜单'),(108,'日志管理',1,9,'log','','','',1,0,'M','0','0','','log','admin','2026-10-02 14:30:22','',NULL,'日志管理菜单'),(109,'在线用户',2,1,'online','monitor/online/index','','',1,0,'C','0','0','monitor:online:list','online','admin','2026-10-02 14:30:22','',NULL,'在线用户菜单'),(110,'定时任务',2,2,'job','monitor/job/index','','',1,0,'C','0','0','monitor:job:list','job','admin','2026-10-02 14:30:22','',NULL,'定时任务菜单'),(111,'数据监控',2,3,'druid','monitor/druid/index','','',1,0,'C','0','0','monitor:druid:list','druid','admin','2026-10-02 14:30:22','',NULL,'数据监控菜单'),(112,'服务监控',2,4,'server','monitor/server/index','','',1,0,'C','0','0','monitor:server:list','server','admin','2026-10-02 14:30:22','',NULL,'服务监控菜单'),(113,'缓存监控',2,5,'cache','monitor/cache/index','','',1,0,'C','0','0','monitor:cache:list','redis','admin','2026-10-02 14:30:22','',NULL,'缓存监控菜单'),(114,'缓存列表',2,6,'cacheList','monitor/cache/list','','',1,0,'C','0','0','monitor:cache:list','redis-list','admin','2026-10-02 14:30:22','',NULL,'缓存列表菜单'),(500,'操作日志',108,1,'operlog','monitor/operlog/index','','',1,0,'C','0','0','monitor:operlog:list','form','admin','2026-10-02 14:30:22','',NULL,'操作日志菜单'),(501,'登录日志',108,2,'logininfor','monitor/logininfor/index','','',1,0,'C','0','0','monitor:logininfor:list','logininfor','admin','2026-10-02 14:30:22','',NULL,'登录日志菜单'),(1000,'用户查询',100,1,'','','','',1,0,'F','0','0','system:user:query','#','admin','2026-10-02 14:30:22','',NULL,''),(1001,'用户新增',100,2,'','','','',1,0,'F','0','0','system:user:add','#','admin','2026-10-02 14:30:22','',NULL,''),(1002,'用户修改',100,3,'','','','',1,0,'F','0','0','system:user:edit','#','admin','2026-10-02 14:30:22','',NULL,''),(1003,'用户删除',100,4,'','','','',1,0,'F','0','0','system:user:remove','#','admin','2026-10-02 14:30:22','',NULL,''),(1004,'用户导出',100,5,'','','','',1,0,'F','0','0','system:user:export','#','admin','2026-10-02 14:30:22','',NULL,''),(1005,'用户导入',100,6,'','','','',1,0,'F','0','0','system:user:import','#','admin','2026-10-02 14:30:22','',NULL,''),(1006,'重置密码',100,7,'','','','',1,0,'F','0','0','system:user:resetPwd','#','admin','2026-10-02 14:30:22','',NULL,''),(1007,'角色查询',101,1,'','','','',1,0,'F','0','0','system:role:query','#','admin','2026-10-02 14:30:22','',NULL,''),(1008,'角色新增',101,2,'','','','',1,0,'F','0','0','system:role:add','#','admin','2026-10-02 14:30:22','',NULL,''),(1009,'角色修改',101,3,'','','','',1,0,'F','0','0','system:role:edit','#','admin','2026-10-02 14:30:22','',NULL,''),(1010,'角色删除',101,4,'','','','',1,0,'F','0','0','system:role:remove','#','admin','2026-10-02 14:30:22','',NULL,''),(1011,'角色导出',101,5,'','','','',1,0,'F','0','0','system:role:export','#','admin','2026-10-02 14:30:22','',NULL,''),(1012,'菜单查询',102,1,'','','','',1,0,'F','0','0','system:menu:query','#','admin','2026-10-02 14:30:22','',NULL,''),(1013,'菜单新增',102,2,'','','','',1,0,'F','0','0','system:menu:add','#','admin','2026-10-02 14:30:22','',NULL,''),(1014,'菜单修改',102,3,'','','','',1,0,'F','0','0','system:menu:edit','#','admin','2026-10-02 14:30:22','',NULL,''),(1015,'菜单删除',102,4,'','','','',1,0,'F','0','0','system:menu:remove','#','admin','2026-10-02 14:30:22','',NULL,''),(1025,'字典查询',105,1,'#','','','',1,0,'F','0','0','system:dict:query','#','admin','2026-10-02 14:30:22','',NULL,''),(1026,'字典新增',105,2,'#','','','',1,0,'F','0','0','system:dict:add','#','admin','2026-10-02 14:30:22','',NULL,''),(1027,'字典修改',105,3,'#','','','',1,0,'F','0','0','system:dict:edit','#','admin','2026-10-02 14:30:22','',NULL,''),(1028,'字典删除',105,4,'#','','','',1,0,'F','0','0','system:dict:remove','#','admin','2026-10-02 14:30:22','',NULL,''),(1029,'字典导出',105,5,'#','','','',1,0,'F','0','0','system:dict:export','#','admin','2026-10-02 14:30:22','',NULL,''),(1030,'参数查询',106,1,'#','','','',1,0,'F','0','0','system:config:query','#','admin','2026-10-02 14:30:22','',NULL,''),(1031,'参数新增',106,2,'#','','','',1,0,'F','0','0','system:config:add','#','admin','2026-10-02 14:30:22','',NULL,''),(1032,'参数修改',106,3,'#','','','',1,0,'F','0','0','system:config:edit','#','admin','2026-10-02 14:30:22','',NULL,''),(1033,'参数删除',106,4,'#','','','',1,0,'F','0','0','system:config:remove','#','admin','2026-10-02 14:30:22','',NULL,''),(1034,'参数导出',106,5,'#','','','',1,0,'F','0','0','system:config:export','#','admin','2026-10-02 14:30:22','',NULL,''),(1035,'公告查询',107,1,'#','','','',1,0,'F','0','0','system:notice:query','#','admin','2026-10-02 14:30:22','',NULL,''),(1036,'公告新增',107,2,'#','','','',1,0,'F','0','0','system:notice:add','#','admin','2026-10-02 14:30:22','',NULL,''),(1037,'公告修改',107,3,'#','','','',1,0,'F','0','0','system:notice:edit','#','admin','2026-10-02 14:30:22','',NULL,''),(1038,'公告删除',107,4,'#','','','',1,0,'F','0','0','system:notice:remove','#','admin','2026-10-02 14:30:22','',NULL,''),(1039,'操作查询',500,1,'#','','','',1,0,'F','0','0','monitor:operlog:query','#','admin','2026-10-02 14:30:22','',NULL,''),(1040,'操作删除',500,2,'#','','','',1,0,'F','0','0','monitor:operlog:remove','#','admin','2026-10-02 14:30:22','',NULL,''),(1041,'日志导出',500,3,'#','','','',1,0,'F','0','0','monitor:operlog:export','#','admin','2026-10-02 14:30:22','',NULL,''),(1042,'登录查询',501,1,'#','','','',1,0,'F','0','0','monitor:logininfor:query','#','admin','2026-10-02 14:30:22','',NULL,''),(1043,'登录删除',501,2,'#','','','',1,0,'F','0','0','monitor:logininfor:remove','#','admin','2026-10-02 14:30:22','',NULL,''),(1044,'日志导出',501,3,'#','','','',1,0,'F','0','0','monitor:logininfor:export','#','admin','2026-10-02 14:30:22','',NULL,''),(1045,'账户解锁',501,4,'#','','','',1,0,'F','0','0','monitor:logininfor:unlock','#','admin','2026-10-02 14:30:22','',NULL,''),(1046,'在线查询',109,1,'#','','','',1,0,'F','0','0','monitor:online:query','#','admin','2026-10-02 14:30:22','',NULL,''),(1047,'批量强退',109,2,'#','','','',1,0,'F','0','0','monitor:online:batchLogout','#','admin','2026-10-02 14:30:22','',NULL,''),(1048,'单条强退',109,3,'#','','','',1,0,'F','0','0','monitor:online:forceLogout','#','admin','2026-10-02 14:30:22','',NULL,''),(1049,'任务查询',110,1,'#','','','',1,0,'F','0','0','monitor:job:query','#','admin','2026-10-02 14:30:22','',NULL,''),(1050,'任务新增',110,2,'#','','','',1,0,'F','0','0','monitor:job:add','#','admin','2026-10-02 14:30:22','',NULL,''),(1051,'任务修改',110,3,'#','','','',1,0,'F','0','0','monitor:job:edit','#','admin','2026-10-02 14:30:22','',NULL,''),(1052,'任务删除',110,4,'#','','','',1,0,'F','0','0','monitor:job:remove','#','admin','2026-10-02 14:30:22','',NULL,''),(1053,'状态修改',110,5,'#','','','',1,0,'F','0','0','monitor:job:changeStatus','#','admin','2026-10-02 14:30:22','',NULL,''),(1054,'任务导出',110,6,'#','','','',1,0,'F','0','0','monitor:job:export','#','admin','2026-10-02 14:30:22','',NULL,''),(2000,'基础数据与权限管理',0,1,'basic',NULL,'','',1,0,'M','0','0','','peoples','admin','2026-10-02 14:30:24','',NULL,'模块一目录'),(2001,'故障报修与跟踪',0,2,'repair',NULL,'','',1,0,'M','0','0','','message','admin','2026-10-02 14:30:24','',NULL,'模块二目录'),(2002,'工单调度与执行',0,3,'order',NULL,'','',1,0,'M','0','0','','job','admin','2026-10-02 14:30:24','',NULL,'模块三目录'),(2003,'预防性维保',0,4,'maintain',NULL,'','',1,0,'M','0','0','','server','admin','2026-10-02 14:30:24','',NULL,'模块四目录'),(2004,'数据分析与预警',0,5,'analysis',NULL,'','',1,0,'M','0','0','','chart','admin','2026-10-02 14:30:24','',NULL,'模块五目录'),(2102,'基础信息管理',2000,3,'info','basic/info/index','','',1,0,'C','0','0','basic:info:list','tree','admin','2026-10-02 14:30:24','',NULL,'基础信息管理菜单'),(2103,'故障一键报修',2001,1,'order','repair/order/index','','',1,0,'C','0','0','repair:order:list','form','admin','2026-10-02 14:30:24','',NULL,'故障一键报修菜单'),(2104,'故障分级管理',2001,2,'level','repair/level/index','','',1,0,'C','0','0','repair:level:list','star','admin','2026-10-02 14:30:24','',NULL,'故障分级管理菜单'),(2105,'多媒体证据上传',2001,3,'evidence','repair/evidence/index','','',1,0,'C','0','0','repair:evidence:list','upload','admin','2026-10-02 14:30:24','',NULL,'多媒体证据上传菜单'),(2106,'报修进度跟踪',2001,4,'track','repair/track/index','','',1,0,'C','0','0','repair:track:list','time-range','admin','2026-10-02 14:30:24','',NULL,'报修进度跟踪菜单'),(2107,'智能派单',2002,1,'dispatch','order/dispatch/index','','',1,0,'C','0','0','order:dispatch:list','guide','admin','2026-10-02 14:30:24','',NULL,'智能派单菜单'),(2108,'维保人员接单',2002,2,'accept','order/accept/index','','',1,0,'C','0','0','order:accept:list','checkbox','admin','2026-10-02 14:30:24','',NULL,'维保人员接单菜单'),(2109,'维修过程管理',2002,3,'process','order/process/index','','',1,0,'C','0','0','order:process:list','edit','admin','2026-10-02 14:30:24','',NULL,'维修过程管理菜单'),(2110,'工单异常处理',2002,4,'exception','order/exception/index','','',1,0,'C','0','0','order:exception:list','bug','admin','2026-10-02 14:30:24','',NULL,'工单异常处理菜单'),(2111,'维保计划管理',2003,1,'plan','maintain/plan/index','','',1,0,'C','0','0','maintain:plan:list','date','admin','2026-10-02 14:30:24','',NULL,'维保计划管理菜单'),(2112,'定期巡检执行',2003,2,'inspection','maintain/inspection/index','','',1,0,'C','0','0','maintain:inspection:list','validCode','admin','2026-10-02 14:30:24','',NULL,'定期巡检执行菜单'),(2113,'维保档案归档',2003,3,'archive','maintain/archive/index','','',1,0,'C','0','0','maintain:archive:list','documentation','admin','2026-10-02 14:30:24','',NULL,'维保档案归档菜单'),(2114,'故障频次统计',2004,1,'frequency','analysis/frequency/index','','',1,0,'C','0','0','analysis:frequency:list','chart','admin','2026-10-02 14:30:24','',NULL,'故障频次统计菜单'),(2115,'超期预警监控',2004,2,'warning','analysis/warning/index','','',1,0,'C','0','0','analysis:warning:list','bell','admin','2026-10-02 14:30:24','',NULL,'超期预警监控菜单'),(2116,'电梯健康档案生成',2004,3,'health','analysis/health/index','','',1,0,'C','0','0','analysis:health:list','monitor','admin','2026-10-02 14:30:24','',NULL,'电梯健康档案生成菜单'),(2208,'小区楼栋电梯查询',2102,1,'','','','',1,0,'F','0','0','basic:info:query','#','admin','2026-10-02 14:30:24','',NULL,''),(2209,'基础信息新增',2102,2,'','','','',1,0,'F','0','0','basic:info:add','#','admin','2026-10-02 14:30:24','',NULL,''),(2210,'基础信息修改',2102,3,'','','','',1,0,'F','0','0','basic:info:edit','#','admin','2026-10-02 14:30:24','',NULL,''),(2211,'基础信息删除',2102,4,'','','','',1,0,'F','0','0','basic:info:remove','#','admin','2026-10-02 14:30:24','',NULL,''),(2212,'基础信息导出',2102,5,'','','','',1,0,'F','0','0','basic:info:export','#','admin','2026-10-02 14:30:24','',NULL,''),(2213,'报修单查询',2103,1,'','','','',1,0,'F','0','0','repair:order:query','#','admin','2026-10-02 14:30:24','',NULL,''),(2214,'报修单驳回',2103,2,'','','','',1,0,'F','0','0','repair:order:reject','#','admin','2026-10-02 14:30:24','',NULL,''),(2215,'报修单导出',2103,3,'','','','',1,0,'F','0','0','repair:order:export','#','admin','2026-10-02 14:30:24','',NULL,''),(2216,'故障等级查询',2104,1,'','','','',1,0,'F','0','0','repair:level:query','#','admin','2026-10-02 14:30:24','',NULL,''),(2217,'调整故障等级',2104,2,'','','','',1,0,'F','0','0','repair:order:changeLevel','#','admin','2026-10-02 14:30:24','',NULL,''),(2218,'证据查询',2105,1,'','','','',1,0,'F','0','0','repair:evidence:query','#','admin','2026-10-02 14:30:24','',NULL,''),(2219,'证据删除',2105,2,'','','','',1,0,'F','0','0','repair:evidence:remove','#','admin','2026-10-02 14:30:24','',NULL,''),(2220,'进度查询',2106,1,'','','','',1,0,'F','0','0','repair:track:query','#','admin','2026-10-02 14:30:24','',NULL,''),(2221,'待派单查询',2107,1,'','','','',1,0,'F','0','0','order:dispatch:query','#','admin','2026-10-02 14:30:24','',NULL,''),(2222,'执行派单',2107,2,'','','','',1,0,'F','0','0','order:dispatch:assign','#','admin','2026-10-02 14:30:24','',NULL,''),(2223,'接单查询',2108,1,'','','','',1,0,'F','0','0','order:accept:query','#','admin','2026-10-02 14:30:24','',NULL,''),(2224,'确认接单',2108,2,'','','','',1,0,'F','0','0','order:accept:confirm','#','admin','2026-10-02 14:30:24','',NULL,''),(2225,'维修过程查询',2109,1,'','','','',1,0,'F','0','0','order:process:query','#','admin','2026-10-02 14:30:24','',NULL,''),(2226,'推进维修状态',2109,2,'','','','',1,0,'F','0','0','order:process:edit','#','admin','2026-10-02 14:30:24','',NULL,''),(2227,'异常工单查询',2110,1,'','','','',1,0,'F','0','0','order:exception:query','#','admin','2026-10-02 14:30:24','',NULL,''),(2228,'异常工单处理',2110,2,'','','','',1,0,'F','0','0','order:exception:edit','#','admin','2026-10-02 14:30:24','',NULL,''),(2229,'维保计划查询',2111,1,'','','','',1,0,'F','0','0','maintain:plan:query','#','admin','2026-10-02 14:30:24','',NULL,''),(2230,'维保计划新增',2111,2,'','','','',1,0,'F','0','0','maintain:plan:add','#','admin','2026-10-02 14:30:24','',NULL,''),(2231,'维保计划修改',2111,3,'','','','',1,0,'F','0','0','maintain:plan:edit','#','admin','2026-10-02 14:30:24','',NULL,''),(2232,'维保计划删除',2111,4,'','','','',1,0,'F','0','0','maintain:plan:remove','#','admin','2026-10-02 14:30:24','',NULL,''),(2233,'巡检任务查询',2112,1,'','','','',1,0,'F','0','0','maintain:inspection:query','#','admin','2026-10-02 14:30:24','',NULL,''),(2234,'巡检打卡执行',2112,2,'','','','',1,0,'F','0','0','maintain:inspection:execute','#','admin','2026-10-02 14:30:24','',NULL,''),(2235,'巡检记录导出',2112,3,'','','','',1,0,'F','0','0','maintain:inspection:export','#','admin','2026-10-02 14:30:24','',NULL,''),(2236,'维保档案查询',2113,1,'','','','',1,0,'F','0','0','maintain:archive:query','#','admin','2026-10-02 14:30:24','',NULL,''),(2237,'维保档案导出',2113,2,'','','','',1,0,'F','0','0','maintain:archive:export','#','admin','2026-10-02 14:30:24','',NULL,''),(2238,'频次统计查询',2114,1,'','','','',1,0,'F','0','0','analysis:frequency:query','#','admin','2026-10-02 14:30:24','',NULL,''),(2239,'频次统计导出',2114,2,'','','','',1,0,'F','0','0','analysis:frequency:export','#','admin','2026-10-02 14:30:24','',NULL,''),(2240,'预警查询',2115,1,'','','','',1,0,'F','0','0','analysis:warning:query','#','admin','2026-10-02 14:30:24','',NULL,''),(2241,'预警规则配置',2115,2,'','','','',1,0,'F','0','0','analysis:warning:rule','#','admin','2026-10-02 14:30:24','',NULL,''),(2242,'健康档案查询',2116,1,'','','','',1,0,'F','0','0','analysis:health:query','#','admin','2026-10-02 14:30:24','',NULL,''),(2243,'健康档案导出',2116,2,'','','','',1,0,'F','0','0','analysis:health:export','#','admin','2026-10-02 14:30:24','',NULL,'');
/*!40000 ALTER TABLE `sys_menu` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `sys_notice`
--

DROP TABLE IF EXISTS `sys_notice`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sys_notice` (
  `notice_id` int NOT NULL AUTO_INCREMENT COMMENT '公告ID',
  `notice_title` varchar(50) COLLATE utf8mb4_general_ci NOT NULL COMMENT '公告标题',
  `notice_type` char(1) COLLATE utf8mb4_general_ci NOT NULL COMMENT '公告类型（1通知 2公告）',
  `notice_content` longblob COMMENT '公告内容',
  `status` char(1) COLLATE utf8mb4_general_ci DEFAULT '0' COMMENT '公告状态（0正常 1关闭）',
  `create_by` varchar(64) COLLATE utf8mb4_general_ci DEFAULT '' COMMENT '创建者',
  `create_time` datetime DEFAULT NULL COMMENT '创建时间',
  `update_by` varchar(64) COLLATE utf8mb4_general_ci DEFAULT '' COMMENT '更新者',
  `update_time` datetime DEFAULT NULL COMMENT '更新时间',
  `remark` varchar(255) COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '备注',
  PRIMARY KEY (`notice_id`)
) ENGINE=InnoDB AUTO_INCREMENT=10 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='通知公告表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `sys_notice`
--

LOCK TABLES `sys_notice` WRITE;
/*!40000 ALTER TABLE `sys_notice` DISABLE KEYS */;
INSERT INTO `sys_notice` VALUES (1,'温馨提醒：2018-07-01 若依新版本发布啦','2',_binary '新版本内容','0','admin','2026-10-02 14:30:23','',NULL,'管理员'),(2,'维护通知：2018-07-01 若依系统凌晨维护','1',_binary '维护内容','0','admin','2026-10-02 14:30:23','',NULL,'管理员'),(3,'若依开源框架介绍','1',_binary '<p><span style=\"color: rgb(230, 0, 0);\">项目介绍</span></p><p><font color=\"#333333\">RuoYi开源项目是为企业用户定制的后台脚手架框架，为企业打造的一站式解决方案，降低企业开发成本，提升开发效率。主要包括用户管理、角色管理、部门管理、菜单管理、参数管理、字典管理、</font><span style=\"color: rgb(51, 51, 51);\">岗位管理</span><span style=\"color: rgb(51, 51, 51);\">、定时任务</span><span style=\"color: rgb(51, 51, 51);\">、</span><span style=\"color: rgb(51, 51, 51);\">服务监控、登录日志、操作日志、代码生成等功能。其中，还支持多数据源、数据权限、国际化、Redis缓存、Docker部署、滑动验证码、第三方认证登录、分布式事务、</span><font color=\"#333333\">分布式文件存储</font><span style=\"color: rgb(51, 51, 51);\">、分库分表处理等技术特点。</span></p><p><img src=\"https://foruda.gitee.com/images/1773931848342439032/a4d22313_1815095.png\" style=\"width: 64px;\"><br></p><p><span style=\"color: rgb(230, 0, 0);\">官网及演示</span></p><p><span style=\"color: rgb(51, 51, 51);\">若依官网地址：&nbsp;</span><a href=\"http://ruoyi.vip\" target=\"_blank\">http://ruoyi.vip</a><a href=\"http://ruoyi.vip\" target=\"_blank\"></a></p><p><span style=\"color: rgb(51, 51, 51);\">若依文档地址：&nbsp;</span><a href=\"http://doc.ruoyi.vip\" target=\"_blank\">http://doc.ruoyi.vip</a><br></p><p><span style=\"color: rgb(51, 51, 51);\">演示地址【不分离版】：&nbsp;</span><a href=\"http://demo.ruoyi.vip\" target=\"_blank\">http://demo.ruoyi.vip</a></p><p><span style=\"color: rgb(51, 51, 51);\">演示地址【分离版本】：&nbsp;</span><a href=\"http://vue.ruoyi.vip\" target=\"_blank\">http://vue.ruoyi.vip</a></p><p><span style=\"color: rgb(51, 51, 51);\">演示地址【微服务版】：&nbsp;</span><a href=\"http://cloud.ruoyi.vip\" target=\"_blank\">http://cloud.ruoyi.vip</a></p><p><span style=\"color: rgb(51, 51, 51);\">演示地址【移动端版】：&nbsp;</span><a href=\"http://h5.ruoyi.vip\" target=\"_blank\">http://h5.ruoyi.vip</a></p><p><br style=\"color: rgb(48, 49, 51); font-family: &quot;Helvetica Neue&quot;, Helvetica, Arial, sans-serif; font-size: 12px;\"></p>','0','admin','2026-10-02 14:30:23','',NULL,'管理员');
/*!40000 ALTER TABLE `sys_notice` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `sys_notice_read`
--

DROP TABLE IF EXISTS `sys_notice_read`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sys_notice_read` (
  `read_id` bigint NOT NULL AUTO_INCREMENT COMMENT '已读主键',
  `notice_id` int NOT NULL COMMENT '公告id',
  `user_id` bigint NOT NULL COMMENT '用户id',
  `read_time` datetime NOT NULL COMMENT '阅读时间',
  PRIMARY KEY (`read_id`),
  UNIQUE KEY `uk_user_notice` (`user_id`,`notice_id`) COMMENT '同一用户同一公告只记录一次'
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='公告已读记录表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `sys_notice_read`
--

LOCK TABLES `sys_notice_read` WRITE;
/*!40000 ALTER TABLE `sys_notice_read` DISABLE KEYS */;
INSERT INTO `sys_notice_read` VALUES (1,0,1,'2026-10-11 13:59:38');
/*!40000 ALTER TABLE `sys_notice_read` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `sys_oper_log`
--

DROP TABLE IF EXISTS `sys_oper_log`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sys_oper_log` (
  `oper_id` bigint NOT NULL AUTO_INCREMENT COMMENT '日志主键',
  `title` varchar(50) COLLATE utf8mb4_general_ci DEFAULT '' COMMENT '模块标题',
  `business_type` int DEFAULT '0' COMMENT '业务类型（0其它 1新增 2修改 3删除）',
  `method` varchar(200) COLLATE utf8mb4_general_ci DEFAULT '' COMMENT '方法名称',
  `request_method` varchar(10) COLLATE utf8mb4_general_ci DEFAULT '' COMMENT '请求方式',
  `operator_type` int DEFAULT '0' COMMENT '操作类别（0其它 1后台用户 2手机端用户）',
  `oper_name` varchar(50) COLLATE utf8mb4_general_ci DEFAULT '' COMMENT '操作人员',
  `dept_name` varchar(50) COLLATE utf8mb4_general_ci DEFAULT '' COMMENT '部门名称',
  `oper_url` varchar(255) COLLATE utf8mb4_general_ci DEFAULT '' COMMENT '请求URL',
  `oper_ip` varchar(128) COLLATE utf8mb4_general_ci DEFAULT '' COMMENT '主机地址',
  `oper_location` varchar(255) COLLATE utf8mb4_general_ci DEFAULT '' COMMENT '操作地点',
  `oper_param` varchar(2000) COLLATE utf8mb4_general_ci DEFAULT '' COMMENT '请求参数',
  `json_result` varchar(2000) COLLATE utf8mb4_general_ci DEFAULT '' COMMENT '返回参数',
  `status` int DEFAULT '0' COMMENT '操作状态（0正常 1异常）',
  `error_msg` varchar(2000) COLLATE utf8mb4_general_ci DEFAULT '' COMMENT '错误消息',
  `oper_time` datetime DEFAULT NULL COMMENT '操作时间',
  `cost_time` bigint DEFAULT '0' COMMENT '消耗时间',
  PRIMARY KEY (`oper_id`),
  KEY `idx_sys_oper_log_bt` (`business_type`),
  KEY `idx_sys_oper_log_s` (`status`),
  KEY `idx_sys_oper_log_ot` (`oper_time`)
) ENGINE=InnoDB AUTO_INCREMENT=267 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='操作日志记录';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `sys_oper_log`
--

LOCK TABLES `sys_oper_log` WRITE;
/*!40000 ALTER TABLE `sys_oper_log` DISABLE KEYS */;
INSERT INTO `sys_oper_log` VALUES (1,'操作日志',9,'com.ruoyi.web.controller.monitor.SysOperlogController.clean()','DELETE',1,'admin','','/monitor/operlog/clean','127.0.0.1','内网IP','','{\"msg\":\"操作成功\",\"code\":200}',0,NULL,'2026-10-11 14:01:53',32),(2,'参数管理',9,'com.ruoyi.web.controller.system.SysConfigController.refreshCache()','DELETE',1,'admin','','/system/config/refreshCache','127.0.0.1','内网IP','','{\"msg\":\"操作成功\",\"code\":200}',0,NULL,'2026-10-11 14:01:53',5),(3,'字典类型',9,'com.ruoyi.web.controller.system.SysDictTypeController.refreshCache()','DELETE',1,'admin','','/system/dict/type/refreshCache','127.0.0.1','内网IP','','{\"msg\":\"操作成功\",\"code\":200}',0,NULL,'2026-10-11 14:01:53',10),(4,'预警规则',1,'com.ruoyi.elevator.controller.WarningController.addRule()','POST',1,'admin','','/analysis/warning/rule','127.0.0.1','内网IP','{} ',NULL,1,'规则名称不能为空','2026-10-11 14:01:57',1),(5,'楼栋信息',1,'com.ruoyi.elevator.controller.CommunityController.addBuilding()','POST',1,'admin','','/basic/building','127.0.0.1','内网IP','{} ',NULL,1,'请选择所属小区','2026-10-11 14:01:57',1),(6,'小区信息',1,'com.ruoyi.elevator.controller.CommunityController.addCommunity()','POST',1,'admin','','/basic/community','127.0.0.1','内网IP','{} ',NULL,1,'小区名称不能为空','2026-10-11 14:01:57',1),(7,'电梯信息',1,'com.ruoyi.elevator.controller.ElevatorController.add()','POST',1,'admin','','/basic/elevator','127.0.0.1','内网IP','{} ',NULL,1,'电梯编号不能为空','2026-10-11 14:01:57',2),(8,'手动生成巡检工单',1,'com.ruoyi.elevator.controller.InspectionController.generate()','POST',1,'admin','','/maintain/inspection/generate','127.0.0.1','内网IP','','{\"msg\":\"本次生成巡检工单 5 条\",\"code\":200}',0,NULL,'2026-10-11 14:01:58',43),(9,'巡检提交',2,'com.ruoyi.elevator.controller.InspectionController.submit()','POST',1,'admin','','/maintain/inspection/submit','127.0.0.1','内网IP','{} ',NULL,1,'巡检任务不存在','2026-10-11 14:01:58',4),(10,'维保计划',1,'com.ruoyi.elevator.controller.MaintainPlanController.add()','POST',1,'admin','','/maintain/plan','127.0.0.1','内网IP','{} ',NULL,1,'计划名称不能为空','2026-10-11 14:01:58',3),(11,'维保计划批量创建',1,'com.ruoyi.elevator.controller.MaintainPlanController.batchAdd()','POST',1,'admin','','/maintain/plan/batch','127.0.0.1','内网IP','{} ',NULL,1,'请选择至少一台电梯','2026-10-11 14:01:58',2),(12,'维保检查项',1,'com.ruoyi.elevator.controller.MaintainPlanController.addTemplate()','POST',1,'admin','','/maintain/plan/template','127.0.0.1','内网IP','{} ',NULL,1,'检查项名称不能为空','2026-10-11 14:01:58',2),(13,'定时任务',1,'com.ruoyi.quartz.controller.SysJobController.add()','POST',1,'admin','','/monitor/job','127.0.0.1','内网IP','{\"misfirePolicy\":\"0\",\"params\":{}} ',NULL,1,'cronExpression cannot be null','2026-10-11 14:01:58',0),(14,'维修接单',2,'com.ruoyi.elevator.controller.AcceptController.confirm()','POST',1,'admin','','/order/accept/confirm','127.0.0.1','内网IP','{} ',NULL,1,'工单不存在','2026-10-11 14:01:58',4),(15,'拒绝接单',2,'com.ruoyi.elevator.controller.AcceptController.refuse()','POST',1,'admin','','/order/accept/refuse','127.0.0.1','内网IP','{} ',NULL,1,'工单不存在','2026-10-11 14:01:58',4),(16,'智能派单',2,'com.ruoyi.elevator.controller.DispatchController.assign()','POST',1,'admin','','/order/dispatch/assign','127.0.0.1','内网IP','{} ',NULL,1,'请选择维修员','2026-10-11 14:01:58',1),(17,'批量派单',2,'com.ruoyi.elevator.controller.DispatchController.batchAssign()','POST',1,'admin','','/order/dispatch/batchAssign','127.0.0.1','内网IP','{} ',NULL,1,'Cannot read the array length because \"<local5>\" is null','2026-10-11 14:01:58',0),(18,'异常工单升级',2,'com.ruoyi.elevator.controller.ExceptionController.escalate()','POST',1,'admin','','/order/exception/escalate','127.0.0.1','内网IP','{} ',NULL,1,'工单不存在','2026-10-11 14:01:58',4),(19,'异常工单重新指派',2,'com.ruoyi.elevator.controller.ExceptionController.reassign()','POST',1,'admin','','/order/exception/reassign','127.0.0.1','内网IP','{} ',NULL,1,'请选择新的维修员','2026-10-11 14:01:58',2),(20,'异常工单驳回',2,'com.ruoyi.elevator.controller.ExceptionController.reject()','POST',1,'admin','','/order/exception/reject','127.0.0.1','内网IP','{} ',NULL,1,'驳回原因不能为空','2026-10-11 14:01:58',2),(21,'工单异常上报',2,'com.ruoyi.elevator.controller.ExceptionController.report()','POST',1,'admin','','/order/exception/report','127.0.0.1','内网IP','{} ',NULL,1,'异常说明不能为空','2026-10-11 14:01:58',1),(22,'维修到场',2,'com.ruoyi.elevator.controller.ProcessController.arrive()','POST',1,'admin','','/order/process/arrive','127.0.0.1','内网IP','{} ',NULL,1,'工单不存在','2026-10-11 14:01:58',2),(23,'维修完成',2,'com.ruoyi.elevator.controller.ProcessController.finish()','POST',1,'admin','','/order/process/finish','127.0.0.1','内网IP','{} ',NULL,1,'工单不存在','2026-10-11 14:01:58',4),(24,'维修排查',2,'com.ruoyi.elevator.controller.ProcessController.investigate()','POST',1,'admin','','/order/process/investigate','127.0.0.1','内网IP','{} ',NULL,1,'工单不存在','2026-10-11 14:01:58',3),(25,'预警规则',2,'com.ruoyi.elevator.controller.WarningController.editRule()','PUT',1,'admin','','/analysis/warning/rule','127.0.0.1','内网IP','{} ',NULL,1,'规则ID不能为空','2026-10-11 14:01:58',1),(26,'预警规则状态',2,'com.ruoyi.elevator.controller.WarningController.changeRuleStatus()','PUT',1,'admin','','/analysis/warning/rule/changeStatus','127.0.0.1','内网IP','{} ',NULL,1,'启用状态不能为空','2026-10-11 14:01:58',1),(27,'楼栋信息',2,'com.ruoyi.elevator.controller.CommunityController.editBuilding()','PUT',1,'admin','','/basic/building','127.0.0.1','内网IP','{} ',NULL,1,'楼栋ID不能为空','2026-10-11 14:01:58',2),(28,'小区信息',2,'com.ruoyi.elevator.controller.CommunityController.editCommunity()','PUT',1,'admin','','/basic/community','127.0.0.1','内网IP','{} ',NULL,1,'小区ID不能为空','2026-10-11 14:01:58',1),(29,'电梯信息',2,'com.ruoyi.elevator.controller.ElevatorController.edit()','PUT',1,'admin','','/basic/elevator','127.0.0.1','内网IP','{} ',NULL,1,'电梯ID不能为空','2026-10-11 14:01:58',2),(30,'维保计划',2,'com.ruoyi.elevator.controller.MaintainPlanController.edit()','PUT',1,'admin','','/maintain/plan','127.0.0.1','内网IP','{} ',NULL,1,'计划ID不能为空','2026-10-11 14:01:58',2),(31,'维保计划状态',2,'com.ruoyi.elevator.controller.MaintainPlanController.changeStatus()','PUT',1,'admin','','/maintain/plan/changeStatus','127.0.0.1','内网IP','{} ',NULL,1,'计划状态不能为空','2026-10-11 14:01:58',1),(32,'定时任务',2,'com.ruoyi.quartz.controller.SysJobController.edit()','PUT',1,'admin','','/monitor/job','127.0.0.1','内网IP','{\"misfirePolicy\":\"0\",\"params\":{}} ',NULL,1,'cronExpression cannot be null','2026-10-11 14:01:58',1),(33,'定时任务',2,'com.ruoyi.quartz.controller.SysJobController.changeStatus()','PUT',1,'admin','','/monitor/job/changeStatus','127.0.0.1','内网IP','{\"misfirePolicy\":\"0\",\"params\":{}} ',NULL,1,'Cannot invoke \"com.ruoyi.quartz.domain.SysJob.setStatus(String)\" because \"newJob\" is null','2026-10-11 14:01:58',2),(34,'定时任务',2,'com.ruoyi.quartz.controller.SysJobController.run()','PUT',1,'admin','','/monitor/job/run','127.0.0.1','内网IP','{\"misfirePolicy\":\"0\",\"params\":{}} ','{\"msg\":\"任务不存在或已过期！\",\"code\":500}',0,NULL,'2026-10-11 14:01:58',3),(35,'报修工单',2,'com.ruoyi.elevator.controller.RepairOrderController.reject()','PUT',1,'admin','','/repair/order/reject','127.0.0.1','内网IP','{} ',NULL,1,'驳回原因不能为空','2026-10-11 14:01:58',1),(36,'保存菜单排序',2,'com.ruoyi.web.controller.system.SysMenuController.updateSort()','PUT',1,'admin','','/system/menu/updateSort','127.0.0.1','内网IP','{} ',NULL,1,'Cannot invoke \"String.split(String)\" because the return value of \"java.util.Map.get(Object)\" is null','2026-10-11 14:01:59',1),(37,'角色管理',4,'com.ruoyi.web.controller.system.SysRoleController.cancelAuthUser()','PUT',1,'admin','','/system/role/authUser/cancel','127.0.0.1','内网IP','{} ','{\"msg\":\"操作失败\",\"code\":500}',0,NULL,'2026-10-11 14:01:59',2),(38,'角色管理',4,'com.ruoyi.web.controller.system.SysRoleController.cancelAuthUserAll()','PUT',1,'admin','','/system/role/authUser/cancelAll','127.0.0.1','内网IP','',NULL,1,'\r\n### Error updating database.  Cause: org.apache.ibatis.builder.BuilderException: The expression \'userIds\' evaluated to a null value.\r\n### The error may exist in URL [jar:nested:/E:/Desktop/2023毕设/董/项目/backend/ruoyi-admin/target/ruoyi-admin.jar/!BOOT-INF/lib/ruoyi-system-3.9.2.jar!/mapper/system/SysUserRoleMapper.xml]\r\n### The error may involve com.ruoyi.system.mapper.SysUserRoleMapper.deleteUserRoleInfos\r\n### The error occurred while executing an update\r\n### Cause: org.apache.ibatis.builder.BuilderException: The expression \'userIds\' evaluated to a null value.','2026-10-11 14:01:59',0),(39,'角色管理',4,'com.ruoyi.web.controller.system.SysRoleController.selectAuthUserAll()','PUT',1,'admin','','/system/role/authUser/selectAll','127.0.0.1','内网IP','',NULL,1,'Cannot read the array length because \"<local4>\" is null','2026-10-11 14:01:59',1),(40,'角色管理',2,'com.ruoyi.web.controller.system.SysRoleController.changeStatus()','PUT',1,'admin','','/system/role/changeStatus','127.0.0.1','内网IP','{\"admin\":false,\"flag\":false,\"menuCheckStrictly\":false,\"params\":{},\"updateBy\":\"admin\"} ','{\"msg\":\"操作失败\",\"code\":500}',0,NULL,'2026-10-11 14:01:59',3),(41,'用户管理',4,'com.ruoyi.web.controller.system.SysUserController.insertAuthRole()','PUT',1,'admin','','/system/user/authRole','127.0.0.1','内网IP','','{\"msg\":\"操作成功\",\"code\":200}',0,NULL,'2026-10-11 14:01:59',4),(42,'用户管理',2,'com.ruoyi.web.controller.system.SysUserController.changeStatus()','PUT',1,'admin','','/system/user/changeStatus','127.0.0.1','内网IP','{\"admin\":false,\"params\":{},\"updateBy\":\"admin\"} ','{\"msg\":\"操作失败\",\"code\":500}',0,NULL,'2026-10-11 14:01:59',3),(43,'个人信息',2,'com.ruoyi.web.controller.system.SysProfileController.updateProfile()','PUT',1,'admin','','/system/user/profile','127.0.0.1','内网IP','{\"admin\":false,\"params\":{}} ','{\"msg\":\"操作成功\",\"code\":200}',0,NULL,'2026-10-11 14:01:59',7),(44,'个人信息',2,'com.ruoyi.web.controller.system.SysProfileController.updatePwd()','PUT',1,'admin','','/system/user/profile/updatePwd','127.0.0.1','内网IP','{} ',NULL,1,'rawPassword cannot be null','2026-10-11 14:01:59',6),(45,'用户管理',2,'com.ruoyi.web.controller.system.SysUserController.resetPwd()','PUT',1,'admin','','/system/user/resetPwd','127.0.0.1','内网IP','{\"admin\":false,\"params\":{}} ',NULL,1,'rawPassword cannot be null','2026-10-11 14:01:59',2),(46,'预警扫描',1,'com.ruoyi.elevator.controller.WarningController.scan()','POST',1,'admin','','/analysis/warning/scan','127.0.0.1','内网IP','','{\"msg\":\"本次生成预警 0 条\",\"code\":200}',0,NULL,'2026-10-11 14:02:04',44),(47,'预警扫描',1,'com.ruoyi.elevator.controller.WarningController.scan()','POST',1,'admin','','/analysis/warning/scan','127.0.0.1','内网IP','','{\"msg\":\"本次生成预警 0 条\",\"code\":200}',0,NULL,'2026-10-11 14:02:05',28),(48,'健康评分重算',2,'com.ruoyi.elevator.controller.HealthController.recalculate()','POST',1,'admin','','/analysis/health/recalculate','127.0.0.1','内网IP','','{\"msg\":\"已重算 6 台电梯的健康评分\",\"code\":200}',0,NULL,'2026-10-11 14:02:05',89),(49,'小区信息',1,'com.ruoyi.elevator.controller.CommunityController.addCommunity()','POST',1,'admin','','/basic/community','127.0.0.1','内网IP','{} ',NULL,1,'小区名称不能为空','2026-10-11 14:02:17',2),(50,'小区信息',2,'com.ruoyi.elevator.controller.CommunityController.editCommunity()','PUT',1,'admin','','/basic/community','127.0.0.1','内网IP','{} ',NULL,1,'小区ID不能为空','2026-10-11 14:02:17',1),(51,'小区信息',3,'com.ruoyi.elevator.controller.CommunityController.removeCommunity()','DELETE',1,'admin','','/basic/community/1','127.0.0.1','内网IP','[1] ',NULL,1,'小区【阳光家园小区】下还有 3 个楼栋，无法删除','2026-10-11 14:02:17',9),(52,'楼栋信息',1,'com.ruoyi.elevator.controller.CommunityController.addBuilding()','POST',1,'admin','','/basic/building','127.0.0.1','内网IP','{} ',NULL,1,'请选择所属小区','2026-10-11 14:02:17',2),(53,'楼栋信息',2,'com.ruoyi.elevator.controller.CommunityController.editBuilding()','PUT',1,'admin','','/basic/building','127.0.0.1','内网IP','{} ',NULL,1,'楼栋ID不能为空','2026-10-11 14:02:17',2),(54,'楼栋信息',3,'com.ruoyi.elevator.controller.CommunityController.removeBuilding()','DELETE',1,'admin','','/basic/building/1','127.0.0.1','内网IP','[1] ',NULL,1,'楼栋【1号楼 1单元】下还有 1 台电梯，无法删除','2026-10-11 14:02:17',4),(55,'电梯信息',1,'com.ruoyi.elevator.controller.ElevatorController.add()','POST',1,'admin','','/basic/elevator','127.0.0.1','内网IP','{} ',NULL,1,'电梯编号不能为空','2026-10-11 14:02:17',2),(56,'电梯信息',2,'com.ruoyi.elevator.controller.ElevatorController.edit()','PUT',1,'admin','','/basic/elevator','127.0.0.1','内网IP','{} ',NULL,1,'电梯ID不能为空','2026-10-11 14:02:17',1),(57,'电梯信息',3,'com.ruoyi.elevator.controller.ElevatorController.remove()','DELETE',1,'admin','','/basic/elevator/1','127.0.0.1','内网IP','[1] ','{\"msg\":\"操作成功\",\"code\":200}',0,NULL,'2026-10-11 14:02:18',6),(58,'报修工单',2,'com.ruoyi.elevator.controller.RepairOrderController.reject()','PUT',1,'admin','','/repair/order/reject','127.0.0.1','内网IP','{} ',NULL,1,'驳回原因不能为空','2026-10-11 14:02:18',1),(59,'字典类型',3,'com.ruoyi.web.controller.system.SysDictDataController.remove()','DELETE',1,'admin','','/system/dict/data/1','127.0.0.1','内网IP','[1] ','{\"msg\":\"操作成功\",\"code\":200}',0,NULL,'2026-10-11 14:02:18',16),(60,'智能派单',2,'com.ruoyi.elevator.controller.DispatchController.assign()','POST',1,'admin','','/order/dispatch/assign','127.0.0.1','内网IP','{} ',NULL,1,'请选择维修员','2026-10-11 14:02:18',2),(61,'批量派单',2,'com.ruoyi.elevator.controller.DispatchController.batchAssign()','POST',1,'admin','','/order/dispatch/batchAssign','127.0.0.1','内网IP','{} ',NULL,1,'Cannot read the array length because \"<local5>\" is null','2026-10-11 14:02:18',1),(62,'维修接单',2,'com.ruoyi.elevator.controller.AcceptController.confirm()','POST',1,'admin','','/order/accept/confirm','127.0.0.1','内网IP','{} ',NULL,1,'工单不存在','2026-10-11 14:02:18',3),(63,'拒绝接单',2,'com.ruoyi.elevator.controller.AcceptController.refuse()','POST',1,'admin','','/order/accept/refuse','127.0.0.1','内网IP','{} ',NULL,1,'工单不存在','2026-10-11 14:02:18',3),(64,'维修到场',2,'com.ruoyi.elevator.controller.ProcessController.arrive()','POST',1,'admin','','/order/process/arrive','127.0.0.1','内网IP','{} ',NULL,1,'工单不存在','2026-10-11 14:02:18',3),(65,'维修排查',2,'com.ruoyi.elevator.controller.ProcessController.investigate()','POST',1,'admin','','/order/process/investigate','127.0.0.1','内网IP','{} ',NULL,1,'工单不存在','2026-10-11 14:02:18',4),(66,'维修完成',2,'com.ruoyi.elevator.controller.ProcessController.finish()','POST',1,'admin','','/order/process/finish','127.0.0.1','内网IP','{} ',NULL,1,'工单不存在','2026-10-11 14:02:18',2),(67,'异常工单重新指派',2,'com.ruoyi.elevator.controller.ExceptionController.reassign()','POST',1,'admin','','/order/exception/reassign','127.0.0.1','内网IP','{} ',NULL,1,'请选择新的维修员','2026-10-11 14:02:18',1),(68,'异常工单驳回',2,'com.ruoyi.elevator.controller.ExceptionController.reject()','POST',1,'admin','','/order/exception/reject','127.0.0.1','内网IP','{} ',NULL,1,'驳回原因不能为空','2026-10-11 14:02:18',2),(69,'工单异常上报',2,'com.ruoyi.elevator.controller.ExceptionController.report()','POST',1,'admin','','/order/exception/report','127.0.0.1','内网IP','{} ',NULL,1,'异常说明不能为空','2026-10-11 14:02:18',1),(70,'异常工单升级',2,'com.ruoyi.elevator.controller.ExceptionController.escalate()','POST',1,'admin','','/order/exception/escalate','127.0.0.1','内网IP','{} ',NULL,1,'工单不存在','2026-10-11 14:02:18',3),(71,'维保计划',1,'com.ruoyi.elevator.controller.MaintainPlanController.add()','POST',1,'admin','','/maintain/plan','127.0.0.1','内网IP','{} ',NULL,1,'计划名称不能为空','2026-10-11 14:02:19',1),(72,'维保计划',2,'com.ruoyi.elevator.controller.MaintainPlanController.edit()','PUT',1,'admin','','/maintain/plan','127.0.0.1','内网IP','{} ',NULL,1,'计划ID不能为空','2026-10-11 14:02:19',1),(73,'维保计划',3,'com.ruoyi.elevator.controller.MaintainPlanController.remove()','DELETE',1,'admin','','/maintain/plan/1','127.0.0.1','内网IP','[1] ','{\"msg\":\"操作成功\",\"code\":200}',0,NULL,'2026-10-11 14:02:19',6),(74,'维保计划状态',2,'com.ruoyi.elevator.controller.MaintainPlanController.changeStatus()','PUT',1,'admin','','/maintain/plan/changeStatus','127.0.0.1','内网IP','{} ',NULL,1,'计划状态不能为空','2026-10-11 14:02:19',1),(75,'维保检查项',1,'com.ruoyi.elevator.controller.MaintainPlanController.addTemplate()','POST',1,'admin','','/maintain/plan/template','127.0.0.1','内网IP','{} ',NULL,1,'检查项名称不能为空','2026-10-11 14:02:19',2),(76,'维保计划批量创建',1,'com.ruoyi.elevator.controller.MaintainPlanController.batchAdd()','POST',1,'admin','','/maintain/plan/batch','127.0.0.1','内网IP','{} ',NULL,1,'请选择至少一台电梯','2026-10-11 14:02:19',2),(77,'手动生成巡检工单',1,'com.ruoyi.elevator.controller.InspectionController.generate()','POST',1,'admin','','/maintain/inspection/generate','127.0.0.1','内网IP','','{\"msg\":\"本次生成巡检工单 5 条\",\"code\":200}',0,NULL,'2026-10-11 14:02:19',30),(78,'巡检提交',2,'com.ruoyi.elevator.controller.InspectionController.submit()','POST',1,'admin','','/maintain/inspection/submit','127.0.0.1','内网IP','{} ',NULL,1,'巡检任务不存在','2026-10-11 14:02:19',4),(79,'预警规则',1,'com.ruoyi.elevator.controller.WarningController.addRule()','POST',1,'admin','','/analysis/warning/rule','127.0.0.1','内网IP','{} ',NULL,1,'规则名称不能为空','2026-10-11 14:02:19',1),(80,'预警规则',2,'com.ruoyi.elevator.controller.WarningController.editRule()','PUT',1,'admin','','/analysis/warning/rule','127.0.0.1','内网IP','{} ',NULL,1,'规则ID不能为空','2026-10-11 14:02:19',1),(81,'预警规则状态',2,'com.ruoyi.elevator.controller.WarningController.changeRuleStatus()','PUT',1,'admin','','/analysis/warning/rule/changeStatus','127.0.0.1','内网IP','{} ',NULL,1,'启用状态不能为空','2026-10-11 14:02:19',2),(82,'小区信息',1,'com.ruoyi.elevator.controller.CommunityController.addCommunity()','POST',1,'admin','','/basic/community','127.0.0.1','内网IP','{} ',NULL,1,'小区名称不能为空','2026-10-11 14:02:26',1),(83,'小区信息',2,'com.ruoyi.elevator.controller.CommunityController.editCommunity()','PUT',1,'admin','','/basic/community','127.0.0.1','内网IP','{} ',NULL,1,'小区ID不能为空','2026-10-11 14:02:26',2),(84,'小区信息',3,'com.ruoyi.elevator.controller.CommunityController.removeCommunity()','DELETE',1,'admin','','/basic/community/1','127.0.0.1','内网IP','[1] ',NULL,1,'小区【阳光家园小区】下还有 3 个楼栋，无法删除','2026-10-11 14:02:26',6),(85,'楼栋信息',1,'com.ruoyi.elevator.controller.CommunityController.addBuilding()','POST',1,'admin','','/basic/building','127.0.0.1','内网IP','{} ',NULL,1,'请选择所属小区','2026-10-11 14:02:26',1),(86,'楼栋信息',2,'com.ruoyi.elevator.controller.CommunityController.editBuilding()','PUT',1,'admin','','/basic/building','127.0.0.1','内网IP','{} ',NULL,1,'楼栋ID不能为空','2026-10-11 14:02:26',2),(87,'楼栋信息',3,'com.ruoyi.elevator.controller.CommunityController.removeBuilding()','DELETE',1,'admin','','/basic/building/1','127.0.0.1','内网IP','[1] ','{\"msg\":\"操作成功\",\"code\":200}',0,NULL,'2026-10-11 14:02:26',9),(88,'电梯信息',1,'com.ruoyi.elevator.controller.ElevatorController.add()','POST',1,'admin','','/basic/elevator','127.0.0.1','内网IP','{} ',NULL,1,'电梯编号不能为空','2026-10-11 14:02:26',2),(89,'电梯信息',2,'com.ruoyi.elevator.controller.ElevatorController.edit()','PUT',1,'admin','','/basic/elevator','127.0.0.1','内网IP','{} ',NULL,1,'电梯ID不能为空','2026-10-11 14:02:26',2),(90,'电梯信息',3,'com.ruoyi.elevator.controller.ElevatorController.remove()','DELETE',1,'admin','','/basic/elevator/1','127.0.0.1','内网IP','[1] ','{\"msg\":\"操作成功\",\"code\":200}',0,NULL,'2026-10-11 14:02:27',4),(91,'报修工单',2,'com.ruoyi.elevator.controller.RepairOrderController.reject()','PUT',1,'admin','','/repair/order/reject','127.0.0.1','内网IP','{} ',NULL,1,'驳回原因不能为空','2026-10-11 14:02:27',2),(92,'字典类型',3,'com.ruoyi.web.controller.system.SysDictDataController.remove()','DELETE',1,'admin','','/system/dict/data/1','127.0.0.1','内网IP','[1] ',NULL,1,'Cannot invoke \"com.ruoyi.common.core.domain.entity.SysDictData.getDictType()\" because \"data\" is null','2026-10-11 14:02:27',5),(93,'智能派单',2,'com.ruoyi.elevator.controller.DispatchController.assign()','POST',1,'admin','','/order/dispatch/assign','127.0.0.1','内网IP','{} ',NULL,1,'请选择维修员','2026-10-11 14:02:27',3),(94,'批量派单',2,'com.ruoyi.elevator.controller.DispatchController.batchAssign()','POST',1,'admin','','/order/dispatch/batchAssign','127.0.0.1','内网IP','{} ',NULL,1,'Cannot read the array length because \"<local5>\" is null','2026-10-11 14:02:27',1),(95,'维修接单',2,'com.ruoyi.elevator.controller.AcceptController.confirm()','POST',1,'admin','','/order/accept/confirm','127.0.0.1','内网IP','{} ',NULL,1,'工单不存在','2026-10-11 14:02:27',8),(96,'拒绝接单',2,'com.ruoyi.elevator.controller.AcceptController.refuse()','POST',1,'admin','','/order/accept/refuse','127.0.0.1','内网IP','{} ',NULL,1,'工单不存在','2026-10-11 14:02:27',6),(97,'维修到场',2,'com.ruoyi.elevator.controller.ProcessController.arrive()','POST',1,'admin','','/order/process/arrive','127.0.0.1','内网IP','{} ',NULL,1,'工单不存在','2026-10-11 14:02:27',5),(98,'维修排查',2,'com.ruoyi.elevator.controller.ProcessController.investigate()','POST',1,'admin','','/order/process/investigate','127.0.0.1','内网IP','{} ',NULL,1,'工单不存在','2026-10-11 14:02:27',4),(99,'维修完成',2,'com.ruoyi.elevator.controller.ProcessController.finish()','POST',1,'admin','','/order/process/finish','127.0.0.1','内网IP','{} ',NULL,1,'工单不存在','2026-10-11 14:02:27',5),(100,'异常工单重新指派',2,'com.ruoyi.elevator.controller.ExceptionController.reassign()','POST',1,'admin','','/order/exception/reassign','127.0.0.1','内网IP','{} ',NULL,1,'请选择新的维修员','2026-10-11 14:02:27',1),(101,'异常工单驳回',2,'com.ruoyi.elevator.controller.ExceptionController.reject()','POST',1,'admin','','/order/exception/reject','127.0.0.1','内网IP','{} ',NULL,1,'驳回原因不能为空','2026-10-11 14:02:27',2),(102,'工单异常上报',2,'com.ruoyi.elevator.controller.ExceptionController.report()','POST',1,'admin','','/order/exception/report','127.0.0.1','内网IP','{} ',NULL,1,'异常说明不能为空','2026-10-11 14:02:27',2),(103,'异常工单升级',2,'com.ruoyi.elevator.controller.ExceptionController.escalate()','POST',1,'admin','','/order/exception/escalate','127.0.0.1','内网IP','{} ',NULL,1,'工单不存在','2026-10-11 14:02:28',4),(104,'维保计划',1,'com.ruoyi.elevator.controller.MaintainPlanController.add()','POST',1,'admin','','/maintain/plan','127.0.0.1','内网IP','{} ',NULL,1,'计划名称不能为空','2026-10-11 14:02:28',2),(105,'维保计划',2,'com.ruoyi.elevator.controller.MaintainPlanController.edit()','PUT',1,'admin','','/maintain/plan','127.0.0.1','内网IP','{} ',NULL,1,'计划ID不能为空','2026-10-11 14:02:28',1),(106,'维保计划',3,'com.ruoyi.elevator.controller.MaintainPlanController.remove()','DELETE',1,'admin','','/maintain/plan/1','127.0.0.1','内网IP','[1] ','{\"msg\":\"操作成功\",\"code\":200}',0,NULL,'2026-10-11 14:02:28',5),(107,'维保计划状态',2,'com.ruoyi.elevator.controller.MaintainPlanController.changeStatus()','PUT',1,'admin','','/maintain/plan/changeStatus','127.0.0.1','内网IP','{} ',NULL,1,'计划状态不能为空','2026-10-11 14:02:28',2),(108,'维保检查项',1,'com.ruoyi.elevator.controller.MaintainPlanController.addTemplate()','POST',1,'admin','','/maintain/plan/template','127.0.0.1','内网IP','{} ',NULL,1,'检查项名称不能为空','2026-10-11 14:02:28',1),(109,'维保计划批量创建',1,'com.ruoyi.elevator.controller.MaintainPlanController.batchAdd()','POST',1,'admin','','/maintain/plan/batch','127.0.0.1','内网IP','{} ',NULL,1,'请选择至少一台电梯','2026-10-11 14:02:28',2),(110,'手动生成巡检工单',1,'com.ruoyi.elevator.controller.InspectionController.generate()','POST',1,'admin','','/maintain/inspection/generate','127.0.0.1','内网IP','','{\"msg\":\"本次生成巡检工单 5 条\",\"code\":200}',0,NULL,'2026-10-11 14:02:28',55),(111,'巡检提交',2,'com.ruoyi.elevator.controller.InspectionController.submit()','POST',1,'admin','','/maintain/inspection/submit','127.0.0.1','内网IP','{} ',NULL,1,'巡检任务不存在','2026-10-11 14:02:28',5),(112,'预警规则',1,'com.ruoyi.elevator.controller.WarningController.addRule()','POST',1,'admin','','/analysis/warning/rule','127.0.0.1','内网IP','{} ',NULL,1,'规则名称不能为空','2026-10-11 14:02:28',1),(113,'预警规则',2,'com.ruoyi.elevator.controller.WarningController.editRule()','PUT',1,'admin','','/analysis/warning/rule','127.0.0.1','内网IP','{} ',NULL,1,'规则ID不能为空','2026-10-11 14:02:28',3),(114,'预警规则状态',2,'com.ruoyi.elevator.controller.WarningController.changeRuleStatus()','PUT',1,'admin','','/analysis/warning/rule/changeStatus','127.0.0.1','内网IP','{} ',NULL,1,'启用状态不能为空','2026-10-11 14:02:28',1),(115,'预警扫描',1,'com.ruoyi.elevator.controller.WarningController.scan()','POST',1,'admin','','/analysis/warning/scan','127.0.0.1','内网IP','','{\"msg\":\"本次生成预警 0 条\",\"code\":200}',0,NULL,'2026-10-11 14:02:30',37),(116,'预警扫描',1,'com.ruoyi.elevator.controller.WarningController.scan()','POST',1,'admin','','/analysis/warning/scan','127.0.0.1','内网IP','','{\"msg\":\"本次生成预警 1 条\",\"code\":200}',0,NULL,'2026-10-11 14:02:30',32),(117,'预警扫描',1,'com.ruoyi.elevator.controller.WarningController.scan()','POST',1,'admin','','/analysis/warning/scan','127.0.0.1','内网IP','','{\"msg\":\"本次生成预警 0 条\",\"code\":200}',0,NULL,'2026-10-11 14:02:31',26),(118,'健康评分重算',2,'com.ruoyi.elevator.controller.HealthController.recalculate()','POST',1,'admin','','/analysis/health/recalculate','127.0.0.1','内网IP','','{\"msg\":\"已重算 5 台电梯的健康评分\",\"code\":200}',0,NULL,'2026-10-11 14:02:32',88),(119,'小区信息',1,'com.ruoyi.elevator.controller.CommunityController.addCommunity()','POST',1,'admin','','/basic/community','127.0.0.1','内网IP','{} ',NULL,1,'小区名称不能为空','2026-10-11 14:02:38',2),(120,'小区信息',2,'com.ruoyi.elevator.controller.CommunityController.editCommunity()','PUT',1,'admin','','/basic/community','127.0.0.1','内网IP','{} ',NULL,1,'小区ID不能为空','2026-10-11 14:02:38',1),(121,'小区信息',3,'com.ruoyi.elevator.controller.CommunityController.removeCommunity()','DELETE',1,'admin','','/basic/community/1','127.0.0.1','内网IP','[1] ',NULL,1,'小区【阳光家园小区】下还有 2 个楼栋，无法删除','2026-10-11 14:02:38',5),(122,'楼栋信息',1,'com.ruoyi.elevator.controller.CommunityController.addBuilding()','POST',1,'admin','','/basic/building','127.0.0.1','内网IP','{} ',NULL,1,'请选择所属小区','2026-10-11 14:02:38',2),(123,'楼栋信息',2,'com.ruoyi.elevator.controller.CommunityController.editBuilding()','PUT',1,'admin','','/basic/building','127.0.0.1','内网IP','{} ',NULL,1,'楼栋ID不能为空','2026-10-11 14:02:38',1),(124,'楼栋信息',3,'com.ruoyi.elevator.controller.CommunityController.removeBuilding()','DELETE',1,'admin','','/basic/building/1','127.0.0.1','内网IP','[1] ','{\"msg\":\"操作成功\",\"code\":200}',0,NULL,'2026-10-11 14:02:38',5),(125,'电梯信息',1,'com.ruoyi.elevator.controller.ElevatorController.add()','POST',1,'admin','','/basic/elevator','127.0.0.1','内网IP','{} ',NULL,1,'电梯编号不能为空','2026-10-11 14:02:38',1),(126,'电梯信息',2,'com.ruoyi.elevator.controller.ElevatorController.edit()','PUT',1,'admin','','/basic/elevator','127.0.0.1','内网IP','{} ',NULL,1,'电梯ID不能为空','2026-10-11 14:02:38',1),(127,'电梯信息',3,'com.ruoyi.elevator.controller.ElevatorController.remove()','DELETE',1,'admin','','/basic/elevator/1','127.0.0.1','内网IP','[1] ','{\"msg\":\"操作成功\",\"code\":200}',0,NULL,'2026-10-11 14:02:38',3),(128,'报修工单',2,'com.ruoyi.elevator.controller.RepairOrderController.reject()','PUT',1,'admin','','/repair/order/reject','127.0.0.1','内网IP','{} ',NULL,1,'驳回原因不能为空','2026-10-11 14:02:38',2),(129,'字典类型',3,'com.ruoyi.web.controller.system.SysDictDataController.remove()','DELETE',1,'admin','','/system/dict/data/1','127.0.0.1','内网IP','[1] ',NULL,1,'Cannot invoke \"com.ruoyi.common.core.domain.entity.SysDictData.getDictType()\" because \"data\" is null','2026-10-11 14:02:38',4),(130,'智能派单',2,'com.ruoyi.elevator.controller.DispatchController.assign()','POST',1,'admin','','/order/dispatch/assign','127.0.0.1','内网IP','{} ',NULL,1,'请选择维修员','2026-10-11 14:02:39',2),(131,'批量派单',2,'com.ruoyi.elevator.controller.DispatchController.batchAssign()','POST',1,'admin','','/order/dispatch/batchAssign','127.0.0.1','内网IP','{} ',NULL,1,'Cannot read the array length because \"<local5>\" is null','2026-10-11 14:02:39',1),(132,'维修接单',2,'com.ruoyi.elevator.controller.AcceptController.confirm()','POST',1,'admin','','/order/accept/confirm','127.0.0.1','内网IP','{} ',NULL,1,'工单不存在','2026-10-11 14:02:39',3),(133,'拒绝接单',2,'com.ruoyi.elevator.controller.AcceptController.refuse()','POST',1,'admin','','/order/accept/refuse','127.0.0.1','内网IP','{} ',NULL,1,'工单不存在','2026-10-11 14:02:39',4),(134,'维修到场',2,'com.ruoyi.elevator.controller.ProcessController.arrive()','POST',1,'admin','','/order/process/arrive','127.0.0.1','内网IP','{} ',NULL,1,'工单不存在','2026-10-11 14:02:39',3),(135,'维修排查',2,'com.ruoyi.elevator.controller.ProcessController.investigate()','POST',1,'admin','','/order/process/investigate','127.0.0.1','内网IP','{} ',NULL,1,'工单不存在','2026-10-11 14:02:39',5),(136,'维修完成',2,'com.ruoyi.elevator.controller.ProcessController.finish()','POST',1,'admin','','/order/process/finish','127.0.0.1','内网IP','{} ',NULL,1,'工单不存在','2026-10-11 14:02:39',4),(137,'异常工单重新指派',2,'com.ruoyi.elevator.controller.ExceptionController.reassign()','POST',1,'admin','','/order/exception/reassign','127.0.0.1','内网IP','{} ',NULL,1,'请选择新的维修员','2026-10-11 14:02:39',1),(138,'异常工单驳回',2,'com.ruoyi.elevator.controller.ExceptionController.reject()','POST',1,'admin','','/order/exception/reject','127.0.0.1','内网IP','{} ',NULL,1,'驳回原因不能为空','2026-10-11 14:02:39',2),(139,'工单异常上报',2,'com.ruoyi.elevator.controller.ExceptionController.report()','POST',1,'admin','','/order/exception/report','127.0.0.1','内网IP','{} ',NULL,1,'异常说明不能为空','2026-10-11 14:02:39',3),(140,'异常工单升级',2,'com.ruoyi.elevator.controller.ExceptionController.escalate()','POST',1,'admin','','/order/exception/escalate','127.0.0.1','内网IP','{} ',NULL,1,'工单不存在','2026-10-11 14:02:39',7),(141,'维保计划',1,'com.ruoyi.elevator.controller.MaintainPlanController.add()','POST',1,'admin','','/maintain/plan','127.0.0.1','内网IP','{} ',NULL,1,'计划名称不能为空','2026-10-11 14:02:39',2),(142,'维保计划',2,'com.ruoyi.elevator.controller.MaintainPlanController.edit()','PUT',1,'admin','','/maintain/plan','127.0.0.1','内网IP','{} ',NULL,1,'计划ID不能为空','2026-10-11 14:02:39',3),(143,'维保计划',3,'com.ruoyi.elevator.controller.MaintainPlanController.remove()','DELETE',1,'admin','','/maintain/plan/1','127.0.0.1','内网IP','[1] ','{\"msg\":\"操作成功\",\"code\":200}',0,NULL,'2026-10-11 14:02:39',4),(144,'维保计划状态',2,'com.ruoyi.elevator.controller.MaintainPlanController.changeStatus()','PUT',1,'admin','','/maintain/plan/changeStatus','127.0.0.1','内网IP','{} ',NULL,1,'计划状态不能为空','2026-10-11 14:02:39',1),(145,'维保检查项',1,'com.ruoyi.elevator.controller.MaintainPlanController.addTemplate()','POST',1,'admin','','/maintain/plan/template','127.0.0.1','内网IP','{} ',NULL,1,'检查项名称不能为空','2026-10-11 14:02:39',1),(146,'维保计划批量创建',1,'com.ruoyi.elevator.controller.MaintainPlanController.batchAdd()','POST',1,'admin','','/maintain/plan/batch','127.0.0.1','内网IP','{} ',NULL,1,'请选择至少一台电梯','2026-10-11 14:02:39',2),(147,'手动生成巡检工单',1,'com.ruoyi.elevator.controller.InspectionController.generate()','POST',1,'admin','','/maintain/inspection/generate','127.0.0.1','内网IP','','{\"msg\":\"本次生成巡检工单 5 条\",\"code\":200}',0,NULL,'2026-10-11 14:02:39',35),(148,'巡检提交',2,'com.ruoyi.elevator.controller.InspectionController.submit()','POST',1,'admin','','/maintain/inspection/submit','127.0.0.1','内网IP','{} ',NULL,1,'巡检任务不存在','2026-10-11 14:02:39',5),(149,'预警规则',1,'com.ruoyi.elevator.controller.WarningController.addRule()','POST',1,'admin','','/analysis/warning/rule','127.0.0.1','内网IP','{} ',NULL,1,'规则名称不能为空','2026-10-11 14:02:40',3),(150,'预警规则',2,'com.ruoyi.elevator.controller.WarningController.editRule()','PUT',1,'admin','','/analysis/warning/rule','127.0.0.1','内网IP','{} ',NULL,1,'规则ID不能为空','2026-10-11 14:02:40',2),(151,'预警规则状态',2,'com.ruoyi.elevator.controller.WarningController.changeRuleStatus()','PUT',1,'admin','','/analysis/warning/rule/changeStatus','127.0.0.1','内网IP','{} ',NULL,1,'启用状态不能为空','2026-10-11 14:02:40',2),(152,'维修接单',2,'com.ruoyi.elevator.controller.AcceptController.confirm()','POST',1,'weixiu01','','/order/accept/confirm','127.0.0.1','内网IP','{\"arriveMinutes\":30,\"orderId\":33} ','{\"msg\":\"操作成功\",\"code\":200}',0,NULL,'2026-10-11 14:03:22',18),(153,'维修到场',2,'com.ruoyi.elevator.controller.ProcessController.arrive()','POST',1,'weixiu01','','/order/process/arrive','127.0.0.1','内网IP','{\"orderId\":33} ','{\"msg\":\"操作成功\",\"code\":200}',0,NULL,'2026-10-11 14:03:22',13),(154,'异常工单升级',2,'com.ruoyi.elevator.controller.ExceptionController.escalate()','POST',1,'wuye01','','/order/exception/escalate','127.0.0.1','内网IP','{\"orderId\":35} ','{\"msg\":\"操作成功\",\"code\":200}',0,NULL,'2026-10-11 14:03:22',8),(155,'巡检打卡',2,'com.ruoyi.elevator.controller.InspectionController.clockIn()','POST',1,'weixiu01','','/maintain/inspection/clockIn','127.0.0.1','内网IP','{\"recordId\":\"1\"}',NULL,1,'该巡检任务已完成，不能重复提交','2026-10-11 14:03:22',6),(156,'巡检提交',2,'com.ruoyi.elevator.controller.InspectionController.submit()','POST',1,'weixiu01','','/maintain/inspection/submit','127.0.0.1','内网IP','{\"abnormalCount\":0,\"executeResult\":\"normal\",\"naCount\":0,\"normalCount\":10,\"recordId\":1} ',NULL,1,'该巡检任务已完成，不能重复提交','2026-10-11 14:03:22',5),(157,'小区信息',1,'com.ruoyi.elevator.controller.CommunityController.addCommunity()','POST',1,'admin','','/basic/community','127.0.0.1','内网IP','{} ',NULL,1,'小区名称不能为空','2026-10-11 14:03:33',1),(158,'小区信息',2,'com.ruoyi.elevator.controller.CommunityController.editCommunity()','PUT',1,'admin','','/basic/community','127.0.0.1','内网IP','{} ',NULL,1,'小区ID不能为空','2026-10-11 14:03:33',0),(159,'小区信息',3,'com.ruoyi.elevator.controller.CommunityController.removeCommunity()','DELETE',1,'admin','','/basic/community/1','127.0.0.1','内网IP','[1] ',NULL,1,'小区【阳光家园小区】下还有 2 个楼栋，无法删除','2026-10-11 14:03:33',5),(160,'楼栋信息',1,'com.ruoyi.elevator.controller.CommunityController.addBuilding()','POST',1,'admin','','/basic/building','127.0.0.1','内网IP','{} ',NULL,1,'请选择所属小区','2026-10-11 14:03:33',2),(161,'楼栋信息',2,'com.ruoyi.elevator.controller.CommunityController.editBuilding()','PUT',1,'admin','','/basic/building','127.0.0.1','内网IP','{} ',NULL,1,'楼栋ID不能为空','2026-10-11 14:03:33',1),(162,'楼栋信息',3,'com.ruoyi.elevator.controller.CommunityController.removeBuilding()','DELETE',1,'admin','','/basic/building/1','127.0.0.1','内网IP','[1] ','{\"msg\":\"操作成功\",\"code\":200}',0,NULL,'2026-10-11 14:03:33',6),(163,'电梯信息',1,'com.ruoyi.elevator.controller.ElevatorController.add()','POST',1,'admin','','/basic/elevator','127.0.0.1','内网IP','{} ',NULL,1,'电梯编号不能为空','2026-10-11 14:03:33',2),(164,'电梯信息',2,'com.ruoyi.elevator.controller.ElevatorController.edit()','PUT',1,'admin','','/basic/elevator','127.0.0.1','内网IP','{} ',NULL,1,'电梯ID不能为空','2026-10-11 14:03:33',2),(165,'电梯信息',3,'com.ruoyi.elevator.controller.ElevatorController.remove()','DELETE',1,'admin','','/basic/elevator/1','127.0.0.1','内网IP','[1] ','{\"msg\":\"操作成功\",\"code\":200}',0,NULL,'2026-10-11 14:03:33',3),(166,'报修工单',2,'com.ruoyi.elevator.controller.RepairOrderController.reject()','PUT',1,'admin','','/repair/order/reject','127.0.0.1','内网IP','{} ',NULL,1,'驳回原因不能为空','2026-10-11 14:03:33',1),(167,'字典类型',3,'com.ruoyi.web.controller.system.SysDictDataController.remove()','DELETE',1,'admin','','/system/dict/data/1','127.0.0.1','内网IP','[1] ',NULL,1,'Cannot invoke \"com.ruoyi.common.core.domain.entity.SysDictData.getDictType()\" because \"data\" is null','2026-10-11 14:03:33',4),(168,'智能派单',2,'com.ruoyi.elevator.controller.DispatchController.assign()','POST',1,'admin','','/order/dispatch/assign','127.0.0.1','内网IP','{} ',NULL,1,'请选择维修员','2026-10-11 14:03:34',2),(169,'批量派单',2,'com.ruoyi.elevator.controller.DispatchController.batchAssign()','POST',1,'admin','','/order/dispatch/batchAssign','127.0.0.1','内网IP','{} ',NULL,1,'Cannot read the array length because \"<local5>\" is null','2026-10-11 14:03:34',1),(170,'维修接单',2,'com.ruoyi.elevator.controller.AcceptController.confirm()','POST',1,'admin','','/order/accept/confirm','127.0.0.1','内网IP','{} ',NULL,1,'工单不存在','2026-10-11 14:03:34',4),(171,'拒绝接单',2,'com.ruoyi.elevator.controller.AcceptController.refuse()','POST',1,'admin','','/order/accept/refuse','127.0.0.1','内网IP','{} ',NULL,1,'工单不存在','2026-10-11 14:03:34',5),(172,'维修到场',2,'com.ruoyi.elevator.controller.ProcessController.arrive()','POST',1,'admin','','/order/process/arrive','127.0.0.1','内网IP','{} ',NULL,1,'工单不存在','2026-10-11 14:03:34',4),(173,'维修排查',2,'com.ruoyi.elevator.controller.ProcessController.investigate()','POST',1,'admin','','/order/process/investigate','127.0.0.1','内网IP','{} ',NULL,1,'工单不存在','2026-10-11 14:03:34',4),(174,'维修完成',2,'com.ruoyi.elevator.controller.ProcessController.finish()','POST',1,'admin','','/order/process/finish','127.0.0.1','内网IP','{} ',NULL,1,'工单不存在','2026-10-11 14:03:34',4),(175,'异常工单重新指派',2,'com.ruoyi.elevator.controller.ExceptionController.reassign()','POST',1,'admin','','/order/exception/reassign','127.0.0.1','内网IP','{} ',NULL,1,'请选择新的维修员','2026-10-11 14:03:34',1),(176,'异常工单驳回',2,'com.ruoyi.elevator.controller.ExceptionController.reject()','POST',1,'admin','','/order/exception/reject','127.0.0.1','内网IP','{} ',NULL,1,'驳回原因不能为空','2026-10-11 14:03:34',2),(177,'工单异常上报',2,'com.ruoyi.elevator.controller.ExceptionController.report()','POST',1,'admin','','/order/exception/report','127.0.0.1','内网IP','{} ',NULL,1,'异常说明不能为空','2026-10-11 14:03:34',2),(178,'异常工单升级',2,'com.ruoyi.elevator.controller.ExceptionController.escalate()','POST',1,'admin','','/order/exception/escalate','127.0.0.1','内网IP','{} ',NULL,1,'工单不存在','2026-10-11 14:03:34',4),(179,'维保计划',1,'com.ruoyi.elevator.controller.MaintainPlanController.add()','POST',1,'admin','','/maintain/plan','127.0.0.1','内网IP','{} ',NULL,1,'计划名称不能为空','2026-10-11 14:03:34',1),(180,'维保计划',2,'com.ruoyi.elevator.controller.MaintainPlanController.edit()','PUT',1,'admin','','/maintain/plan','127.0.0.1','内网IP','{} ',NULL,1,'计划ID不能为空','2026-10-11 14:03:34',1),(181,'维保计划',3,'com.ruoyi.elevator.controller.MaintainPlanController.remove()','DELETE',1,'admin','','/maintain/plan/1','127.0.0.1','内网IP','[1] ','{\"msg\":\"操作成功\",\"code\":200}',0,NULL,'2026-10-11 14:03:34',3),(182,'维保计划状态',2,'com.ruoyi.elevator.controller.MaintainPlanController.changeStatus()','PUT',1,'admin','','/maintain/plan/changeStatus','127.0.0.1','内网IP','{} ',NULL,1,'计划状态不能为空','2026-10-11 14:03:34',1),(183,'维保检查项',1,'com.ruoyi.elevator.controller.MaintainPlanController.addTemplate()','POST',1,'admin','','/maintain/plan/template','127.0.0.1','内网IP','{} ',NULL,1,'检查项名称不能为空','2026-10-11 14:03:34',1),(184,'维保计划批量创建',1,'com.ruoyi.elevator.controller.MaintainPlanController.batchAdd()','POST',1,'admin','','/maintain/plan/batch','127.0.0.1','内网IP','{} ',NULL,1,'请选择至少一台电梯','2026-10-11 14:03:34',3),(185,'手动生成巡检工单',1,'com.ruoyi.elevator.controller.InspectionController.generate()','POST',1,'admin','','/maintain/inspection/generate','127.0.0.1','内网IP','','{\"msg\":\"本次生成巡检工单 5 条\",\"code\":200}',0,NULL,'2026-10-11 14:03:34',23),(186,'巡检提交',2,'com.ruoyi.elevator.controller.InspectionController.submit()','POST',1,'admin','','/maintain/inspection/submit','127.0.0.1','内网IP','{} ',NULL,1,'巡检任务不存在','2026-10-11 14:03:34',4),(187,'预警规则',1,'com.ruoyi.elevator.controller.WarningController.addRule()','POST',1,'admin','','/analysis/warning/rule','127.0.0.1','内网IP','{} ',NULL,1,'规则名称不能为空','2026-10-11 14:03:34',1),(188,'预警规则',2,'com.ruoyi.elevator.controller.WarningController.editRule()','PUT',1,'admin','','/analysis/warning/rule','127.0.0.1','内网IP','{} ',NULL,1,'规则ID不能为空','2026-10-11 14:03:34',1),(189,'预警规则状态',2,'com.ruoyi.elevator.controller.WarningController.changeRuleStatus()','PUT',1,'admin','','/analysis/warning/rule/changeStatus','127.0.0.1','内网IP','{} ',NULL,1,'启用状态不能为空','2026-10-11 14:03:35',2),(190,'小区信息',1,'com.ruoyi.elevator.controller.CommunityController.addCommunity()','POST',1,'admin','','/basic/community','127.0.0.1','内网IP','{} ',NULL,1,'小区名称不能为空','2026-10-11 14:03:42',2),(191,'小区信息',2,'com.ruoyi.elevator.controller.CommunityController.editCommunity()','PUT',1,'admin','','/basic/community','127.0.0.1','内网IP','{} ',NULL,1,'小区ID不能为空','2026-10-11 14:03:42',1),(192,'小区信息',3,'com.ruoyi.elevator.controller.CommunityController.removeCommunity()','DELETE',1,'admin','','/basic/community/1','127.0.0.1','内网IP','[1] ',NULL,1,'小区【阳光家园小区】下还有 2 个楼栋，无法删除','2026-10-11 14:03:42',5),(193,'楼栋信息',1,'com.ruoyi.elevator.controller.CommunityController.addBuilding()','POST',1,'admin','','/basic/building','127.0.0.1','内网IP','{} ',NULL,1,'请选择所属小区','2026-10-11 14:03:42',1),(194,'楼栋信息',2,'com.ruoyi.elevator.controller.CommunityController.editBuilding()','PUT',1,'admin','','/basic/building','127.0.0.1','内网IP','{} ',NULL,1,'楼栋ID不能为空','2026-10-11 14:03:42',2),(195,'楼栋信息',3,'com.ruoyi.elevator.controller.CommunityController.removeBuilding()','DELETE',1,'admin','','/basic/building/1','127.0.0.1','内网IP','[1] ','{\"msg\":\"操作成功\",\"code\":200}',0,NULL,'2026-10-11 14:03:42',5),(196,'电梯信息',1,'com.ruoyi.elevator.controller.ElevatorController.add()','POST',1,'admin','','/basic/elevator','127.0.0.1','内网IP','{} ',NULL,1,'电梯编号不能为空','2026-10-11 14:03:42',1),(197,'电梯信息',2,'com.ruoyi.elevator.controller.ElevatorController.edit()','PUT',1,'admin','','/basic/elevator','127.0.0.1','内网IP','{} ',NULL,1,'电梯ID不能为空','2026-10-11 14:03:42',2),(198,'电梯信息',3,'com.ruoyi.elevator.controller.ElevatorController.remove()','DELETE',1,'admin','','/basic/elevator/1','127.0.0.1','内网IP','[1] ','{\"msg\":\"操作成功\",\"code\":200}',0,NULL,'2026-10-11 14:03:42',3),(199,'报修工单',2,'com.ruoyi.elevator.controller.RepairOrderController.reject()','PUT',1,'admin','','/repair/order/reject','127.0.0.1','内网IP','{} ',NULL,1,'驳回原因不能为空','2026-10-11 14:03:43',1),(200,'字典类型',3,'com.ruoyi.web.controller.system.SysDictDataController.remove()','DELETE',1,'admin','','/system/dict/data/1','127.0.0.1','内网IP','[1] ',NULL,1,'Cannot invoke \"com.ruoyi.common.core.domain.entity.SysDictData.getDictType()\" because \"data\" is null','2026-10-11 14:03:43',4),(201,'智能派单',2,'com.ruoyi.elevator.controller.DispatchController.assign()','POST',1,'admin','','/order/dispatch/assign','127.0.0.1','内网IP','{} ',NULL,1,'请选择维修员','2026-10-11 14:03:43',1),(202,'批量派单',2,'com.ruoyi.elevator.controller.DispatchController.batchAssign()','POST',1,'admin','','/order/dispatch/batchAssign','127.0.0.1','内网IP','{} ',NULL,1,'Cannot read the array length because \"<local5>\" is null','2026-10-11 14:03:43',2),(203,'维修接单',2,'com.ruoyi.elevator.controller.AcceptController.confirm()','POST',1,'admin','','/order/accept/confirm','127.0.0.1','内网IP','{} ',NULL,1,'工单不存在','2026-10-11 14:03:43',4),(204,'拒绝接单',2,'com.ruoyi.elevator.controller.AcceptController.refuse()','POST',1,'admin','','/order/accept/refuse','127.0.0.1','内网IP','{} ',NULL,1,'工单不存在','2026-10-11 14:03:43',4),(205,'维修到场',2,'com.ruoyi.elevator.controller.ProcessController.arrive()','POST',1,'admin','','/order/process/arrive','127.0.0.1','内网IP','{} ',NULL,1,'工单不存在','2026-10-11 14:03:43',4),(206,'维修排查',2,'com.ruoyi.elevator.controller.ProcessController.investigate()','POST',1,'admin','','/order/process/investigate','127.0.0.1','内网IP','{} ',NULL,1,'工单不存在','2026-10-11 14:03:43',3),(207,'维修完成',2,'com.ruoyi.elevator.controller.ProcessController.finish()','POST',1,'admin','','/order/process/finish','127.0.0.1','内网IP','{} ',NULL,1,'工单不存在','2026-10-11 14:03:43',3),(208,'异常工单重新指派',2,'com.ruoyi.elevator.controller.ExceptionController.reassign()','POST',1,'admin','','/order/exception/reassign','127.0.0.1','内网IP','{} ',NULL,1,'请选择新的维修员','2026-10-11 14:03:43',1),(209,'异常工单驳回',2,'com.ruoyi.elevator.controller.ExceptionController.reject()','POST',1,'admin','','/order/exception/reject','127.0.0.1','内网IP','{} ',NULL,1,'驳回原因不能为空','2026-10-11 14:03:43',1),(210,'工单异常上报',2,'com.ruoyi.elevator.controller.ExceptionController.report()','POST',1,'admin','','/order/exception/report','127.0.0.1','内网IP','{} ',NULL,1,'异常说明不能为空','2026-10-11 14:03:43',2),(211,'异常工单升级',2,'com.ruoyi.elevator.controller.ExceptionController.escalate()','POST',1,'admin','','/order/exception/escalate','127.0.0.1','内网IP','{} ',NULL,1,'工单不存在','2026-10-11 14:03:43',4),(212,'维保计划',1,'com.ruoyi.elevator.controller.MaintainPlanController.add()','POST',1,'admin','','/maintain/plan','127.0.0.1','内网IP','{} ',NULL,1,'计划名称不能为空','2026-10-11 14:03:44',1),(213,'维保计划',2,'com.ruoyi.elevator.controller.MaintainPlanController.edit()','PUT',1,'admin','','/maintain/plan','127.0.0.1','内网IP','{} ',NULL,1,'计划ID不能为空','2026-10-11 14:03:44',1),(214,'维保计划',3,'com.ruoyi.elevator.controller.MaintainPlanController.remove()','DELETE',1,'admin','','/maintain/plan/1','127.0.0.1','内网IP','[1] ','{\"msg\":\"操作成功\",\"code\":200}',0,NULL,'2026-10-11 14:03:44',4),(215,'维保计划状态',2,'com.ruoyi.elevator.controller.MaintainPlanController.changeStatus()','PUT',1,'admin','','/maintain/plan/changeStatus','127.0.0.1','内网IP','{} ',NULL,1,'计划状态不能为空','2026-10-11 14:03:44',2),(216,'维保检查项',1,'com.ruoyi.elevator.controller.MaintainPlanController.addTemplate()','POST',1,'admin','','/maintain/plan/template','127.0.0.1','内网IP','{} ',NULL,1,'检查项名称不能为空','2026-10-11 14:03:44',2),(217,'维保计划批量创建',1,'com.ruoyi.elevator.controller.MaintainPlanController.batchAdd()','POST',1,'admin','','/maintain/plan/batch','127.0.0.1','内网IP','{} ',NULL,1,'请选择至少一台电梯','2026-10-11 14:03:44',1),(218,'手动生成巡检工单',1,'com.ruoyi.elevator.controller.InspectionController.generate()','POST',1,'admin','','/maintain/inspection/generate','127.0.0.1','内网IP','','{\"msg\":\"本次生成巡检工单 5 条\",\"code\":200}',0,NULL,'2026-10-11 14:03:44',33),(219,'巡检提交',2,'com.ruoyi.elevator.controller.InspectionController.submit()','POST',1,'admin','','/maintain/inspection/submit','127.0.0.1','内网IP','{} ',NULL,1,'巡检任务不存在','2026-10-11 14:03:44',3),(220,'预警规则',1,'com.ruoyi.elevator.controller.WarningController.addRule()','POST',1,'admin','','/analysis/warning/rule','127.0.0.1','内网IP','{} ',NULL,1,'规则名称不能为空','2026-10-11 14:03:44',1),(221,'预警规则',2,'com.ruoyi.elevator.controller.WarningController.editRule()','PUT',1,'admin','','/analysis/warning/rule','127.0.0.1','内网IP','{} ',NULL,1,'规则ID不能为空','2026-10-11 14:03:44',2),(222,'预警规则状态',2,'com.ruoyi.elevator.controller.WarningController.changeRuleStatus()','PUT',1,'admin','','/analysis/warning/rule/changeStatus','127.0.0.1','内网IP','{} ',NULL,1,'启用状态不能为空','2026-10-11 14:03:44',2),(223,'巡检打卡',2,'com.ruoyi.elevator.controller.InspectionController.clockIn()','POST',1,'weixiu01','','/maintain/inspection/clockIn','127.0.0.1','内网IP','{\"recordId\":\"133\"}','{\"msg\":\"操作成功\",\"code\":200}',0,NULL,'2026-10-11 14:04:49',8),(224,'巡检提交',2,'com.ruoyi.elevator.controller.InspectionController.submit()','POST',1,'weixiu01','','/maintain/inspection/submit','127.0.0.1','内网IP','{\"abnormalCount\":0,\"abnormalDesc\":\"验收员测试执行\",\"executeResult\":\"normal\",\"naCount\":0,\"normalCount\":12,\"recordId\":133} ',NULL,1,'请至少填写一项检查结果','2026-10-11 14:04:49',5),(225,'巡检提交',2,'com.ruoyi.elevator.controller.InspectionController.submit()','POST',1,'weixiu01','','/maintain/inspection/submit','127.0.0.1','内网IP','{\"recordId\":133,\"submitItems\":[{\"checkResult\":\"normal\",\"itemCategory\":\"traction\",\"itemId\":11,\"itemName\":\"曳引机减速箱油质检查\",\"orderNum\":1,\"recordId\":133},{\"checkResult\":\"normal\",\"itemCategory\":\"traction\",\"itemId\":12,\"itemName\":\"钢丝绳张力均衡检查\",\"orderNum\":2,\"recordId\":133},{\"checkResult\":\"normal\",\"itemCategory\":\"traction\",\"itemId\":13,\"itemName\":\"导轨与导靴磨损检查\",\"orderNum\":3,\"recordId\":133},{\"checkResult\":\"normal\",\"itemCategory\":\"control\",\"itemId\":14,\"itemName\":\"平层准确度检查\",\"orderNum\":4,\"recordId\":133},{\"checkResult\":\"normal\",\"itemCategory\":\"safety\",\"itemId\":15,\"itemName\":\"超载装置动作检查\",\"orderNum\":5,\"recordId\":133},{\"checkResult\":\"normal\",\"itemCategory\":\"control\",\"itemId\":16,\"itemName\":\"接地保护与绝缘检查\",\"orderNum\":6,\"recordId\":133},{\"checkResult\":\"normal\",\"itemCategory\":\"other\",\"itemId\":17,\"itemName\":\"井道照明与底坑检查\",\"orderNum\":7,\"recordId\":133},{\"checkResult\":\"normal\",\"itemCategory\":\"other\",\"itemId\":18,\"itemName\":\"补偿链与随行电缆检查\",\"orderNum\":8,\"recordId\":133}]} ','{\"msg\":\"操作成功\",\"code\":200}',0,NULL,'2026-10-11 14:05:02',15),(226,'智能派单',2,'com.ruoyi.elevator.controller.DispatchController.assign()','POST',1,'wuye01','','/order/dispatch/assign','127.0.0.1','内网IP','{\"assigneeId\":101,\"orderId\":36} ','{\"msg\":\"操作成功\",\"code\":200}',0,NULL,'2026-10-11 14:06:52',13),(227,'维修接单',2,'com.ruoyi.elevator.controller.AcceptController.confirm()','POST',1,'weixiu01','','/order/accept/confirm','127.0.0.1','内网IP','{\"arriveMinutes\":30,\"orderId\":36} ','{\"msg\":\"操作成功\",\"code\":200}',0,NULL,'2026-10-11 14:06:52',12),(228,'维修到场',2,'com.ruoyi.elevator.controller.ProcessController.arrive()','POST',1,'weixiu01','','/order/process/arrive','127.0.0.1','内网IP','{\"orderId\":36} ','{\"msg\":\"操作成功\",\"code\":200}',0,NULL,'2026-10-11 14:06:52',13),(229,'维修排查',2,'com.ruoyi.elevator.controller.ProcessController.investigate()','POST',1,'weixiu01','','/order/process/investigate','127.0.0.1','内网IP','{\"orderId\":36} ','{\"msg\":\"操作成功\",\"code\":200}',0,NULL,'2026-10-11 14:06:52',12),(230,'维修完成',2,'com.ruoyi.elevator.controller.ProcessController.finish()','POST',1,'weixiu01','','/order/process/finish','127.0.0.1','内网IP','{\"finishTime\":\"2026-10-11 14:06:52\",\"orderId\":36,\"recordId\":23,\"repairDesc\":\"更换门机皮带，已恢复正常\",\"updateBy\":\"weixiu01\",\"workerId\":101} ','{\"msg\":\"操作成功\",\"code\":200}',0,NULL,'2026-10-11 14:06:52',20),(231,'故障频次统计',5,'com.ruoyi.elevator.controller.FrequencyController.export()','POST',1,'admin','','/analysis/frequency/export','127.0.0.1','内网IP','',NULL,0,NULL,'2026-10-11 14:07:10',1069),(232,'小区信息',5,'com.ruoyi.elevator.controller.CommunityController.exportCommunity()','POST',1,'admin','','/basic/community/export','127.0.0.1','内网IP','{} ',NULL,0,NULL,'2026-10-11 14:07:10',54),(233,'楼栋信息',5,'com.ruoyi.elevator.controller.CommunityController.exportBuilding()','POST',1,'admin','','/basic/building/export','127.0.0.1','内网IP','{} ',NULL,0,NULL,'2026-10-11 14:07:10',34),(234,'电梯信息',5,'com.ruoyi.elevator.controller.ElevatorController.export()','POST',1,'admin','','/basic/elevator/export','127.0.0.1','内网IP','{} ',NULL,0,NULL,'2026-10-11 14:07:10',37),(235,'报修工单',5,'com.ruoyi.elevator.controller.RepairOrderController.export()','POST',1,'admin','','/repair/order/export','127.0.0.1','内网IP','{} ',NULL,0,NULL,'2026-10-11 14:07:10',38),(236,'巡检记录',5,'com.ruoyi.elevator.controller.InspectionController.export()','POST',1,'admin','','/maintain/inspection/export','127.0.0.1','内网IP','{} ',NULL,0,NULL,'2026-10-11 14:07:10',44),(237,'维保档案',5,'com.ruoyi.elevator.controller.MaintainArchiveController.export()','POST',1,'admin','','/maintain/archive/export','127.0.0.1','内网IP','{} ',NULL,0,NULL,'2026-10-11 14:07:11',44),(238,'维修接单',2,'com.ruoyi.elevator.controller.AcceptController.confirm()','POST',1,'weixiu03','','/order/accept/confirm','127.0.0.1','内网IP','{\"arriveMinutes\":10,\"orderId\":31} ',NULL,1,'无权操作该数据','2026-10-11 14:07:20',4),(239,'拒绝接单',2,'com.ruoyi.elevator.controller.AcceptController.refuse()','POST',1,'weixiu03','','/order/accept/refuse','127.0.0.1','内网IP','{\"orderId\":31,\"remark\":\"越权\"} ',NULL,1,'无权操作该数据','2026-10-11 14:07:20',9),(240,'维修到场',2,'com.ruoyi.elevator.controller.ProcessController.arrive()','POST',1,'weixiu03','','/order/process/arrive','127.0.0.1','内网IP','{\"arriveLocation\":\"越权\",\"orderId\":31} ',NULL,1,'无权操作该数据','2026-10-11 14:07:20',8),(241,'维修排查',2,'com.ruoyi.elevator.controller.ProcessController.investigate()','POST',1,'weixiu03','','/order/process/investigate','127.0.0.1','内网IP','{\"investigateNote\":\"越权\",\"orderId\":31} ',NULL,1,'无权操作该数据','2026-10-11 14:07:20',7),(242,'维修完成',2,'com.ruoyi.elevator.controller.ProcessController.finish()','POST',1,'weixiu03','','/order/process/finish','127.0.0.1','内网IP','{\"orderId\":31,\"repairDesc\":\"越权\"} ',NULL,1,'无权操作该数据','2026-10-11 14:07:20',5),(243,'健康评分报告',5,'com.ruoyi.elevator.controller.HealthController.exportPdf()','POST',1,'admin','','/analysis/health/exportPdf','127.0.0.1','内网IP','{\"elevatorId\":\"2\"}',NULL,0,NULL,'2026-10-11 14:07:25',1427),(244,'健康评分明细',5,'com.ruoyi.elevator.controller.HealthController.exportExcel()','POST',1,'admin','','/analysis/health/exportExcel','127.0.0.1','内网IP','{\"elevatorId\":\"2\"}',NULL,0,NULL,'2026-10-11 14:07:26',39),(245,'手动生成巡检工单',1,'com.ruoyi.elevator.controller.InspectionController.generate()','POST',1,'admin','','/maintain/inspection/generate','127.0.0.1','内网IP','','{\"msg\":\"本次生成巡检工单 4 条\",\"code\":200}',0,NULL,'2026-10-11 14:08:17',41),(246,'手动生成巡检工单',1,'com.ruoyi.elevator.controller.InspectionController.generate()','POST',1,'admin','','/maintain/inspection/generate','127.0.0.1','内网IP','','{\"msg\":\"本次生成巡检工单 4 条\",\"code\":200}',0,NULL,'2026-10-11 14:08:17',25),(247,'报修工单',2,'com.ruoyi.elevator.controller.RepairOrderController.reject()','PUT',1,'wuye01','','/repair/order/reject','127.0.0.1','内网IP','{\"orderId\":35,\"rejectReason\":\"同秒编号测试前收尾（测试数据）\"} ','{\"msg\":\"操作成功\",\"code\":200}',0,NULL,'2026-10-11 14:08:37',19),(248,'拒绝接单',2,'com.ruoyi.elevator.controller.AcceptController.refuse()','POST',1,'weixiu01','','/order/accept/refuse','127.0.0.1','内网IP','{\"orderId\":34,\"remark\":\"同秒编号测试前收尾（测试数据）\"} ','{\"msg\":\"操作成功\",\"code\":200}',0,NULL,'2026-10-11 14:08:37',21),(249,'报修工单',2,'com.ruoyi.elevator.controller.RepairOrderController.reject()','PUT',1,'wuye01','','/repair/order/reject','127.0.0.1','内网IP','{\"orderId\":34,\"rejectReason\":\"同秒编号测试前收尾（测试数据）\"} ','{\"msg\":\"操作成功\",\"code\":200}',0,NULL,'2026-10-11 14:08:37',21),(250,'健康评分重算',2,'com.ruoyi.elevator.controller.HealthController.recalculate()','POST',1,'admin','','/analysis/health/recalculate','127.0.0.1','内网IP','','{\"msg\":\"已重算 6 台电梯的健康评分\",\"code\":200}',0,NULL,'2026-10-11 14:08:40',134),(251,'维修到场',2,'com.ruoyi.elevator.controller.ProcessController.arrive()','POST',1,'weixiu01','','/order/process/arrive','127.0.0.1','内网IP','{\"arriveLocation\":\"非法到场试探\",\"orderId\":32} ',NULL,1,'工单状态不能从【已完成】变更为【已到场】','2026-10-11 14:09:00',6),(252,'报修工单',2,'com.ruoyi.elevator.controller.RepairOrderController.reject()','PUT',1,'wuye01','','/repair/order/reject','127.0.0.1','内网IP','{\"orderId\":41,\"rejectReason\":\"请补充故障具体表现\"} ','{\"msg\":\"操作成功\",\"code\":200}',0,NULL,'2026-10-11 14:09:01',17),(253,'智能派单',2,'com.ruoyi.elevator.controller.DispatchController.assign()','POST',1,'wuye01','','/order/dispatch/assign','127.0.0.1','内网IP','{\"assigneeId\":101,\"orderId\":41,\"remark\":\"复验闭环派单\"} ','{\"msg\":\"操作成功\",\"code\":200}',0,NULL,'2026-10-11 14:09:01',19),(254,'维修接单',2,'com.ruoyi.elevator.controller.AcceptController.confirm()','POST',1,'weixiu01','','/order/accept/confirm','127.0.0.1','内网IP','{\"arriveMinutes\":15,\"orderId\":41} ','{\"msg\":\"操作成功\",\"code\":200}',0,NULL,'2026-10-11 14:09:01',18),(255,'维修到场',2,'com.ruoyi.elevator.controller.ProcessController.arrive()','POST',1,'weixiu01','','/order/process/arrive','127.0.0.1','内网IP','{\"arriveLocation\":\"和平里小区 3号楼1单元\",\"orderId\":41} ','{\"msg\":\"操作成功\",\"code\":200}',0,NULL,'2026-10-11 14:09:01',19),(256,'维修排查',2,'com.ruoyi.elevator.controller.ProcessController.investigate()','POST',1,'weixiu01','','/order/process/investigate','127.0.0.1','内网IP','{\"investigateNote\":\"门机控制器参数异常，门锁回路接触不良\",\"orderId\":41} ','{\"msg\":\"操作成功\",\"code\":200}',0,NULL,'2026-10-11 14:09:01',16),(257,'维修完成',2,'com.ruoyi.elevator.controller.ProcessController.finish()','POST',1,'weixiu01','','/order/process/finish','127.0.0.1','内网IP','{\"faultReason\":\"controller_params\",\"finishTime\":\"2026-10-11 14:09:01\",\"orderId\":41,\"recordId\":24,\"repairDesc\":\"复位门机控制器参数并更换门锁触点，开关门测试 30 次正常\",\"replaceParts\":\"门锁触点 2 只\",\"updateBy\":\"weixiu01\",\"workerId\":101} ','{\"msg\":\"操作成功\",\"code\":200}',0,NULL,'2026-10-11 14:09:01',28),(258,'巡检提交',2,'com.ruoyi.elevator.controller.InspectionController.submit()','POST',1,'weixiu01','','/maintain/inspection/submit','127.0.0.1','内网IP','{} ',NULL,1,'巡检任务不存在','2026-10-11 14:11:11',4),(259,'维修接单',2,'com.ruoyi.elevator.controller.AcceptController.confirm()','POST',1,'weixiu01','','/order/accept/confirm','127.0.0.1','内网IP','{} ',NULL,1,'工单不存在','2026-10-11 14:11:12',3),(260,'拒绝接单',2,'com.ruoyi.elevator.controller.AcceptController.refuse()','POST',1,'weixiu01','','/order/accept/refuse','127.0.0.1','内网IP','{} ',NULL,1,'工单不存在','2026-10-11 14:11:12',3),(261,'工单异常上报',2,'com.ruoyi.elevator.controller.ExceptionController.report()','POST',1,'weixiu01','','/order/exception/report','127.0.0.1','内网IP','{} ',NULL,1,'异常说明不能为空','2026-10-11 14:11:12',1),(262,'维修到场',2,'com.ruoyi.elevator.controller.ProcessController.arrive()','POST',1,'weixiu01','','/order/process/arrive','127.0.0.1','内网IP','{} ',NULL,1,'工单不存在','2026-10-11 14:11:12',4),(263,'维修完成',2,'com.ruoyi.elevator.controller.ProcessController.finish()','POST',1,'weixiu01','','/order/process/finish','127.0.0.1','内网IP','{} ',NULL,1,'工单不存在','2026-10-11 14:11:12',4),(264,'维修排查',2,'com.ruoyi.elevator.controller.ProcessController.investigate()','POST',1,'weixiu01','','/order/process/investigate','127.0.0.1','内网IP','{} ',NULL,1,'工单不存在','2026-10-11 14:11:12',4),(265,'批量派单',2,'com.ruoyi.elevator.controller.DispatchController.batchAssign()','POST',1,'wuye01','','/order/dispatch/batchAssign','127.0.0.1','内网IP','{\"assigneeId\":101,\"orderIds\":[35,38]} ','{\"msg\":\"操作成功\",\"code\":200}',0,NULL,'2026-10-11 14:12:09',19);
/*!40000 ALTER TABLE `sys_oper_log` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `sys_role`
--

DROP TABLE IF EXISTS `sys_role`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sys_role` (
  `role_id` bigint NOT NULL AUTO_INCREMENT COMMENT '角色ID',
  `role_name` varchar(30) COLLATE utf8mb4_general_ci NOT NULL COMMENT '角色名称',
  `role_key` varchar(100) COLLATE utf8mb4_general_ci NOT NULL COMMENT '角色权限字符串',
  `role_sort` int NOT NULL COMMENT '显示顺序',
  `data_scope` char(1) COLLATE utf8mb4_general_ci DEFAULT '1' COMMENT '数据范围（1：全部数据权限 5：仅本人数据权限）',
  `menu_check_strictly` tinyint(1) DEFAULT '1' COMMENT '菜单树选择项是否关联显示',
  `status` char(1) COLLATE utf8mb4_general_ci NOT NULL COMMENT '角色状态（0正常 1停用）',
  `del_flag` char(1) COLLATE utf8mb4_general_ci DEFAULT '0' COMMENT '删除标志（0代表存在 2代表删除）',
  `create_by` varchar(64) COLLATE utf8mb4_general_ci DEFAULT '' COMMENT '创建者',
  `create_time` datetime DEFAULT NULL COMMENT '创建时间',
  `update_by` varchar(64) COLLATE utf8mb4_general_ci DEFAULT '' COMMENT '更新者',
  `update_time` datetime DEFAULT NULL COMMENT '更新时间',
  `remark` varchar(500) COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '备注',
  PRIMARY KEY (`role_id`)
) ENGINE=InnoDB AUTO_INCREMENT=100 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='角色信息表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `sys_role`
--

LOCK TABLES `sys_role` WRITE;
/*!40000 ALTER TABLE `sys_role` DISABLE KEYS */;
INSERT INTO `sys_role` VALUES (1,'超级管理员','admin',1,'1',1,'0','0','admin','2026-10-02 14:30:22','',NULL,'超级管理员'),(2,'普通角色','common',2,'2',1,'0','0','admin','2026-10-02 14:30:22','',NULL,'普通角色'),(3,'物业','property',2,'1',1,'0','0','admin','2026-10-02 14:30:24','',NULL,'物业管理人员，负责审核报修单、派发工单、管理维保计划、查看统计报表'),(4,'维修员','worker',3,'1',1,'0','0','admin','2026-10-02 14:30:24','',NULL,'维保单位人员，负责接单、反馈到场时间、记录维修过程、执行巡检任务'),(5,'业主','owner',4,'5',1,'0','0','admin','2026-10-02 14:30:24','',NULL,'电梯使用者，负责提交故障报修、上传证据、查看报修进度、确认维修结果');
/*!40000 ALTER TABLE `sys_role` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `sys_role_menu`
--

DROP TABLE IF EXISTS `sys_role_menu`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sys_role_menu` (
  `role_id` bigint NOT NULL COMMENT '角色ID',
  `menu_id` bigint NOT NULL COMMENT '菜单ID',
  PRIMARY KEY (`role_id`,`menu_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='角色和菜单关联表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `sys_role_menu`
--

LOCK TABLES `sys_role_menu` WRITE;
/*!40000 ALTER TABLE `sys_role_menu` DISABLE KEYS */;
INSERT INTO `sys_role_menu` VALUES (1,2000),(1,2001),(1,2002),(1,2003),(1,2004),(1,2102),(1,2103),(1,2104),(1,2105),(1,2106),(1,2107),(1,2108),(1,2109),(1,2110),(1,2111),(1,2112),(1,2113),(1,2114),(1,2115),(1,2116),(1,2208),(1,2209),(1,2210),(1,2211),(1,2212),(1,2213),(1,2214),(1,2215),(1,2216),(1,2217),(1,2218),(1,2219),(1,2220),(1,2221),(1,2222),(1,2223),(1,2224),(1,2225),(1,2226),(1,2227),(1,2228),(1,2229),(1,2230),(1,2231),(1,2232),(1,2233),(1,2234),(1,2235),(1,2236),(1,2237),(1,2238),(1,2239),(1,2240),(1,2241),(1,2242),(1,2243),(2,1),(2,2),(2,100),(2,101),(2,102),(2,105),(2,106),(2,107),(2,108),(2,109),(2,110),(2,111),(2,112),(2,113),(2,114),(2,500),(2,501),(2,1000),(2,1001),(2,1002),(2,1003),(2,1004),(2,1005),(2,1006),(2,1007),(2,1008),(2,1009),(2,1010),(2,1011),(2,1012),(2,1013),(2,1014),(2,1015),(2,1025),(2,1026),(2,1027),(2,1028),(2,1029),(2,1030),(2,1031),(2,1032),(2,1033),(2,1034),(2,1035),(2,1036),(2,1037),(2,1038),(2,1039),(2,1040),(2,1041),(2,1042),(2,1043),(2,1044),(2,1045),(2,1046),(2,1047),(2,1048),(2,1049),(2,1050),(2,1051),(2,1052),(2,1053),(2,1054),(3,2000),(3,2001),(3,2002),(3,2003),(3,2004),(3,2102),(3,2103),(3,2104),(3,2105),(3,2106),(3,2107),(3,2108),(3,2109),(3,2110),(3,2111),(3,2112),(3,2113),(3,2114),(3,2115),(3,2116),(3,2208),(3,2209),(3,2210),(3,2211),(3,2212),(3,2213),(3,2214),(3,2215),(3,2216),(3,2217),(3,2218),(3,2219),(3,2220),(3,2221),(3,2222),(3,2223),(3,2224),(3,2225),(3,2226),(3,2227),(3,2228),(3,2229),(3,2230),(3,2231),(3,2232),(3,2233),(3,2234),(3,2235),(3,2236),(3,2237),(3,2238),(3,2239),(3,2240),(3,2241),(3,2242),(3,2243),(4,2001),(4,2002),(4,2003),(4,2106),(4,2108),(4,2109),(4,2112),(4,2220),(4,2223),(4,2224),(4,2225),(4,2226),(4,2233),(4,2234),(5,2001),(5,2106),(5,2220);
/*!40000 ALTER TABLE `sys_role_menu` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `sys_user`
--

DROP TABLE IF EXISTS `sys_user`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sys_user` (
  `user_id` bigint NOT NULL AUTO_INCREMENT COMMENT '用户ID',
  `user_name` varchar(30) COLLATE utf8mb4_general_ci NOT NULL COMMENT '用户账号',
  `nick_name` varchar(30) COLLATE utf8mb4_general_ci NOT NULL COMMENT '用户昵称',
  `user_type` varchar(2) COLLATE utf8mb4_general_ci DEFAULT '00' COMMENT '用户类型（00系统用户）',
  `email` varchar(50) COLLATE utf8mb4_general_ci DEFAULT '' COMMENT '用户邮箱',
  `phonenumber` varchar(11) COLLATE utf8mb4_general_ci DEFAULT '' COMMENT '手机号码',
  `sex` char(1) COLLATE utf8mb4_general_ci DEFAULT '0' COMMENT '用户性别（0男 1女 2未知）',
  `avatar` varchar(100) COLLATE utf8mb4_general_ci DEFAULT '' COMMENT '头像地址',
  `password` varchar(100) COLLATE utf8mb4_general_ci DEFAULT '' COMMENT '密码',
  `status` char(1) COLLATE utf8mb4_general_ci DEFAULT '0' COMMENT '账号状态（0正常 1停用）',
  `del_flag` char(1) COLLATE utf8mb4_general_ci DEFAULT '0' COMMENT '删除标志（0代表存在 2代表删除）',
  `login_ip` varchar(128) COLLATE utf8mb4_general_ci DEFAULT '' COMMENT '最后登录IP',
  `login_date` datetime DEFAULT NULL COMMENT '最后登录时间',
  `pwd_update_date` datetime DEFAULT NULL COMMENT '密码最后更新时间',
  `create_by` varchar(64) COLLATE utf8mb4_general_ci DEFAULT '' COMMENT '创建者',
  `create_time` datetime DEFAULT NULL COMMENT '创建时间',
  `update_by` varchar(64) COLLATE utf8mb4_general_ci DEFAULT '' COMMENT '更新者',
  `update_time` datetime DEFAULT NULL COMMENT '更新时间',
  `remark` varchar(500) COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '备注',
  `community_id` bigint DEFAULT NULL COMMENT '所属小区ID（论文表3-1，用于数据权限按小区隔离）',
  PRIMARY KEY (`user_id`),
  UNIQUE KEY `uk_user_phonenumber` (`phonenumber`)
) ENGINE=InnoDB AUTO_INCREMENT=106 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='用户信息表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `sys_user`
--

LOCK TABLES `sys_user` WRITE;
/*!40000 ALTER TABLE `sys_user` DISABLE KEYS */;
INSERT INTO `sys_user` VALUES (1,'admin','若依','00','ry@163.com','15888888888','1','','$2a$10$7JB720yubVSZvUI0rEqK/.VqGOZTH.ulu33dHOiBE8ByOhJIrdAu2','0','0','127.0.0.1','2026-10-11 14:09:40','2026-10-02 14:30:22','admin','2026-10-02 14:30:22','','2026-10-11 14:01:59','管理员',NULL),(2,'ry','若依','00','ry@qq.com','15666666666','1','','$2a$10$7JB720yubVSZvUI0rEqK/.VqGOZTH.ulu33dHOiBE8ByOhJIrdAu2','0','0','127.0.0.1','2026-10-02 14:30:22','2026-10-02 14:30:22','admin','2026-10-02 14:30:22','',NULL,'测试员',NULL),(100,'wuye01','物业管理员','00','wuye01@elevator.com','13800000001','1','','$2a$10$gyEgAsudVRZUUksP49d6geVDVNz6W5gWBdzlJ7ssKxdf07z1XwRIi','0','0','127.0.0.1','2026-10-11 14:09:01','2026-10-02 14:30:24','admin','2026-10-02 14:30:24','',NULL,'阳光家园小区物业管理员',1),(101,'weixiu01','维修员王师傅','00','weixiu01@elevator.com','13800000002','1','','$2a$10$gyEgAsudVRZUUksP49d6geVDVNz6W5gWBdzlJ7ssKxdf07z1XwRIi','0','0','127.0.0.1','2026-10-11 14:11:12','2026-10-02 14:30:24','admin','2026-10-02 14:30:24','',NULL,'黑龙江安捷电梯维保有限公司，负责阳光家园小区',1),(102,'yezhu01','业主张阿姨','00','yezhu01@elevator.com','13800000003','1','','$2a$10$gyEgAsudVRZUUksP49d6geVDVNz6W5gWBdzlJ7ssKxdf07z1XwRIi','0','0','127.0.0.1','2026-10-11 14:09:00','2026-10-02 14:30:24','admin','2026-10-02 14:30:24','',NULL,'阳光家园小区1号楼1单元业主',1),(103,'weixiu02','维修员李师傅','00','weixiu02@elevator.com','13800000004','1','','$2a$10$gyEgAsudVRZUUksP49d6geVDVNz6W5gWBdzlJ7ssKxdf07z1XwRIi','0','0','127.0.0.1','2026-10-02 14:30:24','2026-10-02 14:30:24','admin','2026-10-02 14:30:24','',NULL,'哈尔滨华信机电设备有限公司，负责和平里小区',2),(104,'weixiu03','维修员赵师傅','00','weixiu03@elevator.com','13800000005','1','','$2a$10$gyEgAsudVRZUUksP49d6geVDVNz6W5gWBdzlJ7ssKxdf07z1XwRIi','0','0','127.0.0.1','2026-10-11 14:07:21','2026-10-02 14:30:24','admin','2026-10-02 14:30:24','',NULL,'黑龙江广日电梯工程有限公司，负责铁路新村小区',3),(105,'owner2test','验证业主乙','00','','13800009999','0','','$2a$10$lDlaJGYPIjPAjvlCYScrQ.sZ3ClClWoI.9D5FAldcZijOsxCeiQJe','0','0','127.0.0.1','2026-10-11 14:07:19',NULL,'register','2026-10-11 14:04:45','',NULL,NULL,2);
/*!40000 ALTER TABLE `sys_user` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `sys_user_role`
--

DROP TABLE IF EXISTS `sys_user_role`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sys_user_role` (
  `user_id` bigint NOT NULL COMMENT '用户ID',
  `role_id` bigint NOT NULL COMMENT '角色ID',
  PRIMARY KEY (`user_id`,`role_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='用户和角色关联表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `sys_user_role`
--

LOCK TABLES `sys_user_role` WRITE;
/*!40000 ALTER TABLE `sys_user_role` DISABLE KEYS */;
INSERT INTO `sys_user_role` VALUES (1,1),(2,2),(100,3),(101,4),(102,5),(103,4),(104,4),(105,5);
/*!40000 ALTER TABLE `sys_user_role` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `warning_info`
--

DROP TABLE IF EXISTS `warning_info`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `warning_info` (
  `warning_id` bigint NOT NULL AUTO_INCREMENT COMMENT '预警ID',
  `rule_id` bigint DEFAULT NULL COMMENT '触发规则ID',
  `warning_type` varchar(30) COLLATE utf8mb4_general_ci NOT NULL COMMENT '预警类型（order_timeout工单超时 maintain_due维保临期）',
  `biz_sub_type` varchar(30) COLLATE utf8mb4_general_ci DEFAULT '' COMMENT '业务子类型',
  `biz_id` bigint DEFAULT NULL COMMENT '关联业务ID，指向工单或维保计划',
  `biz_no` varchar(50) COLLATE utf8mb4_general_ci DEFAULT '' COMMENT '关联业务编号',
  `warning_content` varchar(500) COLLATE utf8mb4_general_ci NOT NULL COMMENT '预警内容',
  `elevator_id` bigint DEFAULT NULL COMMENT '关联电梯ID',
  `receiver_id` bigint DEFAULT NULL COMMENT '接收人ID',
  `receiver_role` varchar(30) COLLATE utf8mb4_general_ci DEFAULT '' COMMENT '接收人角色',
  `is_read` char(1) COLLATE utf8mb4_general_ci DEFAULT '0' COMMENT '是否已读（0未读 1已读）',
  `read_time` datetime DEFAULT NULL COMMENT '阅读时间',
  `warning_time` datetime DEFAULT NULL COMMENT '预警生成时间',
  `create_time` datetime DEFAULT NULL COMMENT '创建时间',
  PRIMARY KEY (`warning_id`),
  KEY `idx_warning_receiver` (`receiver_id`,`is_read`),
  KEY `idx_warning_biz` (`biz_id`)
) ENGINE=InnoDB AUTO_INCREMENT=30 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='预警信息表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `warning_info`
--

LOCK TABLES `warning_info` WRITE;
/*!40000 ALTER TABLE `warning_info` DISABLE KEYS */;
INSERT INTO `warning_info` VALUES (1,6,'maintain_due','overdue',4,'4','电梯【DT-C-001】半月保标准模板的维保计划【3号楼1单元半月保】已超期 78 天',4,100,'property','0',NULL,'2026-10-02 15:00:00','2026-10-02 15:00:00'),(2,6,'maintain_due','overdue',4,'4','电梯【DT-C-001】半月保标准模板的维保计划【3号楼1单元半月保】已超期 78 天',4,101,'worker','1','2026-10-11 14:11:12','2026-10-02 15:00:00','2026-10-02 15:00:00'),(3,6,'maintain_due','overdue',4,'4','电梯【DT-C-001】半月保标准模板的维保计划【3号楼1单元半月保】已超期 78 天',4,103,'worker','0',NULL,'2026-10-02 15:00:00','2026-10-02 15:00:00'),(4,6,'maintain_due','overdue',4,'4','电梯【DT-C-001】半月保标准模板的维保计划【3号楼1单元半月保】已超期 78 天',4,104,'worker','0',NULL,'2026-10-02 15:00:00','2026-10-02 15:00:00'),(5,6,'maintain_due','overdue',7,'7','电梯【DT-A-001】季度检标准模板的维保计划【1号楼1单元季度检】已超期 1 天',1,100,'property','0',NULL,'2026-10-02 15:00:00','2026-10-02 15:00:00'),(6,6,'maintain_due','overdue',7,'7','电梯【DT-A-001】季度检标准模板的维保计划【1号楼1单元季度检】已超期 1 天',1,101,'worker','1','2026-10-11 14:11:12','2026-10-02 15:00:00','2026-10-02 15:00:00'),(7,6,'maintain_due','overdue',7,'7','电梯【DT-A-001】季度检标准模板的维保计划【1号楼1单元季度检】已超期 1 天',1,103,'worker','0',NULL,'2026-10-02 15:00:00','2026-10-02 15:00:00'),(8,6,'maintain_due','overdue',7,'7','电梯【DT-A-001】季度检标准模板的维保计划【1号楼1单元季度检】已超期 1 天',1,104,'worker','0',NULL,'2026-10-02 15:00:00','2026-10-02 15:00:00'),(9,6,'maintain_due','overdue',8,'8','电梯【DT-A-002】季度检标准模板的维保计划【1号楼2单元季度检】已超期 1 天',2,100,'property','0',NULL,'2026-10-02 15:00:00','2026-10-02 15:00:00'),(10,6,'maintain_due','overdue',8,'8','电梯【DT-A-002】季度检标准模板的维保计划【1号楼2单元季度检】已超期 1 天',2,101,'worker','1','2026-10-11 14:11:12','2026-10-02 15:00:00','2026-10-02 15:00:00'),(11,6,'maintain_due','overdue',8,'8','电梯【DT-A-002】季度检标准模板的维保计划【1号楼2单元季度检】已超期 1 天',2,103,'worker','0',NULL,'2026-10-02 15:00:00','2026-10-02 15:00:00'),(12,6,'maintain_due','overdue',8,'8','电梯【DT-A-002】季度检标准模板的维保计划【1号楼2单元季度检】已超期 1 天',2,104,'worker','0',NULL,'2026-10-02 15:00:00','2026-10-02 15:00:00'),(13,6,'maintain_due','overdue',9,'9','电梯【DT-B-001】季度检标准模板的维保计划【2号楼1单元季度检】已超期 1 天',3,100,'property','0',NULL,'2026-10-02 15:00:00','2026-10-02 15:00:00'),(14,6,'maintain_due','overdue',9,'9','电梯【DT-B-001】季度检标准模板的维保计划【2号楼1单元季度检】已超期 1 天',3,101,'worker','1','2026-10-11 14:11:12','2026-10-02 15:00:00','2026-10-02 15:00:00'),(15,6,'maintain_due','overdue',9,'9','电梯【DT-B-001】季度检标准模板的维保计划【2号楼1单元季度检】已超期 1 天',3,103,'worker','0',NULL,'2026-10-02 15:00:00','2026-10-02 15:00:00'),(16,6,'maintain_due','overdue',9,'9','电梯【DT-B-001】季度检标准模板的维保计划【2号楼1单元季度检】已超期 1 天',3,104,'worker','0',NULL,'2026-10-02 15:00:00','2026-10-02 15:00:00'),(17,6,'maintain_due','overdue',10,'10','电梯【DT-C-002】季度检标准模板的维保计划【4号楼1单元季度检】已超期 1 天',5,100,'property','0',NULL,'2026-10-02 15:00:00','2026-10-02 15:00:00'),(18,6,'maintain_due','overdue',10,'10','电梯【DT-C-002】季度检标准模板的维保计划【4号楼1单元季度检】已超期 1 天',5,101,'worker','1','2026-10-11 14:11:12','2026-10-02 15:00:00','2026-10-02 15:00:00'),(19,6,'maintain_due','overdue',10,'10','电梯【DT-C-002】季度检标准模板的维保计划【4号楼1单元季度检】已超期 1 天',5,103,'worker','0',NULL,'2026-10-02 15:00:00','2026-10-02 15:00:00'),(20,6,'maintain_due','overdue',10,'10','电梯【DT-C-002】季度检标准模板的维保计划【4号楼1单元季度检】已超期 1 天',5,104,'worker','0',NULL,'2026-10-02 15:00:00','2026-10-02 15:00:00'),(21,2,'order_timeout','accept',15,'BX20261002193248','工单【BX20261002193248】接单超时，电梯【DT-A-001】，报修人【业主张阿姨】',1,101,'worker','1','2026-10-11 14:11:12','2026-10-02 20:30:00','2026-10-02 20:30:00'),(22,2,'order_timeout','accept',15,'BX20261002193248','工单【BX20261002193248】接单超时，电梯【DT-A-001】，报修人【业主张阿姨】',1,103,'worker','0',NULL,'2026-10-02 20:30:00','2026-10-02 20:30:00'),(23,2,'order_timeout','accept',15,'BX20261002193248','工单【BX20261002193248】接单超时，电梯【DT-A-001】，报修人【业主张阿姨】',1,104,'worker','0',NULL,'2026-10-02 20:30:00','2026-10-02 20:30:00'),(24,2,'order_timeout','accept',15,'BX20261002193248','工单【BX20261002193248】接单超时，电梯【DT-A-001】，报修人【业主张阿姨】',1,100,'property','0',NULL,'2026-10-02 20:30:00','2026-10-02 20:30:00'),(25,6,'maintain_due','overdue',6,'6','电梯【DT-D-001】半月保标准模板的维保计划【A座1单元半月保】已超期 2 天',6,100,'property','0',NULL,'2026-10-11 13:38:37','2026-10-11 13:38:37'),(26,6,'maintain_due','overdue',6,'6','电梯【DT-D-001】半月保标准模板的维保计划【A座1单元半月保】已超期 2 天',6,101,'worker','1','2026-10-11 14:11:12','2026-10-11 13:38:37','2026-10-11 13:38:37'),(27,6,'maintain_due','overdue',6,'6','电梯【DT-D-001】半月保标准模板的维保计划【A座1单元半月保】已超期 2 天',6,103,'worker','0',NULL,'2026-10-11 13:38:37','2026-10-11 13:38:37'),(28,6,'maintain_due','overdue',6,'6','电梯【DT-D-001】半月保标准模板的维保计划【A座1单元半月保】已超期 2 天',6,104,'worker','0',NULL,'2026-10-11 13:38:37','2026-10-11 13:38:37'),(29,1,'order_timeout','assign',35,'BX20261011140229001','工单【BX20261011140229001】派单超时，电梯【DT-A-002】，报修人【业主张阿姨】',2,100,'property','0',NULL,'2026-10-11 14:02:30','2026-10-11 14:02:30');
/*!40000 ALTER TABLE `warning_info` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `warning_rule`
--

DROP TABLE IF EXISTS `warning_rule`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `warning_rule` (
  `rule_id` bigint NOT NULL AUTO_INCREMENT COMMENT '规则ID',
  `rule_name` varchar(100) COLLATE utf8mb4_general_ci NOT NULL COMMENT '规则名称',
  `rule_type` varchar(30) COLLATE utf8mb4_general_ci NOT NULL COMMENT '规则类型（order_timeout工单超时 maintain_due维保临期）',
  `biz_sub_type` varchar(30) COLLATE utf8mb4_general_ci DEFAULT '' COMMENT '业务子类型（assign派单超时 accept接单超时 arrive到场超时 repair维修超时 confirm确认超时 due_soon临近维保 overdue已超维保）',
  `threshold_value` int NOT NULL COMMENT '阈值',
  `threshold_unit` varchar(10) COLLATE utf8mb4_general_ci DEFAULT 'minute' COMMENT '阈值单位（minute分钟 hour小时 day天）',
  `notify_roles` varchar(100) COLLATE utf8mb4_general_ci DEFAULT '' COMMENT '通知对象角色（多个用逗号分隔，如 property,worker）',
  `enabled` char(1) COLLATE utf8mb4_general_ci DEFAULT '0' COMMENT '是否启用（0启用 1停用）',
  `repeat_interval` int DEFAULT '0' COMMENT '重复推送间隔（分钟），0表示同周期不重复推送',
  `create_by` varchar(64) COLLATE utf8mb4_general_ci DEFAULT '' COMMENT '创建者',
  `create_time` datetime DEFAULT NULL COMMENT '创建时间',
  `update_by` varchar(64) COLLATE utf8mb4_general_ci DEFAULT '' COMMENT '更新者',
  `update_time` datetime DEFAULT NULL COMMENT '更新时间',
  `remark` varchar(500) COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '备注',
  PRIMARY KEY (`rule_id`)
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='预警规则表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `warning_rule`
--

LOCK TABLES `warning_rule` WRITE;
/*!40000 ALTER TABLE `warning_rule` DISABLE KEYS */;
INSERT INTO `warning_rule` VALUES (1,'派单超时预警','order_timeout','assign',30,'minute','property','0',0,'admin','2026-10-02 14:30:24','',NULL,'工单报修后30分钟未派单'),(2,'接单超时预警','order_timeout','accept',30,'minute','worker,property','0',0,'admin','2026-10-02 14:30:24','',NULL,'派单后30分钟未接单'),(3,'到场超时预警','order_timeout','arrive',120,'minute','worker,property','0',0,'admin','2026-10-02 14:30:24','',NULL,'接单后2小时未到场'),(4,'维修超时预警','order_timeout','repair',24,'hour','worker,property','0',0,'admin','2026-10-02 14:30:24','',NULL,'到场后24小时未完成维修'),(5,'维保临期预警','maintain_due','due_soon',3,'day','property,worker','0',0,'admin','2026-10-02 14:30:24','',NULL,'距离计划维保日期不足3天'),(6,'维保超期预警','maintain_due','overdue',0,'day','property,worker','0',0,'admin','2026-10-02 14:30:24','',NULL,'已超过计划维保日期未执行');
/*!40000 ALTER TABLE `warning_rule` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `worker_skill`
--

DROP TABLE IF EXISTS `worker_skill`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `worker_skill` (
  `skill_id` bigint NOT NULL AUTO_INCREMENT COMMENT '技能ID',
  `worker_id` bigint NOT NULL COMMENT '维修员ID',
  `community_id` bigint DEFAULT NULL COMMENT '负责小区ID',
  `skill_tags` varchar(200) COLLATE utf8mb4_general_ci DEFAULT '' COMMENT '技能标签（多个用逗号分隔，如 曳引机,门系统,控制系统）',
  `work_status` char(1) COLLATE utf8mb4_general_ci DEFAULT '0' COMMENT '在岗状态（0在岗 1休息 2请假）',
  `current_load` int DEFAULT '0' COMMENT '当前在手工单数',
  `total_finished` int DEFAULT '0' COMMENT '累计完成工单数',
  `avg_response` int DEFAULT '0' COMMENT '平均响应时长（分钟）',
  `create_by` varchar(64) COLLATE utf8mb4_general_ci DEFAULT '' COMMENT '创建者',
  `create_time` datetime DEFAULT NULL COMMENT '创建时间',
  `update_by` varchar(64) COLLATE utf8mb4_general_ci DEFAULT '' COMMENT '更新者',
  `update_time` datetime DEFAULT NULL COMMENT '更新时间',
  PRIMARY KEY (`skill_id`),
  KEY `idx_skill_worker` (`worker_id`),
  KEY `idx_skill_community` (`community_id`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='维修员技能与负责区域表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `worker_skill`
--

LOCK TABLES `worker_skill` WRITE;
/*!40000 ALTER TABLE `worker_skill` DISABLE KEYS */;
INSERT INTO `worker_skill` VALUES (1,101,1,'曳引机,门系统,控制系统','0',3,12,0,'admin','2026-10-02 14:30:24','',NULL),(2,103,2,'门系统,轿厢,安全装置','0',0,0,0,'admin','2026-10-02 14:30:24','',NULL),(3,104,3,'控制系统,曳引机,电气','0',0,0,0,'admin','2026-10-02 14:30:24','',NULL);
/*!40000 ALTER TABLE `worker_skill` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Dumping routines for database 'elevator'
--
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2026-10-11 14:13:35
