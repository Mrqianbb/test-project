# 电商前端项目架构文档

## 系统架构

### 整体架构

```
┌─────────────────────────────────────────────────────────┐
│                     用户浏览器                           │
│  ┌───────────────────────────────────────────────────┐  │
│  │         Vue3 前端应用 (http://localhost:3000)      │  │
│  │  ┌─────────┐  ┌─────────┐  ┌───────────────────┐ │  │
│  │  │  页面   │  │  组件   │  │   状态管理         │ │  │
│  │  │  组件   │  │  库     │  │   (Pinia Stores)   │ │  │
│  │  └────┬────┘  └────┬────┘  └─────────┬─────────┘ │  │
│  │       └───────────┴──────────────────┘          │  │
│  │                     │                              │  │
│  │           ┌─────────▼─────────┐                    │  │
│  │           │   Axios 请求层    │                    │  │
│  │           │   (HTTP Client)   │                    │  │
│  │           └─────────┬─────────┘                    │  │
│  └─────────────────────┼─────────────────────────────┘  │
│                        │                                │
└────────────────────────┼────────────────────────────────┘
                         │ HTTP/HTTPS
                         ▼
┌─────────────────────────────────────────────────────────┐
│                  API 网关 (端口 9000)                     │
│  ┌───────────────────────────────────────────────────┐  │
│  │        Spring Cloud Gateway                        │  │
│  │  - 路由转发                                         │  │
│  │  - 负载均衡                                         │  │
│  │  - 限流熔断                                         │  │
│  └───────────────────┬───────────────────────────────┘  │
└──────────────────────┼──────────────────────────────────┘
                       │
         ┌─────────────┼─────────────┐
         │             │             │
         ▼             ▼             ▼
┌────────────┐ ┌────────────┐ ┌────────────┐
│ 用户服务   │ │ 商品服务   │ │ 订单服务   │
│ (8001)     │ │ (8002)     │ │ (8003)     │
└────────────┘ └────────────┘ └────────────┘
                                             │
                                             ▼
                                    ┌────────────┐
                                    │ 支付服务   │
                                    │ (8004)     │
                                    └────────────┘
```

## 技术架构

### 前端技术栈

| 技术 | 版本 | 用途 |
|------|------|------|
| Vue | 3.4.0 | 渐进式 JavaScript 框架 |
| Vite | 5.0.8 | 新一代前端构建工具 |
| Vue Router | 4.2.5 | 路由管理 |
| Pinia | 2.1.7 | 状态管理 |
| Axios | 1.6.2 | HTTP 请求库 |
| Element Plus | 2.5.0 | UI 组件库 |
| ECharts | 5.4.3 | 数据可视化 |
| Day.js | 1.11.10 | 日期处理 |

### 开发工具

| 工具 | 用途 |
|------|------|
| VS Code | 代码编辑器 |
| Vue Devtools | Vue 开发者工具 |
| Chrome DevTools | 浏览器开发者工具 |

## 项目结构详解

### 目录结构

