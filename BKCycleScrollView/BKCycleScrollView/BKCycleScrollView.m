//
//  BKCycleScrollView.m
//  BKCycleScrollView
//
//  Created by BIKE on 2018/5/25.
//  Copyright © 2018年 BIKE. All rights reserved.
//

#import "BKCycleScrollView.h"
#import "BKCycleCollectionViewFlowLayout.h"
#import "BKCycleScrollCollectionViewCell.h"
#import "BKCycleScrollPageControl.h"

NSInteger const kAllCount = 99999;//初始item数量
NSInteger const kMiddleCount = kAllCount/2-1;//item中间数

@interface BKCycleScrollView()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,UIScrollViewDelegate,UIGestureRecognizerDelegate>

@property (nonatomic,strong) UICollectionView * collectionView;

@property (nonatomic,strong) BKCycleScrollPageControl * pageControl;

@property (nonatomic,strong) NSIndexPath * beginIndexPath;//collectionView开始显示的indexPath
@property (nonatomic,assign) NSInteger currentIndex;//当前所看到数据的索引
@property (nonatomic,strong) NSIndexPath * displayIndexPath;//collectionView当前显示的indexPath

@property (nonatomic,strong) NSTimer * timer;

//@property (nonatomic,strong) UIPanGestureRecognizer * panGesture;

@end

@implementation BKCycleScrollView

#pragma mark - setter

-(void)setDisplayBackgroundColor:(UIColor *)displayBackgroundColor
{
    _displayBackgroundColor = displayBackgroundColor;
    if (_collectionView) {
        _collectionView.backgroundColor = _displayBackgroundColor;
    }
}

-(void)setDisplayDataArr:(NSArray *)displayDataArr
{
    _displayDataArr = displayDataArr;
    
    if (_collectionView) {
        
        self.currentIndex = 0;
        [self.collectionView reloadData];
        
        [self invalidateTimer];
        [self initTimer];
    }
    if (_pageControl) {
        self.pageControl.numberOfPages = [_displayDataArr count];
        self.pageControl.currentPage = 0;
    }
}

-(void)setAutoScrollTime:(CGFloat)autoScrollTime
{
    _autoScrollTime = autoScrollTime;
    
    [self invalidateTimer];
    [self initTimer];
}

/******************************************************************************/

-(void)setLayoutStyle:(BKDisplayCellLayoutStyle)layoutStyle
{
    _layoutStyle = layoutStyle;
    [self resetLayoutProperty];
}

-(void)setItemSpace:(CGFloat)itemSpace
{
    _itemSpace = itemSpace;
    [self resetLayoutProperty];
}

-(void)setItemWidth:(CGFloat)itemWidth
{
    _itemWidth = itemWidth;
    [self resetLayoutProperty];
}

-(void)setItemReduceScale:(CGFloat)itemReduceScale
{
    _itemReduceScale = itemReduceScale;
    [self resetLayoutProperty];
}

-(void)setRadius:(CGFloat)radius
{
    _radius = radius;
    if (_collectionView) {
        [_collectionView reloadData];
    }
}

/******************************************************************************/

-(void)setPageControlStyle:(BKCycleScrollPageControlStyle)pageControlStyle
{
    _pageControlStyle = pageControlStyle;
    
    if (_pageControlStyle == BKCycleScrollPageControlStyleNone) {
        [self.pageControl removeFromSuperview];
        self.pageControl = nil;
    }else{
        self.pageControl.pageControlStyle = _pageControlStyle;
    }
}

-(void)setDotHeight:(CGFloat)dotHeight
{
    _dotHeight = dotHeight;
    
    CGRect pageControlFrame = self.pageControl.frame;
    pageControlFrame.size.height = _dotHeight;
    pageControlFrame.origin.y = self.frame.size.height - _dotHeight - _dotBottomInset;
    self.pageControl.frame = pageControlFrame;
}

-(void)setDotSpace:(CGFloat)dotSpace
{
    _dotSpace = dotSpace;
    self.pageControl.dotSpace = _dotSpace;
}

