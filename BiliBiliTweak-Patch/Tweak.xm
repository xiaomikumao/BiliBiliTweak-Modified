#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import <objc/runtime.h>

// 恢复直播间右上角热门排行入口
%hook BBLiveBasePopularHotRankEntryView
- (id)init {
    id result = %orig;
    ((UIView *)result).hidden = NO;
    return result;
}

- (id)initWithFrame:(CGRect)frame {
    id result = %orig;
    ((UIView *)result).hidden = NO;
    return result;
}

- (void)layoutSubviews {
    %orig;
    self.hidden = NO;
}
%end

// 恢复直播间右上角排行入口
%hook BBLiveBasePopularRankEntryView
- (id)init {
    id result = %orig;
    ((UIView *)result).hidden = NO;
    return result;
}

- (id)initWithFrame:(CGRect)frame {
    id result = %orig;
    ((UIView *)result).hidden = NO;
    return result;
}

- (void)layoutSubviews {
    %orig;
    self.hidden = NO;
}
%end

// 恢复礼物特效动画
%hook BBLiveBaseAnimationView
- (id)init {
    id result = %orig;
    ((UIView *)result).hidden = NO;
    return result;
}

- (id)initWithFrame:(CGRect)frame {
    id result = %orig;
    ((UIView *)result).hidden = NO;
    return result;
}

- (void)layoutSubviews {
    %orig;
    self.hidden = NO;
}

- (void)setHidden:(BOOL)hidden {
    // 强制不隐藏
    %orig(NO);
}
%end
