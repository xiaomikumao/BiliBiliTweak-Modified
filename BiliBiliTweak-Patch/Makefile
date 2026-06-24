# BiliBiliTweak Patch - 恢复直播间人数和礼物特效
# 这个补丁在 BiliBiliTweak 之后加载，恢复被隐藏的功能

# 支持 rootless 格式 (var/jb/ 路径)
THEOS_PACKAGE_SCHEME = rootless

TARGET = iphone:clang:latest:14.0
INSTALL_TARGET_PROCESSES = BiliBili

include $(THEOS)/makefiles/common.mk

TWEAK_NAME = BiliBiliTweakPatch

# 源文件
BiliBiliTweakPatch_FILES = Tweak.xm

# 编译选项
BiliBiliTweakPatch_CFLAGS = -fobjc-arc
BiliBiliTweakPatch_FRAMEWORKS = UIKit Foundation

include $(THEOS_MAKE_PATH)/tweak.mk

# 确保在 BiliBiliTweak 之后加载
BiliBiliTweakPatch_INSTALL_PATH = /Library/MobileSubstrate/DynamicLibraries
