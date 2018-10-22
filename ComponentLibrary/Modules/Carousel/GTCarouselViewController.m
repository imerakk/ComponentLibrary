//
//  GTCarouselViewController.m
//  ComponentLibrary
//
//  Created by liuchunxi on 2018/10/22.
//  Copyright © 2018年 imera. All rights reserved.
//

#import "GTCarouselViewController.h"
#import "GTCarouselView.h"
#import "GTCarouselCollectionViewCell.h"

@interface GTCarouselViewController () <GTCarouselViewDataSource, GTCarouselViewDelegate>

@property (nonatomic, strong) NSArray *data;

@end

@implementation GTCarouselViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.data = @[@"h1", @"h2", @"h3", @"h4"];
    
    GTCarouselView *carouselView = [[GTCarouselView alloc] init];
    carouselView.datasource = self;
    carouselView.delegate = self;
    carouselView.itemWidth = SCREEN_WIDTH - 40;
    carouselView.itemSpacing = 10;
    carouselView.frame = CGRectMake(0, 150, self.view.width, 200);
    [carouselView refreshView];
    [carouselView registerCellClass:[GTCarouselCollectionViewCell class] forReuseIdentifier:NSStringFromClass([GTCarouselCollectionViewCell class])];
    [self.view addSubview:carouselView];
}

#pragma mark - GTCarouselViewDataSource
- (NSInteger)numberOfItemsInCarouselView:(GTCarouselView *)carouseView {
    return self.data.count;
}

- (UICollectionViewCell *)carouselView:(GTCarouselView *)carouseView cellForRowAtIndex:(NSInteger)index {
    GTCarouselCollectionViewCell *cell = [carouseView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([GTCarouselCollectionViewCell class]) forIndex:index];
    NSString *imageName = self.data[index];
    cell.image = [UIImage imageNamed:imageName];
    cell.cornerRadius = 10;
    return cell;
}

#pragma mark - GTCarouselViewDelegate
- (void)carouselView:(GTCarouselView *)carouseView didSelectedItemAtIndex:(NSInteger)index {
    NSLog(@"didSelectedItemAtIndex:%ld", index);
}

@end