```
ecommerce-frontend/
├── public/                      # 静态资源目录
│   ├── favicon.ico             # 网站图标
│   └── ...                     # 其他静态资源
│
├── src/                        # 源代码目录
│   ├── api/                    # API 接口封装
│   │   ├── user.js             # 用户相关接口
│   │   ├── product.js          # 商品相关接口
│   │   ├── order.js            # 订单相关接口
│   │   └── payment.js          # 支付相关接口
│   │
│   ├── assets/                 # 资源文件
│   │   ├── images/             # 图片资源
│   │   ├── styles/             # 样式文件
│   │   └── ...                 # 其他资源
│   │
│   ├── components/             # 公共组件
│   │   ├── Header.vue          # 头部导航组件
│   │   ├── Footer.vue          # 页脚组件
│   │   └── ProductCard.vue    # 商品卡片组件
│   │
│   ├── composables/            # 组合式函数
│   │   ├── useCart.js          # 购物车逻辑
│   │   ├── useUser.js          # 用户逻辑
│   │   └── ...                 # 其他组合函数
│   │
│   ├── router/                 # 路由配置
│   │   └── index.js            # 路由定义和守卫
│   │
│   ├── stores/                 # Pinia 状态管理
│   │   ├── user.js             # 用户状态
│   │   ├── product.js          # 商品状态
│   │   └── order.js            # 订单状态
│   │
│   ├── utils/                  # 工具函数
│   │   ├── request.js          # Axios 封装和拦截器
│   │   ├── validate.js         # 验证和格式化工具
│   │   └── ...                 # 其他工具函数
│   │
│   ├── views/                  # 页面组件
│   │   ├── home/               # 首页模块
│   │   │   └── Index.vue       # 首页
│   │   ├── user/               # 用户模块
│   │   │   ├── Login.vue       # 登录页
│   │   │   ├── Register.vue    # 注册页
│   │   │   └── Profile.vue     # 个人中心
│   │   ├── product/            # 商品模块
│   │   │   ├── List.vue        # 商品列表
│   │   │   └── Detail.vue      # 商品详情
│   │   ├── cart/               # 购物车模块
│   │   │   └── Index.vue       # 购物车
│   │   ├── order/              # 订单模块
│   │   │   ├── Confirm.vue     # 确认订单
│   │   │   ├── List.vue        # 订单列表
│   │   │   ├── Detail.vue      # 订单详情
│   │   │   └── Success.vue     # 下单成功
│   │   └── payment/            # 支付模块
│   │       └── Index.vue       # 支付页面
│   │
│   ├── App.vue                 # 根组件
│   └── main.js                 # 应用入口
│
├── index.html                  # HTML 模板
├── package.json                # 项目依赖和脚本
├── vite.config.js              # Vite 配置文件
├── .gitignore                  # Git 忽略文件
├── README.md                   # 项目说明文档
├── QUICK_START.md              # 快速开始指南
└── FRONTEND_ARCHITECTURE.md    # 架构文档（本文件）
```

## 核心模块设计

### 1. 状态管理 (Pinia)

#### UserStore
```javascript
{
  state: {
    token: String,              // 用户令牌
    userInfo: Object,           // 用户信息
    cart: Array                // 购物车数据
  },
  actions: {
    login(),                   // 用户登录
    logout(),                  // 用户登出
    checkLogin(),              // 检查登录状态
    updateUserInfo(),          // 更新用户信息
    addToCart(),               // 添加到购物车
    removeFromCart(),          // 从购物车移除
    updateCartQuantity(),      // 更新购物车数量
    clearCart(),               // 清空购物车
    cartTotalQuantity(),       // 计算购物车总数量
    cartTotalAmount()          // 计算购物车总金额
  }
}
```

#### ProductStore
```javascript
{
  state: {
    productList: Array,        // 商品列表
    productDetail: Object,      // 商品详情
    loading: Boolean           // 加载状态
  },
  actions: {
    fetchProductList(),        // 获取商品列表
    fetchProductDetail()       // 获取商品详情
  }
}
```

#### OrderStore
```javascript
{
  state: {
    orderList: Array,          // 订单列表
    orderDetail: Object,        // 订单详情
    loading: Boolean            // 加载状态
  },
  actions: {
    fetchUserOrders(),         // 获取用户订单
    createOrder(),             // 创建订单
    fetchOrderDetail(),        // 获取订单详情
    cancelOrder()              // 取消订单
  }
}
```

### 2. 路由管理 (Vue Router)

#### 路由结构
```javascript
const routes = [
  // 公共路由
  { path: '/', component: Home },
  { path: '/login', component: Login },
  { path: '/register', component: Register },

  // 商品路由
  { path: '/products', component: ProductList },
  { path: '/products/:id', component: ProductDetail },

  // 需要认证的路由
  { path: '/cart', component: Cart, meta: { requiresAuth: true } },
  { path: '/order/confirm', component: OrderConfirm, meta: { requiresAuth: true } },
  { path: '/orders', component: OrderList, meta: { requiresAuth: true } },
  { path: '/payment/:id', component: Payment, meta: { requiresAuth: true } },
  { path: '/profile', component: Profile, meta: { requiresAuth: true } }
]
```

#### 路由守卫
```javascript
router.beforeEach((to, from, next) => {
  // 检查是否需要登录
  if (to.meta.requiresAuth && !userStore.token) {
    next('/login')
  } else {
    next()
  }
})
```

