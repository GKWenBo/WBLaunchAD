//
//  WBLaunchADButton.m
//  Pods-WBLaunchAD_Example
//
//  Created by 文波 on 2019/3/28.
//

#import "WBLaunchADButton.h"
#import "WBLaunchADConst.h"

/** Progress颜色 */
#define kRoundProgressColor  [UIColor whiteColor]
/** 背景色 */
#define kBackgroundColor [UIColor colorWithRed:0 green:0 blue:0 alpha:0.4]
/** 字体颜色 */
#define kFontColor  [UIColor whiteColor]

#define kSkipTitle @"跳过"
/** 倒计时单位 */
#define kDurationUnit @"S"

@interface WBLaunchADButton ()

@property (nonatomic, assign) WBCountdownBtnType skipType;
@property (nonatomic, assign) CGFloat leftRightSpace;
@property (nonatomic, assign) CGFloat topBottomSpace;
@property (nonatomic, strong) UILabel *timeLab;
@property (nonatomic, strong) CAShapeLayer *roundLayer;
@property (nonatomic, copy) dispatch_source_t roundTimer;

@end

@implementation WBLaunchADButton

- (instancetype)initWithCountdonwType:(WBCountdownBtnType)type {
    if (self = [super init]) {
        _skipType = type;
        
        CGFloat y = WB_FULLSCREEN ? 44 : 20;
        if (type == WBCountdownBtnTypeRoundTime || type == WBCountdownBtnTypeRoundText || type == WBCountdownBtnTypeRoundProgressText || type == WBCountdownBtnTypeRoundProgressTime) {
            self.frame = CGRectMake(WB_ScreenW - 55, y, 55, 55);
        }else {
            self.frame = CGRectMake(WB_ScreenW - 80, y, 70, 35);
        }
        
        switch (type) {
            case WBCountdownBtnTypeNone:
                self.hidden = YES;
                break;
            case WBCountdownBtnTypeTime:
                [self addSubview:self.timeLab];
                self.leftRightSpace = 5.f;
                self.topBottomSpace = 2.5f;
                break;
            case WBCountdownBtnTypeText:
                [self addSubview:self.timeLab];
                self.leftRightSpace = 5;
                self.topBottomSpace = 2.5;
                break;
            case WBCountdownBtnTypeTimeText:
            {
                [self addSubview:self.timeLab];
                self.leftRightSpace = 5;
                self.topBottomSpace = 2.5;
            }
                break;
            case WBCountdownBtnTypeRoundTime:
            {
                [self addSubview:self.timeLab];
            }
                break;
            case WBCountdownBtnTypeRoundText:
            {
                [self addSubview:self.timeLab];
            }
                break;
            case WBCountdownBtnTypeRoundProgressTime: {
                [self addSubview:self.timeLab];
                [self.timeLab.layer addSublayer:self.roundLayer];
            }
                break;
            case WBCountdownBtnTypeRoundProgressText:
            {
                [self addSubview:self.timeLab];
                [self.timeLab.layer addSublayer:self.roundLayer];
            }
                break;
            default:
                break;
        }
    }
    return self;
}

// MARK:Public
- (void)wb_setTitleWithSkipType:(WBCountdownBtnType)skipType
                       duration:(NSInteger)duration {
    
}

// MARK:Private
- (void)cornerRadiusWithView:(UIView *)view {
    CGFloat min = view.frame.size.height;
    if (view.frame.size.width < min) {
        min = view.frame.size.width;
    }
    view.layer.cornerRadius = min / 2.f;
    view.layer.masksToBounds = YES;
}

// MARK:getter && setter
- (UILabel *)timeLab {
    if (!_timeLab) {
        _timeLab = [[UILabel alloc] initWithFrame:self.bounds];
        _timeLab.textColor = kFontColor;
        _timeLab.backgroundColor = kBackgroundColor;
        _timeLab.layer.masksToBounds = YES;
        _timeLab.textAlignment = NSTextAlignmentCenter;
        _timeLab.font = [UIFont systemFontOfSize:13.5];
        [self cornerRadiusWithView:_timeLab];
    }
    return _timeLab;
}

- (CAShapeLayer *)roundLayer {
    if (!_roundLayer) {
        _roundLayer = [CAShapeLayer layer];
        _roundLayer.fillColor = kBackgroundColor.CGColor;
        _roundLayer.strokeColor = kRoundProgressColor.CGColor;
        _roundLayer.lineCap = kCALineCapRound;
        _roundLayer.lineJoin = kCALineJoinRound;
        _roundLayer.lineWidth = 2;
        _roundLayer.frame = self.bounds;
        _roundLayer.path = [UIBezierPath bezierPathWithArcCenter:CGPointMake(self.timeLab.bounds.size.width / 2.0, self.timeLab.bounds.size.width / 2.0)
                                                          radius:self.timeLab.bounds.size.width / 2.0 - 1.0
                                                      startAngle:- 0.5 * M_PI
                                                        endAngle:1.5 * M_PI
                                                       clockwise:YES].CGPath;
        _roundLayer.strokeStart = 0;
    }
    return _roundLayer;
}

@end
