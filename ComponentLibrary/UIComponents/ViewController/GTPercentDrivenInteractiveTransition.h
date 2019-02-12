//
//  GTPercentDrivenInteractiveTransition.h
//  ComponentLibrary
//
//  Created by liuchunxi on 2018/11/22.
//  Copyright © 2018年 imera. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GTTransitionViewControllerProtocol.h"

NS_ASSUME_NONNULL_BEGIN

@interface GTPercentDrivenInteractiveTransition : NSObject <GTViewControllerInteractiveTransitioning>

@property (nonatomic, readonly) CGFloat duration;
@property (nonatomic, readonly) CGFloat percentComplete;

- (void)startInteractiveTransition:(id<GTViewControllerContextTransitioning>)transitionContext;

- (void)pauseInteractiveTransition;
- (void)updateInteractiveTransition:(CGFloat)percentComplete;
- (void)cancelInteractiveTransition;
- (void)finishInteractiveTransition;

@end

NS_ASSUME_NONNULL_END
