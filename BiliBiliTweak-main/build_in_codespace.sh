#!/bin/bash

# BiliBiliTweak 自动编译脚本（用于 GitHub Codespaces）
# 这个脚本会在 Linux 环境下安装 Theos 并编译插件

set -e  # 遇到错误立即退出

echo "================================================"
echo "   BiliBiliTweak 自动编译脚本"
echo "   保留直播间人数和礼物特效版本"
echo "================================================"
echo ""

# 颜色定义
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# 检查是否在 Codespace 环境
if [ -z "$CODESPACE_NAME" ]; then
    echo -e "${YELLOW}警告: 不在 Codespace 环境中，但会继续尝试编译...${NC}"
fi

# 步骤 1: 安装 Theos
echo -e "${GREEN}[1/5] 安装 Theos...${NC}"
echo ""

# 设置 Theos 目录
export THEOS=~/theos

if [ ! -d "$THEOS" ]; then
    echo "Theos 未安装，正在安装..."
    bash -c "$(curl -fsSL https://raw.githubusercontent.com/theos/theos/master/bin/install-theos)" || {
        echo -e "${RED}Theos 安装失败！${NC}"
        echo "尝试手动安装..."
        
        # 手动安装 Theos
        git clone --recursive https://github.com/theos/theos.git $THEOS
        
        # 下载 SDK
        mkdir -p $THEOS/sdks
        cd $THEOS/sdks
        curl -LO https://github.com/theos/sdks/raw/master/iPhoneOS14.0.sdk.tar.xz
        tar -xf iPhoneOS14.0.sdk.tar.xz
        rm iPhoneOS14.0.sdk.tar.xz
        
        cd -  # 返回原目录
    }
else
    echo "Theos 已安装，跳过..."
fi

# 添加到环境变量
echo 'export THEOS=~/theos' >> ~/.bashrc
echo 'export PATH=$THEOS/bin:$PATH' >> ~/.bashrc
source ~/.bashrc

echo -e "${GREEN}Theos 安装完成！${NC}"
echo ""

# 步骤 2: 安装依赖
echo -e "${GREEN}[2/5] 安装编译依赖...${NC}"
echo ""

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
    unzip

echo -e "${GREEN}依赖安装完成！${NC}"
echo ""

# 步骤 3: 准备编译环境
echo -e "${GREEN}[3/5] 准备编译环境...${NC}"
echo ""

# 检查项目文件
if [ ! -f "Makefile" ]; then
    echo -e "${YELLOW}未找到 Makefile，尝试创建...${NC}"
    
    # 创建基本的 Makefile
    cat > Makefile << 'EOF'
TARGET = iphone:clang:latest:14.0
INSTALL_TARGET_PROCESSES = BiliBili

include $(THEOS)/makefiles/common.mk

TWEAK_NAME = BiliBiliTweak

BiliBiliTweak_FILES = \
    src/Home/Live/NJLiveDetailAd.xm \
    src/Detail/NJDetailAd.xm \
    src/Detail/NJDetailPlayerAd.xm \
    src/Dynamic/NJDynamicAd.xm \
    src/Home/HotTopic/NJHotTopicAd.xm \
    src/Home/Rcmd/NJRcmdAd.xm \
    src/Home/Tab/NJTabAd.xm \
    src/Launch/NJLaunchAd.x \
    src/Logger/NJLogger.xm \
    src/Network/NJNetworkService.xm \
    src/Search/NJSearchResultAd.xm \
    src/Setting/NJHD2Setting.xm \
    src/Setting/NJSetting.xm \
    src/Tool/Account/NJAccount.xm \
    src/Tool/NJDebug.xm

BiliBiliTweak_CFLAGS = -fobjc-arc
BiliBiliTweak_FRAMEWORKS = UIKit Foundation

include $(THEOS_MAKE_PATH)/tweak.mk
EOF
    
    echo "Makefile 已创建"
fi

echo -e "${GREEN}编译环境准备完成！${NC}"
echo ""

# 步骤 4: 开始编译
echo -e "${GREEN}[4/5] 开始编译...${NC}"
echo ""

# 清理旧的编译产物
make clean 2>/dev/null || true

# 开始编译
echo "正在编译，请耐心等待..."
if make package FINALPACKAGE=1 2>&1 | tee build.log; then
    echo ""
    echo -e "${GREEN}编译成功！${NC}"
else
    echo ""
    echo -e "${RED}编译失败！查看 build.log 获取详细信息${NC}"
    echo "常见的失败原因："
    echo "  1. 缺少 iOS SDK"
    echo "  2. 代码语法错误"
    echo "  3. 依赖库缺失"
    exit 1
fi

echo ""

# 步骤 5: 打包和显示结果
echo -e "${GREEN}[5/5] 打包编译产物...${NC}"
echo ""

# 查找编译产物
if [ -d "packages" ]; then
    echo "编译产物位置："
    ls -lh packages/
    echo ""
    
    # 复制到根目录方便下载
    cp packages/*.deb . 2>/dev/null || true
    echo "已复制 .deb 文件到项目根目录"
else
    echo -e "${YELLOW}未找到 packages 目录，查找 .dylib 文件...${NC}"
    find . -name "*.dylib" -exec cp {} . \;
fi

echo ""
echo "================================================"
echo -e "${GREEN}编译完成！${NC}"
echo "================================================"
echo ""
echo "下一步："
echo "  1. 在文件浏览器中找到 .deb 文件"
echo "  2. 右键点击文件，选择'下载'"
echo "  3. 将 .deb 文件传输到越狱设备"
echo "  4. 使用 Filza 安装并重启 BiliBili"
echo ""
echo "文件列表："
ls -lh *.deb 2>/dev/null || echo "未找到 .deb 文件"
echo ""

exit 0
