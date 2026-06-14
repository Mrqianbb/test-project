<template>
  <div class="taobao-products">
    <Header />

    <div class="main-content">
      <!-- 筛选侧边栏 -->
      <div class="filter-sidebar">
        <!-- 分类 -->
        <div class="filter-section">
          <h3>商品分类</h3>
          <div class="filter-list">
            <el-radio-group v-model="selectedCategory" @change="filterProducts">
              <el-radio label="">全部</el-radio>
              <el-radio v-for="cat in categories" :key="cat.id" :label="cat.id">
                {{ cat.name }}
              </el-radio>
            </el-radio-group>
          </div>
        </div>

        <!-- 价格区间 -->
        <div class="filter-section">
          <h3>价格区间</h3>
          <div class="price-filter">
            <el-radio-group v-model="selectedPriceRange" @change="filterProducts">
              <el-radio label="">全部</el-radio>
              <el-radio label="0-100">0-100元</el-radio>
              <el-radio label="100-500">100-500元</el-radio>
              <el-radio label="500-1000">500-1000元</el-radio>
              <el-radio label="1000+">1000元以上</el-radio>
            </el-radio-group>
          </div>
        </div>

        <!-- 排序 -->
        <div class="filter-section">
          <h3>排序方式</h3>
          <div class="sort-filter">
            <el-radio-group v-model="sortBy" @change="filterProducts">
              <el-radio label="default">默认</el-radio>
              <el-radio label="sales">销量优先</el-radio>
              <el-radio label="price-asc">价格从低到高</el-radio>
              <el-radio label="price-desc">价格从高到低</el-radio>
            </el-radio-group>
          </div>
        </div>
      </div>

      <!-- 商品列表 -->
      <div class="product-list">
        <!-- 搜索结果提示 -->
        <div v-if="searchKeyword" class="search-info">
          搜索结果: <span class="keyword">{{ searchKeyword }}</span>
          <el-button link type="primary" @click="clearSearch">清除</el-button>
        </div>

        <!-- 商品数量 -->
        <div class="product-count">
          共 <span class="count">{{ filteredProducts.length }}</span> 件商品
        </div>

        <!-- 商品网格 -->
        <div class="products-grid">
          <ProductCard
            v-for="product in filteredProducts"
            :key="product.id"
            :product="product"
          />
        </div>

        <!-- 空状态 -->
        <el-empty v-if="filteredProducts.length === 0" description="暂无商品" />
      </div>
    </div>

    <Footer />
  </div>
</template>

<script setup>
import { ref, computed, onMounted } from 'vue'
import { useRoute, useRouter } from 'vue-router'
import Header from '@/components/Header.vue'
import Footer from '@/components/Footer.vue'
import ProductCard from '@/components/ProductCard.vue'

const route = useRoute()
const router = useRouter()

const searchKeyword = ref('')
const selectedCategory = ref('')
const selectedPriceRange = ref('')
const sortBy = ref('default')

const categories = ref([
  { id: 1, name: '数码' },
  { id: 2, name: '服装' },
  { id: 3, name: '食品' },
  { id: 4, name: '家居' },
  { id: 5, name: '美妆' },
  { id: 6, name: '运动' },
  { id: 7, name: '图书' },
  { id: 8, name: '母婴' }
])

const products = ref([])

// 模拟商品数据
const loadProducts = () => {
  products.value = [
    {
      id: 1,
      name: 'iPhone 15 Pro Max',
      description: '苹果 iPhone 15 Pro Max 256GB',
      price: 8999,
      originalPrice: 9999,
      stock: 100,
      sold: 256,
      imageUrl: 'https://via.placeholder.com/300x300/409eff/ffffff?text=iPhone',
      sales: '2.5万+',
      category: 1
    },
    {
      id: 2,
      name: '华为 Mate 60 Pro',
      description: '华为 Mate 60 Pro 麒麟9000',
      price: 6999,
      originalPrice: 7999,
      stock: 50,
      sold: 189,
      imageUrl: 'https://via.placeholder.com/300x300/67c23a/ffffff?text=Huawei',
      sales: '1.8万+',
      category: 1
    },
    {
      id: 3,
      name: 'Nike Air Max 270',
      description: 'Nike Air Max 270 男士运动鞋',
      price: 899,
      originalPrice: 1299,
      stock: 200,
      sold: 456,
      imageUrl: 'https://via.placeholder.com/300x300/e6a23c/ffffff?text=Nike',
      sales: '3.2万+',
      category: 2
    },
    {
      id: 4,
      name: 'SK-II 神仙水',
      description: 'SK-II 神仙水 230ml',
      price: 1690,
      originalPrice: 1990,
      stock: 80,
      sold: 321,
      imageUrl: 'https://via.placeholder.com/300x300/f56c6c/ffffff?text=SK-II',
      sales: '4.1万+',
      category: 5
    },
    {
      id: 5,
      name: '小米14 Pro',
      description: '小米14 Pro 骁龙8 Gen3',
      price: 4999,
      originalPrice: 5999,
      stock: 150,
      sold: 678,
      imageUrl: 'https://via.placeholder.com/300x300/909399/ffffff?text=Xiaomi',
      sales: '5.6万+',
      category: 1
    },
    {
      id: 6,
      name: '戴森 V15 吸尘器',
      description: '戴森 V15 激光探测吸尘器',
      price: 4990,
      originalPrice: 5990,
      stock: 60,
      sold: 234,
      imageUrl: 'https://via.placeholder.com/300x300/409eff/ffffff?text=Dyson',
      sales: '1.9万+',
      category: 4
    },
    {
      id: 7,
      name: '耐克 Air Jordan',
      description: 'Air Jordan 1 Retro High',
      price: 1299,
      originalPrice: 1699,
      stock: 90,
      sold: 567,
      imageUrl: 'https://via.placeholder.com/300x300/67c23a/ffffff?text=AJ1',
      sales: '3.8万+',
      category: 6
    },
    {
      id: 8,
      name: '兰蔻小黑瓶',
      description: '兰蔻小黑瓶精华 100ml',
      price: 1080,
      originalPrice: 1280,
      stock: 120,
      sold: 432,
      imageUrl: 'https://via.placeholder.com/300x300/e6a23c/ffffff?text=Lancome',
      sales: '2.7万+',
      category: 5
    },
    {
      id: 9,
      name: 'iPad Pro 12.9',
      description: '苹果 iPad Pro 12.9英寸 M2芯片',
      price: 7999,
      originalPrice: 8999,
      stock: 80,
      sold: 345,
      imageUrl: 'https://via.placeholder.com/300x300/909399/ffffff?text=iPad',
      sales: '1.5万+',
      category: 1
    },
    {
      id: 10,
      name: '优衣库羽绒服',
      description: '优衣库男士轻量羽绒服',
      price: 599,
      originalPrice: 799,
      stock: 300,
      sold: 789,
      imageUrl: 'https://via.placeholder.com/300x300/67c23a/ffffff?text=Uniqlo',
      sales: '4.5万+',
      category: 2
    },
    {
      id: 11,
      name: '雅诗兰黛小棕瓶',
      description: '雅诗兰黛小棕瓶精华 50ml',
      price: 980,
      originalPrice: 1180,
      stock: 100,
      sold: 289,
      imageUrl: 'https://via.placeholder.com/300x300/f56c6c/ffffff?text=Estee',
      sales: '2.3万+',
      category: 5
    },
    {
      id: 12,
      name: '阿迪达斯Ultra Boost',
      description: '阿迪达斯Ultra Boost 21',
      price: 1099,
      originalPrice: 1499,
      stock: 180,
      sold: 523,
      imageUrl: 'https://via.placeholder.com/300x300/e6a23c/ffffff?text=Adidas',
      sales: '3.1万+',
      category: 6
    }
  ]
}

