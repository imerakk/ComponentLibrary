//
//  GTFileUtility.m
//  ComponentLibrary
//
//  Created by liuchunxi on 2019/2/15.
//  Copyright © 2019年 imera. All rights reserved.
//

#import "GTFileUtility.h"

@implementation GTFileUtility

+ (NSString *)documentDirectory {
    return NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).firstObject;
}

+ (NSString *)libraryDirectory {
    return NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES).firstObject;
}

+ (NSString *)tempDirectory {
    return NSTemporaryDirectory();
}

@end
