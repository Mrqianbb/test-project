import request from '@/utils/request'

export function login(data) {
  return request({
    url: '/user/users/login',
    method: 'post',
    data
  })
}

export function register(data) {
  return request({
    url: '/user/users/register',
    method: 'post',
    data
  })
}

export function getUserInfo(userId) {
  return request({
    url: `/user/users/${userId}`,
    method: 'get'
  })
}