// 筛选商品
const filteredProducts = computed(() => {
  let result = [...products.value]

  // 搜索筛选
  if (searchKeyword.value) {
    result = result.filter(p => 
      p.name.toLowerCase().includes(searchKeyword.value.toLowerCase())
    )
  }

  // 分类筛选
  if (selectedCategory.value) {
    result = result.filter(p => p.category === parseInt(selectedCategory.value))
  }

  // 价格筛选
  if (selectedPriceRange.value) {
    if (selectedPriceRange.value === '0-100') {
      result = result.filter(p => p.price <= 100)
    } else if (selectedPriceRange.value === '100-500') {
      result = result.filter(p => p.price > 100 && p.price <= 500)
    } else if (selectedPriceRange.value === '500-1000') {
      result = result.filter(p => p.price > 500 && p.price <= 1000)
    } else if (selectedPriceRange.value === '1000+') {
      result = result.filter(p => p.price > 1000)
    }
  }

  // 排序
  if (sortBy.value === 'sales') {
    result.sort((a, b) => b.sold - a.sold)
  } else if (sortBy.value === 'price-asc') {
    result.sort((a, b) => a.price - b.price)
  } else if (sortBy.value === 'price-desc') {
    result.sort((a, b) => b.price - a.price)
  }

  return result
})

const filterProducts = () => {
  // 触发computed更新
}

const clearSearch = () => {
  searchKeyword.value = ''
  selectedCategory.value = ''
  selectedPriceRange.value = ''
  sortBy.value = 'default'
  router.push('/products')
}

onMounted(() => {
  loadProducts()
  
  // 获取搜索关键词
  if (route.query.keyword) {
    searchKeyword.value = route.query.keyword
  }
  
  // 获取分类
  if (route.query.categoryId) {
    selectedCategory.value = route.query.categoryId
  }
})
</script>

<style>
.taobao-products {
  min-height: 100vh;
  background: #f5f7fa;
}

.main-content {
  max-width: 1400px;
  margin: 0 auto;
  padding: 76px 20px 40px;
  display: flex;
  gap: 20px;
}

/* 筛选侧边栏 */
.filter-sidebar {
  width: 200px;
  flex-shrink: 0;
  background: white;
  border-radius: 8px;
  padding: 20px;
  height: fit-content;
}

.filter-section {
  margin-bottom: 24px;
}

.filter-section h3 {
  font-size: 14px;
  font-weight: bold;
  color: #333;
  margin-bottom: 12px;
}

.filter-list,
.price-filter,
.sort-filter {
  display: flex;
  flex-direction: column;
  gap: 12px;
}

.filter-list :deep(.el-radio) {
  margin-bottom: 8px;
  margin-right: 0;
}

/* 商品列表 */
.product-list {
  flex: 1;
}

.search-info {
  background: #fff7e6;
  padding: 12px 16px;
  border-radius: 4px;
  margin-bottom: 16px;
  display: flex;
  justify-content: space-between;
  align-items: center;
  color: #f56c6c;
}

.search-info .keyword {
  font-weight: bold;
}

.product-count {
  color: #666;
  font-size: 14px;
  margin-bottom: 16px;
}

.product-count .count {
  color: #ff5000;
  font-weight: bold;
  font-size: 16px;
}

.products-grid {
  display: grid;
  grid-template-columns: repeat(auto-fill, minmax(220px, 1fr));
  gap: 16px;
}

@media (max-width: 768px) {
  .main-content {
    flex-direction: column;
  }

  .filter-sidebar {
    width: 100%;
    margin-bottom: 20px;
  }

  .products-grid {
    grid-template-columns: repeat(2, 1fr);
  }
}
</style>
