//
//  UIImage+GTFileConvert.m
//  ComponentLibrary
//
//  Created by liuchunxi on 2019/2/14.
//  Copyright © 2019年 imera. All rights reserved.
//

#import "UIImage+GTPDF.h"

@implementation UIImage (GTPDF)

+ (void)PDFToImageWithUrl:(NSURL *)url
            pageSizeBlock:(CGSize (^)(CGSize))pageSizeBlock
               completion:(void (^)(UIImage *))completion {
    dispatch_queue_t queue = dispatch_queue_create("UIImage.PDF.Processing", DISPATCH_QUEUE_CONCURRENT);
    dispatch_async(queue, ^{
#define COMPLETION(image) \
dispatch_async(dispatch_get_main_queue(), ^{ \
completion(image); \
});
        CGPDFDocumentRef documentRef = CGPDFDocumentCreateWithURL((__bridge CFURLRef)url);
        if (documentRef == NULL) {
            CGPDFDocumentRelease(documentRef);
            COMPLETION(nil);
            return;
        };
        
        size_t pageNumber = CGPDFDocumentGetNumberOfPages(documentRef);
        if (pageNumber == 0) {
            CGPDFDocumentRelease(documentRef);
            COMPLETION(nil);
            return;
        };
        
        __block CGSize pageSize = CGSizeZero;
        CGPDFPageRef page = CGPDFDocumentGetPage(documentRef, 0);
        CGRect pageRect = CGPDFPageGetBoxRect(page, kCGPDFMediaBox);
        
        if (pageSizeBlock) {
            dispatch_sync(dispatch_get_main_queue(), ^{
                pageSize = pageSizeBlock(pageRect.size);
            });
        }
        else {
            pageSize = pageRect.size;
        }
        
        CGFloat scale = [UIScreen mainScreen].scale;
        NSMutableArray *images = [NSMutableArray array];
        for (int i=1; i<=pageNumber; i++) {
            CGPDFPageRef page = CGPDFDocumentGetPage(documentRef, i);
            CGRect pageRect = CGPDFPageGetBoxRect(page, kCGPDFMediaBox);
            CGFloat pixelsWidth = pageRect.size.width*scale;
            CGFloat pixelsHeight = pageRect.size.height*scale;
            CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
            CGContextRef context = CGBitmapContextCreate(NULL, pixelsWidth, pixelsHeight, 8, 0, colorSpace, kCGImageAlphaPremultipliedLast);
            CGContextScaleCTM(context, scale, scale);
            CGContextDrawPDFPage(context, page);
            CGImageRef imageRef = CGBitmapContextCreateImage(context);
            UIImage *image = [UIImage imageWithCGImage:imageRef scale:scale orientation:UIImageOrientationUp];
            [images addObject:image];
            UIGraphicsEndImageContext();
            
            CGImageRelease(imageRef);
            CGContextRelease(context);
            CGColorSpaceRelease(colorSpace);
        }
        CGPDFDocumentRelease(documentRef);
        
        CGSize imageSize = CGSizeMake(pageSize.width, pageSize.height * pageNumber);
        UIGraphicsBeginImageContextWithOptions(imageSize, NO, 0);
        [images enumerateObjectsUsingBlock:^(UIImage * _Nonnull image, NSUInteger idx, BOOL * _Nonnull stop) {
            CGRect rect = CGRectMake(0, pageSize.height*idx, pageSize.width, pageSize.height);
            [image drawInRect:rect];
        }];
        UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
        COMPLETION(image);
        UIGraphicsEndImageContext();
#undef COMPLETION
    });
}

+ (void)saveToPDFWithFileName:(NSString *)fileName completion:(void (^)(BOOL, NSString * _Nonnull))completion {
    
}


@end
