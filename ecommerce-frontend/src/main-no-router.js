import { createApp } from 'vue'
import AppNoRouter from './App-no-router.vue'

console.log('=== 开始启动应用 ===')

const app = createApp(AppNoRouter)
app.mount('#app')

console.log('=== 应用已挂载 ===')
