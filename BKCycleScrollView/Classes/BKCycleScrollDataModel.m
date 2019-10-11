//
//  BKCycleScrollDataModel.m
//  BKCycleScrollView
//
//  Created by zhaolin on 2019/1/17.
//  Copyright © 2019年 BIKE. All rights reserved.
//

#import "BKCycleScrollDataModel.h"

@implementation BKCycleScrollDataModel

-(void)setVideoUrl:(NSString *)videoUrl
{
    _videoUrl = videoUrl;
    if ([_videoUrl length] > 0) {
        _isVideo = YES;
    }else {
        _isVideo = NO;
    }
}

@end
