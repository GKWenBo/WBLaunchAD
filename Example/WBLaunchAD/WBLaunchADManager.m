//
//  WBLaunchADManager.m
//  WBLaunchAD_Example
//
//  Created by 文波 on 2019/3/31.
//  Copyright © 2019 wenmobo. All rights reserved.
//

#import "WBLaunchADManager.h"
#import <WBLaunchAD/WBLaunchAD.h>

@interface WBLaunchADManager () <WBLaunchADDelegate>

@end

@implementation WBLaunchADManager

+ (void)load {
    [self shareManager];
}

+ (instancetype)shareManager {
    static WBLaunchADManager *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[self alloc]init];
    });
    return manager;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        //在UIApplicationDidFinishLaunching时初始化开屏广告,做到对业务层无干扰,当然你也可以直接在AppDelegate didFinishLaunchingWithOptions方法中初始化
        [[NSNotificationCenter defaultCenter] addObserverForName:UIApplicationDidFinishLaunchingNotification object:nil queue:nil usingBlock:^(NSNotification * _Nonnull note) {
            //初始化开屏广告
            [self setupWBLaunchAd];
        }];
    }
    return self;
}

- (void)setupWBLaunchAd {
    [WBLaunchAD wb_setLaunchSourceType:WBLaunchImageSourceTypeImage];
//    [WBLaunchAD wb_setWaitDataDuration:3];
    WBLaunchADImageConfiguration *configuration = [WBLaunchADImageConfiguration new];
    configuration.duration = 5;
    configuration.imageNameOrURLString = @"http://yun.it7090.com/image/XHLaunchAd/pic_test01.jpg";
    configuration.imageOption = WBLaunchADImageOptionsDefault;
    configuration.skipButtonType = WBCountdownBtnTypeTimeText;
    configuration.showFinishAnimate = WBLaunchADFinishAnimationTypeLite;
    configuration.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height);
    [WBLaunchAD wb_showLuanchWithConfiguration:configuration
                                      delegate:self];
}

// MARK:WBLaunchADDelegate
- (void)wbLaunchAd:(WBLaunchAD *)launchAd clickAndOpenModel:(id)openModel clickPoint:(CGPoint)clickPoint {
    NSLog(@"%s",__func__);
}

- (void)wbLaunchAD:(WBLaunchAD *)launchAd imageDownLoadFinish:(UIImage *)image imageData:(NSData *)imageData {
    NSLog(@"%s",__func__);
}

- (void)wbLaunchAdShowFinish:(WBLaunchAD *)launchAd {
    NSLog(@"%s",__func__);
}

@end
