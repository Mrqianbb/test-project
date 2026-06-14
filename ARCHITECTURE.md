# 电商平台微服务架构设计文档

## 1. 项目概览

本项目是一个完整的**电商平台微服务架构系统**，基于 **Spring Cloud Alibaba** 技术栈构建，采用**前后端分离**设计。项目包含 **9 个 Maven 模块**（含 1 个公共模块、1 个注册中心、1 个 API 网关、5 个业务服务、1 个批量任务服务）和 **1 个独立前端项目**。

| 属性 | 值 |
|------|-----|
| **GroupId** | `com.ecommerce` |
| **ArtifactId** | `ecommerce-platform` |
| **Version** | `1.0.0` |
| **Java 版本** | 8 |
| **项目根路径** | `/Users/zyq/IdeaProjects/TestProject` |

---

## 2. 技术栈总览

### 2.1 后端技术栈

| 技术 | 版本 | 用途 | 备注 |
|------|------|------|------|
| **Java** | 8 | 编程语言 | 目标运行时 |
| **Spring Boot** | 2.7.18 | 基础框架 | 父 POM 统一版本管理 |
| **Spring Cloud** | 2021.0.8 | 微服务框架 | 与 Spring Boot 2.7.x 匹配 |
| **Spring Cloud Alibaba** | 2021.0.5.0 | 微服务治理 | Nacos 集成 |
| **Spring Cloud Gateway** | — | API 网关 | 统一路由、StripPrefix、负载均衡 |
| **OpenFeign** | — | 声明式服务调用 | 订单服务 ←→ 商品服务、支付服务 ←→ 订单服务 |
| **Spring Cloud LoadBalancer** | — | 客户端负载均衡 | 替换 Ribbon |
| **Nacos Server** | 2.2.3 | 服务注册与发现、配置中心 | 外部部署，端口 8848 |
| **MyBatis Plus** | 3.5.5 | ORM 框架 | 所有业务模块使用 |
| **MySQL** | 8.0.33 | 关系型数据库 | 端口 3306，数据库名 ecommerce |
| **Redis** | 6+ | 缓存 / Token 存储 | Spring Data Redis，用户 Token 7 天过期，商品缓存 30 分钟 |
| **XXL-JOB** | 2.4.0 | 分布式任务调度 | 仅在 ecommerce-batch 模块使用 |
| **Seata** | — | 分布式事务 | 已引入依赖但当前禁用 (`seata.enabled: false`) |
| **Spring Security** | — | 认证授权 | 仅在 ecommerce-auth 模块引入，待实现 |
| **Hutool** | 5.8.23 | 工具类库 | BCrypt 加密、UUID 生成等 |
| **Fastjson2** | 2.0.43 | JSON 序列化 | 高性能 JSON 处理 |
| **Lombok** | 1.18.30 | 代码简化 | 全项目使用 |
| **Spring Boot Actuator** | — | 健康检查 | ecommerce-user 模块启用 |

### 2.2 前端技术栈

| 技术 | 版本 | 用途 |
|------|------|------|
| **Vue** | 3.4.0 | 前端框架 (Composition API) |
| **Vite** | 5.0.8 | 构建工具，开发端口 3000 |
| **Vue Router** | 4.2.5 | SPA 路由管理 |
| **Pinia** | 2.1.7 | 响应式状态管理 |
| **Axios** | 1.6.2 | HTTP 请求库 |
| **Element Plus** | 2.5.0 | UI 组件库（企业级） |
| **ECharts** | 5.4.3 | 数据可视化图表 |
| **Day.js** | 1.11.10 | 日期处理 |
| **Sass** | 1.69.5 | CSS 预处理器 |

---

## 3. 模块结构与职责

### 3.1 模块总览

```
ecommerce-platform (父 POM)
├── ecommerce-common        [公共模块]
├── ecommerce-registry      [服务注册中心 :8849]
├── ecommerce-gateway       [API 网关 :9000]
├── ecommerce-auth          [认证授权服务（待实现）]
├── ecommerce-user          [用户服务 :8001]
├── ecommerce-product       [商品服务 :8002]
├── ecommerce-order         [订单服务 :8003]
├── ecommerce-payment       [支付服务 :8004]
├── ecommerce-batch         [批量任务服务 :8010]
└── ecommerce-frontend/     [Vue 前端 :3000]
```

### 3.2 各模块详细说明

---

#### 3.2.1 ecommerce-common（公共模块）

**类型**：JAR 库模块  
**打包方式**：`jar`  
**说明**：不独立运行，被所有业务模块依赖，提供通用基础设施。

**核心组件**：

