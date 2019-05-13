-- phpMyAdmin SQL Dump
-- version 4.8.4
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1:3306
-- Generation Time: May 13, 2019 at 04:16 PM
-- Server version: 5.7.24
-- PHP Version: 7.2.14

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
SET AUTOCOMMIT = 0;
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `itplus_end`
--

-- --------------------------------------------------------

--
-- Table structure for table `friends`
--

DROP TABLE IF EXISTS `friends`;
CREATE TABLE IF NOT EXISTS `friends` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id_1` int(11) NOT NULL,
  `user_id_2` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `FK_PersonOrder` (`user_id_1`),
  KEY `FK_PersonOrder1` (`user_id_2`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Table structure for table `message`
--

DROP TABLE IF EXISTS `message`;
CREATE TABLE IF NOT EXISTS `message` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `from_id` int(11) NOT NULL,
  `to_id` int(11) NOT NULL,
  `message` varchar(255) NOT NULL,
  `send_at` datetime NOT NULL,
  PRIMARY KEY (`id`),
  KEY `to_user_id` (`to_id`),
  KEY `from_user_id` (`from_id`)
) ENGINE=InnoDB AUTO_INCREMENT=20 DEFAULT CHARSET=utf8;

--
-- Dumping data for table `message`
--

INSERT INTO `message` (`id`, `from_id`, `to_id`, `message`, `send_at`) VALUES
(16, 1, 2, 'Hello Đức', '2019-05-11 13:15:14'),
(17, 2, 1, 'Hello Quốc Anh', '2019-05-11 13:15:31'),
(18, 1, 2, 'Hello Đức', '2019-05-11 13:20:55'),
(19, 2, 1, 'Hello', '2019-05-11 13:21:14');

-- --------------------------------------------------------

--
-- Table structure for table `personal_schedule`
--

DROP TABLE IF EXISTS `personal_schedule`;
CREATE TABLE IF NOT EXISTS `personal_schedule` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL,
  `name` varchar(255) NOT NULL,
  `day` date NOT NULL,
  `place` varchar(255) NOT NULL,
  `created_at` date NOT NULL,
  `updated_at` date DEFAULT NULL,
  `start_at` int(11) NOT NULL,
  `periods` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `id_user` (`user_id`)
) ENGINE=InnoDB AUTO_INCREMENT=100 DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `personal_schedule`
--

INSERT INTO `personal_schedule` (`id`, `user_id`, `name`, `day`, `place`, `created_at`, `updated_at`, `start_at`, `periods`) VALUES
(98, 1, 'Làm việc nhà', '2019-05-15', 'Nhà', '2019-05-07', NULL, 1, 3),
(99, 1, 'Hoc o friend', '2019-05-08', 'Nhà', '2019-05-08', '2019-05-08', 1, 2);

-- --------------------------------------------------------

--
-- Table structure for table `school_schedule`
--

DROP TABLE IF EXISTS `school_schedule`;
CREATE TABLE IF NOT EXISTS `school_schedule` (
  `id_user` int(11) NOT NULL,
  `id_subject` varchar(255) NOT NULL,
  `class_subject` varchar(255) NOT NULL,
  `day` date NOT NULL,
  `classroom` varchar(255) NOT NULL,
  `created_at` date NOT NULL,
  `updated_at` date NOT NULL,
  `start_at` int(11) NOT NULL,
  `periods` int(11) NOT NULL,
  KEY `id_user` (`id_user`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `school_schedule`
--

INSERT INTO `school_schedule` (`id_user`, `id_subject`, `class_subject`, `day`, `classroom`, `created_at`, `updated_at`, `start_at`, `periods`) VALUES
(1, 'MAT3306', 'Cơ sở hình học vi phân', '0000-00-00', '304T4', '2019-03-29', '2019-04-03', 1, 3),
(1, 'MAT3301  2', 'Giải tích hàm', '0000-00-00', '201T4', '2019-03-29', '2019-04-03', 6, 2),
(1, 'MAT3301 2', 'Giải tích hàm', '0000-00-00', '201T4', '2019-03-29', '2019-04-03', 6, 2),
(1, 'MAT3344', 'Giải tích phức', '0000-00-00', '303T4', '2019-03-29', '2019-04-03', 8, 3),
(1, 'MAT3344', 'Giải tích phức', '0000-00-00', '209T5', '2019-03-29', '2019-04-03', 9, 2),
(1, 'MAT3347', 'Lý thuyết Galois', '0000-00-00', '203T5', '2019-03-29', '2019-04-03', 1, 2),
(1, 'MAT3347', 'Lý thuyết Galois', '0000-00-00', '203T5', '2019-03-29', '2019-04-03', 1, 2),
(1, 'MAT2306', 'Phương trình đạo hàm riêng 1', '0000-00-00', '207T5', '2019-03-29', '2019-04-03', 1, 2),
(1, 'MAT2306', 'Phương trình đạo hàm riêng 1', '0000-00-00', '207T5', '2019-03-29', '2019-04-03', 4, 2),
(1, 'MAT2311', 'Thống kê ứng dụng', '0000-00-00', '302T4', '2019-03-29', '2019-04-03', 3, 3),
(1, 'MAT2311', 'Thống kê ứng dụng', '0000-00-00', 'Phòng máy', '2019-03-29', '2019-04-03', 4, 2),
(1, 'MAT2309', 'Tối ưu hóa 1', '0000-00-00', '209T5', '2019-03-29', '2019-04-03', 4, 2),
(1, 'MAT2309', 'Tối ưu hóa 1', '0000-00-00', '303T4', '2019-03-29', '2019-04-03', 4, 2);

-- --------------------------------------------------------

--
-- Table structure for table `users`
--

DROP TABLE IF EXISTS `users`;
CREATE TABLE IF NOT EXISTS `users` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) NOT NULL,
  `ma_sv` varchar(255) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `users`
--

INSERT INTO `users` (`id`, `name`, `ma_sv`) VALUES
(1, 'Nguyễn Quốc Anh', '16001742'),
(2, 'Phạm Hoàng Đức', '16002513'),
(3, 'Ngô Công Hoan', '16008324'),
(4, 'Phạm Văn Thanh', '14001726'),
(5, 'Nguyễn Hoàng Bách', '12345678'),
(6, 'Trần Đại Quang', '12334345');

--
-- Constraints for dumped tables
--

--
-- Constraints for table `friends`
--
ALTER TABLE `friends`
  ADD CONSTRAINT `FK_PersonOrder` FOREIGN KEY (`user_id_1`) REFERENCES `users` (`id`),
  ADD CONSTRAINT `FK_PersonOrder1` FOREIGN KEY (`user_id_2`) REFERENCES `users` (`id`),
  ADD CONSTRAINT `friends_ibfk_1` FOREIGN KEY (`user_id_1`) REFERENCES `users` (`id`);

--
-- Constraints for table `message`
--
ALTER TABLE `message`
  ADD CONSTRAINT `from_user_id` FOREIGN KEY (`from_id`) REFERENCES `users` (`id`),
  ADD CONSTRAINT `to_user_id` FOREIGN KEY (`to_id`) REFERENCES `users` (`id`);

--
-- Constraints for table `personal_schedule`
--
ALTER TABLE `personal_schedule`
  ADD CONSTRAINT `personal_schedule_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`);

--
-- Constraints for table `school_schedule`
--
ALTER TABLE `school_schedule`
  ADD CONSTRAINT `school_schedule_ibfk_1` FOREIGN KEY (`id_user`) REFERENCES `users` (`id`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
