//
//  BKCycleScrollPageControl.h
//  BKCycleScrollView
//
//  Created by BIKE on 2018/6/6.
//  Copyright © 2018年 BIKE. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, BKCycleScrollPageControlAlignment) {
    BKCycleScrollPageAlignmentCenter = 0,       //中心对齐
    BKCycleScrollPageAlignmentLeft,             //左对齐
    BKCycleScrollPageAlignmentRight,            //右对齐
};

typedef NS_ENUM(NSUInteger, BKCycleScrollPageControlStyle) {
    BKCycleScrollPageControlStyleNone = 0,      //不显示
    BKCycleScrollPageControlStyleNormalDots,    //小圆点样式
    BKCycleScrollPageControlStyleLongDots,      //选中变长圆点样式
    BKCycleScrollPageControlStyleNumberLab,     //文本数字样式
};

@interface BKCycleScrollPageControl : UIView

/** 样式 修改完样式后，BKCycleScrollPageControl的高度会初始化 */
@property (nonatomic,assign) BKCycleScrollPageControlStyle style;
/** 对齐方式 */
@property (nonatomic,assign) BKCycleScrollPageControlAlignment alignment;

/** 总页数 */
@property(nonatomic,assign) NSUInteger numberOfPages;
/** 当前页 */
@property(nonatomic,assign) NSUInteger currentPage;

#pragma mark - 回调

/// 切换小圆点样式回调(不用理会，内部使用)
@property (nonatomic,copy) void (^switchStyleCallBack)(BKCycleScrollPageControlStyle style);

#pragma mark - 小圆点样式

/** 小圆点之间的间距 默认4 */
@property (nonatomic,assign) CGFloat pageSpace;
/** 小圆点默认颜色 默认灰 */
@property (nonatomic,strong) UIColor * normalPageColor;
/** 小圆点默认颜色 默认白 */
@property (nonatomic,strong) UIColor * selectPageColor;
/** 小圆点默认图片 无默认 */
@property (nonatomic,strong) UIImage * normalPageImage;
/** 小圆点默认图片 无默认 */
@property (nonatomic,strong) UIImage * selectPageImage;

#pragma mark - 文本数字样式

/// 文本字体 默认10
@property (nonatomic,strong) UIFont * pageTitleFont;
/// 文本颜色 默认白
@property (nonatomic,strong) UIColor * pageTitleColor;
/// 文本背景颜色 默认黑，透明0.3
@property (nonatomic,strong) UIColor * pageBgColor;

@end
