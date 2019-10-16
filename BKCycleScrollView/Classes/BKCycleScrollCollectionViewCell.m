//
//  BKCycleScrollCollectionViewCell.m
//  BKCycleScrollView
//
//  Created by BIKE on 2018/5/25.
//  Copyright © 2018年 BIKE. All rights reserved.
//

#import "BKCycleScrollCollectionViewCell.h"
#import <SDWebImage/SDWebImage.h>

@interface BKCycleScrollCollectionViewCell()

@property (nonatomic,strong) UIButton * playBtn;

@end

@implementation BKCycleScrollCollectionViewCell

#pragma mark - setRadius

-(void)setRadius:(CGFloat)radius
{
    _radius = radius;
    [self cutRadius:_radius];
}

-(void)cutRadius:(CGFloat)radius
{
    if (radius > 0) {
        UIBezierPath * path = [UIBezierPath bezierPathWithRoundedRect:self.bounds cornerRadius:radius];
        CAShapeLayer * maskLayer = [CAShapeLayer layer];
        maskLayer.path = path.CGPath;
        maskLayer.frame = self.bounds;
        self.layer.mask = maskLayer;
    }else {
        self.layer.mask = nil;
    }
}

#pragma mark - setPlaceholderImage

-(void)setPlaceholderImage:(UIImage *)placeholderImage
{
    _placeholderImage = placeholderImage;
    [self setDataObj:self.dataObj];
}

#pragma mark - init

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.clipsToBounds = NO;
        [self cutRadius:_radius];
        
        [self initUI];
    }
    return self;
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    
    self.displayImageView.frame = self.bounds;
    self.playBtn.frame = CGRectMake((self.frame.size.width - 44)/2, (self.frame.size.height - 44)/2, 44, 44);
    self.playerBgView.frame = self.bounds;
}

#pragma mark - initUI

-(void)initUI
{
    self.displayImageView = [[BKCycleScrollImageView alloc] init];
    self.displayImageView.clipsToBounds = YES;
    self.displayImageView.contentMode = UIViewContentModeScaleAspectFill;
    self.displayImageView.userInteractionEnabled = YES;
    //        _displayImageView.runLoopMode = NSDefaultRunLoopMode;//滑动时gif不进行动画 为了滑动流畅
    [self addSubview:self.displayImageView];
    
    self.playBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.playBtn setBackgroundImage:[self imageWithCycleScrollImageName:@"BK_start"] forState:UIControlStateNormal];
    [self.playBtn addTarget:self action:@selector(playBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.displayImageView addSubview:self.playBtn];
}

#pragma mark - 触发事件

-(void)playBtnClick:(UIButton*)button
{
    if (self.dataObj.isVideo) {
        if (self.clickPlayBtnCallBack) {
            self.clickPlayBtnCallBack(self);
        }
    }
}

#pragma mark - 赋值

-(void)setDataObj:(BKCycleScrollDataModel *)dataObj
{
    _dataObj = dataObj;
    
    self.displayImageView.image = self.placeholderImage;
    
    if ([dataObj.imageUrl length] > 0) {
        NSString * escapedUrl = [dataObj.imageUrl stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
        NSURL * imageUrl = [NSURL URLWithString:escapedUrl];
        [self.displayImageView sd_setImageWithURL:imageUrl placeholderImage:self.placeholderImage];
    }else if (dataObj.image) {
        self.displayImageView.image = dataObj.image;
    }else if (dataObj.imageData) {
        SDAnimatedImage * animatedImage = [SDAnimatedImage imageWithData:dataObj.imageData];
        if (animatedImage) {
            self.displayImageView.image = animatedImage;
        }else {
            UIImage * image = [UIImage imageWithData:dataObj.imageData];
            self.displayImageView.image = image;
        }
    }
    
    if (_dataObj.isVideo) {
        self.playBtn.hidden = NO;
    }else {
        self.playBtn.hidden = YES;
    }
}

#pragma mark - 图片获取

-(UIImage*)imageWithCycleScrollImageName:(NSString*)imageName
{
    NSString * path = [[NSBundle bundleForClass:[self class]] pathForResource:@"BKCycleScrollView" ofType:@"bundle"];
    UIImage * image = [UIImage imageWithContentsOfFile:[NSString stringWithFormat:@"%@/%@",path,imageName]];
    return image;
}

@end
