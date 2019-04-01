//
//  WBLaunchAD.h
//  Pods-WBLaunchAD_Example
//
//  Created by 文波 on 2019/3/28.
//

#import <Foundation/Foundation.h>
#import "WBLaunchADConfiguration.h"
#import "WBLaunchImageView.h"
@class WBLaunchAD;

@protocol WBLaunchADDelegate <NSObject>

@optional
/**
 如果你想用SDWebImage等框架加载网络广告图片,请实现此代理,注意:实现此方法后,图片缓存将不受XHLaunchAd管理
 
 @param launchAD          launchAD
 @param launchAdImageView launchAdImageView
 @param url               图片url
 */
- (void)wbLaunchAD:(WBLaunchAD *)launchAD
 launchAdImageView:(UIImageView *)launchAdImageView
               URL:(NSURL *)url;
/**
 *  图片本地读取/或下载完成回调
 *
 *  @param launchAd  WBLaunchAD
 *  @param image 读取/下载的image
 *  @param imageData 读取/下载的imageData
 */
- (void)wbLaunchAD:(WBLaunchAD *)launchAd
imageDownLoadFinish:(UIImage *)image
         imageData:(NSData *)imageData;

/**
 广告视图显示完成回调

 @param launchAd WBLaunchAD
 */
- (void)wbLaunchAdShowFinish:(WBLaunchAD *)launchAd;

/**
 广告点击回调
 
 @param launchAd launchAd
 @param openModel 打开页面参数(此参数即你配置广告数据设置的configuration.openModel)
 @param clickPoint 点击位置
 */
- (void)wbLaunchAd:(WBLaunchAD *)launchAd
 clickAndOpenModel:(id)openModel
        clickPoint:(CGPoint)clickPoint;

@end

NS_ASSUME_NONNULL_BEGIN

@interface WBLaunchAD : NSObject

/**
 设置启动图来源

 @param sourceType 来源
 */
+ (void)wb_setLaunchSourceType:(WBLaunchImageSourceType)sourceType;

/**
 设置数据请求等待时间

 @param duration 等待时间
 */
+ (void)wb_setWaitDataDuration:(NSInteger)duration;

/**
 显示启动广告

 @param configuration 相关配置
 */
+ (void)wb_showLuanchWithConfiguration:(WBLaunchADImageConfiguration *)configuration;

/**
 显示启动广告

 @param configuration 配置
 @param delegate 代理
 */
+ (void)wb_showLuanchWithConfiguration:(WBLaunchADImageConfiguration *)configuration
                              delegate:(nullable id<WBLaunchADDelegate>)delegate;

@end

NS_ASSUME_NONNULL_END
