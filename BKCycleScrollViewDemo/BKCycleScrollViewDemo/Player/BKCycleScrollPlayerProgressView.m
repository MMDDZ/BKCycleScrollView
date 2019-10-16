//
//  BKCycleScrollPlayerProgressView.m
//  DSCnliveShopSDK
//
//  Created by zhaolin on 2019/5/8.
//  Copyright © 2019 BIKE. All rights reserved.
//

#import "BKCycleScrollPlayerProgressView.h"

@interface BKCycleScrollPlayerProgressView()

@property (nonatomic,strong) UIView * bufferView;//缓冲view
@property (nonatomic,strong) UIView * progressView;//进度view

@end

@implementation BKCycleScrollPlayerProgressView

#pragma mark - setter

-(void)setTotalColor:(UIColor *)totalColor
{
    _totalColor = totalColor;
    self.backgroundColor = _totalColor ? _totalColor : [UIColor colorWithWhite:1 alpha:0.2];
}

-(void)setBufferColor:(UIColor *)bufferColor
{
    _bufferColor = bufferColor;
    _bufferView.backgroundColor = _bufferColor ? _bufferColor : [UIColor colorWithWhite:1 alpha:0.4];
}

-(void)setCurrentColor:(UIColor *)currentColor
{
    _currentColor = currentColor;
    _progressView.backgroundColor = _currentColor ? _currentColor : [UIColor colorWithWhite:1 alpha:1];
}

-(void)setBufferValue:(CGFloat)bufferValue
{
    _bufferValue = bufferValue;
    if (_bufferValue > 1) {
        _bufferValue = 1;
    }else if (_bufferValue < 0) {
        _bufferValue = 0;
    }
    CGRect bufferViewFrame = _bufferView.frame;
    bufferViewFrame.size.width = self.frame.size.width * _bufferValue;
    _bufferView.frame = bufferViewFrame;
}

-(void)setValue:(CGFloat)value
{
    _value = value;
    if (_value > 1) {
        _value = 1;
    }else if (_value < 0) {
        _value = 0;
    }
    CGRect progressViewFrame = _progressView.frame;
    progressViewFrame.size.width = self.frame.size.width * _value;
    _progressView.frame = progressViewFrame;
}

#pragma mark - init

-(instancetype)init
{
    self = [super init];
    if (self) {
        self.backgroundColor = [UIColor colorWithWhite:1 alpha:0.2];
        [self initUI];
    }
    return self;
}

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor colorWithWhite:1 alpha:0.2];
        [self initUI];
    }
    return self;
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    
    self.bufferView.frame = CGRectMake(0, 0, self.frame.size.width * self.bufferValue, self.frame.size.height);
    self.progressView.frame = CGRectMake(0, 0, self.frame.size.width * self.value, self.frame.size.height);
}

#pragma mark - initUI

-(void)initUI
{
    [self addSubview:self.bufferView];
    [self addSubview:self.progressView];
}

-(UIView*)bufferView
{
    if (!_bufferView) {
        _bufferView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width * self.bufferValue, self.frame.size.height)];
        _bufferView.backgroundColor = self.bufferColor ? self.bufferColor : [UIColor colorWithWhite:1 alpha:0.4];
    }
    return _bufferView;
}

-(UIView*)progressView
{
    if (!_progressView) {
        _progressView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width * self.value, self.frame.size.height)];
        _progressView.backgroundColor = self.currentColor ? self.currentColor : [UIColor colorWithWhite:1 alpha:1];
    }
    return _progressView;
}


@end
