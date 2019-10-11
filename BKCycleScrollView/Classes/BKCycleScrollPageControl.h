//
//  BKCycleScrollPageControl.h
//  BKCycleScrollView
//
//  Created by BIKE on 2018/6/6.
//  Copyright © 2018年 BIKE. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, BKCycleScrollPageControlAlignment) {
    BKCycleScrollPageAlignmentCenter = 0,
    BKCycleScrollPageAlignmentLeft,
    BKCycleScrollPageAlignmentRight,
};

typedef NS_ENUM(NSUInteger, BKCycleScrollPageControlStyle) {
    BKCycleScrollPageControlStyleNone = 0,      //不显示
    BKCycleScrollPageControlStyleNormalDots,    //小圆点形式
    BKCycleScrollPageControlStyleLongDots,      //选中变长圆点形式
};

@interface BKCycleScrollPageControl : UIView

/** 圆点总数 */
@property(nonatomic,assign) NSInteger numberOfPages;
/** 当前选中的圆点 */
@property(nonatomic,assign) NSInteger currentPage;

/** 小圆点样式 */
@property (nonatomic,assign) BKCycleScrollPageControlStyle style;
/** 小圆点对齐方式 */
@property (nonatomic,assign) BKCycleScrollPageControlAlignment alignment;
/** 小圆点之间的间距 默认7 */
@property (nonatomic,assign) CGFloat pageSpace;
/** 小圆点默认颜色 默认灰 */
@property (nonatomic,strong) UIColor * normalPageColor;
/** 小圆点默认颜色 默认白 */
@property (nonatomic,strong) UIColor * selectPageColor;
/** 小圆点默认图片 无默认 */
@property (nonatomic,strong) UIImage * normalPageImage;
/** 小圆点默认图片 无默认 */
@property (nonatomic,strong) UIImage * selectPageImage;

@end
