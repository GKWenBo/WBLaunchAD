//
//  WBLaunchADConst.h
//  Pods-WBLaunchAD_Example
//
//  Created by 文波 on 2019/3/28.
//

#import <Foundation/Foundation.h>

#ifdef DEBUG
#define WBLaunchADLog(FORMAT, ...) fprintf(stderr,"%s:%d\t%s\n",[[[NSString stringWithUTF8String:__FILE__] lastPathComponent] UTF8String], __LINE__, [[NSString stringWithFormat:FORMAT, ##__VA_ARGS__] UTF8String]);
#else
#define WBLaunchADLog(...)
#endif

#define WBWeakSelf __weak typeof(self) weakSelf = self;

#define WBISURLString(string)  ([string hasPrefix:@"https://"] || [string hasPrefix:@"http://"]) ? YES:NO

#define DISPATCH_SOURCE_CANCEL_SAFE(time) if(time)\
{\
dispatch_source_cancel(time);\
time = nil;\
}

#define REMOVE_FROM_SUPERVIEW_SAFE(view) if(view)\
{\
[view removeFromSuperview];\
view = nil;\
}

#define WB_IPHONEX  ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1125, 2436), [[UIScreen mainScreen] currentMode].size) : NO)
#define WB_IPHONEXR    ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(828, 1792), [[UIScreen mainScreen] currentMode].size) : NO)
#define WB_IPHONEXSMAX    ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1242, 2688), [[UIScreen mainScreen] currentMode].size) : NO)
#define WB_FULLSCREEN ((WB_IPHONEX || WB_IPHONEXR || WB_IPHONEXSMAX) ? YES : NO)

#define WB_ScreenW    [UIScreen mainScreen].bounds.size.width
#define WB_ScreenH    [UIScreen mainScreen].bounds.size.height


NS_ASSUME_NONNULL_BEGIN

@interface WBLaunchADConst : NSObject

extern NSString *const WBLuanchADCacheImageUrlStringKey;
extern NSString *const WBLaunchAdWaitDataDurationArriveNotification;

@end

NS_ASSUME_NONNULL_END
