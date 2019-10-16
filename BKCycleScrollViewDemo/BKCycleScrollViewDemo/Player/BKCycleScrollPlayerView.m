//
//  BKCycleScrollPlayerView.m
//  DSCnliveShopSDK
//
//  Created by zhaolin on 2019/5/8.
//  Copyright © 2019 BIKE. All rights reserved.
//

#import "BKCycleScrollPlayerView.h"
#import <PLPlayerKit/PLPlayerKit.h>
#import "BKCycleScrollPlayerProgressView.h"
#import "BKCycleScrollPlayerLoadingView.h"
#import "BKCycleScrollPlayerFailureView.h"
#import <BKTimer/BKTimer.h>

@interface BKCycleScrollPlayerView()<PLPlayerDelegate>

@property (nonatomic,assign) NSTimeInterval playSeekTime;//播放指定位置

@property (nonatomic,weak) dispatch_source_t timer;//定时器
@property (nonatomic,strong) PLPlayer * player;//播放器
@property (nonatomic,strong) UIImageView * coverImageView;//封面图
@property (nonatomic,strong) UIButton * circlePlayBtn;//中间圆形播放暂停按钮
@property (nonatomic,strong) BKCycleScrollPlayerProgressView * progressView;//进度条
@property (nonatomic,strong) BKCycleScrollPlayerLoadingView * loadingView;//加载框
@property (nonatomic,strong) BKCycleScrollPlayerFailureView * failureView;//失败界面

@end

@implementation BKCycleScrollPlayerView
@synthesize videoUrl = _videoUrl;

#pragma mark - 进度条属性

-(void)setTotalColor:(UIColor *)totalColor
{
    _totalColor = totalColor;
    self.progressView.totalColor = _totalColor;
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

#pragma mark - 封面图

-(void)setCoverImage:(UIImage *)coverImage
{
    _coverImage = coverImage;
    self.coverImageView.image = coverImage;
    self.coverImageView.hidden = NO;
}

#pragma mark - 公开方法

-(void)setVideoUrl:(NSURL * _Nullable)videoUrl
{
    _videoUrl = videoUrl;
}

-(NSURL*)videoUrl
{
    return _videoUrl;
}

/**
 初始化视频 并自动播放
 */
-(void)playVideoUrl:(NSURL*)url seekTime:(NSTimeInterval)time
{
    if (![_videoUrl.absoluteString isEqualToString:url.absoluteString]) {
        [self stop];
        
         _videoUrl = url;
        
        PLPlayerOption * option = [PLPlayerOption defaultOption];
        PLPlayFormat format = kPLPLAY_FORMAT_UnKnown;
        NSString * urlString = _videoUrl.absoluteString.lowercaseString;
        if ([urlString hasSuffix:@".mp4"]) {
            format = kPLPLAY_FORMAT_MP4;
        }else if ([urlString hasPrefix:@"rtmp:"]) {
            format = kPLPLAY_FORMAT_FLV;
        }else if ([urlString hasSuffix:@".mp3"]) {
            format = kPLPLAY_FORMAT_MP3;
        }else if ([urlString hasSuffix:@".m3u8"]) {
            format = kPLPLAY_FORMAT_M3U8;
        }else if ([urlString hasSuffix:@".aac"]) {
            format = kPLPLAY_FORMAT_AAC;
        }
        [option setOptionValue:@(format) forKey:PLPlayerOptionKeyVideoPreferFormat];
        [option setOptionValue:@(kPLLogNone) forKey:PLPlayerOptionKeyLogLevel];
        
        self.player = [PLPlayer playerWithURL:_videoUrl option:option];
        self.player.delegateQueue = dispatch_get_main_queue();
        self.player.delegate = self;
        self.player.loopPlay = NO;
        self.player.rotationMode = PLPlayerNoRotation;
//        self.player.playerView.contentMode = UIViewContentModeScaleAspectFit;
        self.player.playerView.backgroundColor = [UIColor blackColor];
        self.player.playerView.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
        [self insertSubview:self.player.playerView atIndex:0];
    }
    _playSeekTime = time;
    
    self.hidden = NO;
    [self registerNotification];
    [self initTimer];
    [self continuePlay];
}

/**
 结束播放
 */
-(void)stop
{
    if (self.player.playerView.superview) {
        [self.player.playerView removeFromSuperview];
    }
    [self.player stop];
    [self stopPlayerAndResetProperty];
}

#pragma mark - 继续播放

-(void)continuePlay
{
    if (self.player.status == PLPlayerStatusPlaying) {
        return;
    }
    
    self.failureView.hidden = YES;
    if (self.player.status == PLPlayerStatusPaused || self.player.status == PLPlayerStatusCompleted) {
        [self.player resume];
    }else {
        [self.player play];
    }
}

#pragma mark - 暂停

-(void)pause
{
    [self.player pause];
}

#pragma mark - 结束播放重置

-(void)stopPlayerAndResetProperty
{
    self.videoUrl = nil;
    self.playSeekTime = 0;
    self.coverImageView.image = nil;
    self.coverImageView.hidden = YES;
    self.progressView.bufferValue = 0;
    self.progressView.value = 0;
    [self.loadingView stopAnimate];
    [self removeNotification];
    [self invalidateTimer];
    self.hidden = YES;
}

#pragma mark - init

-(instancetype)init
{
    self = [super init];
    if (self) {
        self.backgroundColor = [UIColor blackColor];
        [self initUI];
    }
    return self;
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    
    self.player.playerView.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
    self.coverImageView.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
    self.circlePlayBtn.frame = CGRectMake((self.frame.size.width - 44)/2, (self.frame.size.height - 44)/2, 44, 44);
    self.progressView.frame = CGRectMake(0, self.frame.size.height - 2, self.frame.size.width, 2);
    self.loadingView.frame = CGRectMake((self.frame.size.width - 50)/2, (self.frame.size.height - 50)/2, 50, 50);
    self.failureView.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
}

-(void)dealloc
{
    [self removeNotification];
}

#pragma mark - initUI

-(void)initUI
{
    [self addSubview:self.coverImageView];
    [self addSubview:self.circlePlayBtn];
    [self addSubview:self.progressView];
    [self addSubview:self.loadingView];
    [self addSubview:self.failureView];
    
    UITapGestureRecognizer * gestureViewDoubleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(gestureViewDoubleTap:)];
    gestureViewDoubleTap.numberOfTapsRequired = 2;
    [self addGestureRecognizer:gestureViewDoubleTap];
}

