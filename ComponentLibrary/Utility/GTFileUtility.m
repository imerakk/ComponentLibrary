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

+ (void)createDirectoryAtPath:(NSString *)path error:(NSError * _Nullable __autoreleasing *)error {
    NSFileManager *fileManager = [NSFileManager defaultManager];
    BOOL isDirectory;
    if (![fileManager fileExistsAtPath:path isDirectory:&isDirectory]) {
        [fileManager createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:error];
    }
    else {
        if (!isDirectory) {
            *error = [NSError errorWithDomain:@"GTCreateDirectory" code:1 userInfo:nil];
        }
    }
}

@end
