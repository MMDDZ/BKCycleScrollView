//
//  BKCycleScrollCollectionViewCell.m
//  weixiutong
//
//  Created by zhaolin on 2018/5/25.
//  Copyright © 2018年 BIKE. All rights reserved.
//

#import "BKCycleScrollCollectionViewCell.h"

@implementation BKCycleScrollCollectionViewCell

#pragma mark - setRadius

-(void)setRadius:(CGFloat)radius
{
    _radius = radius;
    [self cutRadius:_radius];
}

-(void)cutRadius:(CGFloat)radius
{
    UIBezierPath * path = [UIBezierPath bezierPathWithRoundedRect:self.bounds cornerRadius:radius];
    CAShapeLayer * maskLayer = [CAShapeLayer layer];
    maskLayer.path = path.CGPath;
    maskLayer.frame = self.bounds;
    self.layer.mask = maskLayer;
}

#pragma mark - init

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self cutRadius:_radius];
    }
    return self;
}

#pragma mark - displayImageView

-(BKCycleScrollImageView*)displayImageView
{
    if (!_displayImageView) {
        _displayImageView = [[BKCycleScrollImageView alloc] initWithFrame:self.bounds];
        _displayImageView.clipsToBounds = YES;
        _displayImageView.contentMode = UIViewContentModeScaleAspectFill;
        [self addSubview:_displayImageView];
    }
    return _displayImageView;
}

@end
