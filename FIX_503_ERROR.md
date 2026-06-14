# 503错误修复指南

## 问题原因

**根本原因**：服务注册到Nacos时使用了实际网络IP（192.168.124.5），但Gateway无法访问这个IP地址。

从Nacos服务注册信息可以看到：
```
"ip": "192.168.124.5",
"port": 8001
```

Gateway通过服务发现得到这个地址，但无法访问，导致503错误。

## 解决方案

已在以下文件中修改配置，添加了IP地址绑定：

### 1. ecommerce-user服务
文件：`ecommerce-user/src/main/resources/application.yml`

添加了：
```yaml
spring:
  cloud:
    nacos:
      discovery:
        server-addr: localhost:8848
        ip: 127.0.0.1      # 新增：指定注册IP
        port: 8001          # 新增：指定端口
```

### 2. ecommerce-product服务
文件：`ecommerce-product/src/main/resources/application.yml`

添加了：
```yaml
spring:
  cloud:
    nacos:
      discovery:
        server-addr: localhost:8848
        ip: 127.0.0.1      # 新增：指定注册IP
        port: 8002          # 新增：指定端口
```

## 操作步骤

### 方式1：在IDEA中重启服务（推荐）

1. **重启User服务**
   - 在IDEA中找到ecommerce-user服务的运行窗口
   - 点击停止按钮（红色方块）
   - 等待服务完全停止
   - 点击运行按钮（绿色三角形）

2. **重启Product服务**
   - 在IDEA中找到ecommerce-product服务的运行窗口
   - 点击停止按钮（红色方块）
   - 等待服务完全停止
   - 点击运行按钮（绿色三角形）

3. **验证服务注册**
   - 访问Nacos控制台：http://localhost:8848/nacos
   - 登录：nacos / nacos
   - 进入"服务管理" -> "服务列表"
   - 查看ecommerce-user和ecommerce-product的IP地址
   - **确认IP地址为127.0.0.1**，而不是192.168.124.5

### 方式2：使用命令行重启

```bash
# 停止服务
lsof -ti:8001 | xargs kill -9
lsof -ti:8002 | xargs kill -9

# 等待几秒
sleep 5

# 启动User服务（需要在ecommerce-user目录下）
cd ecommerce-user
mvn spring-boot:run &

# 启动Product服务（需要在ecommerce-product目录下）
cd ../ecommerce-product
mvn spring-boot:run &
```

### 方式3：使用快速重启脚本

我已经创建了重启脚本，执行：

```bash
bash /Users/zyq/IdeaProjects/TestProject/restart-services.sh
```

## 验证步骤

### 1. 检查Nacos服务注册

访问：http://localhost:8848/nacos

确认服务IP为127.0.0.1：
- ecommerce-user: 127.0.0.1:8001
- ecommerce-product: 127.0.0.1:8002
- ecommerce-gateway: 127.0.0.1:9000

### 2. 测试API

打开浏览器访问测试页面：
```
file:///Users/zyq/IdeaProjects/TestProject/test-api.html
```

或者在浏览器控制台执行：

```javascript
// 测试注册
fetch('http://localhost:9000/api/user/users/register', {
  method: 'POST',
  headers: {'Content-Type': 'application/json'},
  body: JSON.stringify({
    username: 'testuser001',
    password: '123456',
    nickname: '测试用户001'
  })
}).then(r => r.json()).then(console.log)

// 测试商品列表
fetch('http://localhost:9000/api/product/products/list')
  .then(r => r.json()).then(console.log)
```

### 3. 测试前端

1. 确保前端正在运行：http://localhost:3000
2. 访问注册页面
3. 填写注册信息
4. 点击"注册"

**预期结果**：
- 注册成功，不再出现503错误
- 用户数据保存到MySQL数据库
- 可以正常登录
- 可以查看商品列表

## 检查命令

如果仍有问题，可以运行以下命令检查：

```bash
# 检查Nacos服务注册
bash /Users/zyq/IdeaProjects/TestProject/check-nacos-services.sh

# 检查服务状态
lsof -i :8001  # User服务
lsof -i :8002  # Product服务
lsof -i :9000  # Gateway服务

# 测试直接访问User服务
curl -X POST http://localhost:8001/users/register \
  -H "Content-Type: application/json" \
  -d '{"username":"test001","password":"123456","nickname":"测试用户"}'

# 测试通过Gateway访问
curl -X POST http://localhost:9000/api/user/users/register \
  -H "Content-Type: application/json" \
  -d '{"username":"test002","password":"123456","nickname":"测试用户"}'
```

## 常见问题

### Q1: 重启后仍然503？
**A**: 检查Nacos控制台，确认服务IP是否更新为127.0.0.1

### Q2: 服务启动失败？
**A**: 检查IDEA控制台的错误日志，可能是端口占用或配置错误

### Q3: Gateway无法发现服务？
**A**: 确保所有服务都成功注册到Nacos，并且IP地址一致

### Q4: 浏览器CORS错误？
**A**: 这是正常的跨域问题，使用Vite代理已经解决，访问 http://localhost:3000 即可

## 成功标志

当修复成功后：
- ✅ Nacos控制台显示服务IP为127.0.0.1
- ✅ Gateway能正常转发请求到后端服务
- ✅ 前端注册功能正常（返回200）
- ✅ 前端登录功能正常
- ✅ 前端商品列表显示正常

## 下一步

修复503错误后，可以继续测试：
1. 完整的注册登录流程
2. 商品浏览和搜索
3. 购物车功能
4. 订单创建和支付
