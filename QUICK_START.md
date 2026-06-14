# 快速启动指南

## 三步启动（最简方式）

### 前提条件
- 已安装 JDK 17+
- 已安装 Maven 3.6+

### 快速启动步骤

```bash
# 第一步：运行环境检查
./check-env.sh root

# 第二步：根据检查结果，安装缺失的服务
# - 如果 Java 版本不对：下载 JDK 17+
# - 如果 MySQL 未启动：brew install mysql && brew services start mysql
# - 如果 Redis 未启动：brew install redis && redis-server
# - 如果 Nacos 未启动：下载并启动 Nacos

# 第三步：启动所有服务
./start.sh
```

## 验证启动成功

```bash
# 访问 Nacos 控制台
open http://localhost:8848/nacos

# 测试 API
curl http://localhost:9000/api/product/products/list
```

## 常见问题快速解决

| 问题 | 解决方案 |
|------|----------|
| Java 版本不对 | 下载 JDK 17+ 并配置 JAVA_HOME |
| MySQL 连接失败 | 检查 MySQL 是否启动，修改配置文件中的密码 |
| Redis 连接失败 | 运行 `redis-server` |
| Nacos 连接失败 | 下载 Nacos 并运行 `./startup.sh -m standalone` |
| 端口占用 | 修改 application.yml 中的端口配置 |
| 编译失败 | 运行 `mvn clean install -U -DskipTests` |

## 详细文档

- 环境检查：`./check-env.sh`
- 启动指南：STARTUP_GUIDE.md
- 问题诊断：DIAGNOSE.md
- 项目文档：README.md
- 架构设计：ARCHITECTURE.md

## 端口说明

| 服务 | 端口 |
|------|------|
| Nacos | 8848 |
| API 网关 | 9000 |
| 用户服务 | 8001 |
| 商品服务 | 8002 |
| 订单服务 | 8003 |
| 支付服务 | 8004 |
| MySQL | 3306 |
| Redis | 6379 |
