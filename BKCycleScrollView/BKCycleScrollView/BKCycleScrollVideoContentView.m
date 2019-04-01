//
//  BKCycleScrollVideoContentView.m
//  BKCycleScrollView
//
//  Created by zhaolin on 2019/1/17.
//  Copyright © 2019年 BIKE. All rights reserved.
//

#import "BKCycleScrollVideoContentView.h"
#import "BKCycleScrollImageView.h"
#import "BKCycleScrollVideoProgressView.h"
#import "UIImageView+WebCache.h"
#import <ZFPlayer/ZFSpeedLoadingView.h>
#import <ZFPlayer/ZFPlayer.h>

@interface BKCycleScrollVideoContentView()

/**
 封面图
 */
@property (nonatomic,strong) BKCycleScrollImageView * coverImageView;
/**
 加载loading
 */
@property (nonatomic,strong) ZFSpeedLoadingView *activity;
/**
 进度条
 */
@property (nonatomic,strong) BKCycleScrollVideoProgressView * progressView;
/**
 播放失败提示
 */
@property (nonatomic,strong) UILabel * failureRemindLab;

@end

@implementation BKCycleScrollVideoContentView
@synthesize player = _player;

#pragma mark - 公开方法

/**
 数据
 */
-(void)setDataObj:(BKCycleScrollDataModel *)dataObj
{
    _dataObj = dataObj;
    
    [self reset];
    
    if ([dataObj.imageUrl length] > 0) {
        NSURL * imageUrl = [NSURL URLWithString:dataObj.imageUrl];
        [self.coverImageView sd_setImageWithURL:imageUrl];
    }else if (dataObj.image) {
        self.coverImageView.image = dataObj.image;
    }else if (dataObj.imageData) {
        FLAnimatedImage * image = [FLAnimatedImage animatedImageWithGIFData:dataObj.imageData];
        if (!image) {
            self.coverImageView.image = [UIImage imageWithData:dataObj.imageData];
        }else{
            self.coverImageView.animatedImage = image;
        }
    }
    
    [self.activity startAnimating];
}

-(void)setProgressColor:(UIColor *)progressColor
{
    _progressColor = progressColor;
    self.progressView.totalColor = _progressColor;
}

-(void)setBufferColor:(UIColor *)bufferColor
{
    _bufferColor = bufferColor;
    self.progressView.bufferColor = _bufferColor;
}

-(void)setCurrentColor:(UIColor *)currentColor
{
    _currentColor = currentColor;
    self.progressView.currentColor = _currentColor;
}

#pragma mark - 重置

/**
 重置
 */
-(void)reset
{
    self.coverImageView.image = nil;
    [self.activity stopAnimating];
    self.progressView.bufferValue = 0;
    self.progressView.value = 0;
}

#pragma mark - init

-(instancetype)init
{
    self = [super init];
    if (self) {
        [self initUI];
    }
    return self;
}

#pragma mark - layoutSubviews

-(void)layoutSubviews
{
    [super layoutSubviews];
    
    self.coverImageView.frame = self.bounds;
    self.activity.frame = self.bounds;
    self.progressView.frame = CGRectMake(0, self.frame.size.height - 2, self.frame.size.width, 2);
}

#pragma mark - initUI

-(void)initUI
{
    [self addSubview:self.coverImageView];
    [self addSubview:self.activity];
    [self addSubview:self.progressView];
}

#pragma mark - 封面图

-(BKCycleScrollImageView*)coverImageView
{
    if (!_coverImageView) {
        _coverImageView = [[BKCycleScrollImageView alloc] init];
        _coverImageView.clipsToBounds = YES;
        _coverImageView.contentMode = UIViewContentModeScaleAspectFill;
        _coverImageView.userInteractionEnabled = YES;
    }
    return _coverImageView;
}

#pragma mark - loading

-(ZFSpeedLoadingView *)activity {
    if (!_activity) {
        _activity = [[ZFSpeedLoadingView alloc] init];
    }
    return _activity;
}

#pragma mark - 进度条

-(BKCycleScrollVideoProgressView*)progressView
{
    if (!_progressView) {
        _progressView = [[BKCycleScrollVideoProgressView alloc] init];
    }
    return _progressView;
}

#pragma mark - 加载失败提示

