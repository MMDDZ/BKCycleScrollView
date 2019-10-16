//
//  BKCycleScrollView.h
//  BKCycleScrollView
//
//  Created by BIKE on 2018/5/25.
//  Copyright © 2018年 BIKE. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BKCycleScrollDataModel.h"
#import "BKCycleScrollPageControl.h"
@class BKCycleScrollView;

FOUNDATION_EXPORT double BKCycleScrollViewVersionNumber;
FOUNDATION_EXPORT const unsigned char BKCycleScrollViewVersionString[];

typedef NS_ENUM(NSUInteger, BKDisplayCellLayoutStyle) {
    BKDisplayCellLayoutStyleNormal = 0,         //普通样式
    BKDisplayCellLayoutStyleMiddleLarger        //中间变大
};

@protocol BKCycleScrollViewDelegate<NSObject>

@optional

#pragma mark - 自定义cell

/// 自定义cell时获取数据数
/// @param cycleScrollView 无限滚动视图
/// @return 数据数
-(NSUInteger)numberOfItemsInCycleScrollView:(nonnull BKCycleScrollView *)cycleScrollView;

/// 自定义cell方法
/// @param cycleScrollView 无限滚动视图
/// @param index 显示自定义cell的索引
/// @return UICollectionViewCell
-(nonnull UICollectionViewCell *)cycleScrollView:(nonnull BKCycleScrollView *)cycleScrollView customCellForItemAtIndex:(NSInteger)index;

#pragma mark - 视频

/// 开始播放方法 (需要自己添加播放器并且播放，不实现这个代理无法播放)
/// @param cycleScrollView 无限滚动视图
/// @param playIndex 要播放的视频所在索引
/// @param superView 视频播放器所在的父视图
-(void)cycleScrollView:(nonnull BKCycleScrollView*)cycleScrollView playIndex:(NSUInteger)playIndex superView:(nonnull UIView*)superView;

/// 暂停播放方法 (需要自己暂停播放器，不实现这个代理无法暂停播放)
/// @param cycleScrollView 无限滚动视图
/// @param pauseIndex 要暂停播放的视频所在索引
-(void)cycleScrollView:(nonnull BKCycleScrollView *)cycleScrollView pauseIndex:(NSUInteger)pauseIndex;

/// 停止播放方法 (需要自己停止播放器，不实现这个代理无法停止播放)
/// @param cycleScrollView 无限滚动视图
/// @param stopIndex 要暂停播放的视频所在索引
-(void)cycleScrollView:(nonnull BKCycleScrollView *)cycleScrollView stopIndex:(NSUInteger)stopIndex;

#pragma mark - 滚动

/// 开始划动
/// @param cycleScrollView 无限滚动视图
/// @param scrollView 滑动视图
-(void)cycleScrollView:(nonnull BKCycleScrollView *)cycleScrollView scrollViewWillBeginDragging:(nonnull UIScrollView *)scrollView;

/// 滑动中
/// @param cycleScrollView 无限滚动视图
/// @param scrollView 滑动视图
-(void)cycleScrollView:(nonnull BKCycleScrollView *)cycleScrollView scrollViewDidScroll:(nonnull UIScrollView *)scrollView;

/// 结束划动
/// @param cycleScrollView 无限滚动视图
/// @param scrollView 滑动视图
/// @param decelerate 即将进行减速
-(void)cycleScrollView:(nonnull BKCycleScrollView *)cycleScrollView scrollViewDidEndDragging:(nonnull UIScrollView *)scrollView willDecelerate:(BOOL)decelerate;

