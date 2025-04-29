#!/bin/bash

# 设置颜色输出
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m' # 无颜色

# 项目根目录
PROJECT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
FRONTEND_DIR="$PROJECT_DIR/frontend"

# 输出带颜色的信息
info() {
    echo -e "${GREEN}[信息] $1${NC}"
}

warning() {
    echo -e "${YELLOW}[警告] $1${NC}"
}

error() {
    echo -e "${RED}[错误] $1${NC}"
}

# 修改vite配置
modify_vite_config() {
    info "修改vite配置，禁用自动打开浏览器..."
    cd "$FRONTEND_DIR"
    
    # 备份原始配置
    cp vite.config.js vite.config.js.bak
    
    # 修改配置，禁用自动打开浏览器
    sed -i 's/open: true/open: false/' vite.config.js
    
    if [ $? -eq 0 ]; then
        info "vite配置修改成功"
    else
        error "vite配置修改失败"
        exit 1
    fi
}

# 在后台启动Vue前端
start_frontend_background() {
    info "正在后台启动Vue前端..."
    cd "$FRONTEND_DIR"
    
    # 创建日志目录
    mkdir -p "$PROJECT_DIR/logs"
    
    # 在后台启动Vue开发服务器，监听所有网络接口
    nohup npm run dev -- --host 0.0.0.0 > "$PROJECT_DIR/logs/frontend.log" 2>&1 &
    
    # 获取进程ID
    FRONTEND_PID=$!
    
    # 保存进程ID到文件
    echo $FRONTEND_PID > "$PROJECT_DIR/.frontend_pid"
    
    # 等待几秒确认进程是否正常启动
    sleep 5
    
    if ps -p $FRONTEND_PID > /dev/null; then
        info "Vue前端已在后台启动，进程ID: $FRONTEND_PID"
        info "前端地址: http://服务器IP:3001"
        info "日志文件: $PROJECT_DIR/logs/frontend.log"
        info "要停止前端，请运行: kill \$(cat $PROJECT_DIR/.frontend_pid)"
    else
        error "Vue前端启动失败，请检查日志文件"
        cat "$PROJECT_DIR/logs/frontend.log"
        exit 1
    fi
}

# 主函数
main() {
    info "=== 开始在服务器上启动Vue前端 ==="
    
    modify_vite_config
    start_frontend_background
    
    info "=== 脚本执行完成 ==="
}

# 执行主函数
main
