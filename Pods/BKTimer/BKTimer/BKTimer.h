//
//  BKTimer.h
//  BKTimer
//
//  Created by zhaolin on 2019/10/11.
//  Copyright © 2019 BIKE. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

FOUNDATION_EXPORT double BKTimerVersionNumber;
FOUNDATION_EXPORT const unsigned char BKTimerVersionString[];

//坑点 最初使用FLT_MIN为永远执行时间判断 后来发现bug 即FLT_MIN==0而不是float的最小值
UIKIT_EXTERN const CGFloat kBKTimerRepeatsTime;//永远执行时间

NS_ASSUME_NONNULL_BEGIN

@interface BKTimer : NSObject

#pragma mark - 创建定时器方法

/**
 初始化定时器

 @param timeInterval 时间间隔 (最多6位小数 即0.000001)
 @param totalTime 执行总时间 当 totalTime==kBKTimerRepeatsTime 时无限执行
 @param handler 回调
 @return 定时器
 */
+(dispatch_source_t)bk_setupTimerWithTimeInterval:(CGFloat)timeInterval totalTime:(CGFloat)totalTime handler:(void (^)(dispatch_source_t timer, CGFloat lastTime))handler;

#pragma mark - 销毁定时器方法

/**
 删除定时器
 */
+(void)bk_removeTimer:(dispatch_source_t)timer;

@end

NS_ASSUME_NONNULL_END
