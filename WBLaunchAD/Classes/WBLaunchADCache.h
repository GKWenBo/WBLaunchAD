//
//  WBLaunchADCache.h
//  Pods-WBLaunchAD_Example
//
//  Created by 文波 on 2019/3/28.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^WBLaunchADSaveCompletedBlock)(BOOL res, NSURL *url);

@interface WBLaunchADCache : NSObject

// MARK:图片缓存

/**
 检查图片f缓存是否存在

 @param url 图片URL
 @return YES/NO.
 */
+ (BOOL)wb_checkImageCacheWithURL:(NSURL *)url;

/**
 异步缓存图片

 @param data 图片二进制数据
 @param url 缓存地址
 @param completed 完成回调
 */
+ (void)wb_asyncSaveImageData:(NSData *)data
                     imageURL:(NSURL *)url
                    completed:(nullable WBLaunchADSaveCompletedBlock)completed;

/**
 获取缓存图片

 @param url 图片url
 @return 图片data
 */
+ (NSData *)wb_getImageDataCahceWithURL:(NSURL *)url;

/**
 缓存图片地址

 @param url 图片地址
 */
+ (void)wb_asyncSaveImageURL:(NSString *)url;

// MARK:文件路径

/**
 图片缓存地址
 
 @param url 图片URL
 @return 地址字符串
 */
+ (NSString *)wb_imagePathWithURL:(NSURL *)url;

/**
 缓存路径

 @return 路径
 */
+ (NSString *)wb_launchADCachePath;

/**
 md5字符串

 @param string 字符串
 @return md5字符串
 */
+ (NSString *)wb_md5String:(NSString *)string;

/**
 md5接口地址

 @param url 地址
 @return md5后的地址
 */
+ (NSString *)wb_keyWithURL:(NSURL *)url;


@end

NS_ASSUME_NONNULL_END
