//
//  WBLaunchADDownloader.h
//  Pods-WBLaunchAD_Example
//
//  Created by 文波 on 2019/3/28.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^WBLaunchADDownloadProgressBlock)(unsigned long long total, unsigned long long current);
typedef void(^WBLaunchADDownloadImageCompletedBlock)(UIImage *_Nullable image, NSData *_Nullable data, NSError *_Nullable error);

@protocol WBLaunchADDownloadDelegate <NSObject>

- (void)wb_downloadFinishWithURL:(NSURL *)url;

@end

// MARK:WBLaunchADDownload
@interface WBLaunchADDownload : NSObject

@property (nonatomic, assign) id<WBLaunchADDownloadDelegate> delegate;

@end

// MARK:WBLaunchADImageDownload
@interface WBLaunchADImageDownload : WBLaunchADDownload

@end

@interface WBLaunchADDownloader : NSObject

+ (instancetype)shareDownloader;

- (void)wb_downloadImageWithURL:(NSURL *)url
                       progress:(WBLaunchADDownloadProgressBlock)progressBlock
                      completed:(WBLaunchADDownloadImageCompletedBlock)completedBlock;
- (void)wb_downLoadImageAndCacheWithURLArray:(NSArray <NSURL *> * )urlArray;
- (void)wb_downLoadImageAndCacheWithURLArray:(NSArray <NSURL *> * )urlArray
                                   completed:(WBLaunchADDownloadImageCompletedBlock)completedBlock;

@end

NS_ASSUME_NONNULL_END
