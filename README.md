# 电商平台微服务架构

> 基于 Spring Cloud Alibaba 的电商平台微服务架构项目，采用前后台分离设计，支持MySQL和Redis。

## 📋 项目简介

本项目是一个完整的电商平台微服务架构，采用 Spring Cloud Alibaba 技术栈，实现了用户管理、商品管理、订单管理、支付管理等核心功能。

## 🏗️ 系统架构

```
┌─────────────────────────────────────────────────────────────┐
│                        客户端 (前端)                          │
│                       (Vue/React/Mobile)                     │
└─────────────────────────┬───────────────────────────────────┘
                          │
                          ▼
┌─────────────────────────────────────────────────────────────┐
│                  API Gateway (9000)                          │
│              路由转发、负载均衡、限流熔断                      │
│              Nacos: localhost:8848                          │
└────┬────────────┬────────────┬────────────┬─────────────────┘
     │            │            │            │
     ▼            ▼            ▼            ▼
┌─────────┐ ┌──────────┐ ┌──────────┐ ┌──────────┐
│ 用户服务  │ │ 商品服务  │ │ 订单服务  │ │ 支付服务  │
│  (8001) │ │  (8002)  │ │  (8003)  │ │  (8004)  │
└─────────┘ └──────────┘ └──────────┘ └──────────┘

┌─────────────────────────────────────────────────────────────┐
│              基础设施                                         │
│  ┌──────────┐  ┌──────────┐  ┌──────────┐                │
│  │  Nacos   │  │  MySQL   │  │  Redis   │                │
│  │  8848    │  │  3306    │  │  6379    │                │
│  └──────────┘  └──────────┘  └──────────┘                │
└─────────────────────────────────────────────────────────────┘
```

## 📦 模块说明

### 1. ecommerce-common
公共模块，包含公共类、工具类、统一响应格式等。

### 2. ecommerce-registry
服务注册中心模块（基于Nacos）。

### 3. ecommerce-gateway
API网关服务，提供统一入口、路由转发、限流等功能。

### 4. ecommerce-user
用户服务，提供用户注册、登录、信息管理等功能。

### 5. ecommerce-product
商品服务，提供商品管理、库存管理、缓存优化等功能。

### 6. ecommerce-order
订单服务，提供订单创建、查询、取消等功能。

### 7. ecommerce-payment
支付服务，提供支付创建、支付处理、支付查询等功能。

### 8. ecommerce-auth
认证授权服务（待实现）。

## 🚀 快速开始

### 环境要求

- JDK 17+
- Maven 3.6+
- MySQL 8.0+
- Redis 5.0+
- Nacos 2.0+

### 安装步骤

#### 1. 启动 Nacos

下载并启动 Nacos Server：

```bash
# 下载 Nacos
wget https://github.com/alibaba/nacos/releases/download/2.2.3/nacos-server-2.2.3.tar.gz
tar -xvf nacos-server-2.2.3.tar.gz
cd nacos/bin

# 启动 Nacos（单机模式）
./startup.sh -m standalone

# 访问 Nacos 控制台
# http://localhost:8848/nacos
# 默认账号密码：nacos/nacos
```

#### 2. 初始化数据库

```bash
mysql -u root -p < sql/init.sql
```

#### 3. 启动 Redis

```bash
redis-server
```

#### 4. 启动服务

```bash
# 方式一：启动所有模块
mvn clean install
cd ecommerce-registry && mvn spring-boot:run
cd ecommerce-gateway && mvn spring-boot:run
cd ecommerce-user && mvn spring-boot:run
cd ecommerce-product && mvn spring-boot:run
cd ecommerce-order && mvn spring-boot:run
cd ecommerce-payment && mvn spring-boot:run

# 方式二：使用IDE启动各个模块的主类
```

## 📡 API 文档

### 基础URL
```
http://localhost:9000/api/{service-name}/{resource}
```

### 用户服务 (ecommerce-user)

#### 用户注册
```bash
POST /api/user/users/register
Content-Type: application/json

{
  "username": "testuser",
  "password": "123456",
  "nickname": "测试用户",
  "phone": "13800138000",
  "email": "test@example.com"
}
```

#### 用户登录
```bash
POST /api/user/users/login
Content-Type: application/json

{
  "username": "testuser",
  "password": "123456"
}
```

#### 获取用户信息
```bash
GET /api/user/users/{id}
```

#### 更新用户信息
```bash
PUT /api/user/users/{id}
Content-Type: application/json

{
  "nickname": "新昵称",
  "avatar": "头像URL"
}
```

### 商品服务 (ecommerce-product)

#### 创建商品
```bash
POST /api/product/products
Content-Type: application/json

{
  "name": "测试商品",
  "description": "商品描述",
  "price": 99.99,
  "stock": 100,
  "status": 1,
  "categoryId": 1
}
```

#### 获取商品详情
```bash
GET /api/product/products/{id}
```

#### 获取商品列表
```bash
GET /api/product/products/list?categoryId=1
```

#### 更新库存
```bash
POST /api/product/products/{id}/stock?quantity=10
```

### 订单服务 (ecommerce-order)

