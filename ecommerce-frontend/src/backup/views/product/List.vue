<template>
  <div class="product-list-page">
    <Header />

    <main class="main-content">
      <div class="page-container">
        <!-- 分类筛选 -->
        <div class="filter-bar">
          <div class="filter-item">
            <span class="filter-label">商品分类：</span>
            <el-select
              v-model="selectedCategory"
              placeholder="全部分类"
              clearable
              @change="handleCategoryChange"
            >
              <el-option
                v-for="category in categories"
                :key="category.id"
                :label="category.name"
                :value="category.id"
              />
            </el-select>
          </div>

          <div class="filter-item">
            <span class="filter-label">排序方式：</span>
            <el-select v-model="sortBy" @change="handleSort">
              <el-option label="默认排序" value="default" />
              <el-option label="价格从低到高" value="price-asc" />
              <el-option label="价格从高到低" value="price-desc" />
            </el-select>
          </div>
        </div>

        <!-- 商品列表 -->
        <div v-loading="productStore.loading" class="product-grid">
          <ProductCard
            v-for="product in displayProducts"
            :key="product.id"
            :product="product"
          />
        </div>

        <!-- 空状态 -->
        <el-empty
          v-if="!productStore.loading && displayProducts.length === 0"
          description="暂无商品"
        />
      </div>
    </main>

    <Footer />
  </div>
</template>

<script setup>
import { ref, computed, onMounted, watch } from 'vue'
import { useRoute } from 'vue-router'
import { useProductStore } from '@/stores/product'
import Header from '@/components/Header.vue'
import Footer from '@/components/Footer.vue'
import ProductCard from '@/components/ProductCard.vue'

const route = useRoute()
const productStore = useProductStore()

const selectedCategory = ref(null)
const sortBy = ref('default')

const categories = [
  { id: 1, name: '数码产品' },
  { id: 2, name: '服装鞋帽' },
  { id: 3, name: '食品饮料' },
  { id: 4, name: '家居用品' }
]

// 显示的商品列表
const displayProducts = computed(() => {
  let products = [...productStore.productList]

  // 排序
  switch (sortBy.value) {
    case 'price-asc':
      products.sort((a, b) => a.price - b.price)
      break
    case 'price-desc':
      products.sort((a, b) => b.price - a.price)
      break
  }

  return products
})

const handleCategoryChange = async (categoryId) => {
  await productStore.fetchProductList(categoryId)
}

const handleSort = () => {
  // 排序在计算属性中处理
}

// 监听路由参数
watch(
  () => route.query.categoryId,
  async (newCategoryId) => {
    if (newCategoryId) {
      selectedCategory.value = parseInt(newCategoryId)
      await productStore.fetchProductList(newCategoryId)
    }
  },
  { immediate: true }
)

onMounted(async () => {
  // 加载商品列表
  await productStore.fetchProductList()
})
</script>

<style>
.product-list-page {
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

.filter-bar {
  background: #fff;
  padding: 20px;
  border-radius: 8px;
  margin-bottom: 20px;
  display: flex;
  gap: 40px;
}

.filter-item {
  display: flex;
  align-items: center;
  gap: 8px;
}

.filter-label {
  font-size: 14px;
  color: #666;
}

.product-grid {
  display: grid;
  grid-template-columns: repeat(4, 1fr);
  gap: 20px;
  min-height: 400px;
}

@media (max-width: 768px) {
  .filter-bar {
    flex-direction: column;
    gap: 16px;
  }

  .product-grid {
    grid-template-columns: repeat(2, 1fr);
  }
}
</style>