| 类名 | 路径 | 职责 |
|------|------|------|
| `BaseEntity` | `com.ecommerce.common.entity.BaseEntity` | 实体基类，抽取 `id`, `createTime`, `updateTime`, `deleted` 公共字段 |
| `Result<T>` | `com.ecommerce.common.result.Result` | 统一 RESTful 响应体，封装 `code`, `message`, `data` |
| `ResultCode` | `com.ecommerce.common.result.ResultCode` | 响应状态码枚举（200 成功、400/500 各类错误码） |
| `BusinessException` | `com.ecommerce.common.exception.BusinessException` | 业务异常类，携带错误码和消息 |
| `GlobalExceptionHandler` | `com.ecommerce.common.handler.GlobalExceptionHandler` | `@RestControllerAdvice` 全局异常处理器，统一处理 `BusinessException` 和 `Exception` |

**依赖**：`spring-boot-starter-web`, `mybatis-plus-boot-starter`, `lombok`, `hutool-all`, `fastjson2`, `spring-boot-starter-validation`

---

#### 3.2.2 ecommerce-registry（注册中心）

**端口**：8849  
**说明**：Nacos Discovery 客户端示例服务。实际的 Nacos Server 需在 8848 端口独立部署运行。

**Java 文件**：`RegistryApplication.java` — `@SpringBootApplication` + `@EnableDiscoveryClient`

**依赖**：`spring-cloud-starter-alibaba-nacos-discovery`, `spring-cloud-starter-alibaba-nacos-config`, `spring-boot-starter-web`

---

#### 3.2.3 ecommerce-gateway（API 网关）

**端口**：9000  
**技术**：Spring Cloud Gateway  
**说明**：所有前端请求的统一入口，提供路由转发、路径重写、负载均衡。

**路由规则表**：

| 路由 ID | 匹配路径 | 目标 URI | 负载均衡 | StripPrefix |
|---------|---------|---------|---------|-------------|
| `user-service` | `/api/user/**` | `http://127.0.0.1:8001` | 直连 | 2 |
| `product-service` | `/api/product/**` | `http://127.0.0.1:8002` | 直连 | 2 |
| `order-service` | `/api/order/**` | `lb://ecommerce-order` | Nacos | 2 |
| `payment-service` | `/api/payment/**` | `lb://ecommerce-payment` | Nacos | 2 |

> StripPrefix=2 表示去掉路径前两层，例如 `/api/user/users/login` → `/users/login`

**Java 文件**：`GatewayApplication.java`

**依赖**：`ecommerce-common`, `spring-cloud-starter-gateway`, `spring-cloud-starter-alibaba-nacos-discovery`, `spring-cloud-starter-alibaba-nacos-config`, `spring-boot-starter-data-redis-reactive`

---

#### 3.2.4 ecommerce-auth（认证授权服务）

**状态**：🟡 模块已创建，**功能待实现**  
**说明**：已引入 Spring Security 依赖，但无任何 Java 源文件，仅有 pom.xml 和空目录结构。

**依赖**：`ecommerce-common`, `spring-boot-starter-security`, `spring-boot-starter-web`, `mybatis-plus`, `mysql`, `redis`, `nacos-discovery`, `nacos-config`

---

#### 3.2.5 ecommerce-user（用户服务）

**端口**：8001  
**说明**：处理用户注册、登录、信息管理、Token 会话管理。

**核心组件**：

| 组件 | 类名 | 职责 |
|------|------|------|
| 启动类 | `UserApplication.java` | `@SpringBootApplication` + `@EnableDiscoveryClient` |
| 控制器 | `UserController.java` | RESTful 接口：`/users/register`, `/users/login`, `/users/{id}`, `/users/logout` |
| 服务层 | `UserService.java` | 业务逻辑：BCrypt 密码加密校验、Token 生成、Redis 会话管理 |
| 数据层 | `UserMapper.java` | MyBatis Plus BaseMapper，操作用户表 |
| 实体 | `User.java` | 映射 `user` 表 |
| DTO | `UserLoginDTO.java` | 登录请求参数（username, password） |
| DTO | `UserRegisterDTO.java` | 注册请求参数（username, password, nickname 等） |
| VO | `UserLoginVO.java` | 登录响应体（token, userInfo） |

**核心业务流程**：
1. **注册**：参数校验 → 检查用户名唯一性 → BCrypt 加密密码（Hutool）→ MyBatis Plus 入库
2. **登录**：校验用户名/密码 → 生成 UUID Token → 存入 Redis（7 天过期）→ 返回 Token + 用户信息
3. **查询**：根据 ID 查用户信息（脱敏，不返回密码）
4. **登出**：从 Redis 删除 Token

**配置**：
```yaml
server.port: 8001
spring.datasource.url: jdbc:mysql://localhost:3306/ecommerce
spring.redis.host: localhost
spring.redis.port: 6379
spring.cloud.nacos.discovery.server-addr: localhost:8848
```

**依赖**：`ecommerce-common`, `spring-boot-starter-web`, `mybatis-plus`, `mysql-connector-j`, `spring-boot-starter-data-redis`, `nacos-discovery`, `nacos-config`, `spring-boot-starter-validation`, `spring-boot-starter-actuator`

---

#### 3.2.6 ecommerce-product（商品服务）

