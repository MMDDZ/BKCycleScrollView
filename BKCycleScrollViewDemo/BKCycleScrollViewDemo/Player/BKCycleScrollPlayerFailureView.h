//
//  BKCycleScrollPlayerFailureView.h
//  DSCnliveShopSDK
//
//  Created by zhaolin on 2019/5/9.
//  Copyright © 2019 BIKE. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface BKCycleScrollPlayerFailureView : UIView

#pragma mark - 属性

@property (nonatomic,copy) NSString * errorMessage;//失败原因

#pragma mark - 回调

@property (nonatomic,copy) void (^clickRefreshCallBack)(void);//点击刷新回调

@end

NS_ASSUME_NONNULL_END
