//
//  WBLaunchADImageView+WBLaunchADCache.m
//  Pods-WBLaunchAD_Example
//
//  Created by Mr_Lucky on 2019/3/29.
//

#import "WBLaunchADImageView+WBLaunchADCache.h"
#import "WBLaunchADConst.h"

@implementation WBLaunchADImageView (WBLaunchADCache)

- (void)wb_setImageWithURL:(nonnull NSURL *)url {
    [self wb_setImageWithURL:url
            placeholderImage:nil];
};

- (void)wb_setImageWithURL:(nonnull NSURL *)url
          placeholderImage:(nullable UIImage *)placeholder {
    [self wb_setImageWithURL:url
            placeholderImage:placeholder
                     options:WBLaunchADImageOptionsDefault];
};

- (void)wb_setImageWithURL:(nonnull NSURL *)url
          placeholderImage:(nullable UIImage *)placeholder
                   options:(WBLaunchADImageOptions)options {
    [self wb_setImageWithURL:url
            placeholderImage:placeholder
                     options:options
                   completed:nil];
};

- (void)wb_setImageWithURL:(nonnull NSURL *)url
          placeholderImage:(nullable UIImage *)placeholder
                 completed:(nullable WBExternalCompletionBlock)completedBlock {
    [self wb_setImageWithURL:url
            placeholderImage:placeholder
                     options:WBLaunchADImageOptionsDefault
                   completed:completedBlock];
};

- (void)wb_setImageWithURL:(nonnull NSURL *)url
                 completed:(nullable WBExternalCompletionBlock)completedBlock {
    [self wb_setImageWithURL:url
            placeholderImage:nil
                   completed:completedBlock];
};

- (void)wb_setImageWithURL:(nonnull NSURL *)url
          placeholderImage:(nullable UIImage *)placeholder
                   options:(WBLaunchADImageOptions)options
                 completed:(nullable WBExternalCompletionBlock)completedBlock {
    if (placeholder) self.image = placeholder;
    if (!url) return;
    
    WBWeakSelf
    [[WBLaunchADImageManager shareManager] wb_loadImageWithURL:url
                                                       options:options
                                                      progress:nil
                                                     completed:^(UIImage * _Nullable image, NSData * _Nullable imageData, NSError * _Nullable error, NSURL * _Nullable imageURL) {
                                                         if (!error) {
                                                             weakSelf.image = image;
                                                         }
                                                         if (completedBlock) {
                                                             completedBlock(image,imageData,error,imageURL);
                                                         }
                                                     }];
}

@end
