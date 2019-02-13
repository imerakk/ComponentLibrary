//
//  GTSnapshotCapture.h
//  ComponentLibrary
//
//  Created by liuchunxi on 2019/2/12.
//  Copyright © 2019年 imera. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface GTSnapshotCapture : NSObject

+ (UIImage *)imageWithScreenSnapshot;
+ (UIImage *)imageWithViewSnapshot:(UIView *)view;
+ (UIImage *)imageWithViewSnapshot:(UIView *)view inViewRect:(CGRect)viewRect;

@end

NS_ASSUME_NONNULL_END
