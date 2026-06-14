# 🚀 项目完整启动指南

## ✅ 已完成的配置

- ✓ Java 1.8 已安装
- ✓ MySQL 8.0.30 正在运行（端口3306）
- ✓ Redis 正在运行（端口6379）
- ✓ 数据库密码已配置：root/mysql12345
- ✓ 数据库已初始化
- ✓ 所有服务配置文件已更新
- ✓ Maven Wrapper 已配置

## 📝 完整启动步骤（5步）

### 步骤1：启动Nacos

**新开一个终端窗口：**

```bash
# 方式1：使用下载脚本
cd /Users/zyq/IdeaProjects/TestProject
./download-nacos.sh

# 方式2：手动下载
cd /tmp
curl -L -o nacos-server-2.2.3.tar.gz https://github.com/alibaba/nacos/releases/download/2.2.3/nacos-server-2.2.3.tar.gz
tar -xzf nacos-server-2.2.3.tar.gz
mv nacos ~/nacos

# 启动Nacos
cd ~/nacos/bin
./startup.sh -m standalone

# 验证Nacos启动
curl http://localhost:8848/nacos
# 或在浏览器访问: http://localhost:8848/nacos
# 用户名: nacos
# 密码: nacos
```

### 步骤2：打开项目（使用IntelliJ IDEA）

1. 打开IntelliJ IDEA
2. File → Open → 选择 `/Users/zyq/IdeaProjects/TestProject`
3. 等待IDEA导入项目
4. 等待Maven同步完成（首次需要10-15分钟）
   - 在右下角可以看到进度
   - 等待显示"Build Success"

### 步骤3：验证Nacos

在浏览器访问：http://localhost:8848/nacos
- 用户名：nacos
- 密码：nacos
- 应该看到Nacos控制台

### 步骤4：在IDEA中启动服务

**按以下顺序启动各服务：**

#### 1. API网关（ecommerce-gateway）
- 在项目树中找到 `ecommerce-gateway/src/main/java/com/ecommerce/gateway/`
- 找到主类（包含 `@SpringBootApplication`）
- 右键 → Run 'GatewayApplication'

#### 2. 用户服务（ecommerce-user）
- 在项目树中找到 `ecommerce-user/src/main/java/com/ecommerce/user/`
- 找到主类
- 右键 → Run 'UserApplication'

#### 3. 商品服务（ecommerce-product）
- 在项目树中找到 `ecommerce-product/src/main/java/com/ecommerce/product/`
- 找到主类
- 右键 → Run 'ProductApplication'

#### 4. 订单服务（ecommerce-order）
- 在项目树中找到 `ecommerce-order/src/main/java/com/ecommerce/order/`
- 找到主类
- 右键 → Run 'OrderApplication'

#### 5. 支付服务（ecommerce-payment）
- 在项目树中找到 `ecommerce-payment/src/main/java/com/ecommerce/payment/`
- 找到主类
- 右键 → Run 'PaymentApplication'

**提示：** 每个服务启动后会创建一个新的Run窗口，你可以在这些窗口中查看日志。

### 步骤5：验证启动成功

#### 1. 检查Nacos控制台
- 访问：http://localhost:8848/nacos
- 登录：nacos/nacos
- 点击"服务管理" → "服务列表"
- 应该看到以下5个服务已注册：
  - ecommerce-gateway
  - ecommerce-user
  - ecommerce-product
  - ecommerce-order
  - ecommerce-payment

#### 2. 测试API

```bash
# 测试网关
curl http://localhost:9000

# 测试用户服务
curl http://localhost:8001

# 测试商品服务
curl http://localhost:8002

# 测试订单服务
curl http://localhost:8003

# 测试支付服务
curl http://localhost:8004
```

## 🛠️ 可用脚本

```bash
# 下载并启动Nacos
./download-nacos.sh

# 快速启动
./quick-start.sh

# 停止所有服务
./stop.sh

# 环境检查
./check-env.sh
```

## 📊 服务端口列表

| 服务 | 端口 | 用途 |
|------|------|------|
| Nacos Server | 8848 | 服务注册中心 |
| API网关 | 9000 | 统一入口 |
| 用户服务 | 8001 | 用户管理 |
| 商品服务 | 8002 | 商品管理 |
| 订单服务 | 8003 | 订单管理 |
| 支付服务 | 8004 | 支付管理 |
| MySQL | 3306 | 数据库 |
| Redis | 6379 | 缓存 |

## 🔧 故障排查

### Maven同步失败
- 检查网络连接
- 右键项目 → Maven → Reload Project
- 尝试清除缓存：File → Invalidate Caches → Invalidate and Restart

### 数据库连接失败
- 检查MySQL是否运行
- 检查密码配置（已设置为mysql12345）
- 查看服务日志中的错误信息

### Nacos连接失败
```bash
# 检查Nacos是否运行
curl http://localhost:8848/nacos

# 查看Nacos日志
tail -f ~/nacos/logs/start.out

# 重启Nacos
cd ~/nacos/bin
./shutdown.sh
./startup.sh -m standalone
```

### 服务启动失败
- 查看IDEA的Run窗口中的错误信息
- 确保Nacos正在运行
- 确保MySQL正在运行
- 检查端口是否被占用：`lsof -i :9000`

### 端口冲突
```bash
# 查看端口占用
lsof -i :8848  # Nacos
lsof -i :3306  # MySQL
lsof -i :6379  # Redis
lsof -i :9000  # 网关
lsof -i :8001  # 用户服务
lsof -i :8002  # 商品服务
lsof -i :8003  # 订单服务
lsof -i :8004  # 支付服务

# 杀掉占用端口的进程
kill -9 <PID>
```

## 💡 提示

1. **启动顺序**：先启动Nacos，再启动各个微服务
2. **等待时间**：首次启动Nacos需要2-3分钟，各服务启动需要30秒-1分钟
3. **查看日志**：在IDEA的Run窗口中可以查看每个服务的日志
4. **多服务运行**：IDEA可以同时运行5个服务，每个服务有自己的Run窗口
5. **热重载**：开发时可以使用Spring DevTools实现热重载（需配置）

## 🧪 测试API示例

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

## ⏱️ 时间预估

| 步骤 | 时间 |
|------|------|
| 下载Nacos（首次） | 2-3分钟 |
| 启动Nacos | 1-2分钟 |
| 打开IDEA项目 | 1-2分钟 |
| Maven同步（首次） | 10-15分钟 |
| 启动各服务 | 2-3分钟 |
| **总计** | **16-25分钟** |

## 🎯 成功标志

当所有服务启动成功后：
- ✅ IDEA中有5个Run窗口，都显示启动成功
- ✅ 所有Run窗口中无ERROR日志
- ✅ Nacos控制台显示5个服务已注册
- ✅ 所有端口都可以正常访问
- ✅ curl测试返回正常响应

## 📚 相关文档

- `IDEA_START_GUIDE.md` - IDEA启动详细指南
- `FINAL_START_GUIDE.md` - 完整启动指南
- `README.md` - 项目介绍
- `ARCHITECTURE.md` - 架构设计

## ✨ 开始启动吧！

1. 在终端运行 `./download-nacos.sh` 启动Nacos
2. 在IDEA中打开项目
3. 等待Maven同步完成
4. 依次启动5个服务
5. 访问Nacos控制台验证

**项目已完全准备就绪，现在可以开始启动了！** 🎉
