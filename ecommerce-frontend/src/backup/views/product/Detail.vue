<template>
  <div class="product-detail">
    <el-row :gutter="20" v-if="product">
      <el-col :span="12">
        <el-image :src="product.image" fit="cover" class="product-image">
          <template #error>
            <div class="image-placeholder">
              <el-icon><Picture /></el-icon>
            </div>
          </template>
        </el-image>
      </el-col>
      
      <el-col :span="12">
        <div class="product-info">
          <h1>{{ product.name }}</h1>
          <p class="description">{{ product.description }}</p>
          <div class="price">¥{{ product.price.toFixed(2) }}</div>
          
          <div class="meta">
            <p><span>分类：</span>{{ product.category }}</p>
            <p><span>库存：</span>{{ product.stock }}件</p>
            <p><span>销量：</span>{{ product.sold }}件</p>
          </div>
          
          <div class="actions">
            <el-input-number v-model="quantity" :min="1" :max="product.stock" size="large" />
            <el-button type="primary" size="large" @click="addToCart" :loading="loading">
              加入购物车
            </el-button>
            <el-button size="large" @click="buyNow">
              立即购买
            </el-button>
          </div>
        </div>
      </el-col>
    </el-row>
    
    <el-empty v-else description="商品不存在" />
  </div>
</template>

<script setup>
import { ref, onMounted } from 'vue'
import { useRoute, useRouter } from 'vue-router'
import { ElMessage } from 'element-plus'
import { Picture } from '@element-plus/icons-vue'
import { getProductById } from '@/api/product'
import { useUserStore } from '@/stores/user'

const route = useRoute()
const router = useRouter()
const userStore = useUserStore()

const product = ref(null)
const quantity = ref(1)
const loading = ref(false)

const loadProduct = async () => {
  try {
    const id = route.params.id
    product.value = await getProductById(id)
  } catch (error) {
    ElMessage.error(error.message || '加载商品详情失败')
  }
}

const addToCart = async () => {
  if (!userStore.token) {
    ElMessage.warning('请先登录')
    router.push('/login?redirect=' + encodeURIComponent(route.fullPath))
    return
  }
  
  loading.value = true
  try {
    userStore.addToCart({
      productId: product.value.id,
      quantity: quantity.value,
      product: product.value
    })
    ElMessage.success('已加入购物车')
  } catch (error) {
    ElMessage.error(error.message || '加入购物车失败')
  } finally {
    loading.value = false
  }
}

const buyNow = async () => {
  if (!userStore.token) {
    ElMessage.warning('请先登录')
    router.push('/login?redirect=' + encodeURIComponent(route.fullPath))
    return
  }
  
  await addToCart()
  router.push('/order/confirm')
}

onMounted(() => {
  loadProduct()
})
</script>

<style>
.product-detail {
  padding: 20px;
}

.product-image {
  width: 100%;
  height: 400px;
  border-radius: 8px;
}

.image-placeholder {
  width: 100%;
  height: 100%;
  display: flex;
  align-items: center;
  justify-content: center;
  background: #f5f7fa;
  color: #909399;
}

.image-placeholder .el-icon {
  font-size: 48px;
}

.product-info h1 {
  font-size: 28px;
  color: #303133;
  margin: 0 0 15px 0;
}

.description {
  color: #606266;
  font-size: 14px;
  line-height: 1.6;
  margin-bottom: 20px;
}

.price {
  font-size: 32px;
  color: #f56c6c;
  font-weight: bold;
  margin-bottom: 20px;
}

.meta p {
  margin: 8px 0;
  color: #606266;
}

.meta span {
  font-weight: bold;
  color: #303133;
  margin-right: 8px;
}

.actions {
  display: flex;
  gap: 15px;
  margin-top: 30px;
}
</style>
