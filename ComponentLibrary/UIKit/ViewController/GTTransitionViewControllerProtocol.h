//
//  GTTransitionViewControllerProtocol.h
//  ComponentLibrary
//
//  Created by liuchunxi on 2018/11/21.
//  Copyright © 2018年 imera. All rights reserved.
//

#ifndef GTTransitionViewControllerProtocol_h
#define GTTransitionViewControllerProtocol_h

@protocol GTViewControllerContextTransitioning <NSObject>

@property(nonatomic, readonly) UIView *containerView;
@property(nonatomic, readonly, getter=isAnimated) BOOL animated;
@property(nonatomic, readonly, getter=isInteractive) BOOL interactive;
@property(nonatomic, readonly) BOOL transitionWasCancelled;
@property(nonatomic, readonly) UIModalPresentationStyle presentationStyle;

- (void)updateInteractiveTransition:(CGFloat)percentComplete;
- (void)finishInteractiveTransition;
- (void)cancelInteractiveTransition;

- (void)pauseInteractiveTransition NS_AVAILABLE_IOS(10_0);
- (void)completeTransition:(BOOL)didComplete;

- (nullable __kindof UIViewController *)viewControllerForKey:(UITransitionContextViewControllerKey)key;
- (nullable __kindof UIView *)viewForKey:(UITransitionContextViewKey)key;

- (CGRect)initialFrameForViewController:(UIViewController *)vc;
- (CGRect)finalFrameForViewController:(UIViewController *)vc;

- (void)addAnimation:(void (^)(void))animation
            duration:(NSTimeInterval)duration
      animationCurve:(UIViewAnimationCurve)animationCurve
         compeletion:(void (^)(void))compeletion;

- (void)startAnimations;

@end

@protocol GTViewControllerAnimatedTransitioning <NSObject>

- (NSTimeInterval)transitionDuration:(nullable id <GTViewControllerContextTransitioning>)transitionContext;
- (void)animateTransition:(id <GTViewControllerContextTransitioning>)transitionContext;

@end




#endif /* GTTransitionViewControllerProtocol_h */
