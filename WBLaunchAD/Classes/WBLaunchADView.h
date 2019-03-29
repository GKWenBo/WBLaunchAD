//
//  WBLaunchADView.h
//  Pods-WBLaunchAD_Example
//
//  Created by Mr_Lucky on 2019/3/29.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface WBLaunchADImageView : UIImageView

@property (nonatomic, copy) void(^click)(CGPoint point);

@end

NS_ASSUME_NONNULL_END