#pragma mark - 封面图

-(UIImageView*)coverImageView
{
    if (!_coverImageView) {
        _coverImageView = [[UIImageView alloc] initWithFrame:self.bounds];
        _coverImageView.clipsToBounds = YES;
        _coverImageView.contentMode = UIViewContentModeScaleAspectFit;
    }
    return _coverImageView;
}

#pragma mark - 中间圆形播放暂停按钮

-(UIButton*)circlePlayBtn
{
    if (!_circlePlayBtn) {
        _circlePlayBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_circlePlayBtn setBackgroundImage:[UIImage imageNamed:@"BK_start"] forState:UIControlStateNormal];
        _circlePlayBtn.hidden = YES;
        [_circlePlayBtn addTarget:self action:@selector(playBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _circlePlayBtn;
}

#pragma mark - 底部进度条

-(BKCycleScrollPlayerProgressView *)progressView
{
    if (!_progressView) {
        _progressView = [[BKCycleScrollPlayerProgressView alloc] init];
    }
    return _progressView;
}

#pragma mark - 加载框

-(BKCycleScrollPlayerLoadingView*)loadingView
{
    if (!_loadingView) {
        _loadingView = [[BKCycleScrollPlayerLoadingView alloc] init];
    }
    return _loadingView;
}

#pragma mark - 失败界面

-(BKCycleScrollPlayerFailureView*)failureView
{
    if (!_failureView) {
        _failureView = [[BKCycleScrollPlayerFailureView alloc] init];
        _failureView.hidden = YES;
        __weak typeof(self) weakSelf = self;
        [_failureView setClickRefreshCallBack:^{
            [weakSelf continuePlay];
        }];
    }
    return _failureView;
}

#pragma mark - 触发事件

-(void)gestureViewDoubleTap:(UITapGestureRecognizer*)recognizer
{
    if (self.loadingView.isLoading) {
        return;
    }
    
    if (self.videoUrl) {
        if (self.player.isPlaying) {
            [self pause];
        }else {
            [self continuePlay];
        }
    }
}

-(void)playBtnClick:(UIButton*)button
{
    if (self.videoUrl && !self.player.isPlaying) {
        [self continuePlay];
    }
}

#pragma mark - PLPlayerDelegate

/**
 告知代理对象播放器状态变更
 */
-(void)player:(nonnull PLPlayer *)player statusDidChange:(PLPlayerStatus)state
{
    dispatch_async(dispatch_get_main_queue(), ^{
        switch (state) {
            case PLPlayerStatusUnknow:
            case PLPlayerStatusOpen:
            {
                [self.loadingView stopAnimate];
            }
                break;
            case PLPlayerStatusPreparing:
            {
                [self.loadingView startAnimate];
                self.coverImageView.hidden = NO;
                self.circlePlayBtn.hidden = YES;
            }
                break;
            case PLPlayerStatusReady:
            {
                [self.loadingView startAnimate];
                self.circlePlayBtn.hidden = YES;
                if (self.playSeekTime > 0) {
                    [self.player seekTo:CMTimeMake(self.playSeekTime * 30, 30)];
                    self.playSeekTime = 0;
                }
            }
                break;
            case PLPlayerStatusCaching:
            {
                [self.loadingView startAnimate];
            }
                break;
            case PLPlayerStatusPlaying:
            {
                [self.loadingView stopAnimate];
                self.coverImageView.hidden = YES;
                self.circlePlayBtn.hidden = YES;
                if (self.playerPlayingCallBack) {
                    self.playerPlayingCallBack();
                }
            }
                break;
            case PLPlayerStatusPaused:
            {
                [self.loadingView stopAnimate];
                self.circlePlayBtn.hidden = NO;
                if (self.playerPausedCallBack) {
                    self.playerPausedCallBack();
                }
            }
                break;
            case PLPlayerStatusStopped:
            {
                [self.loadingView stopAnimate];
            }
                break;
            case PLPlayerStatusError:
            {
                [self.loadingView stopAnimate];
            }
                break;
            case PLPlayerStateAutoReconnecting:
            {
                [self.loadingView startAnimate];
            }
                break;
            case PLPlayerStatusCompleted:
            {
                [self.loadingView stopAnimate];
                [self removeNotification];
                [self invalidateTimer];
                self.hidden = YES;
                if (self.playerDidToEnd) {
                    self.playerDidToEnd();
                }
            }
                break;
            default:
                break;
        }
    });
}

/**
 告知代理对象播放器因错误停止播放
 */
-(void)player:(nonnull PLPlayer *)player stoppedWithError:(nullable NSError *)error
{
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.loadingView stopAnimate];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            self.failureView.hidden = NO;
            
            //            PLPlayerError errorCode = error.code;
            self.failureView.errorMessage = @"视频加载失败";
        });
    });
}

