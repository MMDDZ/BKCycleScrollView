//
//  BKCycleScrollPlayerLoadingView.m
//  DSCnliveShopSDK
//
//  Created by zhaolin on 2019/5/8.
//  Copyright © 2019 BIKE. All rights reserved.
//

#import "BKCycleScrollPlayerLoadingView.h"

@interface BKCycleScrollPlayerLoadingView()<CAAnimationDelegate>

@property (nonatomic,strong) CAShapeLayer * loadingLayer;

@property (nonatomic,assign) CGFloat beginAngle;//开始角度
@property (nonatomic,assign) CGFloat animateAngle;//动画角度

@end

@implementation BKCycleScrollPlayerLoadingView
@synthesize isLoading = _isLoading;

-(void)setIsLoading:(BOOL)isLoading
{
    _isLoading = isLoading;
}

-(BOOL)isLoading
{
    return _isLoading;
}

#pragma mark - init

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.alpha = 0;
        self.beginAngle = 0;
        self.animateAngle = M_PI*10/3;
        [self.layer addSublayer:self.loadingLayer];
    }
    return self;
}

-(void)dealloc
{
    [self stopAnimate];
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    
    UIBezierPath * path = [UIBezierPath bezierPathWithArcCenter:CGPointMake(self.frame.size.width/2, self.frame.size.height/2) radius:self.frame.size.width/2-3 startAngle:self.beginAngle endAngle:self.animateAngle clockwise:YES];
    self.loadingLayer.path = path.CGPath;
}

#pragma mark - loadingLayer

-(CAShapeLayer*)loadingLayer
{
    if (!_loadingLayer) {
        _loadingLayer = [CAShapeLayer layer];
        _loadingLayer.lineWidth = 3;
        _loadingLayer.fillColor = [UIColor clearColor].CGColor;
        _loadingLayer.strokeColor = [UIColor whiteColor].CGColor;
        _loadingLayer.lineCap = kCALineCapRound;
    }
    return _loadingLayer;
}

#pragma mark - 动画

-(void)startAnimate
{
    self.isLoading = YES;
    
    [self.loadingLayer removeAllAnimations];
    self.alpha = 1;
    
    CABasicAnimation * strokeStartAnimation = [CABasicAnimation animationWithKeyPath:@"strokeStart"];
    strokeStartAnimation.fromValue = @(0);
    strokeStartAnimation.toValue = @(1);
    strokeStartAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    
    CABasicAnimation * strokeEndAnimation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    strokeEndAnimation.fromValue = @(0);
    strokeEndAnimation.toValue = @(1);
    strokeEndAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    strokeEndAnimation.duration = 1;
    
    CAAnimationGroup * strokeAniamtionGroup = [CAAnimationGroup animation];
    strokeAniamtionGroup.duration = 1.5;
    strokeAniamtionGroup.fillMode = kCAFillModeForwards;
    strokeAniamtionGroup.removedOnCompletion = NO;
    strokeAniamtionGroup.delegate = self;
    strokeAniamtionGroup.animations = @[strokeEndAnimation, strokeStartAnimation];
    [self.loadingLayer addAnimation:strokeAniamtionGroup forKey:@"strokeAniamtionGroup"];
}

-(void)stopAnimate
{
    self.isLoading = NO;
    
    [self.loadingLayer removeAllAnimations];
    self.beginAngle = 0;
    self.alpha = 0;
}

#pragma mark - CAAnimationDelegate

-(void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag
{
    if ([self.loadingLayer animationForKey:@"strokeAniamtionGroup"] == anim) {
        self.beginAngle = self.beginAngle + self.animateAngle;
        UIBezierPath * path = [UIBezierPath bezierPathWithArcCenter:CGPointMake(self.frame.size.width/2, self.frame.size.height/2) radius:self.frame.size.width/2-3 startAngle:self.beginAngle endAngle:self.beginAngle + self.animateAngle clockwise:YES];
        self.loadingLayer.path = path.CGPath;
        [self startAnimate];
    }
}


@end
