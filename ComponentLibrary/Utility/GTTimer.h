//
//  GTTimer.h
//  ComponentLibrary
//
//  Created by liuchunxi on 2018/10/22.
//  Copyright © 2018年 imera. All rights reserved.
//

#import <Foundation/Foundation.h>

@class GTTimer;

typedef void(^Block)(GTTimer *timer);

NS_ASSUME_NONNULL_BEGIN

@interface GTTimer : NSObject

@property (nonatomic, readonly, getter=isValid, assign) BOOL valid;
@property (nonatomic, readonly, assign) BOOL repeats;
@property (nonatomic, readonly, assign) NSTimeInterval timerInterval;

+ (instancetype)timerWithTimerInterval:(NSTimeInterval)timerInterval
                                target:(id)target
                              selector:(SEL)selector
                               repeats:(BOOL)repeats;

+ (instancetype)timerWithTimerInterval:(NSTimeInterval)timerInterval
                               repeats:(BOOL)repeats
                                 block:(Block)block;
- (void)fire;
- (void)invalidate;

@end

NS_ASSUME_NONNULL_END
