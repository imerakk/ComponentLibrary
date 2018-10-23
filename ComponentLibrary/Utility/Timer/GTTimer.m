//
//  GTTimer.m
//  ComponentLibrary
//
//  Created by liuchunxi on 2018/10/22.
//  Copyright © 2018年 imera. All rights reserved.
//

#import "GTTimer.h"

@interface GTTimer ()

@property (nonatomic, readwrite, getter=isValid, assign) BOOL valid;
@property (nonatomic, readwrite, assign) BOOL repeats;
@property (nonatomic, readwrite, assign) NSTimeInterval timerInterval;
@property (nonatomic, weak) id target;
@property (nonatomic, copy) Block block;
@property (nonatomic, assign) SEL selector;
@property (nonatomic, strong) dispatch_source_t timer;

@end

@implementation GTTimer

+ (instancetype)timerWithTimerInterval:(NSTimeInterval)timerInterval target:(id)target selector:(SEL)selector repeats:(BOOL)repeats {
    return [[GTTimer alloc] initWithTimerInterval:timerInterval target:target selector:selector block:nil delay:timerInterval repeats:repeats];
}

+ (instancetype)timerWithTimerInterval:(NSTimeInterval)timerInterval block:(Block)block repeats:(BOOL)repeats {
    return [[GTTimer alloc] initWithTimerInterval:timerInterval target:nil selector:NULL block:block delay:timerInterval repeats:YES];
}

- (instancetype)initWithTimerInterval:(NSTimeInterval)timerInterval target:(id)target selector:(SEL)selector block:(Block)block delay:(NSTimeInterval)delay repeats:(BOOL)repeats {
    self = [super init];
    if (self) {
        _valid = YES;
        _repeats = repeats;
        _timerInterval = timerInterval;
        _target = target;
        _selector = selector;
        _block = block;
        
        _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, dispatch_get_main_queue());
        dispatch_source_set_timer(_timer, dispatch_time(DISPATCH_TIME_NOW, delay * NSEC_PER_SEC), timerInterval * NSEC_PER_SEC, 0);
        __weak typeof(self) weakSelf = self;
        dispatch_source_set_event_handler(_timer, ^{[weakSelf fire];});
        dispatch_resume(_timer);
    }
    
    return self;
}

- (void)fire {
    if(!self.isValid) return;
    
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
    if (self.target && [self.target respondsToSelector:self.selector]) {
        [self.target performSelector:self.selector withObject:self];
    }
#pragma clang diagnostic pop
    if (self.block) {
        self.block(self);
    }
    
    if (!self.target && !self.block) {
        [self invalidate];
    }
    
    if (!self.repeats) {
        [self invalidate];
    }
}

- (void)invalidate {
    dispatch_source_cancel(_timer);
    self.timer = NULL;
    self.target = nil;
    self.block = nil;
    self.valid = NO;
}

@end
