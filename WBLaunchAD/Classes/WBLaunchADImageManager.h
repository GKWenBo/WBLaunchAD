//
//  WBLaunchADImageManager.h
//  Pods-WBLaunchAD_Example
//
//  Created by 文波 on 2019/3/28.
//

#import <Foundation/Foundation.h>
#import "WBLaunchADDownloader.h"

NS_ASSUME_NONNULL_BEGIN

typedef NS_OPTIONS(NSInteger, WBLaunchADImageOptions) {
    /*  < 有缓存,读取缓存,不重新下载,没缓存先下载,并缓存 > */
    WBLaunchADImageOptionsDefault = 1 << 0,
    /*  < 只下载,不缓存 > */
    WBLaunchADImageOptionsOnlyLoad = 1 << 1,
    /*  < 先读缓存,再下载刷新图片和缓存 > */
    WBLaunchADImageOptionsRefreshCached = 1 << 2,
    /*  < 后台缓存本次不显示,缓存OK后下次再显示(建议使用这种方式) > */
    WBLaunchADImageOptionsCacheInBackground = 1 << 3
};

typedef void(^WBExternalCompletionBlock)(UIImage *_Nullable image, NSData *_Nullable imageData, NSError *_Nullable error, NSURL *_Nullable imageURL);

@interface WBLaunchADImageManager : NSObject

+ (instancetype)shareManager;

- (void)wb_loadImageWithURL:(nullable NSURL *)url
                    options:(WBLaunchADImageOptions)options
                   progress:(nullable WBLaunchADDownloadProgressBlock)progressBlock
                  completed:(nullable WBExternalCompletionBlock)completedBlock;

@end

NS_ASSUME_NONNULL_END
