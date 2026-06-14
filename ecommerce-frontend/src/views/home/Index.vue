<template>
  <div class="taobao-home">
    <Header />

    <!-- 搜索栏 -->
    <div class="search-bar">
      <div class="search-container">
        <el-input
          v-model="searchKeyword"
          placeholder="搜索宝贝"
          size="large"
          class="search-input"
          @keyup.enter="handleSearch"
        >
          <template #prefix>
            <el-icon><Search /></el-icon>
          </template>
          <template #append>
            <el-button type="primary" @click="handleSearch">搜索</el-button>
          </template>
        </el-input>
      </div>
    </div>

    <!-- 轮播图 -->
    <div class="banner">
      <el-carousel height="400px" :interval="4000" arrow="hover">
        <el-carousel-item v-for="(item, index) in banners" :key="index">
          <div class="banner-item" :style="{ backgroundImage: `url(${item.image})` }">
            <div class="banner-content">
              <h2>{{ item.title }}</h2>
              <p>{{ item.desc }}</p>
            </div>
          </div>
        </el-carousel-item>
      </el-carousel>
    </div>

    <!-- 分类导航 -->
    <div class="category-nav">
      <div class="category-item" v-for="category in categories" :key="category.id" @click="goToCategory(category.id)">
        <el-icon :size="40" :color="category.color">
          <component :is="category.icon" />
        </el-icon>
        <span>{{ category.name }}</span>
      </div>
    </div>

    <!-- 热门商品 -->
    <div class="section">
      <div class="section-header">
        <h2>🔥 热门推荐</h2>
        <router-link to="/products" class="more-link">更多 ></router-link>
      </div>
      <div class="product-grid">
        <ProductCard
          v-for="product in hotProducts"
          :key="product.id"
          :product="product"
        />
      </div>
    </div>

    <!-- 促销活动 -->
    <div class="section promo-section">
      <div class="promo-item" v-for="(promo, index) in promotions" :key="index">
        <div class="promo-content">
          <span class="promo-tag">{{ promo.tag }}</span>
          <h3>{{ promo.title }}</h3>
          <p>{{ promo.desc }}</p>
        </div>
      </div>
    </div>

    <Footer />
  </div>
</template>

<script setup>
import { ref, onMounted } from 'vue'
import { useRouter } from 'vue-router'
import { useProductStore } from '@/stores/product'
import Header from '@/components/Header.vue'
import Footer from '@/components/Footer.vue'
import ProductCard from '@/components/ProductCard.vue'
import { Search } from '@element-plus/icons-vue'

const router = useRouter()
const productStore = useProductStore()

const searchKeyword = ref('')

const banners = ref([
  {
    title: '618大促',
    desc: '全场低至5折',
    image: 'https://via.placeholder.com/1200x400/667eea/ffffff?text=618'
  },
  {
    title: '新品上市',
    desc: '限时特惠',
    image: 'https://via.placeholder.com/1200x400/67c23a/ffffff?text=New'
  },
  {
    title: '品牌特卖',
    desc: '品质保证',
    image: 'https://via.placeholder.com/1200x400/e6a23c/ffffff?text=Sale'
  }
])

const categories = ref([
  { id: 1, name: '数码', color: '#409EFF', icon: 'Monitor' },
  { id: 2, name: '服装', color: '#67C23A', icon: 'Sunny' },
  { id: 3, name: '食品', color: '#E6A23C', icon: 'Coffee' },
  { id: 4, name: '家居', color: '#F56C6C', icon: 'House' },
  { id: 5, name: '美妆', color: '#909399', icon: 'Star' },
  { id: 6, name: '运动', color: '#409EFF', icon: 'TrendCharts' },
  { id: 7, name: '图书', color: '#67C23A', icon: 'Reading' },
  { id: 8, name: '母婴', color: '#E6A23C', icon: 'Present' }
])

const hotProducts = ref([])

const promotions = ref([
  { tag: '限时', title: '新品首发', desc: '精选新品限时优惠' },
  { tag: '满减', title: '满200减30', desc: '全场通用' },
  { tag: '包邮', title: '全场包邮', desc: '无门槛包邮' }
])

const handleSearch = () => {
  if (searchKeyword.value) {
    router.push({
      path: '/products',
      query: { keyword: searchKeyword.value }
    })
  }
}

