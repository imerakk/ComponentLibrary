//
//  UIImage+GTFileConvert.h
//  ComponentLibrary
//
//  Created by liuchunxi on 2019/2/14.
//  Copyright © 2019年 imera. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIImage (GTPDF)

+ (void)PDFToImagesWithUrl:(NSURL *)url
                    atSize:(CGSize)size
                completion:(void (^)(NSArray <UIImage *>* _Nullable))completion;

+ (void)PDFToImageWithUrl:(NSURL *)url
                   atSize:(CGSize)size
                   atPage:(NSUInteger)page
               completion:(void (^)(UIImage * _Nullable))completion;


- (void)saveToPDFWithFileName:(NSString *)fileName atSize:(CGSize)size completion:(void (^)(BOOL success, NSString * _Nullable filePath))completion;


@end

NS_ASSUME_NONNULL_END
