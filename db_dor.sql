-- phpMyAdmin SQL Dump
-- version 5.2.2
-- https://www.phpmyadmin.net/
--
-- Host: localhost:3306
-- Generation Time: Nov 28, 2025 at 04:34 AM
-- Server version: 8.4.3
-- PHP Version: 8.3.16

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `db_dor`
--

-- --------------------------------------------------------

--
-- Table structure for table `audit_logs`
--

CREATE TABLE `audit_logs` (
  `id` bigint UNSIGNED NOT NULL,
  `user_id` bigint UNSIGNED DEFAULT NULL,
  `username` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `action` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `description` text COLLATE utf8mb4_unicode_ci NOT NULL,
  `entity_type` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `entity_id` bigint UNSIGNED DEFAULT NULL,
  `ip_address` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `user_agent` text COLLATE utf8mb4_unicode_ci,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `audit_logs`
--

INSERT INTO `audit_logs` (`id`, `user_id`, `username`, `action`, `description`, `entity_type`, `entity_id`, `ip_address`, `user_agent`, `created_at`, `updated_at`) VALUES
(1, 1, 'admin', 'login', 'telah login ke sistem', NULL, NULL, '127.0.0.1', 'Mozilla/5.0', '2025-10-28 07:22:55', '2025-10-28 07:22:55'),
(2, 1, 'admin', 'create', 'menambahkan barang: Laptop Dell', 'Barang', 1, '127.0.0.1', 'Mozilla/5.0', '2025-10-28 07:23:15', '2025-10-28 07:23:15'),
(3, 2, 'staff_gudang', 'update', 'mengedit data supplier: PT. Supplier Jaya', 'Supplier', 1, '127.0.0.1', 'Mozilla/5.0', '2025-10-28 05:23:15', '2025-10-28 05:23:15'),
(4, 1, 'admin', 'approve', 'menyetujui Purchase Order: PO-2023-001', 'PurchaseOrder', 1, '127.0.0.1', 'Mozilla/5.0', '2025-10-28 02:23:15', '2025-10-28 02:23:15'),
(5, 1, 'admin', 'delete', 'menghapus barang: OPPO RENO 14F (PRD-OPPO-5030)', 'Barang', 3, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '2025-10-28 07:33:19', '2025-10-28 07:33:19'),
(6, 1, 'admin', 'update', 'mengedit supplier: PT. MUSTIKA KOMPUTER', 'Supplier', 1, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '2025-10-28 07:40:11', '2025-10-28 07:40:11'),
(7, 1, 'admin', 'logout', 'telah logout dari sistem', 'Auth', 1, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '2025-10-29 02:32:47', '2025-10-29 02:32:47'),
(8, 2, 'staff', 'login', 'telah login ke sistem', 'Auth', 2, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '2025-10-29 02:32:55', '2025-10-29 02:32:55'),
(9, 2, 'staff', 'logout', 'telah logout dari sistem', 'Auth', 2, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '2025-10-29 03:02:18', '2025-10-29 03:02:18'),
(10, 1, 'admin', 'login', 'telah login ke sistem', 'Auth', 1, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '2025-10-29 03:03:25', '2025-10-29 03:03:25'),
(11, 1, 'admin', 'logout', 'telah logout dari sistem', 'Auth', 1, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '2025-10-29 03:03:50', '2025-10-29 03:03:50'),
(12, 2, 'staff', 'login', 'telah login ke sistem', 'Auth', 2, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '2025-10-29 03:03:59', '2025-10-29 03:03:59'),
(13, 2, 'staff', 'logout', 'telah logout dari sistem', 'Auth', 2, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '2025-10-29 03:08:26', '2025-10-29 03:08:26'),
(14, 1, 'admin', 'login', 'telah login ke sistem', 'Auth', 1, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '2025-10-29 03:08:34', '2025-10-29 03:08:34'),
(15, 1, 'admin', 'logout', 'telah logout dari sistem', 'Auth', 1, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '2025-10-29 03:23:13', '2025-10-29 03:23:13'),
(16, 2, 'staff', 'login', 'telah login ke sistem', 'Auth', 2, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '2025-10-29 03:23:19', '2025-10-29 03:23:19'),
(17, 2, 'staff', 'logout', 'telah logout dari sistem', 'Auth', 2, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '2025-10-29 03:24:45', '2025-10-29 03:24:45'),
(18, 1, 'admin', 'login', 'telah login ke sistem', 'Auth', 1, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '2025-10-29 03:24:54', '2025-10-29 03:24:54'),
(19, 1, 'admin', 'create', 'menambahkan barang: OPPO RENO 14F (PRD-OPPO-9685)', 'Barang', 4, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '2025-10-29 03:25:21', '2025-10-29 03:25:21'),
(20, 1, 'admin', 'logout', 'telah logout dari sistem', 'Auth', 1, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '2025-10-29 03:25:45', '2025-10-29 03:25:45'),
(21, 2, 'staff', 'login', 'telah login ke sistem', 'Auth', 2, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '2025-10-29 03:25:51', '2025-10-29 03:25:51'),
(22, 2, 'staff', 'logout', 'telah logout dari sistem', 'Auth', 2, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '2025-10-29 03:27:13', '2025-10-29 03:27:13'),
(23, 1, 'admin', 'login', 'telah login ke sistem', 'Auth', 1, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '2025-10-29 03:27:20', '2025-10-29 03:27:20'),
(24, 1, 'admin', 'logout', 'telah logout dari sistem', 'Auth', 1, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '2025-10-29 03:28:51', '2025-10-29 03:28:51'),
(25, 2, 'staff', 'login', 'telah login ke sistem', 'Auth', 2, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '2025-10-29 03:28:56', '2025-10-29 03:28:56'),
(26, 2, 'staff', 'create', 'Membuat Sales Order baru SO-202510-0002 untuk customer Hafidz', 'SalesOrder', 2, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '2025-10-29 03:46:20', '2025-10-29 03:46:20'),
(27, 1, 'admin', 'login', 'telah login ke sistem', 'Auth', 1, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '2025-10-29 03:49:23', '2025-10-29 03:49:23'),
(28, 1, 'admin', 'logout', 'telah logout dari sistem', 'Auth', 1, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '2025-10-29 03:50:17', '2025-10-29 03:50:17'),
(29, 2, 'staff', 'login', 'telah login ke sistem', 'Auth', 2, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '2025-10-29 03:50:23', '2025-10-29 03:50:23'),
(30, 2, 'staff', 'login', 'telah login ke sistem', 'Auth', 2, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '2025-10-29 03:58:28', '2025-10-29 03:58:28'),
(31, 1, 'admin', 'login', 'telah login ke sistem', 'Auth', 1, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '2025-10-29 04:15:48', '2025-10-29 04:15:48'),
(32, 1, 'admin', 'approve', 'Menyetujui Sales Order SO-202510-0002 untuk customer Hafidz', 'SalesOrder', 2, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '2025-10-29 05:34:58', '2025-10-29 05:34:58'),
(33, 1, 'admin', 'logout', 'telah logout dari sistem', 'Auth', 1, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '2025-10-29 05:35:03', '2025-10-29 05:35:03'),
(34, 2, 'staff', 'login', 'telah login ke sistem', 'Auth', 2, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '2025-10-29 05:35:14', '2025-10-29 05:35:14'),
(35, 2, 'staff', 'create', 'membuat Purchase Order: PO-202510-0002 untuk supplier PT. MUSTIKA KOMPUTER', 'PurchaseOrder', 2, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '2025-10-29 05:36:46', '2025-10-29 05:36:46'),
(36, 1, 'admin', 'login', 'telah login ke sistem', 'Auth', 1, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '2025-10-29 05:37:08', '2025-10-29 05:37:08'),
(37, 1, 'admin', 'approve', 'menyetujui Purchase Order: PO-202510-0002', 'PurchaseOrder', 2, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '2025-10-29 05:37:21', '2025-10-29 05:37:21'),
(38, 2, 'staff', 'login', 'telah login ke sistem', 'Auth', 2, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '2025-10-29 05:37:41', '2025-10-29 05:37:41'),
(39, 2, 'staff', 'create', 'Membuat Sales Order baru SO-202510-0003 untuk customer Nur', 'SalesOrder', 3, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '2025-10-29 05:55:42', '2025-10-29 05:55:42'),
(40, 1, 'admin', 'login', 'telah login ke sistem', 'Auth', 1, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '2025-10-29 05:57:47', '2025-10-29 05:57:47'),
(41, 1, 'admin', 'approve', 'Menyetujui Sales Order SO-202510-0003 untuk customer Nur', 'SalesOrder', 3, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '2025-10-29 05:58:22', '2025-10-29 05:58:22'),
(42, 2, 'staff', 'login', 'telah login ke sistem', 'Auth', 2, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '2025-10-29 06:00:18', '2025-10-29 06:00:18'),
(43, 2, 'staff', 'login', 'telah login ke sistem', 'Auth', 2, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '2025-10-29 06:40:32', '2025-10-29 06:40:32'),
(44, 1, 'admin', 'login', 'telah login ke sistem', 'Auth', 1, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '2025-10-29 21:58:59', '2025-10-29 21:58:59'),
(45, 1, 'admin', 'logout', 'telah logout dari sistem', 'Auth', 1, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '2025-10-29 21:59:13', '2025-10-29 21:59:13'),
(46, 2, 'staff', 'login', 'telah login ke sistem', 'Auth', 2, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '2025-10-29 21:59:20', '2025-10-29 21:59:20'),
(47, 1, 'admin', 'login', 'telah login ke sistem', 'Auth', 1, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '2025-10-29 22:03:03', '2025-10-29 22:03:03'),
(48, 1, 'admin', 'logout', 'telah logout dari sistem', 'Auth', 1, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '2025-10-29 22:05:28', '2025-10-29 22:05:28'),
(49, 2, 'staff', 'login', 'telah login ke sistem', 'Auth', 2, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '2025-10-29 22:05:37', '2025-10-29 22:05:37'),
(50, 1, 'admin', 'login', 'telah login ke sistem', 'Auth', 1, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '2025-10-29 22:16:02', '2025-10-29 22:16:02'),
(51, 2, 'staff', 'login', 'telah login ke sistem', 'Auth', 2, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '2025-10-29 22:17:03', '2025-10-29 22:17:03'),
(52, 2, 'staff', 'create', 'membuat Purchase Order: PO-202510-0003 untuk supplier PT. MUSTIKA KOMPUTER', 'PurchaseOrder', 3, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '2025-10-29 22:34:24', '2025-10-29 22:34:24'),
(53, 1, 'admin', 'login', 'telah login ke sistem', 'Auth', 1, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '2025-10-29 22:34:49', '2025-10-29 22:34:49'),
(54, 1, 'admin', 'approve', 'menyetujui Purchase Order: PO-202510-0003', 'PurchaseOrder', 3, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '2025-10-29 22:35:15', '2025-10-29 22:35:15'),
(55, 1, 'admin', 'logout', 'telah logout dari sistem', 'Auth', 1, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '2025-10-29 22:35:36', '2025-10-29 22:35:36'),
(56, 2, 'staff', 'login', 'telah login ke sistem', 'Auth', 2, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '2025-10-29 22:35:42', '2025-10-29 22:35:42'),
(57, 2, 'staff', 'logout', 'telah logout dari sistem', 'Auth', 2, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '2025-10-29 22:40:45', '2025-10-29 22:40:45'),
(58, 1, 'admin', 'login', 'telah login ke sistem', 'Auth', 1, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '2025-10-29 22:40:51', '2025-10-29 22:40:51'),
(59, 1, 'admin', 'logout', 'telah logout dari sistem', 'Auth', 1, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '2025-10-29 23:02:25', '2025-10-29 23:02:25'),
(60, 2, 'staff', 'login', 'telah login ke sistem', 'Auth', 2, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '2025-10-29 23:02:34', '2025-10-29 23:02:34'),
(61, 1, 'admin', 'login', 'telah login ke sistem', 'Auth', 1, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '2025-10-29 23:15:35', '2025-10-29 23:15:35'),
(62, 1, 'admin', 'logout', 'telah logout dari sistem', 'Auth', 1, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '2025-10-29 23:36:54', '2025-10-29 23:36:54'),
(63, 2, 'staff', 'login', 'telah login ke sistem', 'Auth', 2, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '2025-10-29 23:36:59', '2025-10-29 23:36:59'),
(64, 1, 'admin', 'login', 'telah login ke sistem', 'Auth', 1, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '2025-10-29 23:37:30', '2025-10-29 23:37:30'),
(65, 1, 'admin', 'logout', 'telah logout dari sistem', 'Auth', 1, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '2025-10-30 00:20:31', '2025-10-30 00:20:31'),
(66, 2, 'staff', 'login', 'telah login ke sistem', 'Auth', 2, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '2025-10-30 00:20:37', '2025-10-30 00:20:37'),
(67, 1, 'admin', 'login', 'telah login ke sistem', 'Auth', 1, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '2025-10-30 00:23:38', '2025-10-30 00:23:38'),
(68, 1, 'admin', 'logout', 'telah logout dari sistem', 'Auth', 1, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '2025-10-30 00:24:11', '2025-10-30 00:24:11'),
(69, 2, 'staff', 'login', 'telah login ke sistem', 'Auth', 2, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '2025-10-30 00:24:16', '2025-10-30 00:24:16'),
(70, 1, 'admin', 'login', 'telah login ke sistem', 'Auth', 1, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '2025-10-30 00:26:27', '2025-10-30 00:26:27'),
(71, 1, 'admin', 'logout', 'telah logout dari sistem', 'Auth', 1, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '2025-10-30 04:06:18', '2025-10-30 04:06:18'),
(72, 2, 'staff', 'login', 'telah login ke sistem', 'Auth', 2, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '2025-10-30 04:06:23', '2025-10-30 04:06:23'),
(73, 2, 'staff', 'logout', 'telah logout dari sistem', 'Auth', 2, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '2025-10-30 04:32:56', '2025-10-30 04:32:56'),
(74, 1, 'admin', 'login', 'telah login ke sistem', 'Auth', 1, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '2025-10-30 04:33:02', '2025-10-30 04:33:02'),
(75, 1, 'admin', 'logout', 'telah logout dari sistem', 'Auth', 1, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '2025-10-30 04:42:53', '2025-10-30 04:42:53'),
(76, 2, 'staff', 'login', 'telah login ke sistem', 'Auth', 2, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '2025-10-30 04:43:05', '2025-10-30 04:43:05'),
(77, 2, 'staff', 'create', 'membuat Purchase Order: PO-202510-0001 untuk supplier PT. MUSTIKA KOMPUTER', 'PurchaseOrder', 4, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '2025-10-30 04:43:31', '2025-10-30 04:43:31'),
(78, 1, 'admin', 'login', 'telah login ke sistem', 'Auth', 1, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '2025-10-30 04:43:46', '2025-10-30 04:43:46'),
(79, 1, 'admin', 'approve', 'menyetujui Purchase Order: PO-202510-0001', 'PurchaseOrder', 4, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '2025-10-30 04:44:03', '2025-10-30 04:44:03'),
(80, 1, 'admin', 'logout', 'telah logout dari sistem', 'Auth', 1, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '2025-10-30 04:44:36', '2025-10-30 04:44:36'),
(81, 2, 'staff', 'login', 'telah login ke sistem', 'Auth', 2, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '2025-10-30 04:44:42', '2025-10-30 04:44:42'),
(82, 2, 'staff', 'logout', 'telah logout dari sistem', 'Auth', 2, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '2025-10-30 04:46:10', '2025-10-30 04:46:10'),
(83, 1, 'admin', 'login', 'telah login ke sistem', 'Auth', 1, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '2025-10-30 04:46:16', '2025-10-30 04:46:16'),
(84, 1, 'admin', 'logout', 'telah logout dari sistem', 'Auth', 1, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '2025-10-30 05:25:45', '2025-10-30 05:25:45'),
(85, 2, 'staff', 'login', 'telah login ke sistem', 'Auth', 2, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '2025-10-30 05:25:52', '2025-10-30 05:25:52'),
(86, 2, 'staff', 'create', 'Membuat Sales Order baru SO-202510-0001 untuk customer Ahmad Nur Hafidz', 'SalesOrder', 4, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '2025-10-30 05:26:57', '2025-10-30 05:26:57'),
(87, 2, 'staff', 'logout', 'telah logout dari sistem', 'Auth', 2, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '2025-10-30 05:27:19', '2025-10-30 05:27:19'),
(88, 1, 'admin', 'login', 'telah login ke sistem', 'Auth', 1, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '2025-10-30 05:27:31', '2025-10-30 05:27:31'),
(89, 1, 'admin', 'approve', 'Menyetujui Sales Order SO-202510-0001 untuk customer Ahmad Nur Hafidz', 'SalesOrder', 4, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '2025-10-30 05:28:21', '2025-10-30 05:28:21'),
(90, 1, 'admin', 'logout', 'telah logout dari sistem', 'Auth', 1, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '2025-10-30 05:28:35', '2025-10-30 05:28:35'),
(91, 2, 'staff', 'login', 'telah login ke sistem', 'Auth', 2, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '2025-10-30 05:28:43', '2025-10-30 05:28:43'),
(92, 2, 'staff', 'logout', 'telah logout dari sistem', 'Auth', 2, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '2025-10-30 05:29:24', '2025-10-30 05:29:24'),
(93, 1, 'admin', 'login', 'telah login ke sistem', 'Auth', 1, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '2025-10-30 05:29:30', '2025-10-30 05:29:30'),
(94, 1, 'admin', 'logout', 'telah logout dari sistem', 'Auth', 1, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '2025-10-30 06:05:15', '2025-10-30 06:05:15'),
(95, 2, 'staff', 'login', 'telah login ke sistem', 'Auth', 2, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '2025-10-30 06:05:21', '2025-10-30 06:05:21'),
(96, 1, 'admin', 'login', 'telah login ke sistem', 'Auth', 1, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '2025-10-30 06:06:00', '2025-10-30 06:06:00'),
(97, 1, 'admin', 'logout', 'telah logout dari sistem', 'Auth', 1, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '2025-10-30 06:10:28', '2025-10-30 06:10:28'),
(98, 2, 'staff', 'login', 'telah login ke sistem', 'Auth', 2, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '2025-10-30 06:10:34', '2025-10-30 06:10:34'),
(99, 1, 'admin', 'login', 'telah login ke sistem', 'Auth', 1, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '2025-10-30 06:10:51', '2025-10-30 06:10:51'),
(100, 1, 'admin', 'logout', 'telah logout dari sistem', 'Auth', 1, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '2025-10-30 07:58:54', '2025-10-30 07:58:54'),
(101, 2, 'staff', 'login', 'telah login ke sistem', 'Auth', 2, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '2025-10-30 07:58:59', '2025-10-30 07:58:59'),
(102, 1, 'admin', 'login', 'telah login ke sistem', 'Auth', 1, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '2025-10-30 07:59:31', '2025-10-30 07:59:31'),
(103, 1, 'admin', 'receive', 'menerima barang untuk Purchase Order: PO-202510-0001 (Surat Jalan: PO-30102025-0001)', 'PurchaseOrder', 4, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '2025-10-30 08:39:58', '2025-10-30 08:39:58'),
(104, 1, 'admin', 'process', 'Memproses pengeluaran barang untuk Sales Order SO-202510-0001', 'SalesOrder', 4, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '2025-10-30 08:52:51', '2025-10-30 08:52:51'),
(105, 1, 'admin', 'logout', 'telah logout dari sistem', 'Auth', 1, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '2025-10-30 09:02:14', '2025-10-30 09:02:14'),
(106, 2, 'staff', 'login', 'telah login ke sistem', 'Auth', 2, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '2025-10-30 09:02:19', '2025-10-30 09:02:19'),
(107, 2, 'staff', 'create', 'membuat Purchase Order: PO-202510-0001 untuk supplier PT. MUSTIKA KOMPUTER', 'PurchaseOrder', 5, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '2025-10-30 09:02:56', '2025-10-30 09:02:56'),
(108, 1, 'admin', 'login', 'telah login ke sistem', 'Auth', 1, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '2025-10-30 09:03:06', '2025-10-30 09:03:06'),
(109, 1, 'admin', 'approve', 'menyetujui Purchase Order: PO-202510-0001', 'PurchaseOrder', 5, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '2025-10-30 09:03:18', '2025-10-30 09:03:18'),
(110, 1, 'admin', 'receive', 'menerima barang untuk Purchase Order: PO-202510-0001 (Surat Jalan: PO-31102025-0001)', 'PurchaseOrder', 5, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '2025-10-30 09:05:15', '2025-10-30 09:05:15'),
(111, 2, 'staff', 'login', 'telah login ke sistem', 'Auth', 2, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '2025-10-30 09:09:43', '2025-10-30 09:09:43'),
(112, 2, 'staff', 'create', 'membuat Purchase Order: PO-202510-0001 untuk supplier PT. MUSTIKA KOMPUTER', 'PurchaseOrder', 6, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '2025-10-30 09:10:23', '2025-10-30 09:10:23'),
(113, 1, 'admin', 'login', 'telah login ke sistem', 'Auth', 1, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '2025-10-30 09:10:35', '2025-10-30 09:10:35'),
(114, 1, 'admin', 'approve', 'menyetujui Purchase Order: PO-202510-0001', 'PurchaseOrder', 6, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '2025-10-30 09:10:59', '2025-10-30 09:10:59'),
(115, 1, 'admin', 'receive', 'menerima barang untuk Purchase Order: PO-202510-0001 (Surat Jalan: PO-31102025-0001)', 'PurchaseOrder', 6, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '2025-10-30 09:11:17', '2025-10-30 09:11:17'),
(116, 1, 'admin', 'logout', 'telah logout dari sistem', 'Auth', 1, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '2025-10-30 09:17:51', '2025-10-30 09:17:51'),
(117, 2, 'staff', 'login', 'telah login ke sistem', 'Auth', 2, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '2025-10-30 09:18:05', '2025-10-30 09:18:05'),
(118, 2, 'staff', 'create', 'membuat Purchase Order: PO-202510-0001 untuk supplier PT. MUSTIKA KOMPUTER', 'PurchaseOrder', 7, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '2025-10-30 09:18:43', '2025-10-30 09:18:43'),
(119, 1, 'admin', 'login', 'telah login ke sistem', 'Auth', 1, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '2025-10-30 09:18:57', '2025-10-30 09:18:57'),
(120, 1, 'admin', 'approve', 'menyetujui Purchase Order: PO-202510-0001', 'PurchaseOrder', 7, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '2025-10-30 09:19:13', '2025-10-30 09:19:13'),
(121, 1, 'admin', 'receive', 'menerima barang untuk Purchase Order: PO-202510-0001 (Surat Jalan: PO-31102025-0001)', 'PurchaseOrder', 7, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '2025-10-30 09:19:39', '2025-10-30 09:19:39'),
(122, 2, 'staff', 'login', 'telah login ke sistem', 'Auth', 2, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '2025-10-30 09:21:08', '2025-10-30 09:21:08'),
(123, 1, 'admin', 'login', 'telah login ke sistem', 'Auth', 1, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '2025-10-30 09:26:03', '2025-10-30 09:26:03'),
(124, 1, 'admin', 'logout', 'telah logout dari sistem', 'Auth', 1, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '2025-10-30 09:36:17', '2025-10-30 09:36:17'),
(125, 2, 'staff', 'login', 'telah login ke sistem', 'Auth', 2, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '2025-10-30 09:36:22', '2025-10-30 09:36:22'),
(126, 2, 'staff', 'create', 'membuat Purchase Order: PO-202510-0001 untuk supplier PT. MUSTIKA KOMPUTER', 'PurchaseOrder', 10, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '2025-10-30 09:36:36', '2025-10-30 09:36:36'),
(127, 1, 'admin', 'login', 'telah login ke sistem', 'Auth', 1, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '2025-10-30 09:36:45', '2025-10-30 09:36:45'),
(128, 1, 'admin', 'approve', 'menyetujui Purchase Order: PO-202510-0001', 'PurchaseOrder', 10, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '2025-10-30 09:36:59', '2025-10-30 09:36:59'),
(129, 1, 'admin', 'receive', 'menerima barang untuk Purchase Order: PO-202510-0001 (Surat Jalan: PO-31102025-0001)', 'PurchaseOrder', 10, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '2025-10-30 09:37:22', '2025-10-30 09:37:22'),
(130, 1, 'admin', 'logout', 'telah logout dari sistem', 'Auth', 1, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '2025-10-30 22:50:42', '2025-10-30 22:50:42'),
(131, 2, 'staff', 'login', 'telah login ke sistem', 'Auth', 2, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '2025-10-30 22:50:49', '2025-10-30 22:50:49'),
(132, 1, 'admin', 'login', 'telah login ke sistem', 'Auth', 1, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '2025-10-30 22:58:34', '2025-10-30 22:58:34'),
(133, 1, 'admin', 'create', 'membuat penerimaan barang Non-PO: GR-NON-202510-00001 (Sumber: Retur PT MUSTIKA KOMPUTER)', 'NonPoReceipt', 1, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '2025-10-31 04:15:26', '2025-10-31 04:15:26'),
(134, 1, 'admin', 'create', 'membuat penerimaan barang Non-PO: GR-NON-202510-00002 (Sumber: Retrun)', 'NonPoReceipt', 2, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '2025-10-31 04:19:43', '2025-10-31 04:19:43'),
(135, 1, 'admin', 'create', 'membuat pengeluaran barang Non-PO: OUT-NON-202510-00001 (Penerima: PT MUSTIKA KOMPUTER)', 'NonPoIssue', 1, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '2025-10-31 04:27:00', '2025-10-31 04:27:00'),
(136, 1, 'admin', 'create', 'membuat pengeluaran barang Non-PO: OUT-NON-202510-00002 (Penerima: PT MUSTIKA KOMPUTER)', 'NonPoIssue', 2, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '2025-10-31 04:34:46', '2025-10-31 04:34:46'),
(137, 1, 'admin', 'create', 'membuat pengeluaran barang Non-PO: OUT-NON-202510-00001 (Penerima: PT MUSTIKA KOMPUTER)', 'NonPoIssue', 3, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '2025-10-31 04:48:28', '2025-10-31 04:48:28'),
(138, 2, 'staff', 'login', 'telah login ke sistem', 'Auth', 2, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '2025-10-31 05:27:41', '2025-10-31 05:27:41'),
(139, 1, 'admin', 'login', 'telah login ke sistem', 'Auth', 1, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '2025-10-31 05:33:10', '2025-10-31 05:33:10'),
(140, 1, 'admin', 'logout', 'telah logout dari sistem', 'Auth', 1, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '2025-10-31 05:35:49', '2025-10-31 05:35:49'),
(141, 2, 'staff', 'login', 'telah login ke sistem', 'Auth', 2, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '2025-10-31 05:35:54', '2025-10-31 05:35:54'),
(142, 2, 'staff', 'logout', 'telah logout dari sistem', 'Auth', 2, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '2025-10-31 05:54:55', '2025-10-31 05:54:55'),
(143, 1, 'admin', 'login', 'telah login ke sistem', 'Auth', 1, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '2025-10-31 05:55:02', '2025-10-31 05:55:02'),
(144, 2, 'staff', 'login', 'telah login ke sistem', 'Auth', 2, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '2025-10-31 05:55:57', '2025-10-31 05:55:57'),
(145, 1, 'admin', 'login', 'telah login ke sistem', 'Auth', 1, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '2025-10-31 05:56:29', '2025-10-31 05:56:29'),
(146, 1, 'admin', 'logout', 'telah logout dari sistem', 'Auth', 1, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '2025-10-31 05:58:34', '2025-10-31 05:58:34'),
(147, 2, 'staff', 'login', 'telah login ke sistem', 'Auth', 2, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '2025-10-31 05:58:40', '2025-10-31 05:58:40'),
(148, 2, 'staff', 'login', 'telah login ke sistem', 'Auth', 2, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '2025-10-31 05:58:49', '2025-10-31 05:58:49'),
(149, 2, 'staff', 'logout', 'telah logout dari sistem', 'Auth', 2, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '2025-10-31 06:05:57', '2025-10-31 06:05:57'),
(150, 1, 'admin', 'login', 'telah login ke sistem', 'Auth', 1, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '2025-10-31 06:06:04', '2025-10-31 06:06:04'),
(151, 1, 'admin', 'login', 'telah login ke sistem', 'Auth', 1, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '2025-10-31 06:06:38', '2025-10-31 06:06:38'),
(152, 1, 'admin', 'logout', 'telah logout dari sistem', 'Auth', 1, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '2025-10-31 06:25:10', '2025-10-31 06:25:10'),
(153, 2, 'staff', 'login', 'telah login ke sistem', 'Auth', 2, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '2025-10-31 06:25:17', '2025-10-31 06:25:17'),
(154, 1, 'admin', 'login', 'telah login ke sistem', 'Auth', 1, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '2025-10-31 06:27:00', '2025-10-31 06:27:00'),
(155, 1, 'admin', 'logout', 'telah logout dari sistem', 'Auth', 1, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '2025-10-31 06:52:27', '2025-10-31 06:52:27'),
(156, 2, 'staff', 'login', 'telah login ke sistem', 'Auth', 2, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '2025-10-31 06:52:34', '2025-10-31 06:52:34'),
(157, 2, 'staff', 'logout', 'telah logout dari sistem', 'Auth', 2, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '2025-10-31 06:52:55', '2025-10-31 06:52:55'),
(158, 1, 'admin', 'login', 'telah login ke sistem', 'Auth', 1, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '2025-10-31 06:53:01', '2025-10-31 06:53:01'),
(159, 1, 'admin', 'logout', 'telah logout dari sistem', 'Auth', 1, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '2025-10-31 06:54:00', '2025-10-31 06:54:00'),
(160, 2, 'staff', 'login', 'telah login ke sistem', 'Auth', 2, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '2025-10-31 06:54:06', '2025-10-31 06:54:06'),
(161, 2, 'staff', 'create', 'membuat Purchase Order: PO-202510-0002 untuk supplier PT. MUSTIKA KOMPUTER', 'PurchaseOrder', 11, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '2025-10-31 06:54:49', '2025-10-31 06:54:49'),
(162, 1, 'admin', 'login', 'telah login ke sistem', 'Auth', 1, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '2025-10-31 06:55:09', '2025-10-31 06:55:09'),
(163, 1, 'admin', 'approve', 'menyetujui Purchase Order: PO-202510-0002', 'PurchaseOrder', 11, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '2025-10-31 06:55:23', '2025-10-31 06:55:23'),
(164, 1, 'admin', 'logout', 'telah logout dari sistem', 'Auth', 1, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '2025-10-31 07:05:58', '2025-10-31 07:05:58'),
(165, 2, 'staff', 'login', 'telah login ke sistem', 'Auth', 2, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '2025-10-31 07:06:09', '2025-10-31 07:06:09'),
(166, 1, 'admin', 'login', 'telah login ke sistem', 'Auth', 1, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '2025-10-31 07:08:08', '2025-10-31 07:08:08'),
(167, 1, 'admin', 'logout', 'telah logout dari sistem', 'Auth', 1, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '2025-10-31 07:53:58', '2025-10-31 07:53:58'),
(168, 2, 'staff', 'login', 'telah login ke sistem', 'Auth', 2, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '2025-10-31 07:54:05', '2025-10-31 07:54:05'),
(169, 2, 'staff', 'logout', 'telah logout dari sistem', 'Auth', 2, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '2025-10-31 07:54:29', '2025-10-31 07:54:29'),
(170, 1, 'admin', 'login', 'telah login ke sistem', 'Auth', 1, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '2025-10-31 07:54:41', '2025-10-31 07:54:41'),
(171, 1, 'admin', 'logout', 'telah logout dari sistem', 'Auth', 1, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '2025-10-31 08:04:45', '2025-10-31 08:04:45'),
(172, 2, 'staff', 'login', 'telah login ke sistem', 'Auth', 2, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '2025-10-31 08:04:52', '2025-10-31 08:04:52'),
(173, 2, 'staff', 'login', 'telah login ke sistem', 'Auth', 2, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '2025-10-31 08:05:34', '2025-10-31 08:05:34'),
(174, 1, 'admin', 'login', 'telah login ke sistem', 'Auth', 1, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '2025-10-31 08:07:50', '2025-10-31 08:07:50'),
(175, 1, 'admin', 'logout', 'telah logout dari sistem', 'Auth', 1, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '2025-10-31 08:17:15', '2025-10-31 08:17:15'),
(176, 2, 'staff', 'login', 'telah login ke sistem', 'Auth', 2, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '2025-10-31 08:17:20', '2025-10-31 08:17:20'),
(177, 2, 'staff', 'login', 'telah login ke sistem', 'Auth', 2, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '2025-10-31 08:22:06', '2025-10-31 08:22:06'),
(178, 1, 'admin', 'login', 'telah login ke sistem', 'Auth', 1, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '2025-10-31 10:38:52', '2025-10-31 10:38:52'),
(179, 1, 'admin', 'logout', 'telah logout dari sistem', 'Auth', 1, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '2025-10-31 19:31:36', '2025-10-31 19:31:36'),
(180, 2, 'staff', 'login', 'telah login ke sistem', 'Auth', 2, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '2025-10-31 19:31:42', '2025-10-31 19:31:42'),
(181, 2, 'staff', 'logout', 'telah logout dari sistem', 'Auth', 2, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '2025-10-31 19:32:08', '2025-10-31 19:32:08'),
(182, 1, 'admin', 'login', 'telah login ke sistem', 'Auth', 1, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '2025-10-31 19:32:15', '2025-10-31 19:32:15'),
(183, 1, 'admin', 'logout', 'telah logout dari sistem', 'Auth', 1, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '2025-10-31 21:36:31', '2025-10-31 21:36:31'),
(184, 2, 'staff', 'login', 'telah login ke sistem', 'Auth', 2, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '2025-10-31 21:36:37', '2025-10-31 21:36:37'),
(185, 2, 'staff', 'create', 'Membuat Sales Order baru SO-202511-0001 untuk customer PT. SUKSES JAYA SENTOSA', 'SalesOrder', 5, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '2025-10-31 21:37:01', '2025-10-31 21:37:01'),
(186, 1, 'admin', 'login', 'telah login ke sistem', 'Auth', 1, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '2025-10-31 21:37:37', '2025-10-31 21:37:37'),
(187, 1, 'admin', 'approve', 'Menyetujui Sales Order SO-202511-0001 untuk customer PT. SUKSES JAYA SENTOSA', 'SalesOrder', 5, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '2025-10-31 21:37:45', '2025-10-31 21:37:45'),
(188, 1, 'admin', 'logout', 'telah logout dari sistem', 'Auth', 1, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '2025-10-31 21:38:22', '2025-10-31 21:38:22'),
(189, 2, 'staff', 'login', 'telah login ke sistem', 'Auth', 2, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '2025-10-31 21:38:29', '2025-10-31 21:38:29'),
(190, 1, 'admin', 'login', 'telah login ke sistem', 'Auth', 1, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '2025-10-31 21:39:18', '2025-10-31 21:39:18'),
(191, 1, 'admin', 'process', 'Memproses pengeluaran barang untuk Sales Order SO-202511-0001', 'SalesOrder', 5, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '2025-10-31 21:45:39', '2025-10-31 21:45:39'),
(192, 2, 'staff', 'login', 'telah login ke sistem', 'Auth', 2, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '2025-10-31 21:48:46', '2025-10-31 21:48:46'),
(193, 2, 'staff', 'create', 'Membuat Sales Order baru SO-202511-0002 untuk customer PT. SUKSES JAYA SENTOSA', 'SalesOrder', 6, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '2025-10-31 21:49:04', '2025-10-31 21:49:04'),
(194, 1, 'admin', 'login', 'telah login ke sistem', 'Auth', 1, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '2025-10-31 21:49:25', '2025-10-31 21:49:25'),
(195, 1, 'admin', 'approve', 'Menyetujui Sales Order SO-202511-0002 untuk customer PT. SUKSES JAYA SENTOSA', 'SalesOrder', 6, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '2025-10-31 21:49:40', '2025-10-31 21:49:40'),
(196, 1, 'admin', 'process', 'Memproses pengeluaran barang untuk Sales Order SO-202511-0002', 'SalesOrder', 6, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '2025-10-31 22:03:42', '2025-10-31 22:03:42'),
(197, 2, 'staff', 'login', 'telah login ke sistem', 'Auth', 2, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '2025-10-31 22:16:38', '2025-10-31 22:16:38'),
(198, 2, 'staff', 'create', 'Membuat Sales Order baru SO-202511-0003 untuk customer PT. SUKSES JAYA SENTOSA', 'SalesOrder', 7, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '2025-10-31 22:16:52', '2025-10-31 22:16:52'),
(199, 1, 'admin', 'login', 'telah login ke sistem', 'Auth', 1, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '2025-10-31 22:17:00', '2025-10-31 22:17:00'),
(200, 1, 'admin', 'approve', 'Menyetujui Sales Order SO-202511-0003 untuk customer PT. SUKSES JAYA SENTOSA', 'SalesOrder', 7, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '2025-10-31 22:17:10', '2025-10-31 22:17:10'),
(201, 1, 'admin', 'logout', 'telah logout dari sistem', 'Auth', 1, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '2025-10-31 23:47:18', '2025-10-31 23:47:18');
INSERT INTO `audit_logs` (`id`, `user_id`, `username`, `action`, `description`, `entity_type`, `entity_id`, `ip_address`, `user_agent`, `created_at`, `updated_at`) VALUES
(202, 2, 'staff', 'login', 'telah login ke sistem', 'Auth', 2, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '2025-10-31 23:47:23', '2025-10-31 23:47:23'),
(203, 2, 'staff', 'create', 'membuat Purchase Order: PO-202511-0001 untuk supplier PT. MUSTIKA KOMPUTER', 'PurchaseOrder', 12, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '2025-10-31 23:48:02', '2025-10-31 23:48:02'),
(204, 2, 'staff', 'create', 'Membuat Sales Order baru SO-202511-0001 untuk customer PT. SUKSES JAYA SENTOSA', 'SalesOrder', 1, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '2025-10-31 23:48:18', '2025-10-31 23:48:18'),
(205, 2, 'staff', 'create', 'membuat Purchase Order: PO-202511-0002 untuk supplier PT. MUSTIKA KOMPUTER', 'PurchaseOrder', 13, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '2025-10-31 23:48:34', '2025-10-31 23:48:34'),
(206, 2, 'staff', 'create', 'Membuat Sales Order baru SO-202511-0002 untuk customer PT. SUKSES JAYA SENTOSA', 'SalesOrder', 2, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '2025-10-31 23:49:17', '2025-10-31 23:49:17'),
(207, 2, 'staff', 'logout', 'telah logout dari sistem', 'Auth', 2, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '2025-10-31 23:49:24', '2025-10-31 23:49:24'),
(208, 1, 'admin', 'login', 'telah login ke sistem', 'Auth', 1, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '2025-10-31 23:49:29', '2025-10-31 23:49:29'),
(209, 1, 'admin', 'approve', 'menyetujui Purchase Order: PO-202511-0002', 'PurchaseOrder', 13, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '2025-10-31 23:49:59', '2025-10-31 23:49:59'),
(210, 1, 'admin', 'approve', 'Menyetujui Sales Order SO-202511-0002 untuk customer PT. SUKSES JAYA SENTOSA', 'SalesOrder', 2, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '2025-10-31 23:50:09', '2025-10-31 23:50:09'),
(211, 1, 'admin', 'receive', 'menerima barang untuk Purchase Order: PO-202511-0002 (Surat Jalan: SJ-PO-20251101)', 'PurchaseOrder', 13, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '2025-10-31 23:50:53', '2025-10-31 23:50:53'),
(212, 1, 'admin', 'approve', 'menyetujui Purchase Order: PO-202511-0001', 'PurchaseOrder', 12, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '2025-10-31 23:52:14', '2025-10-31 23:52:14'),
(213, 1, 'admin', 'approve', 'Menyetujui Sales Order SO-202511-0001 untuk customer PT. SUKSES JAYA SENTOSA', 'SalesOrder', 1, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '2025-10-31 23:55:54', '2025-10-31 23:55:54'),
(214, 1, 'admin', 'process', 'Memproses pengeluaran barang untuk Sales Order SO-202511-0001', 'SalesOrder', 1, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '2025-11-01 00:34:36', '2025-11-01 00:34:36'),
(215, 2, 'staff', 'login', 'telah login ke sistem', 'Auth', 2, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '2025-11-01 00:51:13', '2025-11-01 00:51:13'),
(216, 1, 'admin', 'login', 'telah login ke sistem', 'Auth', 1, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '2025-11-01 01:07:49', '2025-11-01 01:07:49'),
(217, 1, 'admin', 'logout', 'telah logout dari sistem', 'Auth', 1, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '2025-11-01 01:08:27', '2025-11-01 01:08:27'),
(218, 2, 'staff', 'login', 'telah login ke sistem', 'Auth', 2, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '2025-11-01 01:08:39', '2025-11-01 01:08:39'),
(219, 1, 'admin', 'login', 'telah login ke sistem', 'Auth', 1, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '2025-11-01 02:09:26', '2025-11-01 02:09:26'),
(220, 1, 'admin', 'logout', 'telah logout dari sistem', 'Auth', 1, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '2025-11-01 04:37:46', '2025-11-01 04:37:46'),
(221, 2, 'staff', 'login', 'telah login ke sistem', 'Auth', 2, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '2025-11-01 04:37:56', '2025-11-01 04:37:56'),
(222, 1, 'admin', 'login', 'telah login ke sistem', 'Auth', 1, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '2025-11-01 05:20:07', '2025-11-01 05:20:07'),
(223, 1, 'admin', 'logout', 'telah logout dari sistem', 'Auth', 1, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '2025-11-04 22:18:43', '2025-11-04 22:18:43'),
(224, 2, 'staff', 'login', 'telah login ke sistem', 'Auth', 2, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '2025-11-04 22:18:54', '2025-11-04 22:18:54'),
(225, 2, 'staff', 'logout', 'telah logout dari sistem', 'Auth', 2, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '2025-11-04 22:26:52', '2025-11-04 22:26:52'),
(226, 1, 'admin', 'login', 'telah login ke sistem', 'Auth', 1, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '2025-11-04 22:27:00', '2025-11-04 22:27:00'),
(227, 1, 'admin', 'create', 'membuat pengeluaran barang Non-PO: OUT-NON-202511-00001 (Penerima: PT MUSTIKA KOMPUTER)', 'NonPoIssue', 4, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '2025-11-04 22:41:56', '2025-11-04 22:41:56'),
(228, 1, 'admin', 'logout', 'telah logout dari sistem', 'Auth', 1, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '2025-11-04 22:42:11', '2025-11-04 22:42:11'),
(229, 1, 'admin', 'login', 'telah login ke sistem', 'Auth', 1, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '2025-11-04 22:42:20', '2025-11-04 22:42:20'),
(230, 1, 'admin', 'logout', 'telah logout dari sistem', 'Auth', 1, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '2025-11-04 22:49:11', '2025-11-04 22:49:11'),
(231, 2, 'staff', 'login', 'telah login ke sistem', 'Auth', 2, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '2025-11-04 22:49:18', '2025-11-04 22:49:18'),
(232, 2, 'staff', 'logout', 'telah logout dari sistem', 'Auth', 2, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '2025-11-04 22:53:06', '2025-11-04 22:53:06'),
(233, 1, 'admin', 'login', 'telah login ke sistem', 'Auth', 1, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '2025-11-04 22:53:12', '2025-11-04 22:53:12'),
(234, 1, 'admin', 'logout', 'telah logout dari sistem', 'Auth', 1, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '2025-11-04 23:01:28', '2025-11-04 23:01:28'),
(235, 2, 'staff', 'login', 'telah login ke sistem', 'Auth', 2, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '2025-11-04 23:01:33', '2025-11-04 23:01:33'),
(236, 1, 'admin', 'login', 'telah login ke sistem', 'Auth', 1, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '2025-11-04 23:03:02', '2025-11-04 23:03:02'),
(237, 1, 'admin', 'logout', 'telah logout dari sistem', 'Auth', 1, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '2025-11-04 23:08:28', '2025-11-04 23:08:28'),
(238, 2, 'staff', 'login', 'telah login ke sistem', 'Auth', 2, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '2025-11-04 23:08:34', '2025-11-04 23:08:34'),
(239, 1, 'admin', 'login', 'telah login ke sistem', 'Auth', 1, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '2025-11-04 23:10:19', '2025-11-04 23:10:19'),
(240, 1, 'admin', 'logout', 'telah logout dari sistem', 'Auth', 1, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '2025-11-04 23:17:44', '2025-11-04 23:17:44'),
(241, 2, 'staff', 'login', 'telah login ke sistem', 'Auth', 2, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '2025-11-04 23:18:20', '2025-11-04 23:18:20'),
(242, 2, 'staff', 'create', 'membuat pengeluaran barang Non-PO: OUT-NON-202511-00001 (Penerima: PT MUSTIKA KOMPUTER)', 'NonPoIssue', 5, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '2025-11-04 23:19:42', '2025-11-04 23:19:42'),
(243, 1, 'admin', 'login', 'telah login ke sistem', 'Auth', 1, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '2025-11-04 23:20:29', '2025-11-04 23:20:29'),
(244, 1, 'admin', 'logout', 'telah logout dari sistem', 'Auth', 1, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '2025-11-04 23:27:11', '2025-11-04 23:27:11'),
(245, 2, 'staff', 'login', 'telah login ke sistem', 'Auth', 2, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '2025-11-04 23:27:18', '2025-11-04 23:27:18'),
(246, 1, 'admin', 'login', 'telah login ke sistem', 'Auth', 1, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '2025-11-04 23:30:59', '2025-11-04 23:30:59'),
(247, 1, 'admin', 'logout', 'telah logout dari sistem', 'Auth', 1, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '2025-11-05 00:10:40', '2025-11-05 00:10:40'),
(248, 2, 'staff', 'login', 'telah login ke sistem', 'Auth', 2, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '2025-11-05 00:10:45', '2025-11-05 00:10:45'),
(249, 2, 'staff', 'login', 'telah login ke sistem', 'Auth', 2, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '2025-11-05 00:27:22', '2025-11-05 00:27:22'),
(250, 2, 'staff', 'login', 'telah login ke sistem', 'Auth', 2, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '2025-11-05 00:42:36', '2025-11-05 00:42:36'),
(251, 2, 'staff', 'create', 'membuat penerimaan barang Non-PO: GR-NON-202511-00001 (Sumber: Retrun)', 'NonPoReceipt', 3, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '2025-11-06 01:18:17', '2025-11-06 01:18:17'),
(252, 2, 'staff', 'create', 'membuat pengeluaran barang Non-PO: OUT-NON-20251106-0001 (Penerima: PT MUSTIKA KOMPUTER)', 'NonPoIssue', 6, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '2025-11-06 01:20:44', '2025-11-06 01:20:44'),
(253, 1, 'admin', 'login', 'telah login ke sistem', 'Auth', 1, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '2025-11-06 01:21:19', '2025-11-06 01:21:19'),
(254, 1, 'admin', 'logout', 'telah logout dari sistem', 'Auth', 1, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '2025-11-06 01:27:54', '2025-11-06 01:27:54'),
(255, 2, 'staff', 'login', 'telah login ke sistem', 'Auth', 2, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '2025-11-06 01:28:02', '2025-11-06 01:28:02'),
(256, 2, 'staff', 'create', 'membuat pengeluaran barang Non-PO: OUT-NON-20251106-0001 (Penerima: PT MUSTIKA KOMPUTER)', 'NonPoIssue', 7, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '2025-11-06 01:32:05', '2025-11-06 01:32:05'),
(257, 2, 'staff', 'create', 'membuat pengeluaran barang Non-PO: OUT-NON-20251106-0001 (Penerima: PT MUSTIKA KOMPUTER)', 'NonPoIssue', 8, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '2025-11-06 01:44:00', '2025-11-06 01:44:00'),
(258, 2, 'staff', 'create', 'membuat pengeluaran barang Non-PO: OUT-NON-20251106-0001 (Penerima: PT MUSTIKA KOMPUTER)', 'NonPoIssue', 9, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '2025-11-06 02:37:56', '2025-11-06 02:37:56'),
(259, 1, 'admin', 'login', 'telah login ke sistem', 'Auth', 1, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '2025-11-06 02:38:38', '2025-11-06 02:38:38'),
(260, 1, 'admin', 'approve', 'menyetujui Pengeluaran Non-SO: OUT-NON-20251106-0001 (Penerima: PT MUSTIKA KOMPUTER)', 'NonPoIssue', 9, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '2025-11-06 03:13:57', '2025-11-06 03:13:57'),
(261, 1, 'admin', 'logout', 'telah logout dari sistem', 'Auth', 1, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '2025-11-06 03:14:18', '2025-11-06 03:14:18'),
(262, 2, 'staff', 'login', 'telah login ke sistem', 'Auth', 2, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '2025-11-06 03:14:23', '2025-11-06 03:14:23'),
(263, 1, 'admin', 'login', 'telah login ke sistem', 'Auth', 1, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '2025-11-06 03:15:19', '2025-11-06 03:15:19'),
(264, 1, 'admin', 'logout', 'telah logout dari sistem', 'Auth', 1, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '2025-11-06 04:38:37', '2025-11-06 04:38:37'),
(265, 2, 'staff', 'login', 'telah login ke sistem', 'Auth', 2, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '2025-11-06 04:38:44', '2025-11-06 04:38:44'),
(266, 1, 'admin', 'login', 'telah login ke sistem', 'Auth', 1, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/142.0.0.0 Safari/537.36', '2025-11-08 21:30:51', '2025-11-08 21:30:51'),
(267, 1, 'admin', 'logout', 'telah logout dari sistem', 'Auth', 1, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/142.0.0.0 Safari/537.36', '2025-11-08 21:33:14', '2025-11-08 21:33:14'),
(268, 2, 'staff', 'login', 'telah login ke sistem', 'Auth', 2, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/142.0.0.0 Safari/537.36', '2025-11-08 21:33:20', '2025-11-08 21:33:20'),
(269, 2, 'staff', 'create', 'membuat Purchase Order: PO-202511-0003 untuk supplier PT. MUSTIKA KOMPUTER', 'PurchaseOrder', 14, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/142.0.0.0 Safari/537.36', '2025-11-08 21:34:08', '2025-11-08 21:34:08'),
(270, 1, 'admin', 'login', 'telah login ke sistem', 'Auth', 1, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/142.0.0.0 Safari/537.36', '2025-11-08 21:34:58', '2025-11-08 21:34:58'),
(271, 1, 'admin', 'approve', 'menyetujui Purchase Order: PO-202511-0003', 'PurchaseOrder', 14, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/142.0.0.0 Safari/537.36', '2025-11-08 21:35:22', '2025-11-08 21:35:22'),
(272, 1, 'admin', 'receive', 'menerima barang untuk Purchase Order: PO-202511-0003 (Surat Jalan: SJ-PO-09112025-001)', 'PurchaseOrder', 14, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/142.0.0.0 Safari/537.36', '2025-11-08 21:36:02', '2025-11-08 21:36:02'),
(273, 1, 'admin', 'login', 'telah login ke sistem', 'Auth', 1, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/142.0.0.0 Safari/537.36', '2025-11-09 04:06:13', '2025-11-09 04:06:13'),
(274, 2, 'staff', 'login', 'telah login ke sistem', 'Auth', 2, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/142.0.0.0 Safari/537.36', '2025-11-09 04:09:45', '2025-11-09 04:09:45'),
(275, 1, 'admin', 'login', 'telah login ke sistem', 'Auth', 1, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/142.0.0.0 Safari/537.36', '2025-11-09 04:11:26', '2025-11-09 04:11:26'),
(276, 2, 'staff', 'login', 'telah login ke sistem', 'Auth', 2, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/142.0.0.0 Safari/537.36', '2025-11-09 04:20:01', '2025-11-09 04:20:01'),
(277, 1, 'admin', 'login', 'telah login ke sistem', 'Auth', 1, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/142.0.0.0 Safari/537.36', '2025-11-09 04:22:04', '2025-11-09 04:22:04'),
(278, 1, 'admin', 'process', 'Memproses pengeluaran barang untuk Sales Order SO-202511-0002', 'SalesOrder', 2, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/142.0.0.0 Safari/537.36', '2025-11-09 04:22:18', '2025-11-09 04:22:18'),
(279, 1, 'admin', 'process', 'memproses/mengeluarkan barang Non-SO: OUT-NON-20251106-0001 (Penerima: PT MUSTIKA KOMPUTER)', 'NonPoIssue', 9, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/142.0.0.0 Safari/537.36', '2025-11-09 04:22:50', '2025-11-09 04:22:50'),
(280, 2, 'staff', 'login', 'telah login ke sistem', 'Auth', 2, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/142.0.0.0 Safari/537.36', '2025-11-09 04:23:45', '2025-11-09 04:23:45'),
(281, 2, 'staff', 'create', 'membuat penerimaan barang Non-PO: GR-NON-202511-00001 (Sumber: Retrun)', 'NonPoReceipt', 4, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/142.0.0.0 Safari/537.36', '2025-11-09 05:18:32', '2025-11-09 05:18:32'),
(282, 2, 'staff', 'create', 'membuat penerimaan barang Non-PO: GR-NON-202511-00002 (Sumber: Retrun)', 'NonPoReceipt', 5, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/142.0.0.0 Safari/537.36', '2025-11-09 05:27:11', '2025-11-09 05:27:11'),
(283, 1, 'admin', 'login', 'telah login ke sistem', 'Auth', 1, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/142.0.0.0 Safari/537.36', '2025-11-09 05:33:58', '2025-11-09 05:33:58'),
(284, 1, 'admin', 'logout', 'telah logout dari sistem', 'Auth', 1, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/142.0.0.0 Safari/537.36', '2025-11-09 05:37:03', '2025-11-09 05:37:03'),
(285, 2, 'staff', 'login', 'telah login ke sistem', 'Auth', 2, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/142.0.0.0 Safari/537.36', '2025-11-09 05:37:08', '2025-11-09 05:37:08'),
(286, 1, 'admin', 'login', 'telah login ke sistem', 'Auth', 1, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/142.0.0.0 Safari/537.36', '2025-11-09 05:39:17', '2025-11-09 05:39:17'),
(287, 1, 'admin', 'logout', 'telah logout dari sistem', 'Auth', 1, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/142.0.0.0 Safari/537.36', '2025-11-09 05:42:14', '2025-11-09 05:42:14'),
(288, 2, 'staff', 'login', 'telah login ke sistem', 'Auth', 2, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/142.0.0.0 Safari/537.36', '2025-11-09 05:42:21', '2025-11-09 05:42:21'),
(289, 2, 'staff', 'login', 'telah login ke sistem', 'Auth', 2, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/142.0.0.0 Safari/537.36', '2025-11-09 05:42:47', '2025-11-09 05:42:47'),
(290, 1, 'admin', 'login', 'telah login ke sistem', 'Auth', 1, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/142.0.0.0 Safari/537.36', '2025-11-09 05:43:52', '2025-11-09 05:43:52'),
(291, 1, 'admin', 'approve', 'menyetujui Penerimaan Non-PO: GR-NON-202511-00002 (Sumber: Retrun)', 'NonPoReceipt', 5, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/142.0.0.0 Safari/537.36', '2025-11-09 05:47:31', '2025-11-09 05:47:31'),
(292, 1, 'admin', 'approve', 'menyetujui Penerimaan Non-PO: GR-NON-202511-00001 (Sumber: Retrun)', 'NonPoReceipt', 4, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/142.0.0.0 Safari/537.36', '2025-11-10 21:35:27', '2025-11-10 21:35:27'),
(293, 1, 'admin', 'logout', 'telah logout dari sistem', 'Auth', 1, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/142.0.0.0 Safari/537.36', '2025-11-10 21:54:22', '2025-11-10 21:54:22'),
(294, 2, 'staff', 'login', 'telah login ke sistem', 'Auth', 2, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/142.0.0.0 Safari/537.36', '2025-11-10 21:54:29', '2025-11-10 21:54:29'),
(295, 2, 'staff', 'create', 'membuat penerimaan barang Non-PO: GR-NON-202511-00001 (Sumber: PT.SENTOSA JAYA)', 'NonPoReceipt', 6, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/142.0.0.0 Safari/537.36', '2025-11-10 21:55:22', '2025-11-10 21:55:22'),
(296, 1, 'admin', 'login', 'telah login ke sistem', 'Auth', 1, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/142.0.0.0 Safari/537.36', '2025-11-10 21:56:06', '2025-11-10 21:56:06'),
(297, 1, 'admin', 'approve', 'menyetujui Penerimaan Non-PO: GR-NON-202511-00001 (Sumber: PT.SENTOSA JAYA)', 'NonPoReceipt', 6, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/142.0.0.0 Safari/537.36', '2025-11-10 21:56:38', '2025-11-10 21:56:38'),
(298, 1, 'admin', 'logout', 'telah logout dari sistem', 'Auth', 1, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/142.0.0.0 Safari/537.36', '2025-11-10 22:09:25', '2025-11-10 22:09:25'),
(299, 2, 'staff', 'login', 'telah login ke sistem', 'Auth', 2, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/142.0.0.0 Safari/537.36', '2025-11-10 22:09:31', '2025-11-10 22:09:31'),
(300, 2, 'staff', 'create', 'membuat penerimaan barang Non-PO: GR-NON-202511-00001 (Sumber: PT JAYA SENTOSA)', 'NonPoReceipt', 7, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/142.0.0.0 Safari/537.36', '2025-11-10 22:10:01', '2025-11-10 22:10:01'),
(301, 2, 'staff', 'logout', 'telah logout dari sistem', 'Auth', 2, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/142.0.0.0 Safari/537.36', '2025-11-10 22:10:37', '2025-11-10 22:10:37'),
(302, 1, 'admin', 'login', 'telah login ke sistem', 'Auth', 1, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/142.0.0.0 Safari/537.36', '2025-11-10 22:10:42', '2025-11-10 22:10:42'),
(303, 1, 'admin', 'approve', 'menyetujui Penerimaan Non-PO: GR-NON-202511-00001 (Sumber: PT JAYA SENTOSA)', 'NonPoReceipt', 7, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/142.0.0.0 Safari/537.36', '2025-11-10 22:10:51', '2025-11-10 22:10:51'),
(304, 1, 'admin', 'logout', 'telah logout dari sistem', 'Auth', 1, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/142.0.0.0 Safari/537.36', '2025-11-10 22:31:56', '2025-11-10 22:31:56'),
(305, 1, 'admin', 'login', 'telah login ke sistem', 'Auth', 1, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/142.0.0.0 Safari/537.36', '2025-11-10 22:32:02', '2025-11-10 22:32:02'),
(306, 1, 'admin', 'create', 'membuat penerimaan barang Non-PO: GR-NON-202511-00001 (Sumber: PT JAYA SENTOSA)', 'NonPoReceipt', 8, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/142.0.0.0 Safari/537.36', '2025-11-10 22:32:21', '2025-11-10 22:32:21'),
(307, 1, 'admin', 'logout', 'telah logout dari sistem', 'Auth', 1, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/142.0.0.0 Safari/537.36', '2025-11-10 22:33:41', '2025-11-10 22:33:41'),
(308, 2, 'staff', 'login', 'telah login ke sistem', 'Auth', 2, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/142.0.0.0 Safari/537.36', '2025-11-10 22:33:47', '2025-11-10 22:33:47'),
(309, 2, 'staff', 'create', 'membuat penerimaan barang Non-PO: GR-NON-202511-00002 (Sumber: PT.JAYA SENTOSA)', 'NonPoReceipt', 9, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/142.0.0.0 Safari/537.36', '2025-11-10 22:34:13', '2025-11-10 22:34:13'),
(310, 2, 'staff', 'logout', 'telah logout dari sistem', 'Auth', 2, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/142.0.0.0 Safari/537.36', '2025-11-10 22:45:25', '2025-11-10 22:45:25'),
(311, 1, 'admin', 'login', 'telah login ke sistem', 'Auth', 1, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/142.0.0.0 Safari/537.36', '2025-11-10 22:45:32', '2025-11-10 22:45:32'),
(312, 1, 'admin', 'create', 'membuat penerimaan barang Non-PO: GR-NON-202511-00001 (Sumber: PT. SENTOSA JAYA)', 'NonPoReceipt', 10, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/142.0.0.0 Safari/537.36', '2025-11-10 22:48:01', '2025-11-10 22:48:01'),
(313, 1, 'admin', 'approve', 'menyetujui Penerimaan Non-PO: GR-NON-202511-00001 (Sumber: PT. SENTOSA JAYA)', 'NonPoReceipt', 10, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/142.0.0.0 Safari/537.36', '2025-11-10 22:48:35', '2025-11-10 22:48:35'),
(314, 1, 'admin', 'receive', 'menerima barang Non-PO: GR-NON-202511-00001 dengan No. Surat Jalan: SJ-20251111-001', 'NonPoReceipt', 10, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/142.0.0.0 Safari/537.36', '2025-11-10 22:49:25', '2025-11-10 22:49:25'),
(315, 1, 'admin', 'create', 'membuat penerimaan barang Non-PO: GR-NON-202511-00002 (Sumber: PT.JAYA SENTOSA)', 'NonPoReceipt', 11, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/142.0.0.0 Safari/537.36', '2025-11-10 22:59:00', '2025-11-10 22:59:00'),
(316, 1, 'admin', 'approve', 'menyetujui Penerimaan Non-PO: GR-NON-202511-00002 (Sumber: PT.JAYA SENTOSA)', 'NonPoReceipt', 11, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/142.0.0.0 Safari/537.36', '2025-11-10 22:59:21', '2025-11-10 22:59:21'),
(317, 2, 'staff', 'login', 'telah login ke sistem', 'Auth', 2, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/142.0.0.0 Safari/537.36', '2025-11-10 23:06:20', '2025-11-10 23:06:20'),
(318, 2, 'staff', 'logout', 'telah logout dari sistem', 'Auth', 2, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/142.0.0.0 Safari/537.36', '2025-11-10 23:11:40', '2025-11-10 23:11:40'),
(319, 1, 'admin', 'login', 'telah login ke sistem', 'Auth', 1, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/142.0.0.0 Safari/537.36', '2025-11-10 23:11:47', '2025-11-10 23:11:47'),
(320, 2, 'staff', 'login', 'telah login ke sistem', 'Auth', 2, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/142.0.0.0 Safari/537.36', '2025-11-12 23:34:17', '2025-11-12 23:34:17'),
(321, 1, 'admin', 'login', 'telah login ke sistem', 'Auth', 1, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/142.0.0.0 Safari/537.36', '2025-11-13 00:38:22', '2025-11-13 00:38:22'),
(322, 2, 'staff', 'login', 'telah login ke sistem', 'Auth', 2, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/142.0.0.0 Safari/537.36', '2025-11-13 01:02:09', '2025-11-13 01:02:09'),
(323, 1, 'admin', 'login', 'telah login ke sistem', 'Auth', 1, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/142.0.0.0 Safari/537.36', '2025-11-17 22:59:54', '2025-11-17 22:59:54'),
(324, 2, 'staff', 'login', 'telah login ke sistem', 'Auth', 2, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/142.0.0.0 Safari/537.36', '2025-11-17 23:42:02', '2025-11-17 23:42:02'),
(325, 1, 'admin', 'login', 'telah login ke sistem', 'Auth', 1, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/142.0.0.0 Safari/537.36', '2025-11-17 23:42:17', '2025-11-17 23:42:17'),
(326, 2, 'staff', 'login', 'telah login ke sistem', 'Auth', 2, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/142.0.0.0 Safari/537.36', '2025-11-18 02:50:21', '2025-11-18 02:50:21'),
(327, 1, 'admin', 'login', 'telah login ke sistem', 'Auth', 1, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/142.0.0.0 Safari/537.36', '2025-11-18 04:02:43', '2025-11-18 04:02:43'),
(328, 2, 'staff', 'login', 'telah login ke sistem', 'Auth', 2, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/142.0.0.0 Safari/537.36', '2025-11-18 04:03:28', '2025-11-18 04:03:28'),
(329, 1, 'admin', 'login', 'telah login ke sistem', 'Auth', 1, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/142.0.0.0 Safari/537.36', '2025-11-19 22:44:53', '2025-11-19 22:44:53'),
(330, 2, 'staff', 'login', 'telah login ke sistem', 'Auth', 2, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/142.0.0.0 Safari/537.36', '2025-11-22 05:33:51', '2025-11-22 05:33:51'),
(331, 1, 'admin', 'login', 'telah login ke sistem', 'Auth', 1, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/142.0.0.0 Safari/537.36', '2025-11-22 05:34:29', '2025-11-22 05:34:29'),
(332, 2, 'staff', 'login', 'telah login ke sistem', 'Auth', 2, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/142.0.0.0 Safari/537.36', '2025-11-23 19:53:23', '2025-11-23 19:53:23'),
(333, 1, 'admin', 'login', 'telah login ke sistem', 'Auth', 1, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/142.0.0.0 Safari/537.36', '2025-11-23 19:57:24', '2025-11-23 19:57:24'),
(334, 2, 'staff', 'login', 'telah login ke sistem', 'Auth', 2, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/142.0.0.0 Safari/537.36', '2025-11-23 19:57:52', '2025-11-23 19:57:52'),
(335, 1, 'admin', 'login', 'telah login ke sistem', 'Auth', 1, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/142.0.0.0 Safari/537.36', '2025-11-23 20:18:34', '2025-11-23 20:18:34'),
(336, 2, 'staff', 'login', 'telah login ke sistem', 'Auth', 2, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/142.0.0.0 Safari/537.36', '2025-11-23 20:27:01', '2025-11-23 20:27:01'),
(337, 2, 'staff', 'create', 'membuat Purchase Order: PO-202511-0001 untuk supplier PT. MUSTIKA KOMPUTER', 'PurchaseOrder', 15, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/142.0.0.0 Safari/537.36', '2025-11-23 20:27:28', '2025-11-23 20:27:28'),
(338, 1, 'admin', 'login', 'telah login ke sistem', 'Auth', 1, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/142.0.0.0 Safari/537.36', '2025-11-23 20:27:53', '2025-11-23 20:27:53'),
(339, 1, 'admin', 'create', 'membuat penerimaan barang Non-PO: GR-NON-202511-00001 (Sumber: PT. JAYA SENTOSA)', 'NonPoReceipt', 12, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/142.0.0.0 Safari/537.36', '2025-11-23 20:36:56', '2025-11-23 20:36:56'),
(340, 1, 'admin', 'login', 'telah login ke sistem', 'Auth', 1, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/142.0.0.0 Safari/537.36', '2025-11-23 20:37:35', '2025-11-23 20:37:35'),
(341, 2, 'staff', 'login', 'telah login ke sistem', 'Auth', 2, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/142.0.0.0 Safari/537.36', '2025-11-23 20:42:42', '2025-11-23 20:42:42'),
(342, 2, 'staff', 'create', 'membuat penerimaan barang Non-PO: GR-NON-202511-00001 (Sumber: PT. JAYA SENTOSA)', 'NonPoReceipt', 13, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/142.0.0.0 Safari/537.36', '2025-11-23 20:43:33', '2025-11-23 20:43:33'),
(343, 1, 'admin', 'login', 'telah login ke sistem', 'Auth', 1, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/142.0.0.0 Safari/537.36', '2025-11-23 20:44:21', '2025-11-23 20:44:21'),
(344, 1, 'admin', 'approve', 'menyetujui Penerimaan Non-PO: GR-NON-202511-00001 (Sumber: PT. JAYA SENTOSA)', 'NonPoReceipt', 13, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/142.0.0.0 Safari/537.36', '2025-11-23 20:44:32', '2025-11-23 20:44:32'),
(345, 2, 'staff', 'login', 'telah login ke sistem', 'Auth', 2, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/142.0.0.0 Safari/537.36', '2025-11-23 20:45:42', '2025-11-23 20:45:42'),
(346, 2, 'staff', 'create', 'membuat penerimaan barang Non-PO: GR-NON-202511-00002 (Sumber: PT. JAYA SENTOSA)', 'NonPoReceipt', 14, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/142.0.0.0 Safari/537.36', '2025-11-23 20:46:27', '2025-11-23 20:46:27'),
(347, 1, 'admin', 'login', 'telah login ke sistem', 'Auth', 1, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/142.0.0.0 Safari/537.36', '2025-11-25 21:28:44', '2025-11-25 21:28:44'),
(348, 1, 'admin', 'login', 'telah login ke sistem', 'Auth', 1, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/142.0.0.0 Safari/537.36', '2025-11-25 22:44:54', '2025-11-25 22:44:54'),
(349, 2, 'staff', 'login', 'telah login ke sistem', 'Auth', 2, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/142.0.0.0 Safari/537.36', '2025-11-25 22:45:05', '2025-11-25 22:45:05'),
(350, 1, 'admin', 'login', 'telah login ke sistem', 'Auth', 1, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/142.0.0.0 Safari/537.36', '2025-11-25 22:48:57', '2025-11-25 22:48:57'),
(351, 1, 'admin', 'approve', 'menyetujui Purchase Order: PO-202511-0001', 'PurchaseOrder', 15, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/142.0.0.0 Safari/537.36', '2025-11-25 22:59:43', '2025-11-25 22:59:43');

-- --------------------------------------------------------

--
-- Table structure for table `barang`
--

CREATE TABLE `barang` (
  `id` bigint UNSIGNED NOT NULL,
  `nama` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `kode` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `kategori_id` bigint UNSIGNED NOT NULL,
  `deskripsi` text COLLATE utf8mb4_unicode_ci,
  `stok` int NOT NULL DEFAULT '0',
  `stok_minimum` int NOT NULL DEFAULT '0',
  `harga_beli` decimal(15,2) NOT NULL DEFAULT '0.00',
  `harga_jual` decimal(15,2) NOT NULL DEFAULT '0.00',
  `satuan` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `foto` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `status` tinyint(1) NOT NULL DEFAULT '1',
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  `deleted_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `barang`
--

INSERT INTO `barang` (`id`, `nama`, `kode`, `kategori_id`, `deskripsi`, `stok`, `stok_minimum`, `harga_beli`, `harga_jual`, `satuan`, `foto`, `status`, `created_at`, `updated_at`, `deleted_at`) VALUES
(1, 'Xiaomi 11T', 'PRD-XIAOM-7692', 5, NULL, 7, 0, 5000000.00, 6500000.00, 'Unit', NULL, 1, '2025-10-28 04:22:11', '2025-11-10 22:49:25', NULL),
(4, 'OPPO RENO 14F', 'PRD-OPPO-9685', 5, NULL, 4, 0, 3000000.00, 5000000.00, 'Unit', NULL, 1, '2025-10-29 03:25:21', '2025-11-09 04:22:18', NULL);

-- --------------------------------------------------------

--
-- Table structure for table `cache`
--

CREATE TABLE `cache` (
  `key` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `value` mediumtext COLLATE utf8mb4_unicode_ci NOT NULL,
  `expiration` int NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `cache_locks`
--

CREATE TABLE `cache_locks` (
  `key` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `owner` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `expiration` int NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `customers`
--

CREATE TABLE `customers` (
  `id` bigint UNSIGNED NOT NULL,
  `company_name` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `contact_name` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `email` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `phone` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `address` text COLLATE utf8mb4_unicode_ci,
  `city` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `zipcode` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `customers`
--

INSERT INTO `customers` (`id`, `company_name`, `contact_name`, `email`, `phone`, `address`, `city`, `zipcode`, `created_at`, `updated_at`) VALUES
(4, 'PT. SUKSES JAYA SENTOSA', 'Jaya', 'Jaya@inventaris.com', '123456789', 'Jl. Raya Poncol RT.03/007, Kel. Ciracas, Kec. Ciracas, Jakarta Timur, DKI Jakarta', 'Jakarta Timur', '13740', '2025-10-31 06:33:01', '2025-10-31 06:33:01');

-- --------------------------------------------------------

--
-- Table structure for table `kategori`
--

CREATE TABLE `kategori` (
  `id` bigint UNSIGNED NOT NULL,
  `nama` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `kode` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `deskripsi` text COLLATE utf8mb4_unicode_ci,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  `deleted_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `kategori`
--

INSERT INTO `kategori` (`id`, `nama`, `kode`, `deskripsi`, `created_at`, `updated_at`, `deleted_at`) VALUES
(5, 'Elektronik', 'CAT-ELEKT-5593', 'Laptop,Handphone,Komputer', '2025-10-28 04:21:06', '2025-10-28 04:21:06', NULL);

-- --------------------------------------------------------

--
-- Table structure for table `migrations`
--

CREATE TABLE `migrations` (
  `id` int UNSIGNED NOT NULL,
  `migration` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `batch` int NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `migrations`
--

INSERT INTO `migrations` (`id`, `migration`, `batch`) VALUES
(1, '0001_01_01_000000_create_users_table', 1),
(2, '2024_10_27_000002_create_kategori_table', 1),
(3, '2024_10_27_000003_create_supplier_table', 1),
(4, '2024_10_27_000004_create_barang_table', 1),
(5, '2024_10_27_000005_create_purchase_orders_table', 1),
(6, '2024_10_27_000006_create_sales_orders_table', 1),
(7, '2024_10_27_000007_create_notifications_table', 1),
(8, '2024_10_27_000008_create_activity_logs_table', 1),
(9, '2025_10_27_115300_create_personal_access_tokens_table', 1),
(10, '2025_10_27_163604_create_suppliers_table', 1),
(11, '2025_10_28_085813_add_approval_columns_to_purchase_orders_table', 1),
(12, '2025_10_28_085922_update_purchase_order_items_columns', 1),
(13, '2025_10_28_091901_fix_purchase_orders_supplier_foreign_key', 1),
(15, '2025_10_28_141407_create_audit_logs_table', 2),
(16, '2025_10_29_133755_create_cache_table', 3),
(17, '2024_10_30_000001_add_process_columns_to_sales_orders', 4),
(18, '2024_10_30_000002_add_completed_at_to_purchase_orders', 4),
(19, '2024_10_30_000003_add_receive_columns_to_purchase_orders', 5),
(20, '2025_10_31_104812_create_non_po_receipts_table', 6),
(21, '2025_10_31_104821_create_non_po_issues_table', 6),
(22, '2025_10_31_131402_create_customers_table', 7),
(23, '2024_11_01_000001_add_no_surat_jalan_to_sales_orders', 8),
(25, '2025_11_05_055341_add_approval_columns_to_non_po_tables', 9),
(26, '2025_11_06_085905_add_financial_columns_to_non_po_issues_table', 10),
(27, '2025_11_11_043927_add_no_surat_jalan_to_non_po_receipts_table', 11);

-- --------------------------------------------------------

--
-- Table structure for table `non_po_issues`
--

CREATE TABLE `non_po_issues` (
  `id` bigint UNSIGNED NOT NULL,
  `no_dokumen` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `recipient` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `issue_date` date NOT NULL,
  `notes` text COLLATE utf8mb4_unicode_ci,
  `subtotal` decimal(15,2) NOT NULL DEFAULT '0.00',
  `ppn` decimal(15,2) NOT NULL DEFAULT '0.00',
  `total` decimal(15,2) NOT NULL DEFAULT '0.00',
  `created_by` bigint UNSIGNED NOT NULL,
  `status` enum('pending','approved','rejected','completed') COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'pending',
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  `deleted_at` timestamp NULL DEFAULT NULL,
  `approved_by` bigint UNSIGNED DEFAULT NULL,
  `approved_at` timestamp NULL DEFAULT NULL,
  `reject_reason` text COLLATE utf8mb4_unicode_ci
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `non_po_issue_items`
--

CREATE TABLE `non_po_issue_items` (
  `id` bigint UNSIGNED NOT NULL,
  `non_po_issue_id` bigint UNSIGNED NOT NULL,
  `barang_id` bigint UNSIGNED NOT NULL,
  `qty` int NOT NULL,
  `harga_satuan` decimal(15,2) NOT NULL DEFAULT '0.00',
  `subtotal` decimal(15,2) NOT NULL DEFAULT '0.00',
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `non_po_receipts`
--

CREATE TABLE `non_po_receipts` (
  `id` bigint UNSIGNED NOT NULL,
  `no_dokumen` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `source` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `receive_date` date NOT NULL,
  `no_surat_jalan` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `notes` text COLLATE utf8mb4_unicode_ci NOT NULL,
  `total_value` decimal(15,2) NOT NULL DEFAULT '0.00',
  `created_by` bigint UNSIGNED NOT NULL,
  `status` enum('pending','approved','rejected','completed') COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'pending',
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  `deleted_at` timestamp NULL DEFAULT NULL,
  `approved_by` bigint UNSIGNED DEFAULT NULL,
  `approved_at` timestamp NULL DEFAULT NULL,
  `received_at` timestamp NULL DEFAULT NULL,
  `received_by` bigint UNSIGNED DEFAULT NULL,
  `reject_reason` text COLLATE utf8mb4_unicode_ci
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `non_po_receipts`
--

INSERT INTO `non_po_receipts` (`id`, `no_dokumen`, `source`, `receive_date`, `no_surat_jalan`, `notes`, `total_value`, `created_by`, `status`, `created_at`, `updated_at`, `deleted_at`, `approved_by`, `approved_at`, `received_at`, `received_by`, `reject_reason`) VALUES
(13, 'GR-NON-202511-00001', 'PT. JAYA SENTOSA', '2025-11-24', NULL, 'Return', 5100000.00, 2, 'approved', '2025-11-23 20:43:33', '2025-11-23 20:44:32', NULL, 1, '2025-11-23 20:44:32', NULL, NULL, NULL),
(14, 'GR-NON-202511-00002', 'PT. JAYA SENTOSA', '2025-11-24', NULL, 'Return', 500000.00, 2, 'pending', '2025-11-23 20:46:27', '2025-11-23 20:46:27', NULL, NULL, NULL, NULL, NULL, NULL);

-- --------------------------------------------------------

--
-- Table structure for table `non_po_receipt_items`
--

CREATE TABLE `non_po_receipt_items` (
  `id` bigint UNSIGNED NOT NULL,
  `non_po_receipt_id` bigint UNSIGNED NOT NULL,
  `barang_id` bigint UNSIGNED NOT NULL,
  `qty` int NOT NULL,
  `price` decimal(15,2) NOT NULL DEFAULT '0.00',
  `subtotal` decimal(15,2) NOT NULL DEFAULT '0.00',
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `non_po_receipt_items`
--

INSERT INTO `non_po_receipt_items` (`id`, `non_po_receipt_id`, `barang_id`, `qty`, `price`, `subtotal`, `created_at`, `updated_at`) VALUES
(2, 13, 1, 1, 5100000.00, 5100000.00, '2025-11-23 20:43:33', '2025-11-23 20:43:33'),
(3, 14, 1, 1, 500000.00, 500000.00, '2025-11-23 20:46:27', '2025-11-23 20:46:27');

-- --------------------------------------------------------

--
-- Table structure for table `notifications`
--

CREATE TABLE `notifications` (
  `id` bigint UNSIGNED NOT NULL,
  `user_id` bigint UNSIGNED DEFAULT NULL,
  `title` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `message` text COLLATE utf8mb4_unicode_ci NOT NULL,
  `type` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'info',
  `icon` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `is_read` tinyint(1) NOT NULL DEFAULT '0',
  `data` json DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  `deleted_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `password_reset_tokens`
--

CREATE TABLE `password_reset_tokens` (
  `email` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `token` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `personal_access_tokens`
--

CREATE TABLE `personal_access_tokens` (
  `id` bigint UNSIGNED NOT NULL,
  `tokenable_type` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `tokenable_id` bigint UNSIGNED NOT NULL,
  `name` text COLLATE utf8mb4_unicode_ci NOT NULL,
  `token` varchar(64) COLLATE utf8mb4_unicode_ci NOT NULL,
  `abilities` text COLLATE utf8mb4_unicode_ci,
  `last_used_at` timestamp NULL DEFAULT NULL,
  `expires_at` timestamp NULL DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `personal_access_tokens`
--

INSERT INTO `personal_access_tokens` (`id`, `tokenable_type`, `tokenable_id`, `name`, `token`, `abilities`, `last_used_at`, `expires_at`, `created_at`, `updated_at`) VALUES
(1, 'App\\Models\\User', 2, 'auth_token', '04752f1638f185cd6e745622839945078650699b5bcc7807dee2df5114afb836', '[\"*\"]', '2025-10-28 03:50:39', NULL, '2025-10-28 03:45:25', '2025-10-28 03:50:39'),
(4, 'App\\Models\\User', 2, 'auth_token', '8f96c68ac5a34daca1ef586e0f96abea2deb42e405948bf4b7e3699e2e9e9018', '[\"*\"]', '2025-10-28 04:19:59', NULL, '2025-10-28 04:19:51', '2025-10-28 04:19:59'),
(6, 'App\\Models\\User', 2, 'auth_token', 'fb834bc7aadc08571a5537119524980d0049dc97b4642303a10caed17adb52d2', '[\"*\"]', '2025-10-28 04:23:44', NULL, '2025-10-28 04:22:55', '2025-10-28 04:23:44'),
(12, 'App\\Models\\User', 2, 'auth_token', '97e6dadf06cb200fbee1a4b4c43ccbe6d7e7854eb490e4201ab7d652a5ba346e', '[\"*\"]', '2025-10-28 05:50:01', NULL, '2025-10-28 05:18:50', '2025-10-28 05:50:01'),
(18, 'App\\Models\\User', 2, 'auth_token', 'deff0062fa98ac81520cfaf03af4304fff4bf910f40b9f7d5646086e11f885d1', '[\"*\"]', '2025-10-28 06:38:03', NULL, '2025-10-28 06:21:09', '2025-10-28 06:38:03'),
(29, 'App\\Models\\User', 2, 'auth_token', '64fc8138028fae31d23b33995ddb2c4380abc4852eadce69e133204ec0289b0f', '[\"*\"]', '2025-10-29 03:48:58', NULL, '2025-10-29 03:28:56', '2025-10-29 03:48:58'),
(31, 'App\\Models\\User', 2, 'auth_token', 'a8f22f8c5a90155ea874b0556e0a209661e378343e6e453a602bfce02341f7b3', '[\"*\"]', '2025-10-29 03:51:29', NULL, '2025-10-29 03:50:23', '2025-10-29 03:51:29'),
(32, 'App\\Models\\User', 2, 'auth_token', '365f3bca187cf10d741d036561782b41c93bdce18ae92737c654efa1e92f3b12', '[\"*\"]', '2025-10-29 04:15:41', NULL, '2025-10-29 03:58:28', '2025-10-29 04:15:41'),
(34, 'App\\Models\\User', 2, 'auth_token', 'dff8f277c004b77d82877ef77158a545c95a3cf1be1428a91e01114d5314b149', '[\"*\"]', '2025-10-29 05:37:04', NULL, '2025-10-29 05:35:14', '2025-10-29 05:37:04'),
(35, 'App\\Models\\User', 1, 'auth_token', '67d3a7cd6dbed9bc6ebc99e12c5a6dda1c8551216a800e918bacbb208f4d213a', '[\"*\"]', '2025-10-29 05:37:28', NULL, '2025-10-29 05:37:08', '2025-10-29 05:37:28'),
(36, 'App\\Models\\User', 2, 'auth_token', '26eaf526413b1699f39a2d571bb2de63491ce7e002139a12632a9f91a221c6f1', '[\"*\"]', '2025-10-29 05:57:20', NULL, '2025-10-29 05:37:41', '2025-10-29 05:57:20'),
(37, 'App\\Models\\User', 1, 'auth_token', '3cdbbeb3f5f009f3c3726793abf953a15812c64b042739e3e11c37b750e5fb65', '[\"*\"]', '2025-10-29 06:00:10', NULL, '2025-10-29 05:57:47', '2025-10-29 06:00:10'),
(38, 'App\\Models\\User', 2, 'auth_token', '4a43c2f07442c00772f040662f712b9ce116c91d350d56391c2d6c4d08b14477', '[\"*\"]', '2025-10-29 06:37:55', NULL, '2025-10-29 06:00:18', '2025-10-29 06:37:55'),
(39, 'App\\Models\\User', 2, 'auth_token', 'aaa6f93e4bc4332c04c510beba0b475adb26af968bc46c8923f329d82ab8d4ff', '[\"*\"]', '2025-10-29 06:44:19', NULL, '2025-10-29 06:40:32', '2025-10-29 06:44:19'),
(41, 'App\\Models\\User', 2, 'auth_token', '1dc598a30af65bc76f2be50ce7d92ab02f828e24b332c47874b4036c7db37fe2', '[\"*\"]', '2025-10-29 22:02:52', NULL, '2025-10-29 21:59:20', '2025-10-29 22:02:52'),
(43, 'App\\Models\\User', 2, 'auth_token', 'a14c6b181c5eb0621bc7f99856aef2b74632209e7dbcd50b28cfaee4c5935b35', '[\"*\"]', '2025-10-29 22:15:32', NULL, '2025-10-29 22:05:37', '2025-10-29 22:15:32'),
(44, 'App\\Models\\User', 1, 'auth_token', '2a25b3d8a3336fbf4f221d192d9b2eee5aa5ded8169f62f38090e391b7db682a', '[\"*\"]', '2025-10-29 22:16:50', NULL, '2025-10-29 22:16:02', '2025-10-29 22:16:50'),
(45, 'App\\Models\\User', 2, 'auth_token', 'f2bf75f65276ddfc20bc47351081bee27843339b0249de8deaba589fe61ff954', '[\"*\"]', '2025-10-29 22:34:39', NULL, '2025-10-29 22:17:03', '2025-10-29 22:34:39'),
(49, 'App\\Models\\User', 2, 'auth_token', '0813b0e2ec8f8a75be85eda0083e567b6c1598a8120176e8bc88cc9f35efd892', '[\"*\"]', '2025-10-29 23:15:20', NULL, '2025-10-29 23:02:34', '2025-10-29 23:15:20'),
(51, 'App\\Models\\User', 2, 'auth_token', '071505f9d9edd7cf8c83c54f8b792343e3b2b6a43e302204783fa0bd676cfe33', '[\"*\"]', '2025-10-29 23:37:23', NULL, '2025-10-29 23:36:59', '2025-10-29 23:37:23'),
(53, 'App\\Models\\User', 2, 'auth_token', '8f0426a02633dff02a4e049c8d0e11e69cdf159ea7a499681dfef0d33664ef85', '[\"*\"]', '2025-10-30 00:23:03', NULL, '2025-10-30 00:20:37', '2025-10-30 00:23:03'),
(55, 'App\\Models\\User', 2, 'auth_token', '4c318c56c2fcf5a7f7a48d8f5f33f042a2a4135ac72a0a00297529ed31e99eb3', '[\"*\"]', '2025-10-30 00:24:50', NULL, '2025-10-30 00:24:16', '2025-10-30 00:24:50'),
(59, 'App\\Models\\User', 2, 'auth_token', 'b3fe2623c97919bc76fed2bde84142e43da747391e3c9aa5efa96ec9db51dd5d', '[\"*\"]', '2025-10-30 04:43:34', NULL, '2025-10-30 04:43:05', '2025-10-30 04:43:34'),
(67, 'App\\Models\\User', 2, 'auth_token', '850284290e5a5e7fa3d87bc3e6278afa180e4a8a616729e0c5dc6c15a8744e53', '[\"*\"]', '2025-10-30 06:05:50', NULL, '2025-10-30 06:05:21', '2025-10-30 06:05:50'),
(69, 'App\\Models\\User', 2, 'auth_token', 'ce498a49577c5d469763e709180d24b3c3e81df8c5eebdc40c03ccba88597933', '[\"*\"]', '2025-10-30 06:10:44', NULL, '2025-10-30 06:10:34', '2025-10-30 06:10:44'),
(71, 'App\\Models\\User', 2, 'auth_token', '738e9609fa4e95865d7e61184fcae22450a248544a79589dc7b9f14604c08253', '[\"*\"]', '2025-10-30 07:59:25', NULL, '2025-10-30 07:58:59', '2025-10-30 07:59:25'),
(73, 'App\\Models\\User', 2, 'auth_token', '77368c6c718acdb43723b339ae88bd22192732fc437eb8999eff8fec8b4a4dc6', '[\"*\"]', '2025-10-30 09:02:58', NULL, '2025-10-30 09:02:19', '2025-10-30 09:02:58'),
(74, 'App\\Models\\User', 1, 'auth_token', '13d362634ca3e3263ec01ca4a98c3db85ade37cd3b67d53684f567d491153409', '[\"*\"]', '2025-10-30 09:09:23', NULL, '2025-10-30 09:03:06', '2025-10-30 09:09:23'),
(75, 'App\\Models\\User', 2, 'auth_token', 'e8c172ac40d2bc95231ae0f12c7ae048a69abe944259f7c6179185358cd0ac50', '[\"*\"]', '2025-10-30 09:10:26', NULL, '2025-10-30 09:09:43', '2025-10-30 09:10:26'),
(77, 'App\\Models\\User', 2, 'auth_token', '69c0d302ef2a1f99ccea09fb510a562bba2b00f7c709bdafd5e8243a0e70b715', '[\"*\"]', '2025-10-30 09:18:46', NULL, '2025-10-30 09:18:05', '2025-10-30 09:18:46'),
(78, 'App\\Models\\User', 1, 'auth_token', 'ad45dd2449f232669187a0395ef74b535511373b9b0788e9e472a6be67e08272', '[\"*\"]', '2025-10-30 09:20:25', NULL, '2025-10-30 09:18:57', '2025-10-30 09:20:25'),
(79, 'App\\Models\\User', 2, 'auth_token', '4bb153c9a6e7cac9367a6b18868edb1bcbc30ce91bb201e5e9aa70a55cae57b6', '[\"*\"]', '2025-10-30 09:25:46', NULL, '2025-10-30 09:21:08', '2025-10-30 09:25:46'),
(81, 'App\\Models\\User', 2, 'auth_token', '326fbec391345d36dbf9c9bc08188b7298f7ad45867c17819d0ca4da96d5a7fb', '[\"*\"]', '2025-10-30 09:36:39', NULL, '2025-10-30 09:36:22', '2025-10-30 09:36:39'),
(83, 'App\\Models\\User', 2, 'auth_token', '9a9eee5a79fa060f732883c768bc52c4e7bb0aba5d8336fdebdf13173501cdbc', '[\"*\"]', '2025-10-30 22:58:19', NULL, '2025-10-30 22:50:49', '2025-10-30 22:58:19'),
(84, 'App\\Models\\User', 1, 'auth_token', 'bc8e85dbb25ec7ccecf6f5385619673948303356219044f25b1af821f60367cb', '[\"*\"]', '2025-10-31 05:27:35', NULL, '2025-10-30 22:58:34', '2025-10-31 05:27:35'),
(85, 'App\\Models\\User', 2, 'auth_token', '8c34f34263723fbdc0b9de8d92e62a6edfba2fcc76e21228e9565552f9a69288', '[\"*\"]', '2025-10-31 05:27:57', NULL, '2025-10-31 05:27:41', '2025-10-31 05:27:57'),
(88, 'App\\Models\\User', 1, 'auth_token', '7fd4cf9acc3501fb053dcf7e545a67590373142b8ab19da3771cffeae48e0dd0', '[\"*\"]', '2025-10-31 05:55:19', NULL, '2025-10-31 05:55:02', '2025-10-31 05:55:19'),
(89, 'App\\Models\\User', 2, 'auth_token', '9363233827000989246c66d736f3a53665c7e6d7229fdc6eaf7fbb2ddd5d56ba', '[\"*\"]', '2025-10-31 05:56:09', NULL, '2025-10-31 05:55:57', '2025-10-31 05:56:09'),
(91, 'App\\Models\\User', 2, 'auth_token', '7b93be9aeca8ee5cc5ad26b02252d635ee011b2ef41aea2a967ffae32279e6ca', '[\"*\"]', '2025-10-31 05:58:44', NULL, '2025-10-31 05:58:40', '2025-10-31 05:58:44'),
(93, 'App\\Models\\User', 1, 'auth_token', '32e13be8561f2b9420932e5d14f8ca63646c1a898a30da7a0e0a35202d26e883', '[\"*\"]', '2025-10-31 06:06:05', NULL, '2025-10-31 06:06:04', '2025-10-31 06:06:05'),
(95, 'App\\Models\\User', 2, 'auth_token', '73b49ec4e6fc2bda68b7083413cb4c0c2f7b52c8f67350e7420e55f35712ffa4', '[\"*\"]', '2025-10-31 06:26:50', NULL, '2025-10-31 06:25:17', '2025-10-31 06:26:50'),
(99, 'App\\Models\\User', 2, 'auth_token', '6e5cb65e6449986e87cb7c0d421f0cdc72e9bd9bb8c037e171e0a42e9002e863', '[\"*\"]', '2025-10-31 06:55:03', NULL, '2025-10-31 06:54:06', '2025-10-31 06:55:03'),
(101, 'App\\Models\\User', 2, 'auth_token', 'e2a46e758ea4d64a72fe8df159b6c8729cac18528c7ec436dd86c3eb67e4562e', '[\"*\"]', '2025-10-31 07:07:53', NULL, '2025-10-31 07:06:09', '2025-10-31 07:07:53'),
(105, 'App\\Models\\User', 2, 'auth_token', 'e771a86f8c5671add74286391c811c94a365360683cacb228e38ad1d87980abb', '[\"*\"]', '2025-10-31 08:05:10', NULL, '2025-10-31 08:04:52', '2025-10-31 08:05:10'),
(106, 'App\\Models\\User', 2, 'auth_token', '7f9cc5a86ba4075ed6a25fb284a69e731ea4561eac0424fce862fe1002bbba88', '[\"*\"]', '2025-10-31 08:07:10', NULL, '2025-10-31 08:05:34', '2025-10-31 08:07:10'),
(108, 'App\\Models\\User', 2, 'auth_token', 'd3bbe8545c94b289dcd28fd4540cac7602a31221d72ec2656f13f1a9d70aab8b', '[\"*\"]', '2025-10-31 08:21:52', NULL, '2025-10-31 08:17:20', '2025-10-31 08:21:52'),
(109, 'App\\Models\\User', 2, 'auth_token', 'e799ec206849b7644ae9a91c7f5285e05f4893cd54dd976e3004e45eb1bff07a', '[\"*\"]', '2025-10-31 10:38:37', NULL, '2025-10-31 08:22:06', '2025-10-31 10:38:37'),
(113, 'App\\Models\\User', 2, 'auth_token', '5de323bf1f9567a172324b4b428316aeb1ad9355768d17891f2cdaa21c2a0b60', '[\"*\"]', '2025-10-31 21:37:24', NULL, '2025-10-31 21:36:37', '2025-10-31 21:37:24'),
(115, 'App\\Models\\User', 2, 'auth_token', 'b28ba06e75a00b95c502c86c97feaa0a5125a8c5fc095bd97029af50b84ab1e9', '[\"*\"]', '2025-10-31 21:39:12', NULL, '2025-10-31 21:38:29', '2025-10-31 21:39:12'),
(116, 'App\\Models\\User', 1, 'auth_token', '1e922d4928a93ad3568cee18e079c747b6c0698a5e2a021529b211862f4f81fa', '[\"*\"]', '2025-10-31 21:48:36', NULL, '2025-10-31 21:39:18', '2025-10-31 21:48:36'),
(117, 'App\\Models\\User', 2, 'auth_token', '74f06ebd19aba8ed2c8c7e389632a00ebb1df008fcbc7e73c7ba2414dddecdc0', '[\"*\"]', '2025-10-31 21:49:12', NULL, '2025-10-31 21:48:46', '2025-10-31 21:49:12'),
(118, 'App\\Models\\User', 1, 'auth_token', '44a55064371b2bd1aa2f2368d43b21c5cfae96179dfae01e8b58a1f0e2e17231', '[\"*\"]', '2025-10-31 22:15:41', NULL, '2025-10-31 21:49:25', '2025-10-31 22:15:41'),
(119, 'App\\Models\\User', 2, 'auth_token', '1502e85e05acbace29b58246cf04ce88431e9ed269e753d544f46c493f585e04', '[\"*\"]', '2025-10-31 22:16:52', NULL, '2025-10-31 22:16:38', '2025-10-31 22:16:52'),
(122, 'App\\Models\\User', 1, 'auth_token', 'a201c5746151ecb2ba1444e0861a5f2a014463c7b8687d68ed258a1992edda18', '[\"*\"]', '2025-11-01 00:50:52', NULL, '2025-10-31 23:49:29', '2025-11-01 00:50:52'),
(123, 'App\\Models\\User', 2, 'auth_token', '529a1573018fce146ea1e9a130327de40d7397eb4e2a8e90077362f61ed2f4b3', '[\"*\"]', '2025-11-01 01:07:39', NULL, '2025-11-01 00:51:13', '2025-11-01 01:07:39'),
(125, 'App\\Models\\User', 2, 'auth_token', '5eca754b032106a38c39333810e59044478cf07895cc63ce59070385217b596f', '[\"*\"]', '2025-11-01 02:09:17', NULL, '2025-11-01 01:08:39', '2025-11-01 02:09:17'),
(127, 'App\\Models\\User', 2, 'auth_token', 'bb44cbc4dc15e75772abfc28b13989088570bf1f13bf59e2351be20ec8dfcd9d', '[\"*\"]', '2025-11-01 05:19:59', NULL, '2025-11-01 04:37:56', '2025-11-01 05:19:59'),
(134, 'App\\Models\\User', 2, 'auth_token', '4822a76c4100acb313127209f0a2afc6c2f93fa7de67f49940e5af50a08f4d5d', '[\"*\"]', '2025-11-04 23:02:55', NULL, '2025-11-04 23:01:33', '2025-11-04 23:02:55'),
(136, 'App\\Models\\User', 2, 'auth_token', '119434bf3575ff675b4beeb52e9bedaad12c56c315b04cc906bdba1641134d26', '[\"*\"]', '2025-11-04 23:08:37', NULL, '2025-11-04 23:08:34', '2025-11-04 23:08:37'),
(138, 'App\\Models\\User', 2, 'auth_token', 'b5ce8a9498f44322b088f63b6c97503e96b6cdd8b7a820191c2ce6fbe89463ad', '[\"*\"]', '2025-11-04 23:20:24', NULL, '2025-11-04 23:18:20', '2025-11-04 23:20:24'),
(140, 'App\\Models\\User', 2, 'auth_token', '0aee16a572d31402539e59c8dc41a32f559a4d0027bb0e02f96430e0a9559b29', '[\"*\"]', '2025-11-04 23:30:06', NULL, '2025-11-04 23:27:18', '2025-11-04 23:30:06'),
(142, 'App\\Models\\User', 2, 'auth_token', '52bc856526d2eb00d6a145127d3b8b1685a228086845b52d89d3aa5507867aed', '[\"*\"]', '2025-11-05 00:26:50', NULL, '2025-11-05 00:10:45', '2025-11-05 00:26:50'),
(143, 'App\\Models\\User', 2, 'auth_token', '6706fd48bc713ec01afac1e7038c95ba58cd0253cd1ae978cde63d4a224d18c2', '[\"*\"]', '2025-11-05 00:42:30', NULL, '2025-11-05 00:27:22', '2025-11-05 00:42:30'),
(144, 'App\\Models\\User', 2, 'auth_token', '511d0588c0d868748d35ced41d86b6f0b54c5a2823a3d9b06cecefa6d92d405c', '[\"*\"]', '2025-11-06 01:21:03', NULL, '2025-11-05 00:42:36', '2025-11-06 01:21:03'),
(146, 'App\\Models\\User', 2, 'auth_token', '874ee04abc6874391b6c8533c716bac6356ab2bbf32132f7c7b4bb0e34f915a1', '[\"*\"]', '2025-11-06 02:38:27', NULL, '2025-11-06 01:28:02', '2025-11-06 02:38:27'),
(148, 'App\\Models\\User', 2, 'auth_token', '53fa1765ca93599460d46281adcc53efd1d084290076693002b6d331e90647d2', '[\"*\"]', '2025-11-06 03:15:09', NULL, '2025-11-06 03:14:23', '2025-11-06 03:15:09'),
(150, 'App\\Models\\User', 2, 'auth_token', 'd6b482925605e8dbe1c018a6d12549e5fa30a69b58f2b4a39236305ab2ef1c52', '[\"*\"]', '2025-11-08 21:30:29', NULL, '2025-11-06 04:38:44', '2025-11-08 21:30:29'),
(152, 'App\\Models\\User', 2, 'auth_token', '775cc15b513cac04b1a01f63fcf1764af2e69b82bcdffc7316c8ed697bd7d993', '[\"*\"]', '2025-11-08 21:34:28', NULL, '2025-11-08 21:33:20', '2025-11-08 21:34:28'),
(153, 'App\\Models\\User', 1, 'auth_token', 'f6f5dc03b40f64410982dce3a99edcba4b363b9320668de43d7cd064f9867375', '[\"*\"]', '2025-11-08 21:42:26', NULL, '2025-11-08 21:34:58', '2025-11-08 21:42:26'),
(154, 'App\\Models\\User', 1, 'auth_token', 'a6088ca5c77e209f67c9d38d4346669fcf4e642fd82222830116fd8163db7bc2', '[\"*\"]', '2025-11-09 04:09:36', NULL, '2025-11-09 04:06:12', '2025-11-09 04:09:36'),
(155, 'App\\Models\\User', 2, 'auth_token', '7b7da8002a58f8386ccbeb1645434719214c036cf6f24e7a3ca33bba2d906196', '[\"*\"]', '2025-11-09 04:11:17', NULL, '2025-11-09 04:09:45', '2025-11-09 04:11:17'),
(156, 'App\\Models\\User', 1, 'auth_token', '4e132bd75427a651960b3bfb09c5223bb913a95d44e394a23e98e7648e1d5629', '[\"*\"]', '2025-11-09 04:19:52', NULL, '2025-11-09 04:11:26', '2025-11-09 04:19:52'),
(157, 'App\\Models\\User', 2, 'auth_token', 'b8b5afc17b19c1e3a61f0816e428683f4ed392aaf3ab572a343442fa07676b5f', '[\"*\"]', '2025-11-09 04:21:45', NULL, '2025-11-09 04:20:01', '2025-11-09 04:21:45'),
(158, 'App\\Models\\User', 1, 'auth_token', 'bfa15fe4057d22411ed332f7b27cb3314d09784885e1d027729519fa7f1113f4', '[\"*\"]', '2025-11-09 04:23:13', NULL, '2025-11-09 04:22:04', '2025-11-09 04:23:13'),
(159, 'App\\Models\\User', 2, 'auth_token', '4354e65e97a67cc3eab5072dc70e80cfa6079b2318d3718cdd04b4b04b71efd8', '[\"*\"]', '2025-11-09 05:33:43', NULL, '2025-11-09 04:23:45', '2025-11-09 05:33:43'),
(161, 'App\\Models\\User', 2, 'auth_token', '5ed7e6b21d3d9539d03382708f8bf22556f52296851e8176618bff5a21fc14ee', '[\"*\"]', '2025-11-09 05:38:10', NULL, '2025-11-09 05:37:08', '2025-11-09 05:38:10'),
(163, 'App\\Models\\User', 2, 'auth_token', 'a8da1b2d4949e9be80403bce2d583802a88e3ac6902c1829188a4fc8702a1af2', '[\"*\"]', NULL, NULL, '2025-11-09 05:42:21', '2025-11-09 05:42:21'),
(164, 'App\\Models\\User', 2, 'auth_token', '2905e41ca70ecdb49c90a7f18c6a406f430825b914779e47660ea92a721edd6a', '[\"*\"]', '2025-11-09 05:43:41', NULL, '2025-11-09 05:42:47', '2025-11-09 05:43:41'),
(166, 'App\\Models\\User', 2, 'auth_token', '017c0ad377da2797e8dbe0975ad17abebf2ffaef6d98c46cffe8a2e9dbd1c57e', '[\"*\"]', '2025-11-10 21:55:58', NULL, '2025-11-10 21:54:29', '2025-11-10 21:55:58'),
(172, 'App\\Models\\User', 1, 'auth_token', '955c19faab90dc1b33720462af26ed262e54c48a545831c9151f10eb3296a9b2', '[\"*\"]', '2025-11-10 23:06:05', NULL, '2025-11-10 22:45:32', '2025-11-10 23:06:05'),
(174, 'App\\Models\\User', 1, 'auth_token', 'e14860af0d68157fa4cf47b66a9a500d77fcbbeb32aff823d5f7958df767b3e7', '[\"*\"]', '2025-11-12 23:34:01', NULL, '2025-11-10 23:11:47', '2025-11-12 23:34:01'),
(175, 'App\\Models\\User', 2, 'auth_token', '37b9753d40e72b8f9edd0b44d5d2aeb8f3ad1dcc44caf487982b2436cfb952a7', '[\"*\"]', '2025-11-13 00:38:15', NULL, '2025-11-12 23:34:17', '2025-11-13 00:38:15'),
(176, 'App\\Models\\User', 1, 'auth_token', '3b159d29f33469e1ad7f56bb876cb7809c9584d48b2f7e1f77ae932f85557e4b', '[\"*\"]', '2025-11-13 01:02:03', NULL, '2025-11-13 00:38:22', '2025-11-13 01:02:03'),
(177, 'App\\Models\\User', 2, 'auth_token', '246b720a62f5eae15aeffa857d172d747b94832eef0e17ff116c01b068cc6a08', '[\"*\"]', '2025-11-17 22:59:18', NULL, '2025-11-13 01:02:09', '2025-11-17 22:59:18'),
(178, 'App\\Models\\User', 1, 'auth_token', '2ab5719086e456bedec5224865465e51e9fad90a33a2594b63a6c5637b35de0c', '[\"*\"]', '2025-11-17 23:41:54', NULL, '2025-11-17 22:59:54', '2025-11-17 23:41:54'),
(179, 'App\\Models\\User', 2, 'auth_token', '4ad5cf5eedc7b6fc59510bcccb78104ef0ed737008822602b16023519834c0e7', '[\"*\"]', '2025-11-17 23:42:05', NULL, '2025-11-17 23:42:02', '2025-11-17 23:42:05'),
(180, 'App\\Models\\User', 1, 'auth_token', '9b4e0981ef5ced4d8421ed66346f799220c227915a808c6fb39cf637ce6c00a0', '[\"*\"]', '2025-11-18 02:50:07', NULL, '2025-11-17 23:42:17', '2025-11-18 02:50:07'),
(181, 'App\\Models\\User', 2, 'auth_token', '65c74d22a8824d251b9617e379c2c292d920bcbcb3cb1ded4ab5d8df7aefdcc8', '[\"*\"]', '2025-11-18 04:02:36', NULL, '2025-11-18 02:50:21', '2025-11-18 04:02:36'),
(182, 'App\\Models\\User', 1, 'auth_token', 'dded32b361cd4ea9a0782766bb85e23c19807dbb67c6a49ebf962749c54e7a8a', '[\"*\"]', '2025-11-18 04:02:50', NULL, '2025-11-18 04:02:43', '2025-11-18 04:02:50'),
(183, 'App\\Models\\User', 2, 'auth_token', 'e4a87b1317f8fbf12b2d965c3e11beeaa96106a7ab7fa292403c5c7bc6abf37c', '[\"*\"]', '2025-11-19 22:44:54', NULL, '2025-11-18 04:03:28', '2025-11-19 22:44:54'),
(184, 'App\\Models\\User', 1, 'auth_token', '2b568b17c269fbbad19e125580c2cb9d5b6e00da5f2c494c992c9895c8bfabb7', '[\"*\"]', '2025-11-22 05:33:44', NULL, '2025-11-19 22:44:53', '2025-11-22 05:33:44'),
(185, 'App\\Models\\User', 2, 'auth_token', '0011d23a7471b3165e2d7448f4104d234ef935059954d86a2b22cfc55ff94802', '[\"*\"]', '2025-11-22 05:33:57', NULL, '2025-11-22 05:33:51', '2025-11-22 05:33:57'),
(186, 'App\\Models\\User', 1, 'auth_token', 'e0d77dcd0ae0e397f52ba8971e628b68dbc56d1f6ae1a048e9ff87ed99d080e2', '[\"*\"]', '2025-11-23 19:53:07', NULL, '2025-11-22 05:34:29', '2025-11-23 19:53:07'),
(187, 'App\\Models\\User', 2, 'auth_token', '18060d8799242fa83345cdef12f1a3d896c8a7fb9c29b6b2c037de32c87d8562', '[\"*\"]', '2025-11-23 19:57:09', NULL, '2025-11-23 19:53:23', '2025-11-23 19:57:09'),
(188, 'App\\Models\\User', 1, 'auth_token', 'e661a3ea95df5eaf3e65ff9741c6f2d21fa14469d9152ab9d32f0671b3405982', '[\"*\"]', '2025-11-23 19:57:39', NULL, '2025-11-23 19:57:23', '2025-11-23 19:57:39'),
(189, 'App\\Models\\User', 2, 'auth_token', '5b985b0e32537bf25c53f1a52ffe0c3ece7b846147e8297ed48c1dfd634e113a', '[\"*\"]', '2025-11-23 20:18:19', NULL, '2025-11-23 19:57:51', '2025-11-23 20:18:19'),
(190, 'App\\Models\\User', 1, 'auth_token', '98499765e1f62d9e60ececd15e41f03f5b76abb19ac125e31d29d87a6b8fcc1c', '[\"*\"]', '2025-11-23 20:23:24', NULL, '2025-11-23 20:18:34', '2025-11-23 20:23:24'),
(191, 'App\\Models\\User', 2, 'auth_token', 'ed6bbe6c8f89d75122a852160c8c3205ece34e60af3cc78eb8efcbe479b3f6ac', '[\"*\"]', '2025-11-23 20:27:39', NULL, '2025-11-23 20:27:01', '2025-11-23 20:27:39'),
(192, 'App\\Models\\User', 1, 'auth_token', '952b7c0ae27920dc1ff547167598db21ee7dc008cda403f08b533f408d72a959', '[\"*\"]', '2025-11-23 20:37:11', NULL, '2025-11-23 20:27:53', '2025-11-23 20:37:11'),
(193, 'App\\Models\\User', 1, 'auth_token', 'ba61e1d18348148c5faab62cd625f6ee34d9b443861472008683a77fcb63093d', '[\"*\"]', '2025-11-23 20:37:48', NULL, '2025-11-23 20:37:35', '2025-11-23 20:37:48'),
(194, 'App\\Models\\User', 2, 'auth_token', '8bc8afb6e7507e7ea5cd892fac4f96bba112d47425e3cb06b3ea27c3a87fc81a', '[\"*\"]', '2025-11-23 20:44:03', NULL, '2025-11-23 20:42:42', '2025-11-23 20:44:03'),
(195, 'App\\Models\\User', 1, 'auth_token', '151a174073ac8f9a4952b4facf2e4f1658aefed3013bf96aa6aba6e52ac544d3', '[\"*\"]', '2025-11-23 20:45:29', NULL, '2025-11-23 20:44:21', '2025-11-23 20:45:29'),
(196, 'App\\Models\\User', 2, 'auth_token', 'd7073e668a9419a415726f3af8dcba8dcce53ba2cd9775e9e00a5df2cbada0d0', '[\"*\"]', '2025-11-23 22:05:10', NULL, '2025-11-23 20:45:42', '2025-11-23 22:05:10'),
(197, 'App\\Models\\User', 1, 'auth_token', '0d7f3f130850bc7dca3db8883e01f7faa0f134934b40988bbd5a95f465c2529a', '[\"*\"]', '2025-11-25 22:44:31', NULL, '2025-11-25 21:28:44', '2025-11-25 22:44:31'),
(198, 'App\\Models\\User', 1, 'auth_token', '030ad86cbc11661069a3bd6b760790d153eaa99b64b18cfa29a5d10ea70dfe9b', '[\"*\"]', '2025-11-25 22:44:56', NULL, '2025-11-25 22:44:54', '2025-11-25 22:44:56'),
(199, 'App\\Models\\User', 2, 'auth_token', '838094c04be5a7994d50862a9d5fbe6bf648ba197768d228cf21aad11f52ceaa', '[\"*\"]', '2025-11-25 22:48:49', NULL, '2025-11-25 22:45:05', '2025-11-25 22:48:49'),
(200, 'App\\Models\\User', 1, 'auth_token', 'c0d02d926d90e0b2f8d0a1eaf10f640d14d3b68197397cde3ce98e63db1ad135', '[\"*\"]', '2025-11-25 23:19:35', NULL, '2025-11-25 22:48:57', '2025-11-25 23:19:35');

-- --------------------------------------------------------

--
-- Table structure for table `purchase_orders`
--

CREATE TABLE `purchase_orders` (
  `id` bigint UNSIGNED NOT NULL,
  `no_po` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `supplier_id` bigint UNSIGNED NOT NULL,
  `created_by` bigint UNSIGNED NOT NULL,
  `approved_by` bigint UNSIGNED DEFAULT NULL,
  `approved_at` timestamp NULL DEFAULT NULL,
  `completed_at` timestamp NULL DEFAULT NULL,
  `reject_reason` text COLLATE utf8mb4_unicode_ci,
  `tgl_pesan` date NOT NULL,
  `tgl_estimasi` date NOT NULL,
  `total` decimal(15,2) NOT NULL,
  `catatan` text COLLATE utf8mb4_unicode_ci,
  `no_surat_jalan` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `status` enum('pending','approved','rejected','completed') COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'pending',
  `subtotal` decimal(15,2) NOT NULL DEFAULT '0.00',
  `ppn` decimal(15,2) NOT NULL DEFAULT '0.00',
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  `deleted_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `purchase_orders`
--

INSERT INTO `purchase_orders` (`id`, `no_po`, `supplier_id`, `created_by`, `approved_by`, `approved_at`, `completed_at`, `reject_reason`, `tgl_pesan`, `tgl_estimasi`, `total`, `catatan`, `no_surat_jalan`, `status`, `subtotal`, `ppn`, `created_at`, `updated_at`, `deleted_at`) VALUES
(15, 'PO-202511-0001', 1, 2, 1, '2025-11-25 22:59:43', NULL, NULL, '2025-11-24', '2025-11-25', 5100000.00, NULL, NULL, 'approved', 5000000.00, 0.00, '2025-11-23 20:27:28', '2025-11-25 22:59:43', NULL);

-- --------------------------------------------------------

--
-- Table structure for table `purchase_order_items`
--

CREATE TABLE `purchase_order_items` (
  `id` bigint UNSIGNED NOT NULL,
  `purchase_order_id` bigint UNSIGNED NOT NULL,
  `barang_id` bigint UNSIGNED NOT NULL,
  `qty` int NOT NULL,
  `qty_received` int DEFAULT NULL,
  `harga_satuan` decimal(15,2) NOT NULL,
  `subtotal` decimal(15,2) NOT NULL,
  `catatan` text COLLATE utf8mb4_unicode_ci,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `purchase_order_items`
--

INSERT INTO `purchase_order_items` (`id`, `purchase_order_id`, `barang_id`, `qty`, `qty_received`, `harga_satuan`, `subtotal`, `catatan`, `created_at`, `updated_at`) VALUES
(1, 15, 1, 1, NULL, 5000000.00, 5000000.00, NULL, '2025-11-23 20:27:28', '2025-11-23 20:27:28');

-- --------------------------------------------------------

--
-- Table structure for table `sales_orders`
--

CREATE TABLE `sales_orders` (
  `id` bigint UNSIGNED NOT NULL,
  `no_so` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `customer_name` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `customer_phone` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `customer_address` text COLLATE utf8mb4_unicode_ci,
  `tgl_order` date NOT NULL,
  `tgl_kirim` date NOT NULL,
  `catatan` text COLLATE utf8mb4_unicode_ci,
  `status` enum('pending','approved','rejected','completed') COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'pending',
  `subtotal` decimal(15,2) NOT NULL DEFAULT '0.00',
  `ppn` decimal(15,2) NOT NULL DEFAULT '0.00',
  `total` decimal(15,2) NOT NULL DEFAULT '0.00',
  `created_by` bigint UNSIGNED NOT NULL,
  `approved_by` bigint UNSIGNED DEFAULT NULL,
  `approved_at` timestamp NULL DEFAULT NULL,
  `completed_at` timestamp NULL DEFAULT NULL,
  `no_surat_jalan` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `reject_reason` text COLLATE utf8mb4_unicode_ci,
  `catatan_pengeluaran` text COLLATE utf8mb4_unicode_ci,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `sales_order_items`
--

CREATE TABLE `sales_order_items` (
  `id` bigint UNSIGNED NOT NULL,
  `sales_order_id` bigint UNSIGNED NOT NULL,
  `barang_id` bigint UNSIGNED NOT NULL,
  `qty` int NOT NULL,
  `qty_issued` int DEFAULT NULL,
  `harga_satuan` decimal(15,2) NOT NULL,
  `subtotal` decimal(15,2) NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `sessions`
--

CREATE TABLE `sessions` (
  `id` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `user_id` bigint UNSIGNED DEFAULT NULL,
  `ip_address` varchar(45) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `user_agent` text COLLATE utf8mb4_unicode_ci,
  `payload` longtext COLLATE utf8mb4_unicode_ci NOT NULL,
  `last_activity` int NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `suppliers`
--

CREATE TABLE `suppliers` (
  `id` bigint UNSIGNED NOT NULL,
  `nama` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `kontak_person` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `telepon` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `email` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `alamat` text COLLATE utf8mb4_unicode_ci,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `suppliers`
--

INSERT INTO `suppliers` (`id`, `nama`, `kontak_person`, `telepon`, `email`, `alamat`, `created_at`, `updated_at`) VALUES
(1, 'PT. MUSTIKA KOMPUTER', 'Ahmad Nur Hafidz', '085157877443', 'mscomm@inventaris.com', 'Jl. Raya Poncol RT.03/007, Kel. Ciracas, Kec. Ciracas, Jakarta Timur, DKI Jakarta, 13740', '2025-10-28 04:22:34', '2025-10-28 07:40:11');

-- --------------------------------------------------------

--
-- Table structure for table `users`
--

CREATE TABLE `users` (
  `id` bigint UNSIGNED NOT NULL,
  `name` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `username` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `email` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `email_verified_at` timestamp NULL DEFAULT NULL,
  `password` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `role` enum('admin','staff') COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'staff',
  `phone` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `address` text COLLATE utf8mb4_unicode_ci,
  `remember_token` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  `deleted_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `users`
--

INSERT INTO `users` (`id`, `name`, `username`, `email`, `email_verified_at`, `password`, `role`, `phone`, `address`, `remember_token`, `created_at`, `updated_at`, `deleted_at`) VALUES
(1, 'Administrator', 'admin', 'admin@example.com', NULL, '$2y$12$dOhwAM0FFUYqvph6oGq3TOZL0Nm3J71IqCGr0jROLnEKpalYatf0.', 'admin', '081234567890', 'Jl. Admin No. 1', 'IiQy6ioKFum2BRtyPjdQntqRqyvj1c7FwJVK9tJiZGaOarp1kyNjXx2eNdLo', '2025-10-28 03:44:22', '2025-10-28 03:44:22', NULL),
(2, 'Staff', 'staff', 'staff@example.com', NULL, '$2y$12$zIrKqsf5irRR3tRxCrF96O0cvYUXmJS2EZOTpVwNwfAX8tuxLcSG.', 'staff', '081234567891', 'Jl. Staff No. 1', 'mLwScZKedWSjy1MslEyTNpEwxkp8VESiIZeXZKBGILoPAKDkiYlMte7PMEnQ', '2025-10-28 03:44:22', '2025-10-28 05:04:50', NULL);

--
-- Indexes for dumped tables
--

--
-- Indexes for table `audit_logs`
--
ALTER TABLE `audit_logs`
  ADD PRIMARY KEY (`id`),
  ADD KEY `audit_logs_user_id_created_at_index` (`user_id`,`created_at`),
  ADD KEY `audit_logs_action_created_at_index` (`action`,`created_at`),
  ADD KEY `audit_logs_entity_type_entity_id_index` (`entity_type`,`entity_id`);

--
-- Indexes for table `barang`
--
ALTER TABLE `barang`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `barang_kode_unique` (`kode`),
  ADD KEY `barang_kategori_id_foreign` (`kategori_id`);

--
-- Indexes for table `cache`
--
ALTER TABLE `cache`
  ADD PRIMARY KEY (`key`);

--
-- Indexes for table `cache_locks`
--
ALTER TABLE `cache_locks`
  ADD PRIMARY KEY (`key`);

--
-- Indexes for table `customers`
--
ALTER TABLE `customers`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `customers_email_unique` (`email`);

--
-- Indexes for table `kategori`
--
ALTER TABLE `kategori`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `kategori_kode_unique` (`kode`);

--
-- Indexes for table `migrations`
--
ALTER TABLE `migrations`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `non_po_issues`
--
ALTER TABLE `non_po_issues`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `non_po_issues_no_dokumen_unique` (`no_dokumen`),
  ADD KEY `non_po_issues_created_by_foreign` (`created_by`),
  ADD KEY `non_po_issues_approved_by_foreign` (`approved_by`);

--
-- Indexes for table `non_po_issue_items`
--
ALTER TABLE `non_po_issue_items`
  ADD PRIMARY KEY (`id`),
  ADD KEY `non_po_issue_items_non_po_issue_id_foreign` (`non_po_issue_id`),
  ADD KEY `non_po_issue_items_barang_id_foreign` (`barang_id`);

--
-- Indexes for table `non_po_receipts`
--
ALTER TABLE `non_po_receipts`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `non_po_receipts_no_dokumen_unique` (`no_dokumen`),
  ADD KEY `non_po_receipts_created_by_foreign` (`created_by`),
  ADD KEY `non_po_receipts_approved_by_foreign` (`approved_by`),
  ADD KEY `non_po_receipts_received_by_foreign` (`received_by`);

--
-- Indexes for table `non_po_receipt_items`
--
ALTER TABLE `non_po_receipt_items`
  ADD PRIMARY KEY (`id`),
  ADD KEY `non_po_receipt_items_non_po_receipt_id_foreign` (`non_po_receipt_id`),
  ADD KEY `non_po_receipt_items_barang_id_foreign` (`barang_id`);

--
-- Indexes for table `notifications`
--
ALTER TABLE `notifications`
  ADD PRIMARY KEY (`id`),
  ADD KEY `notifications_user_id_foreign` (`user_id`);

--
-- Indexes for table `password_reset_tokens`
--
ALTER TABLE `password_reset_tokens`
  ADD PRIMARY KEY (`email`);

--
-- Indexes for table `personal_access_tokens`
--
ALTER TABLE `personal_access_tokens`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `personal_access_tokens_token_unique` (`token`),
  ADD KEY `personal_access_tokens_tokenable_type_tokenable_id_index` (`tokenable_type`,`tokenable_id`),
  ADD KEY `personal_access_tokens_expires_at_index` (`expires_at`);

--
-- Indexes for table `purchase_orders`
--
ALTER TABLE `purchase_orders`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `purchase_orders_nomor_unique` (`no_po`),
  ADD KEY `purchase_orders_user_id_foreign` (`created_by`),
  ADD KEY `purchase_orders_approved_by_foreign` (`approved_by`),
  ADD KEY `purchase_orders_supplier_id_foreign` (`supplier_id`);

--
-- Indexes for table `purchase_order_items`
--
ALTER TABLE `purchase_order_items`
  ADD PRIMARY KEY (`id`),
  ADD KEY `purchase_order_items_purchase_order_id_foreign` (`purchase_order_id`),
  ADD KEY `purchase_order_items_barang_id_foreign` (`barang_id`);

--
-- Indexes for table `sales_orders`
--
ALTER TABLE `sales_orders`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `sales_orders_no_so_unique` (`no_so`),
  ADD KEY `sales_orders_created_by_foreign` (`created_by`),
  ADD KEY `sales_orders_approved_by_foreign` (`approved_by`);

--
-- Indexes for table `sales_order_items`
--
ALTER TABLE `sales_order_items`
  ADD PRIMARY KEY (`id`),
  ADD KEY `sales_order_items_sales_order_id_foreign` (`sales_order_id`),
  ADD KEY `sales_order_items_barang_id_foreign` (`barang_id`);

--
-- Indexes for table `sessions`
--
ALTER TABLE `sessions`
  ADD PRIMARY KEY (`id`),
  ADD KEY `sessions_user_id_index` (`user_id`),
  ADD KEY `sessions_last_activity_index` (`last_activity`);

--
-- Indexes for table `suppliers`
--
ALTER TABLE `suppliers`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `users`
--
ALTER TABLE `users`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `users_username_unique` (`username`),
  ADD UNIQUE KEY `users_email_unique` (`email`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `audit_logs`
--
ALTER TABLE `audit_logs`
  MODIFY `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=352;

--
-- AUTO_INCREMENT for table `barang`
--
ALTER TABLE `barang`
  MODIFY `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

--
-- AUTO_INCREMENT for table `customers`
--
ALTER TABLE `customers`
  MODIFY `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

--
-- AUTO_INCREMENT for table `kategori`
--
ALTER TABLE `kategori`
  MODIFY `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- AUTO_INCREMENT for table `migrations`
--
ALTER TABLE `migrations`
  MODIFY `id` int UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=28;

--
-- AUTO_INCREMENT for table `non_po_issues`
--
ALTER TABLE `non_po_issues`
  MODIFY `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=10;

--
-- AUTO_INCREMENT for table `non_po_issue_items`
--
ALTER TABLE `non_po_issue_items`
  MODIFY `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `non_po_receipts`
--
ALTER TABLE `non_po_receipts`
  MODIFY `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=15;

--
-- AUTO_INCREMENT for table `non_po_receipt_items`
--
ALTER TABLE `non_po_receipt_items`
  MODIFY `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT for table `notifications`
--
ALTER TABLE `notifications`
  MODIFY `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `personal_access_tokens`
--
ALTER TABLE `personal_access_tokens`
  MODIFY `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=201;

--
-- AUTO_INCREMENT for table `purchase_orders`
--
ALTER TABLE `purchase_orders`
  MODIFY `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=16;

--
-- AUTO_INCREMENT for table `purchase_order_items`
--
ALTER TABLE `purchase_order_items`
  MODIFY `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT for table `sales_orders`
--
ALTER TABLE `sales_orders`
  MODIFY `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT for table `sales_order_items`
--
ALTER TABLE `sales_order_items`
  MODIFY `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `suppliers`
--
ALTER TABLE `suppliers`
  MODIFY `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT for table `users`
--
ALTER TABLE `users`
  MODIFY `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `audit_logs`
--
ALTER TABLE `audit_logs`
  ADD CONSTRAINT `audit_logs_user_id_foreign` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE SET NULL;

--
-- Constraints for table `barang`
--
ALTER TABLE `barang`
  ADD CONSTRAINT `barang_kategori_id_foreign` FOREIGN KEY (`kategori_id`) REFERENCES `kategori` (`id`);

--
-- Constraints for table `non_po_issues`
--
ALTER TABLE `non_po_issues`
  ADD CONSTRAINT `non_po_issues_approved_by_foreign` FOREIGN KEY (`approved_by`) REFERENCES `users` (`id`),
  ADD CONSTRAINT `non_po_issues_created_by_foreign` FOREIGN KEY (`created_by`) REFERENCES `users` (`id`);

--
-- Constraints for table `non_po_issue_items`
--
ALTER TABLE `non_po_issue_items`
  ADD CONSTRAINT `non_po_issue_items_barang_id_foreign` FOREIGN KEY (`barang_id`) REFERENCES `barang` (`id`),
  ADD CONSTRAINT `non_po_issue_items_non_po_issue_id_foreign` FOREIGN KEY (`non_po_issue_id`) REFERENCES `non_po_issues` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `non_po_receipts`
--
ALTER TABLE `non_po_receipts`
  ADD CONSTRAINT `non_po_receipts_approved_by_foreign` FOREIGN KEY (`approved_by`) REFERENCES `users` (`id`),
  ADD CONSTRAINT `non_po_receipts_created_by_foreign` FOREIGN KEY (`created_by`) REFERENCES `users` (`id`),
  ADD CONSTRAINT `non_po_receipts_received_by_foreign` FOREIGN KEY (`received_by`) REFERENCES `users` (`id`) ON DELETE SET NULL;

--
-- Constraints for table `non_po_receipt_items`
--
ALTER TABLE `non_po_receipt_items`
  ADD CONSTRAINT `non_po_receipt_items_barang_id_foreign` FOREIGN KEY (`barang_id`) REFERENCES `barang` (`id`),
  ADD CONSTRAINT `non_po_receipt_items_non_po_receipt_id_foreign` FOREIGN KEY (`non_po_receipt_id`) REFERENCES `non_po_receipts` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `notifications`
--
ALTER TABLE `notifications`
  ADD CONSTRAINT `notifications_user_id_foreign` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`);

--
-- Constraints for table `purchase_orders`
--
ALTER TABLE `purchase_orders`
  ADD CONSTRAINT `purchase_orders_approved_by_foreign` FOREIGN KEY (`approved_by`) REFERENCES `users` (`id`),
  ADD CONSTRAINT `purchase_orders_supplier_id_foreign` FOREIGN KEY (`supplier_id`) REFERENCES `suppliers` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `purchase_orders_user_id_foreign` FOREIGN KEY (`created_by`) REFERENCES `users` (`id`);

--
-- Constraints for table `purchase_order_items`
--
ALTER TABLE `purchase_order_items`
  ADD CONSTRAINT `purchase_order_items_barang_id_foreign` FOREIGN KEY (`barang_id`) REFERENCES `barang` (`id`),
  ADD CONSTRAINT `purchase_order_items_purchase_order_id_foreign` FOREIGN KEY (`purchase_order_id`) REFERENCES `purchase_orders` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `sales_orders`
--
ALTER TABLE `sales_orders`
  ADD CONSTRAINT `sales_orders_approved_by_foreign` FOREIGN KEY (`approved_by`) REFERENCES `users` (`id`) ON DELETE SET NULL,
  ADD CONSTRAINT `sales_orders_created_by_foreign` FOREIGN KEY (`created_by`) REFERENCES `users` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `sales_order_items`
--
ALTER TABLE `sales_order_items`
  ADD CONSTRAINT `sales_order_items_barang_id_foreign` FOREIGN KEY (`barang_id`) REFERENCES `barang` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `sales_order_items_sales_order_id_foreign` FOREIGN KEY (`sales_order_id`) REFERENCES `sales_orders` (`id`) ON DELETE CASCADE;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
