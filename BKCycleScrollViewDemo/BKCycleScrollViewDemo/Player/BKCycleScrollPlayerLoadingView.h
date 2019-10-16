//
//  BKCycleScrollPlayerLoadingView.h
//  DSCnliveShopSDK
//
//  Created by zhaolin on 2019/5/8.
//  Copyright © 2019 BIKE. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface BKCycleScrollPlayerLoadingView : UIView

/**
 是否在加载中
 */
@property (nonatomic,assign,readonly) BOOL isLoading;

#pragma mark - 方法

/**
 开启动画
 */
-(void)startAnimate;
/**
 结束动画
 */
-(void)stopAnimate;

@end

NS_ASSUME_NONNULL_END
