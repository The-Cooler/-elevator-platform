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
INSERT INTO `sys_user` VALUES (1,'admin','系统管理员','00','ry@163.com','15888888888','1','','$2a$10$7JB720yubVSZvUI0rEqK/.VqGOZTH.ulu33dHOiBE8ByOhJIrdAu2','0','0','127.0.0.1','2026-10-12 12:02:47','2026-10-02 14:30:22','admin','2026-10-02 14:30:22','','2026-10-11 14:01:59','管理员',NULL),(2,'ry','若依','00','ry@qq.com','15666666666','1','','$2a$10$7JB720yubVSZvUI0rEqK/.VqGOZTH.ulu33dHOiBE8ByOhJIrdAu2','0','0','127.0.0.1','2026-10-12 10:32:40','2026-10-02 14:30:22','admin','2026-10-02 14:30:22','',NULL,'测试员',NULL),(100,'wuye01','物业管理员','00','wuye01@elevator.com','13800000001','1','','$2a$10$pdXrbtI9oylyNZP2jNorMOFsPnxkobyrXlZ1xzSj7nCAngvoz2pBC','0','0','127.0.0.1','2026-10-12 12:02:47','2026-10-12 10:36:32','admin','2026-10-02 14:30:24','',NULL,'阳光家园小区物业管理员',1),(101,'weixiu01','维修员王师傅','00','weixiu01@elevator.com','13800000002','1','','$2a$10$pdXrbtI9oylyNZP2jNorMOFsPnxkobyrXlZ1xzSj7nCAngvoz2pBC','0','0','127.0.0.1','2026-10-12 12:02:48','2026-10-12 10:36:32','admin','2026-10-02 14:30:24','',NULL,'黑龙江安捷电梯维保有限公司，负责阳光家园小区',1),(102,'yezhu01','业主张阿姨','00','yezhu01@elevator.com','13800000003','1','','$2a$10$pdXrbtI9oylyNZP2jNorMOFsPnxkobyrXlZ1xzSj7nCAngvoz2pBC','0','0','127.0.0.1','2026-10-12 12:02:47','2026-10-12 10:36:32','admin','2026-10-02 14:30:24','',NULL,'阳光家园小区1号楼1单元业主',1),(103,'weixiu02','维修员李师傅','00','weixiu02@elevator.com','13800000004','1','','$2a$10$pdXrbtI9oylyNZP2jNorMOFsPnxkobyrXlZ1xzSj7nCAngvoz2pBC','0','0','127.0.0.1','2026-10-12 10:38:02','2026-10-12 10:36:32','admin','2026-10-02 14:30:24','',NULL,'哈尔滨华信机电设备有限公司，负责和平里小区',2),(104,'weixiu03','维修员赵师傅','00','weixiu03@elevator.com','13800000005','1','','$2a$10$pdXrbtI9oylyNZP2jNorMOFsPnxkobyrXlZ1xzSj7nCAngvoz2pBC','0','0','127.0.0.1','2026-10-12 11:05:21','2026-10-12 10:36:32','admin','2026-10-02 14:30:24','',NULL,'黑龙江广日电梯工程有限公司，负责铁路新村小区',3),(105,'owner2test','验证业主乙','00','','13800009999','0','','$2a$10$lDlaJGYPIjPAjvlCYScrQ.sZ3ClClWoI.9D5FAldcZijOsxCeiQJe','0','0','127.0.0.1','2026-10-12 10:32:42',NULL,'register','2026-10-11 14:04:45','',NULL,NULL,2);
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
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2026-10-12 12:22:01
