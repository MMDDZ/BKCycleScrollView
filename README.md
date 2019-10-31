# BKCycleScrollView无限滚动视图

演示视图

![yanshi GIF](https://github.com/FOREVERIDIOT/BKCycleScrollView/blob/master/Images/yanshi.gif)

基本代码
```objc
BKCycleScrollView * cycleScrollView = [[BKCycleScrollView alloc] init];
[viewController.view addSubView:cycleScrollView];
```

代理
```objc
#pragma mark - 自定义cell

/// 自定义cell时获取数据数
/// @param cycleScrollView 无限滚动视图
/// @return 数据数
-(NSUInteger)numberOfItemsInCycleScrollView:(nonnull BKCycleScrollView *)cycleScrollView;

/// 自定义cell方法
/// @param cycleScrollView 无限滚动视图
/// @param index 显示自定义cell的索引
/// @return UICollectionViewCell
-(nonnull UICollectionViewCell *)cycleScrollView:(nonnull BKCycleScrollView *)cycleScrollView customCellForItemAtIndex:(NSInteger)index;

#pragma mark - 视频

/// 开始播放方法 (需要自己添加播放器并且播放，不实现这个代理无法播放)
/// @param cycleScrollView 无限滚动视图
/// @param playIndex 要播放的视频所在索引
/// @param superView 视频播放器所在的父视图
-(void)cycleScrollView:(nonnull BKCycleScrollView*)cycleScrollView playIndex:(NSUInteger)playIndex superView:(nonnull UIView*)superView;

/// 暂停播放方法 (需要自己暂停播放器，不实现这个代理无法暂停播放)
/// @param cycleScrollView 无限滚动视图
/// @param pauseIndex 要暂停播放的视频所在索引
-(void)cycleScrollView:(nonnull BKCycleScrollView *)cycleScrollView pauseIndex:(NSUInteger)pauseIndex;

/// 停止播放方法 (需要自己停止播放器，不实现这个代理无法停止播放)
/// @param cycleScrollView 无限滚动视图
/// @param stopIndex 要暂停播放的视频所在索引
-(void)cycleScrollView:(nonnull BKCycleScrollView *)cycleScrollView stopIndex:(NSUInteger)stopIndex;

#pragma mark - 滚动

/// 开始划动
/// @param cycleScrollView 无限滚动视图
/// @param scrollView 滑动视图
-(void)cycleScrollView:(nonnull BKCycleScrollView *)cycleScrollView scrollViewWillBeginDragging:(nonnull UIScrollView *)scrollView;

/// 滑动中
/// @param cycleScrollView 无限滚动视图
/// @param scrollView 滑动视图
-(void)cycleScrollView:(nonnull BKCycleScrollView *)cycleScrollView scrollViewDidScroll:(nonnull UIScrollView *)scrollView;

/// 结束划动
/// @param cycleScrollView 无限滚动视图
/// @param scrollView 滑动视图
/// @param decelerate 即将进行减速
-(void)cycleScrollView:(nonnull BKCycleScrollView *)cycleScrollView scrollViewDidEndDragging:(nonnull UIScrollView *)scrollView willDecelerate:(BOOL)decelerate;

/// 结束划动 带目标停止位置
/// @param cycleScrollView 无限滚动视图
/// @param scrollView 滑动视图
/// @param velocity 速度
/// @param targetContentOffset 目标停止位置
-(void)cycleScrollView:(nonnull BKCycleScrollView *)cycleScrollView scrollViewWillEndDragging:(nonnull UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(nonnull inout CGPoint *)targetContentOffset;

/// 结束惯性滑动
/// @param cycleScrollView 无限滚动视图
/// @param scrollView 滑动视图
-(void)cycleScrollView:(nonnull BKCycleScrollView *)cycleScrollView scrollViewDidEndDecelerating:(nonnull UIScrollView *)scrollView;
```

回调
```objc
/**
 点击item方法
 index 点中的索引
 imageView 显示的图片 非自定义cell时有值
 */
@property (nonatomic,copy) void (^clickItemCallBack)(NSInteger index, UIImageView * _Nullable imageView);

/**
 切换item回调
 */
@property (nonatomic,copy) void (^switchIndexCallBack)(NSUInteger index);
```

## Swift版BKCycleScrollView无限滚动视图链接
- [BKCycleScrollView-Swift](https://github.com/FOREVERIDIOT/BKCycleScrollView-Swift)

## 导入三方
- [SDWebImage](https://github.com/rs/SDWebImage)

## 版本记录
    2.0.4    修复当数据只有1条会崩溃的bug 此版本pod不添加播放器了，太大，上传下载太慢，下载完成自行update
    2.0.3    优化加载完网络图片后把图片赋值给model 修改播放完成后播放背景没有删除问题
    2.0.2    修复分页指示器的样式为None时还显示的问题。 添加是否无限循环属性
    2.0.1    当只有一个cell时，不显示分页指示器，只显示一个且不能滑动
    2.0.0    删除FLAnimatedImage，更新SDWebImage为5.1，删除ZFPlayer。 视频播放器跟无限滚动视图分开，sdk内不再提供播放器，只提供了播放器所在的视图。 
    1.2.2    更新ZFPlayer
    1.2.1    细节修改
    1.2.0    添加视频显示
    1.1.0    修复创建时不赋值崩溃bug，优化无数据时滚动视图不能滑动
    1.0.0    无限轮播第一版完成
    
    
    
    
    
    
    
