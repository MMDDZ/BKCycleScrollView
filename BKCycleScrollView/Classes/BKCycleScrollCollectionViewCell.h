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

/**
 显示的imageView
 */
@property (nonatomic,strong) BKCycleScrollImageView * displayImageView;

/** cell圆角度数 默认0 */
@property (nonatomic,assign) CGFloat radius;
/** 占位图 无默认 */
@property (nonatomic,strong) UIImage * placeholderImage;

/** 数据 */
@property (nonatomic,strong) BKCycleScrollDataModel * dataObj;
/** 当前cell数据的索引 */
@property (nonatomic,assign) NSUInteger currentIndex;

/**
 点击播放回调
 */
@property (nonatomic,copy) void (^clickPlayBtnCallBack)(BKCycleScrollCollectionViewCell * currentCell, NSUInteger currentIndex);

@end
