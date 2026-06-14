#!/bin/bash

# 编译并启动项目的脚本

echo "======================================"
echo "编译并启动项目"
echo "======================================"

# 颜色定义
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

# 设置环境变量
export JAVA_HOME=/Library/Java/JavaVirtualMachines/jdk1.8.0_221.jdk/Contents/Home
export PATH="$JAVA_HOME/bin:$PATH"
export PATH="/usr/local/mysql-8.0.30-macos12-x86_64/bin:$PATH"

echo -e "${GREEN}✓ 环境变量已设置${NC}"
echo "Java版本: $(java -version 2>&1 | head -n 1)"
echo ""

# 检查Nacos
echo "检查Nacos..."
if curl -s http://localhost:8848/nacos/index.html &> /dev/null; then
    echo -e "${GREEN}✓ Nacos正在运行${NC}"
else
    echo -e "${RED}✗ Nacos未运行${NC}"
    echo -e "${YELLOW}请启动Nacos: cd ~/nacos/bin && ./startup.sh -m standalone${NC}"
    exit 1
fi
echo ""

# 编译项目
echo "开始编译项目..."
echo -e "${YELLOW}注意：首次编译需要10-15分钟下载依赖${NC}"
echo ""

./mvnw clean install -DskipTests

if [ $? -eq 0 ]; then
    echo ""
    echo -e "${GREEN}======================================"
    echo -e "编译成功！${NC}"
    echo -e "======================================${NC}"
    echo ""
    echo "下一步：在IntelliJ IDEA中启动服务"
    echo ""
    echo "启动顺序："
    echo "1. ecommerce-gateway (API网关)"
    echo "2. ecommerce-user (用户服务)"
    echo "3. ecommerce-product (商品服务)"
    echo "4. ecommerce-order (订单服务)"
    echo "5. ecommerce-payment (支付服务)"
    echo ""
    echo "详细指南: cat IDEA_START_GUIDE.md"
    echo ""
else
    echo ""
    echo -e "${RED}======================================"
    echo -e "编译失败！${NC}"
    echo -e "======================================${NC}"
    echo ""
    echo "请检查错误信息并修复后重试"
    echo ""
    exit 1
fi
