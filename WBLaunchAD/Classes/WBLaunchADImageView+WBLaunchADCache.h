//
//  WBLaunchADImageView+WBLaunchADCache.h
//  Pods-WBLaunchAD_Example
//
//  Created by Mr_Lucky on 2019/3/29.
//

#import "WBLaunchADView.h"
#import "WBLaunchADImageManager.h"

NS_ASSUME_NONNULL_BEGIN

@interface WBLaunchADImageView (WBLaunchADCache)

/**
 设置url图片
 
 @param url 图片url
 */
- (void)wb_setImageWithURL:(nonnull NSURL *)url;

/**
 设置url图片
 
 @param url 图片url
 @param placeholder 占位图
 */
- (void)wb_setImageWithURL:(nonnull NSURL *)url
          placeholderImage:(nullable UIImage *)placeholder;

/**
 设置url图片
 
 @param url 图片url
 @param placeholder 占位图
 @param options XHLaunchAdImageOptions
 */
- (void)wb_setImageWithURL:(nonnull NSURL *)url
          placeholderImage:(nullable UIImage *)placeholder
                   options:(WBLaunchADImageOptions)options;

/**
 设置url图片
 
 @param url 图片url
 @param placeholder 占位图
 @param completedBlock XHExternalCompletionBlock
 */
- (void)wb_setImageWithURL:(nonnull NSURL *)url
          placeholderImage:(nullable UIImage *)placeholder
                 completed:(nullable WBExternalCompletionBlock)completedBlock;

/**
 设置url图片
 
 @param url 图片url
 @param completedBlock XHExternalCompletionBlock
 */
- (void)wb_setImageWithURL:(nonnull NSURL *)url
                 completed:(nullable WBExternalCompletionBlock)completedBlock;


/**
 设置url图片
 
 @param url 图片url
 @param placeholder 占位图
 @param options XHLaunchAdImageOptions
 @param completedBlock XHExternalCompletionBlock
 */
- (void)wb_setImageWithURL:(nonnull NSURL *)url
          placeholderImage:(nullable UIImage *)placeholder
                   options:(WBLaunchADImageOptions)options
                 completed:(nullable WBExternalCompletionBlock)completedBlock;


@end

NS_ASSUME_NONNULL_END
