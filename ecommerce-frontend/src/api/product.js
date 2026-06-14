import request from '@/utils/request'

export function getProductListApi(params) {
  return request({
    url: '/product/products/list',
    method: 'get',
    params
  })
}

export function getProductDetailApi(productId) {
  return request({
    url: `/product/products/${productId}`,
    method: 'get'
  })
}

export function updateStockApi(productId, quantity) {
  return request({
    url: `/product/products/${productId}/stock`,
    method: 'post',
    params: { quantity }
  })
}