**端口**：8002  
**说明**：商品 CRUD、库存管理、Redis 缓存策略、乐观锁防超卖。

**核心组件**：

| 组件 | 类名 | 职责 |
|------|------|------|
| 启动类 | `ProductApplication.java` | `@SpringBootApplication` + `@EnableDiscoveryClient` |
| 控制器 | `ProductController.java` | RESTful 接口：商品 CRUD + `/products/{id}/stock` 库存操作 |
| 服务层 | `ProductService.java` | 业务逻辑：Cache-Aside 缓存策略、乐观锁扣减/恢复库存 |
| 数据层 | `ProductMapper.java` | MyBatis Plus BaseMapper，操作商品表 |
| 实体 | `Product.java` | 映射 `product` 表 |
| 配置 | `RedisConfig.java` | RedisTemplate 序列化配置 |

**缓存策略（Cache-Aside）**：
```
查询：先查 Redis → 未命中则查 MySQL → 回写 Redis（30 分钟 TTL）
更新：更新 MySQL → 删除 Redis 缓存
扣库存：乐观锁 (WHERE stock >= quantity) → 删除 Redis 缓存
```

**乐观锁防超卖**：
```java
boolean success = lambdaUpdate()
    .eq(Product::getId, id)
    .ge(Product::getStock, quantity)  // 乐观锁条件
    .setSql("stock = stock - " + quantity)
    .update();
```

**依赖**：`ecommerce-common`, `spring-boot-starter-web`, `mybatis-plus`, `mysql`, `redis`, `nacos-discovery`, `nacos-config`

---

#### 3.2.7 ecommerce-order（订单服务）

**端口**：8003  
**说明**：订单创建（含明细）、查询、取消、状态管理，通过 OpenFeign 调用商品服务扣减/恢复库存。

**核心组件**：

| 组件 | 类名 | 职责 |
|------|------|------|
| 启动类 | `OrderApplication.java` | `@SpringBootApplication` + `@EnableDiscoveryClient` + `@EnableFeignClients` |
| 控制器 | `OrderController.java` | RESTful 接口：订单 CRUD + `/orders/{id}/cancel` + `/orders/{id}/status` |
| 服务层 | `OrderService.java` | 核心订单逻辑：生成订单号、保存订单+明细、Feign 扣库存 |
| 服务层 | `OrderItemService.java` | 订单明细管理 |
| 数据层 | `OrderMapper.java` | MyBatis Plus BaseMapper，操作 `order_info` 表 |
| 数据层 | `OrderItemMapper.java` | MyBatis Plus BaseMapper，操作 `order_item` 表 |
| 实体 | `Order.java` | 映射 `order_info` 表 |
| 实体 | `OrderItem.java` | 映射 `order_item` 表 |
| Feign | `ProductFeignClient.java` | `@FeignClient(name = "ecommerce-product")`，调用商品服务扣减/恢复库存 |

**服务间调用**：`ecommerce-order` → `ecommerce-product`（扣减库存、恢复库存）

**依赖**：`ecommerce-common`, `spring-boot-starter-web`, `mybatis-plus`, `mysql`, `redis`, `nacos-discovery`, `nacos-config`, **`spring-cloud-starter-openfeign`**, **`spring-cloud-starter-alibaba-seata`**（当前禁用）, `spring-cloud-starter-loadbalancer`

---

#### 3.2.8 ecommerce-payment（支付服务）

**端口**：8004  
**说明**：支付创建、支付完成、支付查询，通过 OpenFeign 调用订单服务更新订单状态。

**核心组件**：

| 组件 | 类名 | 职责 |
|------|------|------|
| 启动类 | `PaymentApplication.java` | `@SpringBootApplication` + `@EnableDiscoveryClient` + `@EnableFeignClients` |
| 控制器 | `PaymentController.java` | RESTful 接口：支付 CRUD + `/payments/{id}/complete` |
| 服务层 | `PaymentService.java` | 支付逻辑：生成支付单号、保存支付、Feign 更新订单状态 |
| 数据层 | `PaymentMapper.java` | MyBatis Plus BaseMapper，操作 `payment` 表 |
| 实体 | `Payment.java` | 映射 `payment` 表 |
| Feign | `OrderFeignClient.java` | `@FeignClient(name = "ecommerce-order")`，调用订单服务更新订单状态 |

**服务间调用**：`ecommerce-payment` → `ecommerce-order`（更新订单状态）

**依赖**：`ecommerce-common`, `spring-boot-starter-web`, `mybatis-plus`, `mysql`, `redis`, `nacos-discovery`, `nacos-config`, **`spring-cloud-starter-openfeign`**, `spring-cloud-starter-loadbalancer`

---

#### 3.2.9 ecommerce-batch（批量任务服务）

**端口**：8010  
**说明**：基于 XXL-JOB 的分布式任务调度服务，支持商品数据的批量导入。

**核心组件**：

