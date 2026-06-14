<template>
  <div class="taobao-footer">
    <!-- 主要内容 -->
    <div class="footer-content">
      <div class="footer-section">
        <h3>购物指南</h3>
        <ul>
          <li><a href="#">购物流程</a></li>
          <li><a href="#">常见问题</a></li>
          <li><a href="#">在线支付</a></li>
        </ul>
      </div>

      <div class="footer-section">
        <h3>配送方式</h3>
        <ul>
          <li><a href="#">上门自提</a></li>
          <li><a href="#">物流配送</a></li>
          <li><a href="#">配送查询</a></li>
        </ul>
      </div>

      <div class="footer-section">
        <h3>售后服务</h3>
        <ul>
          <li><a href="#">售后政策</a></li>
          <li><a href="#">价格保护</a></li>
          <li><a href="#">退款说明</a></li>
          <li><a href="#">取消订单</a></li>
        </ul>
      </div>

      <div class="footer-section">
        <h3>关于我们</h3>
        <ul>
          <li><a href="#">公司简介</a></li>
          <li><a href="#">联系我们</a></li>
          <li><a href="#">加入我们</a></li>
        </ul>
      </div>

      <div class="footer-section">
        <h3>帮助中心</h3>
        <ul>
          <li><a href="#">商家中心</a></li>
          <li><a href="#">客服中心</a></li>
          <li><a href="#">意见反馈</a></li>
        </ul>
      </div>
    </div>

    <!-- 底部信息 -->
    <div class="footer-bottom">
      <p class="copyright">© 2024 淘淘网 版权所有</p>
      <div class="links">
        <a href="#">隐私政策</a>
        <a href="#">用户协议</a>
        <a href="#">关于我们</a>
        <a href="#">联系客服</a>
      </div>
    </div>
  </div>
</template>

<script setup>
</script>

<style>
.taobao-footer {
  background: #f5f5f5;
  padding: 40px 0 20px;
  margin-top: 60px;
}

.footer-content {
  max-width: 1200px;
  margin: 0 auto;
  display: grid;
  grid-template-columns: repeat(5, 1fr);
  gap: 40px;
  padding: 0 20px;
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
  line-height: 1.8;
}

.footer-section a:hover {
  color: #ff5000;
}

.footer-bottom {
  max-width: 1200px;
  margin: 40px auto 0;
  text-align: center;
  padding-top: 20px;
  border-top: 1px solid #e0e0e0;
}

.copyright {
  color: #999;
  font-size: 14px;
  margin: 0 0 10px 0;
}

.links {
  display: flex;
  justify-content: center;
  gap: 20px;
}

.links a {
  color: #999;
  text-decoration: none;
  font-size: 13px;
  transition: color 0.3s;
}

.links a:hover {
  color: #ff5000;
}

@media (max-width: 768px) {
  .footer-content {
    grid-template-columns: repeat(2, 1fr);
  }
}
</style>