-(void)setDotBottomInset:(CGFloat)dotBottomInset
{
    _dotBottomInset = dotBottomInset;
    CGRect pageControlFrame = self.pageControl.frame;
    pageControlFrame.origin.y = self.frame.size.height - pageControlFrame.size.height - _dotBottomInset;
    self.pageControl.frame = pageControlFrame;
}

-(void)setNormalDotColor:(UIColor *)normalDotColor
{
    _normalDotColor = normalDotColor;
    self.pageControl.normalDotColor = _normalDotColor;
}

-(void)setSelectDotColor:(UIColor *)selectDotColor
{
    _selectDotColor = selectDotColor;
    self.pageControl.selectDotColor = _selectDotColor;
}

-(void)setNormalDotImage:(UIImage *)normalDotImage
{
    _normalDotImage = normalDotImage;
    self.pageControl.normalDotImage = _normalDotImage;
}

-(void)setSelectDotImage:(UIImage *)selectDotImage
{
    _selectDotImage = selectDotImage;
    self.pageControl.selectDotImage = _selectDotImage;
}

#pragma mark - 初始化cell的Layout属性时重新创建collectionView

-(void)resetLayoutProperty
{
    if (_collectionView) {
        
        [_collectionView removeFromSuperview];
        _collectionView = nil;
        
        [self invalidateTimer];
        [self resetCurrentIndex:0 displayIndexPath:_beginIndexPath];
        [self collectionView];
        [self initTimer];
    }
    if (_pageControl) {
        self.pageControl.numberOfPages = [_displayDataArr count];
        self.pageControl.currentPage = 0;
    }
}

#pragma mark - delloc

- (void)dealloc
{
    [self invalidateTimer];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - init

- (void)willMoveToWindow:(UIWindow *)newWindow
{
    [super willMoveToWindow:newWindow];
    
    if (!newWindow) {
        [self invalidateTimer];
    }else{
        [self initTimer];
    }
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    if (!_collectionView) {
        
        self.currentIndex = 0;
        [self collectionView];
        
        [self invalidateTimer];
        [self initTimer];
    }
    if (!_pageControl) {
        [self pageControl];
    }
}

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initData];
    }
    return self;
}

-(instancetype)initWithFrame:(CGRect)frame displayDataArr:(NSArray*)displayDataArr
{
    self = [super initWithFrame:frame];
    if (self) {
        
        [self initData];
        
        self.displayDataArr = displayDataArr;
    }
    return self;
}

-(instancetype)initWithFrame:(CGRect)frame delegate:(id<BKCycleScrollViewDelegate>)delegate
{
    self = [super initWithFrame:frame];
    if (self) {
        
        [self initData];
        
        self.delegate = delegate;
    }
    return self;
}

-(instancetype)initWithFrame:(CGRect)frame delegate:(id<BKCycleScrollViewDelegate>)delegate displayDataArr:(NSArray*)displayDataArr
{
    self = [super initWithFrame:frame];
    if (self) {
        
        [self initData];
        
        self.delegate = delegate;
        self.displayDataArr = displayDataArr;
    }
    return self;
}

/**
 初始数据
 */
-(void)initData
{
    self.backgroundColor = [UIColor clearColor];
    self.displayBackgroundColor = [UIColor clearColor];
    self.autoScrollTime = 5;
    
    self.beginIndexPath = [NSIndexPath indexPathForItem:kMiddleCount inSection:0];
    self.displayIndexPath = self.beginIndexPath;
    self.currentIndex = 0;
    
    //    [self panGesture];
    
    self.itemSpace = 0;
    self.itemWidth = self.frame.size.width;
    self.itemReduceScale = 0.1;
    self.radius = 0;
    
    self.dotHeight = 7;
    self.dotSpace = 7;
    self.dotBottomInset = 10;
    self.normalDotColor = [UIColor lightGrayColor];
    self.selectDotColor = [UIColor whiteColor];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didEnterBackgroundNotification:) name:UIApplicationDidEnterBackgroundNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didBecomeActiveNotification:) name:UIApplicationDidBecomeActiveNotification object:nil];
}

/**
 当前看见的索引重新赋值
 
 @param currentIndex 当前所看到数据的索引
 @param displayIndexPath collectionView当前显示的indexPath
 */