const goToCategory = (categoryId) => {
  router.push({
    path: '/products',
    query: { categoryId }
  })
}

onMounted(async () => {
  // 模拟加载热门商品
  hotProducts.value = [
    {
      id: 1,
      name: 'iPhone 15 Pro Max',
      description: '苹果 iPhone 15 Pro Max 256GB',
      price: 8999,
      originalPrice: 9999,
      stock: 100,
      sold: 256,
      imageUrl: 'https://via.placeholder.com/300x300/409eff/ffffff?text=iPhone',
      sales: '2.5万+'
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
      sales: '1.8万+'
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
      sales: '3.2万+'
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
      sales: '4.1万+'
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
      sales: '5.6万+'
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
      sales: '1.9万+'
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
      sales: '3.8万+'
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
      sales: '2.7万+'
    }
  ]
})
</script>

<style>
.taobao-home {
  min-height: 100vh;
  background: #f5f7fa;
}

/* 搜索栏 */
.search-bar {
  background: linear-gradient(to right, #ff5000, #ff6b00);
  padding: 20px 0;
  position: sticky;
  top: 60px;
  z-index: 100;
}

.search-container {
  max-width: 800px;
  margin: 0 auto;
  padding: 0 20px;
}

.search-input {
  background: white !important;
  border-radius: 25px !important;
}

.search-input :deep(.el-input__wrapper) {
  border-radius: 25px;
}

/* 轮播图 */
.banner {
  max-width: 1200px;
  margin: 20px auto;
  border-radius: 12px;
  overflow: hidden;
}

.banner-item {
  width: 100%;
  height: 100%;
  background-size: cover;
  background-position: center;
  display: flex;
  align-items: center;
  justify-content: center;
  color: white;
  text-shadow: 2px 2px 4px rgba(0,0,0,0.5);
}

.banner-content h2 {
  font-size: 48px;
  margin: 0 0 10px 0;
}

.banner-content p {
  font-size: 24px;
  margin: 0;
}

/* 分类导航 */
.category-nav {
  max-width: 1200px;
  margin: 30px auto;
  padding: 0 20px;
  display: grid;
  grid-template-columns: repeat(8, 1fr);
  gap: 15px;
  background: white;
  padding: 20px;
  border-radius: 12px;
  box-shadow: 0 2px 8px rgba(0, 0, 0, 0.1);
}

.category-item {
  display: flex;
  flex-direction: column;
  align-items: center;
  cursor: pointer;
  padding: 15px 10px;
  border-radius: 8px;
  transition: all 0.3s;
}

.category-item:hover {
  background: #f5f7fa;
  transform: translateY(-3px);
}

.category-item span {
  font-size: 14px;
  color: #666;
  margin-top: 8px;
}

/* 商品区域 */
.section {
  max-width: 1200px;
  margin: 40px auto;
  padding: 0 20px;
}

.section-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  margin-bottom: 20px;
}

.section-header h2 {
  font-size: 24px;
  color: #333;
  margin: 0;
}

.more-link {
  color: #ff5000;
  text-decoration: none;
  font-size: 14px;
}

.product-grid {
  display: grid;
  grid-template-columns: repeat(4, 1fr);
  gap: 20px;
}

/* 促销活动 */
.promo-section {
  display: grid;
  grid-template-columns: repeat(3, 1fr);
  gap: 20px;
  margin-top: 40px;
}

.promo-item {
  background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
  border-radius: 12px;
  padding: 30px;
  color: white;
  text-align: center;
  cursor: pointer;
  transition: all 0.3s;
}

.promo-item:hover {
  transform: translateY(-5px);
  box-shadow: 0 8px 24px rgba(102, 126, 234, 0.3);
}

.promo-tag {
  display: inline-block;
  padding: 4px 12px;
  background: rgba(255, 255, 255, 0.3);
  border-radius: 4px;
  font-size: 12px;
  margin-bottom: 15px;
}

.promo-content h3 {
  font-size: 20px;
  margin: 0 0 8px 0;
}

.promo-content p {
  font-size: 14px;
  margin: 0;
  opacity: 0.9;
}

@media (max-width: 768px) {
  .category-nav {
    grid-template-columns: repeat(4, 1fr);
  }

  .product-grid {
    grid-template-columns: repeat(2, 1fr);
  }

  .promo-section {
    grid-template-columns: 1fr;
  }
}
</style>
