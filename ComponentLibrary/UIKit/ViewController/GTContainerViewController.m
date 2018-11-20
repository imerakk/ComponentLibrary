//
//  GTContainerViewController.m
//  ComponentLibrary
//
//  Created by liuchunxi on 2018/11/13.
//  Copyright © 2018年 imera. All rights reserved.
//

#import "GTContainerViewController.h"

@interface GTViewControllerContextTransitioning : NSObject <UIViewControllerContextTransitioningExtension>

@property(nonatomic, readonly) UIView *containerView;

@property(nonatomic, readonly, getter=isAnimated) BOOL animated;
@property(nonatomic, readonly, getter=isInteractive) BOOL interactive; // This indicates whether the transition is currently interactive.
@property(nonatomic, readonly) BOOL transitionWasCancelled;
@property(nonatomic, readonly) UIModalPresentationStyle presentationStyle;
@property(nonatomic, readonly) CGAffineTransform targetTransform;
@property (nonatomic, copy) void (^compeletionBlock)(void);

- (instancetype)initWithFromViewController:(UIViewController *)fromViewController toViewController:(UIViewController *)toViewController;

@end

////////////////////////////////////////////////////////////////////////////////////////
@interface GTContainerViewController ()

@property (nonatomic, strong) NSMutableArray *mutViewControllers;

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
    NSAssert(![self.mutViewControllers containsObject:viewController], @"controller not add to containerViewController");
    NSAssert(self.mutViewControllers.count == 1, @"can't remove last child view controller");

    if (self.selectedViewcontroller == viewController) {
        NSInteger selectedIndex = [self.mutViewControllers indexOfObject:self.selectedViewcontroller];
        if (selectedIndex > 0) {
            self.selectedViewcontroller = self.mutViewControllers[selectedIndex - 1];
        }
        else {
            self.selectedViewcontroller = self.mutViewControllers[selectedIndex + 1];
        }
    }

    [_mutViewControllers removeObject:viewController];
}

- (void)setSelectedViewcontroller:(UIViewController *)selectedViewcontroller {
    NSAssert(![self.mutViewControllers containsObject:selectedViewcontroller], @"selectedViewcontroller must add to containerViewController");
    
    [self transitionToChildViewController:selectedViewcontroller];
}

#pragma mark - private method
- (void)transitionToChildViewController:(UIViewController *)toViewController {
    UIViewController *fromViewController = self.childViewControllers.count > 0 ? self.childViewControllers[0] : nil;
    if (!fromViewController) {
        [self addChildViewController:toViewController];
        [toViewController didMoveToParentViewController:self];
        toViewController.view.frame = self.view.bounds;
        [self.view addSubview:toViewController.view];
        
        return;
    }
    
    [fromViewController willMoveToParentViewController:nil];
    
    id<UIViewControllerAnimatedTransitioning> animator = nil;
    if ([self.delegate respondsToSelector:@selector(containerViewController:fromViewController:toViewController:)]) {
        animator = [self.delegate containerViewController:self fromViewController:fromViewController toViewController:toViewController];
    }
    
    GTViewControllerContextTransitioning *contextTransitioning = [[GTViewControllerContextTransitioning alloc] initWithFromViewController:fromViewController toViewController:toViewController];
    contextTransitioning.compeletionBlock = ^{
        [fromViewController removeFromParentViewController];
        [fromViewController.view removeFromSuperview];
        [self addChildViewController:toViewController];
        [toViewController didMoveToParentViewController:self];
    };
    
    [animator animateTransition:contextTransitioning];
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

- (CGAffineTransform)targetTransform {
    return CGAffineTransformIdentity;
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
         compeletion:(void (^)(void))compeletion {
    UIViewPropertyAnimator *animator = [[UIViewPropertyAnimator alloc] initWithDuration:duration curve:animationCurve animations:animation];
    [animator addCompletion:^(UIViewAnimatingPosition finalPosition) {
        if (compeletion) {
            compeletion();
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
    if (didComplete && self.compeletionBlock) {
        self.compeletionBlock();
    }
}

@end


