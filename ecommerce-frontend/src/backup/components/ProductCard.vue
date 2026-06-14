<template>
  <div class="product-card" @click="goToDetail">
    <div class="product-image">
      <el-image
        :src="product.imageUrl"
        fit="cover"
        class="image"
      >
        <template #error>
          <div class="image-error">
            <el-icon :size="40" color="#ccc">
              <Picture />
            </el-icon>
          </div>
        </template>
      </el-image>
      <div v-if="product.stock === 0" class="out-of-stock">
        已售罄
      </div>
    </div>

    <div class="product-info">
      <h3 class="product-name" :title="product.name">{{ product.name }}</h3>
      <p class="product-desc" :title="product.description">
        {{ product.description }}
      </p>

      <div class="product-footer">
        <div class="product-price">
          <span class="price-symbol">¥</span>
          <span class="price-value">{{ formatPrice(product.price) }}</span>
        </div>

        <el-button
          type="primary"
          :disabled="product.stock === 0"
          @click.stop="addToCart"
        >
          {{ product.stock === 0 ? '已售罄' : '加入购物车' }}
        </el-button>
      </div>
    </div>
  </div>
</template>

<script setup>
import { useRouter } from 'vue-router'
import { ElMessage } from 'element-plus'
import { useUserStore } from '@/stores/user'
import { Picture } from '@element-plus/icons-vue'

const props = defineProps({
  product: {
    type: Object,
    required: true
  }
})

const router = useRouter()
const userStore = useUserStore()

const formatPrice = (price) => {
  return parseFloat(price).toFixed(2)
}

const goToDetail = () => {
  router.push(`/products/${props.product.id}`)
}

const addToCart = () => {
  if (!userStore.token) {
    ElMessage.warning('请先登录')
    router.push('/login')
    return
  }

  userStore.addToCart(props.product)
  ElMessage.success('已加入购物车')
}
</script>

<style>
.product-card {
  background: #fff;
  border-radius: 8px;
  overflow: hidden;
  cursor: pointer;
  transition: all 0.3s;
  box-shadow: 0 2px 8px rgba(0, 0, 0, 0.1);
}

.product-card:hover {
  transform: translateY(-8px);
  box-shadow: 0 8px 16px rgba(0, 0, 0, 0.15);
}

.product-image {
  position: relative;
  padding-top: 100%;
  background: #f5f5f5;
  overflow: hidden;
}

.image {
  position: absolute;
  top: 0;
  left: 0;
  width: 100%;
  height: 100%;
}

.image-error {
  width: 100%;
  height: 100%;
  display: flex;
  align-items: center;
  justify-content: center;
  background: #f5f5f5;
}

.out-of-stock {
  position: absolute;
  top: 0;
  left: 0;
  right: 0;
  bottom: 0;
  background: rgba(0, 0, 0, 0.6);
  display: flex;
  align-items: center;
  justify-content: center;
  color: #fff;
  font-size: 18px;
  font-weight: bold;
}

.product-info {
  padding: 16px;
}

.product-name {
  font-size: 16px;
  color: #333;
  margin-bottom: 8px;
  overflow: hidden;
  text-overflow: ellipsis;
  white-space: nowrap;
}

.product-desc {
  font-size: 14px;
  color: #999;
  margin-bottom: 12px;
  overflow: hidden;
  text-overflow: ellipsis;
  white-space: nowrap;
}

.product-footer {
  display: flex;
  justify-content: space-between;
  align-items: center;
}

.product-price {
  display: flex;
  align-items: baseline;
}

.price-symbol {
  font-size: 14px;
  color: #F56C6C;
  margin-right: 2px;
}

.price-value {
  font-size: 20px;
  font-weight: bold;
  color: #F56C6C;
}
</style>
