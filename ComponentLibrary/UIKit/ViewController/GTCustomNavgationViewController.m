//
//  GTCustomNavgationViewController.m
//  ComponentLibrary
//
//  Created by liuchunxi on 2018/11/20.
//  Copyright © 2018年 imera. All rights reserved.
//

#import "GTCustomNavgationViewController.h"

@interface GTCustomNavgationAnimator : NSObject <GTContainerViewControllerDelegate, GTViewControllerAnimatedTransitioning>

@property (nonatomic, assign) UINavigationControllerOperation operation;

@end

@implementation GTCustomNavgationAnimator

#pragma mark - GTContainerViewControllerDelegate
- (nullable id <UIViewControllerInteractiveTransitioning>)containerViewController:(GTContainerViewController *)containerViewController
                                      interactionControllerForAnimationController:(id <GTViewControllerContextTransitioning>)animationController {
    return nil;
}

- (nullable id <GTViewControllerAnimatedTransitioning>)containerViewController:(GTContainerViewController *)containerViewController
                                                            fromViewController:(UIViewController *)fromVC
                                                              toViewController:(UIViewController *)toVC {
    NSInteger fromIndex = [containerViewController.viewControllers indexOfObject:fromVC];
    NSInteger toIndex = [containerViewController.viewControllers indexOfObject:toVC];
    if (fromIndex == toIndex) {
        self.operation = UINavigationControllerOperationNone;
    }
    else if (fromIndex > toIndex) {
        self.operation = UINavigationControllerOperationPop;
    }
    else {
        self.operation = UINavigationControllerOperationPush;
    }
    
    return self;
}

#pragma mark - UIViewControllerAnimatedTransitioning
- (NSTimeInterval)transitionDuration:(id<GTViewControllerContextTransitioning>)transitionContext {
    return 0.2;
}

- (void)animateTransition:(id<GTViewControllerContextTransitioning>)transitionContext {
    if (self.operation == UINavigationControllerOperationNone) {
        return;
    }
    
    UIView *fromView = [transitionContext viewForKey:UITransitionContextFromViewKey];
    UIView *toView = [transitionContext viewForKey:UITransitionContextToViewKey];
    
    if (self.operation == UINavigationControllerOperationPush) {
        [transitionContext.containerView insertSubview:toView aboveSubview:fromView];
        CGAffineTransform transform = CGAffineTransformTranslate(CGAffineTransformIdentity, transitionContext.containerView.frame.size.width, 0);
        toView.transform = transform;
        [transitionContext addAnimation:^{
                                toView.transform = CGAffineTransformIdentity;
        }
                               duration:[self transitionDuration:transitionContext]
                         animationCurve:UIViewAnimationCurveLinear
                            compeletion:^(id<GTViewControllerContextTransitioning> transitioningContext) {
                                [transitioningContext completeTransition:![transitioningContext transitionWasCancelled]];
                            }];
    }
    else {
        [transitionContext.containerView insertSubview:toView belowSubview:fromView];
        
        CGAffineTransform transform = CGAffineTransformTranslate(CGAffineTransformIdentity, transitionContext.containerView.frame.size.width, 0);
        [transitionContext addAnimation:^{
            fromView.transform = transform;
        }
                               duration:[self transitionDuration:transitionContext]
                         animationCurve:UIViewAnimationCurveLinear
                            compeletion:^(id<GTViewControllerContextTransitioning> transitioningContext) {
                                [transitioningContext completeTransition:![transitioningContext transitionWasCancelled]];
                            }];
    }

    
    [transitionContext startAnimations];
}

@end


@interface GTCustomNavgationViewController ()

@property (nonatomic, strong) GTCustomNavgationAnimator *animator;

@end

@implementation GTCustomNavgationViewController

- (instancetype)initWithRootViewController:(UIViewController *)rootViewController {
    self = [super initWithViewControllers:@[rootViewController]];
    if (self) {
        GTCustomNavgationAnimator *animator = [GTCustomNavgationAnimator new];
        self.animator = animator;
        self.delegate = animator;
    }
    return self;
}

- (void)pushViewController:(UIViewController *)viewController {
    [self gt_addChildViewController:viewController];
    self.selectedViewcontroller = viewController;
    
}

- (void)popViewController {
    NSInteger selectedIndex = [self.viewControllers indexOfObject:self.selectedViewcontroller];

    if (selectedIndex - 1 >= 0 && self.viewControllers.count > selectedIndex - 1) {
        self.selectedViewcontroller = self.viewControllers[selectedIndex - 1];
        [self gt_removeChildViewController:self.viewControllers[selectedIndex]];
    }
}

@end

