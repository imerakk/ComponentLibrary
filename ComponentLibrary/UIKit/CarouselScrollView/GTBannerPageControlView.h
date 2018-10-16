//
//  HBBannerPageControlView.h
//  demo
//
//  Created by liuchunxi on 2018/10/15.
//  Copyright © 2018年 liuchunxi. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface GTBannerPageControlView : UIView

@property (nonatomic, assign) CGFloat progress;

- (instancetype)initWithFrame:(CGRect)frame indexCount:(NSInteger)indexCount currentIndex:(NSInteger)currentIndex;

@end

NS_ASSUME_NONNULL_END