| 组件 | 类名 | 职责 |
|------|------|------|
| 启动类 | `BatchApplication.java` | `@SpringBootApplication` + `@EnableDiscoveryClient` |
| 配置 | `XxlJobConfig.java` | XXL-JOB 调度中心连接配置（admin.addresses, appname, accessToken） |
| 任务 | `DemoJobHandler.java` | 示例 Job（demoJobHandler），展示基础用法 |
| 任务 | `ProductImportJobHandler.java` | 商品批量导入 Job，支持**分片广播**并行处理 |
| 实体/DTO | `Product.java` | 商品实体（本地拷贝，不依赖 ecommerce-product） |
| 数据层 | `ProductMapper.java` | 批量写入商品数据 |

**XXL-JOB 任务说明**：
- `demoJobHandler`：Bean 模式示例任务
- `productImportJobHandler`：读取 txt 格式文件，按 `|+|` 分隔符解析商品数据，支持分片并行处理，批量入库（每批 500 条）

**依赖**：`ecommerce-common`, `spring-boot-starter-web`, **`xxl-job-core` (2.4.0)**, `mybatis-plus`, `mysql`, `nacos-discovery`, `lombok`

---

## 4. 整体架构图

```
                            ┌─────────────────────┐
                            │   浏览器 / 客户端     │
                            └──────────┬──────────┘
                                       │
                            localhost:3000 (Vite Dev Server)
                                       │
                            Vite Proxy: /api → localhost:9000
                                       │
                                       ▼
                      ┌─────────────────────────────────┐
                      │   API 网关 (ecommerce-gateway)     │
                      │   Spring Cloud Gateway :9000      │
                      │   StripPrefix=2 统一路由转发       │
                      └────────┬────────────┬─────────────┘
                               │            │
              ┌────────────────┼────────────┼────────────────┐
              │                │            │                │
              ▼                ▼            ▼                ▼
┌─────────────────┐ ┌─────────────────┐ ┌─────────────────┐ ┌─────────────────┐
│  ecommerce-user  │ │ ecommerce-product│ │ ecommerce-order  │ │ ecommerce-payment│
│     :8001        │ │     :8002        │ │     :8003        │ │     :8004        │
│  用户服务         │ │  商品服务         │ │  订单服务         │ │  支付服务         │
│ ─────────────── │ │ ─────────────── │ │ ─────────────── │ │ ─────────────── │
│ 注册/登录/Token  │ │ 商品CRUD/库存    │ │ 订单创建/取消    │ │ 支付创建/完成    │
│ BCrypt加密       │ │ Redis缓存       │ │ OpenFeign→商品  │ │ OpenFeign→订单  │
│ Redis会话       │ │ 乐观锁防超卖     │ │ Seata(待启用)   │ │                 │
└────────┬────────┘ └────────┬────────┘ └────────┬────────┘ └────────┬────────┘
         │                   │                   │                   │
         └───────────────────┴───────────────────┴───────────────────┘
                                    │
                    ┌───────────────┼───────────────┐
                    │               │               │
                    ▼               ▼               ▼
          ┌──────────────┐ ┌──────────────┐ ┌──────────────┐
          │  Nacos :8848  │ │ MySQL :3306  │ │ Redis :6379  │
          │  注册/配置中心 │ │  ecommerce   │ │  缓存/Token   │
          └──────────────┘ └──────────────┘ └──────────────┘

┌─────────────────────────────────────────────────────────────────┐
│                      辅助服务                                    │
│  ┌───────────────────────┐  ┌─────────────────────────────────┐ │
│  │  ecommerce-batch :8010 │  │  ecommerce-auth (待实现)         │ │
│  │  XXL-JOB 批量任务      │  │  Spring Security 认证授权        │ │
│  │  商品批量导入/分片并行  │  │                                 │ │
│  └───────────────────────┘  └─────────────────────────────────┘ │
└─────────────────────────────────────────────────────────────────┘
```

---

## 5. 数据库设计

### 5.1 数据库基本信息

| 属性 | 值 |
|------|-----|
| **数据库名** | `ecommerce` |
| **字符集** | `utf8mb4` |
| **引擎** | InnoDB |
| **表数量** | 5 张业务表 |

### 5.2 ER 关系图

```
  ┌──────────┐         ┌──────────────┐         ┌──────────────┐
  │   user   │ 1    n  │  order_info  │ 1    1  │   payment    │
  │          ├─────────►│              ├─────────►│              │
  │ id (PK)  │         │ id (PK)      │         │ id (PK)      │
  │ username │         │ order_no     │         │ payment_no   │
  │ password │         │ user_id (FK) │         │ order_id (FK)│
  │ nickname │         │ total_amount │         │ amount       │
  │ phone    │         │ status       │         │ status       │
  │ email    │         │ address      │         │ trans_id     │
  └──────────┘         └──────┬───────┘         └──────────────┘
                              │ 1
                              │
                              │ n
                       ┌──────┴───────┐
                       │  order_item  │        ┌──────────┐
                       │              │ n    1 │ product  │
                       │ id (PK)      ├────────►│          │
                       │ order_id(FK) │        │ id (PK)  │
                       │ product_id   │        │ name     │
                       │ product_name │        │ price    │
                       │ price        │        │ stock    │
                       │ quantity     │        │ status   │
                       │ total_amount │        └──────────┘
                       └──────────────┘
```

