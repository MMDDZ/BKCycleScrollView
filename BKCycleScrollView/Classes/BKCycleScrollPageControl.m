//
//  BKCycleScrollPageControl.m
//  BKCycleScrollView
//
//  Created by BIKE on 2018/6/6.
//  Copyright © 2018年 BIKE. All rights reserved.
//

#import "BKCycleScrollPageControl.h"

@implementation BKCycleScrollPageControl
@synthesize normalPageColor = _normalPageColor;
@synthesize selectPageColor = _selectPageColor;

#pragma mark - 样式

-(void)setStyle:(BKCycleScrollPageControlStyle)style
{
    if (_style == style) {
        return;
    }
    _style = style;
    if (_style == BKCycleScrollPageControlStyleNone) {
        self.hidden = YES;
    }else {
        self.hidden = NO;
        [self resetUI];
    }
    if (self.switchStyleCallBack) {
        self.switchStyleCallBack(_style);
    }
}

-(void)setAlignment:(BKCycleScrollPageControlAlignment)alignment
{
    _alignment = alignment;
    [self resetUI];
}

#pragma mark - 页数

-(void)setNumberOfPages:(NSUInteger)numberOfPages
{
    _numberOfPages = numberOfPages;
    [self resetUI];
}

-(void)setCurrentPage:(NSUInteger)currentPage
{
    _currentPage = currentPage;
    [self resetUI];
}

#pragma mark - 小圆点样式

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

#pragma mark - 文本数字样式

-(void)setPageTitleFont:(UIFont *)pageTitleFont
{
    _pageTitleFont = pageTitleFont;
    [self resetUI];
}

-(void)setPageTitleColor:(UIColor *)pageTitleColor
{
    _pageTitleColor = pageTitleColor;
    [self resetUI];
}

-(void)setPageBgColor:(UIColor *)pageBgColor
{
    _pageBgColor = pageBgColor;
    [self resetUI];
}

#pragma mark - init

-(instancetype)init
{
    self = [super init];
    if (self) {
        [self initialize];
    }
    return self;
}

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initialize];
    }
    return self;
}

-(void)initialize
{
    self.backgroundColor = [UIColor clearColor];
    
    self.pageSpace = 7;
    self.normalPageColor = [UIColor lightGrayColor];
    self.selectPageColor = [UIColor whiteColor];
    
    self.pageTitleFont = [UIFont systemFontOfSize:10];
    self.pageTitleColor = [UIColor whiteColor];
    self.pageBgColor = [UIColor colorWithWhite:0 alpha:0.3];
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
    
    if (self.numberOfPages > 0) {
        if (self.style == BKCycleScrollPageControlStyleNumberLab) {
          
            UILabel * titleLab = [[UILabel alloc] init];
            titleLab.text = [NSString stringWithFormat:@"  %lu/%lu   ", self.numberOfPages, self.numberOfPages];
            titleLab.textColor = self.pageTitleColor;
            titleLab.font = self.pageTitleFont;
            titleLab.backgroundColor = self.pageBgColor;
            titleLab.textAlignment = NSTextAlignmentCenter;
            [self addSubview:titleLab];
            [titleLab sizeToFit];
            titleLab.text = [NSString stringWithFormat:@"%lu/%lu", self.currentPage+1, self.numberOfPages];
            CGFloat beginX = 0;
            if (self.alignment == BKCycleScrollPageAlignmentLeft) {
                beginX = 0;
            }else if (self.alignment == BKCycleScrollPageAlignmentRight) {
                beginX = self.frame.size.width - titleLab.frame.size.width;
            }else {
                beginX = (self.frame.size.width - titleLab.frame.size.width)/2;
            }
            titleLab.frame = CGRectMake(beginX, 0, titleLab.frame.size.width, self.frame.size.height);
            titleLab.layer.cornerRadius = titleLab.frame.size.height/2;
            titleLab.clipsToBounds = YES;
            
        }else {
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
                UIImageView * dot = [[UIImageView alloc] init];
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
}

@end
