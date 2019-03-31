//
//  WBLaunchAD.m
//  Pods-WBLaunchAD_Example
//
//  Created by 文波 on 2019/3/28.
//

#import "WBLaunchAD.h"
#import "WBLaunchADConst.h"
#import "WBLaunchADViewController.h"
#import "WBLaunchADView.h"
#import "WBLaunchADImageView+WBLaunchADCache.h"
#import "WBLaunchADCache.h"
#import "WBLaunchADButton.h"

@interface WBLaunchAD ()

@property (nonatomic, assign) id<WBLaunchADDelegate> delegate;
@property (nonatomic, strong) UIWindow *window;
@property (nonatomic, assign) WBLaunchImageSourceType sourceType;
@property (nonatomic, assign) NSInteger waitDataDuration;
@property (nonatomic, strong) WBLaunchADImageConfiguration *imageConfiguration;
@property (nonatomic, copy) dispatch_source_t waitDataTimer;
@property (nonatomic, copy) dispatch_source_t skipTimer;
@property (nonatomic, strong) WBLaunchADButton *skipButton;
@property (nonatomic, assign) CGPoint clickPoint;
@end

@implementation WBLaunchAD

// MARK:Private Method
+ (instancetype)shareLaunchAD {
    static WBLaunchAD *_instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [[self alloc]init];
    });
    return _instance;
};

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self wb_commonInit];
        [self wb_setupLuanchAD];
    }
    return self;
}

- (void)wb_commonInit {
    _sourceType = WBLaunchImageSourceTypeImage;
    _waitDataDuration = 3;
}

- (void)wb_setupLuanchAD {
    self.window = ({
        UIWindow *window = [[UIWindow alloc]initWithFrame:[UIScreen mainScreen].bounds];
        UIViewController *rootVc = [WBLaunchADViewController new];
        rootVc.view.backgroundColor = [UIColor clearColor];
        rootVc.view.userInteractionEnabled = YES;
        window.rootViewController = rootVc;
        window.windowLevel = UIWindowLevelStatusBar + 1;
        window.alpha = 1.f;
        window.hidden = NO;
        [window addSubview:[[WBLaunchImageView alloc] initWithSourceType:_sourceType]];
        window;
    });
}

- (void)wb_setupImageAdForConfiguration:(WBLaunchADImageConfiguration *)configuration {
    if (_window == nil) return;
    [self wb_removeSubViewsExceptLuancheImageView];
    
    WBLaunchADImageView *adImageView = [[WBLaunchADImageView alloc]init];
    [_window addSubview:adImageView];
    /*  < frame > */
    if (configuration.frame.size.width > 0 && configuration.frame.size.height > 0) {
        adImageView.frame = configuration.frame;
    }
    /** < contentMode > */
    if (configuration.contentMode) {
        adImageView.contentMode = configuration.contentMode;
    }
    
    /*  < 图片 > */
    if (configuration.imageNameOrURLString.length && WBISURLString(configuration.imageNameOrURLString)) {
        
        /*  < 存储图片地址 > */
        [WBLaunchADCache wb_asyncSaveImageURL:configuration.imageNameOrURLString];
        
        if (self.delegate && [self.delegate respondsToSelector:@selector(wbLaunchAD:launchAdImageView:URL:)]) {
            [self.delegate wbLaunchAD:self
                    launchAdImageView:adImageView
                                  URL:[NSURL URLWithString:configuration.imageNameOrURLString]];
        }else {
            if (!configuration.imageOption) {
                configuration.imageOption = WBLaunchADImageOptionsDefault;
            }
            
            WBWeakSelf
            [adImageView wb_setImageWithURL:[NSURL URLWithString:configuration.imageNameOrURLString]
                           placeholderImage:nil
                                    options:configuration.imageOption
                                  completed:^(UIImage * _Nullable image, NSData * _Nullable imageData, NSError * _Nullable error, NSURL * _Nullable imageURL) {
                                      if (!error) {
                                          if (weakSelf.delegate && [weakSelf.delegate respondsToSelector:@selector(wbLaunchAD:imageDownLoadFinish:imageData:)]) {
                                              [weakSelf.delegate wbLaunchAD:self
                                                        imageDownLoadFinish:image
                                                                  imageData:imageData];
                                          }
                                      }
                                  }];
            if (configuration.imageOption == WBLaunchADImageOptionsCacheInBackground) {
                /*  < 缓存中没有 > */
                if (![WBLaunchADCache wb_checkImageCacheWithURL:[NSURL URLWithString:configuration.imageNameOrURLString]]) {
                    [self wb_removeAndAnimateDefault];
                }
            }
        }
    }
    
    /*  < 配置跳过按钮 > */
    [self wb_addSkipButtonForConfiguration:configuration];
    [self wb_startSkipDispathTimer];
    
    /*  < customView > */
    WBWeakSelf
    adImageView.click = ^(CGPoint point) {
        [weakSelf wb_clickAndPoint:point];
    };
}

