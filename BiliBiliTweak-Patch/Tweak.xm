#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import <objc/runtime.h>

// 声明类接口，让编译器知道这些是 UIView 子类
@interface BBLiveBasePopularHotRankEntryView : UIView
@end

@interface BBLiveBasePopularRankEntryView : UIView
@end

@interface BBLiveBaseAnimationView : UIView
@end

// 恢复直播间右上角热门排行入口
%hook BBLiveBasePopularHotRankEntryView
- (id)init {
    id result = %orig;
    [(UIView *)result setHidden:NO];
    return result;
}

- (id)initWithFrame:(CGRect)frame {
    id result = %orig;
    [(UIView *)result setHidden:NO];
    return result;
}

- (void)layoutSubviews {
    %orig;
    [self setHidden:NO];
}
%end

// 恢复直播间右上角排行入口
%hook BBLiveBasePopularRankEntryView
- (id)init {
    id result = %orig;
    [(UIView *)result setHidden:NO];
    return result;
}

- (id)initWithFrame:(CGRect)frame {
    id result = %orig;
    [(UIView *)result setHidden:NO];
    return result;
}

- (void)layoutSubviews {
    %orig;
    [self setHidden:NO];
}
%end

// 恢复礼物特效动画
%hook BBLiveBaseAnimationView
- (id)init {
    id result = %orig;
    [(UIView *)result setHidden:NO];
    return result;
}

- (id)initWithFrame:(CGRect)frame {
    id result = %orig;
    [(UIView *)result setHidden:NO];
    return result;
}

- (void)layoutSubviews {
    %orig;
    [self setHidden:NO];
}

- (void)setHidden:(BOOL)hidden {
    // 强制不隐藏
    %orig(NO);
}
%end