/**
 点播已缓冲区域
 */
-(void)player:(nonnull PLPlayer *)player loadedTimeRange:(CMTime)timeRange
{
    dispatch_async(dispatch_get_main_queue(), ^{
        NSTimeInterval totalSecond = CMTimeGetSeconds(self.player.totalDuration);
        if (totalSecond > 0) {
            NSTimeInterval bufferSecond = CMTimeGetSeconds(timeRange);
            self.progressView.bufferValue = bufferSecond / totalSecond;
        }else {
            self.progressView.bufferValue = 0;
        }
    });
}

/**
 seekTo 完成的回调通知
 */
-(void)player:(nonnull PLPlayer *)player seekToCompleted:(BOOL)isCompleted
{
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.loadingView stopAnimate];
    });
}

#pragma mark - 通知

-(void)registerNotification
{
    [self removeNotification];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(audioSessionRouteChangeNotification:) name:AVAudioSessionRouteChangeNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(willResignActiveNotification) name:UIApplicationWillResignActiveNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didBecomeActiveNotification) name:UIApplicationDidBecomeActiveNotification object:nil];
}

-(void)removeNotification
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:AVAudioSessionRouteChangeNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationWillResignActiveNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationDidBecomeActiveNotification object:nil];
}

/**
 播放设备切换通知
 */
-(void)audioSessionRouteChangeNotification:(NSNotification*)notification
{
    dispatch_async(dispatch_get_main_queue(), ^{
        NSInteger reason = [[notification.userInfo valueForKey:AVAudioSessionRouteChangeReasonKey] integerValue];
        if (reason == AVAudioSessionRouteChangeReasonOldDeviceUnavailable) {
            //耳机拔出停止播放
            [self pause];
        }
    });
}

/**
 去后台
 */
-(void)willResignActiveNotification
{
    dispatch_async(dispatch_get_main_queue(), ^{
        [self pause];
    });
}

/**
 回来
 */
-(void)didBecomeActiveNotification
{
    dispatch_async(dispatch_get_main_queue(), ^{
        [self continuePlay];
    });
}

#pragma mark - 定时器

-(void)initTimer
{
    [self invalidateTimer];
    self.timer = [BKTimer bk_setupTimerWithTimeInterval:0.01 totalTime:kBKTimerRepeatsTime handler:^(dispatch_source_t timer, CGFloat lastTime) {
        
        NSTimeInterval current = CMTimeGetSeconds(self.player.currentTime);
        NSTimeInterval totalSecond = CMTimeGetSeconds(self.player.totalDuration);
        if (self.videoUrl && self.playerPlayTimeChanged) {
            self.playerPlayTimeChanged(current, totalSecond);
        }

        if (totalSecond > 0) {
            self.progressView.value = current / totalSecond;
        }else {
            self.progressView.value = 0;
        }
    }];
}

-(void)invalidateTimer
{
    [BKTimer bk_removeTimer:self.timer];
}

@end