- (void)wb_startSkipDispathTimer {
    WBLaunchADConfiguration *configuration = [self wb_commonConfiguration];
    if (!configuration.skipButtonType) configuration.skipButtonType = WBCountdownBtnTypeText;
    __block NSInteger duration = kSkipCountdownTime;
    if (configuration.duration) duration = configuration.duration;
    if (configuration.skipButtonType == WBCountdownBtnTypeRoundProgressText || configuration.skipButtonType == WBCountdownBtnTypeRoundProgressTime) {
        [_skipButton wb_startRoundDispathTimerWithDuration:duration];
    }
    
    NSTimeInterval period = 1.f;
    _skipTimer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0));
    dispatch_source_set_timer(_skipTimer, dispatch_walltime(NULL, 0), period * NSEC_PER_SEC, 0);
    dispatch_source_set_event_handler(_skipTimer, ^{
        dispatch_async(dispatch_get_main_queue(), ^{
            if (!configuration.customSkipView) {
                [_skipButton wb_setTitleWithSkipType:configuration.skipButtonType
                                            duration:duration];
                if (duration == 0) {
                    DISPATCH_SOURCE_CANCEL_SAFE(_skipTimer);
                    [self wb_removeAndAnimate];
                }
                duration --;
            }
        });
    });
    
    dispatch_resume(_skipTimer);
}

- (void)wb_removeAndAnimate {
    WBLaunchADConfiguration *configuration = [self wb_commonConfiguration];
    CGFloat duration = kShowFinishAnimateTime;
    if (configuration.showFinishAnimateTime > 0) duration = configuration.showFinishAnimateTime;
    
    switch (configuration.showFinishAnimate) {
        case WBLaunchADFinishAnimationTypeNone:
            [self wb_remove];
            break;
        case WBLaunchADFinishAnimationTypeFadein:
            [self wb_removeAndAnimateDefault];
            break;
        case WBLaunchADFinishAnimationTypeLite:
        {
            [UIView transitionWithView:_window duration:duration options:UIViewAnimationOptionCurveEaseOut animations:^{
                _window.transform = CGAffineTransformMakeScale(1.5, 1.5);
                _window.alpha = 0;
            } completion:^(BOOL finished) {
                [self wb_remove];
            }];
        }
            break;
        case WBLaunchADFinishAnimationTypeFlipFromLeft:
        {
            [UIView transitionWithView:_window duration:duration options:UIViewAnimationOptionTransitionFlipFromLeft animations:^{
                _window.alpha = 0;
            } completion:^(BOOL finished) {
                [self wb_remove];
            }];
        }
            break;
        case WBLaunchADFinishAnimationTypeFlipFromBottom:
        {
            [UIView transitionWithView:_window duration:duration options:UIViewAnimationOptionTransitionFlipFromBottom animations:^{
                _window.alpha = 0;
            } completion:^(BOOL finished) {
                [self wb_remove];
            }];
        }
            break;
        case WBLaunchADFinishAnimationTypeCurlUp:
        {
            [UIView transitionWithView:_window duration:duration options:UIViewAnimationOptionTransitionCurlUp animations:^{
                _window.alpha = 0;
            } completion:^(BOOL finished) {
                [self wb_remove];
            }];
        }
            break;
        default:
            [self wb_removeAndAnimateDefault];
            break;
    }
}

- (void)wb_addSkipButtonForConfiguration:(WBLaunchADImageConfiguration *)configuration {
    if (!configuration.duration) configuration.duration = kSkipCountdownTime;
    if (!configuration.skipButtonType) configuration.skipButtonType = WBCountdownBtnTypeText;
    if (configuration.customSkipView) {
        [_window addSubview:configuration.customSkipView];
    }else {
        if (!_skipButton) {
            _skipButton = [[WBLaunchADButton alloc]initWithCountdonwType:configuration.skipButtonType];
            _skipButton.hidden = YES;
            [_skipButton addTarget:self
                            action:@selector(skipButtonClick)
                  forControlEvents:UIControlEventTouchUpInside];
            [_window addSubview:_skipButton];
            [_skipButton wb_setTitleWithSkipType:configuration.skipButtonType
                                        duration:configuration.duration];
        }
    }
}