/// 结束划动 带目标停止位置
/// @param cycleScrollView 无限滚动视图
/// @param scrollView 滑动视图
/// @param velocity 速度
/// @param targetContentOffset 目标停止位置
-(void)cycleScrollView:(nonnull BKCycleScrollView *)cycleScrollView scrollViewWillEndDragging:(nonnull UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(nonnull inout CGPoint *)targetContentOffset;

/// 结束惯性滑动
/// @param cycleScrollView 无限滚动视图
/// @param scrollView 滑动视图
-(void)cycleScrollView:(nonnull BKCycleScrollView *)cycleScrollView scrollViewDidEndDecelerating:(nonnull UIScrollView *)scrollView;

@end

NS_ASSUME_NONNULL_BEGIN

@interface BKCycleScrollView : UIView

#pragma mark - BKCycleScrollView属性

/** 代理 */
@property (nonatomic,weak) id<BKCycleScrollViewDelegate> delegate;
/** 背景颜色 默认透明 */
@property (nonatomic,strong) UIColor * displayBackgroundColor;
/** 轮播数组 自定义cell不用传 需使用numberOfItemsInCycleScrollView:代理*/
@property (nonatomic,copy,nullable) NSArray<BKCycleScrollDataModel*> * displayDataArr;
/** 当前所看到数据的索引 */
@property (nonatomic,assign) NSInteger currentIndex;
/** 占位图 无默认 */
@property (nonatomic,strong) UIImage * placeholderImage;
/** 是否自动滚动 默认是 */
@property (nonatomic,assign) BOOL isAutoScroll;
/** 自动滚动时间 默认5s */
@property (nonatomic,assign) CGFloat autoScrollTime;
/** 是否分页 (就是滑动结束时控件中心和某个item中心重合) 默认分页 */
@property (nonatomic,assign) BOOL pagingEnabled;
/** 是否允许滑动 */
@property (nonatomic,assign) BOOL isAllowScroll;

#pragma mark - cell属性

/** cell显示风格 */
@property (nonatomic,assign) BKDisplayCellLayoutStyle layoutStyle;
/** cell间距 默认0 */
@property (nonatomic,assign) CGFloat itemSpace;
/** cell的宽度 默认和无限滚动视图同宽 */
@property (nonatomic,assign) CGFloat itemWidth;
/** 默认0.1 当layoutStyle = BKDisplayCellLayoutStyleMiddleLarger时有效 除中间显示的cell不缩放外,其余cell缩放系数 */
@property (nonatomic,assign) CGFloat itemReduceScale;
/** cell圆角度数 默认0 */
@property (nonatomic,assign) CGFloat radius;

#pragma mark - 分页指示器属性

/** 分页指示器 */
@property (nonatomic,strong,readonly) BKCycleScrollPageControl * pageControl;
/** 分页指示器距左底右边界偏移量 top无效 默认10 */
@property (nonatomic,assign) UIEdgeInsets pageControlContentInset;
/** 分页指示器高度 当为小圆点样式时，默认7  当为文本数字样式时，默认18 */
@property (nonatomic,assign) CGFloat pageControlHeight;

#pragma mark - 视频

/// 开始播放
-(void)playVideo;

/// 暂停播放
-(void)pauseVideo;

/// 停止播放
-(void)stopVideo;

#pragma mark - 自定义cell

/// 注册customCell (UICollectionViewCell)
/// @param cellClass cell类
/// @param identifier 标识符
-(void)registerClass:(nullable Class)cellClass forCustomCellWithReuseIdentifier:(nullable NSString *)identifier;

/// 复用customCell (UICollectionViewCell)
/// @param identifier 标识符
/// @param index 索引
/// @return UICollectionViewCell
-(__kindof UICollectionViewCell*)dequeueReusableCustomCellWithReuseIdentifier:(NSString *)identifier forIndex:(NSUInteger)index;

#pragma mark - 公开方法

/// 获取显示的索引
/// @return 索引数组
-(NSArray<NSNumber*>*)visibleIndexs;

/// 重置cell的位置
-(void)resetCellPosition;

/// 刷新无限轮播视图
-(void)reloadData;

#pragma mark - 回调方法

/**
 点击item方法
 index 点中的索引
 imageView 显示的图片 非自定义cell时有值
 */
@property (nonatomic,copy) void (^clickItemCallBack)(NSInteger index, UIImageView * _Nullable imageView);

/**
 切换item回调
 */
@property (nonatomic,copy) void (^switchIndexCallBack)(NSUInteger index);

@end

NS_ASSUME_NONNULL_END

