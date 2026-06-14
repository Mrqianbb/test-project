#!/bin/bash

echo "======================================"
echo "清理端口占用"
echo "======================================"

# 定义需要清理的端口
PORTS=(8001 8002 8003 8004 8848 9000)

echo ""
echo "检查端口占用情况..."

for port in "${PORTS[@]}"; do
    PID=$(lsof -ti:$port 2>/dev/null)
    if [ -n "$PID" ]; then
        PROCESS=$(ps -p $PID -o comm=)
        echo "✗ 端口 $port 被占用 (PID: $PID, 进程: $PROCESS)"
    else
        echo "✓ 端口 $port 可用"
    fi
done

echo ""
echo "是否停止所有占用的进程？(y/n)"
read -r answer

if [ "$answer" != "y" ]; then
    echo "操作取消"
    exit 0
fi

echo ""
echo "正在停止占用的进程..."

for port in "${PORTS[@]}"; do
    PID=$(lsof -ti:$port 2>/dev/null)
    if [ -n "$PID" ]; then
        PROCESS=$(ps -p $PID -o comm=)
        kill -9 $PID 2>/dev/null
        echo "✓ 已停止端口 $port 的进程 (PID: $PID, $PROCESS)"
    fi
done

echo ""
echo "等待端口释放..."
sleep 2

echo ""
echo "验证端口状态..."
for port in "${PORTS[@]}"; do
    PID=$(lsof -ti:$port 2>/dev/null)
    if [ -n "$PID" ]; then
        echo "✗ 端口 $port 仍被占用 (PID: $PID)"
    else
        echo "✓ 端口 $port 已释放"
    fi
done

echo ""
echo "======================================"
echo "清理完成！"
echo "======================================"
echo ""
echo "现在可以在IDEA中重新启动服务了。"
echo ""
