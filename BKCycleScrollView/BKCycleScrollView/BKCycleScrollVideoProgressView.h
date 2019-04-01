//
//  BKCycleScrollVideoProgressView.h
//  BKCycleScrollView
//
//  Created by zhaolin on 2019/4/1.
//  Copyright © 2019年 BIKE. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface BKCycleScrollVideoProgressView : UIView

/**
 全部进度颜色
 */
@property (nonatomic,strong) UIColor * totalColor;
/**
 缓冲进度颜色
 */
@property (nonatomic,strong) UIColor * bufferColor;
/**
 当前进度颜色
 */
@property (nonatomic,strong) UIColor * currentColor;
/**
 缓冲 0~1
 */
@property (nonatomic,assign) CGFloat bufferValue;
/**
 进度 0~1
 */
@property (nonatomic,assign) CGFloat value;

@end

NS_ASSUME_NONNULL_END