### 3. API 请求 (Axios)

#### 请求拦截器
```javascript
// 自动添加 token
config.headers['Authorization'] = `Bearer ${token}`
```

#### 响应拦截器
```javascript
// 统一处理响应
if (res.code === 200) {
  return res.data
} else {
  ElMessage.error(res.message)
  return Promise.reject(res.message)
}
```

### 4. 组件设计

#### 公共组件
- **Header**: 顶部导航，包含用户信息和购物车
- **Footer**: 页脚信息
- **ProductCard**: 商品展示卡片

#### 页面组件
- **Home**: 首页，展示轮播图和热门商品
- **Login**: 用户登录
- **Register**: 用户注册
- **ProductList**: 商品列表
- **ProductDetail**: 商品详情
- **Cart**: 购物车
- **OrderConfirm**: 确认订单
- **OrderList**: 订单列表
- **Payment**: 支付页面

## 数据流向

### 用户登录流程
```
1. 用户输入账号密码
2. 调用 loginApi() 接口
3. 后端验证并返回 token
4. UserStore 存储 token 和用户信息
5. 持久化到 localStorage
6. 跳转到首页
```

### 购物车流程
```
1. 用户浏览商品
2. 点击"加入购物车"
3. UserStore.addToCart() 添加商品
4. 购物车数量更新
5. 购物车金额自动计算
```

### 下单流程
```
1. 用户在购物车点击"去结算"
2. 跳转到订单确认页
3. 填写收货信息
4. 点击"提交订单"
5. 调用 createOrderApi() 创建订单
6. 清空购物车
7. 跳转到支付页面
```

### 支付流程
```
1. 显示支付二维码
2. 轮询支付状态
3. 用户扫码支付
4. 后端更新支付状态
5. 前端检测到支付成功
6. 跳转到订单成功页
```

## 性能优化

### 1. 路由懒加载
```javascript
const ProductList = () => import('@/views/product/List.vue')
```

### 2. 组件按需加载
使用 Element Plus 的自动导入：
```javascript
AutoImport({
  resolvers: [ElementPlusResolver()]
})
```

### 3. 图片优化
- 使用懒加载
- 压缩图片
- 使用 WebP 格式

### 4. 缓存策略
- localStorage 存储用户信息
- sessionStorage 存储临时数据
- Pinia 管理应用状态

## 安全措施

### 1. 认证授权
- JWT Token 认证
- 路由守卫保护
- Token 过期自动刷新

### 2. 数据验证
- 表单验证
- API 响应验证
- XSS 防护

### 3. HTTPS
- 生产环境使用 HTTPS
- Cookie 安全设置

## 部署方案

### 开发环境
```bash
npm run dev
```

### 生产环境
```bash
npm run build
# 将 dist 目录部署到静态服务器
```

### Docker 部署
```dockerfile
FROM node:16-alpine
WORKDIR /app
COPY package*.json ./
RUN npm install
COPY . .
RUN npm run build
EXPOSE 3000
CMD ["npm", "run", "preview"]
```

## 监控和日志

### 1. 错误监控
- Vue 全局错误捕获
- API 错误日志
- 用户行为记录

### 2. 性能监控
- 页面加载时间
- API 响应时间
- 用户交互数据

## 扩展建议

### 1. 功能扩展
- 商品搜索
- 商品评论
- 收藏功能
- 地址管理
- 优惠券系统

### 2. 技术优化
- SSR 服务端渲染
- PWA 渐进式 Web 应用
- 微前端架构
- CDN 加速

### 3. 体验优化
- 骨架屏加载
- 虚拟列表
- 无限滚动
- 离线缓存

## 总结

本前端项目采用现代化的 Vue 3 技术栈，具有良好的架构设计和代码规范。通过模块化设计、状态管理和组件化开发，实现了高效的开发和维护。

项目特点：
- 🎯 基于 Vue 3 Composition API
- 📦 使用 Pinia 进行状态管理
- 🎨 基于 Element Plus 的现代化 UI
- 🚀 Vite 提供极速开发体验
- 🔒 完善的认证授权机制
- 📱 响应式设计，支持移动端
- 🧩 组件化开发，易于维护
- 📝 完善的文档和注释
