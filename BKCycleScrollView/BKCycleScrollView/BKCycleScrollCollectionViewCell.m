//
//  BKCycleScrollCollectionViewCell.m
//  BKCycleScrollView
//
//  Created by BIKE on 2018/5/25.
//  Copyright © 2018年 BIKE. All rights reserved.
//

#import "BKCycleScrollCollectionViewCell.h"
#import "UIImageView+WebCache.h"

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
//        [self cutRadius:_radius];
    }
    return self;
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    
    _displayImageView.frame = self.bounds;
}

#pragma mark - displayImageView

-(BKCycleScrollImageView*)displayImageView
{
    if (!_displayImageView) {
        _displayImageView = [[BKCycleScrollImageView alloc] initWithFrame:self.bounds];
        _displayImageView.clipsToBounds = YES;
        _displayImageView.contentMode = UIViewContentModeScaleAspectFill;
        //        _displayImageView.runLoopMode = NSDefaultRunLoopMode;//滑动时gif不进行动画 为了滑动流畅
        [self addSubview:_displayImageView];
    }
    return _displayImageView;
}

#pragma mark - 赋值

-(void)setDataObj:(NSObject *)dataObj
{
    _dataObj = dataObj;
    
    if ([dataObj isKindOfClass:[NSString class]]) {
        NSURL * imageUrl = [NSURL URLWithString:(NSString*)_dataObj];
        [self.displayImageView sd_setImageWithURL:imageUrl placeholderImage:self.placeholderImage];
    }else if ([_dataObj isKindOfClass:[UIImage class]]) {
        self.displayImageView.image = (UIImage*)_dataObj;
    }else if ([_dataObj isKindOfClass:[NSData class]]) {
        FLAnimatedImage * image = [FLAnimatedImage animatedImageWithGIFData:(NSData*)_dataObj];
        if (!image) {
            self.displayImageView.image = [UIImage imageWithData:(NSData*)_dataObj];
        }else{
            self.displayImageView.animatedImage = image;
        }
    }else{
        self.displayImageView.image = self.placeholderImage;
    }
}

@end
