//
//  GTSecondViewController.m
//  ComponentLibrary
//
//  Created by liuchunxi on 2018/11/21.
//  Copyright © 2018年 imera. All rights reserved.
//

#import "GTSecondViewController.h"

@interface GTSecondViewController ()

@end

@implementation GTSecondViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor blueColor];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [button setTitle:@"previous" forState:UIControlStateNormal];
    [button addTarget:self action:@selector(previous) forControlEvents:UIControlEventTouchUpInside];
    button.frame = CGRectMake(100, 200, 150, 70);
    [self.view addSubview:button];
}

- (void)previous {
    [self.nav popViewController];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
