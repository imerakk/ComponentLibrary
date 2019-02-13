//
//  GTSnapshotCapture.m
//  ComponentLibrary
//
//  Created by liuchunxi on 2019/2/12.
//  Copyright © 2019年 imera. All rights reserved.
//

#import "GTSnapshotCapture.h"

@implementation GTSnapshotCapture

+ (UIImage *)imageWithScreenSnapshot {
    CGSize imageSize = [UIScreen mainScreen].bounds.size;
    
    UIGraphicsBeginImageContextWithOptions(imageSize, NO, 0.0);
    CGContextRef context = UIGraphicsGetCurrentContext();
    for (UIWindow *window in [UIApplication sharedApplication].windows) {
        CGContextSaveGState(context);
        //同步window transform
        CGContextTranslateCTM(context, window.center.x, window.center.y);
        CGContextConcatCTM(context, window.transform);
        CGContextTranslateCTM(context, -window.bounds.size.width*window.layer.anchorPoint.x, -window.bounds.size.height*window.layer.anchorPoint.y);
        
        [window drawViewHierarchyInRect:window.bounds afterScreenUpdates:NO];
        CGContextRestoreGState(context);
    }
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

+ (UIImage *)imageWithViewSnapshot:(UIView *)view {
    return [self imageWithViewSnapshot:view inViewRect:view.bounds];
}

+ (UIImage *)imageWithViewSnapshot:(UIView *)view inViewRect:(CGRect)viewRect {
    UIGraphicsBeginImageContextWithOptions(viewRect.size, NO, 0.0);
    CGContextRef context = UIGraphicsGetCurrentContext();
        
    [view drawViewHierarchyInRect:view.bounds afterScreenUpdates:NO];
    CGContextClipToRect(context, viewRect);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

@end
