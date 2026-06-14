#!/bin/bash

# 数据库初始化脚本（使用已安装的MySQL 8.0.30）

echo "======================================"
echo "数据库初始化脚本"
echo "======================================"

# 颜色定义
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# 设置MySQL路径
export PATH="/usr/local/mysql-8.0.30-macos12-x86_64/bin:$PATH"

echo -e "${YELLOW}检查MySQL服务...${NC}"

# 检查MySQL进程
if pgrep -x "mysqld" > /dev/null; then
    echo -e "${GREEN}✓ MySQL服务正在运行${NC}"
else
    echo -e "${YELLOW}MySQL服务未运行，尝试启动...${NC}"
    # 尝试启动MySQL
    sudo /usr/local/mysql-8.0.30-macos12-x86_64/support-files/mysql.server start 2>/dev/null
    if [ $? -eq 0 ]; then
        echo -e "${GREEN}✓ MySQL服务启动成功${NC}"
        sleep 3
    else
        echo -e "${YELLOW}⚠ MySQL服务启动失败，请手动启动MySQL${NC}"
        echo -e "${YELLOW}启动命令: sudo /usr/local/mysql-8.0.30-macos12-x86_64/support-files/mysql.server start${NC}"
        exit 1
    fi
fi

echo ""
echo -e "${YELLOW}初始化数据库...${NC}"

# 提示输入MySQL root密码
echo "请输入MySQL root密码（如果设置了密码）："
read -s mysql_password

# 尝试连接并初始化
if mysql -u root -p$mysql_password -e "USE ecommerce;" 2>/dev/null; then
    echo -e "${GREEN}✓ 数据库 ecommerce 已存在${NC}"
else
    echo -e "${YELLOW}创建数据库并初始化...${NC}"

    # 执行初始化脚本
    mysql -u root -p$mysql_password < sql/init.sql 2>/dev/null

    if [ $? -eq 0 ]; then
        echo -e "${GREEN}✓ 数据库初始化成功${NC}"
    else
        echo -e "${RED}✗ 数据库初始化失败${NC}"
        echo -e "${YELLOW}请手动执行: mysql -u root -p < sql/init.sql${NC}"
        exit 1
    fi
fi

echo ""
echo -e "${GREEN}======================================"
echo -e "数据库初始化完成！${NC}"
echo -e "======================================${NC}"
echo ""
echo "数据库信息："
echo "  - 数据库: ecommerce"
echo "  - 端口: 3306"
echo ""
