//
//  GTFileUtility.h
//  ComponentLibrary
//
//  Created by liuchunxi on 2019/2/15.
//  Copyright © 2019年 imera. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface GTFileUtility : NSObject

+ (NSString *)documentDirectory;
+ (NSString *)libraryDirectory;
+ (NSString *)tempDirectory;

@end

NS_ASSUME_NONNULL_END