### 5.3 表结构详解

#### user（用户表）
| 字段 | 类型 | 约束 | 说明 |
|------|------|------|------|
| id | BIGINT | PK, AUTO_INCREMENT | 用户 ID |
| username | VARCHAR(50) | UNIQUE, NOT NULL | 用户名 |
| password | VARCHAR(255) | NOT NULL | BCrypt 加密密码 |
| nickname | VARCHAR(50) | — | 昵称 |
| phone | VARCHAR(20) | — | 手机号 |
| email | VARCHAR(100) | — | 邮箱 |
| avatar | VARCHAR(500) | — | 头像 URL |
| status | TINYINT | DEFAULT 1 | 0:禁用, 1:正常 |
| create_time | DATETIME | DEFAULT CURRENT_TIMESTAMP | 创建时间 |
| update_time | DATETIME | ON UPDATE CURRENT_TIMESTAMP | 更新时间 |
| deleted | TINYINT | DEFAULT 0 | 逻辑删除标记 |

#### product（商品表）
| 字段 | 类型 | 约束 | 说明 |
|------|------|------|------|
| id | BIGINT | PK, AUTO_INCREMENT | 商品 ID |
| name | VARCHAR(200) | NOT NULL | 商品名称 |
| description | TEXT | — | 商品描述 |
| price | DECIMAL(10,2) | NOT NULL | 商品单价 |
| stock | INT | DEFAULT 0 | 库存数量（乐观锁目标字段） |
| image_url | VARCHAR(500) | — | 商品图片 URL |
| status | TINYINT | DEFAULT 1 | 0:下架, 1:上架 |
| category_id | BIGINT | INDEX | 分类 ID |
| create_time | DATETIME | DEFAULT CURRENT_TIMESTAMP | 创建时间 |
| update_time | DATETIME | ON UPDATE CURRENT_TIMESTAMP | 更新时间 |
| deleted | TINYINT | DEFAULT 0 | 逻辑删除标记 |

#### order_info（订单表）
| 字段 | 类型 | 约束 | 说明 |
|------|------|------|------|
| id | BIGINT | PK, AUTO_INCREMENT | 订单 ID |
| order_no | VARCHAR(50) | UNIQUE, NOT NULL | 订单编号 |
| user_id | BIGINT | NOT NULL, INDEX | 用户 ID（外键） |
| total_amount | DECIMAL(10,2) | NOT NULL | 订单总金额 |
| status | TINYINT | DEFAULT 0 | 0:待支付, 1:已支付, 2:已取消 |
| address | VARCHAR(500) | — | 收货地址 |
| receiver | VARCHAR(50) | — | 收货人 |
| phone | VARCHAR(20) | — | 联系电话 |
| create_time | DATETIME | DEFAULT CURRENT_TIMESTAMP | 创建时间 |
| update_time | DATETIME | ON UPDATE CURRENT_TIMESTAMP | 更新时间 |
| deleted | TINYINT | DEFAULT 0 | 逻辑删除标记 |

#### order_item（订单明细表）
| 字段 | 类型 | 约束 | 说明 |
|------|------|------|------|
| id | BIGINT | PK, AUTO_INCREMENT | 明细 ID |
| order_id | BIGINT | NOT NULL, INDEX | 订单 ID（外键） |
| product_id | BIGINT | NOT NULL | 商品 ID |
| product_name | VARCHAR(200) | NOT NULL | 商品名称快照 |
| price | DECIMAL(10,2) | NOT NULL | 购买时单价 |
| quantity | INT | NOT NULL | 购买数量 |
| total_amount | DECIMAL(10,2) | NOT NULL | 小计金额 |
| create_time | DATETIME | DEFAULT CURRENT_TIMESTAMP | 创建时间 |
| update_time | DATETIME | ON UPDATE CURRENT_TIMESTAMP | 更新时间 |
| deleted | TINYINT | DEFAULT 0 | 逻辑删除标记 |

#### payment（支付表）
| 字段 | 类型 | 约束 | 说明 |
|------|------|------|------|
| id | BIGINT | PK, AUTO_INCREMENT | 支付 ID |
| payment_no | VARCHAR(50) | UNIQUE, NOT NULL | 支付单号 |
| order_id | BIGINT | NOT NULL, INDEX | 关联订单 ID |
| amount | DECIMAL(10,2) | NOT NULL | 支付金额 |
| status | TINYINT | DEFAULT 0 | 0:待支付, 1:已支付 |
| payment_method | VARCHAR(20) | — | 支付方式 |
| transaction_id | VARCHAR(100) | — | 第三方交易流水号 |
| create_time | DATETIME | DEFAULT CURRENT_TIMESTAMP | 创建时间 |
| update_time | DATETIME | ON UPDATE CURRENT_TIMESTAMP | 更新时间 |
| deleted | TINYINT | DEFAULT 0 | 逻辑删除标记 |

