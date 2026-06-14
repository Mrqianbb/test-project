#!/bin/bash

# 电商前端项目启动脚本

echo "========================================="
echo "  电商前端项目启动脚本"
echo "========================================="
echo ""

# 检查 Node.js
if ! command -v node &> /dev/null
then
    echo "❌ 错误: 未安装 Node.js"
    echo "请先安装 Node.js: https://nodejs.org/"
    exit 1
fi

echo "✅ Node.js 版本: $(node -v)"
echo ""

# 检查 npm
if ! command -v npm &> /dev/null
then
    echo "❌ 错误: 未安装 npm"
    exit 1
fi

echo "✅ npm 版本: $(npm -v)"
echo ""

# 进入项目目录
cd "$(dirname "$0")"

# 检查 node_modules
if [ ! -d "node_modules" ]; then
    echo "📦 首次安装，正在安装依赖..."
    npm install
    if [ $? -ne 0 ]; then
        echo "❌ 依赖安装失败"
        exit 1
    fi
    echo "✅ 依赖安装完成"
    echo ""
fi

# 检查后端服务
echo "🔍 检查后端服务状态..."

# 检查网关服务
if curl -s http://localhost:9000 > /dev/null 2>&1; then
    echo "✅ 网关服务 (9000) 运行中"
else
    echo "⚠️  网关服务 (9000) 未启动，请先启动后端服务"
    echo ""
    echo "启动后端服务："
    echo "  cd ../ && bash start.sh"
    echo ""
    read -p "是否继续启动前端? (y/n) " -n 1 -r
    echo
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        exit 0
    fi
fi

echo ""
echo "========================================="
echo "  启动开发服务器"
echo "========================================="
echo ""

# 启动开发服务器
npm run dev
