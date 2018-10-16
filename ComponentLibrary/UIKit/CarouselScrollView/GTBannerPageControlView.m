//
//  HBBannerPageControlView.m
//  demo
//
//  Created by liuchunxi on 2018/10/15.
//  Copyright © 2018年 liuchunxi. All rights reserved.
//

#import "GTBannerPageControlView.h"

#define UIColorFromRGB(rgbValue)    [UIColor colorWithRed:((float)(((rgbValue) & 0xFF0000) >> 16))/255.0 \
green:((float)(((rgbValue) & 0x00FF00) >> 8))/255.0 \
blue:((float)((rgbValue) & 0x0000FF))/255.0 \
alpha:1.0]

static const CGFloat kPageControlItemMarginLeft = 4.0;

@interface GTBannerPageControlView ()

@property (nonatomic, assign) NSInteger indexCount;
@property (nonatomic, assign) NSInteger currentIndex;
@property (nonatomic, strong) UIView *contentView;
@property (nonatomic, strong) NSMutableArray *controlViews;
@property (nonatomic, assign) NSInteger unselectedColor;
@property (nonatomic, assign) NSInteger selectedColor;

@end

@implementation GTBannerPageControlView

- (instancetype)initWithFrame:(CGRect)frame indexCount:(NSInteger)indexCount currentIndex:(NSInteger)currentIndex {
    self = [super initWithFrame:frame];
    if (self) {
        _indexCount = indexCount;
        _currentIndex = currentIndex;
        _progress = currentIndex;
        _controlViews = [NSMutableArray array];
        _unselectedColor = 0xd9d9d9;
        _selectedColor = 0xffc040;
        
        [self initSubView];
        [self updateControlView];
    }
    
    return self;
}

- (void)initSubView {
    if (self.indexCount <= 0) {
        return;
    }
    
    self.contentView = [[UIView alloc] init];
    [self addSubview:self.contentView];
    
    for (int i = 0; i < self.indexCount; i++) {
        UIView *controlView = [[UIView alloc] init];
        controlView.layer.cornerRadius = 2.5;
        controlView.layer.masksToBounds = YES;
        [self.controlViews addObject:controlView];
        [self.contentView addSubview:controlView];
    }
}

- (void)updateControlView {
    if (self.progress < 0 || self.progress > self.indexCount - 1) {
        return;
    }
    
    CGFloat controlViewX = 0;
    int r1 = (self.unselectedColor & 0xff0000) >> 16;
    int g1 = (self.unselectedColor & 0x00ff00) >> 8;
    int b1 = (self.unselectedColor & 0x0000ff);
    int r2 = (self.selectedColor & 0xff0000) >> 16;
    int g2 = (self.selectedColor & 0x00ff00) >> 8;
    int b2 = (self.selectedColor & 0x0000ff);
    
    for (int i = 0; i < self.indexCount; i++) {
        CGFloat offset = self.progress - i;
        UIView *controlView = self.controlViews[i];
        if (fabs(offset) >= 1) {
            controlView.frame = CGRectMake(controlViewX, 0, self.frame.size.height, self.frame.size.height);
            controlView.backgroundColor = UIColorFromRGB(self.unselectedColor);
            controlViewX = CGRectGetMaxX(controlView.frame) + kPageControlItemMarginLeft;
        }
        else {
            int tempR = r2 + (r1 - r2) * fabs(offset);
            int tempG = g2 + (g1 - g2) * fabs(offset);
            int tempB = b2 + (b1 - b2) * fabs(offset);

            controlView.backgroundColor = [UIColor colorWithRed:(float)tempR/255.0  green:(float)tempG/255.0 blue:(float)tempB/255.0 alpha:1.0];
            controlView.frame = CGRectMake(controlViewX, 0, self.frame.size.height + (1 - fabs(offset))*6, self.frame.size.height);
            controlViewX = CGRectGetMaxX(controlView.frame) + kPageControlItemMarginLeft;
        }
    }
}

- (void)setProgress:(CGFloat)progress {
    _progress = progress;
    [self updateControlView];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    CGFloat contentViewWidth = (self.indexCount - 1)*(self.frame.size.height + kPageControlItemMarginLeft) + 11;
    self.contentView.frame = CGRectMake(0, 0, contentViewWidth, self.frame.size.height);
    self.contentView.center = CGPointMake(self.frame.size.width / 2, self.frame.size.height / 2);
    [self updateControlView];
}

@end
