# 🚀 完整启动指南（修复503错误后）

## 📋 当前任务

✅ 已完成：
- 移除Gateway限流器配置
- 修改User和Product服务的Nacos注册IP为127.0.0.1
- 清理所有被占用的端口

⏳ 待执行：
- 按正确顺序启动所有服务
- 验证服务注册
- 测试前后端集成

## 🎯 重要提醒

**必须按以下顺序启动服务，否则可能出现端口冲突！**

启动顺序：
1. Nacos (8848) - 必须最先启动
2. User Service (8001) - 已修改配置
3. Product Service (8002) - 已修改配置
4. Gateway (9000) - 已修改配置
5. Frontend (3000)

## 📝 完整启动步骤

### 步骤1: 确认Nacos已启动

```bash
lsof -i :8848
```

如果未启动，在IDEA中启动ecommerce-registry服务。

**预期结果**：
```
COMMAND   PID USER   FD   TYPE  DEVICE SIZE/OFF NODE NAME
java    XXXXX  zyq  XXXu  IPv6 0xeXXXXXX      0t0  TCP *:irdmi (LISTEN)
```

### 步骤2: 启动User Service

**在IDEA中操作**：

1. 打开文件：`ecommerce-user/src/main/resources/application.yml`
2. **确认配置包含以下内容**（这是我们为了修复503错误添加的）：
   ```yaml
   spring:
     cloud:
       nacos:
         discovery:
           server-addr: localhost:8848
           ip: 127.0.0.1      # ← 这个是关键！
           port: 8001
   ```
3. 点击运行按钮启动ecommerce-user服务
4. 等待启动完成，看到：
   ```
   Started UserApplication in X.XXX seconds
   ```

### 步骤3: 启动Product Service

**在IDEA中操作**：

1. 打开文件：`ecommerce-product/src/main/resources/application.yml`
2. **确认配置包含以下内容**：
   ```yaml
   spring:
     cloud:
       nacos:
         discovery:
           server-addr: localhost:8848
           ip: 127.0.0.1      # ← 这个是关键！
           port: 8002
   ```
3. 点击运行按钮启动ecommerce-product服务
4. 等待启动完成，看到：
   ```
   Started ProductApplication in X.XXX seconds
   ```

### 步骤4: 启动Gateway

**在IDEA中操作**：

1. 点击运行按钮启动ecommerce-gateway服务
2. 等待启动完成，看到：
   ```
   Started GatewayApplication in X.XXX seconds
   ```

**如果遇到端口占用错误**：
```bash
# 清理端口
lsof -ti:9000 | xargs kill -9

# 然后重新启动Gateway
```

### 步骤5: 启动Frontend

**在终端中执行**：

```bash
cd /Users/zyq/IdeaProjects/TestProject/ecommerce-frontend
npm run dev
```

或者如果npm找不到：
```bash
cd /Users/zyq/IdeaProjects/TestProject/ecommerce-frontend
/opt/homebrew/bin/npm run dev  # 或其他npm路径
```

**预期输出**：
```
VITE v4.x.x  ready in xxx ms

➜  Local:   http://localhost:3000/
➜  press h + enter to show help
```

### 步骤6: 验证Nacos服务注册

**在浏览器中打开**：
```
http://localhost:8848/nacos
```

**登录信息**：
- 用户名：`nacos`
- 密码：`nacos`

**检查步骤**：
1. 点击左侧菜单：服务管理 → 服务列表
2. 查找以下服务：
   - `ecommerce-user`
   - `ecommerce-product`
   - `ecommerce-gateway`
3. 点击服务名后的"详情"链接
4. **关键检查**：确认IP地址为 `127.0.0.1`
   - ❌ 错误：`192.168.124.5`（会导致503错误）
   - ✅ 正确：`127.0.0.1`（503错误已修复）

### 步骤7: 测试API

**打开测试页面**：
```
file:///Users/zyq/IdeaProjects/TestProject/test-api.html
```

**测试步骤**：
1. 点击"检查所有服务" - 确保所有服务都在运行
2. 点击"通过Gateway注册" - 测试用户注册
3. 点击"测试登录" - 测试用户登录
4. 点击"通过Gateway获取商品列表" - 测试商品API

