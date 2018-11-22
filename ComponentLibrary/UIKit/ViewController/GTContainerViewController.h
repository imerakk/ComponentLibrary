//
//  GTContainerViewController.h
//  ComponentLibrary
//
//  Created by liuchunxi on 2018/11/13.
//  Copyright © 2018年 imera. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GTTransitionViewControllerProtocol.h"

NS_ASSUME_NONNULL_BEGIN

@interface GTViewControllerContextTransitioning : NSObject <GTViewControllerContextTransitioning>

@property(nonatomic, readonly) UIView *containerView;
@property (nonatomic, strong) id<GTViewControllerAnimatedTransitioning> animator;

@property(nonatomic, readonly, getter=isAnimated) BOOL animated;
@property(nonatomic, readonly, getter=isInteractive) BOOL interactive; // This indicates whether the transition is currently interactive.
@property(nonatomic, readonly) BOOL transitionWasCancelled;
@property(nonatomic, readonly) UIModalPresentationStyle presentationStyle;
@property(nonatomic, readonly) CGAffineTransform targetTransform;
@property (nonatomic, copy) void (^compeletionBlock)(BOOL compeletion);

- (instancetype)initWithFromViewController:(UIViewController *)fromViewController toViewController:(UIViewController *)toViewController;

@end

////////////////////////////////////////////////////////////////////////////////////////
@interface GTContainerViewController : UIViewController

@property (nonatomic, readonly, strong) NSArray *viewControllers;

@property (nonatomic, strong) UIViewController *selectedViewcontroller;

@property (nonatomic, weak) id<GTContainerViewControllerDelegate> delegate;

- (instancetype)initWithViewControllers:(NSArray<UIViewController *> *)viewControllers;

/**
 添加子控制器并显示

 @param viewController 子控制器
 */
- (void)gt_addChildViewController:(UIViewController *)viewController;

/**
 移除子控制器，禁止移除正在显示的子控制器

 @param viewController 子控制器
 */
- (void)gt_removeChildViewController:(UIViewController *)viewController;

@end

NS_ASSUME_NONNULL_END
