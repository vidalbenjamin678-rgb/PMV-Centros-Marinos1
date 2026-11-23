CREATE DATABASE  IF NOT EXISTS `conservacion_marina` /*!40100 DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci */ /*!80016 DEFAULT ENCRYPTION='N' */;
USE `conservacion_marina`;
-- MySQL dump 10.13  Distrib 8.0.44, for Win64 (x86_64)
--
-- Host: 127.0.0.1    Database: conservacion_marina
-- ------------------------------------------------------
-- Server version	8.0.45

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
-- Table structure for table `actividad`
--

DROP TABLE IF EXISTS `actividad`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `actividad` (
  `cod_actividad` varchar(12) COLLATE utf8mb4_unicode_ci NOT NULL,
  `nombre_actividad` varchar(120) COLLATE utf8mb4_unicode_ci NOT NULL,
  `tipo_actividad` varchar(40) COLLATE utf8mb4_unicode_ci NOT NULL,
  `fecha_actividad` date NOT NULL,
  `num_sector` int NOT NULL,
  `cod_centro` varchar(10) COLLATE utf8mb4_unicode_ci NOT NULL,
  PRIMARY KEY (`cod_actividad`),
  KEY `fk_act_sector` (`num_sector`,`cod_centro`),
  CONSTRAINT `fk_act_sector` FOREIGN KEY (`num_sector`, `cod_centro`) REFERENCES `sector_marino` (`num_sector`, `cod_centro`),
  CONSTRAINT `actividad_chk_1` CHECK ((`tipo_actividad` in (_utf8mb4'Avistamiento',_utf8mb4'Buceo Cientifico',_utf8mb4'Educativa',_utf8mb4'Limpieza Costera',_utf8mb4'Voluntariado')))
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `actividad`
--

LOCK TABLES `actividad` WRITE;
/*!40000 ALTER TABLE `actividad` DISABLE KEYS */;
INSERT INTO `actividad` VALUES ('ACT-01','Avistamiento Responsable de Cetáceos','Avistamiento','2026-09-12',1,'CEN-09'),('ACT-02','Buceo Científico en Cañón Quintay','Buceo Cientifico','2026-09-19',1,'CEN-04'),('ACT-03','Charla de Conservación Costera','Educativa','2026-09-26',1,'CEN-01'),('ACT-04','Limpieza de Playa Cumberland','Limpieza Costera','2026-10-03',1,'CEN-03'),('ACT-05','Ruta Educativa Bahía Ancud','Educativa','2026-10-10',1,'CEN-08'),('ACT-06','Voluntariado Bosque de Huiro','Voluntariado','2026-10-17',2,'CEN-08');
/*!40000 ALTER TABLE `actividad` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `administrativo`
--

DROP TABLE IF EXISTS `administrativo`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `administrativo` (
  `rut` varchar(15) COLLATE utf8mb4_unicode_ci NOT NULL,
  PRIMARY KEY (`rut`),
  CONSTRAINT `fk_admin_trab` FOREIGN KEY (`rut`) REFERENCES `trabajador` (`rut`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `administrativo`
--

LOCK TABLES `administrativo` WRITE;
/*!40000 ALTER TABLE `administrativo` DISABLE KEYS */;
INSERT INTO `administrativo` VALUES ('16.543.210-K');
/*!40000 ALTER TABLE `administrativo` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `asiste`
--

DROP TABLE IF EXISTS `asiste`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `asiste` (
  `id_visitante` int NOT NULL,
  `cod_actividad` varchar(12) COLLATE utf8mb4_unicode_ci NOT NULL,
  PRIMARY KEY (`id_visitante`,`cod_actividad`),
  KEY `fk_asiste_act` (`cod_actividad`),
  CONSTRAINT `fk_asiste_act` FOREIGN KEY (`cod_actividad`) REFERENCES `actividad` (`cod_actividad`),
  CONSTRAINT `fk_asiste_vis` FOREIGN KEY (`id_visitante`) REFERENCES `visitante` (`id_visitante`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `asiste`
--

LOCK TABLES `asiste` WRITE;
/*!40000 ALTER TABLE `asiste` DISABLE KEYS */;
INSERT INTO `asiste` VALUES (1,'ACT-01'),(2,'ACT-01'),(3,'ACT-01'),(4,'ACT-02'),(1,'ACT-03'),(2,'ACT-03'),(3,'ACT-03'),(5,'ACT-03'),(2,'ACT-04'),(6,'ACT-04'),(1,'ACT-05'),(3,'ACT-05'),(4,'ACT-05'),(5,'ACT-06'),(6,'ACT-06');
/*!40000 ALTER TABLE `asiste` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `centro`
--

DROP TABLE IF EXISTS `centro`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `centro` (
  `cod_centro` varchar(10) COLLATE utf8mb4_unicode_ci NOT NULL,
  `nombre_centro` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL,
  `fecha_creacion` date NOT NULL,
  `superficie` decimal(12,2) NOT NULL,
  `ubicacion` varchar(120) COLLATE utf8mb4_unicode_ci NOT NULL,
  `presupuesto` decimal(14,2) NOT NULL,
  `capacidad_operativa` int NOT NULL,
  `estado_conservacion` varchar(30) COLLATE utf8mb4_unicode_ci NOT NULL,
  `cod_region` varchar(10) COLLATE utf8mb4_unicode_ci NOT NULL,
  PRIMARY KEY (`cod_centro`),
  KEY `fk_centro_region` (`cod_region`),
  CONSTRAINT `fk_centro_region` FOREIGN KEY (`cod_region`) REFERENCES `region` (`cod_region`),
  CONSTRAINT `centro_chk_1` CHECK ((`superficie` > 0)),
  CONSTRAINT `centro_chk_2` CHECK ((`presupuesto` >= 0)),
  CONSTRAINT `centro_chk_3` CHECK ((`capacidad_operativa` > 0)),
  CONSTRAINT `centro_chk_4` CHECK ((`estado_conservacion` in (_utf8mb4'Optimo',_utf8mb4'Estable',_utf8mb4'Vulnerable',_utf8mb4'Critico')))
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `centro`
--

LOCK TABLES `centro` WRITE;
/*!40000 ALTER TABLE `centro` DISABLE KEYS */;
INSERT INTO `centro` VALUES ('CEN-01','Centro Pingüino de Humboldt','2018-03-15',1250.50,'Isla Damas, La Higuera',45000000.00,60,'Vulnerable','REG-04'),('CEN-02','Centro Bahía Tongoy','2020-07-10',820.00,'Tongoy, Coquimbo',32000000.00,45,'Estable','REG-04'),('CEN-03','Centro Archipiélago Juan Fernández','2016-11-22',3400.00,'Isla Robinson Crusoe',78000000.00,40,'Critico','REG-05'),('CEN-04','Centro Quintay Marino','2019-05-04',950.25,'Caleta Quintay, Casablanca',52000000.00,75,'Optimo','REG-05'),('CEN-05','Centro Península de Tumbes','2021-01-18',1100.00,'Talcahuano, Biobío',38000000.00,50,'Estable','REG-08'),('CEN-06','Centro Golfo de Arauco','2022-02-14',670.80,'Lebu, Biobío',27000000.00,35,'Vulnerable','REG-08'),('CEN-07','Centro Fiordo Comau','2017-09-30',4200.00,'Hualaihué, Los Lagos',89000000.00,55,'Optimo','REG-10'),('CEN-08','Centro Chiloé Norte','2019-12-05',2150.40,'Ancud, Chiloé',61000000.00,65,'Estable','REG-10'),('CEN-09','Centro Estrecho de Magallanes','2015-08-12',5600.00,'Punta Arenas, Magallanes',95000000.00,45,'Optimo','REG-12'),('CEN-10','Centro Cabo Froward','2021-10-20',4800.75,'Península de Brunswick',74000000.00,30,'Vulnerable','REG-12');
/*!40000 ALTER TABLE `centro` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `conservacionista`
--

DROP TABLE IF EXISTS `conservacionista`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `conservacionista` (
  `rut` varchar(15) COLLATE utf8mb4_unicode_ci NOT NULL,
  PRIMARY KEY (`rut`),
  CONSTRAINT `fk_cons_trab` FOREIGN KEY (`rut`) REFERENCES `trabajador` (`rut`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `conservacionista`
--

LOCK TABLES `conservacionista` WRITE;
/*!40000 ALTER TABLE `conservacionista` DISABLE KEYS */;
INSERT INTO `conservacionista` VALUES ('18.765.432-1'),('19.234.567-8');
/*!40000 ALTER TABLE `conservacionista` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `coral`
--

DROP TABLE IF EXISTS `coral`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `coral` (
  `cod_especie` varchar(10) COLLATE utf8mb4_unicode_ci NOT NULL,
  `tipo_arrecife` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL,
  `tasa_crecimiento` decimal(6,2) NOT NULL,
  PRIMARY KEY (`cod_especie`),
  CONSTRAINT `fk_coral_especie` FOREIGN KEY (`cod_especie`) REFERENCES `especie_marina` (`cod_especie`),
  CONSTRAINT `coral_chk_1` CHECK ((`tasa_crecimiento` >= 0))
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `coral`
--

LOCK TABLES `coral` WRITE;
/*!40000 ALTER TABLE `coral` DISABLE KEYS */;
INSERT INTO `coral` VALUES ('ESP-08','Profundo',3.50),('ESP-09','Profundo',2.80);
/*!40000 ALTER TABLE `coral` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `especie_marina`
--

DROP TABLE IF EXISTS `especie_marina`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `especie_marina` (
  `cod_especie` varchar(10) COLLATE utf8mb4_unicode_ci NOT NULL,
  `nombre_cientifico` varchar(120) COLLATE utf8mb4_unicode_ci NOT NULL,
  `nombre_comun` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL,
  `estado_conservacion` varchar(30) COLLATE utf8mb4_unicode_ci NOT NULL,
  `fecha_incorporacion` date NOT NULL,
  `distribucion_geografica` varchar(200) COLLATE utf8mb4_unicode_ci NOT NULL,
  PRIMARY KEY (`cod_especie`),
  UNIQUE KEY `nombre_cientifico` (`nombre_cientifico`),
  CONSTRAINT `especie_marina_chk_1` CHECK ((`estado_conservacion` in (_utf8mb4'Preocupacion Menor',_utf8mb4'Vulnerable',_utf8mb4'En Peligro',_utf8mb4'En Peligro Critico')))
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `especie_marina`
--

LOCK TABLES `especie_marina` WRITE;
/*!40000 ALTER TABLE `especie_marina` DISABLE KEYS */;
INSERT INTO `especie_marina` VALUES ('ESP-01','Spheniscus humboldti','Pingüino de Humboldt','Vulnerable','2018-04-01','Corriente de Humboldt, norte y centro de Chile'),('ESP-02','Megaptera novaeangliae','Ballena Jorobada','En Peligro','2018-05-12','Pacífico sur y estrecho de Magallanes'),('ESP-03','Cephalorhynchus eutropia','Delfín Chileno','En Peligro Critico','2019-01-20','Aguas costeras del centro-sur y sur de Chile'),('ESP-04','Genypterus chilensis','Congrio Colorado','Vulnerable','2019-03-10','Fondos rocosos del Pacífico suroriental'),('ESP-05','Eleginops maclovinus','Róbalo','Preocupacion Menor','2019-06-15','Costas y estuarios del sur de Chile'),('ESP-06','Merluccius australis','Merluza Austral','Vulnerable','2020-02-05','Aguas australes y canales patagónicos'),('ESP-07','Scyliorhinus besnardi','Pintarroja Austral','Preocupacion Menor','2020-04-18','Plataforma continental del Pacífico y Atlántico sur'),('ESP-08','Caryophyllia huinayensis','Coral Frío de Huinay','En Peligro','2020-08-22','Fiordos profundos de la Región de Los Lagos'),('ESP-09','Desmophyllum dianthus','Coral Copa Profundo','Vulnerable','2021-01-11','Zonas profundas y cañones submarinos'),('ESP-10','Macrocystis pyrifera','Huiro Gigante','Preocupacion Menor','2021-03-29','Bosques submareales costeros templados'),('ESP-11','Loxechinus albus','Erizo Rojo','Vulnerable','2021-07-07','Fondos rocosos desde el norte hasta Magallanes'),('ESP-12','Pyura chilensis','Piure','Preocupacion Menor','2022-01-15','Zona intermareal rocosa de Chile');
/*!40000 ALTER TABLE `especie_marina` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `evaluacion`
--

DROP TABLE IF EXISTS `evaluacion`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `evaluacion` (
  `num_evaluacion` int NOT NULL,
  `cod_actividad` varchar(12) COLLATE utf8mb4_unicode_ci NOT NULL,
  `calificacion` decimal(3,2) NOT NULL,
  `fecha_evaluacion` date NOT NULL,
  `comentario` varchar(250) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`num_evaluacion`,`cod_actividad`),
  KEY `fk_eval_act` (`cod_actividad`),
  CONSTRAINT `fk_eval_act` FOREIGN KEY (`cod_actividad`) REFERENCES `actividad` (`cod_actividad`),
  CONSTRAINT `evaluacion_chk_1` CHECK ((`calificacion` between 1.00 and 5.00))
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `evaluacion`
--

LOCK TABLES `evaluacion` WRITE;
/*!40000 ALTER TABLE `evaluacion` DISABLE KEYS */;
INSERT INTO `evaluacion` VALUES (1,'ACT-01',4.90,'2026-09-12','Excelente avistamiento y respeto a la fauna marina.'),(1,'ACT-02',4.75,'2026-09-19','Muy buena organización y seguridad submarina.'),(1,'ACT-03',4.70,'2026-09-26','Contenido claro y accesible para visitantes.'),(1,'ACT-04',4.65,'2026-10-03','Gran participación y recolección de residuos.'),(1,'ACT-05',4.45,'2026-10-10','Recorrido educativo interesante y bien guiado.'),(2,'ACT-01',4.95,'2026-09-13','Guías muy preparados y medidas claras.');
/*!40000 ALTER TABLE `evaluacion` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `guardaparque`
--

DROP TABLE IF EXISTS `guardaparque`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `guardaparque` (
  `rut` varchar(15) COLLATE utf8mb4_unicode_ci NOT NULL,
  PRIMARY KEY (`rut`),
  CONSTRAINT `fk_guarda_trab` FOREIGN KEY (`rut`) REFERENCES `trabajador` (`rut`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `guardaparque`
--

LOCK TABLES `guardaparque` WRITE;
/*!40000 ALTER TABLE `guardaparque` DISABLE KEYS */;
INSERT INTO `guardaparque` VALUES ('15.987.654-2'),('17.890.123-4');
/*!40000 ALTER TABLE `guardaparque` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `investigador`
--

DROP TABLE IF EXISTS `investigador`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `investigador` (
  `rut` varchar(15) COLLATE utf8mb4_unicode_ci NOT NULL,
  PRIMARY KEY (`rut`),
  CONSTRAINT `fk_inv_trab` FOREIGN KEY (`rut`) REFERENCES `trabajador` (`rut`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `investigador`
--

LOCK TABLES `investigador` WRITE;
/*!40000 ALTER TABLE `investigador` DISABLE KEYS */;
INSERT INTO `investigador` VALUES ('18.456.789-0'),('20.111.222-3');
/*!40000 ALTER TABLE `investigador` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `mamifero_marino`
--

DROP TABLE IF EXISTS `mamifero_marino`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `mamifero_marino` (
  `cod_especie` varchar(10) COLLATE utf8mb4_unicode_ci NOT NULL,
  `periodo_gestacion` int NOT NULL,
  `longitud_promedio` decimal(6,2) NOT NULL,
  PRIMARY KEY (`cod_especie`),
  CONSTRAINT `fk_mamifero_especie` FOREIGN KEY (`cod_especie`) REFERENCES `especie_marina` (`cod_especie`),
  CONSTRAINT `mamifero_marino_chk_1` CHECK ((`periodo_gestacion` > 0)),
  CONSTRAINT `mamifero_marino_chk_2` CHECK ((`longitud_promedio` > 0))
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `mamifero_marino`
--

LOCK TABLES `mamifero_marino` WRITE;
/*!40000 ALTER TABLE `mamifero_marino` DISABLE KEYS */;
INSERT INTO `mamifero_marino` VALUES ('ESP-01',4,0.68),('ESP-02',11,14.50),('ESP-03',10,1.70);
/*!40000 ALTER TABLE `mamifero_marino` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `monitoreo`
--

DROP TABLE IF EXISTS `monitoreo`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `monitoreo` (
  `id_monitoreo` int NOT NULL AUTO_INCREMENT,
  `fecha_monitoreo` date NOT NULL,
  `cantidad_observada` int NOT NULL,
  `condiciones_ambientales` varchar(150) COLLATE utf8mb4_unicode_ci NOT NULL,
  `observaciones` varchar(250) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `num_sector` int NOT NULL,
  `cod_centro` varchar(10) COLLATE utf8mb4_unicode_ci NOT NULL,
  `cod_especie` varchar(10) COLLATE utf8mb4_unicode_ci NOT NULL,
  `rut_trabajador` varchar(15) COLLATE utf8mb4_unicode_ci NOT NULL,
  PRIMARY KEY (`id_monitoreo`),
  KEY `fk_mon_sector` (`num_sector`,`cod_centro`),
  KEY `fk_mon_especie` (`cod_especie`),
  KEY `fk_mon_trab` (`rut_trabajador`),
  CONSTRAINT `fk_mon_especie` FOREIGN KEY (`cod_especie`) REFERENCES `especie_marina` (`cod_especie`),
  CONSTRAINT `fk_mon_sector` FOREIGN KEY (`num_sector`, `cod_centro`) REFERENCES `sector_marino` (`num_sector`, `cod_centro`),
  CONSTRAINT `fk_mon_trab` FOREIGN KEY (`rut_trabajador`) REFERENCES `trabajador` (`rut`),
  CONSTRAINT `monitoreo_chk_1` CHECK ((`cantidad_observada` >= 0))
) ENGINE=InnoDB AUTO_INCREMENT=11 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `monitoreo`
--

LOCK TABLES `monitoreo` WRITE;
/*!40000 ALTER TABLE `monitoreo` DISABLE KEYS */;
INSERT INTO `monitoreo` VALUES (1,'2026-08-08',24,'Mar calmo, visibilidad buena','Grupo estable de pingüinos en sector norte.',1,'CEN-01','ESP-01','18.456.789-0'),(2,'2026-08-18',3,'Oleaje moderado, viento suave','Avistamiento de ballenas en tránsito.',1,'CEN-09','ESP-02','20.111.222-3'),(3,'2026-08-25',6,'Cielo despejado, visibilidad alta','Registro costero de delfines chilenos.',1,'CEN-08','ESP-03','18.456.789-0'),(4,'2026-09-05',11,'Mar calmo, buena visibilidad','Muestreo de peces en zona rocosa.',1,'CEN-04','ESP-04','20.111.222-3'),(5,'2026-09-14',18,'Viento leve, mar leve','Conteo en sector educativo costero.',1,'CEN-05','ESP-05','17.890.123-4'),(6,'2026-09-21',14,'Neblina costera, mar leve','Monitoreo de fauna en sector sur.',2,'CEN-06','ESP-06','19.234.567-8'),(7,'2026-09-30',45,'Visibilidad buena, mar calmo','Alta densidad de macroalgas en el sector.',2,'CEN-08','ESP-10','18.765.432-1'),(8,'2026-10-08',32,'Condiciones estables, mar leve','Inspección de colonias de coral profundo.',3,'CEN-07','ESP-08','18.456.789-0'),(9,'2026-10-18',19,'Oleaje moderado, visibilidad media','Evaluación de especies en fondo marino.',1,'CEN-02','ESP-11','15.987.654-2'),(10,'2026-10-25',28,'Cielo despejado, mar calmo','Registro de organismos intermareales.',3,'CEN-10','ESP-12','20.111.222-3');
/*!40000 ALTER TABLE `monitoreo` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `pez`
--

DROP TABLE IF EXISTS `pez`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `pez` (
  `cod_especie` varchar(10) COLLATE utf8mb4_unicode_ci NOT NULL,
  `tipo_escama` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL,
  `profundidad_habitat` decimal(8,2) NOT NULL,
  PRIMARY KEY (`cod_especie`),
  CONSTRAINT `fk_pez_especie` FOREIGN KEY (`cod_especie`) REFERENCES `especie_marina` (`cod_especie`),
  CONSTRAINT `pez_chk_1` CHECK ((`profundidad_habitat` >= 0))
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `pez`
--

LOCK TABLES `pez` WRITE;
/*!40000 ALTER TABLE `pez` DISABLE KEYS */;
INSERT INTO `pez` VALUES ('ESP-04','Sin escamas',120.00),('ESP-05','Ctenoidea',35.00),('ESP-06','Cicloidea',250.00),('ESP-07','Placoidea',180.00);
/*!40000 ALTER TABLE `pez` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `region`
--

DROP TABLE IF EXISTS `region`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `region` (
  `cod_region` varchar(10) COLLATE utf8mb4_unicode_ci NOT NULL,
  `nombre_oficial` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL,
  `superficie_protegida` decimal(12,2) NOT NULL,
  `presupuesto_anual` decimal(14,2) NOT NULL,
  `nivel_proteccion` varchar(30) COLLATE utf8mb4_unicode_ci NOT NULL,
  PRIMARY KEY (`cod_region`),
  CONSTRAINT `region_chk_1` CHECK ((`superficie_protegida` > 0)),
  CONSTRAINT `region_chk_2` CHECK ((`presupuesto_anual` >= 0)),
  CONSTRAINT `region_chk_3` CHECK ((`nivel_proteccion` in (_utf8mb4'Bajo',_utf8mb4'Medio',_utf8mb4'Alto',_utf8mb4'Estricto')))
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `region`
--

LOCK TABLES `region` WRITE;
/*!40000 ALTER TABLE `region` DISABLE KEYS */;
INSERT INTO `region` VALUES ('REG-04','Región de Coquimbo',15200.50,420000000.00,'Alto'),('REG-05','Región de Valparaíso',18450.00,560000000.00,'Alto'),('REG-08','Región del Biobío',12300.75,390000000.00,'Medio'),('REG-10','Región de Los Lagos',34800.00,780000000.00,'Estricto'),('REG-12','Región de Magallanes y de la Antártica Chilena',68900.25,950000000.00,'Estricto');
/*!40000 ALTER TABLE `region` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `rol`
--

DROP TABLE IF EXISTS `rol`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `rol` (
  `cod_rol` varchar(10) COLLATE utf8mb4_unicode_ci NOT NULL,
  `nombre_rol` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL,
  `descripcion_permisos` varchar(200) COLLATE utf8mb4_unicode_ci NOT NULL,
  PRIMARY KEY (`cod_rol`),
  UNIQUE KEY `nombre_rol` (`nombre_rol`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `rol`
--

LOCK TABLES `rol` WRITE;
/*!40000 ALTER TABLE `rol` DISABLE KEYS */;
INSERT INTO `rol` VALUES ('ROL-ADM','Administrador','Gestión completa del sistema, usuarios, centros y catálogos'),('ROL-INV','Investigador','Registro y consulta de monitoreos, especies y reportes técnicos'),('ROL-OPE','Operador','Gestión de actividades, inscripción de visitantes y control operativo');
/*!40000 ALTER TABLE `rol` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `sector_marino`
--

DROP TABLE IF EXISTS `sector_marino`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sector_marino` (
  `num_sector` int NOT NULL,
  `cod_centro` varchar(10) COLLATE utf8mb4_unicode_ci NOT NULL,
  `nombre_sector` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL,
  `extension` decimal(10,2) NOT NULL,
  `profundidad_promedio` decimal(8,2) NOT NULL,
  `temperatura` decimal(5,2) NOT NULL,
  `nivel_acceso` varchar(30) COLLATE utf8mb4_unicode_ci NOT NULL,
  `biodiversidad_estimada` int NOT NULL,
  PRIMARY KEY (`num_sector`,`cod_centro`),
  KEY `fk_sector_centro` (`cod_centro`),
  CONSTRAINT `fk_sector_centro` FOREIGN KEY (`cod_centro`) REFERENCES `centro` (`cod_centro`),
  CONSTRAINT `sector_marino_chk_1` CHECK ((`extension` > 0)),
  CONSTRAINT `sector_marino_chk_2` CHECK ((`profundidad_promedio` >= 0)),
  CONSTRAINT `sector_marino_chk_3` CHECK ((`nivel_acceso` in (_utf8mb4'Publico',_utf8mb4'Restringido',_utf8mb4'Solo Investigacion'))),
  CONSTRAINT `sector_marino_chk_4` CHECK ((`biodiversidad_estimada` >= 0))
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `sector_marino`
--

LOCK TABLES `sector_marino` WRITE;
/*!40000 ALTER TABLE `sector_marino` DISABLE KEYS */;
INSERT INTO `sector_marino` VALUES (1,'CEN-01','Ensenada Norte',120.50,25.00,14.50,'Publico',85),(1,'CEN-02','Humedal Tongoy',140.00,12.00,15.10,'Publico',65),(1,'CEN-03','Bahía Cumberland',160.00,35.00,16.40,'Publico',95),(1,'CEN-04','Cañón de Quintay',220.00,95.00,13.20,'Restringido',105),(1,'CEN-05','Bahía San Vicente',175.00,22.00,12.80,'Publico',72),(1,'CEN-06','Desembocadura Lebu',150.00,16.00,12.50,'Publico',64),(1,'CEN-07','Fiordo Leptepu',310.00,110.00,11.20,'Restringido',84),(1,'CEN-08','Bahía de Ancud',230.00,26.00,11.80,'Publico',82),(1,'CEN-09','Canal de Ballenas',520.00,130.00,8.50,'Restringido',89),(1,'CEN-10','Bahía Fortescue',340.00,75.00,8.10,'Restringido',71),(2,'CEN-01','Arrecife Profundo Damas',210.00,65.00,13.80,'Solo Investigacion',110),(2,'CEN-02','Banco Arenoso Sur',180.00,30.00,14.70,'Restringido',55),(2,'CEN-03','Punta San Carlos',130.00,45.00,16.10,'Restringido',80),(2,'CEN-04','Playa Chica Quintay',85.00,14.00,14.00,'Publico',60),(2,'CEN-05','Punta Lobería Tumbes',190.00,40.00,12.40,'Restringido',88),(2,'CEN-06','Isla Mocha Norte',260.00,55.00,12.20,'Restringido',92),(2,'CEN-07','Caleta Vodudahue',195.00,48.00,11.50,'Publico',76),(2,'CEN-08','Bosque de Huiro',170.00,19.00,11.60,'Publico',96),(2,'CEN-09','Punta Arenas Costero',180.00,24.00,8.90,'Publico',58),(2,'CEN-10','Cabo Froward Sur',460.00,160.00,7.80,'Solo Investigacion',86),(3,'CEN-01','Islote Pájaros',95.00,18.00,14.20,'Restringido',70),(3,'CEN-02','Canal Exterior Tongoy',250.00,80.00,13.50,'Solo Investigacion',90),(3,'CEN-03','Fosa Juan Fernández',410.00,150.00,12.90,'Solo Investigacion',120),(3,'CEN-04','Roca Pelícano',110.00,28.00,13.70,'Solo Investigacion',75),(3,'CEN-05','Talud Tumbes',320.00,120.00,11.60,'Solo Investigacion',98),(3,'CEN-06','Fosa Arauco',380.00,140.00,11.40,'Solo Investigacion',100),(3,'CEN-07','Canal Comau Profundo',450.00,210.00,10.80,'Solo Investigacion',94),(3,'CEN-08','Golfo de Quetalmahue',240.00,38.00,11.40,'Restringido',78),(3,'CEN-09','Paso Ancho Magallanes',390.00,95.00,8.20,'Solo Investigacion',74),(3,'CEN-10','Caleta San Isidro',155.00,32.00,8.40,'Publico',62);
/*!40000 ALTER TABLE `sector_marino` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `trabajador`
--

DROP TABLE IF EXISTS `trabajador`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `trabajador` (
  `rut` varchar(15) COLLATE utf8mb4_unicode_ci NOT NULL,
  `nombre` varchar(60) COLLATE utf8mb4_unicode_ci NOT NULL,
  `apellido1` varchar(60) COLLATE utf8mb4_unicode_ci NOT NULL,
  `apellido2` varchar(60) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `fecha_contratacion` date NOT NULL,
  `fecha_nacimiento` date NOT NULL,
  PRIMARY KEY (`rut`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `trabajador`
--

LOCK TABLES `trabajador` WRITE;
/*!40000 ALTER TABLE `trabajador` DISABLE KEYS */;
INSERT INTO `trabajador` VALUES ('15.987.654-2','Marcelo','Tapia','Reyes','2017-06-01','1982-07-30'),('16.543.210-K','Rodrigo','Fuentes','Vidal','2018-09-01','1985-02-19'),('17.890.123-4','Diego','Herrera','Soto','2019-07-15','1989-11-02'),('18.456.789-0','Camila','Rojas','Muñoz','2020-03-01','1992-05-14'),('18.765.432-1','Francisca','Silva','Mora','2021-10-01','1994-03-17'),('19.234.567-8','Valentina','Paz','Araya','2021-01-10','1995-08-23'),('19.876.543-9','Tomás','Contreras','Lagos','2023-02-01','1998-09-25'),('20.111.222-3','Sofía','Núñez','Castro','2022-04-01','1997-12-08');
/*!40000 ALTER TABLE `trabajador` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `usuario`
--

DROP TABLE IF EXISTS `usuario`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `usuario` (
  `username` varchar(40) COLLATE utf8mb4_unicode_ci NOT NULL,
  `password_hash` varchar(120) COLLATE utf8mb4_unicode_ci NOT NULL,
  `estado_cuenta` varchar(20) COLLATE utf8mb4_unicode_ci NOT NULL,
  `rut_trabajador` varchar(15) COLLATE utf8mb4_unicode_ci NOT NULL,
  PRIMARY KEY (`username`),
  UNIQUE KEY `rut_trabajador` (`rut_trabajador`),
  CONSTRAINT `fk_usuario_trab` FOREIGN KEY (`rut_trabajador`) REFERENCES `trabajador` (`rut`),
  CONSTRAINT `usuario_chk_1` CHECK ((`estado_cuenta` in (_utf8mb4'Activo',_utf8mb4'Inactivo',_utf8mb4'Bloqueado')))
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `usuario`
--

LOCK TABLES `usuario` WRITE;
/*!40000 ALTER TABLE `usuario` DISABLE KEYS */;
INSERT INTO `usuario` VALUES ('crojas','1234','Activo','18.456.789-0'),('dherrera','1234','Activo','17.890.123-4'),('rfuentes','1234','Activo','16.543.210-K'),('snunez','1234','Activo','20.111.222-3'),('vpaz','1234','Activo','19.234.567-8');
/*!40000 ALTER TABLE `usuario` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `usuario_rol`
--

DROP TABLE IF EXISTS `usuario_rol`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `usuario_rol` (
  `username` varchar(40) COLLATE utf8mb4_unicode_ci NOT NULL,
  `cod_rol` varchar(10) COLLATE utf8mb4_unicode_ci NOT NULL,
  PRIMARY KEY (`username`,`cod_rol`),
  KEY `fk_ur_rol` (`cod_rol`),
  CONSTRAINT `fk_ur_rol` FOREIGN KEY (`cod_rol`) REFERENCES `rol` (`cod_rol`),
  CONSTRAINT `fk_ur_usuario` FOREIGN KEY (`username`) REFERENCES `usuario` (`username`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `usuario_rol`
--

LOCK TABLES `usuario_rol` WRITE;
/*!40000 ALTER TABLE `usuario_rol` DISABLE KEYS */;
INSERT INTO `usuario_rol` VALUES ('rfuentes','ROL-ADM'),('crojas','ROL-INV'),('snunez','ROL-INV'),('vpaz','ROL-INV'),('dherrera','ROL-OPE'),('vpaz','ROL-OPE');
/*!40000 ALTER TABLE `usuario_rol` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `visitante`
--

DROP TABLE IF EXISTS `visitante`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `visitante` (
  `id_visitante` int NOT NULL AUTO_INCREMENT,
  `nombre` varchar(60) COLLATE utf8mb4_unicode_ci NOT NULL,
  `apellido1` varchar(60) COLLATE utf8mb4_unicode_ci NOT NULL,
  `apellido2` varchar(60) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `telefono` varchar(25) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`id_visitante`)
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `visitante`
--

LOCK TABLES `visitante` WRITE;
/*!40000 ALTER TABLE `visitante` DISABLE KEYS */;
INSERT INTO `visitante` VALUES (1,'Javiera','Espinoza','Ríos','+56 9 8123 4501'),(2,'Matías','Gutiérrez','Díaz','+56 9 8234 5602'),(3,'Constanza','Morales','Vega','+56 9 8345 6703'),(4,'Sebastián','Paredes','Jara','+56 9 8456 7804'),(5,'Antonia','Bravo','Campos','+56 9 8567 8905'),(6,'Ignacio','Navarro','Peña','+56 9 8678 9006');
/*!40000 ALTER TABLE `visitante` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `visitante_correo`
--

DROP TABLE IF EXISTS `visitante_correo`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `visitante_correo` (
  `id_visitante` int NOT NULL,
  `correo` varchar(120) COLLATE utf8mb4_unicode_ci NOT NULL,
  PRIMARY KEY (`id_visitante`,`correo`),
  CONSTRAINT `fk_vc_visitante` FOREIGN KEY (`id_visitante`) REFERENCES `visitante` (`id_visitante`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `visitante_correo`
--

LOCK TABLES `visitante_correo` WRITE;
/*!40000 ALTER TABLE `visitante_correo` DISABLE KEYS */;
INSERT INTO `visitante_correo` VALUES (1,'javiera.espinoza@correo.cl'),(1,'jespinoza.ambiental@gmail.com'),(2,'matias.gutierrez@correo.cl'),(3,'cmorales.mar@gmail.com'),(3,'constanza.morales@correo.cl'),(4,'sebastian.paredes@correo.cl'),(5,'antonia.bravo@correo.cl'),(6,'ignacio.navarro@correo.cl');
/*!40000 ALTER TABLE `visitante_correo` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Temporary view structure for view `vw_monitoreos_detalle`
--

DROP TABLE IF EXISTS `vw_monitoreos_detalle`;
/*!50001 DROP VIEW IF EXISTS `vw_monitoreos_detalle`*/;
SET @saved_cs_client     = @@character_set_client;
/*!50503 SET character_set_client = utf8mb4 */;
/*!50001 CREATE VIEW `vw_monitoreos_detalle` AS SELECT 
 1 AS `id_monitoreo`,
 1 AS `fecha_monitoreo`,
 1 AS `especie`,
 1 AS `centro`,
 1 AS `sector`,
 1 AS `cantidad_observada`,
 1 AS `condiciones_ambientales`,
 1 AS `responsable`*/;
SET character_set_client = @saved_cs_client;

--
-- Temporary view structure for view `vw_participacion_visitantes`
--

DROP TABLE IF EXISTS `vw_participacion_visitantes`;
/*!50001 DROP VIEW IF EXISTS `vw_participacion_visitantes`*/;
SET @saved_cs_client     = @@character_set_client;
/*!50503 SET character_set_client = utf8mb4 */;
/*!50001 CREATE VIEW `vw_participacion_visitantes` AS SELECT 
 1 AS `id_visitante`,
 1 AS `visitante`,
 1 AS `telefono`,
 1 AS `actividades_asistidas`*/;
SET character_set_client = @saved_cs_client;

--
-- Temporary view structure for view `vw_resumen_actividades`
--

DROP TABLE IF EXISTS `vw_resumen_actividades`;
/*!50001 DROP VIEW IF EXISTS `vw_resumen_actividades`*/;
SET @saved_cs_client     = @@character_set_client;
/*!50503 SET character_set_client = utf8mb4 */;
/*!50001 CREATE VIEW `vw_resumen_actividades` AS SELECT 
 1 AS `cod_actividad`,
 1 AS `nombre_actividad`,
 1 AS `tipo_actividad`,
 1 AS `fecha_actividad`,
 1 AS `nombre_centro`,
 1 AS `nombre_sector`,
 1 AS `total_asistentes`,
 1 AS `promedio_evaluacion`*/;
SET character_set_client = @saved_cs_client;

--
-- Temporary view structure for view `vw_resumen_centros`
--

DROP TABLE IF EXISTS `vw_resumen_centros`;
/*!50001 DROP VIEW IF EXISTS `vw_resumen_centros`*/;
SET @saved_cs_client     = @@character_set_client;
/*!50503 SET character_set_client = utf8mb4 */;
/*!50001 CREATE VIEW `vw_resumen_centros` AS SELECT 
 1 AS `cod_centro`,
 1 AS `nombre_centro`,
 1 AS `region`,
 1 AS `estado_conservacion`,
 1 AS `capacidad_operativa`,
 1 AS `presupuesto`,
 1 AS `total_sectores`*/;
SET character_set_client = @saved_cs_client;

--
-- Temporary view structure for view `vw_resumen_especies`
--

DROP TABLE IF EXISTS `vw_resumen_especies`;
/*!50001 DROP VIEW IF EXISTS `vw_resumen_especies`*/;
SET @saved_cs_client     = @@character_set_client;
/*!50503 SET character_set_client = utf8mb4 */;
/*!50001 CREATE VIEW `vw_resumen_especies` AS SELECT 
 1 AS `cod_especie`,
 1 AS `nombre_comun`,
 1 AS `nombre_cientifico`,
 1 AS `estado_conservacion`,
 1 AS `distribucion_geografica`,
 1 AS `total_observado`,
 1 AS `total_monitoreos`*/;
SET character_set_client = @saved_cs_client;

--
-- Temporary view structure for view `vw_sectores_biodiversidad`
--

DROP TABLE IF EXISTS `vw_sectores_biodiversidad`;
/*!50001 DROP VIEW IF EXISTS `vw_sectores_biodiversidad`*/;
SET @saved_cs_client     = @@character_set_client;
/*!50503 SET character_set_client = utf8mb4 */;
/*!50001 CREATE VIEW `vw_sectores_biodiversidad` AS SELECT 
 1 AS `cod_centro`,
 1 AS `nombre_centro`,
 1 AS `num_sector`,
 1 AS `nombre_sector`,
 1 AS `nivel_acceso`,
 1 AS `temperatura`,
 1 AS `profundidad_promedio`,
 1 AS `biodiversidad_estimada`*/;
SET character_set_client = @saved_cs_client;

--
-- Final view structure for view `vw_monitoreos_detalle`
--

/*!50001 DROP VIEW IF EXISTS `vw_monitoreos_detalle`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8mb4 */;
/*!50001 SET character_set_results     = utf8mb4 */;
/*!50001 SET collation_connection      = utf8mb4_0900_ai_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `vw_monitoreos_detalle` AS select `m`.`id_monitoreo` AS `id_monitoreo`,`m`.`fecha_monitoreo` AS `fecha_monitoreo`,`e`.`nombre_comun` AS `especie`,`c`.`nombre_centro` AS `centro`,`s`.`nombre_sector` AS `sector`,`m`.`cantidad_observada` AS `cantidad_observada`,`m`.`condiciones_ambientales` AS `condiciones_ambientales`,concat(`t`.`nombre`,' ',`t`.`apellido1`) AS `responsable` from ((((`monitoreo` `m` join `especie_marina` `e` on((`m`.`cod_especie` = `e`.`cod_especie`))) join `sector_marino` `s` on(((`m`.`num_sector` = `s`.`num_sector`) and (`m`.`cod_centro` = `s`.`cod_centro`)))) join `centro` `c` on((`s`.`cod_centro` = `c`.`cod_centro`))) join `trabajador` `t` on((`m`.`rut_trabajador` = `t`.`rut`))) */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `vw_participacion_visitantes`
--

/*!50001 DROP VIEW IF EXISTS `vw_participacion_visitantes`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8mb4 */;
/*!50001 SET character_set_results     = utf8mb4 */;
/*!50001 SET collation_connection      = utf8mb4_0900_ai_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `vw_participacion_visitantes` AS select `v`.`id_visitante` AS `id_visitante`,concat(`v`.`nombre`,' ',`v`.`apellido1`) AS `visitante`,`v`.`telefono` AS `telefono`,count(`a`.`cod_actividad`) AS `actividades_asistidas` from (`visitante` `v` left join `asiste` `a` on((`v`.`id_visitante` = `a`.`id_visitante`))) group by `v`.`id_visitante`,`v`.`nombre`,`v`.`apellido1`,`v`.`telefono` */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `vw_resumen_actividades`
--

/*!50001 DROP VIEW IF EXISTS `vw_resumen_actividades`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8mb4 */;
/*!50001 SET character_set_results     = utf8mb4 */;
/*!50001 SET collation_connection      = utf8mb4_0900_ai_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `vw_resumen_actividades` AS select `a`.`cod_actividad` AS `cod_actividad`,`a`.`nombre_actividad` AS `nombre_actividad`,`a`.`tipo_actividad` AS `tipo_actividad`,`a`.`fecha_actividad` AS `fecha_actividad`,`c`.`nombre_centro` AS `nombre_centro`,`s`.`nombre_sector` AS `nombre_sector`,count(distinct `asi`.`id_visitante`) AS `total_asistentes`,round(avg(`ev`.`calificacion`),2) AS `promedio_evaluacion` from ((((`actividad` `a` join `sector_marino` `s` on(((`a`.`num_sector` = `s`.`num_sector`) and (`a`.`cod_centro` = `s`.`cod_centro`)))) join `centro` `c` on((`s`.`cod_centro` = `c`.`cod_centro`))) left join `asiste` `asi` on((`a`.`cod_actividad` = `asi`.`cod_actividad`))) left join `evaluacion` `ev` on((`a`.`cod_actividad` = `ev`.`cod_actividad`))) group by `a`.`cod_actividad`,`a`.`nombre_actividad`,`a`.`tipo_actividad`,`a`.`fecha_actividad`,`c`.`nombre_centro`,`s`.`nombre_sector` */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `vw_resumen_centros`
--

/*!50001 DROP VIEW IF EXISTS `vw_resumen_centros`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8mb4 */;
/*!50001 SET character_set_results     = utf8mb4 */;
/*!50001 SET collation_connection      = utf8mb4_0900_ai_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `vw_resumen_centros` AS select `c`.`cod_centro` AS `cod_centro`,`c`.`nombre_centro` AS `nombre_centro`,`r`.`nombre_oficial` AS `region`,`c`.`estado_conservacion` AS `estado_conservacion`,`c`.`capacidad_operativa` AS `capacidad_operativa`,`c`.`presupuesto` AS `presupuesto`,count(`s`.`num_sector`) AS `total_sectores` from ((`centro` `c` join `region` `r` on((`c`.`cod_region` = `r`.`cod_region`))) left join `sector_marino` `s` on((`c`.`cod_centro` = `s`.`cod_centro`))) group by `c`.`cod_centro`,`c`.`nombre_centro`,`r`.`nombre_oficial`,`c`.`estado_conservacion`,`c`.`capacidad_operativa`,`c`.`presupuesto` */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `vw_resumen_especies`
--

/*!50001 DROP VIEW IF EXISTS `vw_resumen_especies`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8mb4 */;
/*!50001 SET character_set_results     = utf8mb4 */;
/*!50001 SET collation_connection      = utf8mb4_0900_ai_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `vw_resumen_especies` AS select `e`.`cod_especie` AS `cod_especie`,`e`.`nombre_comun` AS `nombre_comun`,`e`.`nombre_cientifico` AS `nombre_cientifico`,`e`.`estado_conservacion` AS `estado_conservacion`,`e`.`distribucion_geografica` AS `distribucion_geografica`,coalesce(sum(`m`.`cantidad_observada`),0) AS `total_observado`,count(`m`.`id_monitoreo`) AS `total_monitoreos` from (`especie_marina` `e` left join `monitoreo` `m` on((`e`.`cod_especie` = `m`.`cod_especie`))) group by `e`.`cod_especie`,`e`.`nombre_comun`,`e`.`nombre_cientifico`,`e`.`estado_conservacion`,`e`.`distribucion_geografica` */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `vw_sectores_biodiversidad`
--

/*!50001 DROP VIEW IF EXISTS `vw_sectores_biodiversidad`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8mb4 */;
/*!50001 SET character_set_results     = utf8mb4 */;
/*!50001 SET collation_connection      = utf8mb4_0900_ai_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `vw_sectores_biodiversidad` AS select `s`.`cod_centro` AS `cod_centro`,`c`.`nombre_centro` AS `nombre_centro`,`s`.`num_sector` AS `num_sector`,`s`.`nombre_sector` AS `nombre_sector`,`s`.`nivel_acceso` AS `nivel_acceso`,`s`.`temperatura` AS `temperatura`,`s`.`profundidad_promedio` AS `profundidad_promedio`,`s`.`biodiversidad_estimada` AS `biodiversidad_estimada` from (`sector_marino` `s` join `centro` `c` on((`s`.`cod_centro` = `c`.`cod_centro`))) */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2026-11-23  2:18:14
