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
#import <BKTimer/BKTimer.h>

NSInteger const kAllCount = 999;//初始item数量
NSInteger const kMiddleCount = kAllCount/2-1;//item中间数
NSInteger const kBKCycleScrollViewNoPlayIndex = -1;//没有播放索引
NSString * const kBKCycleScrollCollectionViewCellID = @"BKCycleScrollCollectionViewCell";

@interface BKCycleScrollView()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,UIScrollViewDelegate,UIGestureRecognizerDelegate>

@property (nonatomic,strong) UICollectionView * collectionView;

@property (nonatomic,strong) NSIndexPath * beginIndexPath;//collectionView开始显示的indexPath
@property (nonatomic,strong) NSIndexPath * displayIndexPath;//collectionView当前显示的indexPath

@property (nonatomic,weak) dispatch_source_t timer;

@property (nonatomic,strong) UIView * playerBgView;//播放视频view(该SDK没有添加视频控件，需要自己addSubView)
@property (nonatomic,assign) NSInteger playIndex;//播放所在的索引 kBKCycleScrollViewNoPlayIndex代表已经停止播放
@property (nonatomic,assign) BOOL isPlaying;//是否正在播放中 YES播放 NO暂停/停止

@property (nonatomic,assign) BOOL isCustomCell;//是否是自定义Cell

@end

@implementation BKCycleScrollView
@synthesize pageControl = _pageControl;

#pragma mark - BKCycleScrollView属性

-(void)setDisplayBackgroundColor:(UIColor *)displayBackgroundColor
{
    _displayBackgroundColor = displayBackgroundColor;
    self.collectionView.backgroundColor = _displayBackgroundColor;
}

-(void)setDisplayDataArr:(NSArray<BKCycleScrollDataModel *> *)displayDataArr
{
    _displayDataArr = displayDataArr;

    [self privateStopVideo];
    [self invalidateTimer];

    self.currentIndex = 0;
    [self.collectionView reloadData];
    if ([_displayDataArr count] > 0) {
        self.collectionView.userInteractionEnabled = YES;
        [self.collectionView scrollToItemAtIndexPath:self.displayIndexPath atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:NO];
    }else {
        self.collectionView.userInteractionEnabled = NO;
    }

    self.pageControl.numberOfPages = [_displayDataArr count];
    self.pageControl.currentPage = 0;

    [self initTimer];
}

-(void)setCurrentIndex:(NSInteger)currentIndex
{
    _currentIndex = currentIndex;

    self.pageControl.currentPage = self.currentIndex;
    [self.collectionView reloadData];

    [self invalidateTimer];
    [self initTimer];
}

-(void)setIsAutoScroll:(BOOL)isAutoScroll
{
    _isAutoScroll = isAutoScroll;

    [self invalidateTimer];
    [self initTimer];
}

-(void)setAutoScrollTime:(CGFloat)autoScrollTime
{
    _autoScrollTime = autoScrollTime;

    [self invalidateTimer];
    [self initTimer];
}

-(void)setPagingEnabled:(BOOL)pagingEnabled
{
    _pagingEnabled = pagingEnabled;
    self.collectionView.collectionViewLayout = [self resetLayout];
    [self resetCellPosition];
}

-(void)setIsAllowScroll:(BOOL)isAllowScroll
{
    _isAllowScroll = isAllowScroll;
    self.collectionView.scrollEnabled = _isAllowScroll;
}

#pragma mark - cell属性

-(void)setLayoutStyle:(BKDisplayCellLayoutStyle)layoutStyle
{
    _layoutStyle = layoutStyle;
    self.collectionView.collectionViewLayout = [self resetLayout];
    [self resetCellPosition];
}

-(void)setItemSpace:(CGFloat)itemSpace
{
    _itemSpace = itemSpace;
    self.collectionView.collectionViewLayout = [self resetLayout];
    [self resetCellPosition];
}

-(void)setItemWidth:(CGFloat)itemWidth
{
    _itemWidth = itemWidth;
    self.collectionView.collectionViewLayout = [self resetLayout];
    [self resetCellPosition];
}

