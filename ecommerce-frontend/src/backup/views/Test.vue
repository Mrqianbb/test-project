<template>
  <div style="padding: 20px; background: yellow; margin: 20px;">
    <h1 style="color: red;">测试页面已加载！</h1>
    <p>这是测试页面</p>
    <p>当前路径: {{ $route.path }}</p>
  </div>
</template>

<script setup>
import { useRoute } from 'vue-router'

const $route = useRoute()
console.log('=== 测试页面 Test.vue 已加载，路径:', $route.path)
</script>
