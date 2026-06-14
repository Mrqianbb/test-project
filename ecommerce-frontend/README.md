# 电商前端项目 - Vue3 + Vite

基于 Spring Cloud 微服务架构的电商平台前端项目。

## 技术栈

- **Vue 3** - 渐进式 JavaScript 框架
- **Vite** - 新一代前端构建工具
- **Vue Router** - 官方路由管理器
- **Pinia** - 状态管理库
- **Axios** - HTTP 请求库
- **Element Plus** - 基于 Vue 3 的组件库
- **ECharts** - 数据可视化库

## 项目结构

```
ecommerce-frontend/
├── public/                  # 静态资源
├── src/
│   ├── api/                 # API 接口封装
│   │   ├── user.js          # 用户相关接口
│   │   ├── product.js       # 商品相关接口
│   │   ├── order.js         # 订单相关接口
│   │   └── payment.js       # 支付相关接口
│   ├── assets/              # 资源文件
│   ├── components/          # 公共组件
│   │   ├── Header.vue       # 头部导航
│   │   ├── Footer.vue       # 页脚
│   │   └── ProductCard.vue  # 商品卡片
│   ├── composables/         # 组合式函数
│   ├── router/              # 路由配置
│   │   └── index.js         # 路由定义
│   ├── stores/              # Pinia 状态管理
│   │   ├── user.js          # 用户状态
│   │   ├── product.js       # 商品状态
│   │   └── order.js         # 订单状态
│   ├── utils/               # 工具函数
│   │   ├── request.js       # Axios 封装
│   │   └── validate.js      # 验证和格式化工具
│   ├── views/               # 页面组件
│   │   ├── home/            # 首页
│   │   ├── user/            # 用户模块
│   │   │   ├── Login.vue    # 登录页
│   │   │   ├── Register.vue # 注册页
│   │   │   └── Profile.vue  # 个人中心
│   │   ├── product/         # 商品模块
│   │   │   ├── List.vue     # 商品列表
│   │   │   └── Detail.vue   # 商品详情
│   │   ├── cart/            # 购物车模块
│   │   │   └── Index.vue    # 购物车
│   │   ├── order/           # 订单模块
│   │   │   ├── Confirm.vue  # 确认订单
│   │   │   ├── List.vue     # 订单列表
│   │   │   ├── Detail.vue   # 订单详情
│   │   │   └── Success.vue  # 下单成功
│   │   └── payment/         # 支付模块
│   │       └── Index.vue    # 支付页面
│   ├── App.vue              # 根组件
│   └── main.js              # 入口文件
├── index.html               # HTML 模板
├── package.json             # 项目配置
├── vite.config.js           # Vite 配置
└── README.md                # 项目说明
```

## 功能模块

### 1. 用户模块
- 用户注册
- 用户登录
- 个人信息管理
- 退出登录

### 2. 商品模块
- 商品列表展示
- 商品分类筛选
- 商品详情查看
- 商品搜索

### 3. 购物车模块
- 添加商品到购物车
- 购物车商品数量修改
- 删除购物车商品
- 购物车金额计算

### 4. 订单模块
- 创建订单
- 订单确认
- 订单列表
- 订单详情
- 取消订单

### 5. 支付模块
- 选择支付方式
- 扫码支付
- 支付结果查询

## 快速开始

### 环境要求
- Node.js >= 16.0.0
- npm >= 8.0.0

### 安装依赖

```bash
npm install
```

### 启动开发服务器

```bash
npm run dev
```

访问 http://localhost:3000

### 构建生产版本

```bash
npm run build
```

### 预览生产版本

```bash
npm run preview
```

## API 接口

所有接口都通过网关服务 `http://localhost:9000` 进行访问。

### 用户服务
- `POST /users/register` - 用户注册
- `POST /users/login` - 用户登录
- `GET /users/{id}` - 获取用户信息
- `PUT /users/{id}` - 更新用户信息

### 商品服务
- `GET /products/list` - 获取商品列表
- `GET /products/{id}` - 获取商品详情
- `POST /products/{id}/stock` - 更新库存

### 订单服务
- `POST /orders` - 创建订单
- `GET /orders/{id}` - 获取订单详情
- `GET /orders/user/{userId}` - 获取用户订单列表
- `POST /orders/{id}/cancel` - 取消订单
- `POST /orders/{id}/status` - 更新订单状态

### 支付服务
- `POST /payments` - 创建支付
- `GET /payments/{id}` - 获取支付详情
- `POST /payments/{id}/complete` - 完成支付
- `GET /payments/order/{orderId}` - 根据订单查询支付

## 状态管理

使用 Pinia 进行状态管理，主要包含以下 store：

### UserStore
- 用户信息
- 登录状态
- 购物车数据

### ProductStore
- 商品列表
- 商品详情

### OrderStore
- 订单列表
- 订单详情

## 路由配置

使用 Vue Router 进行路由管理，主要路由：

- `/` - 首页
- `/login` - 登录页
- `/register` - 注册页
- `/products` - 商品列表
- `/products/:id` - 商品详情
- `/cart` - 购物车
- `/order/confirm` - 确认订单
- `/orders` - 订单列表
- `/orders/:id` - 订单详情
- `/payment/:id` - 支付页面
- `/profile` - 个人中心

## 组件说明

### 公共组件
- `Header` - 页面头部导航，包含用户信息和购物车入口
- `Footer` - 页脚信息
- `ProductCard` - 商品卡片组件

### 页面组件
- `Home` - 首页，展示轮播图和热门商品
- `Login` - 用户登录页面
- `Register` - 用户注册页面
- `ProductList` - 商品列表页面
- `ProductDetail` - 商品详情页面
- `Cart` - 购物车页面
- `OrderConfirm` - 订单确认页面
- `OrderList` - 订单列表页面
- `OrderDetail` - 订单详情页面
- `Payment` - 支付页面

## 请求拦截

使用 Axios 拦截器处理请求和响应：

### 请求拦截
- 自动添加 Authorization header
- 添加 token 到请求头

### 响应拦截
- 统一处理响应数据格式
- 处理错误状态码（401, 403, 404, 500）
- 显示错误提示消息

## 验证规则

包含常用的验证和格式化工具函数：

- `validatePhone` - 验证手机号
- `validateEmail` - 验证邮箱
- `validatePassword` - 验证密码
- `formatMoney` - 格式化金额
- `formatDateTime` - 格式化日期时间
- `getOrderStatusText` - 获取订单状态文本
- `getPaymentMethodText` - 获取支付方式文本

## 开发建议

1. **组件化开发** - 将重复的功能提取为公共组件
2. **代码规范** - 遵循 Vue 3 Composition API 风格
3. **状态管理** - 合理使用 Pinia store，避免过度使用
4. **路由守卫** - 使用路由守卫保护需要登录的页面
5. **错误处理** - 统一处理 API 请求错误

## 注意事项

1. 确保 Spring Cloud 后端服务已启动
2. 确保网关服务运行在 `http://localhost:9000`
3. 确保 Nacos 服务正常运行
4. 确保 MySQL 和 Redis 服务已启动
5. 修改 `vite.config.js` 中的代理配置以匹配实际后端地址

## 浏览器支持

- Chrome >= 87
- Firefox >= 78
- Safari >= 14
- Edge >= 88

## 许可证

MIT License
