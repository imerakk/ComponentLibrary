//
//  GTContainerViewController.m
//  ComponentLibrary
//
//  Created by liuchunxi on 2018/11/13.
//  Copyright © 2018年 imera. All rights reserved.
//

#import "GTContainerViewController.h"

@interface GTViewControllerContextTransitioning : NSObject <GTViewControllerContextTransitioning>

@property(nonatomic, readonly) UIView *containerView;

@property(nonatomic, readonly, getter=isAnimated) BOOL animated;
@property(nonatomic, readonly, getter=isInteractive) BOOL interactive; // This indicates whether the transition is currently interactive.
@property(nonatomic, readonly) BOOL transitionWasCancelled;
@property(nonatomic, readonly) UIModalPresentationStyle presentationStyle;
@property(nonatomic, readonly) CGAffineTransform targetTransform;
@property (nonatomic, copy) void (^compeletionBlock)(BOOL compeletion);

- (instancetype)initWithFromViewController:(UIViewController *)fromViewController toViewController:(UIViewController *)toViewController;

@end

////////////////////////////////////////////////////////////////////////////////////////
@interface GTContainerViewController ()

@property (nonatomic, strong) NSMutableArray *mutViewControllers;
@property (nonatomic, strong) UIViewController *needRemovedViewController;

@property (nonatomic, strong) UIViewController *fromViewController;
@property (nonatomic, strong) UIViewController *toViewController;
@property (nonatomic, strong) id<GTViewControllerContextTransitioning> transitionContext;

@end

@implementation GTContainerViewController

@synthesize viewControllers;

- (instancetype)initWithViewControllers:(NSArray<UIViewController *> *)viewControllers {
    self = [super init];
    if (self) {
        _mutViewControllers = [viewControllers mutableCopy];
    }
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    [self transitionToChildViewController:self.selectedViewcontroller ?: self.mutViewControllers[0]];
}

#pragma mark - getter && setter
- (NSArray *)viewControllers {
    return [_mutViewControllers copy];
}

- (void)setViewControllers:(NSArray * _Nonnull)viewControllers {
    [_mutViewControllers addObject:viewControllers];
}

- (void)gt_addChildViewController:(UIViewController *)viewController {
    [_mutViewControllers addObject:viewController];
}

- (void)gt_removeChildViewController:(UIViewController *)viewController {
    if (![self.mutViewControllers containsObject:viewController] || self.mutViewControllers.count == 1) {
        return;
    }
    
    //正在做转场动画
    if (self.fromViewController || self.toViewController) {
        if (viewController == self.toViewController) {
            return;
        }
        
        if (viewController == self.fromViewController) {
            self.needRemovedViewController = viewController;
        }
        else {
            [_mutViewControllers removeObject:viewController];
        }
    }
    else {
        if (viewController == self.selectedViewcontroller) {
            return;
        }
        
        [_mutViewControllers removeObject:viewController];
    }
}

- (void)setSelectedViewcontroller:(UIViewController *)selectedViewcontroller {
    if (![self.mutViewControllers containsObject:selectedViewcontroller]) {
        return;
    }
    
    [self transitionToChildViewController:selectedViewcontroller];
}

#pragma mark - private method
- (void)transitionToChildViewController:(UIViewController *)toViewController {
    toViewController.view.frame = self.view.bounds;
    
    UIViewController *fromViewController = self.childViewControllers.count > 0 ? self.childViewControllers[0] : nil;
    if (!fromViewController) {
        _selectedViewcontroller = toViewController;
        [self addChildViewController:toViewController];
        [toViewController didMoveToParentViewController:self];
        [self.view addSubview:toViewController.view];
        
        return;
    }
    
    [fromViewController willMoveToParentViewController:nil];
    
    id<GTViewControllerAnimatedTransitioning> animator = nil;
    if ([self.delegate respondsToSelector:@selector(containerViewController:fromViewController:toViewController:)]) {
        animator = [self.delegate containerViewController:self fromViewController:fromViewController toViewController:toViewController];
    }
    
    if (animator) {
        GTViewControllerContextTransitioning *contextTransitioning = [[GTViewControllerContextTransitioning alloc] initWithFromViewController:fromViewController toViewController:toViewController];
        __weak typeof(self) weakSelf = self;
        contextTransitioning.compeletionBlock = ^ (BOOL compeletion){
            if (compeletion) {
                if (weakSelf) {
                    __strong typeof(self) strongSelf = weakSelf;
                    strongSelf->_selectedViewcontroller = toViewController;
                }
                
                [fromViewController removeFromParentViewController];
                [fromViewController.view removeFromSuperview];
                [weakSelf addChildViewController:toViewController];
                [toViewController didMoveToParentViewController:weakSelf];
                
                if (weakSelf.needRemovedViewController) {
                    [weakSelf.mutViewControllers removeObject:weakSelf.needRemovedViewController];
                }
            }
            
            self.fromViewController = nil;
            self.toViewController = nil;
        };
        
        self.fromViewController = fromViewController;
        self.toViewController = toViewController;
        self.transitionContext = contextTransitioning;
        [animator animateTransition:contextTransitioning];
    }
    else {
        _selectedViewcontroller = toViewController;
        
        [fromViewController removeFromParentViewController];
        [fromViewController.view removeFromSuperview];
        [self addChildViewController:toViewController];
        [toViewController didMoveToParentViewController:self];
        [self.view addSubview:toViewController.view];
        
        if (self.needRemovedViewController) {
            [self.mutViewControllers removeObject:self.needRemovedViewController];
        }
    }

}

