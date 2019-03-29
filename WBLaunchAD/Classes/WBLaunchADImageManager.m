//
//  WBLaunchADImageManager.m
//  Pods-WBLaunchAD_Example
//
//  Created by 文波 on 2019/3/28.
//

#import "WBLaunchADImageManager.h"
#import "WBLaunchADCache.h"

@interface WBLaunchADImageManager ()

@property (nonatomic, strong) WBLaunchADDownloader *downloader;

@end

@implementation WBLaunchADImageManager

+ (instancetype)shareManager {
    static WBLaunchADImageManager *_instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [[self alloc]init];
    });
    return _instance;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        _downloader = [WBLaunchADDownloader shareDownloader];
    }
    return self;
}

- (void)wb_loadImageWithURL:(nullable NSURL *)url
                    options:(WBLaunchADImageOptions)options
                   progress:(nullable WBLaunchADDownloadProgressBlock)progressBlock
                  completed:(nullable WBExternalCompletionBlock)completedBlock {
    if (!options) options = WBLaunchADImageOptionsDefault;
    if (options & WBLaunchADImageOptionsOnlyLoad) {
        [_downloader wb_downloadImageWithURL:url
                                    progress:progressBlock
                                   completed:^(UIImage * _Nullable image, NSData * _Nullable data, NSError * _Nullable error) {
                                       if (completedBlock) {
                                           completedBlock(image,data,error,url);
                                       }
                                   }];
    }else if (options & WBLaunchADImageOptionsRefreshCached) {
        NSData *imageData = [WBLaunchADCache wb_getImageDataCahceWithURL:url];
        UIImage *image = [UIImage imageWithData:imageData];
        if (image && completedBlock) {
            completedBlock(image,imageData,nil,url);
        }
        [_downloader wb_downloadImageWithURL:url
                                    progress:progressBlock
                                   completed:^(UIImage * _Nullable image, NSData * _Nullable data, NSError * _Nullable error) {
                                       if (completedBlock) {
                                           completedBlock(image,data,error,url);
                                       }
                                       [WBLaunchADCache wb_asyncSaveImageData:data
                                                                     imageURL:url
                                                                    completed:nil];
                                   }];
    }else if (options & WBLaunchADImageOptionsCacheInBackground) {
        NSData *imageData = [WBLaunchADCache wb_getImageDataCahceWithURL:url];
        UIImage *image = [UIImage imageWithData:imageData];
        if (image && completedBlock) {
            completedBlock(image,imageData,nil,url);
        }else {
            [_downloader wb_downloadImageWithURL:url
                                        progress:progressBlock
                                       completed:^(UIImage * _Nullable image, NSData * _Nullable data, NSError * _Nullable error) {
                                           if (completedBlock) {
                                               completedBlock(image,data,error,url);
                                           }
                                           [WBLaunchADCache wb_asyncSaveImageData:data
                                                                         imageURL:url
                                                                        completed:nil];
                                       }];
        }
    }else {
        NSData *imageData = [WBLaunchADCache wb_getImageDataCahceWithURL:url];
        UIImage *image = [UIImage imageWithData:imageData];
        if (image && completedBlock) {
            completedBlock(image,imageData,nil,url);
        }else {
            [_downloader wb_downloadImageWithURL:url
                                        progress:progressBlock
                                       completed:^(UIImage * _Nullable image, NSData * _Nullable data, NSError * _Nullable error) {
                                           if (completedBlock) {
                                               completedBlock(image,data,error,url);
                                           }
                                           [WBLaunchADCache wb_asyncSaveImageData:data
                                                                         imageURL:url
                                                                        completed:nil];
                                       }];
        }
    }
}

@end
