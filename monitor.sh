#!/bin/bash

# 项目路径
PROJECT_PATH="/root/AI-Agent-Debate"
FRONTEND_PATH="$PROJECT_PATH/frontend"
LOG_FILE="$PROJECT_PATH/monitor.log"

# 记录日志函数
log() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] $1" >> "$LOG_FILE"
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] $1"
}

# 检查目录是否存在
if [ ! -d "$PROJECT_PATH" ]; then
    log "项目目录不存在，正在克隆..."
    mkdir -p $(dirname "$PROJECT_PATH")
    cd $(dirname "$PROJECT_PATH")
    git clone git@github.com:FicoHu/AI-Agent-Debate.git
    if [ $? -ne 0 ]; then
        log "克隆仓库失败"
        exit 1
    fi
    log "仓库克隆成功"
fi

# 检查Python服务器是否在运行
check_python_server() {
    if ! pgrep -f "python.*server\.py" > /dev/null; then
        log "检测到Python服务器未运行，正在启动..."
        cd "$PROJECT_PATH"
        nohup python3 server.py > "$PROJECT_PATH/server.log" 2>&1 &
        if [ $? -eq 0 ]; then
            log "Python服务器启动成功"
        else
            log "Python服务器启动失败"
        fi
    fi
}

# 拉取最新代码
pull_latest_code() {
    log "正在拉取最新代码..."
    cd "$PROJECT_PATH"
    git pull
    if [ $? -ne 0 ]; then
        log "拉取代码失败"
        return 1
    fi
    log "代码拉取成功"
    return 0
}

# 检查npm run dev进程
check_and_start_dev_server() {
    log "检查npm run dev进程..."
    if ! pgrep -f "node.*dev" > /dev/null; then
        log "npm run dev进程不存在，正在启动..."
        cd "$FRONTEND_PATH"
        nohup npm run dev -- --host > frontend.log 2>&1 &
        if [ $? -ne 0 ]; then
            log "启动npm run dev失败"
            return 1
        fi
        log "npm run dev启动成功，进程ID: $(pgrep -f 'node.*dev')"
    else
        log "npm run dev进程正在运行，进程ID: $(pgrep -f 'node.*dev')"
    fi
    return 0
}

# 主循环
while true; do
    pull_latest_code
    check_python_server      # 检查Python服务器是否在运行
    check_and_start_dev_server
    log "等待1分钟后再次检查..."
    sleep 60
done
