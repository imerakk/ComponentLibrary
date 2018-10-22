//
//  GTCellModel.h
//  ComponentLibrary
//
//  Created by liuchunxi on 2018/10/22.
//  Copyright © 2018年 imera. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^DidClickHandler)(void);

NS_ASSUME_NONNULL_BEGIN

@interface GTCellModel : NSObject

@property (nonatomic, strong) NSString *title;
@property (nonatomic, copy) DidClickHandler didClickHander;

+ (instancetype)modelFactoryWithTitle:(NSString *)title didClickHander:(DidClickHandler)didClickHander;

@end

NS_ASSUME_NONNULL_END
