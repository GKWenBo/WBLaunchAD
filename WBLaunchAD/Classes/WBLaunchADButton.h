//
//  WBLaunchADButton.h
//  Pods-WBLaunchAD_Example
//
//  Created by 文波 on 2019/3/28.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, WBCountdownBtnType) {
    /*  < 无跳过按钮 > */
    WBCountdownBtnTypeNone = 1,
    /*  < 方形倒计时 > */
    WBCountdownBtnTypeTime,
    /*  < 跳过 > */
    WBCountdownBtnTypeText,
    /*  < 方形:倒计时+跳过 (default) > */
    WBCountdownBtnTypeTimeText,
    /*  < 方形:倒计时+跳过 (default) > */
    WBCountdownBtnTypeRoundTime,
    /*  < 圆形:倒计时 > */
    WBCountdownBtnTypeRoundText,
    /*  < 圆形:进度圈+倒计时 > */
    WBCountdownBtnTypeRoundProgressTime,
    /*  < 圆形:进度圈+跳过 > */
    WBCountdownBtnTypeRoundProgressText
};

@interface WBLaunchADButton : UIButton

- (instancetype)initWithCountdonwType:(WBCountdownBtnType)type;
- (void)wb_startRoundDispathTimerWithDuration:(CGFloat )duration;
- (void)wb_setTitleWithSkipType:(WBCountdownBtnType)skipType
                       duration:(NSInteger)duration;

@end

NS_ASSUME_NONNULL_END
