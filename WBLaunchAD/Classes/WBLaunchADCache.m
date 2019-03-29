//
//  WBLaunchADCache.m
//  Pods-WBLaunchAD_Example
//
//  Created by 文波 on 2019/3/28.
//

#import "WBLaunchADCache.h"
#import "WBLaunchADConst.h"
#import <CommonCrypto/CommonDigest.h>

static NSString *const kWBLuanchADPath = @"Library/WBLaunchADCache";

@implementation WBLaunchADCache

// MARK:图片缓存
+ (void)wb_asyncSaveImageData:(NSData *)data
                     imageURL:(NSURL *)url
                    completed:(nullable WBLaunchADSaveCompletedBlock)completed {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
       BOOL res = [self wb_saveImageData:data
                                imageURL:url];
        dispatch_async(dispatch_get_main_queue(), ^{
            if (completed) completed(res,url);
        });
    });
}

+ (BOOL)wb_saveImageData:(NSData *)data
                imageURL:(NSURL *)url {
    NSString *path = [self wb_imagePathWithURL:url];
    if (data) {
        BOOL res = [[NSFileManager defaultManager] createFileAtPath:path
                                                           contents:data
                                                         attributes:nil];
        if (!res) WBLaunchADLog(@"cache file error for URL: %@", url);
        return res;
    }
    return NO;
}

+ (NSData *)wb_getImageDataCahceWithURL:(NSURL *)url {
    if (!url) return nil;
    return [NSData dataWithContentsOfFile:[self wb_imagePathWithURL:url]];
}

+ (void)wb_asyncSaveImageURL:(NSString *)url {
    if (!url) return;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [[NSUserDefaults standardUserDefaults] setObject:url forKey:WBLuanchADCacheImageUrlStringKey];
        [[NSUserDefaults standardUserDefaults] synchronize];
    });
}

+ (NSString *)wb_launchADCachePath {
    return [NSHomeDirectory() stringByAppendingPathComponent:kWBLuanchADPath];
}

+ (NSString *)wb_imagePathWithURL:(NSURL *)url {
    return [[self wb_launchADCachePath] stringByAppendingPathComponent:[self wb_keyWithURL:url]];
}

+ (BOOL)wb_checkImageCacheWithURL:(NSURL *)url {
    return [[NSFileManager defaultManager] fileExistsAtPath:[self wb_imagePathWithURL:url]];
}

+ (void)wb_createDirectoryIfNeeded:(NSString *)path {
    NSFileManager *fileManager = [NSFileManager defaultManager];
    BOOL isDir;
    if (![fileManager fileExistsAtPath:path isDirectory:&isDir]) {
        [self wb_createBaseDirectoryAtPath:path];
    }else {
        if (!isDir) {
            [fileManager removeItemAtPath:path
                                    error:nil];
            [self wb_createBaseDirectoryAtPath:path];
        }
    }
}

+ (void)wb_createBaseDirectoryAtPath:(NSString *)path {
    NSError *error = nil;
    [[NSFileManager defaultManager] createDirectoryAtPath:path withIntermediateDirectories:YES
                                               attributes:nil
                                                    error:&error];
    if (error) {
        WBLaunchADLog(@"create cache directory failed, error = %@", error);
    }else {
        [self wb_addDoNotBackupAttribute:path];
    }
}

+ (void)wb_addDoNotBackupAttribute:(NSString *)path {
    NSURL *url = [NSURL fileURLWithPath:path];
    NSError *error = nil;
    [url setResourceValue:[NSNumber numberWithBool:YES] forKey:NSURLIsExcludedFromBackupKey error:&error];
    if (error) {
        WBLaunchADLog(@"error to set do not backup attribute, error = %@", error);
    }
}

+ (NSString *)wb_md5String:(NSString *)string {
    const char *value = [string UTF8String];
    unsigned char outputBuffer[CC_MD5_DIGEST_LENGTH];
    CC_MD5(value, (CC_LONG)strlen(value), outputBuffer);
    NSMutableString *outputString = [[NSMutableString alloc] initWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
    for(NSInteger count = 0; count < CC_MD5_DIGEST_LENGTH; count++){
        [outputString appendFormat:@"%02x",outputBuffer[count]];
    }
    return outputString;
}

+ (NSString *)wb_keyWithURL:(NSURL *)url {
    return [self wb_md5String:url.absoluteString];
}

@end
