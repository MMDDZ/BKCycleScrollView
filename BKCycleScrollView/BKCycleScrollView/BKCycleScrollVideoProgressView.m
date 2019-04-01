//
//  BKCycleScrollVideoProgressView.m
//  BKCycleScrollView
//
//  Created by zhaolin on 2019/4/1.
//  Copyright © 2019年 BIKE. All rights reserved.
//

#import "BKCycleScrollVideoProgressView.h"

@interface BKCycleScrollVideoProgressView()

@property (nonatomic,strong) UIView * belowView;
@property (nonatomic,strong) UIView * aboveView;

@end

@implementation BKCycleScrollVideoProgressView

#pragma mark - setter

-(void)setTotalColor:(UIColor *)totalColor
{
    _totalColor = totalColor;
    self.backgroundColor = self.totalColor ? self.totalColor : [UIColor colorWithWhite:1 alpha:0.3];
}

-(void)setBufferColor:(UIColor *)bufferColor
{
    _bufferColor = bufferColor;
    _belowView.backgroundColor = self.bufferColor ? self.bufferColor : [UIColor colorWithWhite:1 alpha:0.6];
}

-(void)setCurrentColor:(UIColor *)currentColor
{
    _currentColor = currentColor;
    _aboveView.backgroundColor = self.currentColor ? self.currentColor : [UIColor colorWithWhite:1 alpha:1];
}

-(void)setBufferValue:(CGFloat)bufferValue
{
    _bufferValue = bufferValue;
    if (_bufferValue > 1) {
        _bufferValue = 1;
    }else if (_bufferValue < 0) {
        _bufferValue = 0;
    }
    if (_bufferValue == 0 && _value == 0) {
        self.hidden = YES;
    }else {
        self.hidden = NO;
    }
    CGRect belowViewFrame = _belowView.frame;
    belowViewFrame.size.width = self.frame.size.width * _bufferValue;
    _belowView.frame = belowViewFrame;
}

-(void)setValue:(CGFloat)value
{
    _value = value;
    if (_value > 1) {
        _value = 1;
    }else if (_value < 0) {
        _value = 0;
    }
    if (_bufferValue == 0 && _value == 0) {
        self.hidden = YES;
    }else {
        self.hidden = NO;
    }
    CGRect aboveViewFrame = _aboveView.frame;
    aboveViewFrame.size.width = self.frame.size.width * _value;
    _aboveView.frame = aboveViewFrame;
}

-(void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
    
    _belowView.frame = self.bounds;
    _aboveView.frame = self.bounds;
}

#pragma mark - init

-(instancetype)init
{
    self = [super init];
    if (self) {
        self.backgroundColor = [UIColor colorWithWhite:1 alpha:0.3];
        [self initUI];
    }
    return self;
}

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor colorWithWhite:1 alpha:0.3];
        [self initUI];
    }
    return self;
}

-(void)initUI
{
    [self addSubview:self.belowView];
    [self addSubview:self.aboveView];
}

-(UIView*)belowView
{
    if (!_belowView) {
        _belowView = [[UIView alloc] initWithFrame:self.bounds];
        _belowView.backgroundColor = self.bufferColor ? self.bufferColor : [UIColor colorWithWhite:1 alpha:0.6];
    }
    return _belowView;
}

-(UIView*)aboveView
{
    if (!_aboveView) {
        _aboveView = [[UIView alloc] initWithFrame:self.bounds];
        _aboveView.backgroundColor = self.currentColor ? self.currentColor : [UIColor colorWithWhite:1 alpha:1];
    }
    return _aboveView;
}

@end
