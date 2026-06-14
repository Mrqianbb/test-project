# 手动环境准备指南

## 当前环境问题

系统检查发现以下问题：
- ❌ Java 1.8（需要JDK 17+，或使用兼容版本）
- ❌ Maven 未安装
- ❌ MySQL 未启动
- ❌ Nacos 未启动
- ✓ Redis 已运行

## 已完成的修改

✅ 项目已降级到兼容Java 8的版本：
- Java版本：17 → 8
- Spring Boot：3.2.0 → 2.7.18
- Spring Cloud：2023.0.0 → 2021.0.8
- Spring Cloud Alibaba：2022.0.0.0 → 2021.0.5.0

## 快速解决方案（3步完成）

### 方案一：使用Homebrew自动安装（推荐）

```bash
# 1. 安装所有依赖
brew install openjdk@8 maven mysql redis

# 2. 启动服务
brew services start mysql
brew services start redis

# 3. 设置环境变量
echo 'export JAVA_HOME=$(/usr/libexec/java_home -v 1.8)' >> ~/.zshrc
source ~/.zshrc
```

### 方案二：使用IDEA编译运行

1. 用IntelliJ IDEA打开项目
2. IDEA会自动下载Maven和依赖
3. 等待依赖下载完成
4. 在IDEA中运行各服务

### 方案三：手动准备环境

#### 步骤1：安装JDK 8（如果需要）
```bash
# 检查当前Java版本
java -version

# 如果需要JDK 17
brew install openjdk@17
export JAVA_HOME=$(/usr/libexec/java_home -v 17)
```

#### 步骤2：安装Maven
```bash
brew install maven

# 验证安装
mvn -version
```

#### 步骤3：安装并启动MySQL
```bash
brew install mysql
brew services start mysql

# 设置root密码（可选）
mysql_secure_installation

# 初始化数据库
mysql -u root < sql/init.sql
```

#### 步骤4：启动Redis
```bash
# Redis已安装，检查状态
redis-cli ping

# 如果未运行
redis-server
```

#### 步骤5：下载并启动Nacos
```bash
# 下载Nacos
cd /tmp
curl -O https://github.com/alibaba/nacos/releases/download/2.2.3/nacos-server-2.2.3.tar.gz
tar -xzf nacos-server-2.2.3.tar.gz
mv nacos ~/nacos

# 启动Nacos
cd ~/nacos/bin
./startup.sh -m standalone

# 访问控制台
open http://localhost:8848/nacos
# 默认用户名密码：nacos/nacos
```

## 启动项目

环境准备完成后：

```bash
# 编译项目
mvn clean install -DskipTests

# 使用启动脚本
./start.sh

# 或者手动启动各服务
cd ecommerce-registry && mvn spring-boot:run &
cd ecommerce-gateway && mvn spring-boot:run &
cd ecommerce-user && mvn spring-boot:run &
cd ecommerce-product && mvn spring-boot:run &
cd ecommerce-order && mvn spring-boot:run &
cd ecommerce-payment && mvn spring-boot:run &
```

## 验证启动成功

```bash
# 检查服务状态
curl http://localhost:8848/nacos
curl http://localhost:9000
curl http://localhost:8001
curl http://localhost:8002
```

## 端口说明

| 服务 | 端口 |
|------|------|
| Nacos | 8848 |
| MySQL | 3306 |
| Redis | 6379 |
| 用户服务 | 8001 |
| 商品服务 | 8002 |
| 订单服务 | 8003 |
| 支付服务 | 8004 |
| API网关 | 9000 |

## 常见问题

### Maven下载慢
配置阿里云镜像（已自动配置在pom.xml中）

### MySQL连接失败
检查MySQL是否启动：`brew services list`
检查密码配置：修改各模块的application.yml

### Nacos启动失败
检查Java版本是否正确
查看日志：~/nacos/logs/start.out

### 端口冲突
修改application.yml中的server.port

## 推荐操作顺序

1. **首先执行**：`brew install maven`
2. **然后执行**：`mvn clean install -DskipTests`
3. **在等待依赖下载时**：
   - 安装并启动MySQL：`brew install mysql && brew services start mysql`
   - 下载Nacos并启动
4. **编译完成后**：使用IDEA运行各服务或使用`./start.sh`

## 快速测试脚本

```bash
# 一键测试环境
echo "测试Maven..."
mvn -version

echo "测试MySQL..."
mysql -u root -e "SELECT 1;"

echo "测试Redis..."
redis-cli ping

echo "测试Nacos..."
curl -s http://localhost:8848/nacos | head -1

echo "编译项目..."
mvn clean compile -DskipTests
```

## 下一步

1. 根据上述方案准备环境
2. 运行 `./check-env.sh` 验证环境
3. 运行 `./start.sh` 启动项目
4. 访问 http://localhost:8848/nacos 查看服务注册情况
