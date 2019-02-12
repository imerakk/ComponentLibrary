//
//  NSObject+GTSwizzling.m
//  ComponentLibrary
//
//  Created by liuchunxi on 2019/1/30.
//  Copyright © 2019年 imera. All rights reserved.
//

#import "NSObject+GTSwizzling.h"
#import <objc/runtime.h>

@implementation NSObject (GTSwizzling)

+ (BOOL)swizzleInstanceMethod:(SEL)originSel withNewSel:(SEL)newSel {
    Method originMethod = class_getInstanceMethod(self, originSel);
    Method newMethod = class_getInstanceMethod(self, newSel);
    
    if (!originSel || !newMethod) {
        return NO;
    }
    
    method_exchangeImplementations(originMethod, newMethod);
    return YES;
}

+ (BOOL)swizzleClassMethod:(SEL)originSel withNewSel:(SEL)newSel {
    Class class = object_getClass(self);
    
    Method originMethod = class_getInstanceMethod(class, originSel);
    Method newMethod = class_getInstanceMethod(class, newSel);
    
    if (!originSel || !newMethod) {
        return NO;
    }
    
    method_exchangeImplementations(originMethod, newMethod);
    return YES;
}
@end
