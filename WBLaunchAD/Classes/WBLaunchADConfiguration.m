//
//  WBLuanchADConfiguration.m
//  Pods-WBLaunchAD_Example
//
//  Created by Mr_Lucky on 2019/3/29.
//

#import "WBLaunchADConfiguration.h"

@implementation WBLaunchADConfiguration


@end

@implementation WBLaunchADImageConfiguration

+ (WBLaunchADImageConfiguration *)wb_defaultConfiguration {
    WBLaunchADImageConfiguration *config = [WBLaunchADImageConfiguration new];
    config.duration = kSkipCountdownTime;
    config.frame = [UIScreen mainScreen].bounds;
    config.imageOption = WBLaunchADImageOptionsDefault;
    config.contentMode = UIViewContentModeScaleToFill;
    config.showFinishAnimate = WBLaunchADFinishAnimationTypeFadein;
    config.showFinishAnimateTime = kShowFinishAnimateTime;
    config.skipButtonType = WBCountdownBtnTypeText;
    config.showEnterForeground = NO;
    return config;
}

@end
