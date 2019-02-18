//
//  UIImage+GTFileConvert.m
//  ComponentLibrary
//
//  Created by liuchunxi on 2019/2/14.
//  Copyright © 2019年 imera. All rights reserved.
//

#import "UIImage+GTPDF.h"
#import "GTFileUtility.h"

#define COMPLETION(image) \
dispatch_async(dispatch_get_main_queue(), ^{ \
completion(image); \
});

static NSString * const kFileDirectoryName = @"GTPDF";

static dispatch_queue_t image_pdf_category_create_queue() {
    static dispatch_queue_t queue;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        queue = dispatch_queue_create("UIImage.Category.PDF.Processing", DISPATCH_QUEUE_CONCURRENT);
    });
    
    return queue;
}

static UIImage * GTImageWithPDFDocument(CGPDFDocumentRef document, NSUInteger page, CGSize size) {
    CGFloat scale = [UIScreen mainScreen].scale;
    CGFloat pixelsWidth = size.width*scale;
    CGFloat pixelsHeight = size.height*scale;
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    
    CGContextRef context = CGBitmapContextCreate(NULL, pixelsWidth, pixelsHeight, 8, 0, colorSpace, kCGImageAlphaPremultipliedLast);
    CGContextScaleCTM(context, scale, scale);
    CGPDFPageRef documentPage = CGPDFDocumentGetPage(document, page);
    CGAffineTransform transform = CGPDFPageGetDrawingTransform(documentPage, kCGPDFMediaBox, CGRectMake(0, 0, size.width, size.height), 0, YES);
    CGContextConcatCTM(context, transform);
    
    CGContextSetInterpolationQuality(context, kCGInterpolationHigh);
    CGContextDrawPDFPage(context, documentPage);
    
    CGImageRef imageRef = CGBitmapContextCreateImage(context);
    UIImage *image = [UIImage imageWithCGImage:imageRef scale:scale orientation:UIImageOrientationUp];
    UIGraphicsEndImageContext();
    
    CGImageRelease(imageRef);
    CGContextRelease(context);
    CGColorSpaceRelease(colorSpace);
    
    return image;
}

static NSString * GTPDFWithImages(NSArray <UIImage *>* images, NSString *fileName, CGSize size) {
    if (![fileName hasSuffix:@"pdf"]) {
        fileName = [fileName stringByAppendingString:@".pdf"];
    }
    
    NSString *docDir = [[GTFileUtility documentDirectory] stringByAppendingPathComponent:kFileDirectoryName];
    NSString *filePath = [docDir stringByAppendingPathComponent:fileName];
    
    NSError *error = nil;
    [GTFileUtility createDirectoryAtPath:docDir error:&error];
    if (error) return nil;
    
    BOOL success = UIGraphicsBeginPDFContextToFile(filePath, CGRectMake(0, 0, size.width, size.height), nil);
    if (!success) return nil;
    
    CGContextRef conetxt = UIGraphicsGetCurrentContext();
    
    for (UIImage *image in images) {
        UIGraphicsBeginPDFPage();
        CGFloat scale = MIN(size.width / image.size.width, size.height / image.size.height);
        CGFloat translationX = (size.width - image.size.width*scale)*0.5;
        CGFloat translationY = (size.height - image.size.height*scale)*0.5;
        
        CGAffineTransform transform = CGAffineTransformScale(CGContextGetCTM(conetxt), scale, -scale);
        transform = CGAffineTransformTranslate(transform, 0, -size.height/scale);
        transform = CGAffineTransformTranslate(transform, translationX/scale, translationY/scale);
        CGContextConcatCTM(conetxt, transform);
        
        [image drawAtPoint:CGPointZero];
    }
    
    UIGraphicsEndPDFContext();
    
    return filePath;
}

@implementation UIImage (GTPDF)

+ (void)PDFToImagesWithUrl:(NSURL *)url atSize:(CGSize)size completion:(void (^)(NSArray <UIImage *>* _Nullable))completion {
    dispatch_async(image_pdf_category_create_queue(), ^{
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
        
        NSMutableArray *images = [NSMutableArray array];
        for (int i=1; i<=pageNumber; i++) {
            UIImage *image = GTImageWithPDFDocument(documentRef, i, size);
            [images addObject:image];
        }
        CGPDFDocumentRelease(documentRef);
        
        COMPLETION(images);
    });
}

+ (void)PDFToImageWithUrl:(NSURL *)url atSize:(CGSize)size atPage:(NSUInteger)page completion:(void (^)(UIImage * _Nullable))completion {
    dispatch_async(image_pdf_category_create_queue(), ^{

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
        
        COMPLETION(GTImageWithPDFDocument(documentRef, page, size));
    });
}

+ (void)imagesToPDFWithFileName:(NSString *)fileName images:(NSArray<UIImage *> *)images atSize:(CGSize)size completion:(void (^)(BOOL, NSString * _Nullable))completion {
    dispatch_async(image_pdf_category_create_queue(), ^{
        NSString *filePath = GTPDFWithImages(images, fileName, size);
        dispatch_async(dispatch_get_main_queue(), ^{
            if (filePath) {
                completion(YES, filePath);
            }
            else {
                completion(NO, nil);
            }
        });
    });
}

- (void)saveToPDFWithFileName:(NSString *)fileName atSize:(CGSize)size completion:(void (^)(BOOL, NSString * _Nullable))completion {
    dispatch_async(image_pdf_category_create_queue(), ^{
        NSString *filePath = GTPDFWithImages(@[self], fileName, size);
        dispatch_async(dispatch_get_main_queue(), ^{
            if (filePath) {
                completion(YES, filePath);
            }
            else {
                completion(NO, nil);
            }
        });
    });
}
@end
