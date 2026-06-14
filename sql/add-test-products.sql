USE ecommerce;

-- 更新现有商品的图片URL
UPDATE product SET image_url = 'https://picsum.photos/400/400?random=1' WHERE name = 'iPhone 15 Pro';
UPDATE product SET image_url = 'https://picsum.photos/400/400?random=2' WHERE name = 'MacBook Pro';
UPDATE product SET image_url = 'https://picsum.photos/400/400?random=3' WHERE name = 'AirPods Pro';
UPDATE product SET image_url = 'https://picsum.photos/400/400?random=4' WHERE name = 'iPad Air';
UPDATE product SET image_url = 'https://picsum.photos/400/400?random=5' WHERE name = 'Apple Watch';

-- 插入更多测试商品数据
INSERT INTO product (`name`, `description`, `price`, `stock`, `image_url`, `status`, `category_id`) VALUES
('小米14 Ultra', '小米旗舰智能手机', 6499.00, 120, 'https://picsum.photos/400/400?random=6', 1, 1),
('华为P60 Pro', '华为旗舰手机', 5988.00, 100, 'https://picsum.photos/400/400?random=7', 1, 1),
('三星Galaxy S24', '三星旗舰手机', 5699.00, 90, 'https://picsum.photos/400/400?random=8', 1, 1),
('戴尔XPS 15', '高性能笔记本', 9999.00, 60, 'https://picsum.photos/400/400?random=9', 1, 2),
('联想ThinkPad X1', '商务笔记本', 8888.00, 50, 'https://picsum.photos/400/400?random=10', 1, 2),
('索尼WH-1000XM5', '降噪耳机', 2499.00, 180, 'https://picsum.photos/400/400?random=11', 1, 3),
('Bose QuietComfort', '无线降噪耳机', 2299.00, 160, 'https://picsum.photos/400/400?random=12', 1, 3),
('华为FreeBuds Pro', '蓝牙耳机', 1299.00, 200, 'https://picsum.photos/400/400?random=13', 1, 3),
('小米Pad 6 Pro', '高性能平板', 2899.00, 100, 'https://picsum.photos/400/400?random=14', 1, 4),
('华为MatePad Pro', '旗舰平板', 3999.00, 80, 'https://picsum.photos/400/400?random=15', 1, 4),
('三星Galaxy Tab S9', '安卓平板', 4599.00, 70, 'https://picsum.photos/400/400?random=16', 1, 4),
('华为Watch GT4', '智能运动手表', 1488.00, 150, 'https://picsum.photos/400/400?random=17', 1, 5),
('小米Watch S3', '智能手表', 999.00, 200, 'https://picsum.photos/400/400?random=18', 1, 5),
('三星Galaxy Watch 6', '安卓智能手表', 1799.00, 120, 'https://picsum.photos/400/400?random=19', 1, 5),
('任天堂Switch', '游戏主机', 2099.00, 80, 'https://picsum.photos/400/400?random=20', 1, 6),
('PlayStation 5', '索尼游戏机', 3899.00, 60, 'https://picsum.photos/400/400?random=21', 1, 6),
('Xbox Series X', '微软游戏机', 3499.00, 70, 'https://picsum.photos/400/400?random=22', 1, 6),
('大疆Mini 3 Pro', '无人机', 4788.00, 40, 'https://picsum.photos/400/400?random=23', 1, 7),
('佳能EOS R6', '单反相机', 15999.00, 30, 'https://picsum.photos/400/400?random=24', 1, 7),
('索尼Alpha 7 IV', '微单相机', 16999.00, 25, 'https://picsum.photos/400/400?random=25', 1, 7);

-- 查询商品数量
SELECT COUNT(*) as total_products FROM product;
