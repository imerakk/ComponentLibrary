//
//  NSObject+GTSwizzling.h
//  ComponentLibrary
//
//  Created by liuchunxi on 2019/1/30.
//  Copyright © 2019年 imera. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSObject (GTSwizzling)

+ (BOOL)swizzleInstanceMethod:(SEL)originSel withNewSel:(SEL)newSel;
+ (BOOL)swizzleClassMethod:(SEL)originSel withNewSel:(SEL)newSel;

@end

NS_ASSUME_NONNULL_END
