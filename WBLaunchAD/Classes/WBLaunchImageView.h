//
//  WBLuanchImageView.h
//  Pods-WBLaunchAD_Example
//
//  Created by Mr_Lucky on 2019/3/29.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, WBLaunchImageSourceType) {
    WBLaunchImageSourceTypeImage,
    WBLaunchImageSourceTypeLuanchScreen
};

@interface WBLaunchImageView : UIImageView

- (instancetype)initWithSourceType:(WBLaunchImageSourceType)sourceType;

@end

NS_ASSUME_NONNULL_END
