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
 视频链接
 */
@property (nonatomic,copy) NSString * videoUrl;
/**
 数据类型是否为视频(videoUrl有值即为YES，反之为NO)
 */
@property (nonatomic,assign,readonly) BOOL isVideo;

@end

NS_ASSUME_NONNULL_END
