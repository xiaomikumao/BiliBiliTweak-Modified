// BiliBiliTweak 补丁 - 恢复直播间人数和礼物特效
// 这个补丁需要在原 BiliBiliTweak 之后加载

%group RestoreLiveFeatures

// 恢复直播间右上角热门排行入口
%hook BBLiveBasePopularHotRankEntryView
- (id)init {
    id result = %orig;
    if ([result respondsToSelector:@selector(setHidden:)]) {
        [result setHidden:NO];
    }
    return result;
}

- (id)initWithFrame:(CGRect)frame {
    id result = %orig;
    if ([result respondsToSelector:@selector(setHidden:)]) {
        [result setHidden:NO];
    }
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
    if ([result respondsToSelector:@selector(setHidden:)]) {
        [result setHidden:NO];
    }
    return result;
}

- (id)initWithFrame:(CGRect)frame {
    id result = %orig;
    if ([result respondsToSelector:@selector(setHidden:)]) {
        [result setHidden:NO];
    }
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
    if ([result respondsToSelector:@selector(setHidden:)]) {
        [result setHidden:NO];
    }
    if ([result respondsToSelector:@selector(setUserInteractionEnabled:)]) {
        [result setUserInteractionEnabled:YES];
    }
    return result;
}

- (id)initWithFrame:(CGRect)frame {
    id result = %orig;
    if ([result respondsToSelector:@selector(setHidden:)]) {
        [result setHidden:NO];
    }
    if ([result respondsToSelector:@selector(setUserInteractionEnabled:)]) {
        [result setUserInteractionEnabled:YES];
    }
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

- (void)removeFromSuperview {
    // 阻止从父视图移除
    // 不调用 %orig
}
%end

%end

%ctor {
    // 确保原插件已经加载
    // 通过延时加载确保补丁后执行
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        %init(RestoreLiveFeatures);
        NSLog(@"[BiliBiliTweakPatch] 直播间功能恢复补丁已加载");
    });
}
