//
//  BKCycleScrollDataModel.h
//  BKCycleScrollView
//
//  Created by zhaolin on 2019/1/17.
//  Copyright © 2019年 BIKE. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface BKCycleScrollDataModel : NSObject

/**
 图片
 */
@property (nonatomic,strong) UIImage * image;
/**
 图片链接
 */
@property (nonatomic,copy) NSString * imageUrl;
/**
 图片data
 */
@property (nonatomic,strong) NSData * imageData;
/**
 数据类型是否为视频
 */
@property (nonatomic,assign,readonly) BOOL isVideo;
/**
 视频链接
 */
@property (nonatomic,copy) NSString * videoUrl;
/**
 视频当前播放时间
 */
@property (nonatomic,assign) NSTimeInterval currentTime;
/**
 视频总时间
 */
@property (nonatomic,assign) NSTimeInterval totalTime;

@end

NS_ASSUME_NONNULL_END
