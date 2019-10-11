# BKTimer（一款非常简单的定时器）

## 使用方法

```objc

/**
 初始化定时器

 @param timeInterval 时间间隔 (最多6位小数 即0.000001)
 @param totalTime 执行总时间 当 totalTime==kBKTimerRepeatsTime 时无限执行
 @param handler 回调
 @return 定时器
 */
+(dispatch_source_t)bk_setupTimerWithTimeInterval:(CGFloat)timeInterval totalTime:(CGFloat)totalTime handler:(void (^)(dispatch_source_t timer, CGFloat lastTime))handler;

/**
 删除定时器
 */
+(void)bk_removeTimer:(dispatch_source_t)timer;

```
