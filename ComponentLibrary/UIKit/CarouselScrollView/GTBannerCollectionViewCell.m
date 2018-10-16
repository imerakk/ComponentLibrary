//
//  HBBannerCollectionViewCell.m
//  demo
//
//  Created by liuchunxi on 2018/10/12.
//  Copyright © 2018年 liuchunxi. All rights reserved.
//

#import "GTBannerCollectionViewCell.h"
#define UIColorFromRGB(rgbValue)    [UIColor colorWithRed:((float)(((rgbValue) & 0xFF0000) >> 16))/255.0 \
green:((float)(((rgbValue) & 0x00FF00) >> 8))/255.0 \
blue:((float)((rgbValue) & 0x0000FF))/255.0 \
alpha:1.0]


@interface GTBannerCollectionViewCell ()

@property (nonatomic, strong) UIImageView *imageView;

@end

@implementation GTBannerCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        _imageView = ({
            UIImageView *imageView = [[UIImageView alloc] init];
            imageView.layer.cornerRadius = _cornerRadius;
            imageView.layer.masksToBounds = YES;
            [self addSubview:imageView];
            
            imageView;
        });
        
        _cornerRadius = 10;
        self.layer.shadowColor = UIColorFromRGB(0x5a5a5a).CGColor;
        self.layer.shadowOffset = CGSizeMake(0.0, 7.0);
        self.layer.shadowRadius = 9.0;
        self.layer.shadowOpacity = 0.25;
    }
    
    return self;
}

- (void)setImage:(UIImage *)image {
    _image = image;
    
    self.imageView.image = image;
}

- (void)setCornerRadius:(CGFloat)cornerRadius {
    _cornerRadius = cornerRadius;
    
    self.imageView.layer.cornerRadius = cornerRadius;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    self.imageView.frame = self.bounds;
    self.layer.shadowPath = CGPathCreateWithRect(CGRectMake(15, 0, self.frame.size.width - 30, self.frame.size.height), NULL);
}

@end