---

## 6. 核心业务流程详解

### 6.1 用户注册流程

```
客户端 → Gateway → ecommerce-user: /users/register
  1. @Valid 参数校验 (UserRegisterDTO)
  2. 查询 username 是否已存在
  3. 存在 → 抛出 BusinessException("用户名已存在")
  4. 不存在 → Hutool BCrypt.hashpw() 加密密码
  5. MyBatis Plus save() 入库
  6. 返回 Result.success()
```

### 6.2 用户登录流程

```
客户端 → Gateway → ecommerce-user: /users/login
  1. 根据 username 查询用户
  2. 不存在 → 抛出 BusinessException("用户名或密码错误")
  3. BCrypt.checkpw() 校验密码
  4. 失败 → 抛出 BusinessException("用户名或密码错误")
  5. 成功 → UUID.randomUUID() 生成 Token
  6. Redis SET token → userInfo JSON, EXPIRE 7天
  7. 返回 Result.success(UserLoginVO { token, userInfo })
```

### 6.3 商品购买（创建订单）流程

```
客户端 → Gateway → ecommerce-order: /orders
  1. 生成唯一订单号 (UUID + 时间戳)
  2. 保存 order_info 记录
  3. 遍历商品列表，保存 order_item 记录
  4. Feign 调用 ecommerce-product: POST /products/{id}/stock?quantity=-{n}
     ├── 乐观锁: WHERE stock >= quantity
     ├── SQL: stock = stock - quantity
     └── 失败 → 抛出 BusinessException("库存不足")
  5. 计算并更新 total_amount
  6. 返回订单信息
```

### 6.4 订单取消流程

```
客户端 → Gateway → ecommerce-order: POST /orders/{id}/cancel
  1. 查询订单，校验状态（只能取消待支付订单）
  2. 更新 status = 2（已取消）
  3. Feign 调用 ecommerce-product 恢复库存（正数扣减）
  4. 返回成功
```

### 6.5 支付完成流程

```
客户端 → Gateway → ecommerce-payment: POST /payments/{id}/complete
  1. 查询支付记录
  2. 更新 payment.status = 1（已支付）
  3. Feign 调用 ecommerce-order: PUT /orders/{id}/status?status=1
     └── ecommerce-order 更新 order_info.status = 1（已支付）
  4. 返回成功
```

### 6.6 商品批量导入流程

```
XXL-JOB 调度中心 → ecommerce-batch: productImportJobHandler
  1. 获取分片参数 (shardIndex / shardTotal)
  2. 读取 txt 文件，按 |+| 分隔符解析行数据
  3. 按分片过滤：仅处理 shardIndex 对应的数据行
  4. 每 500 条批量 insert
  5. 返回执行结果
```

---

## 7. 服务间通信架构

### 7.1 通信方式总览

| 通信方向 | 方式 | 说明 |
|----------|------|------|
| 前端 → 后端 | HTTP REST | 通过 Vite Proxy + Gateway 转发 |
| Gateway → 微服务 | HTTP 路由转发 | 统一入口、StripPrefix 路径重写 |
| Order → Product | OpenFeign | `ProductFeignClient.updateStock()` 扣减/恢复库存 |
| Payment → Order | OpenFeign | `OrderFeignClient.updateOrderStatus()` 更新订单状态 |
| 微服务 → Nacos | gRPC/HTTP | 服务注册、心跳上报（端口 8848） |
| 微服务 → MySQL | JDBC | MyBatis Plus 直连（端口 3306） |
| 微服务 → Redis | RESP 协议 | Spring Data Redis（端口 6379） |
| XXL-JOB → Batch | HTTP | 调度中心远程调用执行器（端口 8010） |

### 7.2 OpenFeign 接口定义

**ecommerce-order 中的 ProductFeignClient**：
```java
@FeignClient(name = "ecommerce-product")
public interface ProductFeignClient {
    @PostMapping("/products/{id}/stock")
    Result<Void> updateStock(@PathVariable("id") Long id, 
                             @RequestParam("quantity") Integer quantity);
}
```

**ecommerce-payment 中的 OrderFeignClient**：
```java
@FeignClient(name = "ecommerce-order")
public interface OrderFeignClient {
    @PutMapping("/orders/{id}/status")
    Result<Void> updateOrderStatus(@PathVariable("id") Long id,
                                    @RequestParam("status") Integer status);
}
```

### 7.3 Gateway 路由配置