-(UILabel*)failureRemindLab
{
    if (!_failureRemindLab) {
        _failureRemindLab = [[UILabel alloc] initWithFrame:self.bounds];
        _failureRemindLab.backgroundColor = [UIColor colorWithWhite:0 alpha:0.5];
        _failureRemindLab.textColor = [UIColor whiteColor];
        _failureRemindLab.textAlignment = NSTextAlignmentCenter;
        _failureRemindLab.font = [UIFont systemFontOfSize:14];
        _failureRemindLab.alpha = 0;
    }
    return _failureRemindLab;
}

#pragma mark - 播放器状态

/**
 准备播放
 */
-(void)videoPlayer:(ZFPlayerController *)videoPlayer prepareToPlay:(NSURL *)assetURL
{
    [self.activity startAnimating];
}

/**
 播放状态改变
 */
-(void)videoPlayer:(ZFPlayerController *)videoPlayer playStateChanged:(ZFPlayerPlaybackState)state
{
    if (state == ZFPlayerPlayStatePlaying) {
        if (videoPlayer.currentPlayerManager.loadState == ZFPlayerLoadStateStalled || videoPlayer.currentPlayerManager.loadState == ZFPlayerLoadStatePrepare) {
            [self.activity startAnimating];
        }
    }else if (state == ZFPlayerPlayStatePaused || state == ZFPlayerPlayStatePlayFailed) {
        [self.activity stopAnimating];
    }
}

/**
 加载状态改变
 */
-(void)videoPlayer:(ZFPlayerController *)videoPlayer loadStateChanged:(ZFPlayerLoadState)state
{
    if (state == ZFPlayerLoadStatePrepare) {
        self.coverImageView.alpha = 1;
    }else if (state == ZFPlayerLoadStatePlaythroughOK) {
        [UIView animateWithDuration:0.25 animations:^{
            self.coverImageView.alpha = 0;
        }];
    }
    if ((state == ZFPlayerLoadStateStalled || state == ZFPlayerLoadStatePrepare) && videoPlayer.currentPlayerManager.isPlaying) {
        [self.activity startAnimating];
    }else {
        //判断加载进度比播放进度快才停止loading，防止loading停止了视频还没有播放
        if (videoPlayer.currentTime < videoPlayer.bufferTime && videoPlayer.currentTime > 0 && videoPlayer.bufferTime > 0) {
            [self.activity stopAnimating];
        }
    }
}

/**
 播放结束
 */
-(void)videoPlayerPlayEnd:(ZFPlayerController *)videoPlayer
{
    [self.activity stopAnimating];
}

/**
 播放失败
 */
-(void)videoPlayerPlayFailed:(ZFPlayerController *)videoPlayer error:(id)error
{
    [self.activity stopAnimating];
    if ([error isKindOfClass:[NSError class]]) {
        NSError * e = (NSError*)error;
        if (e.code == -1009) {
            self.failureRemindLab.text = @"没有网络";
        }
    }else {
        self.failureRemindLab.text = @"播放失败";
    }
    [self addSubview:self.failureRemindLab];
    [UIView animateWithDuration:0.25 animations:^{
        self.failureRemindLab.alpha = 1;
    } completion:^(BOOL finished) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [UIView animateWithDuration:0.25 animations:^{
                self.failureRemindLab.alpha = 0;
            } completion:^(BOOL finished) {
                [videoPlayer stopCurrentPlayingCell];
            }];
        });
    }];
}

#pragma mark - 播放器进度

/**
 缓冲时间改变
 */
-(void)videoPlayer:(ZFPlayerController *)videoPlayer bufferTime:(NSTimeInterval)bufferTime
{
    [self.activity stopAnimating];
    self.progressView.bufferValue = videoPlayer.bufferProgress;
}

/**
 播放进度改变
 */
-(void)videoPlayer:(ZFPlayerController *)videoPlayer currentTime:(NSTimeInterval)currentTime totalTime:(NSTimeInterval)totalTime
{
    self.progressView.value = videoPlayer.progress;
}

/**
 拖拽修改进度
 */
-(void)videoPlayer:(ZFPlayerController *)videoPlayer draggingTime:(NSTimeInterval)seekTime totalTime:(NSTimeInterval)totalTime
{
    
}

#pragma mark - 手势代理

-(BOOL)gestureTriggerCondition:(ZFPlayerGestureControl *)gestureControl gestureType:(ZFPlayerGestureType)gestureType gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer touch:(UITouch *)touch
{
    //不响应任何手势
    return NO;
}



@end
