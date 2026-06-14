# 项目启动指南

## 前置条件检查

在启动项目之前，请确保以下环境已正确配置：

### 1. Java 环境
```bash
# 检查 Java 版本（需要 JDK 17+）
java -version

# 如果版本低于 17，请安装 JDK 17+
# 下载地址: https://adoptium.net/
```

### 2. Maven 环境
```bash
# 检查 Maven 版本（需要 3.6+）
mvn -version

# 如果未安装，请安装 Maven
# macOS: brew install maven
# Linux: apt install maven
# Windows: 从官网下载并配置环境变量
```

### 3. MySQL 数据库
```bash
# 检查 MySQL 是否运行
mysql -u root -p

# 如果未安装，请安装 MySQL 8.0+
# macOS: brew install mysql
# Linux: apt install mysql-server
# Windows: 从官网下载安装

# 启动 MySQL
# macOS: brew services start mysql
# Linux: systemctl start mysql
# Windows: net start mysql
```

### 4. Redis 缓存
```bash
# 检查 Redis 是否运行
redis-cli ping

# 如果未安装，请安装 Redis
# macOS: brew install redis
# Linux: apt install redis-server
# Windows: 从官网下载

# 启动 Redis
redis-server

# 或者使用后台模式启动
redis-server --daemonize yes
```

### 5. Nacos 服务注册中心

```bash
# 下载 Nacos
wget https://github.com/alibaba/nacos/releases/download/2.2.3/nacos-server-2.2.3.tar.gz
tar -xvf nacos-server-2.2.3.tar.gz
cd nacos

# 启动 Nacos（单机模式）
cd bin
./startup.sh -m standalone

# Windows 启动命令
startup.cmd -m standalone

# 访问 Nacos 控制台
# http://localhost:8848/nacos
# 默认账号密码: nacos/nacos
```

## 初始化数据库

```bash
# 创建数据库并导入数据
mysql -u root -p < sql/init.sql

# 或者登录 MySQL 后执行
mysql -u root -p
source sql/init.sql;
```

## 修改配置文件

根据你的环境，修改各服务的 `application.yml` 配置文件：

### 1. 数据库配置
```yaml
spring:
  datasource:
    url: jdbc:mysql://localhost:3306/ecommerce?useUnicode=true&characterEncoding=utf8&useSSL=false&serverTimezone=Asia/Shanghai
    username: root
    password: your_password  # 修改为你的 MySQL 密码
```

### 2. Redis 配置
```yaml
spring:
  data:
    redis:
      host: localhost
      port: 6379
      password:  # 如果有密码，在此配置
```

### 3. Nacos 配置
```yaml
spring:
  cloud:
    nacos:
      discovery:
        server-addr: localhost:8848  # 如果 Nacos 在其他机器，修改为对应地址
```

## 启动项目

### 方式一：使用启动脚本（推荐）

```bash
# 1. 编译项目
mvn clean install -DskipTests

# 2. 启动所有服务
./start.sh
```

### 方式二：手动启动各个服务

```bash
# 1. 启动用户服务
cd ecommerce-user
mvn spring-boot:run

# 2. 启动商品服务
cd ../ecommerce-product
mvn spring-boot:run

# 3. 启动订单服务
cd ../ecommerce-order
mvn spring-boot:run

# 4. 启动支付服务
cd ../ecommerce-payment
mvn spring-boot:run

# 5. 启动网关服务
cd ../ecommerce-gateway
mvn spring-boot:run
```

### 方式三：在 IDE 中启动

1. 在 IDE 中打开项目
2. 找到各服务的启动类（Application 类）
3. 右键点击启动类，选择 "Run"

启动顺序建议：
1. ecommerce-user
2. ecommerce-product
3. ecommerce-order
4. ecommerce-payment
5. ecommerce-gateway

## 验证服务是否启动成功

### 1. 检查 Nacos 服务注册

访问 Nacos 控制台：http://localhost:8848/nacos

在"服务管理" -> "服务列表"中，应该能看到以下服务：
- ecommerce-user
- ecommerce-product
- ecommerce-order
- ecommerce-payment
- ecommerce-gateway

### 2. 测试 API 接口

```bash
# 测试用户注册
curl -X POST http://localhost:9000/api/user/users/register \
  -H "Content-Type: application/json" \
  -d '{
    "username": "testuser",
    "password": "123456",
    "nickname": "测试用户",
    "phone": "13800138000",
    "email": "test@example.com"
  }'

# 测试用户登录
curl -X POST http://localhost:9000/api/user/users/login \
  -H "Content-Type: application/json" \
  -d '{"username": "testuser", "password": "123456"}'

# 测试获取商品列表
curl http://localhost:9000/api/product/products/list

# 测试获取商品详情
curl http://localhost:9000/api/product/products/1
```

