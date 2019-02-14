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

+ (void)PDFToImageWithUrl:(NSURL *)url
            pageSizeBlock:(CGSize (^)(CGSize originPageSize))pageSizeBlock
               completion:(void (^)(UIImage *))completion;

+ (void)saveToPDFWithFileName:(NSString *)fileName completion:(void (^)(BOOL success, NSString *filePath))completion;


@end

NS_ASSUME_NONNULL_END
