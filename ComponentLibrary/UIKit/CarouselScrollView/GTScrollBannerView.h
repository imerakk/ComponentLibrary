//
//  HBScrollBannerView.h
//  demo
//
//  Created by liuchunxi on 2018/10/12.
//  Copyright © 2018年 liuchunxi. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

extern const CGFloat KControlViewHeight;
extern const CGFloat KControlViewMarginTop;

@interface GTScrollBannerView : UIView

+ (instancetype)scrollBannerViewWithFrame:(CGRect)frame images:(NSArray<UIImage *> *)images;

@property (nonatomic, strong) NSArray<UIImage *> *images;
@property (nonatomic, assign) CGFloat itemSpacing;
@property (nonatomic, assign) CGFloat itemWidth;
@property (nonatomic, assign) BOOL autoScrollEnable;
@property (nonatomic, assign) CGFloat autoScrollDelayTime; //defult 3.0

- (void)refreshView;

@end

NS_ASSUME_NONNULL_END
