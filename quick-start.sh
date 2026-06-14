#!/bin/bash

# 快速启动脚本（使用已安装的MySQL 8.0.30）

echo "======================================"
echo "电商平台快速启动脚本"
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
echo ""

# 1. 启动MySQL
echo "步骤 1/3: 启动MySQL服务"
echo "-----------------------------------"
sudo /usr/local/mysql-8.0.30-macos12-x86_64/support-files/mysql.server start 2>/dev/null
if [ $? -eq 0 ]; then
    echo -e "${GREEN}✓ MySQL服务启动成功${NC}"
else
    echo -e "${YELLOW}MySQL服务可能已在运行${NC}"
fi
sleep 2
echo ""

# 2. 初始化数据库
echo "步骤 2/3: 初始化数据库"
echo "-----------------------------------"
echo "尝试初始化数据库..."
mysql -u root < sql/init.sql 2>/dev/null
if [ $? -eq 0 ]; then
    echo -e "${GREEN}✓ 数据库初始化成功${NC}"
else
    echo -e "${YELLOW}数据库可能已存在或需要密码${NC}"
    echo -e "${YELLOW}如需手动初始化: mysql -u root -p < sql/init.sql${NC}"
fi
echo ""

# 3. 检查Nacos
echo "步骤 3/3: 检查Nacos服务"
echo "-----------------------------------"
if curl -s http://localhost:8848/nacos &> /dev/null; then
    echo -e "${GREEN}✓ Nacos正在运行${NC}"
else
    echo -e "${YELLOW}Nacos未运行${NC}"
    echo -e "${YELLOW}启动Nacos: cd ~/nacos/bin && ./startup.sh -m standalone${NC}"
fi
echo ""

echo "======================================"
echo -e "${GREEN}基础环境准备完成！${NC}"
echo "======================================"
echo ""
echo "下一步操作："
echo ""
echo "1. 如果Nacos未运行，请启动Nacos："
echo "   cd ~/nacos/bin && ./startup.sh -m standalone"
echo ""
echo "2. 编译项目（首次需要10-15分钟）："
echo "   export JAVA_HOME=/Library/Java/JavaVirtualMachines/jdk1.8.0_221.jdk/Contents/Home"
echo "   ./mvnw clean install -DskipTests"
echo ""
echo "3. 启动服务（选择一种方式）："
echo "   方式A（推荐）：在IntelliJ IDEA中运行各服务"
echo "   方式B：运行 ./start.sh"
echo ""
echo "详细指南："
echo "   cat FINAL_START_GUIDE.md"
echo ""
