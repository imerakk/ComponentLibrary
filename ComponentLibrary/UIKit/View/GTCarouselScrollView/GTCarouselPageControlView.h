//
//  HBBannerPageControlView.h
//  demo
//
//  Created by liuchunxi on 2018/10/15.
//  Copyright © 2018年 liuchunxi. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface GTCarouselPageControlView : UIView

@property (nonatomic, assign) CGFloat progress;
@property (nonatomic, assign) NSInteger unselectedColor;
@property (nonatomic, assign) NSInteger selectedColor;

- (instancetype)initWithFrame:(CGRect)frame indexCount:(NSInteger)indexCount currentIndex:(NSInteger)currentIndex;

@end

NS_ASSUME_NONNULL_END
