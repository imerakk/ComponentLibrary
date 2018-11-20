//
//  GTCustomNavgationViewController.m
//  ComponentLibrary
//
//  Created by liuchunxi on 2018/11/20.
//  Copyright © 2018年 imera. All rights reserved.
//

#import "GTCustomNavgationViewController.h"

@interface GTCustomNavgationAnimator : NSObject <GTContainerViewControllerDelegate, UIViewControllerAnimatedTransitioning>

@end

@implementation GTCustomNavgationAnimator

#pragma mark - GTContainerViewControllerDelegate
- (nullable id <UIViewControllerInteractiveTransitioning>)containerViewController:(GTContainerViewController *)containerViewController
                                      interactionControllerForAnimationController:(id <UIViewControllerContextTransitioningExtension>)animationController {
    return nil;
}

- (nullable id <UIViewControllerAnimatedTransitioning>)containerViewController:(GTContainerViewController *)containerViewController
                                                            fromViewController:(UIViewController *)fromVC
                                                              toViewController:(UIViewController *)toVC {
    return self;
}

#pragma mark - UIViewControllerAnimatedTransitioning
- (NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext {
    return 3;
}

- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext {
    
}

@end


@interface GTCustomNavgationViewController ()

@end

@implementation GTCustomNavgationViewController

- (instancetype)initWithRootViewController:(UIViewController *)rootViewController {
    self = [super initWithViewControllers:@[rootViewController]];
    if (self) {
        GTCustomNavgationAnimator *animator = [GTCustomNavgationAnimator new];
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

