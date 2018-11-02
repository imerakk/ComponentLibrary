//
//  GTExtendView.m
//  ComponentLibrary
//
//  Created by liuchunxi on 2018/11/2.
//  Copyright © 2018年 imera. All rights reserved.
//

#import "GTExtendView.h"

@implementation GTGradientView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        _startPoint = CGPointMake(0.5, 0);
        _endPoint = CGPointMake(0.5, 1);
    }
    return self;
}

+ (Class)layerClass {
    return [CAGradientLayer class];
}

- (void)setColors:(NSArray *)colors {
    _colors = [colors copy];
    CAGradientLayer *gradientLayer = (CAGradientLayer *)self.layer;
    gradientLayer.colors = colors;
}

- (void)setStartPoint:(CGPoint)startPoint {
    _startPoint = startPoint;
    CAGradientLayer *gradientLayer = (CAGradientLayer *)self.layer;
    gradientLayer.startPoint = startPoint;
}

- (void)setEndPoint:(CGPoint)endPoint {
    _endPoint = endPoint;
    CAGradientLayer *gradientLayer = (CAGradientLayer *)self.layer;
    gradientLayer.endPoint = endPoint;
}

- (void)setLocations:(NSArray<NSNumber *> *)locations {
    _locations = [locations copy];
    
    CAGradientLayer *gradientLayer = (CAGradientLayer *)self.layer;
    gradientLayer.locations = locations;
}

@end

//////////////////////////////////////////////////////
@interface GTExtendView ()

@end

@implementation GTExtendView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        _contentView = [GTGradientView new];
        [self addSubview:_contentView];
    }
    
    return self;
}

- (void)layoutSubviews {
    _contentView.frame = self.bounds;
}

#pragma mark - setter
- (void)setCornRadius:(CGFloat)cornRadius {
    _cornRadius = cornRadius;
    
    self.contentView.layer.cornerRadius = cornRadius;
    self.contentView.layer.masksToBounds = YES;
}

- (void)setShadowRadius:(CGFloat)shadowRadius {
    _shadowRadius = shadowRadius;
    self.layer.shadowRadius = shadowRadius;
}

- (void)setShadowOffset:(CGSize)shadowOffset {
    _shadowOffset = shadowOffset;
    self.layer.shadowOffset = shadowOffset;
}

- (void)setShadowColor:(UIColor *)shadowColor {
    _shadowColor = shadowColor;
    self.layer.shadowColor = shadowColor.CGColor;
}

- (void)setShadowOpacity:(CGFloat)shadowOpacity {
    _shadowOpacity = shadowOpacity;
    self.layer.shadowOpacity = shadowOpacity;
}

- (void)setShadowPath:(CGPathRef)shadowPath {
    _shadowPath = shadowPath;
    self.layer.shadowPath = shadowPath;
}

- (void)setColors:(NSArray *)colors {
    _colors = [colors copy];
    self.contentView.colors = colors;
}

- (void)setLocations:(NSArray<NSNumber *> *)locations {
    _locations = [locations copy];
    self.contentView.locations = locations;
}

- (void)setStartPoint:(CGPoint)startPoint {
    _startPoint = startPoint;
    self.contentView.startPoint = startPoint;
}

- (void)setEndPoint:(CGPoint)endPoint {
    _endPoint = endPoint;
    self.contentView.endPoint = endPoint;
}

#pragma mark - API
- (void)setShadowWithRadius:(CGFloat)radius
                    opacity:(CGFloat)opacity
                     offset:(CGSize)offset
                      color:(UIColor *)color {
    self.layer.shadowRadius = radius;
    [self setShadowWithOpacity:opacity offset:offset color:color];
}

- (void)setShadowWithPath:(CGPathRef)path
                  opacity:(CGFloat)opacity
                   offset:(CGSize)offset
                    color:(UIColor *)color {
    self.layer.shadowPath = path;
    [self setShadowWithOpacity:opacity offset:offset color:color];
}
#pragma mark - private
- (void)setShadowWithOpacity:(CGFloat)opacity
                      offset:(CGSize)offset
                       color:(UIColor *)color {
    self.layer.shadowOpacity = opacity;
    self.layer.shadowOffset = offset;
    self.layer.shadowColor = color.CGColor;
}


@end