## 常见问题及解决方案

### 1. Maven 编译失败

**问题**: `command not found: mvn`

**解决方案**: 安装 Maven 或配置环境变量

```bash
# macOS
brew install maven

# Linux
apt install maven

# 配置环境变量
export PATH=/path/to/maven/bin:$PATH
```

### 2. Java 版本错误

**问题**: `Unsupported class file major version 61`

**解决方案**: 确保 Java 版本为 17 或更高

```bash
# 检查当前版本
java -version

# 如果版本低于 17，需要升级 JDK
# 下载 JDK 17+ 并配置 JAVA_HOME
export JAVA_HOME=/path/to/jdk17
export PATH=$JAVA_HOME/bin:$PATH
```

### 3. 数据库连接失败

**问题**: `Communications link failure`

**解决方案**:
1. 确保 MySQL 已启动
2. 检查数据库用户名和密码是否正确
3. 检查数据库 `ecommerce` 是否已创建
4. 检查 MySQL 是否允许远程连接

```bash
# 检查 MySQL 是否运行
mysql -u root -p -e "SELECT 1;"

# 重启 MySQL
brew services restart mysql  # macOS
systemctl restart mysql   # Linux
```

### 4. Redis 连接失败

**问题**: `Unable to connect to Redis`

**解决方案**:
1. 确保 Redis 已启动
2. 检查 Redis 配置是否正确
3. 检查防火墙设置

```bash
# 检查 Redis 是否运行
redis-cli ping

# 重启 Redis
redis-server --daemonize yes
```

### 5. Nacos 连接失败

**问题**: `Failed to connect to Nacos`

**解决方案**:
1. 确保 Nacos 已启动
2. 检查 Nacos 地址是否正确
3. 检查防火墙设置

```bash
# 检查 Nacos 是否运行
curl http://localhost:8848/nacos

# 重启 Nacos
cd nacos/bin
./shutdown.sh
./startup.sh -m standalone
```

### 6. 端口占用

**问题**: `Port 8001 is already in use`

**解决方案**:
1. 找到占用端口的进程并停止
2. 或者修改服务的端口号

```bash
# 查找占用端口的进程
lsof -i :8001  # macOS/Linux
netstat -ano | findstr 8001  # Windows

# 停止进程
kill -9 PID
```

### 7. 依赖下载失败

**问题**: `Could not resolve dependencies`

**解决方案**:
1. 检查网络连接
2. 配置 Maven 镜像源
3. 清理本地 Maven 缓存

```bash
# 清理 Maven 缓存
rm -rf ~/.m2/repository

# 重新编译
mvn clean install -U
```

### 8. 服务启动后无法访问

**问题**: 服务已启动但无法访问 API

**解决方案**:
1. 检查服务是否在 Nacos 中注册成功
2. 检查网关路由配置是否正确
3. 查看服务日志，排查错误

```bash
# 查看服务日志
tail -f logs/ecommerce-user.log

# 访问服务直接地址（绕过网关）
curl http://localhost:8001/users/1
```

## 性能优化建议

### 1. JVM 参数优化

在启动服务时添加 JVM 参数：

```bash
mvn spring-boot:run -Dspring-boot.run.jvmArguments="-Xms512m -Xmx1024m -XX:+UseG1GC"
```

### 2. 数据库连接池优化

```yaml
spring:
  datasource:
    hikari:
      minimum-idle: 5
      maximum-pool-size: 20
      connection-timeout: 30000
      idle-timeout: 600000
      max-lifetime: 1800000
```

### 3. Redis 连接池优化

```yaml
spring:
  data:
    redis:
      lettuce:
        pool:
          min-idle: 5
          max-idle: 20
          max-active: 50
          max-wait: -1ms
```

## 日志查看

```bash
# 查看所有服务的日志
tail -f logs/*.log

# 查看特定服务的日志
tail -f logs/ecommerce-user.log

# 搜索错误日志
grep "ERROR" logs/ecommerce-user.log
```

## 停止服务

```bash
# 使用停止脚本
./stop.sh

# 或者手动停止所有服务
killall java

# 或者找到并停止特定进程
ps aux | grep spring-boot:run
kill -9 PID
```

## 下一步

项目启动成功后，可以：
1. 访问 Nacos 控制台查看服务状态
2. 使用 Postman 或 curl 测试 API 接口
3. 查看 README.md 了解更多 API 使用示例
4. 查看业务代码了解实现细节

## 获取帮助

如果遇到问题：
1. 查看服务日志文件：`logs/` 目录
2. 检查 Nacos 控制台：http://localhost:8848/nacos
3. 查看 ARCHITECTURE.md 了解系统架构
4. 查看 README.md 了解项目使用方法

祝你使用愉快！
