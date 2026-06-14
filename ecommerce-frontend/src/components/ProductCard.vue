<template>
  <div class="taobao-product-card" @click="goToDetail">
    <!-- 商品图片 -->
    <div class="product-image">
      <img :src="product.imageUrl" :alt="product.name" />
      
      <!-- 促销标签 -->
      <div v-if="product.originalPrice" class="promo-tag">
        <span>限时特惠</span>
      </div>

      <!-- 销量标签 -->
      <div v-if="product.sales" class="sales-tag">
        月销 {{ product.sales }}
      </div>
    </div>

    <!-- 商品信息 -->
    <div class="product-info">
      <h3 class="product-name" :title="product.name">
        {{ product.name }}
      </h3>
      
      <!-- 价格区域 -->
      <div class="price-section">
        <div class="price-main">
          <span class="price-symbol">¥</span>
          <span class="price-value">{{ product.price }}</span>
          <span v-if="product.originalPrice" class="price-original">
            ¥{{ product.originalPrice }}
          </span>
        </div>
      </div>

      <!-- 销量和库存 -->
      <div class="product-meta">
        <span v-if="product.sold">已售 {{ product.sold }}件</span>
        <span v-if="product.stock" class="stock-info">
          库存{{ product.stock }}
        </span>
      </div>

      <!-- 购买按钮 -->
      <div class="action-section">
        <el-button
          type="primary"
          size="small"
          :disabled="product.stock === 0"
          @click.stop="addToCart"
        >
          加入购物车
        </el-button>
        <el-button
          type="danger"
          size="small"
          :disabled="product.stock === 0"
          @click.stop="buyNow"
        >
          立即购买
        </el-button>
      </div>
    </div>
  </div>
</template>

<script setup>
import { useRouter } from 'vue-router'
import { ElMessage } from 'element-plus'
import { useUserStore } from '@/stores/user'

const router = useRouter()
const userStore = useUserStore()

const props = defineProps({
  product: {
    type: Object,
    required: true
  }
})

const goToDetail = () => {
  router.push(`/products/${props.product.id}`)
}

const addToCart = () => {
  if (!userStore.token) {
    ElMessage.warning('请先登录')
    router.push('/login')
    return
  }

  // 更新购物车数量
  const currentCount = parseInt(localStorage.getItem('cartCount') || 0)
  localStorage.setItem('cartCount', currentCount + 1)
  
  ElMessage.success('已加入购物车')
  
  // 触发自定义事件更新header的购物车数量
  window.dispatchEvent(new Event('cart-updated'))
}

const buyNow = () => {
  if (!userStore.token) {
    ElMessage.warning('请先登录')
    router.push('/login')
    return
  }

  // 直接跳转到商品详情页
  goToDetail()
}
</script>

<style>
.taobao-product-card {
  background: white;
  border-radius: 8px;
  overflow: hidden;
  cursor: pointer;
  transition: all 0.3s;
  box-shadow: 0 2px 8px rgba(0, 0, 0, 0.08);
}

.taobao-product-card:hover {
  transform: translateY(-4px);
  box-shadow: 0 8px 24px rgba(0, 0, 0, 0.15);
}

/* 商品图片 */
.product-image {
  position: relative;
  width: 100%;
  padding-top: 100%;
  background: #f5f5f5;
  overflow: hidden;
}

.product-image img {
  position: absolute;
  top: 0;
  left: 0;
  width: 100%;
  height: 100%;
  object-fit: cover;
  transition: transform 0.3s;
}

.taobao-product-card:hover .product-image img {
  transform: scale(1.05);
}

.promo-tag {
  position: absolute;
  top: 8px;
  left: 8px;
  background: linear-gradient(135deg, #ff6b6b, #ee5a5a);
  color: white;
  padding: 4px 10px;
  border-radius: 4px;
  font-size: 12px;
  font-weight: bold;
  z-index: 2;
}

.sales-tag {
  position: absolute;
  bottom: 8px;
  right: 8px;
  background: rgba(0, 0, 0, 0.7);
  color: white;
  padding: 4px 10px;
  border-radius: 4px;
  font-size: 12px;
  z-index: 2;
}

/* 商品信息 */
.product-info {
  padding: 16px;
}

.product-name {
  font-size: 14px;
  color: #333;
  margin: 0 0 10px 0;
  overflow: hidden;
  text-overflow: ellipsis;
  white-space: nowrap;
  line-height: 1.4;
  height: 40px;
}

/* 价格区域 */
.price-section {
  margin-bottom: 12px;
}

.price-main {
  display: flex;
  align-items: baseline;
  gap: 8px;
}

.price-symbol {
  font-size: 14px;
  color: #ff5000;
  font-weight: bold;
}

.price-value {
  font-size: 24px;
  color: #ff5000;
  font-weight: bold;
}

.price-original {
  font-size: 14px;
  color: #999;
  text-decoration: line-through;
}

/* 商品元数据 */
.product-meta {
  display: flex;
  gap: 12px;
  font-size: 12px;
  color: #999;
  margin-bottom: 12px;
}

.stock-info {
  color: #ff5000;
}

/* 按钮区域 */
.action-section {
  display: flex;
  gap: 8px;
}

.action-section .el-button {
  flex: 1;
}
</style>
