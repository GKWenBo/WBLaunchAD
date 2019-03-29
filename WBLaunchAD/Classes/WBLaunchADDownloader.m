//
//  WBLaunchADDownloader.m
//  Pods-WBLaunchAD_Example
//
//  Created by 文波 on 2019/3/28.
//

#import "WBLaunchADDownloader.h"
#import "WBLaunchADConst.h"
#import "WBLaunchADCache.h"

// MARK:WBLaunchADDownload
@interface WBLaunchADDownload ()

@property (nonatomic, strong) NSURLSession *session;
@property (strong, nonatomic) NSURLSessionDownloadTask *downloadTask;
@property (nonatomic, assign) unsigned long long totalLength;
@property (nonatomic, assign) unsigned long long currentLength;
@property (nonatomic, copy) WBLaunchADDownloadProgressBlock progressBlock;
@property (strong, nonatomic) NSURL *url;

@end

@implementation WBLaunchADDownload

@end

// MARK:WBLaunchADImageDownload
@interface WBLaunchADImageDownload () <NSURLSessionDelegate, NSURLSessionDownloadDelegate>

@property (nonatomic, copy) WBLaunchADDownloadImageCompletedBlock completedBlock;

@end

@implementation WBLaunchADImageDownload

- (instancetype)initWithURL:(NSURL *)url
              delegateQueue:(NSOperationQueue *)queue
                   progress:(WBLaunchADDownloadProgressBlock)progressBlock
                  completed:(WBLaunchADDownloadImageCompletedBlock)completedBlock {
    if (self = [super init]) {
        self.url = url;
        self.progressBlock = progressBlock;
        self.completedBlock = completedBlock;
        NSURLSessionConfiguration *sessionConfiguration = [NSURLSessionConfiguration defaultSessionConfiguration];
        sessionConfiguration.timeoutIntervalForRequest = 15.f;
        self.session = [NSURLSession sessionWithConfiguration:sessionConfiguration
                                                     delegate:self
                                                delegateQueue:queue];
        self.downloadTask = [self.session downloadTaskWithRequest:[NSURLRequest requestWithURL:url]];
        [self.downloadTask resume];
    }
    return self;
}


// MARK:NSURLSessionDownloadDelegate && NSURLSessionDelegate
- (void)URLSession:(NSURLSession *)session
      downloadTask:(NSURLSessionDownloadTask *)downloadTask
didFinishDownloadingToURL:(NSURL *)location {
    NSData *data = [NSData dataWithContentsOfURL:location];
    UIImage *image = [UIImage imageWithData:data];
    dispatch_async(dispatch_get_main_queue(), ^{
        if (self.completedBlock) {
            self.completedBlock(image, data, nil);
            //防止重复调用
            self.completedBlock = nil;
        }
        
        //下载完成回调
        if (self.delegate && [self.delegate respondsToSelector:@selector(wb_downloadFinishWithURL:)]) {
            [self.delegate wb_downloadFinishWithURL:self.url];
        }
    });
    
    [self.session invalidateAndCancel];
    self.session = nil;
};

- (void)URLSession:(NSURLSession *)session
      downloadTask:(NSURLSessionDownloadTask *)downloadTask
      didWriteData:(int64_t)bytesWritten
 totalBytesWritten:(int64_t)totalBytesWritten
totalBytesExpectedToWrite:(int64_t)totalBytesExpectedToWrite {
    self.currentLength = totalBytesWritten;
    self.totalLength = totalBytesExpectedToWrite;
    if (self.progressBlock) {
        self.progressBlock(self.totalLength, self.currentLength);
    }
}

- (void)URLSession:(NSURLSession *)session
              task:(NSURLSessionTask *)task
didCompleteWithError:(NSError *)error {
    if (error) {
        WBLaunchADLog(@"error = %@",error);
        dispatch_async(dispatch_get_main_queue(), ^{
            if (self.completedBlock) {
                self.completedBlock(nil, nil, error);
            }
            self.completedBlock = nil;
        });
    }
}

//处理HTTPS请求的
- (void)URLSession:(NSURLSession *)session
didReceiveChallenge:(NSURLAuthenticationChallenge *)challenge
 completionHandler:(void (^)(NSURLSessionAuthChallengeDisposition, NSURLCredential *))completionHandler{
    NSURLProtectionSpace *protectionSpace = challenge.protectionSpace;
    if ([protectionSpace.authenticationMethod isEqualToString:NSURLAuthenticationMethodServerTrust]) {
        SecTrustRef serverTrust = protectionSpace.serverTrust;
        completionHandler(NSURLSessionAuthChallengeUseCredential, [NSURLCredential credentialForTrust:serverTrust]);
    } else {
        completionHandler(NSURLSessionAuthChallengePerformDefaultHandling, nil);
    }
}

