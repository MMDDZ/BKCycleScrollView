//
//  BKCycleScrollCollectionViewCell.h
//  BKCycleScrollView
//
//  Created by BIKE on 2018/5/25.
//  Copyright © 2018年 BIKE. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BKCycleScrollImageView.h"
#import "BKCycleScrollDataModel.h"

@interface BKCycleScrollCollectionViewCell : UICollectionViewCell

#pragma mark - UI

/// 显示的imageView
@property (nonatomic,strong) BKCycleScrollImageView * displayImageView;
/// 播放视频view(从外层传入的，用于改变大小和BKCycleScrollCollectionViewCell一样)
@property (nonatomic,weak) UIView * playerBgView;

#pragma mark - 赋值

/// cell圆角度数 默认0
@property (nonatomic,assign) CGFloat radius;
/// 占位图 无默认
@property (nonatomic,strong) UIImage * placeholderImage;

/// 数据
@property (nonatomic,strong,readonly) BKCycleScrollDataModel * dataObj;
/// 当前cell数据的索引
@property (nonatomic,assign,readonly) NSUInteger currentIndex;
/// 赋值
/// @param dataObj 数据
/// @param currentIndex 当前cell数据的索引
-(void)setDataObj:(BKCycleScrollDataModel *)dataObj currentIndex:(NSUInteger)currentIndex;

#pragma mark - 回调

/// 点击播放回调
@property (nonatomic,copy) void (^clickPlayBtnCallBack)(BKCycleScrollCollectionViewCell * currentCell);
/// 加载完图片回调
@property (nonatomic,copy) void (^imageLoadCompleteCallBack)(BKCycleScrollDataModel * dataObj, NSUInteger currentIndex);

@end
