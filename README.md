# BKCycleScrollView无限滚动视图

演示视图

![yanshi GIF](https://github.com/FOREVERIDIOT/BKCycleScrollView/blob/master/Images/yanshi.gif)

基本代码
```objc
BKCycleScrollView * cycleScrollView = [[BKCycleScrollView alloc] initWithFrame:(CGRect) delegate:(id<BKCycleScrollViewDelegate>) displayDataArr:(NSArray *)];
[viewController.view addSubView:cycleScrollView];
```
点击回调
```objc
[cycleScrollView setSelectItemAction:^(NSInteger index) {
NSLog(@"点击了 cycleScrollView 上 索引%ld的item",index);
}];
```

## Swift版BKCycleScrollView无限滚动视图链接
-[BKCycleScrollView-Swift](https://github.com/FOREVERIDIOT/BKCycleScrollView-Swift)

## 导入三方
- [FLAnimatedImage](https://github.com/Flipboard/FLAnimatedImage)
- [SDWebImage](https://github.com/rs/SDWebImage)

## 版本
    1.0 无限轮播第一版完成
