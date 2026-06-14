import { defineStore } from 'pinia'
import { ref } from 'vue'
import { getProductListApi, getProductDetailApi } from '@/api/product'

export const useProductStore = defineStore('product', () => {
  const productList = ref([])
  const productDetail = ref(null)
  const loading = ref(false)

  // 获取商品列表
  const fetchProductList = async (params = {}) => {
    try {
      loading.value = true
      const data = await getProductListApi(params)
      productList.value = data
      return data
    } catch (error) {
      console.error('获取商品列表失败:', error)
      return []
    } finally {
      loading.value = false
    }
  }

  // 获取商品详情
  const fetchProductDetail = async (productId) => {
    try {
      loading.value = true
      const data = await getProductDetailApi(productId)
      productDetail.value = data
      return data
    } catch (error) {
      console.error('获取商品详情失败:', error)
      return null
    } finally {
      loading.value = false
    }
  }

  return {
    productList,
    productDetail,
    loading,
    fetchProductList,
    fetchProductDetail
  }
})
