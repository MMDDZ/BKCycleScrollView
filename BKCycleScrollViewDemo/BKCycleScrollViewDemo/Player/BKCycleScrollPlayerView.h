//
//  BKCycleScrollPlayerView.h
//  DSCnliveShopSDK
//
//  Created by zhaolin on 2019/5/8.
//  Copyright © 2019 BIKE. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface BKCycleScrollPlayerView : UIView

#pragma mark - 进度条属性

/**
 全部进度颜色
 */
@property (nonatomic,strong) UIColor * totalColor;
/**
 缓冲进度颜色
 */
@property (nonatomic,strong) UIColor * bufferColor;
/**
 当前进度颜色
 */
@property (nonatomic,strong) UIColor * currentColor;

#pragma mark - 封面图

/**
 封面图
 */
@property (nonatomic,strong) UIImage * coverImage;

#pragma mark - 视频属性

/**
 播放的url
 */
@property (nonatomic,strong,nullable,readonly) NSURL * videoUrl;

/**
 播放

 @param url 视频url
 @param time 观看地点
 */
-(void)playVideoUrl:(NSURL*)url seekTime:(NSTimeInterval)time;
/**
 暂停
 */
-(void)pause;
/**
 结束播放
 */
-(void)stop;

#pragma mark - 回调

/**
 播放时间改变回调
 */
@property (nonatomic,copy) void (^playerPlayTimeChanged)(NSTimeInterval currentTime, NSTimeInterval duration);
/// 播放器暂停回调
@property (nonatomic,copy) void (^playerPausedCallBack)(void);
/// 播放器继续播放回调
@property (nonatomic,copy) void (^playerPlayingCallBack)(void);
/**
 播放完成回调
 */
@property (nonatomic,copy) void (^playerDidToEnd)(void);

@end

NS_ASSUME_NONNULL_END