-(void)resetCurrentIndex:(NSInteger)currentIndex displayIndexPath:(NSIndexPath*)displayIndexPath
{
    self.currentIndex = currentIndex;
    self.displayIndexPath = displayIndexPath;
    
    self.pageControl.currentPage = self.currentIndex;
}

#pragma mark - Notification

-(void)didEnterBackgroundNotification:(NSNotification*)notification
{
    [self invalidateTimer];
}

-(void)didBecomeActiveNotification:(NSNotification*)notification
{
    [self initTimer];
}

//#pragma mark - UIPanGestureRecognizer
//
//-(UIPanGestureRecognizer *)panGesture
//{
//    if (!_panGesture) {
//        _panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(selfPanGesture:)];
//        _panGesture.delegate = self;
//        _panGesture.minimumNumberOfTouches = 1;
//        _panGesture.maximumNumberOfTouches = 1;
//        [self addGestureRecognizer:_panGesture];
//    }
//    return _panGesture;
//}
//
//-(void)selfPanGesture:(UIPanGestureRecognizer*)panGesture
//{
//    CGPoint velocity = [panGesture velocityInView:panGesture.view];
//
//    switch (panGesture.state) {
//        case UIGestureRecognizerStateBegan:
//        {
//            [self invalidateTimer];
//        }
//            break;
//        case UIGestureRecognizerStateChanged:
//        {
//            CGFloat transitionX = [panGesture translationInView:panGesture.view].x;
//            [self.collectionView setContentOffset:CGPointMake(self.collectionView.contentOffset.x - transitionX, self.collectionView.contentOffset.y) animated:NO];
//        }
//            break;
//        case UIGestureRecognizerStateEnded:
//        case UIGestureRecognizerStateCancelled:
//        case UIGestureRecognizerStateFailed:
//        {
//            [self initTimer];
//
//            NSIndexPath * targetIndexPath = nil;//滑动目标IndexPath
//
//            if (velocity.x > 300) {//往右划,显示左边
//                targetIndexPath = [NSIndexPath indexPathForItem:self.displayIndexPath.item - 1 inSection:0];
//            }else if (velocity.x < -300) {//往左划,显示右边
//                targetIndexPath = [NSIndexPath indexPathForItem:self.displayIndexPath.item + 1 inSection:0];
//            }else{//移动量小于半屏回归原位 ; 大于半屏时 如果是负的往右划,显示左边 如果是正的往左划,显示右边
//
//                BKCycleScrollCollectionViewCell * cell = (BKCycleScrollCollectionViewCell*)[self.collectionView cellForItemAtIndexPath:self.displayIndexPath];
//                CGFloat screen_space = (self.collectionView.width - self.layout.itemSize.width) / 2;//item距屏幕的间距
//                CGFloat beginX = cell.frame.origin.x - screen_space;//手势滑动前初始的contentOffset.x
//                CGFloat scrollOffset = self.collectionView.contentOffset.x - beginX;//手势滑动结束时滑动的偏移量
//                CGFloat halfWidth = self.collectionView.frame.size.width/2;//屏幕的一半
//
//                if (scrollOffset > halfWidth) {
//                    targetIndexPath = [NSIndexPath indexPathForItem:self.displayIndexPath.item + 1 inSection:0];
//                }else if (scrollOffset < -halfWidth) {
//                    targetIndexPath = [NSIndexPath indexPathForItem:self.displayIndexPath.item - 1 inSection:0];
//                }else{
//                    targetIndexPath = self.displayIndexPath;
//                }
//            }
//
//            [self.collectionView scrollToItemAtIndexPath:targetIndexPath atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:YES];
//
//            NSInteger selectIndex = [self getDisplayIndexWithTargetIndexPath:targetIndexPath];
//            [self resetCurrentIndex:selectIndex displayIndexPath:targetIndexPath];
//        }
//            break;
//        default:
//            break;
//    }
//
//    [panGesture setTranslation:CGPointZero inView:panGesture.view];
//}
//
//#pragma mark - UIGestureRecognizerDelegate
//
//- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
//{
//    if (gestureRecognizer == self.panGesture) {
//        CGPoint point = [self.panGesture translationInView:self.panGesture.view];
//        if (fabs(point.y) > fabs(point.x)) {
//            self.panGesture.enabled = NO;
//            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//                self.panGesture.enabled = YES;
//            });
//        }else {
//            otherGestureRecognizer.enabled = NO;
//            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//                otherGestureRecognizer.enabled = YES;
//            });
//        }
//    }
//    return NO;
//}

