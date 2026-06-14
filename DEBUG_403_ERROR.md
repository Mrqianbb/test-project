# 403错误诊断和解决方案

## 问题分析

前端注册用户时报403错误，可能的原因：

1. **Gateway限流器配置问题** ✅ 已解决
   - 原因：Gateway配置了RequestRateLimiter限流器，但key-resolver配置缺失导致403
   - 解决：已从`ecommerce-gateway/src/main/resources/application.yml`中移除限流器配置

2. **服务发现可能的问题**
   - Gateway可能无法从Nacos发现ecommerce-user服务
   - User服务可能没有正确注册到Nacos

## 当前状态

### 运行中的服务
- ✅ Nacos (8848)
- ✅ Gateway (9000) - 已重启，配置已更新
- ✅ User Service (8001)
- ✅ Product Service (8002)
- ✅ Frontend (3000)

### 已完成的配置修改
1. **Gateway配置** - 移除了限流器
2. **前端API路径** - 已更新为正确的Gateway路由路径
3. **前端Store** - 已移除模拟数据，直接调用真实API
4. **数据库** - 已添加25个测试商品

## 测试步骤

### 1. 直接测试User服务（绕过Gateway）

使用浏览器或Postman直接访问：
```
POST http://localhost:8001/users/register
Content-Type: application/json

{
  "username": "test001",
  "password": "123456",
  "nickname": "测试用户001",
  "phone": "13800138001",
  "email": "test001@example.com"
}
```

**预期结果**：返回200和成功消息

### 2. 测试Gateway转发

```
POST http://localhost:9000/api/user/users/register
Content-Type: application/json

{
  "username": "test002",
  "password": "123456",
  "nickname": "测试用户002",
  "phone": "13800138002",
  "email": "test002@example.com"
}
```

**预期结果**：返回200和成功消息

### 3. 测试前端

1. 打开浏览器访问 `http://localhost:3000`
2. 点击"注册"
3. 填写注册信息
4. 点击"注册"按钮

**预期结果**：
- 注册成功，提示"注册成功！"
- 数据保存到MySQL数据库

## 检查Nacos服务注册

访问Nacos控制台查看服务注册情况：
```
http://localhost:8848/nacos/
用户名: nacos
密码: nacos
```

检查以下服务是否已注册：
- ecommerce-gateway
- ecommerce-user
- ecommerce-product

## 如果仍然出现403错误

### 方法1：重启所有后端服务
```bash
# 停止所有服务
lsof -ti:8001 -ti:8002 -ti:8003 -ti:8004 -ti:9000 | xargs kill -9

# 启动各个服务（在IDEA中或使用命令行）
```

### 方法2：检查Gateway日志
查看Gateway启动日志，确认是否正确连接到Nacos

### 方法3：临时解决方案 - 直接连接User服务
修改前端`src/utils/request.js`，将baseURL改为直接连接User服务：

```javascript
const service = axios.create({
  baseURL: 'http://localhost:8001',  // 暂时直接连接User服务
  timeout: 15000
})
```

**注意**：这只是临时方案，正式环境应该通过Gateway。

### 方法4：检查防火墙或网络配置
确保：
- 9000端口没有被防火墙阻止
- Gateway可以访问Nacos (8848)
- Gateway可以访问User服务 (8001)

## API路由映射

前端路径 → Gateway → 后端服务

```
/api/user/users/login     → Gateway:9000 → User Service:8001 /users/login
/api/user/users/register  → Gateway:9000 → User Service:8001 /users/register
/api/product/products/list → Gateway:9000 → Product Service:8002 /products/list
```

## 数据库验证

注册成功后，可以验证数据是否保存到数据库：

```sql
USE ecommerce;
SELECT id, username, nickname, phone, email, create_time 
FROM user 
ORDER BY create_time DESC 
LIMIT 10;
```

## 调试技巧

### 1. 浏览器开发者工具
- 打开F12开发者工具
- 切换到"网络"标签
- 发起注册请求
- 查看请求详情和响应

### 2. 查看Gateway日志
Gateway启动日志会显示：
- 是否成功连接到Nacos
- 服务发现情况
- 路由规则加载情况

### 3. 查看User服务日志
User服务日志会显示：
- 是否成功注册到Nacos
- 请求处理情况
- 数据库操作情况

## 常见错误码

- **200**: 成功
- **403**: Forbidden - 权限被拒绝（已修复）
- **503**: Service Unavailable - 服务不可用（通常是服务发现失败）
- **500**: Internal Server Error - 服务器内部错误

## 下一步

1. 测试注册功能
2. 如果成功，测试登录功能
3. 测试商品列表展示
4. 测试完整购物流程
