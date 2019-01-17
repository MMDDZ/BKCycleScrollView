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

-(void)setPageControlStyle:(BKCycleScrollPageControlStyle)pageControlStyle
{
    _pageControlStyle = pageControlStyle;
    [self resetUI];
}

-(void)setDotSpace:(CGFloat)dotSpace
{
    _dotSpace = dotSpace;
    [self resetUI];
}

-(void)setNormalDotColor:(UIColor *)normalDotColor
{
    _normalDotColor = normalDotColor;
    [self resetUI];
}

-(void)setSelectDotColor:(UIColor *)selectDotColor
{
    _selectDotColor = selectDotColor;
    [self resetUI];
}

-(void)setNormalDotImage:(UIImage *)normalDotImage
{
    _normalDotImage = normalDotImage;
    [self resetUI];
}

-(void)setSelectDotImage:(UIImage *)selectDotImage
{
    _selectDotImage = selectDotImage;
    [self resetUI];
}

#pragma mark - init

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
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
        if (_pageControlStyle == BKCycleScrollPageControlStyleLongDots) {
            select_w = normal_w * 2;
        }else{
            select_w = normal_w;
        }
        CGFloat space = self.dotSpace;//间距宽
        
        CGFloat width = (_numberOfPages-1) * (normal_w+space) + select_w;
        CGFloat beginX = (self.frame.size.width - width)/2;
        
        UIView * lastView;
        for (int index = 0; index < _numberOfPages; index++) {
            
            BKCycleScrollImageView * dot = [[BKCycleScrollImageView alloc]init];
            CGFloat x = lastView?(CGRectGetMaxX(lastView.frame)+space):beginX;
            if (index == _currentPage) {
                [dot setFrame:CGRectMake(x, 0, select_w , normal_w)];
                if (_selectDotImage) {
                    dot.image = _selectDotImage;
                }else{
                    dot.backgroundColor = _selectDotColor;
                }
            }else{
                [dot setFrame:CGRectMake(x, 0, normal_w , normal_w)];
                if (_normalDotImage) {
                    dot.image = _normalDotImage;
                }else{
                    dot.backgroundColor = _normalDotColor;
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
