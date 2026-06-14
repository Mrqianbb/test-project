<template>
  <el-footer class="footer">
    <div class="footer-content">
      <div class="footer-section">
        <h3>关于我们</h3>
        <ul>
          <li><a href="#">公司简介</a></li>
          <li><a href="#">联系方式</a></li>
          <li><a href="#">加入我们</a></li>
        </ul>
      </div>

      <div class="footer-section">
        <h3>帮助中心</h3>
        <ul>
          <li><a href="#">购物指南</a></li>
          <li><a href="#">支付方式</a></li>
          <li><a href="#">配送方式</a></li>
          <li><a href="#">售后服务</a></li>
        </ul>
      </div>

      <div class="footer-section">
        <h3>售后服务</h3>
        <ul>
          <li><a href="#">退换货政策</a></li>
          <li><a href="#">退款说明</a></li>
          <li><a href="#">取消订单</a></li>
        </ul>
      </div>

      <div class="footer-section">
        <h3>联系方式</h3>
        <ul>
          <li>客服热线：400-123-4567</li>
          <li>工作时间：9:00-18:00</li>
          <li>邮箱：service@example.com</li>
        </ul>
      </div>
    </div>

    <div class="footer-bottom">
      <p>&copy; 2024 电商平台 版权所有</p>
    </div>
  </el-footer>
</template>

<script setup>
</script>

<style>
.footer {
  background: #f5f5f5;
  padding: 40px 0 20px;
  margin-top: auto;
}

.footer-content {
  max-width: 1200px;
  margin: 0 auto;
  display: grid;
  grid-template-columns: repeat(4, 1fr);
  gap: 40px;
}

.footer-section h3 {
  font-size: 16px;
  font-weight: bold;
  color: #333;
  margin-bottom: 20px;
}

.footer-section ul {
  list-style: none;
  padding: 0;
  margin: 0;
}

.footer-section li {
  margin-bottom: 12px;
}

.footer-section a {
  color: #666;
  text-decoration: none;
  font-size: 14px;
  transition: color 0.3s;
}

.footer-section a:hover {
  color: #409EFF;
}

.footer-bottom {
  max-width: 1200px;
  margin: 40px auto 0;
  text-align: center;
  padding-top: 20px;
  border-top: 1px solid #e0e0e0;
}

.footer-bottom p {
  color: #999;
  font-size: 14px;
  margin: 0;
}
</style>
