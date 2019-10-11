//
//  BKCycleScrollImageView.m
//  BKCycleScrollView
//
//  Created by BIKE on 2018/6/7.
//  Copyright © 2018年 BIKE. All rights reserved.
//

#import "BKCycleScrollImageView.h"

@implementation BKCycleScrollImageView

-(instancetype)init
{
    self = [super init];
    if (self) {
        [self settingBase];
    }
    return self;
}

-(instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self settingBase];
    }
    return self;
}

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self settingBase];
    }
    return self;
}

-(instancetype)initWithImage:(UIImage *)image
{
    self = [super initWithImage:image];
    if (self) {
        [self settingBase];
    }
    return self;
}

-(instancetype)initWithImage:(UIImage *)image highlightedImage:(UIImage *)highlightedImage
{
    self = [super initWithImage:image highlightedImage:highlightedImage];
    if (self) {
        [self settingBase];
    }
    return self;
}

-(void)settingBase
{
    self.clipsToBounds = YES;
    self.contentMode = UIViewContentModeScaleAspectFit;
    self.shouldCustomLoopCount = YES;
    self.animationRepeatCount = NSIntegerMax;
    self.runLoopMode = NSRunLoopCommonModes;
}

@end
