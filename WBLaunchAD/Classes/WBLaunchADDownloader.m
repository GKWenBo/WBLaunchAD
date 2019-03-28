//
//  WBLaunchADDownloader.m
//  Pods-WBLaunchAD_Example
//
//  Created by 文波 on 2019/3/28.
//

#import "WBLaunchADDownloader.h"
#import "WBLaunchADConst.h"

// MARK:WBLaunchADDownload
@interface WBLaunchADDownload ()

@property (nonatomic, strong) NSURLSession *session;
@property (strong,nonatomic) NSURLSessionDownloadTask *downloadTask;
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
@property (strong, nonatomic) NSOperationQueue *downloadVideoQueue;
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

@end
