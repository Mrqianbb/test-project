<template>
  <div class="cart-page">
    <Header />

    <main class="main-content">
      <div class="page-container">
        <div class="cart-content">
          <h2 class="cart-title">购物车</h2>

          <!-- 购物车列表 -->
          <div v-if="userStore.cart.length > 0" class="cart-items">
            <div
              v-for="item in userStore.cart"
              :key="item.id"
              class="cart-item"
            >
              <el-image
                :src="item.imageUrl"
                fit="cover"
                class="item-image"
              >
                <template #error>
                  <div class="image-error">暂无图片</div>
                </template>
              </el-image>

              <div class="item-info">
                <h3 class="item-name" :title="item.name">{{ item.name }}</h3>
                <p class="item-price">¥{{ formatPrice(item.price) }}</p>
              </div>

              <div class="item-actions">
                <el-input-number
                  v-model="item.quantity"
                  :min="1"
                  :max="99"
                  size="small"
                  @change="handleQuantityChange(item)"
                />

                <el-button
                  type="danger"
                  :icon="Delete"
                  size="small"
                  @click="handleRemove(item.id)"
                >
                  删除
                </el-button>
              </div>
            </div>
          </div>

          <!-- 空购物车 -->
          <el-empty
            v-else
            description="购物车是空的"
          >
            <el-button type="primary" @click="$router.push('/products')">
              去购物
            </el-button>
          </el-empty>

          <!-- 购物车底部 -->
          <div v-if="userStore.cart.length > 0" class="cart-footer">
            <div class="cart-summary">
              <div class="summary-item">
                <span class="label">商品数量：</span>
                <span class="value">{{ userStore.cartTotalQuantity() }} 件</span>
              </div>
              <div class="summary-item total">
                <span class="label">总计金额：</span>
                <span class="value">¥{{ formatPrice(userStore.cartTotalAmount()) }}</span>
              </div>
            </div>

            <div class="cart-actions">
              <el-button size="large" @click="handleContinue">
                继续购物
              </el-button>
              <el-button
                type="primary"
                size="large"
                @click="handleCheckout"
              >
                去结算
              </el-button>
            </div>
          </div>
        </div>
      </div>
    </main>

    <Footer />
  </div>
</template>

<script setup>
import { useRouter } from 'vue-router'
import { ElMessage, ElMessageBox } from 'element-plus'
import { useUserStore } from '@/stores/user'
import { Delete } from '@element-plus/icons-vue'
import Header from '@/components/Header.vue'
import Footer from '@/components/Footer.vue'

const router = useRouter()
const userStore = useUserStore()

const formatPrice = (price) => {
  return parseFloat(price).toFixed(2)
}

const handleQuantityChange = (item) => {
  userStore.updateCartQuantity(item.id, item.quantity)
}

const handleRemove = (productId) => {
  ElMessageBox.confirm(
    '确定要删除该商品吗？',
    '提示',
    {
      confirmButtonText: '确定',
      cancelButtonText: '取消',
      type: 'warning'
    }
  ).then(() => {
    userStore.removeFromCart(productId)
    ElMessage.success('已删除')
  })
}

const handleContinue = () => {
  router.push('/products')
}

const handleCheckout = () => {
  router.push('/order/confirm')
}
</script>

<style>
.cart-page {
  min-height: 100vh;
  display: flex;
  flex-direction: column;
}

.main-content {
  flex: 1;
  padding-top: 60px;
}

.page-container {
  max-width: 1200px;
  margin: 0 auto;
  padding: 20px;
}

.cart-content {
  background: #fff;
  border-radius: 8px;
  padding: 30px;
  box-shadow: 0 2px 8px rgba(0, 0, 0, 0.1);
}

.cart-title {
  font-size: 24px;
  color: #333;
  margin-bottom: 30px;
}

.cart-items {
  margin-bottom: 30px;
}

.cart-item {
  display: flex;
  align-items: center;
  padding: 20px 0;
  border-bottom: 1px solid #f0f0f0;
}

.cart-item:last-child {
  border-bottom: none;
}

.item-image {
  width: 100px;
  height: 100px;
  border-radius: 4px;
  overflow: hidden;
  margin-right: 20px;
}

.image-error {
  width: 100%;
  height: 100%;
  display: flex;
  align-items: center;
  justify-content: center;
  background: #f5f5f5;
  font-size: 12px;
  color: #999;
}

.item-info {
  flex: 1;
}

.item-name {
  font-size: 16px;
  color: #333;
  margin-bottom: 8px;
}

.item-price {
  font-size: 18px;
  color: #F56C6C;
  font-weight: bold;
}

.item-actions {
  display: flex;
  flex-direction: column;
  gap: 12px;
  margin-left: 20px;
}

.cart-footer {
  margin-top: 30px;
  padding-top: 30px;
  border-top: 2px solid #f0f0f0;
}

.cart-summary {
  display: flex;
  flex-direction: column;
  gap: 16px;
  margin-bottom: 30px;
}

.summary-item {
  display: flex;
  justify-content: flex-end;
  align-items: center;
  gap: 16px;
  font-size: 14px;
}

.summary-item .label {
  color: #666;
}

.summary-item .value {
  color: #333;
  font-weight: 500;
}

.summary-item.total .value {
  font-size: 24px;
  color: #F56C6C;
  font-weight: bold;
}

.cart-actions {
  display: flex;
  justify-content: flex-end;
  gap: 16px;
}
</style>