@end

////////////////////////////////////////////////////////////////////////////////////////
@interface GTViewControllerContextTransitioning ()

@property (nonatomic, strong) UIViewController *containerViewController;
@property (nonatomic, strong) NSDictionary *viewControllers;
@property (nonatomic, strong) NSMutableArray *animators;

@end

@implementation GTViewControllerContextTransitioning

- (instancetype)initWithFromViewController:(UIViewController *)fromViewController toViewController:(UIViewController *)toViewController {
    self = [super init];
    if (self) {
        _presentationStyle = UIModalPresentationCustom;
        _viewControllers = @{
                             UITransitionContextFromViewControllerKey: fromViewController,
                             UITransitionContextToViewControllerKey: toViewController
                             };
        _containerViewController = fromViewController.parentViewController;
        _containerView = _containerViewController.view;
        _animators = [NSMutableArray array];
        _transitionWasCancelled = NO;
    }
    
    return self;
}

- (UIViewController *)viewControllerForKey:(UITransitionContextViewControllerKey)key {
    return _viewControllers[key];
}

- (UIView *)viewForKey:(UITransitionContextViewKey)key {
    NSDictionary *map = @{
                          UITransitionContextFromViewKey: UITransitionContextFromViewControllerKey,
                          UITransitionContextToViewKey: UITransitionContextToViewControllerKey
                          };
    NSString *vcKey = map[key];
    UIViewController *viewController = _viewControllers[vcKey];
    return viewController.view;
}

- (CGRect)initialFrameForViewController:(UIViewController *)vc {
    if (vc == _viewControllers[UITransitionContextFromViewControllerKey]) {
        return vc.view.frame;
    }
    else {
        return CGRectZero;
    }
}

- (CGRect)finalFrameForViewController:(UIViewController *)vc {
    if (vc == _viewControllers[UITransitionContextFromViewControllerKey]) {
        return CGRectZero;
    }
    else {
        return vc.view.frame;
    }
}

- (void)addAnimation:(void (^)(void))animation
            duration:(NSTimeInterval)duration
      animationCurve:(UIViewAnimationCurve)animationCurve
         compeletion:(void (^)(id<GTViewControllerContextTransitioning> transitioningContext))compeletion {
    UIViewPropertyAnimator *animator = [[UIViewPropertyAnimator alloc] initWithDuration:duration curve:animationCurve animations:animation];
    [animator addCompletion:^(UIViewAnimatingPosition finalPosition) {
        if (compeletion) {
            compeletion(self);
        }
    }];
    [_animators addObject:animator];
}

- (void)startAnimations {
    for (UIViewPropertyAnimator *animator in _animators) {
        [animator startAnimation];
    }
}

- (void)updateInteractiveTransition:(CGFloat)percentComplete {
    for (UIViewPropertyAnimator *animator in _animators) {
        animator.fractionComplete = percentComplete;
    }
}

- (void)finishInteractiveTransition {
    for (UIViewPropertyAnimator *animator in _animators) {
        [animator continueAnimationWithTimingParameters:nil durationFactor:1 - animator.fractionComplete];
    }
}

- (void)cancelInteractiveTransition {
    for (UIViewPropertyAnimator *animator in _animators) {
        animator.reversed = YES;
        [animator continueAnimationWithTimingParameters:nil durationFactor:1 - animator.fractionComplete];
    }
    
    _transitionWasCancelled = YES;
}

- (void)pauseInteractiveTransition {
    for (UIViewPropertyAnimator *animator in _animators) {
        [animator pauseAnimation];
    }
}

- (void)completeTransition:(BOOL)didComplete {
    if (self.compeletionBlock) {
        self.compeletionBlock(didComplete);
    }
}

@end


