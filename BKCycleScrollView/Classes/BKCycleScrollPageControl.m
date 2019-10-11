//
//  BKCycleScrollPageControl.m
//  BKCycleScrollView
//
//  Created by BIKE on 2018/6/6.
//  Copyright © 2018年 BIKE. All rights reserved.
//

#import "BKCycleScrollPageControl.h"
#import "BKCycleScrollImageView.h"

@implementation BKCycleScrollPageControl

#pragma mark - setter

-(void)setNumberOfPages:(NSInteger)numberOfPages
{
    _numberOfPages = numberOfPages;
    [self resetUI];
}

-(void)setCurrentPage:(NSInteger)currentPage
{
    _currentPage = currentPage;
    [self resetUI];
}

-(void)setStyle:(BKCycleScrollPageControlStyle)style
{
    _style = style;
    if (_style == BKCycleScrollPageControlStyleNone) {
        self.hidden = YES;
    }else {
        self.hidden = NO;
        [self resetUI];
    }
}

-(void)setAlignment:(BKCycleScrollPageControlAlignment)alignment
{
    _alignment = alignment;
    [self resetUI];
}

-(void)setPageSpace:(CGFloat)pageSpace
{
    _pageSpace = pageSpace;
    [self resetUI];
}

-(void)setNormalPageColor:(UIColor *)normalPageColor
{
    _normalPageColor = normalPageColor;
    [self resetUI];
}

-(void)setSelectPageColor:(UIColor *)selectPageColor
{
    _selectPageColor = selectPageColor;
    [self resetUI];
}

-(void)setNormalPageImage:(UIImage *)normalPageImage
{
    _normalPageImage = normalPageImage;
    [self resetUI];
}

-(void)setSelectPageImage:(UIImage *)selectPageImage
{
    _selectPageImage = selectPageImage;
    [self resetUI];
}

#pragma mark - init

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        self.style = BKCycleScrollPageControlStyleNone;
        self.alignment = BKCycleScrollPageAlignmentCenter;
        self.pageSpace = 7;
        self.normalPageColor = [UIColor lightGrayColor];
        self.selectPageColor = [UIColor whiteColor];
    }
    return self;
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    [self resetUI];
}

#pragma mark - UI

-(void)resetUI
{
    [[self subviews] makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    if (_numberOfPages > 0) {
        
        CGFloat normal_w = self.frame.size.height;//未选中宽
        CGFloat select_w = 0;//选中宽
        if (_style == BKCycleScrollPageControlStyleLongDots) {
            select_w = normal_w * 2;
        }else{
            select_w = normal_w;
        }
        CGFloat space = self.pageSpace;//间距宽
        
        CGFloat width = (_numberOfPages-1) * (normal_w+space) + select_w;
        CGFloat beginX = 0;
        if (self.alignment == BKCycleScrollPageAlignmentLeft) {
            beginX = 0;
        }else if (self.alignment == BKCycleScrollPageAlignmentRight) {
            beginX = self.frame.size.width - width;
        }else {
            beginX = (self.frame.size.width - width)/2;
        }
        
        UIView * lastView;
        for (int index = 0; index < _numberOfPages; index++) {
            
            BKCycleScrollImageView * dot = [[BKCycleScrollImageView alloc] init];
            CGFloat x = lastView?(CGRectGetMaxX(lastView.frame)+space):beginX;
            if (index == _currentPage) {
                [dot setFrame:CGRectMake(x, 0, select_w , normal_w)];
                if (_selectPageImage) {
                    dot.image = _selectPageImage;
                }else{
                    dot.backgroundColor = _selectPageColor;
                }
            }else{
                [dot setFrame:CGRectMake(x, 0, normal_w , normal_w)];
                if (_normalPageImage) {
                    dot.image = _normalPageImage;
                }else{
                    dot.backgroundColor = _normalPageColor;
                }
            }
            dot.layer.cornerRadius = dot.frame.size.height/2;
            dot.contentMode = UIViewContentModeScaleAspectFit;
            dot.clipsToBounds = YES;
            [self addSubview:dot];
            
            lastView = dot;
        }
    }
}

@end
