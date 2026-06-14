#!/bin/bash

# 快速测试脚本

echo "======================================"
echo "快速环境测试"
echo "======================================"

# 颜色定义
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

# 测试Maven
echo -n "测试 Maven... "
if command -v mvn &> /dev/null; then
    echo -e "${GREEN}✓ 已安装${NC}"
    mvn -version | head -n 1
else
    echo -e "${RED}✗ 未安装${NC}"
    echo "  安装命令: brew install maven"
fi

# 测试MySQL
echo -n "测试 MySQL... "
if command -v mysql &> /dev/null; then
    echo -e "${GREEN}✓ 客户端已安装${NC}"
    if mysql -u root -e "SELECT 1;" &> /dev/null; then
        echo -e "${GREEN}✓ 服务运行中${NC}"
    else
        echo -e "${YELLOW}⚠ 服务未运行或需要密码${NC}"
    fi
else
    echo -e "${RED}✗ 未安装${NC}"
    echo "  安装命令: brew install mysql"
fi

# 测试Redis
echo -n "测试 Redis... "
if redis-cli ping &> /dev/null; then
    echo -e "${GREEN}✓ 运行中${NC}"
else
    echo -e "${YELLOW}⚠ 未运行${NC}"
    echo "  启动命令: redis-server"
fi

# 测试Nacos
echo -n "测试 Nacos... "
if curl -s http://localhost:8848/nacos &> /dev/null; then
    echo -e "${GREEN}✓ 运行中${NC}"
else
    echo -e "${RED}✗ 未运行${NC}"
    echo "  启动命令: cd ~/nacos/bin && ./startup.sh -m standalone"
fi

echo ""
echo "======================================"
echo "快速启动建议"
echo "======================================"
echo ""
echo "如果Maven已安装，可以直接编译："
echo "  mvn clean install -DskipTests"
echo ""
echo "如果Maven未安装，运行："
echo "  brew install maven"
echo ""
echo "详细指南请查看："
echo "  MANUAL_SETUP.md"
echo ""
