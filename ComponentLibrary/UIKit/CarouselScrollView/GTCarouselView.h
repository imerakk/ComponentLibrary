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

@class GTCarouselView;

@protocol GTCarouselViewDataSource <NSObject>

- (UICollectionViewCell *)carouselView:(GTCarouselView *)carouseView cellForRowAtIndex:(NSInteger)index;
- (NSInteger)numberOfItemsInCarouselView:(GTCarouselView *)carouseView;

@end

@protocol GTCarouselViewDelegate <NSObject>
@optional
- (void)carouselView:(GTCarouselView *)carouseView didSelectedItemAtIndex:(NSInteger)index;

@end

@interface GTCarouselView : UIView

@property (nonatomic, weak)   id<GTCarouselViewDataSource> datasource;
@property (nonatomic, weak)   id<GTCarouselViewDelegate> delegate;
@property (nonatomic, assign) CGFloat itemSpacing;
@property (nonatomic, assign) CGFloat itemWidth;
@property (nonatomic, assign) BOOL autoScrollEnable;
@property (nonatomic, assign) CGFloat autoScrollDelayTime;

- (void)refreshView;
- (void)registerCellClass:(Class)itemClass forReuseIdentifier:(NSString *)reuseIdentifier;
- (__kindof UICollectionViewCell *)dequeueReusableCellWithReuseIdentifier:(NSString *)reuseIdentifier forIndex:(NSInteger)index;

@end

NS_ASSUME_NONNULL_END
