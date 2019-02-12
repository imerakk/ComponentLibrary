//
//  GTCustomNavgationViewController.h
//  ComponentLibrary
//
//  Created by liuchunxi on 2018/11/20.
//  Copyright © 2018年 imera. All rights reserved.
//

#import "GTContainerViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface GTCustomNavgationViewController : GTContainerViewController

- (instancetype)initWithRootViewController:(UIViewController *)rootViewController;
- (void)pushViewController:(UIViewController *)viewController;
- (void)popViewController;

@end

NS_ASSUME_NONNULL_END
