#!/bin/bash

# Nacos下载和启动脚本

echo "======================================"
echo "Nacos下载和启动脚本"
echo "======================================"

# 颜色定义
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

NACOS_VERSION="2.2.3"
NACOS_FILE="nacos-server-${NACOS_VERSION}.tar.gz"

echo -e "${YELLOW}检查Nacos安装情况...${NC}"

if [ -d "$HOME/nacos" ]; then
    echo -e "${GREEN}✓ Nacos已安装${NC}"

    # 检查Nacos是否运行
    if curl -s http://localhost:8848/nacos &> /dev/null; then
        echo -e "${GREEN}✓ Nacos正在运行${NC}"
    else
        echo -e "${YELLOW}启动Nacos...${NC}"
        cd ~/nacos/bin
        ./startup.sh -m standalone
        cd - > /dev/null
        sleep 5
        echo -e "${GREEN}✓ Nacos启动完成${NC}"
    fi
else
    echo -e "${YELLOW}下载并安装Nacos...${NC}"
    cd /tmp

    # 检查文件是否已下载
    if [ -f "$NACOS_FILE" ]; then
        echo -e "${GREEN}✓ Nacos文件已存在${NC}"
    else
        echo "正在下载Nacos..."
        curl -L -o "$NACOS_FILE" "https://github.com/alibaba/nacos/releases/download/${NACOS_VERSION}/$NACOS_FILE"

        if [ $? -ne 0 ]; then
            echo -e "${RED}✗ Nacos下载失败${NC}"
            echo -e "${YELLOW}请手动下载: https://github.com/alibaba/nacos/releases/download/${NACOS_VERSION}/$NACOS_FILE${NC}"
            exit 1
        fi
    fi

    # 解压
    echo "解压Nacos..."
    tar -xzf "$NACOS_FILE"

    if [ $? -ne 0 ]; then
        echo -e "${RED}✗ 解压失败${NC}"
        exit 1
    fi

    # 移动到用户目录
    mv nacos ~/nacos
    cd - > /dev/null

    echo -e "${GREEN}✓ Nacos安装完成${NC}"

    # 启动Nacos
    echo -e "${YELLOW}启动Nacos...${NC}"
    cd ~/nacos/bin
    ./startup.sh -m standalone
    cd - > /dev/null
    sleep 5
    echo -e "${GREEN}✓ Nacos启动完成${NC}"
fi

echo ""
echo "======================================"
echo -e "${GREEN}Nacos就绪！${NC}"
echo "======================================"
echo ""
echo "访问Nacos控制台:"
echo "  URL: http://localhost:8848/nacos"
echo "  用户名: nacos"
echo "  密码: nacos"
echo ""