#### 创建订单
```bash
POST /api/order/orders
Content-Type: application/json

{
  "userId": 1,
  "address": "北京市朝阳区",
  "receiver": "张三",
  "phone": "13800138000",
  "items": [
    {
      "productId": 1,
      "productName": "iPhone 15 Pro",
      "price": 7999.00,
      "quantity": 1
    }
  ]
}
```

#### 获取订单详情
```bash
GET /api/order/orders/{id}
```

#### 获取用户订单列表
```bash
GET /api/order/orders/user/{userId}
```

#### 取消订单
```bash
POST /api/order/orders/{id}/cancel
```

### 支付服务 (ecommerce-payment)

#### 创建支付
```bash
POST /api/payment/payments
Content-Type: application/json

{
  "orderId": 1,
  "amount": 7999.00,
  "paymentMethod": "ALIPAY"
}
```

#### 完成支付
```bash
POST /api/payment/payments/{id}/complete
```

#### 获取支付详情
```bash
GET /api/payment/payments/{id}
```

## 🎯 核心功能

### 1. 服务注册与发现
- 基于 Nacos 实现服务注册与发现
- 自动服务注册和健康检查
- 动态服务列表更新

### 2. API 网关
- 统一入口，路由转发
- 负载均衡（基于 Ribbon）
- 限流保护（基于 Redis）
- 路径重写

### 3. 服务调用
- 基于 OpenFeign 的声明式服务调用
- 自动负载均衡
- 超时控制
- 熔断降级

### 4. 缓存优化
- 商品信息 Redis 缓存
- 减少数据库查询
- 提高系统性能

### 5. 并发控制
- 数据库乐观锁
- 库存扣减原子性
- 防止超卖

### 6. 统一响应
```json
{
  "code": 200,
  "message": "操作成功",
  "data": {},
  "timestamp": 1234567890
}
```

## 🗄️ 数据库设计

### 用户表 (user)
- id: 用户ID
- username: 用户名
- password: 密码（BCrypt加密）
- nickname: 昵称
- phone: 手机号
- email: 邮箱
- avatar: 头像
- status: 状态

### 商品表 (product)
- id: 商品ID
- name: 商品名称
- description: 商品描述
- price: 价格
- stock: 库存数量
- image_url: 商品图片
- status: 状态
- category_id: 分类ID

### 订单表 (order_info)
- id: 订单ID
- order_no: 订单号
- user_id: 用户ID
- total_amount: 订单总金额
- status: 订单状态（0：待支付，1：已支付，2：已取消）
- address: 收货地址
- receiver: 收货人
- phone: 联系电话

### 订单明细表 (order_item)
- id: 订单明细ID
- order_id: 订单ID
- product_id: 商品ID
- product_name: 商品名称
- price: 商品价格
- quantity: 购买数量
- total_amount: 小计金额

### 支付表 (payment)
- id: 支付ID
- payment_no: 支付单号
- order_id: 订单ID
- amount: 支付金额
- status: 支付状态（0：待支付，1：已支付）
- payment_method: 支付方式
- transaction_id: 第三方交易号

## 🔧 技术栈

- **核心框架**: Spring Boot 3.2.0
- **微服务框架**: Spring Cloud 2023.0.0
- **服务注册与发现**: Nacos 2.2.3
- **API 网关**: Spring Cloud Gateway
- **服务调用**: OpenFeign
- **持久层**: MyBatis Plus 3.5.5
- **数据库**: MySQL 8.0.33
- **缓存**: Redis
- **工具类**: Hutool 5.8.23
- **JSON**: Fastjson2 2.0.43

## 📊 项目特点

1. **微服务架构**: 各服务独立部署、独立扩展
2. **服务注册与发现**: 基于 Nacos 的服务治理
3. **API 网关**: 统一入口、路由转发、限流保护
4. **声明式服务调用**: 基于 OpenFeign 简化服务调用
5. **缓存优化**: 使用 Redis 提高查询性能
6. **并发控制**: 数据库乐观锁，防止超卖
7. **统一响应**: 规范的 API 响应格式
8. **全局异常处理**: 统一异常处理机制

## 🚧 待优化方向

- [ ] 添加认证授权服务（OAuth2 + JWT）
- [ ] 添加配置中心（Nacos Config）
- [ ] 添加链路追踪（Spring Cloud Sleuth）
- [ ] 添加熔断降级（Sentinel）
- [ ] 添加消息队列（RocketMQ）
- [ ] 添加分布式事务（Seata）
- [ ] 添加搜索服务（Elasticsearch）
- [ ] 添加日志收集（ELK）
- [ ] 添加监控告警（Prometheus + Grafana）
- [ ] 添加 CI/CD 流程

## 📝 注意事项

1. 确保 MySQL 和 Redis 服务已启动
2. 确保 Nacos Server 已启动
3. 修改各服务的 `application.yml` 中的数据库连接信息
4. 生产环境建议修改默认密码
5. 建议配置服务集群部署提高可用性
6. Token 有效期为 7 天，可根据需要调整

## 📄 许可证

本项目基于 MIT 许可证开源。

## 👥 贡献

欢迎提交 Issue 和 Pull Request！

## 📧 联系方式

如有问题，请联系项目维护者。

---

**注意**: 本项目仅用于学习和参考，生产环境使用请根据实际情况进行优化和调整。