#pragma mark - NSTimer

-(void)initTimer
{
    BOOL isHaveData = [self checkData];
    if (isHaveData) {
        [self timer];
    }
}

-(NSTimer*)timer
{
    if (!_timer) {
        _timer = [NSTimer scheduledTimerWithTimeInterval:5 target:self selector:@selector(autoScrollTimer:) userInfo:nil repeats:YES];
        [[NSRunLoop mainRunLoop] addTimer:_timer forMode:NSRunLoopCommonModes];
    }
    return _timer;
}

-(void)autoScrollTimer:(NSTimer*)timer
{
    if (_collectionView) {
        
        CGPoint point = [self convertPoint:self.collectionView.center toView:self.collectionView];
        NSIndexPath * currentIndexPath = [self.collectionView indexPathForItemAtPoint:point];
        
        NSIndexPath * nextIndexPath = [NSIndexPath indexPathForItem:currentIndexPath.item + 1 inSection:0];
        
        NSInteger selectIndex = [self getDisplayIndexWithTargetIndexPath:nextIndexPath];
        [self resetCurrentIndex:selectIndex displayIndexPath:nextIndexPath];
        
        [_collectionView scrollToItemAtIndexPath:self.displayIndexPath atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:YES];
    }
}

-(void)invalidateTimer
{
    [self.timer invalidate];
    self.timer = nil;
}

#pragma mark - UICollectionView

-(BOOL)checkData
{
    if ([self.displayDataArr count] > 0) {
        _collectionView.userInteractionEnabled = YES;
    }else {
        _collectionView.userInteractionEnabled = NO;
    }
    return _collectionView.userInteractionEnabled;
}

-(BKCycleCollectionViewFlowLayout *)resetLayout
{
    CGFloat left_right_inset = (self.frame.size.width - self.itemWidth)/2;
    
    BKCycleCollectionViewFlowLayout * layout = [[BKCycleCollectionViewFlowLayout alloc] init];
    layout.layoutStyle = _layoutStyle;
    layout.itemSpace = _itemSpace;
    layout.itemInset = UIEdgeInsetsMake(0, left_right_inset, 0, left_right_inset);
    layout.itemReduceScale = _itemReduceScale;
    
    return layout;
}

-(UICollectionView*)collectionView
{
    if (!_collectionView) {
        
        BKCycleCollectionViewFlowLayout * layout = [self resetLayout];
        
        _collectionView = [[UICollectionView alloc] initWithFrame:self.bounds collectionViewLayout:layout];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.backgroundColor = self.displayBackgroundColor?self.displayBackgroundColor:[UIColor clearColor];
        _collectionView.showsHorizontalScrollIndicator = NO;
        _collectionView.bounces = NO;
        _collectionView.decelerationRate = 0;
        //        _collectionView.scrollEnabled = NO; //如果不喜欢layout动画 可以解注释 和手势的注释
        if (@available(iOS 11.0, *)) {
            _collectionView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        }
        [_collectionView registerClass:[BKCycleScrollCollectionViewCell class] forCellWithReuseIdentifier:@"BKCycleScrollCollectionViewCell"];
        
        [_collectionView scrollToItemAtIndexPath:self.displayIndexPath atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:NO];
        
        [self checkData];
        
        if (_pageControl) {
            [self insertSubview:_collectionView belowSubview:_pageControl];
        }else{
            [self addSubview:_collectionView];
        }
    }
    return _collectionView;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return kAllCount;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    BKCycleScrollCollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"BKCycleScrollCollectionViewCell" forIndexPath:indexPath];
    
    NSInteger selectIndex = [self getDisplayIndexWithTargetIndexPath:indexPath];
    
    if ([self.delegate respondsToSelector:@selector(cycleScrollView:customDisplayCellStyleAtIndex:displayCell:)]) {
        [[cell subviews] makeObjectsPerformSelector:@selector(removeFromSuperview)];
        [self.delegate cycleScrollView:self customDisplayCellStyleAtIndex:selectIndex displayCell:cell];
        return cell;
    }
    
    cell.radius = self.radius;
    cell.placeholderImage = self.placeholderImage;
    if ([self.displayDataArr count] > selectIndex) {
        cell.dataObj = self.displayDataArr[selectIndex];
    }
    
    return cell;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    [self invalidateTimer];
    [self initTimer];
    
    NSInteger selectIndex = [self getDisplayIndexWithTargetIndexPath:indexPath];
    if (self.selectItemAction) {
        self.selectItemAction(selectIndex);
    }
}

