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
        
        [self addSubview:self.displayImageView];
        [self.displayImageView addSubview:self.playBtn];
    }
    return self;
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    
    _displayImageView.frame = self.bounds;
    _playBtn.frame = CGRectMake((self.frame.size.width - 44)/2, (self.frame.size.height - 44)/2, 44, 44);
}

#pragma mark - displayImageView

-(BKCycleScrollImageView*)displayImageView
{
    if (!_displayImageView) {
        _displayImageView = [[BKCycleScrollImageView alloc] initWithFrame:self.bounds];
        _displayImageView.clipsToBounds = YES;
        _displayImageView.contentMode = UIViewContentModeScaleAspectFill;
        _displayImageView.userInteractionEnabled = YES;
        _displayImageView.tag = 99999;
        //        _displayImageView.runLoopMode = NSDefaultRunLoopMode;//滑动时gif不进行动画 为了滑动流畅
    }
    return _displayImageView;
}

#pragma mark - playBtn

-(UIButton*)playBtn
{
    if (!_playBtn) {
        _playBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _playBtn.frame = CGRectMake((self.displayImageView.bounds.size.width - 44)/2, (self.displayImageView.bounds.size.height - 44)/2, 44, 44);
        [_playBtn setBackgroundImage:[self imageWithCycleScrollImageName:@"BK_start"] forState:UIControlStateNormal];
        [_playBtn addTarget:self action:@selector(playBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _playBtn;
}

#pragma mark - 触发事件

-(void)playBtnClick:(UIButton*)button
{
    if (self.dataObj.isVideo) {
        if (self.clickPlayBtnCallBack) {
            self.clickPlayBtnCallBack(self, self.currentIndex);
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
