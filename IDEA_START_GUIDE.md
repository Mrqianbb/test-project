# 🚀 使用IntelliJ IDEA启动项目

## ✅ 当前状态

- ✓ Java 1.8 已安装
- ✓ MySQL 8.0.30 正在运行
- ✓ Redis 正在运行
- ✓ Maven Wrapper 已配置
- ✓ 项目代码已修复

## 📝 启动步骤（5步完成）

### 步骤1：打开项目

1. 打开IntelliJ IDEA
2. File → Open → 选择 `/Users/zyq/IdeaProjects/TestProject`
3. 等待IDEA导入项目（首次可能需要几分钟）

### 步骤2：等待Maven同步

- IDEA会自动开始下载依赖
- 在右下角可以看到进度条
- 首次同步需要10-15分钟
- 等待显示"Build Success"

### 步骤3：下载并启动Nacos

**新开一个终端窗口：**

```bash
# 下载Nacos（首次需要）
cd /tmp
curl -O https://github.com/alibaba/nacos/releases/download/2.2.3/nacos-server-2.2.3.tar.gz
tar -xzf nacos-server-2.2.3.tar.gz
mv nacos ~/nacos

# 启动Nacos
cd ~/nacos/bin
./startup.sh -m standalone

# 验证Nacos启动成功
curl http://localhost:8848/nacos
# 访问控制台: http://localhost:8848/nacos
# 用户名: nacos
# 密码: nacos
```

### 步骤4：初始化数据库

```bash
# 检查数据库密码
mysql -u root -e "SELECT 1;"

# 如果没有密码
mysql -u root < /Users/zyq/IdeaProjects/TestProject/sql/init.sql

# 如果有密码（请替换your_password）
mysql -u root -pyour_password < /Users/zyq/IdeaProjects/TestProject/sql/init.sql
```

**注意：** 如果数据库密码不是root，需要修改配置文件：
- `ecommerce-user/src/main/resources/application.yml`
- `ecommerce-product/src/main/resources/application.yml`
- `ecommerce-order/src/main/resources/application.yml`
- `ecommerce-payment/src/main/resources/application.yml`

将 `password: root` 改为你的实际密码。

### 步骤5：在IDEA中启动服务

**启动顺序很重要，按以下顺序启动：**

#### 1. 启动API网关（ecommerce-gateway）
1. 在IDEA左侧项目树中找到 `ecommerce-gateway`
2. 展开 `src/main/java/com/ecommerce/gateway`
3. 找到主类（包含 `@SpringBootApplication` 的类）
4. 右键 → Run 'GatewayApplication'

#### 2. 启动用户服务（ecommerce-user）
1. 在IDEA左侧项目树中找到 `ecommerce-user`
2. 展开 `src/main/java/com/ecommerce/user`
3. 找到主类
4. 右键 → Run 'UserApplication'

#### 3. 启动商品服务（ecommerce-product）
1. 在IDEA左侧项目树中找到 `ecommerce-product`
2. 展开 `src/main/java/com/ecommerce/product`
3. 找到主类
4. 右键 → Run 'ProductApplication'

#### 4. 启动订单服务（ecommerce-order）
1. 在IDEA左侧项目树中找到 `ecommerce-order`
2. 展开 `src/main/java/com/ecommerce/order`
3. 找到主类
4. 右键 → Run 'OrderApplication'

#### 5. 启动支付服务（ecommerce-payment）
1. 在IDEA左侧项目树中找到 `ecommerce-payment`
2. 展开 `src/main/java/com/ecommerce/payment`
3. 找到主类
4. 右键 → Run 'PaymentApplication'

## ✅ 验证启动成功

### 检查Nacos控制台
- 访问：http://localhost:8848/nacos
- 登录：nacos/nacos
- 点击"服务管理" → "服务列表"
- 应该看到以下服务：
  - ecommerce-gateway
  - ecommerce-user
  - ecommerce-product
  - ecommerce-order
  - ecommerce-payment

### 测试API

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

## 🛠️ 故障排查

### Maven依赖下载失败
- 检查网络连接
- 配置阿里云镜像（已自动配置）
- 尝试刷新Maven：右键项目 → Maven → Reload Project

### MySQL连接失败
- 检查MySQL是否运行：`sudo /usr/local/mysql-8.0.30-macos12-x86_64/support-files/mysql.server status`
- 检查密码配置
- 修改application.yml中的数据库密码

### Nacos连接失败
- 检查Nacos是否运行：`curl http://localhost:8848/nacos`
- 查看Nacos日志：`tail -f ~/nacos/logs/start.out`
- 重新启动Nacos：`cd ~/nacos/bin && ./shutdown.sh && ./startup.sh -m standalone`

### 端口冲突
- 检查端口占用：`lsof -i :9000`
- 修改application.yml中的server.port
- 杀掉占用端口的进程：`kill -9 <PID>`

## 📊 服务端口列表

| 服务 | 端口 | 说明 |
|------|------|------|
| Nacos Server | 8848 | 服务注册中心 |
| API网关 | 9000 | 统一入口 |
| 用户服务 | 8001 | 用户管理 |
| 商品服务 | 8002 | 商品管理 |
| 订单服务 | 8003 | 订单管理 |
| 支付服务 | 8004 | 支付管理 |

## 💡 提示

1. **启动顺序很重要**：先启动Nacos，再启动各个微服务
2. **查看日志**：在IDEA的Run窗口可以查看每个服务的日志
3. **多服务运行**：IDEA可以同时运行多个服务，每个服务有自己的Run窗口
4. **热重载**：开发时可以使用Spring DevTools实现热重载

## 🎯 成功标志

当所有服务启动成功后：
- IDEA中会有5个Run窗口（每个服务一个）
- 所有窗口都显示启动成功，无ERROR日志
- Nacos控制台显示5个服务已注册
- 所有端口都可以正常访问

## ⏱️ 预计时间

- IDEA打开项目：1-2分钟
- Maven下载依赖：10-15分钟（首次）
- 下载Nacos：2-3分钟（首次）
- 启动各服务：2-3分钟
- **总计：15-23分钟**

## 🎉 开始启动吧！

现在按照上述步骤，在IDEA中打开项目并启动服务！

详细问题请参考：`FINAL_START_GUIDE.md`
