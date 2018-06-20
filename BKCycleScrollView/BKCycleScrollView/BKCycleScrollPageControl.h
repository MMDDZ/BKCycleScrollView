//
//  BKCycleScrollPageControl.h
//  BKCycleScrollView
//
//  Created by BIKE on 2018/6/6.
//  Copyright © 2018年 BIKE. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BKCycleScrollView.h"

@interface BKCycleScrollPageControl : UIView

/** 圆点总数 */
@property(nonatomic,assign) NSInteger numberOfPages;
/** 当前选中的圆点 */
@property(nonatomic,assign) NSInteger currentPage;

/** 小圆点样式 */
@property (nonatomic,assign) BKCycleScrollPageControlStyle pageControlStyle;
/** 小圆点之间的间距 默认7 */
@property (nonatomic,assign) CGFloat dotSpace;
/** 小圆点默认颜色 默认灰 */
@property (nonatomic,strong) UIColor * normalDotColor;
/** 小圆点默认颜色 默认白 */
@property (nonatomic,strong) UIColor * selectDotColor;
/** 小圆点默认图片 无默认 */
@property (nonatomic,strong) UIImage * normalDotImage;
/** 小圆点默认图片 无默认 */
@property (nonatomic,strong) UIImage * selectDotImage;

@end
