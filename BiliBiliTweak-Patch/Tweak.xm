#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import <objc/runtime.h>

// 声明类接口，避免 forward declaration 错误
__attribute__((unused)) static Class _cls_BBLiveBasePopularHotRankEntryView;
__attribute__((unused)) static Class _cls_BBLiveBasePopularRankEntryView;
__attribute__((unused)) static Class _cls_BBLiveBaseAnimationView;

// 恢复直播间右上角热门排行入口
%hook BBLiveBasePopularHotRankEntryView
- (id)init {
    id result = %orig;
    UIView *view = (UIView *)result;
    [view setHidden:NO];
    return result;
}

- (id)initWithFrame:(CGRect)frame {
    id result = %orig;
    UIView *view = (UIView *)result;
    [view setHidden:NO];
    return result;
}

- (void)layoutSubviews {
    %orig;
    [self performSelector:@selector(setHidden:) withObject:nil afterDelay:0];
    objc_setAssociatedObject(self, "hidden", @NO, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
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
    UIView *view = (UIView *)self;
    [view setHidden:NO];
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
    [(UIView *)self setHidden:NO];
}

- (void)setHidden:(BOOL)hidden {
    // 强制不隐藏
    %orig(NO);
}
%end
