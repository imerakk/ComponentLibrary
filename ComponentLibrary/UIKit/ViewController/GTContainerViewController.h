//
//  GTContainerViewController.h
//  ComponentLibrary
//
//  Created by liuchunxi on 2018/11/13.
//  Copyright © 2018年 imera. All rights reserved.
//

#import <UIKit/UIKit.h>

@class GTContainerViewController;

@protocol UIViewControllerContextTransitioningExtension <NSObject, UIViewControllerContextTransitioning>

- (void)addAnimation:(void (^)(void))animation
            duration:(NSTimeInterval)duration
      animationCurve:(UIViewAnimationCurve)animationCurve
         compeletion:(void (^)(void))compeletion;

- (void)startAnimations;

@end

NS_ASSUME_NONNULL_BEGIN

@protocol GTContainerViewControllerDelegate <NSObject>

- (nullable id <UIViewControllerInteractiveTransitioning>)containerViewController:(GTContainerViewController *)containerViewController
                                      interactionControllerForAnimationController:(id <UIViewControllerContextTransitioningExtension>)animationController NS_AVAILABLE_IOS(10_0);

- (nullable id <UIViewControllerAnimatedTransitioning>)containerViewController:(GTContainerViewController *)containerViewController
                                                            fromViewController:(UIViewController *)fromVC
                                                              toViewController:(UIViewController *)toVC  NS_AVAILABLE_IOS(10_0);


@end

@interface GTContainerViewController : UIViewController

@property (nonatomic, readonly, strong) NSArray *viewControllers;
//@property (nonatomic, assign) NSInteger selectedIndex;
@property (nonatomic, strong) UIViewController *selectedViewcontroller;

@property (nonatomic, weak) id<GTContainerViewControllerDelegate> delegate;

- (instancetype)initWithViewControllers:(NSArray<UIViewController *> *)viewControllers;

/**
 添加子控制器并显示

 @param viewController 子控制器
 */
- (void)gt_addChildViewController:(UIViewController *)viewController;

/**
 移除子控制器，如果移除的子控制器是当前显示的控制器，则显示栈顶的控制器视图

 @param viewController 子控制器
 */
- (void)gt_removeChildViewController:(UIViewController *)viewController;

@end

NS_ASSUME_NONNULL_END
