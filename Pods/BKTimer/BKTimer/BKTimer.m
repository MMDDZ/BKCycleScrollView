//
//  BKTimer.m
//  BKTimer
//
//  Created by zhaolin on 2019/10/11.
//  Copyright © 2019 BIKE. All rights reserved.
//

#import "BKTimer.h"

CGFloat const kBKTimerRepeatsTime = -999999;
CGFloat const kMinTimeInterval = 0.000001;

@implementation BKTimer

#pragma mark - 创建定时器方法

+(dispatch_source_t)bk_setupTimerWithTimeInterval:(CGFloat)timeInterval totalTime:(CGFloat)totalTime handler:(void (^)(dispatch_source_t timer, CGFloat lastTime))handler
{
    dispatch_source_t timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, dispatch_get_global_queue(0, 0));
    
    CGFloat temp_timeInterval = timeInterval;
    if (temp_timeInterval < kMinTimeInterval) {
        temp_timeInterval = kMinTimeInterval;
    }
    __block CGFloat lastTime = totalTime;
    
    dispatch_time_t start = dispatch_time(DISPATCH_TIME_NOW, temp_timeInterval * NSEC_PER_SEC);//延迟一个循环时间执行定时器
    dispatch_source_set_timer(timer, start, temp_timeInterval * NSEC_PER_SEC, 0 * NSEC_PER_SEC);
    dispatch_source_set_event_handler(timer, ^{
        if (!timer) {
            return;
        }
        
        if (totalTime != kBKTimerRepeatsTime) {
            lastTime = lastTime - temp_timeInterval;
            
            //保留6位小数 取出整数和小数
            NSString * lastTimeStr = [NSString stringWithFormat:@"%.6f",lastTime];
            NSArray * array = [lastTimeStr componentsSeparatedByString:@"."];
            //检测剩余时间是否为kMinTimeInterval 即0.000000
            BOOL flag = YES;
            NSString * integer = [array firstObject];
            if ([integer isEqualToString:@"0"]) {//判断整数是否为0
                NSString * decimal = [array lastObject];
                for (int i = 0; i < [decimal length]; i++) {
                    NSString * range_string = [decimal substringWithRange:NSMakeRange(i, 1)];
                    if (![range_string isEqualToString:@"0"]) {//判断小数所有位数是否为0
                        flag = NO;
                        break;
                    }
                }
            }else{
                flag = NO;
            }
            
            if (flag) {
                lastTime = 0;
                [self bk_removeTimer:timer];
            }else {
                if (lastTime <= 0) {
                    lastTime = 0;
                    [self bk_removeTimer:timer];
                }
            }
        }
        
        if (handler) {
            dispatch_async(dispatch_get_main_queue(), ^{
                handler(timer, lastTime);
            });
        }
    });
    dispatch_resume(timer);
    
    return timer;
}

#pragma mark - 销毁定时器方法

+(void)bk_removeTimer:(dispatch_source_t)timer
{
    if (!timer) {
        return;
    }
    
    dispatch_cancel(timer);
//    dispatch_source_cancel(timer);//在在创建多次，并且瞬间删除全部时有可能崩溃 所以用dispatch_cancel(timer)替代
    timer = nil;
}

@end
