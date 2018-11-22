//
//  GTPercentDrivenInteractiveTransition.m
//  ComponentLibrary
//
//  Created by liuchunxi on 2018/11/22.
//  Copyright © 2018年 imera. All rights reserved.
//

#import "GTPercentDrivenInteractiveTransition.h"
#import "GTContainerViewController.h"

@interface GTPercentDrivenInteractiveTransition ()

@property (nonatomic, weak) id<GTViewControllerContextTransitioning> transitionContext;

@end

@implementation GTPercentDrivenInteractiveTransition

- (void)startInteractiveTransition:(id<GTViewControllerContextTransitioning>)transitionContext {
    if ([transitionContext isKindOfClass:[GTViewControllerContextTransitioning class]]) {
        GTViewControllerContextTransitioning *context = (GTViewControllerContextTransitioning *)transitionContext;
        [context.animator animateTransition:context];
    }
    
    self.transitionContext = transitionContext;
}

- (void)pauseInteractiveTransition {
    [self.transitionContext pauseInteractiveTransition];
}

- (void)updateInteractiveTransition:(CGFloat)percentComplete {
    _percentComplete = percentComplete;
    [self.transitionContext updateInteractiveTransition:percentComplete];
}

- (void)cancelInteractiveTransition {
    [self.transitionContext cancelInteractiveTransition];
}

- (void)finishInteractiveTransition {
    [self.transitionContext finishInteractiveTransition];
}


@end
