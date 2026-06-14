# 🚀 项目启动最终指南

## ✅ 环境已准备

- ✓ Java 1.8 已安装
- ✓ MySQL 8.0.30 已安装（端口3306）
- ✓ Redis 正在运行
- ✓ Maven Wrapper 已配置

## 🎯 启动步骤

### 步骤1：启动MySQL

```bash
sudo /usr/local/mysql-8.0.30-macos12-x86_64/support-files/mysql.server start
```

### 步骤2：初始化数据库

```bash
# 方式1：无密码登录
mysql -u root < sql/init.sql

# 方式2：有密码登录（替换your_password为你的密码）
mysql -u root -pyour_password < sql/init.sql

# 方式3：交互式输入密码
mysql -u root -p
# 输入密码后，在MySQL命令行中执行：
source /Users/zyq/IdeaProjects/TestProject/sql/init.sql
```

### 步骤3：下载并启动Nacos

```bash
# 下载Nacos（首次需要）
cd /tmp
curl -O https://github.com/alibaba/nacos/releases/download/2.2.3/nacos-server-2.2.3.tar.gz
tar -xzf nacos-server-2.2.3.tar.gz
mv nacos ~/nacos

# 启动Nacos
cd ~/nacos/bin
./startup.sh -m standalone

# 访问控制台
open http://localhost:8848/nacos
# 用户名: nacos
# 密码: nacos
```

### 步骤4：编译项目

```bash
cd /Users/zyq/IdeaProjects/TestProject

# 设置Java环境变量（如果需要）
export JAVA_HOME=/Library/Java/JavaVirtualMachines/jdk1.8.0_221.jdk/Contents/Home
export PATH="$JAVA_HOME/bin:$PATH"

# 编译项目
./mvnw clean install -DskipTests
```

### 步骤5：启动服务

**方式A：使用启动脚本（推荐）**
```bash
cd /Users/zyq/IdeaProjects/TestProject
./start.sh
```

**方式B：在IntelliJ IDEA中启动（最简单）**
1. 用IDEA打开项目
2. 右键各服务的主类，选择Run
   - `ecommerce-registry` → 运行
   - `ecommerce-gateway` → 运行
   - `ecommerce-user` → 运行
   - `ecommerce-product` → 运行
   - `ecommerce-order` → 运行
   - `ecommerce-payment` → 运行

**方式C：手动启动各服务**
```bash
# 注册中心
cd ecommerce-registry
../mvnw spring-boot:run &

# API网关
cd ../ecommerce-gateway
../mvnw spring-boot:run &

# 用户服务
cd ../ecommerce-user
../mvnw spring-boot:run &

# 商品服务
cd ../ecommerce-product
../mvnw spring-boot:run &

# 订单服务
cd ../ecommerce-order
../mvnw spring-boot:run &

# 支付服务
cd ../ecommerce-payment
../mvnw spring-boot:run &
```

## 🔍 验证启动成功

### 检查服务状态

```bash
# 访问Nacos控制台
open http://localhost:8848/nacos
# 应该看到6个服务已注册

# 测试API
curl http://localhost:9000
curl http://localhost:8001
curl http://localhost:8002
curl http://localhost:8003
curl http://localhost:8004
```

### 查看日志

```bash
# 如果使用启动脚本
tail -f logs/*.log

# 如果在IDEA中运行
查看IDEA的Console窗口
```

## 🛠️ 快速命令参考

```bash
# 一键启动MySQL
sudo /usr/local/mysql-8.0.30-macos12-x86_64/support-files/mysql.server start

# 一键停止MySQL
sudo /usr/local/mysql-8.0.30-macos12-x86_64/support-files/mysql.server stop

# 一键启动Nacos
cd ~/nacos/bin && ./startup.sh -m standalone

# 一键停止Nacos
cd ~/nacos/bin && ./shutdown.sh

# 编译项目
./mvnw clean install -DskipTests

# 启动所有服务
./start.sh

# 停止所有服务
./stop.sh

# 检查端口占用
lsof -i :8848  # Nacos
lsof -i :3306  # MySQL
lsof -i :6379  # Redis
lsof -i :9000  # API网关
lsof -i :8001  # 用户服务
lsof -i :8002  # 商品服务
lsof -i :8003  # 订单服务
lsof -i :8004  # 支付服务
```

