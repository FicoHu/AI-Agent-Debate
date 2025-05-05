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
    # 使用更精确的模式匹配，包含多种可能的进程名称
    if ! ps aux | grep -E '[python.*app\.py|[python3.*app\.py|[f]lask.*app\.py' > /dev/null; then
        log "检测到Python服务器未运行，正在启动..."
        cd "$PROJECT_PATH"
        # 确保安装了必要的依赖
        pip3 install flask flask-cors bs4 requests > /dev/null 2>&1
        # 使用绝对路径启动服务器
        nohup python "$PROJECT_PATH/flask/app.py" > "$PROJECT_PATH/server.log" 2>&1 &
        sleep 2 # 等待服务器启动
        if ps aux | grep -E '[python.*app\.py|[python3.*app\.py|[f]lask.*app\.py' > /dev/null; then
            log "Python服务器启动成功"
        else
            log "Python服务器启动失败，请查看日志: $PROJECT_PATH/server.log"
        fi
    else
        log "Python服务器正在运行中"
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
    # 使用更精确的模式匹配，包含多种可能的进程名称
    if ! ps aux | grep -E '[n]ode.*dev|[v]ite|[n]pm.*run.*dev' > /dev/null; then
        log "npm run dev进程不存在，正在启动..."
        cd "$FRONTEND_PATH"
        # 确保安装了必要的依赖
        npm install > /dev/null 2>&1
        # 使用nohup启动前端服务器
        nohup npm run dev -- --host > "$PROJECT_PATH/frontend.log" 2>&1 &
        sleep 5 # 等待前端服务器启动
        if ps aux | grep -E '[n]ode.*dev|[v]ite|[n]pm.*run.*dev' > /dev/null; then
            log "npm run dev启动成功"
        else
            log "npm run dev启动失败，请查看日志: $PROJECT_PATH/frontend.log"
            return 1
        fi
    else
        log "npm run dev进程正在运行中"
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
