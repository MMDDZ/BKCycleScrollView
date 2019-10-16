//
//  ViewController.m
//  BKCycleScrollViewDemo
//
//  Created by zhaolin on 2019/10/12.
//  Copyright © 2019 BIKE. All rights reserved.
//

#import "ViewController.h"
#import <BKCycleScrollView/BKCycleScrollView.h>
#import "BKCycleScrollPlayerView.h"

@interface ViewController () <BKCycleScrollViewDelegate>

@property (nonatomic,strong) NSArray * localImageArr;
@property (nonatomic,strong) NSArray * netImageArr;
@property (nonatomic,strong) NSArray * netImageArr2;

@property (nonatomic,strong) BKCycleScrollView * cycleScrollView1;
@property (nonatomic,strong) BKCycleScrollView * cycleScrollView2;
@property (nonatomic,strong) BKCycleScrollView * cycleScrollView3;

@property (nonatomic,strong) BKCycleScrollPlayerView * playerView;

@end

@implementation ViewController

#pragma mark - viewDidLoad

-(void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor whiteColor];
        
    NSURL * imageUrl = [[NSBundle mainBundle] URLForResource:@"4" withExtension:@"gif"];
    NSArray * images1 = @[[UIImage imageNamed:@"1"], [UIImage imageNamed:@"2"], [UIImage imageNamed:@"5"], UIImageJPEGRepresentation([UIImage imageNamed:@"3"], 1), [NSData dataWithContentsOfURL:imageUrl]];
    NSMutableArray * datas1 = [NSMutableArray array];
    for (int i = 0; i < [images1 count]; i++) {
        BKCycleScrollDataModel * dataModel = [[BKCycleScrollDataModel alloc] init];
        if (i == 0 || i == 1) {
            dataModel.image = images1[i];
        }else if (i == 2) {
            dataModel.image = images1[i];
            dataModel.videoUrl = @"https://vd4.bdstatic.com/mda-ie76sgt45m94hzaw/logo/sc/mda-ie76sgt45m94hzaw.mp4";
        }else {
            dataModel.imageData = images1[i];
        }
        [datas1 addObject:dataModel];
    }
    self.localImageArr = [datas1 copy];
        
    NSArray * images2 = @[@"http://photocdn.sohu.com/20120625/Img346436472.jpg", @"http://photocdn.sohu.com/20120625/Img346436473.jpg", @"http://photocdn.sohu.com/20120625/Img346436474.jpg"];
    NSMutableArray * datas2 = [NSMutableArray array];
    for (int i = 0; i < [images2 count]; i++) {
        BKCycleScrollDataModel * dataModel = [[BKCycleScrollDataModel alloc] init];
        dataModel.imageUrl = images2[i];
        [datas2 addObject:dataModel];
    }
    self.netImageArr = [datas2 copy];
        
    NSArray * images3 = @[@"http://img.taopic.com/uploads/allimg/140118/234914-14011PZ32692.jpg",@"http://pic1.win4000.com/wallpaper/5/58c74e21e2228.jpg",@"http://imgsrc.baidu.com/imgad/pic/item/42a98226cffc1e17d453210c4190f603738de91b.jpg",@"https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1529388176527&di=7a047e6e2c065af002f71b594793d777&imgtype=0&src=http%3A%2F%2Fimg.zcool.cn%2Fcommunity%2F01c3cf5544d0c70000019ae97686ea.jpg",@"http://img.mp.sohu.com/upload/20170801/8b8854e3a09245b68e2058fc8b30fc02_th.png"];
    NSMutableArray * datas3 = [NSMutableArray array];
    for (int i = 0; i < [images3 count]; i++) {
        BKCycleScrollDataModel * dataModel = [[BKCycleScrollDataModel alloc] init];
        dataModel.imageUrl = images3[i];
        [datas3 addObject:dataModel];
    }
    self.netImageArr2 = [datas3 copy];
        
    [self.view addSubview:self.cycleScrollView1];
    [self.view addSubview:self.cycleScrollView2];
    [self.view addSubview:self.cycleScrollView3];
}

#pragma mark - BKCycleScrollView1

-(BKCycleScrollView*)cycleScrollView1
{
    if (!_cycleScrollView1) {
        
        _cycleScrollView1 = [[BKCycleScrollView alloc] initWithFrame:CGRectMake(0, [UIApplication sharedApplication].statusBarFrame.size.height + 20, self.view.frame.size.width, 150)];
        _cycleScrollView1.displayDataArr = self.netImageArr;
        _cycleScrollView1.layoutStyle = BKDisplayCellLayoutStyleMiddleLarger;
        _cycleScrollView1.itemSpace = -18;
        _cycleScrollView1.itemWidth = self.view.frame.size.width - 40;
        _cycleScrollView1.itemReduceScale = 0.1;
        _cycleScrollView1.radius = 12;
        _cycleScrollView1.isAutoScroll = NO;
        
        [_cycleScrollView1 setClickItemCallBack:^(NSInteger index, UIImageView * _Nullable imageView) {
            NSLog(@"点击了 _cycleScrollView1 上 索引%ld的item",(long)index);
        }];
    }
    return _cycleScrollView1;
}

