//
//  ViewController.m
//  BKCycleScrollView
//
//  Created by BIKE on 2018/6/7.
//  Copyright © 2018年 BIKE. All rights reserved.
//

#import "ViewController.h"
#import "BKCycleScrollView.h"

@interface ViewController ()

@property (nonatomic,strong) NSArray * localImageArr;
@property (nonatomic,strong) NSArray * netImageArr;
@property (nonatomic,strong) NSArray * netImageArr2;

@property (nonatomic,strong) BKCycleScrollView * cycleScrollView1;
@property (nonatomic,strong) BKCycleScrollView * cycleScrollView2;
@property (nonatomic,strong) BKCycleScrollView * cycleScrollView3;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
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
    
    NSArray * images2 = @[@"https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1528368399685&di=d6d322d6cf932ebbf569303d0bade418&imgtype=0&src=http%3A%2F%2Fpic1.16pic.com%2F00%2F07%2F66%2F16pic_766152_b.jpg",@"https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1528368294842&di=5de9f86a4001b2f04d04b65e1573122d&imgtype=0&src=http%3A%2F%2Fpic.qiantucdn.com%2F58pic%2F13%2F71%2F35%2F24k58PICSiB_1024.jpg",@"https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1528368334917&di=fc058e94d3951768c4151104f707a347&imgtype=0&src=http%3A%2F%2Fimg1.3lian.com%2F2015%2Fa1%2F63%2Fd%2F121.jpg"];
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
    
    [self cycleScrollView1];
    [self cycleScrollView2];
//    [self cycleScrollView3];
}

#pragma mark - BKCycleScrollView1

-(BKCycleScrollView*)cycleScrollView1
{
    if (!_cycleScrollView1) {
        
        _cycleScrollView1 = [[BKCycleScrollView alloc] initWithFrame:CGRectMake(0, [UIApplication sharedApplication].statusBarFrame.size.height + 20, self.view.frame.size.width, 150) displayDataArr:self.netImageArr];
        _cycleScrollView1.layoutStyle = BKDisplayCellLayoutStyleMiddleLarger;
        _cycleScrollView1.itemSpace = -18;
        _cycleScrollView1.itemWidth = self.view.frame.size.width - 40;
        _cycleScrollView1.itemReduceScale = 0.1;
        _cycleScrollView1.radius = 12;
        _cycleScrollView1.isAutoScroll = NO;
        [self.view addSubview:_cycleScrollView1];

        [_cycleScrollView1 setSelectItemAction:^(NSInteger index, UIImageView *imageView) {
            NSLog(@"点击了 _cycleScrollView1 上 索引%ld的item",index);
        }];
    }
    return _cycleScrollView1;
}

#pragma mark - BKCycleScrollView2

-(BKCycleScrollView*)cycleScrollView2
{
    if (!_cycleScrollView2) {
        
        _cycleScrollView2 = [[BKCycleScrollView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.cycleScrollView1.frame) + 40, self.view.frame.size.width, 150) displayDataArr:self.localImageArr];
        _cycleScrollView2.isAutoScroll = NO;
        _cycleScrollView2.layoutStyle = BKDisplayCellLayoutStyleNormal;
        _cycleScrollView2.pageControlStyle = BKCycleScrollPageControlStyleNormalDots;
        _cycleScrollView2.progressColor = [UIColor brownColor];
        [self.view addSubview:_cycleScrollView2];
        
        [_cycleScrollView2 setSelectItemAction:^(NSInteger index, UIImageView *imageView) {
            NSLog(@"点击了 _cycleScrollView2 上 索引%ld的item",index);
        }];
    }
    return _cycleScrollView2;
}

#pragma mark - BKCycleScrollView3

-(BKCycleScrollView*)cycleScrollView3
{
    if (!_cycleScrollView3) {
        
        _cycleScrollView3 = [[BKCycleScrollView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.cycleScrollView2.frame) + 40, self.view.frame.size.width, 150) displayDataArr:self.netImageArr2];
        _cycleScrollView3.placeholderImage = [UIImage imageNamed:@"placeholder"];
        _cycleScrollView3.layoutStyle = BKDisplayCellLayoutStyleMiddleLarger;
        _cycleScrollView3.itemSpace = 0;
        _cycleScrollView3.itemWidth = 50;
        _cycleScrollView3.itemReduceScale = 0.2;
        _cycleScrollView3.radius = 0;
        _cycleScrollView3.pageControlStyle = BKCycleScrollPageControlStyleLongDots;
        _cycleScrollView3.normalDotColor = [UIColor yellowColor];
        _cycleScrollView3.selectDotColor = [UIColor brownColor];
        [self.view addSubview:_cycleScrollView3];
        
        [_cycleScrollView3 setSelectItemAction:^(NSInteger index, UIImageView *imageView) {
            NSLog(@"点击了 _cycleScrollView3 上 索引%ld的item",index);
        }];
    }
    return _cycleScrollView3;
}

@end