```yaml
spring:
  cloud:
    gateway:
      routes:
        - id: user-service
          uri: http://127.0.0.1:8001
          predicates: [Path=/api/user/**]
          filters: [StripPrefix=2]

        - id: product-service
          uri: http://127.0.0.1:8002
          predicates: [Path=/api/product/**]
          filters: [StripPrefix=2]

        - id: order-service
          uri: lb://ecommerce-order          # 通过 Nacos 负载均衡
          predicates: [Path=/api/order/**]
          filters: [StripPrefix=2]

        - id: payment-service
          uri: lb://ecommerce-payment        # 通过 Nacos 负载均衡
          predicates: [Path=/api/payment/**]
          filters: [StripPrefix=2]
```

### 7.4 前端 API 请求流

```javascript
// Axios baseURL = '/api'
// Vite Proxy: /api → http://localhost:9000
// Gateway StripPrefix=2: /api/user/users/login → /users/login

// 请求示例
POST /api/user/users/login  → Gateway → ecommerce-user:8001/users/login
POST /api/product/products  → Gateway → ecommerce-product:8002/products
POST /api/order/orders      → Gateway → lb://ecommerce-order/orders
POST /api/payment/payments  → Gateway → lb://ecommerce-payment/payments
```

---

## 8. 前端项目结构

### 8.1 目录结构

```
ecommerce-frontend/
├── index.html                         # Vite HTML 入口
├── package.json                       # 依赖与脚本
├── vite.config.js                     # Vite 配置（端口3000, /api 代理→9000）
├── src/
│   ├── main.js                        # Vue 应用入口（挂载 App/Pinia/Router/ElementPlus）
│   ├── App.vue                        # 根组件（Header + router-view + Footer）
│   ├── Login.vue                      # 登录页
│   ├── Register.vue                   # 注册页
│   ├── api/                           # API 接口层
│   │   ├── user.js                    # 登录/注册/获取用户信息
│   │   ├── product.js                 # 商品列表/详情/更新库存
│   │   ├── order.js                   # 订单 CRUD/取消/状态更新
│   │   └── payment.js                 # 支付创建/完成/查询
│   ├── components/                    # 公共组件
│   │   ├── Header.vue                 # 顶部导航栏
│   │   ├── Footer.vue                 # 页脚
│   │   └── ProductCard.vue            # 商品卡片组件
│   ├── router/index.js                # 路由配置（懒加载）
│   ├── stores/                        # Pinia 状态管理
│   │   ├── user.js                    # 用户状态（token/userInfo/login/logout/register）
│   │   ├── product.js                 # 商品状态
│   │   └── order.js                   # 订单状态
│   ├── utils/
│   │   ├── request.js                 # Axios 封装（拦截器：注入 Token/统一错误处理）
│   │   ├── validate.js                # 前端表单验证工具
│   │   └── mock.js                    # Mock 数据
│   └── views/
│       ├── home/Index.vue             # 首页（轮播+商品推荐+数据统计 ECharts）
│       ├── products/List.vue          # 商品列表页（搜索/筛选/分页）
│       └── cart/Index.vue             # 购物车页
└── backup/                            # 旧版完整页面备份（含订单/支付/用户中心等）
```

### 8.2 前端路由表

| 路径 | 组件 | 说明 | 权限 |
|------|------|------|------|
| `/` | `views/home/Index.vue` | 首页 | 公开 |
| `/login` | `Login.vue` | 登录页 | 公开 |
| `/register` | `Register.vue` | 注册页 | 公开 |
| `/products` | `views/products/List.vue` | 商品列表 | 公开 |
| `/cart` | `views/cart/Index.vue` | 购物车 | 需登录 |

### 8.3 Pinia 状态管理

**user Store**：管理用户登录态
- `state`: token, userInfo
- `actions`: login(username, password), register(...), logout(), fetchUserInfo()

**product Store**：管理商品列表
- `state`: products[], loading, total
- `actions`: fetchProducts(params)

**order Store**：管理订单
- `state`: orders[], currentOrder
- `actions`: createOrder(...), cancelOrder(id), fetchOrders(...)

---

## 9. 关键技术实现

### 9.1 MyBatis Plus 逻辑删除

所有业务表通过 `deleted` 字段实现逻辑删除，BaseEntity 配置：
```java
@TableLogic
private Integer deleted;  // 0:正常, 1:已删除
```

### 9.2 统一响应格式

```json
{
  "code": 200,
  "message": "操作成功",
  "data": { ... }
}
```

### 9.3 全局异常处理

`GlobalExceptionHandler` 使用 `@RestControllerAdvice` 统一拦截：
- `BusinessException` → 返回业务错误码和消息
- `MethodArgumentNotValidException` → 返回参数校验失败详情
- `Exception` → 返回通用 500 错误

### 9.4 Redis 缓存策略

| 场景 | Key 格式 | TTL | 策略 |
|------|----------|-----|------|
| 用户 Token | `token:{uuid}` | 7 天 | 登录写入，登出删除 |
| 商品详情 | `product:{id}` | 30 分钟 | Cache-Aside：查询回写，更新删除 |
| 商品列表 | `product:list:{page}:{size}` | 30 分钟 | Cache-Aside |

### 9.5 乐观锁库存扣减（防超卖）