**预期结果**：
- ✅ 所有服务状态显示为"运行中"
- ✅ 注册返回200成功（不再503错误）
- ✅ 登录返回token和用户信息
- ✅ 商品列表返回25个商品

### 步骤8: 测试前端

**在浏览器中打开**：
```
http://localhost:3000
```

**测试流程**：
1. 点击"注册"按钮
2. 填写表单：
   - 用户名：testuser001
   - 密码：123456
   - 确认密码：123456
   - 昵称：测试用户
   - 手机号：13800138000
   - 邮箱：test@example.com
3. 点击"注册"按钮
4. 注册成功后，点击"登录"
5. 输入用户名和密码
6. 登录成功后，查看首页商品列表

**预期结果**：
- ✅ 注册成功提示
- ✅ 登录成功进入首页
- ✅ 首页显示商品列表
- ✅ 所有功能正常，无503错误

## 🔍 故障排查

### 问题1: 端口被占用

**错误信息**：
```
Port 8001 was already in use.
```

**解决方法**：
```bash
# 使用清理脚本
bash /Users/zyq/IdeaProjects/TestProject/fix-port-conflict.sh

# 或手动清理
lsof -ti:8001 | xargs kill -9
lsof -ti:8002 | xargs kill -9
lsof -ti:9000 | xargs kill -9
```

### 问题2: Nacos注册IP仍是192.168.124.5

**解决方法**：
1. 确认`application.yml`中添加了`ip: 127.0.0.1`
2. 完全停止服务（IDEA中点击停止）
3. 删除Nacos中的旧实例
4. 重新启动服务

### 问题3: 仍然返回503错误

**检查清单**：
- [ ] Nacos控制台显示IP为127.0.0.1
- [ ] Gateway服务正在运行（端口9000）
- [ ] User服务正在运行（端口8001）
- [ ] 直接访问http://localhost:8001/users/register是否成功
- [ ] 通过Gateway访问是否成功

**临时解决方案**：
修改前端`src/utils/request.js`，暂时直接连接User服务：
```javascript
const service = axios.create({
  baseURL: 'http://localhost:8001',  // 暂时直接连接
  timeout: 15000
})
```

### 问题4: 前端页面空白

**检查**：
- 打开浏览器开发者工具（F12）
- 查看Console标签的错误信息
- 查看Network标签的请求状态

## 📊 服务端口汇总

| 服务 | 端口 | 状态 | 说明 |
|------|------|------|------|
| Nacos | 8848 | ✅ | 服务注册中心 |
| User Service | 8001 | ✅ | 用户服务 |
| Product Service | 8002 | ✅ | 商品服务 |
| Order Service | 8003 | - | 订单服务（可选） |
| Payment Service | 8004 | - | 支付服务（可选） |
| Gateway | 9000 | ✅ | API网关 |
| Frontend | 3000 | ✅ | 前端服务 |

## ✅ 启动完成检查清单

启动完成后，请确认以下项目：

- [ ] Nacos运行在8848端口
- [ ] User Service运行在8001端口
- [ ] Product Service运行在8002端口
- [ ] Gateway运行在9000端口
- [ ] Frontend运行在3000端口
- [ ] Nacos控制台显示所有服务IP为127.0.0.1
- [ ] 测试API页面显示所有服务正常
- [ ] 前端可以正常注册用户
- [ ] 前端可以正常登录
- [ ] 前端可以正常显示商品列表
- [ ] 不再出现503错误

## 🎉 成功标志

当所有步骤完成后，您应该看到：

✅ 所有服务正常运行
✅ Nacos服务IP为127.0.0.1
✅ 前端注册成功（200状态码）
✅ 前端登录成功
✅ 商品列表正常显示
✅ 完整的电商购物流程可用

## 📞 需要帮助？

如果按照以上步骤操作后仍有问题，请提供：

1. IDEA控制台的错误日志
2. Nacos控制台的截图（服务列表）
3. 浏览器开发者工具的错误信息（F12 → Console）
4. 执行以下命令的输出：
   ```bash
   lsof -i :8848 :8001 :8002 :9000 :3000
   ```

---

**祝您启动顺利！🚀**