-(void)setItemReduceScale:(CGFloat)itemReduceScale
{
    _itemReduceScale = itemReduceScale;
    self.collectionView.collectionViewLayout = [self resetLayout];
    [self resetCellPosition];
}

-(void)setRadius:(CGFloat)radius
{
    _radius = radius;
    [self.collectionView reloadData];
}

#pragma mark - 小圆点属性

-(void)setPageControlHeight:(CGFloat)pageControlHeight
{
    _pageControlHeight = pageControlHeight;

    CGRect pageControlFrame = self.pageControl.frame;
    pageControlFrame.size.height = _pageControlHeight;
    pageControlFrame.origin.y = self.frame.size.height - _pageControlHeight - _pageControlContentInset.bottom;
    self.pageControl.frame = pageControlFrame;
}

-(void)setPageControlContentInset:(UIEdgeInsets)pageControlContentInset
{
    _pageControlContentInset = pageControlContentInset;
    CGRect pageControlFrame = self.pageControl.frame;
    pageControlFrame.origin.x = _pageControlContentInset.left;
    pageControlFrame.origin.y = self.frame.size.height - pageControlFrame.size.height - _pageControlContentInset.bottom;
    pageControlFrame.size.width = self.frame.size.width - pageControlFrame.origin.x - _pageControlContentInset.right;
    self.pageControl.frame = pageControlFrame;
}

#pragma mark - 公开方法

/**
 获取显示的索引
 */
-(NSArray<NSNumber*>*)visibleIndexs
{
    NSMutableArray * indexs = [NSMutableArray array];
    [[self.collectionView indexPathsForVisibleItems] enumerateObjectsUsingBlock:^(NSIndexPath * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [indexs addObject:@([self getDisplayIndexWithTargetIndexPath:obj])];
    }];
    return [indexs copy];
}

/**
 重置cell的位置
 */
-(void)resetCellPosition
{
    if ([self.displayDataArr count] > 0) {
        [self.collectionView scrollToItemAtIndexPath:self.displayIndexPath atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:NO];
    }
}

/**
 刷新无限轮播视图
 */
-(void)reloadData
{
    if ([self.delegate respondsToSelector:@selector(numberOfItemsInCycleScrollView:)]) {
        NSUInteger number = [self.delegate numberOfItemsInCycleScrollView:self];
        NSMutableArray * displayDataArr = [NSMutableArray array];
        for (int i = 0; i < number; i++) {
            BKCycleScrollDataModel * model = [[BKCycleScrollDataModel alloc] init];
            [displayDataArr addObject:model];
        }
        self.displayDataArr = [displayDataArr copy];
    }
    [self.collectionView reloadData];
}

#pragma mark - 自定义cell

-(void)registerClass:(Class)cellClass forCustomCellWithReuseIdentifier:(NSString *)identifier
{
    [self.collectionView registerClass:cellClass forCellWithReuseIdentifier:identifier];
}

-(__kindof UICollectionViewCell*)dequeueReusableCustomCellWithReuseIdentifier:(NSString *)identifier forIndex:(NSUInteger)index
{
    return [self.collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:[NSIndexPath indexPathForItem:index inSection:0]];
}

#pragma mark - delloc

-(void)dealloc
{
    [self privateStopVideo];
    [self invalidateTimer];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - init

-(instancetype)init
{
    self = [super init];
    if (self) {
        [self initData];
        [self addSubview:self.collectionView];
        [self addSubview:self.pageControl];
    }
    return self;
}

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initData];
        [self addSubview:self.collectionView];
        [self addSubview:self.pageControl];
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
    self.isAutoScroll = YES;
    self.autoScrollTime = 5;
    self.pagingEnabled = YES;
    
    self.beginIndexPath = [NSIndexPath indexPathForItem:kMiddleCount inSection:0];
    self.displayIndexPath = self.beginIndexPath;
    self.currentIndex = 0;
    
    self.itemSpace = 0;
    self.itemWidth = self.frame.size.width;
    self.itemReduceScale = 0.1;
    self.radius = 0;
    
    self.pageControlHeight = 7;
    self.pageControlContentInset = UIEdgeInsetsMake(0, 10, 10, 10);
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didEnterBackgroundNotification:) name:UIApplicationDidEnterBackgroundNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didBecomeActiveNotification:) name:UIApplicationDidBecomeActiveNotification object:nil];
}