/**
 获取目标indexPath显示的index
 
 @param indexPath 无线循环view上的目标显示的indexPath
 @return 实际显示的index数据
 */
-(NSInteger)getDisplayIndexWithTargetIndexPath:(NSIndexPath*)indexPath
{
    NSInteger currentIndex = indexPath.item;
    
    NSInteger selectIndex = _currentIndex;
    if (currentIndex != self.displayIndexPath.item) {
        selectIndex = selectIndex - (self.displayIndexPath.item - currentIndex);
    }
    
    NSInteger count = [self.displayDataArr count];
    if (selectIndex < 0) {
        selectIndex = (count + selectIndex % count) % count;
    }else if (selectIndex > count - 1) {
        selectIndex = selectIndex % count;
    }
    
    return selectIndex;
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [self invalidateTimer];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    [self initTimer];
}

- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset
{
    //因为偏移量最终位置collectionView一屏中显示3个item 滚动停止后targetContentOffset肯定比目前显示cell的item小1 所以偏移量x调成了中心
    //因为缩放原因 cell的y值不一定为0 所以把偏移量y调成了中心
    CGPoint newTargetContentOffset = CGPointMake((*targetContentOffset).x + self.collectionView.frame.size.width/2, self.collectionView.frame.size.height/2);
    NSIndexPath * currentIndexPath = [self.collectionView indexPathForItemAtPoint:newTargetContentOffset];
    NSInteger selectIndex = [self getDisplayIndexWithTargetIndexPath:currentIndexPath];
    [self resetCurrentIndex:selectIndex displayIndexPath:currentIndexPath];
}

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    [self scrollViewDidEndScrollingAnimation:scrollView];
}

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView
{
    //延迟0s 防止定时器动画结束刹那闪屏现象
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        NSArray * visibleIndexPaths = [self.collectionView indexPathsForVisibleItems];
        __block BOOL isExist = NO;
        [visibleIndexPaths enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            NSIndexPath * indexPath = obj;
            //为了适配一屏显示多个时 返回滚动不出现bug 建议目前滚动item与初始item相差屏幕显示最大item数量*2 我这默认设置成99
            if (self.beginIndexPath.item + 99 > indexPath.item) {
                isExist = YES;
                *stop = YES;
            }
        }];
        
        if (!isExist) {
            self.displayIndexPath = self.beginIndexPath;
            [self.collectionView scrollToItemAtIndexPath:self.displayIndexPath atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:NO];
        }
    });
}

#pragma mark - BKCycleScrollPageControl

-(BKCycleScrollPageControl*)pageControl
{
    if (_pageControlStyle != BKCycleScrollPageControlStyleNone) {
        if (!_pageControl) {
            _pageControl = [[BKCycleScrollPageControl alloc] initWithFrame:CGRectMake(0, self.frame.size.height - self.dotBottomInset - self.dotHeight, self.frame.size.width, self.dotHeight)];
            _pageControl.numberOfPages = [_displayDataArr count];
            _pageControl.currentPage = 0;
            _pageControl.pageControlStyle = _pageControlStyle;
            _pageControl.dotSpace = _dotSpace;
            _pageControl.normalDotColor = _normalDotColor;
            _pageControl.selectDotColor = _selectDotColor;
            _pageControl.normalDotImage = _normalDotImage;
            _pageControl.selectDotImage = _selectDotImage;
            [self addSubview:_pageControl];
        }
    }
    return _pageControl;
}

@end
