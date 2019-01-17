//
//  BKCycleScrollView.h
//  BKCycleScrollView
//
//  Created by BIKE on 2018/5/25.
//  Copyright © 2018年 BIKE. All rights reserved.
//

#import <UIKit/UIKit.h>
@class BKCycleScrollView;

typedef NS_ENUM(NSUInteger, BKDisplayCellLayoutStyle) {
    BKDisplayCellLayoutStyleNormal = 0,         //普通样式
    BKDisplayCellLayoutStyleMiddleLarger        //中间变大
};

typedef NS_ENUM(NSUInteger, BKCycleScrollPageControlStyle) {
    BKCycleScrollPageControlStyleNone = 0,      //不显示
    BKCycleScrollPageControlStyleNormalDots,    //小圆点形式
    BKCycleScrollPageControlStyleLongDots,      //选中变长圆点形式
};

@protocol BKCycleScrollViewDelegate<NSObject>

@optional

/**
 自定义cell方法

 @param cycleScrollView 无限滚动视图
 @param index 索引
 @param displayCell 显示的cell
 */
-(void)cycleScrollView:(BKCycleScrollView*)cycleScrollView customDisplayCellStyleAtIndex:(NSInteger)index displayCell:(UICollectionViewCell*)displayCell;

@end

@interface BKCycleScrollView : UIView

@property (nonatomic,assign) id<BKCycleScrollViewDelegate> delegate;

/** 背景颜色 默认透明 */
@property (nonatomic,strong) UIColor * displayBackgroundColor;
/** 图片数组 网络图片传String 本地图片传Image或者data */
@property (nonatomic,strong) NSArray * displayDataArr;
/** 占位图 无默认 */
@property (nonatomic,strong) UIImage * placeholderImage;
/** 自动滚动时间 默认5s */
@property (nonatomic,assign) CGFloat autoScrollTime;

#pragma mark - cell属性

/** cell显示风格 */
@property (nonatomic,assign) BKDisplayCellLayoutStyle layoutStyle;
/** cell间距 默认0 */
@property (nonatomic,assign) CGFloat itemSpace;
/** cell的宽度 默认和无限滚动视图同宽 */
@property (nonatomic,assign) CGFloat itemWidth;
/**
 默认0.1 当layoutStyle = BKDisplayCellLayoutStyleMiddleLarger时有效
 除中间显示的cell不缩放外,其余cell缩放系数
 */
@property (nonatomic,assign) CGFloat itemReduceScale;
/** cell圆角度数 默认0 */
@property (nonatomic,assign) CGFloat radius;

#pragma mark - 小圆点属性

/** 小圆点样式 */
@property (nonatomic,assign) BKCycleScrollPageControlStyle pageControlStyle;
/**
 小圆点高度 默认 7
 pageControlStyle不同状态时默认小圆点宽度不同
 pageControlStyle = BKCycleScrollPageControlStyleNormalDots 时 所有小圆点宽度与高度一样
 pageControlStyle = BKCycleScrollPageControlStyleLongDots 时 选中小圆点宽度是高度的两倍 未选中小圆点宽度与高度一样
 */
@property (nonatomic,assign) CGFloat dotHeight;
/** 小圆点之间的间距 默认7 */
@property (nonatomic,assign) CGFloat dotSpace;
/** 小圆点距底部边界偏移量 默认10 */
@property (nonatomic,assign) CGFloat dotBottomInset;
/** 小圆点默认颜色 默认灰 */
@property (nonatomic,strong) UIColor * normalDotColor;
/** 小圆点选中颜色 默认白 */
@property (nonatomic,strong) UIColor * selectDotColor;
/** 小圆点默认图片 无默认 级数比颜色高 */
@property (nonatomic,strong) UIImage * normalDotImage;
/** 小圆点选中图片 无默认 级数比颜色高 */
@property (nonatomic,strong) UIImage * selectDotImage;

#pragma mark - 创建方法

-(instancetype)initWithFrame:(CGRect)frame;
-(instancetype)initWithFrame:(CGRect)frame displayDataArr:(NSArray*)displayDataArr;
-(instancetype)initWithFrame:(CGRect)frame delegate:(id<BKCycleScrollViewDelegate>)delegate;
-(instancetype)initWithFrame:(CGRect)frame delegate:(id<BKCycleScrollViewDelegate>)delegate displayDataArr:(NSArray*)displayDataArr;

/**
 点击item方法
 index 点中的索引
 */
@property (nonatomic,copy) void (^selectItemAction)(NSInteger index, UIImageView * imageView);

@end
