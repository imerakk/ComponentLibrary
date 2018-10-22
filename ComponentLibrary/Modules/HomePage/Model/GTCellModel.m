//
//  GTCellModel.m
//  ComponentLibrary
//
//  Created by liuchunxi on 2018/10/22.
//  Copyright © 2018年 imera. All rights reserved.
//

#import "GTCellModel.h"

@implementation GTCellModel

+ (instancetype)modelFactoryWithTitle:(NSString *)title didClickHander:(DidClickHandler)didClickHander {
    GTCellModel *model = [GTCellModel new];
    model.title = title;
    model.didClickHander = didClickHander;
    return model;
}

@end