- (WBLaunchADConfiguration *)wb_commonConfiguration {
    return _imageConfiguration;
}

- (void)wb_startWaitDataDispathTiemr {
    __block NSInteger duration = _waitDataDuration;
    _waitDataTimer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0));
    NSTimeInterval period = 1.0;
    dispatch_source_set_timer(_waitDataTimer, dispatch_walltime(NULL, 0), period * NSEC_PER_SEC, 0);
    dispatch_source_set_event_handler(_waitDataTimer, ^{
        if (duration == 0) {
            DISPATCH_SOURCE_CANCEL_SAFE(_waitDataTimer);
            dispatch_async(dispatch_get_main_queue(), ^{
                [[NSNotificationCenter defaultCenter] postNotificationName:WBLaunchAdWaitDataDurationArriveNotification
                                                                    object:nil];
                [self wb_remove];
                return ;
            });
        }
        duration --;
    });
    dispatch_resume(_waitDataTimer);
}

// MARK:remove
- (void)wb_removeAndAnimateDefault {
    WBLaunchADConfiguration *configuration = [self wb_commonConfiguration];
    CGFloat duration = kShowFinishAnimateTime;
    if (configuration.duration > 0) duration = configuration.duration;
    [UIView animateWithDuration:duration
                          delay:0.f
                        options:UIViewAnimationOptionTransitionNone
                     animations:^{
                         _window.alpha = .0f;
                     }
                     completion:^(BOOL finished) {
                         [self wb_remove];
                     }];
}

- (void)wb_remove {
    [self wb_removeOnly];
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(wbLaunchAdShowFinish:)]) {
        [self.delegate wbLaunchAdShowFinish:self];
    }
}

- (void)wb_removeOnly {
    DISPATCH_SOURCE_CANCEL_SAFE(_waitDataTimer);
    DISPATCH_SOURCE_CANCEL_SAFE(_skipTimer);
    REMOVE_FROM_SUPERVIEW_SAFE(_skipButton);
    
    if (_window) {
        [_window.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            REMOVE_FROM_SUPERVIEW_SAFE(obj);
        }];
        
        _window.hidden = YES;
        _window = nil;
    }
}

- (void)wb_removeSubViewsExceptLuancheImageView {
    if (_window.subviews.count) {
        [_window.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if (![obj isKindOfClass:[WBLaunchImageView class]]) {
                [obj removeFromSuperview];
                obj = nil;
            }
        }];
    }
}

- (void)wb_removeAndAnimated:(BOOL)animated{
    if(animated){
        [self wb_removeAndAnimate];
    }else{
        [self wb_remove];
    }
}

// MARK:Event Response
- (void)skipButtonClick {
    [self wb_removeAndAnimated:YES];
}

- (void)wb_clickAndPoint:(CGPoint)point {
    self.clickPoint = point;
    WBLaunchADConfiguration *configuration = [self wb_commonConfiguration];
    if (self.delegate && [self.delegate respondsToSelector:@selector(wbLaunchAd:clickAndOpenModel:clickPoint:)]) {
        [self.delegate wbLaunchAd:self
                clickAndOpenModel:configuration.openModel
                       clickPoint:point];
        [self wb_removeAndAnimateDefault];
    }
}

// MARK:public Method
+ (void)wb_setWaitDataDuration:(NSInteger)duration {
    [WBLaunchAD shareLaunchAD].waitDataDuration = duration;
}

+ (void)wb_setLaunchSourceType:(WBLaunchImageSourceType)sourceType {
    [WBLaunchAD shareLaunchAD].sourceType = sourceType;
}

+ (void)wb_showLuanchWithConfiguration:(WBLaunchADImageConfiguration *)configuration {
    [self wb_showLuanchWithConfiguration:configuration
                                delegate:nil];
}

+ (void)wb_showLuanchWithConfiguration:(WBLaunchADImageConfiguration *)configuration
                              delegate:(nullable id<WBLaunchADDelegate>)delegate {
    [WBLaunchAD shareLaunchAD].imageConfiguration = configuration;
    if (delegate) [WBLaunchAD shareLaunchAD].delegate = delegate;
}

// MARK:setter
- (void)setImageConfiguration:(WBLaunchADImageConfiguration *)imageConfiguration {
    _imageConfiguration = imageConfiguration;
    [self wb_setupImageAdForConfiguration:imageConfiguration];
}

- (void)setWaitDataDuration:(NSInteger)waitDataDuration {
    _waitDataDuration = waitDataDuration;
    [self wb_startWaitDataDispathTiemr];
}

@end