```java
// ProductService.java 核心代码
public void updateStock(Long id, Integer quantity) {
    boolean success = lambdaUpdate()
        .eq(Product::getId, id)
        .ge(Product::getStock, Math.abs(quantity))  // 乐观锁条件
        .setSql("stock = stock + " + quantity)       // quantity 为负数即扣减
        .update();
    if (!success) {
        throw new BusinessException(ResultCode.STOCK_INSUFFICIENT);
    }
    // 删除缓存
    redisTemplate.delete(PRODUCT_CACHE_PREFIX + id);
}
```

---

## 10. 部署与运行

### 10.1 基础设施依赖

| 服务 | 端口 | 用途 | 部署方式 |
|------|------|------|----------|
| Nacos Server | 8848 | 服务注册发现/配置中心 | 独立部署 |
| MySQL | 3306 | 数据库 | 独立部署 |
| Redis | 6379 | 缓存/会话 | 独立部署 |
| XXL-JOB Admin | 8080 | 任务调度管理平台 | 独立部署 |

### 10.2 微服务端口分配

| 服务 | 端口 | 健康检查端点 |
|------|------|-------------|
| ecommerce-gateway | 9000 | — |
| ecommerce-user | 8001 | /actuator/health |
| ecommerce-product | 8002 | — |
| ecommerce-order | 8003 | — |
| ecommerce-payment | 8004 | — |
| ecommerce-batch | 8010 | — |
| ecommerce-registry | 8849 | — |
| 前端 Vite Dev | 3000 | — |

### 10.3 启动顺序

```
1. Nacos Server (8848)
2. MySQL (3306) + Redis (6379)
3. ecommerce-gateway (9000)
4. ecommerce-user (8001)
5. ecommerce-product (8002)
6. ecommerce-order (8003)
7. ecommerce-payment (8004)
8. ecommerce-batch (8010) — 可选
9. npm run dev (3000) — 前端
```

---

## 11. 当前状态与待完成工作

### 11.1 已完成
- [x] 项目骨架搭建（父 POM、9 个子模块）
- [x] 公共模块（统一响应、异常处理、基础实体）
- [x] 用户服务（注册、登录、Token 管理）
- [x] 商品服务（CRUD、缓存、乐观锁库存扣减）
- [x] 订单服务（创建、查询、取消、Feign 调商品服务）
- [x] 支付服务（创建、完成、Feign 调订单服务）
- [x] API 网关（路由转发、StripPrefix）
- [x] XXL-JOB 批量任务（商品批量导入）
- [x] 前端（Vue 3 + Element Plus 基础页面）
- [x] 数据库设计（5 张表 + 初始化 SQL + 测试数据）

### 11.2 待完成
- [ ] **ecommerce-auth**：Spring Security 认证授权逻辑实现
- [ ] **Seata 分布式事务**：已引入依赖但 `seata.enabled: false`，需配置启用
- [ ] **Nacos 配置中心**：已配置但 `nacos.config.enabled: false`，当前仍使用本地 yml
- [ ] **Sentinel 熔断降级**：尚未引入
- [ ] **消息队列**：RocketMQ 异步解耦（订单创建通知、库存同步等）
- [ ] **链路追踪**：Spring Cloud Sleuth + Zipkin
- [ ] **前端页面完善**：购物车、订单管理、用户中心等页面（部分在 backup/ 中有旧版）
- [ ] **API 文档**：集成 Swagger/Knife4j
- [ ] **单元测试**：各模块测试用例

---

## 12. 技术亮点总结

| 亮点 | 实现方式 | 所在模块 |
|------|----------|----------|
| **微服务架构** | Spring Cloud Alibaba + Nacos | 全局 |
| **统一 API 网关** | Spring Cloud Gateway 路由 + StripPrefix | ecommerce-gateway |
| **声明式服务调用** | OpenFeign + LoadBalancer | ecommerce-order, ecommerce-payment |
| **并发库存控制** | 数据库乐观锁 `WHERE stock >= quantity` | ecommerce-product |
| **缓存加速** | Redis Cache-Aside 策略（30 分钟 TTL） | ecommerce-product |
| **统一响应格式** | Result<T> + ResultCode 枚举 | ecommerce-common |
| **全局异常处理** | @RestControllerAdvice | ecommerce-common |
| **Token 会话管理** | UUID Token + Redis（7 天过期） | ecommerce-user |
| **密码安全** | BCrypt 加密（Hutool 实现） | ecommerce-user |
| **分布式任务** | XXL-JOB 分片广播并行处理 | ecommerce-batch |
| **前端响应式** | Vue 3 Composition API + Pinia + Element Plus | ecommerce-frontend |
| **逻辑删除** | MyBatis Plus @TableLogic | 所有模块 |
| **前后端分离** | Vite 开发服务器代理 + Gateway 路由 | 全局 |

---

> 文档生成时间：2026-05-31  
> 项目根路径：`/Users/zyq/IdeaProjects/TestProject`
