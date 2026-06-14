-- 创建数据库
CREATE DATABASE IF NOT EXISTS ecommerce DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

USE ecommerce;

-- 用户表
CREATE TABLE IF NOT EXISTS `user` (
    `id` BIGINT AUTO_INCREMENT PRIMARY KEY COMMENT '用户ID',
    `username` VARCHAR(50) NOT NULL UNIQUE COMMENT '用户名',
    `password` VARCHAR(255) NOT NULL COMMENT '密码',
    `nickname` VARCHAR(50) COMMENT '昵称',
    `phone` VARCHAR(20) COMMENT '手机号',
    `email` VARCHAR(100) COMMENT '邮箱',
    `avatar` VARCHAR(500) COMMENT '头像',
    `status` TINYINT DEFAULT 1 COMMENT '状态 0:禁用 1:正常',
    `create_time` DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    `update_time` DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
    `deleted` TINYINT DEFAULT 0 COMMENT '删除标记 0:正常 1:删除',
    INDEX idx_username (`username`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='用户表';

-- 商品表
CREATE TABLE IF NOT EXISTS `product` (
    `id` BIGINT AUTO_INCREMENT PRIMARY KEY COMMENT '商品ID',
    `name` VARCHAR(200) NOT NULL COMMENT '商品名称',
    `description` TEXT COMMENT '商品描述',
    `price` DECIMAL(10,2) NOT NULL COMMENT '价格',
    `stock` INT DEFAULT 0 COMMENT '库存数量',
    `image_url` VARCHAR(500) COMMENT '商品图片',
    `status` TINYINT DEFAULT 1 COMMENT '状态 0:下架 1:上架',
    `category_id` BIGINT COMMENT '分类ID',
    `create_time` DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    `update_time` DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
    `deleted` TINYINT DEFAULT 0 COMMENT '删除标记 0:正常 1:删除',
    INDEX idx_category (`category_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='商品表';

-- 订单表
CREATE TABLE IF NOT EXISTS `order_info` (
    `id` BIGINT AUTO_INCREMENT PRIMARY KEY COMMENT '订单ID',
    `order_no` VARCHAR(50) NOT NULL UNIQUE COMMENT '订单号',
    `user_id` BIGINT NOT NULL COMMENT '用户ID',
    `total_amount` DECIMAL(10,2) NOT NULL COMMENT '订单总金额',
    `status` TINYINT DEFAULT 0 COMMENT '订单状态 0:待支付 1:已支付 2:已取消',
    `address` VARCHAR(500) COMMENT '收货地址',
    `receiver` VARCHAR(50) COMMENT '收货人',
    `phone` VARCHAR(20) COMMENT '联系电话',
    `create_time` DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    `update_time` DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
    `deleted` TINYINT DEFAULT 0 COMMENT '删除标记 0:正常 1:删除',
    INDEX idx_user_id (`user_id`),
    INDEX idx_order_no (`order_no`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='订单表';

-- 订单明细表
CREATE TABLE IF NOT EXISTS `order_item` (
    `id` BIGINT AUTO_INCREMENT PRIMARY KEY COMMENT '订单明细ID',
    `order_id` BIGINT NOT NULL COMMENT '订单ID',
    `product_id` BIGINT NOT NULL COMMENT '商品ID',
    `product_name` VARCHAR(200) NOT NULL COMMENT '商品名称',
    `price` DECIMAL(10,2) NOT NULL COMMENT '商品价格',
    `quantity` INT NOT NULL COMMENT '购买数量',
    `total_amount` DECIMAL(10,2) NOT NULL COMMENT '小计金额',
    `create_time` DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    `update_time` DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
    `deleted` TINYINT DEFAULT 0 COMMENT '删除标记 0:正常 1:删除',
    INDEX idx_order_id (`order_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='订单明细表';

-- 支付表
CREATE TABLE IF NOT EXISTS `payment` (
    `id` BIGINT AUTO_INCREMENT PRIMARY KEY COMMENT '支付ID',
    `payment_no` VARCHAR(50) NOT NULL UNIQUE COMMENT '支付单号',
    `order_id` BIGINT NOT NULL COMMENT '订单ID',
    `amount` DECIMAL(10,2) NOT NULL COMMENT '支付金额',
    `status` TINYINT DEFAULT 0 COMMENT '支付状态 0:待支付 1:已支付',
    `payment_method` VARCHAR(20) COMMENT '支付方式',
    `transaction_id` VARCHAR(100) COMMENT '第三方交易号',
    `create_time` DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    `update_time` DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
    `deleted` TINYINT DEFAULT 0 COMMENT '删除标记 0:正常 1:删除',
    INDEX idx_order_id (`order_id`),
    INDEX idx_payment_no (`payment_no`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='支付表';

-- 插入测试数据
INSERT INTO `user` (`username`, `password`, `nickname`, `phone`, `email`) VALUES
('admin', '$2a$10$N.zmdr9k7uOCQb376NoUnuTJ8iAt6Z5EHsM8lE9lBOsl7iAt6Z5EH', '管理员', '13800138000', 'admin@example.com'),
('test', '$2a$10$N.zmdr9k7uOCQb376NoUnuTJ8iAt6Z5EHsM8lE9lBOsl7iAt6Z5EH', '测试用户', '13800138001', 'test@example.com');

INSERT INTO `product` (`name`, `description`, `price`, `stock`, `status`, `category_id`) VALUES
('iPhone 15 Pro', '苹果最新款智能手机', 7999.00, 100, 1, 1),
('MacBook Pro', '苹果笔记本电脑', 12999.00, 50, 1, 2),
('AirPods Pro', '无线耳机', 1999.00, 200, 1, 3),
('iPad Air', '平板电脑', 4299.00, 80, 1, 4),
('Apple Watch', '智能手表', 2999.00, 150, 1, 5);
