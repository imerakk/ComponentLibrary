//
//  GTUIKitTableViewController.m
//  ComponentLibrary
//
//  Created by liuchunxi on 2018/10/22.
//  Copyright © 2018年 imera. All rights reserved.
//

#import "GTUIKitTableViewController.h"
#import "GTCarouselViewController.h"
#import "GTCellModel.h"

@interface GTUIKitTableViewController ()

@property (nonatomic, strong) NSArray *dataSource;

@end

@implementation GTUIKitTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:NSStringFromClass([UITableViewCell class])];
    
    __weak typeof(self) weakSelf = self;
    GTCellModel *model1 = [GTCellModel modelFactoryWithTitle:@"CarouselView" didClickHander:^{
        GTCarouselViewController *vc = [GTCarouselViewController new];
        [weakSelf.navigationController pushViewController:vc animated:YES];
    }];
    
    self.dataSource = @[model1];
}

#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([UITableViewCell class]) forIndexPath:indexPath];
    GTCellModel *model = self.dataSource[indexPath.row];
    cell.textLabel.text = model.title;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    GTCellModel *model = self.dataSource[indexPath.row];
    model.didClickHander();
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 44;
}

@end
