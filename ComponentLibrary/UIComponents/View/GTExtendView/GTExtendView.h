//
//  GTExtendView.h
//  ComponentLibrary
//
//  Created by liuchunxi on 2018/11/2.
//  Copyright © 2018年 imera. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GTExtendViewChainableBlocks.h"

NS_ASSUME_NONNULL_BEGIN

@interface GTGradientView : UIView

@property (nonatomic, copy) NSArray *colors; //An array of CGColorRef objects
@property (nonatomic, copy) NSArray<NSNumber *> *locations;
@property (nonatomic, assign) CGPoint startPoint;
@property (nonatomic, assign) CGPoint endPoint;

@end

////////////////////////////////////////////////////////////
@interface GTExtendView : UIView

@property (nonatomic, strong) GTGradientView *contentView;

/** 圆角 */
- (GTExtendViewChainableFloat)cornRadius;

/** 阴影 */
- (GTExtendViewChainableFloat)shadowRadius;
- (GTExtendViewChainableFloat)shadowOpacity;
- (GTExtendViewChainableSize)shadowOffset;
- (GTExtendViewChainableColor)shadowColor;
- (GTExtendViewChainablePath)shadowPath; 

/** 渐变 */
- (GTExtendViewChainableArray)gradientColors; //An array of CGColorRef objects
- (GTExtendViewChainablePoint)startPoint;
- (GTExtendViewChainablePoint)endPoint;
- (GTExtendViewChainableArray)gradientLocations;

@end

NS_ASSUME_NONNULL_END
