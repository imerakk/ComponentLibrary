//
//  GTExtendView.h
//  ComponentLibrary
//
//  Created by liuchunxi on 2018/11/2.
//  Copyright © 2018年 imera. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface GTGradientView : UIView

@property (nonatomic, copy) NSArray *colors;
@property (nonatomic, copy) NSArray<NSNumber *> *locations;
@property (nonatomic, assign) CGPoint startPoint;
@property (nonatomic, assign) CGPoint endPoint;

@end

////////////////////////////////////////////////////////////
@interface GTExtendView : UIView

@property (nonatomic, strong) GTGradientView *contentView;

/** 圆角 */
@property (nonatomic, assign) CGFloat cornRadius;

/** 阴影 */
@property (nonatomic, assign) CGFloat shadowRadius;
@property (nonatomic, assign) CGFloat shadowOpacity;
@property (nonatomic, assign) CGSize shadowOffset;
@property (nonatomic, strong) UIColor *shadowColor;
@property (nonatomic, assign) CGPathRef shadowPath;

/** 渐变 */
@property (nonatomic, copy) NSArray *colors;
@property (nonatomic, copy) NSArray<NSNumber *> *locations;
@property (nonatomic, assign) CGPoint startPoint;
@property (nonatomic, assign) CGPoint endPoint;

- (void)setShadowWithRadius:(CGFloat)radius
                    opacity:(CGFloat)opacity
                     offset:(CGSize)offset
                      color:(UIColor *)color;

- (void)setShadowWithPath:(CGPathRef)path
                  opacity:(CGFloat)opacity
                   offset:(CGSize)offset
                    color:(UIColor *)color;
@end

NS_ASSUME_NONNULL_END
