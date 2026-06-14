import { defineStore } from 'pinia'
import { ref } from 'vue'
import { login, register } from '@/api/user'

export const useUserStore = defineStore('user', () => {
  const token = ref(localStorage.getItem('token') || '')
  const userInfo = ref(null)

  // 从 localStorage 恢复用户信息
  if (localStorage.getItem('userInfo')) {
    try {
      userInfo.value = JSON.parse(localStorage.getItem('userInfo'))
    } catch (e) {
      console.error('解析用户信息失败:', e)
    }
  }

  const userLogin = async (loginForm) => {
    try {
      const data = await login(loginForm)

      token.value = data.token
      userInfo.value = {
        userId: data.userId,
        username: data.username,
        nickname: data.nickname || data.username,
        avatar: data.avatar
      }
      localStorage.setItem('token', data.token)
      localStorage.setItem('userInfo', JSON.stringify(userInfo.value))
      return true
    } catch (error) {
      console.error('登录失败:', error)
      return false
    }
  }

  const userRegister = async (registerForm) => {
    try {
      const data = await register(registerForm)
      return data
    } catch (error) {
      console.error('注册失败:', error)
      throw error
    }
  }

  const logout = () => {
    token.value = ''
    userInfo.value = null
    localStorage.removeItem('token')
    localStorage.removeItem('userInfo')
  }

  return {
    token,
    userInfo,
    login: userLogin,
    register: userRegister,
    logout
  }
})