@end

@interface WBLaunchADDownloader () <WBLaunchADDownloadDelegate>

@property (strong, nonatomic) NSOperationQueue *downloadImageQueue;
@property (strong, nonatomic) NSMutableDictionary *allDownloadDict;

@end

@implementation WBLaunchADDownloader

+ (instancetype)shareDownloader {
    static WBLaunchADDownloader *_downloader = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _downloader = [[self alloc]init];
    });
    return _downloader;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        _downloadImageQueue = [NSOperationQueue new];
        _downloadImageQueue.maxConcurrentOperationCount = 6;
        _downloadImageQueue.name = @"com.wenbo.WBLaunchADDownloadImageQueue";
        WBLaunchADLog(@"WBLauchADPath:%@",[WBLaunchADCache wb_launchADCachePath]);
    }
    return self;
}

- (void)wb_downloadImageWithURL:(NSURL *)url
                       progress:(nullable WBLaunchADDownloadProgressBlock)progressBlock
                      completed:(WBLaunchADDownloadImageCompletedBlock)completedBlock {
    NSString *key = [WBLaunchADCache wb_keyWithURL:url];
    WBLaunchADImageDownload *download = [[WBLaunchADImageDownload alloc]initWithURL:url
                                                                      delegateQueue:_downloadImageQueue
                                                                         progress:progressBlock
                                                                        completed:completedBlock];
    download.delegate = self;
    [self.allDownloadDict setObject:download forKey:key];
}

- (void)wb_downloadImageAndCacheWithURL:(NSURL *)url
                              completed:(void(^)(BOOL result))completedBlock {
    if (url == nil) {
        if (completedBlock) {
            completedBlock(NO);
            return;
        }
    }
    
    [self wb_downloadImageWithURL:url
                         progress:nil
                        completed:^(UIImage * _Nullable image, NSData * _Nullable data, NSError * _Nullable error) {
                            if (error) {
                                if (completedBlock) completedBlock(NO);
                            }else {
                                [WBLaunchADCache wb_asyncSaveImageData:data
                                                              imageURL:url
                                                             completed:^(BOOL res, NSURL * _Nonnull url) {
                                                                 if (completedBlock) completedBlock(res);
                                                             }];
                            }
                        }];
}

- (void)wb_downLoadImageAndCacheWithURLArray:(NSArray<NSURL *> *)urlArray {
    [self wb_downLoadImageAndCacheWithURLArray:urlArray
                                     completed:nil];
}

- (void)wb_downLoadImageAndCacheWithURLArray:(NSArray<NSURL *> *)urlArray
                                   completed:(nullable WBLaunchADBatchDownLoadAndCacheCompletedBlock)completedBlock {
    if (urlArray.count == 0) return;
    __block NSMutableArray *downloadArray = @[].mutableCopy;
    dispatch_group_t group = dispatch_group_create();
    [urlArray enumerateObjectsUsingBlock:^(NSURL * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (![WBLaunchADCache wb_checkImageCacheWithURL:obj]) {
            dispatch_group_enter(group);
            [self wb_downloadImageAndCacheWithURL:obj
                                        completed:^(BOOL result) {
                                            dispatch_group_leave(group);
                                            [downloadArray addObject:@{@"url":obj.absoluteString,@"result":@(result)}];
                                        }];
        }else {
            [downloadArray addObject:@{@"url":obj.absoluteString,@"result":@(YES)}];
        }
    }];
    
    dispatch_group_notify(group, dispatch_get_main_queue(), ^{
        if (completedBlock) {
            completedBlock(downloadArray);
        }
    });
}

// MARK:WBLaunchADDownloadDelegate
- (void)wb_downloadFinishWithURL:(NSURL *)url {
    [self.allDownloadDict removeObjectForKey:[WBLaunchADCache wb_keyWithURL:url]];
}

// MARK:getter
- (NSMutableDictionary *)allDownloadDict {
    if (!_allDownloadDict) {
        _allDownloadDict = @{}.mutableCopy;
    }
    return _allDownloadDict;
}

@end