-(void)willMoveToWindow:(UIWindow *)newWindow
{
    [super willMoveToWindow:newWindow];
    
    if (!newWindow) {
        [self privateStopVideo];
        [self invalidateTimer];
    }else{
        [self initTimer];
    }
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    
    if (self.itemWidth == 0) {
        self.itemWidth = self.frame.size.width;
        self.collectionView.collectionViewLayout = [self resetLayout];
        [self resetCellPosition];
    }
    self.collectionView.frame = self.bounds;
    self.pageControl.frame = CGRectMake(self.pageControlContentInset.left, self.frame.size.height - self.pageControlContentInset.bottom - self.pageControlHeight, self.frame.size.width - self.pageControlContentInset.left - self.pageControlContentInset.right, self.pageControlHeight);
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

#pragma mark - 视频

-(UIView*)playerBgView
{
    if (!_playerBgView) {
        _playerBgView = [[UIView alloc] init];
        _playerBgView.backgroundColor = [UIColor redColor];
    }
    return _playerBgView;
}

/// 开始播放
-(void)playVideo
{
    if (self.isCustomCell) {
        return;
    }
    
    self.isPlaying = YES;
}

/// 暂停播放
-(void)pauseVideo
{
    if (self.isCustomCell) {
        return;
    }
    
    self.isPlaying = NO;
}

/// 停止播放
-(void)stopVideo
{
    if (self.isCustomCell) {
        return;
    }
    
    self.isPlaying = NO;
    [self.playerBgView removeFromSuperview];
    self.playerBgView = nil;
}

/// 内部暂停播放方法
-(void)privatePauseVideo
{
    if (self.isCustomCell) {
        return;
    }
    
    if (!self.isPlaying) {
        return;
    }
    
    __block BOOL isExist = NO;
    [[self.collectionView visibleCells] enumerateObjectsUsingBlock:^(__kindof UICollectionViewCell * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        BKCycleScrollCollectionViewCell * cell = (BKCycleScrollCollectionViewCell*)obj;
        if (cell.currentIndex == self.playIndex) {
            isExist = YES;
            *stop = YES;
        }
    }];
    if (!isExist && self.isPlaying) {
        self.isPlaying = NO;
        if ([self.delegate respondsToSelector:@selector(cycleScrollView:pauseIndex:)]) {
            [self.delegate cycleScrollView:self pauseIndex:self.playIndex];
        }
    }
}

-(void)privateStopVideo
{
    if (self.playIndex != kBKCycleScrollViewNoPlayIndex) {
        if ([self.delegate respondsToSelector:@selector(cycleScrollView:stopIndex:)]) {
            [self.delegate cycleScrollView:self stopIndex:self.playIndex];
        }
        self.playIndex = kBKCycleScrollViewNoPlayIndex;
    }
}

#pragma mark - 修改displayDataArr数据(不走setter的赋值)

/**
 修改displayDataArr数据(不走setter的赋值)
 
 @param dataArr 数据
 */
-(void)assignDisplayDataArr:(NSArray*)dataArr
{
    _displayDataArr = [dataArr copy];
}

#pragma mark - NSTimer

-(void)initTimer
{
    if (!self.isAutoScroll) {
        return;
    }
    if ([self.displayDataArr count] > 0) {
        [self invalidateTimer];
        self.timer = [BKTimer bk_setupTimerWithTimeInterval:5 totalTime:kBKTimerRepeatsTime handler:^(dispatch_source_t timer, CGFloat lastTime) {
            [self timerExecutionMethod];
        }];
    }
}

-(void)timerExecutionMethod
{
    if (_collectionView) {
        CGPoint point = [self convertPoint:_collectionView.center toView:_collectionView];
        NSIndexPath * currentIndexPath = [_collectionView indexPathForItemAtPoint:point];
        
        NSIndexPath * nextIndexPath = [NSIndexPath indexPathForItem:currentIndexPath.item + 1 inSection:0];
        
        NSInteger selectIndex = [self getDisplayIndexWithTargetIndexPath:nextIndexPath];
        [self resetCurrentIndex:selectIndex displayIndexPath:nextIndexPath];
        
        [_collectionView scrollToItemAtIndexPath:self.displayIndexPath atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:YES];
    }
}

-(void)invalidateTimer
{
    [BKTimer bk_removeTimer:self.timer];
    self.timer = nil;
}

#pragma mark - 给前看见的索引重新赋值

/**
 给前看见的索引重新赋值
 
 @param currentIndex 当前所看到数据的索引
 @param displayIndexPath collectionView当前显示的indexPath
 */
-(void)resetCurrentIndex:(NSInteger)currentIndex displayIndexPath:(NSIndexPath*)displayIndexPath
{
    if (self.currentIndex == currentIndex && self.displayIndexPath == displayIndexPath) {
        return;
    }
    self.currentIndex = currentIndex;
    self.displayIndexPath = displayIndexPath;
    
    if (self.switchIndexCallBack) {
        self.switchIndexCallBack(self.currentIndex);
    }
    
    self.pageControl.currentPage = self.currentIndex;
}

#pragma mark - UICollectionView

-(BKCycleCollectionViewFlowLayout *)resetLayout
{
    CGFloat left_right_inset = (self.frame.size.width - self.itemWidth)/2;
    
    BKCycleCollectionViewFlowLayout * layout = [[BKCycleCollectionViewFlowLayout alloc] init];
    layout.pagingEnabled = self.pagingEnabled;
    layout.layoutStyle = self.layoutStyle;
    layout.itemSpace = self.itemSpace;
    layout.itemInset = UIEdgeInsetsMake(0, left_right_inset, 0, left_right_inset);
    layout.itemReduceScale = self.itemReduceScale;
    
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
        _collectionView.clipsToBounds = NO;
        _collectionView.userInteractionEnabled = NO;
        _collectionView.decelerationRate = UIScrollViewDecelerationRateFast;
        if (@available(iOS 11.0, *)) {
            _collectionView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        }
        [_collectionView registerClass:[BKCycleScrollCollectionViewCell class] forCellWithReuseIdentifier:kBKCycleScrollCollectionViewCellID];
    }
    return _collectionView;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [self.displayDataArr count] == 0 ? 0 : kAllCount;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger selectIndex = [self getDisplayIndexWithTargetIndexPath:indexPath];
    
    if ([self.delegate respondsToSelector:@selector(cycleScrollView:customCellForItemAtIndex:)]) {
        self.isCustomCell = YES;
        UICollectionViewCell * cell = [self.delegate cycleScrollView:self customCellForItemAtIndex:selectIndex];
        return cell;
    }
    
    self.isCustomCell = NO;
    
    BKCycleScrollCollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:kBKCycleScrollCollectionViewCellID forIndexPath:indexPath];
    __weak typeof(self) weakSelf = self;
    [cell setClickPlayBtnCallBack:^(BKCycleScrollCollectionViewCell *currentCell, NSUInteger currentIndex) {
        BKCycleScrollDataModel * dataModel = weakSelf.displayDataArr[currentIndex];
        if ([dataModel.videoUrl length] > 0) {
            weakSelf.playIndex = currentIndex;
            [currentCell addSubview:weakSelf.playerBgView];
            weakSelf.playerBgView.frame = CGRectMake(0, 0, currentCell.frame.size.width, currentCell.frame.size.height);
            if ([weakSelf.delegate respondsToSelector:@selector(cycleScrollView:playIndex:superView:)]) {
                [weakSelf.delegate cycleScrollView:weakSelf playIndex:weakSelf.playIndex superView:weakSelf.playerBgView];
            }
            weakSelf.isPlaying = YES;
        }
    }];
    
    cell.radius = self.radius;
    cell.placeholderImage = self.placeholderImage;
    if ([self.displayDataArr count] > selectIndex) {
        cell.currentIndex = selectIndex;
        cell.dataObj = self.displayDataArr[selectIndex];
    }
    
    return cell;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    [self invalidateTimer];
    [self initTimer];
    
    NSInteger selectIndex = [self getDisplayIndexWithTargetIndexPath:indexPath];
    UICollectionViewCell * cell = [self.collectionView cellForItemAtIndexPath:indexPath];
    if ([cell isKindOfClass:[BKCycleScrollCollectionViewCell class]]) {
        BKCycleScrollCollectionViewCell * cycleScrollCell = (BKCycleScrollCollectionViewCell*)cell;
        if (self.selectItemAction) {
            self.selectItemAction(selectIndex, cycleScrollCell.displayImageView);
        }
    }else {
        if (self.selectItemAction) {
            self.selectItemAction(selectIndex, nil);
        }
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
    if (count == 0) {
        selectIndex = 0;
    }else {
        if (selectIndex < 0) {
            selectIndex = (count + selectIndex % count) % count;
        }else if (selectIndex > count - 1) {
            selectIndex = selectIndex % count;
        }
    }

    return selectIndex;
}

