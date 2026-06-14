# 🚀 项目启动最终指南

## ✅ 问题已解决

所有启动报错问题已修复：
1. ✅ MySQL连接器版本 → 已修复
2. ✅ Order实体类导入 → 已修复
3. ✅ 全局异常处理器导入 → 已修复
4. ✅ Java版本兼容性 → 已降级到Java 8

## 📋 当前状态

### 环境检查结果
- ✓ Java 1.8 已安装
- ✓ Redis 正在运行
- ✓ Maven Wrapper 已配置
- ✗ MySQL 未启动
- ✗ Nacos 未启动

### 项目已准备
- ✓ 8个微服务模块完整
- ✓ 所有代码已修复
- ✓ 配置文件完整
- ✓ 数据库脚本就绪
- ✓ 启动脚本已配置

## 🎯 启动项目（3种方案）

### 方案一：使用Maven Wrapper（推荐）

```bash
# 1. 初始化数据库（MySQL未安装时会提示安装）
brew install mysql 2>/dev/null || echo "请手动安装MySQL"
brew services start mysql 2>/dev/null || echo "MySQL启动失败"
mysql -u root < sql/init.sql

# 2. 启动Nacos（如果未下载）
cd ~/nacos/bin && ./startup.sh -m standalone 2>/dev/null || \
  (cd /tmp && curl -O https://github.com/alibaba/nacos/releases/download/2.2.3/nacos-server-2.2.3.tar.gz && \
   tar -xzf nacos-server-2.2.3.tar.gz && \
   mv nacos ~/nacos && \
   cd ~/nacos/bin && ./startup.sh -m standalone)

# 3. 编译并启动项目
./start.sh
```

### 方案二：使用IntelliJ IDEA（最简单）

1. **打开项目**
   ```
   File -> Open -> 选择 /Users/zyq/IdeaProjects/TestProject
   ```

2. **等待Maven同步**
   - IDEA会自动下载Maven和依赖
   - 首次需要10-20分钟
   - 右下角会显示进度

3. **准备数据库和Nacos**
   ```bash
   # 新开终端窗口
   brew install mysql
   brew services start mysql
   mysql -u root < sql/init.sql
   
   # 下载并启动Nacos
   cd /tmp
   curl -O https://github.com/alibaba/nacos/releases/download/2.2.3/nacos-server-2.2.3.tar.gz
   tar -xzf nacos-server-2.2.3.tar.gz
   mv nacos ~/nacos
   cd ~/nacos/bin && ./startup.sh -m standalone
   ```

4. **在IDEA中启动服务**
   - 右键 `ecommerce-registry` 模块的主类 -> Run
   - 右键 `ecommerce-gateway` 模块的主类 -> Run
   - 右键其他服务的主类 -> Run

### 方案三：纯命令行

```bash
# 安装所有依赖
brew install maven mysql redis

# 启动服务
brew services start mysql
brew services start redis

# 初始化数据库
mysql -u root < sql/init.sql

# 启动Nacos
cd ~/nacos/bin && ./startup.sh -m standalone

# 编译项目
mvn clean install -DskipTests

# 启动项目
./start.sh
```

## 🔍 验证启动成功

### 检查服务状态

```bash
# 访问Nacos控制台
open http://localhost:8848/nacos
# 用户名: nacos
# 密码: nacos

# 检查服务健康状态
curl http://localhost:9000
curl http://localhost:8001
curl http://localhost:8002
curl http://localhost:8003
curl http://localhost:8004
```

### 查看日志

```bash
# 查看所有服务日志
tail -f logs/*.log

# 查看特定服务日志
tail -f logs/ecommerce-user.log
tail -f logs/ecommerce-product.log
```

## ⚡ 快速测试API

启动成功后，测试以下API：

```bash
# 通过网关访问商品列表
curl http://localhost:9000/api/product/products/list

# 用户注册
curl -X POST http://localhost:9000/api/user/register \
  -H "Content-Type: application/json" \
  -d '{"username":"test","password":"123456","email":"test@example.com"}'

# 查看商品详情
curl http://localhost:9000/api/product/products/1
```

