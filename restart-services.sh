#!/bin/bash

echo "======================================"
echo "重启User和Product服务"
echo "======================================"

# 设置Java环境
export JAVA_HOME=/Library/Java/JavaVirtualMachines/jdk1.8.0_221.jdk/Contents/Home
export PATH=$JAVA_HOME/bin:$PATH

# 停止User服务
echo ""
echo "1. 停止ecommerce-user服务..."
USER_PID=$(lsof -ti:8001)
if [ -n "$USER_PID" ]; then
    kill -9 $USER_PID
    echo "✓ ecommerce-user服务已停止 (PID: $USER_PID)"
else
    echo "✓ ecommerce-user服务未运行"
fi

# 停止Product服务
echo ""
echo "2. 停止ecommerce-product服务..."
PRODUCT_PID=$(lsof -ti:8002)
if [ -n "$PRODUCT_PID" ]; then
    kill -9 $PRODUCT_PID
    echo "✓ ecommerce-product服务已停止 (PID: $PRODUCT_PID)"
else
    echo "✓ ecommerce-product服务未运行"
fi

# 等待端口释放
echo ""
echo "3. 等待端口释放..."
sleep 5

# 启动User服务
echo ""
echo "4. 启动ecommerce-user服务..."
cd /Users/zyq/IdeaProjects/TestProject/ecommerce-user
nohup ../mvnw spring-boot:run > /tmp/user-service.log 2>&1 &
echo "✓ ecommerce-user服务启动中..."
sleep 5

# 检查User服务是否启动成功
if lsof -ti:8001 > /dev/null 2>&1; then
    echo "✓ ecommerce-user服务启动成功"
else
    echo "✗ ecommerce-user服务启动失败，请查看日志: tail -f /tmp/user-service.log"
fi

# 启动Product服务
echo ""
echo "5. 启动ecommerce-product服务..."
cd /Users/zyq/IdeaProjects/TestProject/ecommerce-product
nohup ../mvnw spring-boot:run > /tmp/product-service.log 2>&1 &
echo "✓ ecommerce-product服务启动中..."
sleep 5

# 检查Product服务是否启动成功
if lsof -ti:8002 > /dev/null 2>&1; then
    echo "✓ ecommerce-product服务启动成功"
else
    echo "✗ ecommerce-product服务启动失败，请查看日志: tail -f /tmp/product-service.log"
fi

# 等待服务注册到Nacos
echo ""
echo "6. 等待服务注册到Nacos..."
sleep 10

# 检查服务注册状态
echo ""
echo "7. 检查Nacos服务注册..."
echo ""
echo "ecommerce-user服务:"
curl -s "http://localhost:8848/nacos/v1/ns/instance/list?serviceName=ecommerce-user" | grep -A 5 '"ip"' | head -6
echo ""
echo "ecommerce-product服务:"
curl -s "http://localhost:8848/nacos/v1/ns/instance/list?serviceName=ecommerce-product" | grep -A 5 '"ip"' | head -6

echo ""
echo "======================================"
echo "重启完成！"
echo "======================================"
echo ""
echo "日志文件："
echo "  - User服务: tail -f /tmp/user-service.log"
echo "  - Product服务: tail -f /tmp/product-service.log"
echo ""
echo "Nacos控制台:"
echo "  - http://localhost:8848/nacos"
echo "  - 用户名: nacos"
echo "  - 密码: nacos"
echo ""
echo "如果服务IP仍为192.168.124.5，请在IDEA中重启服务。"
echo "======================================"
