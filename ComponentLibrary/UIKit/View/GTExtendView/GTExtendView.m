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

#pragma mark - API
- (GTExtendViewChainableFloat)cornRadius {
    return GTExtendViewChainableFloat(cornRadius) {
        self.contentView.layer.cornerRadius = cornRadius;
        self.contentView.layer.masksToBounds = YES;
        return self;
    };
}

- (GTExtendViewChainableFloat)shadowRadius {
    return GTExtendViewChainableFloat(shadowRadius) {
        self.layer.shadowRadius = shadowRadius;
        return self;
    };
}

- (GTExtendViewChainableColor)shadowColor {
    return GTExtendViewChainableColor(color) {
        self.layer.shadowColor = color.CGColor;
        return self;
    };
}

- (GTExtendViewChainableSize)shadowOffset {
    return GTExtendViewChainableSize(size) {
        self.layer.shadowOffset = size;
        return self;
    };
}

- (GTExtendViewChainableFloat)shadowOpacity {
    return GTExtendViewChainableFloat(opacity) {
        self.layer.shadowOpacity = opacity;
        return self;
    };
}

- (GTExtendViewChainablePath)shadowPath {
    return GTExtendViewChainablePath(path) {
        self.layer.shadowPath = path;
        return self;
    };
}

- (GTExtendViewChainableArray)gradientColors {
    return GTExtendViewChainableArray(colors) {
        self.contentView.colors = colors;
        return self;
    };
}

- (GTExtendViewChainableArray)gradientLocations {
    return GTExtendViewChainableArray(locations) {
        self.contentView.locations = locations;
        return self;
    };
}

- (GTExtendViewChainablePoint)startPoint {
    return GTExtendViewChainablePoint(point) {
        self.contentView.startPoint = point;
        return self;
    };
}

- (GTExtendViewChainablePoint)endPoint {
    return GTExtendViewChainablePoint(point) {
        self.contentView.endPoint = point;
        return self;
    };
}

@end
