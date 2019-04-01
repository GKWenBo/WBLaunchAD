//
//  WBLuanchADConfiguration.h
//  Pods-WBLaunchAD_Example
//
//  Created by Mr_Lucky on 2019/3/29.
//

#import <Foundation/Foundation.h>
#import "WBLaunchADButton.h"
#import "WBLaunchADImageManager.h"

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, WBLaunchADFinishAnimationType) {
    /*  < 无动画 > */
    WBLaunchADFinishAnimationTypeNone,
    /*  < 普通淡入(default) > */
    WBLaunchADFinishAnimationTypeFadein,
    /*  < 放大淡入 > */
    WBLaunchADFinishAnimationTypeLite,
    /*  < 左右翻转(类似网易云音乐) > */
    WBLaunchADFinishAnimationTypeFlipFromLeft,
    /*  < 下上翻转 > */
    WBLaunchADFinishAnimationTypeFlipFromBottom,
    /*  < 向上翻页 > */
    WBLaunchADFinishAnimationTypeCurlUp
};

static CGFloat const kShowFinishAnimateTime = 0.8f;
static NSInteger const kSkipCountdownTime = 5;

@interface WBLaunchADConfiguration : NSObject

/*  < 停留时间(default 5 ,单位:秒) > */
@property(nonatomic, assign) NSInteger duration;
/*  < 跳过按钮类型(default WBCountdownBtnTypeRoundTime) > */
@property(nonatomic, assign) WBCountdownBtnType skipButtonType;
/*  < 显示完成动画(default ShowFinishAnimateFadein) > */
@property(nonatomic, assign) WBLaunchADFinishAnimationType showFinishAnimate;
/*  < 显示完成动画时间(default 0.8 , 单位:秒) > */
@property(nonatomic, assign) CGFloat showFinishAnimateTime;
/*  < 设置开屏广告的frame(default [UIScreen mainScreen].bounds) > */
@property (nonatomic, assign) CGRect frame;
/*  < 自定义跳过按钮(若定义此视图,将会自定替换系统跳过按钮) > */
@property(nonatomic, strong) UIView *customSkipView;
/*  < 点击打开页面参数 > */
@property (nonatomic, strong) id openModel;
/*  < 程序从后台恢复时,是否需要展示广告(defailt NO) > */
@property (nonatomic, assign) BOOL showEnterForeground;

@end


@interface WBLaunchADImageConfiguration : WBLaunchADConfiguration

/*  < image本地图片名(jpg/gif图片请带上扩展名)或网络图片URL string > */
@property(nonatomic, copy)NSString *imageNameOrURLString;
/*  < 图片广告缩放模式(default UIViewContentModeScaleToFill) > */
@property(nonatomic, assign)UIViewContentMode contentMode;
/*  < 缓存机制(default WBLaunchADImageOptionsDefault) > */
@property(nonatomic, assign)WBLaunchADImageOptions imageOption;

/**
 默认配置

 @return WBLuanchADImageConfiguration.
 */
+ (WBLaunchADImageConfiguration *)wb_defaultConfiguration;

@end

NS_ASSUME_NONNULL_END