## 📊 服务端口列表

| 服务 | 端口 | 用途 |
|------|------|------|
| Nacos | 8848 | 服务注册中心 |
| MySQL | 3306 | 数据库 |
| Redis | 6379 | 缓存 |
| API网关 | 9000 | 统一入口 |
| 用户服务 | 8001 | 用户管理 |
| 商品服务 | 8002 | 商品管理 |
| 订单服务 | 8003 | 订单管理 |
| 支付服务 | 8004 | 支付管理 |

## 🧪 测试API

### 用户注册
```bash
curl -X POST http://localhost:9000/api/user/register \
  -H "Content-Type: application/json" \
  -d '{"username":"test","password":"123456","email":"test@example.com"}'
```

### 查看商品列表
```bash
curl http://localhost:9000/api/product/products/list
```

### 创建订单
```bash
curl -X POST http://localhost:9000/api/order/create \
  -H "Content-Type: application/json" \
  -d '{"userId":1,"productId":1,"quantity":2}'
```

## ⚠️ 常见问题

### MySQL连接失败
```bash
# 检查MySQL是否运行
sudo /usr/local/mysql-8.0.30-macos12-x86_64/support-files/mysql.server status

# 重启MySQL
sudo /usr/local/mysql-8.0.30-macos12-x86_64/support-files/mysql.server restart

# 检查端口
lsof -i :3306
```

### Nacos启动失败
```bash
# 查看日志
tail -f ~/nacos/logs/start.out

# 重新启动
cd ~/nacos/bin
./shutdown.sh
./startup.sh -m standalone
```

### 编译失败
```bash
# 清理并重新编译
./mvnw clean install -U -DskipTests

# 查看详细错误
./mvnw clean install -DskipTests -X
```

### 端口被占用
```bash
# 查看占用进程
lsof -i :9000

# 杀掉进程
kill -9 <PID>

# 或者修改端口
# 编辑各服务的application.yml，修改server.port
```

## 🎉 启动成功的标志

1. **Nacos控制台**：访问 http://localhost:8848/nacos，看到6个服务已注册
2. **服务日志**：所有服务的日志显示启动成功，无ERROR
3. **API测试**：curl测试返回正常响应
4. **端口检查**：所有服务端口都被监听

## 📝 配置文件说明

各服务的配置文件位于：
- `ecommerce-registry/src/main/resources/application.yml`
- `ecommerce-gateway/src/main/resources/application.yml`
- `ecommerce-user/src/main/resources/application.yml`
- `ecommerce-product/src/main/resources/application.yml`
- `ecommerce-order/src/main/resources/application.yml`
- `ecommerce-payment/src/main/resources/application.yml`

如需修改数据库密码等配置，请编辑这些文件。

## 🚀 最快启动方式（推荐）

如果你使用IntelliJ IDEA：

1. **启动依赖服务**
   ```bash
   # 启动MySQL
   sudo /usr/local/mysql-8.0.30-macos12-x86_64/support-files/mysql.server start

   # 初始化数据库
   mysql -u root < sql/init.sql

   # 启动Nacos
   cd ~/nacos/bin && ./startup.sh -m standalone
   ```

2. **在IDEA中**
   - File → Open → 选择项目目录
   - 等待Maven同步完成
   - 右键各服务的主类 → Run

这是最简单、最可靠的方式！

## ✨ 项目已准备就绪

所有代码已修复，所有配置已完成，按照上述步骤即可启动！

**预计启动时间：10-15分钟**
