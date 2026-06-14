import { createRouter, createWebHistory } from 'vue-router'

const routes = [
  {
    path: '/',
    name: 'Home',
    component: () => import('@/views/home/Index.vue'),
    meta: { title: '首页 - 淘淘网' }
  },
  {
    path: '/login',
    name: 'Login',
    component: () => import('@/Login.vue'),
    meta: { title: '登录 - 淘淘网' }
  },
  {
    path: '/register',
    name: 'Register',
    component: () => import('@/Register.vue'),
    meta: { title: '注册 - 淘淘网' }
  },
  {
    path: '/products',
    name: 'ProductList',
    component: () => import('@/views/products/List.vue'),
    meta: { title: '商品列表 - 淘淘网' }
  },
  {
    path: '/cart',
    name: 'Cart',
    component: () => import('@/views/cart/Index.vue'),
    meta: { title: '购物车 - 淘淘网' }
  }
]

const router = createRouter({
  history: createWebHistory(),
  routes
})

router.beforeEach((to, from, next) => {
  document.title = to.meta.title || '淘淘网'
  next()
})

export default router
