# 前端项目快速开始指南

## 安装依赖

在项目根目录执行：

```bash
cd ecommerce-frontend
npm install
```

## 启动开发服务器

```bash
npm run dev
```

访问 http://localhost:3000

## 启动后端服务

在启动前端之前，需要先启动以下后端服务：

### 1. 启动 Nacos
```bash
cd /path/to/nacos/bin
./startup.sh -m standalone
```

### 2. 初始化数据库
```bash
cd /path/to/TestProject
bash init-db.sh
```

### 3. 启动各个微服务
在 IntelliJ IDEA 中依次启动：
- ecommerce-gateway (端口 9000)
- ecommerce-user (端口 8001)
- ecommerce-product (端口 8002)
- ecommerce-order (端口 8003)
- ecommerce-payment (端口 8004)

或者使用脚本：
```bash
cd /path/to/TestProject
bash start.sh
```

## 配置说明

### API 代理配置

前端默认通过 `http://localhost:9000` 访问后端 API。

如果需要修改后端地址，请编辑 `vite.config.js`：

```javascript
server: {
  port: 3000,
  proxy: {
    '/api': {
      target: 'http://localhost:9000',  // 修改为实际的网关地址
      changeOrigin: true,
      rewrite: (path) => path.replace(/^\/api/, '')
    }
  }
}
```

### 端口配置

- 前端开发服务器：3000
- 网关服务：9000
- 用户服务：8001
- 商品服务：8002
- 订单服务：8003
- 支付服务：8004
- Nacos：8848

## 测试账号

可以使用以下测试账号：

- 用户名：admin
- 密码：123456

或者自行注册新账号。

## 主要功能测试流程

### 1. 用户注册/登录
1. 访问 http://localhost:3000
2. 点击"注册"按钮，填写注册信息
3. 或直接使用测试账号登录

### 2. 浏览商品
1. 登录后进入首页
2. 点击"商品"查看商品列表
3. 可以按分类筛选商品
4. 点击商品查看详情

### 3. 添加购物车
1. 在商品详情页点击"加入购物车"
2. 或在商品列表页直接点击"加入购物车"
3. 点击顶部"购物车"查看已添加商品

### 4. 下单支付
1. 在购物车页面点击"去结算"
2. 填写收货信息
3. 选择支付方式
4. 点击"提交订单"
5. 在支付页面完成支付

### 5. 查看订单
1. 点击用户头像 -> "我的订单"
2. 查看订单列表和详情
3. 可以取消未支付的订单

## 常见问题

### 1. 跨域问题
如果遇到跨域问题，请检查：
- 后端网关是否正确配置 CORS
- Vite 代理配置是否正确

### 2. 404 错误
如果遇到 404 错误，请检查：
- 后端服务是否全部启动
- API 路径是否正确
- 网关路由配置是否正确

### 3. 登录失败
如果登录失败，请检查：
- 用户名和密码是否正确
- 后端用户服务是否正常运行
- 数据库连接是否正常

### 4. 数据显示异常
如果数据显示异常，请检查：
- MySQL 数据库是否正确初始化
- Redis 服务是否正常运行
- 后端服务是否有错误日志

## 开发工具

推荐使用以下开发工具：

- **VS Code** - 代码编辑器
- **Vue Devtools** - Vue 开发者工具
- **Postman** - API 测试工具

## 项目构建

### 开发环境
```bash
npm run dev
```

### 生产环境构建
```bash
npm run build
```

构建后的文件在 `dist` 目录。

### 预览生产版本
```bash
npm run preview
```

## 代码规范

### Vue 风格指南
遵循 [Vue 官方风格指南](https://v2.cn.vuejs.org/v2/style-guide/)

### 命名规范
- 组件名：PascalCase (如：`ProductCard.vue`)
- 文件名：kebab-case (如：`product-card.vue`)
- 变量名：camelCase (如：`userName`)
- 常量名：UPPER_SNAKE_CASE (如：`API_BASE_URL`)

### 提交信息规范
```
<type>(<scope>): <subject>

<body>

<footer>
```

type 类型：
- `feat`: 新功能
- `fix`: 修复 bug
- `docs`: 文档更新
- `style`: 代码格式
- `refactor`: 重构
- `test`: 测试
- `chore`: 构建/工具变动

示例：
```
feat(user): 添加用户注册功能

- 添加注册页面
- 添加注册接口调用
- 添加表单验证

Closes #123
```

## 后续优化建议

1. **性能优化**
   - 路由懒加载
   - 组件按需加载
   - 图片懒加载

2. **用户体验**
   - 添加加载动画
   - 优化错误提示
   - 添加骨架屏

3. **功能扩展**
   - 商品搜索功能
   - 商品评论功能
   - 收藏功能
   - 地址管理

4. **测试**
   - 单元测试
   - E2E 测试
   - 组件测试

5. **部署**
   - Docker 容器化
   - CI/CD 流水线
   - CDN 加速

## 技术支持

如有问题，请参考：
- [Vue 3 官方文档](https://cn.vuejs.org/)
- [Element Plus 文档](https://element-plus.org/zh-CN/)
- [Pinia 文档](https://pinia.vuejs.org/zh/)
- [Vite 文档](https://cn.vitejs.dev/)
