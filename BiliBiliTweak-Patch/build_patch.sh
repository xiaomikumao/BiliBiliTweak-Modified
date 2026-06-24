#!/bin/bash

# BiliBiliTweak Patch 自动编译脚本
# 用于在 GitHub Codespaces 或任何 Linux/macOS 环境中编译

set -e

echo "================================================"
echo "   BiliBiliTweak Patch 自动编译脚本"
echo "   版本: 1.0.0"
echo "   功能: 恢复直播间人数和礼物特效"
echo "================================================"
echo ""

# 颜色定义
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

# 检查 Theos 是否安装
check_theos() {
    if [ -z "$THEOS" ] || [ ! -d "$THEOS" ]; then
        echo -e "${YELLOW}Theos 未安装，正在安装...${NC}"
        
        # 安装 Theos
        export THEOS=$HOME/theos
        git clone --recursive https://github.com/theos/theos.git $THEOS
        
        # 下载 iOS SDK
        echo "下载 iOS SDK..."
        mkdir -p $THEOS/sdks
        cd $THEOS/sdks
        
        # 尝试下载 SDK
        curl -LO https://github.com/theos/sdks/raw/master/iPhoneOS14.0.sdk.tar.xz || {
            echo -e "${YELLOW}SDK 下载失败，但会继续编译...${NC}"
        }
        
        if [ -f "iPhoneOS14.0.sdk.tar.xz" ]; then
            tar -xf iPhoneOS14.0.sdk.tar.xz
            rm iPhoneOS14.0.sdk.tar.xz
        fi
        
        cd -
        
        # 添加到 bashrc
        echo "export THEOS=$HOME/theos" >> ~/.bashrc
        echo "export PATH=\$THEOS/bin:\$PATH" >> ~/.bashrc
        
        echo -e "${GREEN}Theos 安装完成！${NC}"
    else
        echo -e "${GREEN}Theos 已安装: $THEOS${NC}"
    fi
    
    # 确保环境变量设置
    export PATH=$THEOS/bin:$PATH
}

# 安装依赖
install_deps() {
    echo -e "${GREEN}[1/4] 安装编译依赖...${NC}"
    
    if command -v apt-get &> /dev/null; then
        sudo apt-get update
        sudo apt-get install -y \
            build-essential \
            git \
            curl \
            wget \
            fakeroot \
            ldid \
            xz-utils \
            zip \
            unzip \
            python3 \
            python3-pip
    elif command -v brew &> /dev/null; then
        brew install ldid fakeroot
    fi
    
    echo -e "${GREEN}依赖安装完成！${NC}"
}

# 准备项目
prepare_project() {
    echo -e "${GREEN}[2/4] 准备项目...${NC}"
    
    # 创建 control 文件目录
    mkdir -p DEBIAN
    
    # 复制 control 文件
    if [ ! -f "DEBIAN/control" ]; then
        cp control DEBIAN/control 2>/dev/null || {
            echo "Package: com.yourname.bilibilitweakpatch
Name: BiliBiliTweak Patch
Version: 1.0.0
Architecture: iphoneos-arm64
Description: 恢复 BiliBiliTweak 隐藏的直播间人数和礼物特效
Maintainer: Patch Developer
Author: Developer
Section: Tweaks
Depends: mobilesubstrate, com.touchfriend.bilibilitweak
Priority: optional" > DEBIAN/control
        }
    fi
    
    echo -e "${GREEN}项目准备完成！${NC}"
}

# 编译项目
build_project() {
    echo -e "${GREEN}[3/4] 开始编译...${NC}"
    echo ""
    
    # 清理
    make clean 2>/dev/null || true
    
    # 编译
    echo "正在编译，请耐心等待..."
    if make package FINALPACKAGE=1 2>&1 | tee build.log; then
        echo ""
        echo -e "${GREEN}✅ 编译成功！${NC}"
        return 0
    else
        echo ""
        echo -e "${RED}❌ 编译失败！${NC}"
        echo "查看 build.log 获取详细信息"
        echo ""
        echo "常见的失败原因："
        echo "  1. 类名不存在 - BiliBili 可能更新了版本"
        echo "  2. 缺少 iOS SDK"
        echo "  3. 语法错误"
        return 1
    fi
}

# 打包和显示结果
package_results() {
    echo -e "${GREEN}[4/4] 打包编译产物...${NC}"
    echo ""
    
    # 查找 .deb 文件
    if [ -d "packages" ]; then
        echo "编译产物："
        ls -lh packages/
        echo ""
        
        # 复制到当前目录
        cp packages/*.deb . 2>/dev/null || true
    fi
    
    # 查找 .dylib 文件
    find . -name "*.dylib" -exec ls -lh {} \;
    
    echo ""
    echo "================================================"
    echo -e "${GREEN}✅ 编译完成！${NC}"
    echo "================================================"
    echo ""
    echo "📦 下一步："
    echo "  1. 将 .deb 文件传输到越狱设备"
    echo "  2. 使用 Filza 或 dpkg 安装"
    echo "  3. 确保已安装原版 BiliBiliTweak"
    echo "  4. 重启 BiliBili APP"
    echo ""
    echo "📝 验证安装："
    echo "  在设备上查看日志："
    echo "  tail -f /var/log/syslog | grep BiliBiliTweakPatch"
    echo ""
}

# 主函数
main() {
    # 检查当前目录
    if [ ! -f "Makefile" ] || [ ! -f "Tweak.xm" ]; then
        echo -e "${RED}错误：未找到 Makefile 或 Tweak.xm${NC}"
        echo "请在项目根目录下运行此脚本"
        exit 1
    fi
    
    # 执行编译步骤
    check_theos
    install_deps
    prepare_project
    
    if build_project; then
        package_results
        exit 0
    else
        echo ""
        echo "编译失败，尝试手动编译："
        echo "  export THEOS=$HOME/theos"
        echo "  export PATH=\$THEOS/bin:\$PATH"
        echo "  make package FINALPACKAGE=1"
        exit 1
    fi
}

# 运行主函数
main "$@"
