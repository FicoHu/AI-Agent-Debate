#!/bin/bash

# 设置颜色输出
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m' # 无颜色

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

# 项目根目录
PROJECT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
FRONTEND_DIR="$PROJECT_DIR/frontend"

# 检查Node.js版本
check_node_version() {
    info "检查Node.js版本..."
    
    if command -v node &> /dev/null; then
        NODE_VERSION=$(node -v)
        NODE_MAJOR_VERSION=$(echo $NODE_VERSION | cut -d. -f1 | tr -d 'v')
        
        info "当前Node.js版本: $NODE_VERSION"
        
        if [ "$NODE_MAJOR_VERSION" -lt "16" ]; then
            warning "Node.js版本过低，建议升级到v16或更高版本"
            
            # 询问是否要安装nvm
            read -p "是否要安装nvm并升级Node.js? (y/n): " INSTALL_NVM
            if [ "$INSTALL_NVM" = "y" ]; then
                install_nvm
            else
                warning "继续使用当前版本，可能会出现兼容性问题"
            fi
        else
            info "Node.js版本满足要求"
        fi
    else
        error "未找到Node.js，请先安装Node.js"
        exit 1
    fi
}

# 安装nvm并升级Node.js
install_nvm() {
    info "正在安装nvm..."
    
    # 下载nvm安装脚本
    curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.7/install.sh | bash
    
    # 加载nvm
    export NVM_DIR="$HOME/.nvm"
    [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
    
    # 安装最新的LTS版本
    info "正在安装Node.js LTS版本..."
    nvm install --lts
    
    # 使用新安装的版本
    nvm use --lts
    
    # 显示新版本
    NODE_VERSION=$(node -v)
    info "Node.js已升级到: $NODE_VERSION"
}

# 安装前端依赖
install_frontend_deps() {
    info "正在安装前端依赖..."
    cd "$FRONTEND_DIR"
    
    npm install
    
    if [ $? -eq 0 ]; then
        info "前端依赖安装成功"
    else
        error "前端依赖安装失败"
        exit 1
    fi
}

# 启动Vue前端
start_frontend() {
    info "正在启动Vue前端..."
    cd "$FRONTEND_DIR"
    
    # 修改vite配置，禁用自动打开浏览器
    info "修改vite配置，禁用自动打开浏览器"
    sed -i 's/open: true/open: false/' vite.config.js
    
    # 添加--host参数，使其在服务器上可以被访问
    info "启动Vue开发服务器，监听所有网络接口"
    npm run dev -- --host 0.0.0.0
}

# 主函数
main() {
    info "=== 开始执行脚本 ==="
    
    check_node_version
    install_frontend_deps
    start_frontend
    
    info "=== 脚本执行完成 ==="
}

# 执行主函数
main
