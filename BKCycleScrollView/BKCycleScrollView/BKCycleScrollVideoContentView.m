//
//  BKCycleScrollVideoContentView.m
//  BKCycleScrollView
//
//  Created by zhaolin on 2019/1/17.
//  Copyright © 2019年 BIKE. All rights reserved.
//

#import "BKCycleScrollVideoContentView.h"

@interface BKCycleScrollVideoContentView()

@end

@implementation BKCycleScrollVideoContentView
@synthesize player = _player;

#pragma mark - 播放器状态

/**
 准备播放
 */
-(void)videoPlayer:(ZFPlayerController *)videoPlayer prepareToPlay:(NSURL *)assetURL
{
    
}

/**
 播放状态改变
 */
-(void)videoPlayer:(ZFPlayerController *)videoPlayer playStateChanged:(ZFPlayerPlaybackState)state
{
    
}

/**
 加载状态改变
 */
-(void)videoPlayer:(ZFPlayerController *)videoPlayer loadStateChanged:(ZFPlayerLoadState)state
{
    
}

#pragma mark - 手势代理

-(BOOL)gestureTriggerCondition:(ZFPlayerGestureControl *)gestureControl gestureType:(ZFPlayerGestureType)gestureType gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer touch:(UITouch *)touch
{//不响应任何手势
    return NO;
}



@end
