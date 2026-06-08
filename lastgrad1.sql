-- MySQL dump 10.13  Distrib 8.0.30, for Win64 (x86_64)
--
-- Host: localhost    Database: nusuq_db1
-- ------------------------------------------------------
-- Server version	8.0.35

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!50503 SET NAMES utf8 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `admin`
--

DROP TABLE IF EXISTS `admin`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `admin` (
  `adminID` varchar(20) NOT NULL,
  `fullName` varchar(100) NOT NULL,
  `email` varchar(100) NOT NULL,
  `phoneNumber` varchar(20) DEFAULT NULL,
  `password` varchar(255) NOT NULL,
  PRIMARY KEY (`adminID`),
  UNIQUE KEY `email` (`email`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `admin`
--

LOCK TABLES `admin` WRITE;
/*!40000 ALTER TABLE `admin` DISABLE KEYS */;
INSERT INTO `admin` VALUES ('111111','System Admin','admin@nusuq.com','+966500000000','$2b$10$s.lbELy46PIryghwHUUcaOpNLMyo7k4O7p6j0666hsBMb9dx2PwRe');
/*!40000 ALTER TABLE `admin` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `campaign`
--

DROP TABLE IF EXISTS `campaign`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `campaign` (
  `campaignID` int NOT NULL AUTO_INCREMENT,
  `campaignName` varchar(100) NOT NULL,
  `campaignNumber` varchar(50) NOT NULL,
  `numberOfPilgrims` int DEFAULT '0',
  `arrivalDetails` text,
  `providerID` varchar(20) NOT NULL,
  PRIMARY KEY (`campaignID`),
  UNIQUE KEY `campaignNumber` (`campaignNumber`),
  UNIQUE KEY `unique_campaign_number` (`campaignNumber`),
  KEY `fk_campaign_provider` (`providerID`),
  CONSTRAINT `fk_campaign_provider` FOREIGN KEY (`providerID`) REFERENCES `provider` (`providerID`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `campaign`
--

LOCK TABLES `campaign` WRITE;
/*!40000 ALTER TABLE `campaign` DISABLE KEYS */;
INSERT INTO `campaign` VALUES (1,'Noor Al Huda Campaign','2026001',50,'From: Turkey\nArrival Time: 2026-04-17T14:15:00.000\nDescription: Pilgrims arriving from Istanbul. Expected arrival of 85 pilgrims.','1128711912'),(2,'Barakah Pilgrims Campaign','2026002',32,'From: Egypt\nArrival Time: 2026-04-16T09:30:00.000\nDescription:','1128711912');
/*!40000 ALTER TABLE `campaign` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `health_profile`
--

DROP TABLE IF EXISTS `health_profile`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `health_profile` (
  `pilgrimID` varchar(20) NOT NULL,
  `dietaryPreferences` text,
  `healthConditions` text,
  `allergies` text,
  `age` int DEFAULT NULL,
  PRIMARY KEY (`pilgrimID`),
  CONSTRAINT `fk_healthprofile_pilgrim` FOREIGN KEY (`pilgrimID`) REFERENCES `pilgrim` (`pilgrimID`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `health_profile`
--

LOCK TABLES `health_profile` WRITE;
/*!40000 ALTER TABLE `health_profile` DISABLE KEYS */;
INSERT INTO `health_profile` VALUES ('1127611414','Vegetarian','Diabetes','Milk, Eggs',22),('1127611918','Regular','Heart Disease','Fish, Strawberry',35);
/*!40000 ALTER TABLE `health_profile` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `meal`
--

DROP TABLE IF EXISTS `meal`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `meal` (
  `mealID` int NOT NULL AUTO_INCREMENT,
  `mealName` varchar(100) NOT NULL,
  `mealName_en` varchar(100) DEFAULT NULL,
  `mealName_ar` varchar(100) DEFAULT NULL,
  `mealType` varchar(50) DEFAULT NULL,
  `mealType_en` varchar(50) DEFAULT NULL,
  `mealType_ar` varchar(50) DEFAULT NULL,
  `description` text,
  `description_en` text,
  `description_ar` text,
  `protein` decimal(6,2) DEFAULT NULL,
  `carbohydrates` decimal(6,2) DEFAULT NULL,
  `fat` decimal(6,2) DEFAULT NULL,
  `calories` int DEFAULT NULL,
  `image` varchar(255) DEFAULT NULL,
  `providerID` varchar(20) DEFAULT NULL,
  PRIMARY KEY (`mealID`),
  KEY `providerID` (`providerID`),
  CONSTRAINT `meal_ibfk_1` FOREIGN KEY (`providerID`) REFERENCES `provider` (`providerID`)
) ENGINE=InnoDB AUTO_INCREMENT=76 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `meal`
--

LOCK TABLES `meal` WRITE;
/*!40000 ALTER TABLE `meal` DISABLE KEYS */;
INSERT INTO `meal` VALUES (66,'Grilled Chicken with Rice','Grilled Chicken with Rice','دجاج مشوي مع الأرز','Lunch','Lunch','غداء','Healthy grilled chicken meal','Healthy grilled chicken meal','وجبة دجاج مشوي صحية',35.00,45.00,8.00,420,'grilled_chicken.jpg','1128711912'),(67,'Vegetable Salad','Vegetable Salad','سلطة خضار','Dinner','Dinner','عشاء','Fresh mixed vegetables','Fresh mixed vegetables','سلطة خضار طازجة',5.00,12.00,3.00,110,'salad.jpg','1128711912'),(68,'Diabetic Friendly Breakfast','Diabetic Friendly Breakfast','فطور مناسب لمرضى السكري','Breakfast','Breakfast','فطور','Low sugar breakfast','Low sugar breakfast','وجبة قليلة السكر',18.00,22.00,6.00,240,'diabetic_breakfast.jpg','1128711912'),(69,'Vegetarian Rice Bowl','Vegetarian Rice Bowl','طبق أرز نباتي','Lunch','Lunch','غداء','Vegetarian healthy meal','Vegetarian healthy meal','وجبة نباتية صحية',12.00,48.00,5.00,310,'veg_bowl.jpg','1128711912'),(70,'Grilled Fish','Grilled Fish','سمك مشوي','Dinner','Dinner','عشاء','Omega 3 rich fish meal','Omega 3 rich fish meal','وجبة سمك غنية بالأوميغا 3',30.00,8.00,9.00,280,'fish.jpg','1128711912'),(71,'Low Sodium Chicken Soup','Low Sodium Chicken Soup','شوربة دجاج قليلة الصوديوم','Dinner','Dinner','عشاء','Suitable for hypertension patients','Suitable for hypertension patients','مناسبة لمرضى الضغط',15.00,10.00,4.00,180,'soup.jpg','1128711912'),(72,'High Protein Beef Meal','High Protein Beef Meal','وجبة لحم عالية البروتين','Lunch','Lunch','غداء','Protein rich meal','Protein rich meal','وجبة غنية بالبروتين',42.00,30.00,12.00,520,'beef.jpg','1128711912'),(73,'Fruit Bowl','Fruit Bowl','سلطة فواكه','Snack','Snack','وجبة خفيفة','Fresh seasonal fruits','Fresh seasonal fruits','فواكه موسمية طازجة',3.00,28.00,1.00,140,'fruit.jpg','1128711912'),(74,'Heart Healthy Meal','Heart Healthy Meal','وجبة صحية للقلب','Lunch','Lunch','غداء','Low fat and low sodium meal','Low fat and low sodium meal','وجبة قليلة الدهون والصوديوم',25.00,35.00,5.00,330,'heart_meal.jpg','1128711912'),(75,'Soft Chicken Porridge','Soft Chicken Porridge','عصيدة دجاج طرية','Breakfast','Breakfast','فطور','Easy to chew meal','Easy to chew meal','وجبة سهلة المضغ',14.00,25.00,3.00,210,'porridge.jpg','1128711912');
/*!40000 ALTER TABLE `meal` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `meal_order`
--

DROP TABLE IF EXISTS `meal_order`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `meal_order` (
  `orderID` int NOT NULL AUTO_INCREMENT,
  `requestDate` datetime DEFAULT CURRENT_TIMESTAMP,
  `status` enum('pending','accepted','completed','cancelled','rejected') DEFAULT 'pending',
  `pilgrimID` varchar(20) DEFAULT NULL,
  `mealID` int DEFAULT NULL,
  PRIMARY KEY (`orderID`),
  KEY `pilgrimID` (`pilgrimID`),
  KEY `mealID` (`mealID`),
  CONSTRAINT `meal_order_ibfk_1` FOREIGN KEY (`pilgrimID`) REFERENCES `pilgrim` (`pilgrimID`),
  CONSTRAINT `meal_order_ibfk_2` FOREIGN KEY (`mealID`) REFERENCES `meal` (`mealID`)
) ENGINE=InnoDB AUTO_INCREMENT=20 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `meal_order`
--

LOCK TABLES `meal_order` WRITE;
/*!40000 ALTER TABLE `meal_order` DISABLE KEYS */;
INSERT INTO `meal_order` VALUES (1,'2026-06-01 09:46:29','completed','1127611918',75),(2,'2026-06-01 09:47:38','pending','1127611918',73),(3,'2026-06-01 09:59:04','accepted','1127611414',69),(4,'2026-06-01 09:59:11','completed','1127611414',68),(5,'2026-06-01 09:59:22','pending','1127611414',66),(6,'2026-06-01 10:03:01','completed','1127611414',73);
/*!40000 ALTER TABLE `meal_order` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `notification`
--

DROP TABLE IF EXISTS `notification`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `notification` (
  `notificationID` int NOT NULL AUTO_INCREMENT,
  `title` varchar(150) NOT NULL,
  `title_en` varchar(150) DEFAULT NULL,
  `title_ar` varchar(150) DEFAULT NULL,
  `notificationType` varchar(50) NOT NULL,
  `timestamp` datetime DEFAULT CURRENT_TIMESTAMP,
  `messageContent` text NOT NULL,
  `messageContent_en` text,
  `messageContent_ar` text,
  `recipientUserID` varchar(20) NOT NULL,
  `recipientType` enum('pilgrim','provider','admin') NOT NULL,
  `createdByAdminID` varchar(20) DEFAULT NULL,
  `isRead` tinyint(1) DEFAULT '0',
  PRIMARY KEY (`notificationID`)
) ENGINE=InnoDB AUTO_INCREMENT=85 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `notification`
--

LOCK TABLES `notification` WRITE;
/*!40000 ALTER TABLE `notification` DISABLE KEYS */;
INSERT INTO `notification` VALUES (65,'New Pilgrim Account','New Pilgrim Account','تسجيل حاج جديد','pilgrim_registered','2026-06-01 09:21:19','Raneem Alqarni registered','New pilgrim registered: Raneem Alqarni','تم تسجيل حاج جديد: Raneem Alqarni','111111','admin',NULL,0),(66,'New Campaign','New Campaign','حملة جديدة','campaign_created','2026-06-01 09:37:23','Campaign Barakah Pilgrims Campaign created','New campaign created: Barakah Pilgrims Campaign','تم إنشاء حملة جديدة: Barakah Pilgrims Campaign','111111','admin',NULL,0),(67,'New Pilgrim Account','New Pilgrim Account','تسجيل حاج جديد','pilgrim_registered','2026-06-01 09:42:47','Atheer Alqarni registered','New pilgrim registered: Atheer Alqarni','تم تسجيل حاج جديد: Atheer Alqarni','111111','admin',NULL,0),(68,'New Meal Order','New Meal Order','طلب وجبة جديد','meal_order_created','2026-06-01 09:46:29','New meal order submitted','A new meal order has been submitted','تم تقديم طلب وجبة جديد','111111','admin',NULL,0),(69,'New Meal Order','New Meal Order','طلب وجبة جديد','meal_order_created','2026-06-01 09:47:38','New meal order submitted','A new meal order has been submitted','تم تقديم طلب وجبة جديد','111111','admin',NULL,0),(70,'Order Status Updated','Order Status Updated','تم تحديث حالة الطلب','meal_order_status_updated','2026-06-01 09:49:27','Order #1 status changed to accepted','Order #1 status changed to accepted','تم تغيير حالة الطلب رقم 1 إلى accepted','111111','admin',NULL,0),(71,'Meal order accepted','Meal order accepted','تم قبول طلب الوجبة','order_accepted','2026-06-01 09:49:27','تم قبول طلب وجبة \"عصيدة دجاج طرية\" بنجاح!','Your meal order \"Soft Chicken Porridge\" has been accepted successfully!','تم قبول طلب وجبة \"عصيدة دجاج طرية\" بنجاح!','1127611918','pilgrim',NULL,1),(72,'Order Status Updated','Order Status Updated','تم تحديث حالة الطلب','meal_order_status_updated','2026-06-01 09:49:31','Order #1 status changed to completed','Order #1 status changed to completed','تم تغيير حالة الطلب رقم 1 إلى completed','111111','admin',NULL,0),(73,'New Meal Order','New Meal Order','طلب وجبة جديد','meal_order_created','2026-06-01 09:59:04','New meal order submitted','A new meal order has been submitted','تم تقديم طلب وجبة جديد','111111','admin',NULL,0),(74,'New Meal Order','New Meal Order','طلب وجبة جديد','meal_order_created','2026-06-01 09:59:11','New meal order submitted','A new meal order has been submitted','تم تقديم طلب وجبة جديد','111111','admin',NULL,0),(75,'New Meal Order','New Meal Order','طلب وجبة جديد','meal_order_created','2026-06-01 09:59:22','New meal order submitted','A new meal order has been submitted','تم تقديم طلب وجبة جديد','111111','admin',NULL,0),(76,'Order Status Updated','Order Status Updated','تم تحديث حالة الطلب','meal_order_status_updated','2026-06-01 10:01:13','Order #3 status changed to accepted','Order #3 status changed to accepted','تم تغيير حالة الطلب رقم 3 إلى accepted','111111','admin',NULL,0),(77,'Meal order accepted','Meal order accepted','تم قبول طلب الوجبة','order_accepted','2026-06-01 10:01:13','تم قبول طلب وجبة \"طبق أرز نباتي\" بنجاح!','Your meal order \"Vegetarian Rice Bowl\" has been accepted successfully!','تم قبول طلب وجبة \"طبق أرز نباتي\" بنجاح!','1127611414','pilgrim',NULL,0),(78,'Order Status Updated','Order Status Updated','تم تحديث حالة الطلب','meal_order_status_updated','2026-06-01 10:01:18','Order #4 status changed to accepted','Order #4 status changed to accepted','تم تغيير حالة الطلب رقم 4 إلى accepted','111111','admin',NULL,0),(79,'Meal order accepted','Meal order accepted','تم قبول طلب الوجبة','order_accepted','2026-06-01 10:01:18','تم قبول طلب وجبة \"فطور مناسب لمرضى السكري\" بنجاح!','Your meal order \"Diabetic Friendly Breakfast\" has been accepted successfully!','تم قبول طلب وجبة \"فطور مناسب لمرضى السكري\" بنجاح!','1127611414','pilgrim',NULL,0),(80,'Order Status Updated','Order Status Updated','تم تحديث حالة الطلب','meal_order_status_updated','2026-06-01 10:01:22','Order #4 status changed to completed','Order #4 status changed to completed','تم تغيير حالة الطلب رقم 4 إلى completed','111111','admin',NULL,0),(81,'New Meal Order','New Meal Order','طلب وجبة جديد','meal_order_created','2026-06-01 10:03:01','New meal order submitted','A new meal order has been submitted','تم تقديم طلب وجبة جديد','111111','admin',NULL,0),(82,'Order Status Updated','Order Status Updated','تم تحديث حالة الطلب','meal_order_status_updated','2026-06-01 10:04:32','Order #6 status changed to accepted','Order #6 status changed to accepted','تم تغيير حالة الطلب رقم 6 إلى accepted','111111','admin',NULL,0),(83,'Meal order accepted','Meal order accepted','تم قبول طلب الوجبة','order_accepted','2026-06-01 10:04:32','تم قبول طلب وجبة \"سلطة فواكه\" بنجاح!','Your meal order \"Fruit Bowl\" has been accepted successfully!','تم قبول طلب وجبة \"سلطة فواكه\" بنجاح!','1127611414','pilgrim',NULL,0),(84,'Order Status Updated','Order Status Updated','تم تحديث حالة الطلب','meal_order_status_updated','2026-06-01 10:04:37','Order #6 status changed to completed','Order #6 status changed to completed','تم تغيير حالة الطلب رقم 6 إلى completed','111111','admin',NULL,0);
/*!40000 ALTER TABLE `notification` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `pilgrim`
--

DROP TABLE IF EXISTS `pilgrim`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `pilgrim` (
  `pilgrimID` varchar(20) NOT NULL,
  `fullName` varchar(100) NOT NULL,
  `email` varchar(100) NOT NULL,
  `phoneNumber` varchar(20) NOT NULL,
  `password` varchar(255) NOT NULL,
  `campaignID` int NOT NULL,
  `status` enum('active','inactive') DEFAULT 'active',
  PRIMARY KEY (`pilgrimID`),
  UNIQUE KEY `email` (`email`),
  UNIQUE KEY `phoneNumber` (`phoneNumber`),
  KEY `campaignID` (`campaignID`),
  CONSTRAINT `pilgrim_ibfk_1` FOREIGN KEY (`campaignID`) REFERENCES `campaign` (`campaignID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `pilgrim`
--

LOCK TABLES `pilgrim` WRITE;
/*!40000 ALTER TABLE `pilgrim` DISABLE KEYS */;
INSERT INTO `pilgrim` VALUES ('1127611414','Raneem Alqarni','raneem.alqarni@gmail.com','+966501111111','$2b$10$ixXD/9ULd.p0hTEwmN69sezpQUqNzTIrZuvS4PMJGkHUjrO8mX2Z2',1,'active'),('1127611918','Atheer Alqarni','atheer.alqarni@gmail.com','+966542222222','$2b$10$nUhJmiTqcSUI3T9wl0yUuuaOZMxeXOR8hezi2lC.JDffe8gfXkPO.',2,'active');
/*!40000 ALTER TABLE `pilgrim` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `provider`
--

DROP TABLE IF EXISTS `provider`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `provider` (
  `providerID` varchar(20) NOT NULL,
  `fullName` varchar(100) NOT NULL,
  `email` varchar(100) NOT NULL,
  `phoneNumber` varchar(20) NOT NULL,
  `password` varchar(255) NOT NULL,
  `status` enum('active','inactive') DEFAULT 'active',
  PRIMARY KEY (`providerID`),
  UNIQUE KEY `email` (`email`),
  UNIQUE KEY `phoneNumber` (`phoneNumber`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `provider`
--

LOCK TABLES `provider` WRITE;
/*!40000 ALTER TABLE `provider` DISABLE KEYS */;
INSERT INTO `provider` VALUES ('1128711912','Al Safa Catering Services','alsafa@nusuq.com','+966551234567','$2b$10$0HO2wKZtrDqEYUi4WIbM1.f5SOuGQyDVHosERDUQrKvqZlJ.9r.PO','active');
/*!40000 ALTER TABLE `provider` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `rate`
--

DROP TABLE IF EXISTS `rate`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `rate` (
  `ratingID` int NOT NULL AUTO_INCREMENT,
  `requestDate` datetime DEFAULT NULL,
  `orderID` int NOT NULL,
  `comment` text,
  `reviewDateTime` datetime DEFAULT NULL,
  `stars` int DEFAULT NULL,
  PRIMARY KEY (`ratingID`),
  KEY `fk_rate_order` (`orderID`),
  CONSTRAINT `fk_rate_order` FOREIGN KEY (`orderID`) REFERENCES `meal_order` (`orderID`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `rate_chk_1` CHECK ((`stars` between 1 and 5))
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `rate`
--

LOCK TABLES `rate` WRITE;
/*!40000 ALTER TABLE `rate` DISABLE KEYS */;
INSERT INTO `rate` VALUES (3,NULL,1,'Excellent meal quality','2026-06-01 09:57:44',5),(4,NULL,4,'','2026-06-01 10:05:42',4);
/*!40000 ALTER TABLE `rate` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2026-06-01 10:08:32