#pragma mark - UIScrollViewDelegate

-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if ([self.delegate respondsToSelector:@selector(cycleScrollView:scrollViewDidScroll:)]) {
        [self.delegate cycleScrollView:self scrollViewDidScroll:scrollView];
    }
    [self privatePauseVideo];
}

-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    if ([self.delegate respondsToSelector:@selector(cycleScrollView:scrollViewWillBeginDragging:)]) {
        [self.delegate cycleScrollView:self scrollViewWillBeginDragging:scrollView];
    }
    [self invalidateTimer];
}

-(void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    [self initTimer];
}

-(void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset
{
    if (self.pagingEnabled) {
        //因为偏移量最终位置collectionView一屏中显示3个item 滚动停止后targetContentOffset肯定比目前显示cell的item小1 所以偏移量x调成了中心
        //因为缩放原因 cell的y值不一定为0 所以把偏移量y调成了中心
        CGPoint newTargetContentOffset = CGPointMake((*targetContentOffset).x + self.collectionView.frame.size.width/2, self.collectionView.frame.size.height/2);
        NSIndexPath * currentIndexPath = [self.collectionView indexPathForItemAtPoint:newTargetContentOffset];
        NSInteger selectIndex = [self getDisplayIndexWithTargetIndexPath:currentIndexPath];
        [self resetCurrentIndex:selectIndex displayIndexPath:currentIndexPath];
    }
}

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    if ([self.delegate respondsToSelector:@selector(cycleScrollView:scrollViewDidEndDecelerating:)]) {
        [self.delegate cycleScrollView:self scrollViewDidEndDecelerating:scrollView];
    }
    [self scrollViewDidEndScrollingAnimation:scrollView];
    [self privatePauseVideo];
}

#pragma mark - 停止滚动后 修改当前所在indexPath

-(void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView
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
    if (!_pageControl) {
        _pageControl = [[BKCycleScrollPageControl alloc] initWithFrame:CGRectMake(self.pageControlContentInset.left, self.frame.size.height - self.pageControlContentInset.bottom - self.pageControlHeight, self.frame.size.width - self.pageControlContentInset.left - self.pageControlContentInset.right, self.pageControlHeight)];
        _pageControl.numberOfPages = [_displayDataArr count];
        _pageControl.currentPage = 0;
    }
    return _pageControl;
}

-(void)setPageControl:(BKCycleScrollPageControl * _Nonnull)pageControl
{
    _pageControl = pageControl;
}

@end