#pragma mark - BKCycleScrollView2

-(BKCycleScrollView*)cycleScrollView2
{
    if (!_cycleScrollView2) {
        _cycleScrollView2 = [[BKCycleScrollView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.cycleScrollView1.frame) + 40, self.view.frame.size.width, 150)];
        _cycleScrollView2.delegate = self;
        _cycleScrollView2.displayDataArr = self.localImageArr;
        _cycleScrollView2.isAutoScroll = NO;
        _cycleScrollView2.layoutStyle = BKDisplayCellLayoutStyleNormal;
        _cycleScrollView2.pageControl.style = BKCycleScrollPageControlStyleNumberLab;
        _cycleScrollView2.pageControl.alignment = BKCycleScrollPageAlignmentRight;
        
        [_cycleScrollView2 setClickItemCallBack:^(NSInteger index, UIImageView * _Nullable imageView) {
            NSLog(@"点击了 _cycleScrollView2 上 索引%ld的item",(long)index);
        }];
    }
    return _cycleScrollView2;
}

#pragma mark - BKCycleScrollView3

-(BKCycleScrollView*)cycleScrollView3
{
    if (!_cycleScrollView3) {
        
        _cycleScrollView3 = [[BKCycleScrollView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.cycleScrollView2.frame) + 40, self.view.frame.size.width, 150)];
        _cycleScrollView3.displayDataArr = self.netImageArr2;
        _cycleScrollView3.placeholderImage = [UIImage imageNamed:@"placeholder"];
        _cycleScrollView3.layoutStyle = BKDisplayCellLayoutStyleMiddleLarger;
        _cycleScrollView3.itemSpace = 0;
        _cycleScrollView3.itemWidth = 50;
        _cycleScrollView3.itemReduceScale = 0.2;
        _cycleScrollView3.radius = 0;
        _cycleScrollView3.pageControl.style = BKCycleScrollPageControlStyleLongDots;
        _cycleScrollView3.pageControl.normalPageColor = [UIColor yellowColor];
        _cycleScrollView3.pageControl.selectPageColor = [UIColor brownColor];
        
        [_cycleScrollView3 setClickItemCallBack:^(NSInteger index, UIImageView * _Nullable imageView) {
            NSLog(@"点击了 _cycleScrollView3 上 索引%ld的item",(long)index);
        }];
    }
    return _cycleScrollView3;
}

#pragma mark - BKCycleScrollViewDelegate

/// 开始播放方法 (需要自己添加播放器并且播放，不实现这个代理无法播放)
/// @param cycleScrollView 无限滚动视图
/// @param playIndex 要播放的视频所在索引
/// @param superView 视频播放器所在的父视图
-(void)cycleScrollView:(nonnull BKCycleScrollView*)cycleScrollView playIndex:(NSUInteger)playIndex superView:(nonnull UIView*)superView
{
    if (!self.playerView) {
        self.playerView = [[BKCycleScrollPlayerView alloc] init];
        __weak typeof(self) weakSelf = self;
        [self.playerView setPlayerPlayingCallBack:^{
            [weakSelf.cycleScrollView2 playVideo];
        }];
        [self.playerView setPlayerPausedCallBack:^{
            [weakSelf.cycleScrollView2 pauseVideo];
        }];
        [self.playerView setPlayerDidToEnd:^{
            [weakSelf.cycleScrollView2 stopVideo];
        }];
    }
    [superView addSubview:self.playerView];
    self.playerView.frame = CGRectMake(0, 0, superView.frame.size.width, superView.frame.size.height);
    
    BKCycleScrollDataModel * model = cycleScrollView.displayDataArr[playIndex];
    [self.playerView playVideoUrl:[NSURL URLWithString:model.videoUrl] seekTime:0];
}

/// 暂停播放方法 (需要自己暂停播放器，不实现这个代理无法暂停播放)
/// @param cycleScrollView 无限滚动视图
/// @param pauseIndex 要暂停播放的视频所在索引
-(void)cycleScrollView:(nonnull BKCycleScrollView *)cycleScrollView pauseIndex:(NSUInteger)pauseIndex
{
    [self.playerView pause];
}

/// 停止播放方法 (需要自己停止播放器，不实现这个代理无法停止播放)
/// @param cycleScrollView 无限滚动视图
/// @param stopIndex 要暂停播放的视频所在索引
-(void)cycleScrollView:(nonnull BKCycleScrollView *)cycleScrollView stopIndex:(NSUInteger)stopIndex
{
    [self.playerView stop];
    [self.playerView removeFromSuperview];
    self.playerView = nil;
}

@end