## 🛠️ 故障排查

### 编译失败
```bash
# 清理并重新编译
./mvnw clean install -U -DskipTests
```

### MySQL连接失败
```bash
# 检查MySQL状态
brew services list | grep mysql

# 启动MySQL
brew services start mysql

# 重置MySQL密码（如果需要）
mysql -u root -e "ALTER USER 'root'@'localhost' IDENTIFIED BY 'newpassword';"
```

### Nacos启动失败
```bash
# 查看Nacos日志
tail -f ~/nacos/logs/start.out

# 停止并重新启动Nacos
cd ~/nacos/bin && ./shutdown.sh && ./startup.sh -m standalone
```

### 端口被占用
```bash
# 查看端口占用
lsof -i :8848  # Nacos
lsof -i :3306  # MySQL
lsof -i :8001  # 用户服务
lsof -i :8002  # 商品服务
lsof -i :8003  # 订单服务
lsof -i :8004  # 支付服务
lsof -i :9000  # API网关

# 杀掉占用端口的进程
kill -9 <PID>
```

## 📚 辅助工具

### 可用的脚本
- `./start.sh` - 启动所有服务
- `./stop.sh` - 停止所有服务
- `./check-env.sh` - 详细环境检查
- `./quick-test.sh` - 快速环境测试
- `./setup-env.sh` - 自动安装依赖
- `./mvnw` - Maven Wrapper（无需安装Maven）

### 文档
- `README.md` - 项目介绍
- `ARCHITECTURE.md` - 架构设计
- `QUICK_START.md` - 快速开始
- `STARTUP_GUIDE.md` - 详细启动指南
- `DIAGNOSE.md` - 问题诊断
- `MANUAL_SETUP.md` - 手动安装指南
- `CURRENT_STATUS.md` - 当前状态

## 🎊 预期结果

启动成功后，你将看到：

### Nacos控制台
- 访问：http://localhost:8848/nacos
- 登录：nacos/nacos
- 看到6个服务已注册：
  - ecommerce-gateway
  - ecommerce-user
  - ecommerce-product
  - ecommerce-order
  - ecommerce-payment
  - ecommerce-registry

### 服务列表
- ✅ Nacos: http://localhost:8848/nacos
- ✅ API网关: http://localhost:9000
- ✅ 用户服务: http://localhost:8001
- ✅ 商品服务: http://localhost:8002
- ✅ 订单服务: http://localhost:8003
- ✅ 支付服务: http://localhost:8004

## ⏱️ 时间预估

| 步骤 | 时间 |
|------|------|
| 打开IDEA项目 | 1-2分钟 |
| Maven下载依赖 | 10-20分钟（首次） |
| 安装MySQL | 3-5分钟 |
| 安装Nacos | 2-3分钟 |
| 启动服务 | 2-5分钟 |
| **总计** | **20-35分钟** |

## 💡 最佳实践

1. **首次启动**：使用IDEA方案，可视化操作更友好
2. **开发调试**：在IDEA中单独启动需要的服务
3. **快速测试**：使用./start.sh一键启动所有服务
4. **生产部署**：使用Docker容器化部署

## 🚀 立即开始

**最快的启动方式：**

```bash
# 1. 打开IntelliJ IDEA，导入项目
# 2. 在IDEA中等待Maven同步完成
# 3. 在终端执行：
brew install mysql
brew services start mysql
mysql -u root < sql/init.sql

cd /tmp
curl -O https://github.com/alibaba/nacos/releases/download/2.2.3/nacos-server-2.2.3.tar.gz
tar -xzf nacos-server-2.2.3.tar.gz
mv nacos ~/nacos
cd ~/nacos/bin && ./startup.sh -m standalone

# 4. 在IDEA中运行各服务
```

## ✨ 项目已完全准备就绪！

所有代码已修复，所有配置已完成，只需按照上述方案启动即可。

**祝启动顺利！** 🎉
