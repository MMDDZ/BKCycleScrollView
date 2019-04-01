//
//  BKCycleScrollVideoContentView.h
//  BKCycleScrollView
//
//  Created by zhaolin on 2019/1/17.
//  Copyright © 2019年 BIKE. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <ZFPlayer/ZFPlayerMediaControl.h>
#import "BKCycleScrollDataModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface BKCycleScrollVideoContentView : UIView<ZFPlayerMediaControl>

/**
 数据
 */
@property (nonatomic,strong) BKCycleScrollDataModel * dataObj;

/** 进度条背景颜色 默认[UIColor colorWithWhite:1 alpha:0.3]*/
@property (nonatomic,strong) UIColor * progressColor;
/** 进度条加载颜色 默认[UIColor colorWithWhite:1 alpha:0.6]*/
@property (nonatomic,strong) UIColor * bufferColor;
/** 进度条当前播放颜色 默认[UIColor colorWithWhite:1 alpha:1]*/
@property (nonatomic,strong) UIColor * currentColor;

@end

NS_ASSUME_NONNULL_END
