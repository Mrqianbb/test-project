<template>
  <div class="taobao-header">
    <div class="header-content">
      <!-- Logo -->
      <div class="logo" @click="goHome">
        <el-icon :size="32" color="#ff5000">
          <ShoppingCart />
        </el-icon>
        <span class="logo-text">淘淘网</span>
      </div>

      <!-- 搜索框 -->
      <div class="search-box">
        <el-input
          v-model="keyword"
          placeholder="搜索商品"
          @keyup.enter="handleSearch"
        >
          <template #append>
            <el-button type="danger" @click="handleSearch">
              <el-icon><Search /></el-icon>
            </el-button>
          </template>
        </el-input>
      </div>

      <!-- 导航 -->
      <div class="nav">
        <router-link to="/" class="nav-item active">首页</router-link>
        <router-link to="/products" class="nav-item">全部商品</router-link>
      </div>

      <!-- 用户操作 -->
      <div class="user-actions">
        <router-link to="/cart" class="cart-link">
          <el-badge :value="cartCount" :max="99" type="danger">
            <el-icon :size="24" color="#666">
              <ShoppingCart />
            </el-icon>
          </el-badge>
          <span>购物车</span>
        </router-link>

        <template v-if="userStore.token">
          <el-dropdown @command="handleCommand">
            <span class="user-name">
              {{ userStore.userInfo?.nickname || '用户' }}
              <el-icon><ArrowDown /></el-icon>
            </span>
            <template #dropdown>
              <el-dropdown-menu>
                <el-dropdown-item command="orders">我的订单</el-dropdown-item>
                <el-dropdown-item command="profile">个人中心</el-dropdown-item>
                <el-dropdown-item divided command="logout">退出登录</el-dropdown-item>
              </el-dropdown-menu>
            </template>
          </el-dropdown>
        </template>

        <template v-else>
          <router-link to="/login" class="login-btn">登录</router-link>
          <router-link to="/register" class="register-btn">注册</router-link>
        </template>
      </div>
    </div>
  </div>
</template>

<script setup>
import { ref, computed, onMounted, onUnmounted } from 'vue'
import { useRouter } from 'vue-router'
import { ElMessageBox, ElMessage } from 'element-plus'
import { useUserStore } from '@/stores/user'
import { ShoppingCart, Search, ArrowDown } from '@element-plus/icons-vue'

const router = useRouter()
const userStore = useUserStore()
const keyword = ref('')
const cartCount = ref(parseInt(localStorage.getItem('cartCount') || 0))

const updateCartCount = () => {
  cartCount.value = parseInt(localStorage.getItem('cartCount') || 0)
}

const goHome = () => {
  router.push('/')
}

const handleSearch = () => {
  if (keyword.value.trim()) {
    router.push({
      path: '/products',
      query: { keyword: keyword.value.trim() }
    })
  }
}

const handleCommand = (command) => {
  switch (command) {
    case 'orders':
      router.push('/orders')
      break
    case 'profile':
      router.push('/profile')
      break
    case 'logout':
      ElMessageBox.confirm('确定要退出登录吗？', '提示', {
        confirmButtonText: '确定',
        cancelButtonText: '取消',
        type: 'warning'
      }).then(() => {
        userStore.logout()
        ElMessage.success('已退出登录')
        router.push('/')
      })
      break
  }
}

onMounted(() => {
  window.addEventListener('cart-updated', updateCartCount)
})

onUnmounted(() => {
  window.removeEventListener('cart-updated', updateCartCount)
})
</script>

<style>
.taobao-header {
  background: white;
  box-shadow: 0 2px 8px rgba(0, 0, 0, 0.08);
  position: sticky;
  top: 0;
  z-index: 1000;
}

.header-content {
  max-width: 1200px;
  margin: 0 auto;
  display: flex;
  align-items: center;
  padding: 12px 20px;
  gap: 30px;
}

.logo {
  display: flex;
  align-items: center;
  gap: 8px;
  cursor: pointer;
  min-width: 120px;
}

.logo-text {
  font-size: 22px;
  font-weight: bold;
  color: #ff5000;
}

.search-box {
  flex: 1;
  max-width: 500px;
}

.search-box :deep(.el-input__wrapper) {
  border-radius: 20px 0 0 20px;
}

.search-box :deep(.el-input-group__append) {
  border-radius: 0 20px 20px 0;
  background: #ff5000;
  border: none;
  padding: 0 20px;
}

.search-box :deep(.el-button--danger) {
  background: #ff5000;
  border: none;
}

.nav {
  display: flex;
  gap: 20px;
  min-width: 150px;
}

.nav-item {
  color: #666;
  text-decoration: none;
  font-size: 14px;
  transition: color 0.3s;
}

.nav-item:hover,
.nav-item.active {
  color: #ff5000;
}

.user-actions {
  display: flex;
  align-items: center;
  gap: 20px;
}

.cart-link {
  display: flex;
  align-items: center;
  gap: 6px;
  color: #666;
  text-decoration: none;
  font-size: 14px;
  transition: color 0.3s;
}

.cart-link:hover {
  color: #ff5000;
}

.user-name {
  display: flex;
  align-items: center;
  gap: 4px;
  cursor: pointer;
  color: #666;
  font-size: 14px;
  padding: 6px 12px;
  border-radius: 4px;
  transition: background 0.3s;
}

.user-name:hover {
  background: #f5f5fa;
}

.login-btn,
.register-btn {
  padding: 6px 16px;
  border-radius: 4px;
  text-decoration: none;
  font-size: 14px;
  transition: all 0.3s;
}

.login-btn {
  color: #ff5000;
}

.login-btn:hover {
  background: rgba(255, 85, 0, 0.1);
}

.register-btn {
  background: #ff5000;
  color: white;
}

.register-btn:hover {
  background: #ff6b00;
}
</style>
