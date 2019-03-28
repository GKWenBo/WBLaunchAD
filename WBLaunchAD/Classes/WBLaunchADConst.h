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

NS_ASSUME_NONNULL_BEGIN

@interface WBLaunchADConst : NSObject

@end

NS_ASSUME_NONNULL_END
