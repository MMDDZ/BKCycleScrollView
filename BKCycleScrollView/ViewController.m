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
    self.localImageArr = @[[UIImage imageNamed:@"1"], [UIImage imageNamed:@"2"], UIImageJPEGRepresentation([UIImage imageNamed:@"3"], 1), [NSData dataWithContentsOfURL:imageUrl]];
    
    self.netImageArr = @[@"https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1528368399685&di=d6d322d6cf932ebbf569303d0bade418&imgtype=0&src=http%3A%2F%2Fpic1.16pic.com%2F00%2F07%2F66%2F16pic_766152_b.jpg",@"https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1528368294842&di=5de9f86a4001b2f04d04b65e1573122d&imgtype=0&src=http%3A%2F%2Fpic.qiantucdn.com%2F58pic%2F13%2F71%2F35%2F24k58PICSiB_1024.jpg",@"https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1528368334917&di=fc058e94d3951768c4151104f707a347&imgtype=0&src=http%3A%2F%2Fimg1.3lian.com%2F2015%2Fa1%2F63%2Fd%2F121.jpg"];
    
    self.netImageArr2 = @[@"http://img.taopic.com/uploads/allimg/140118/234914-14011PZ32692.jpg",@"http://pic1.win4000.com/wallpaper/5/58c74e21e2228.jpg",@"http://imgsrc.baidu.com/imgad/pic/item/42a98226cffc1e17d453210c4190f603738de91b.jpg",@"https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1529388176527&di=7a047e6e2c065af002f71b594793d777&imgtype=0&src=http%3A%2F%2Fimg.zcool.cn%2Fcommunity%2F01c3cf5544d0c70000019ae97686ea.jpg",@"http://img.mp.sohu.com/upload/20170801/8b8854e3a09245b68e2058fc8b30fc02_th.png"];
    
    [self cycleScrollView1];
    [self cycleScrollView2];
    [self cycleScrollView3];
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
        [self.view addSubview:_cycleScrollView1];

        [_cycleScrollView1 setSelectItemAction:^(NSInteger index) {
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
        _cycleScrollView2.layoutStyle = BKDisplayCellLayoutStyleNormal;
        _cycleScrollView2.pageControlStyle = BKCycleScrollPageControlStyleNormalDots;
        [self.view addSubview:_cycleScrollView2];
        
        [_cycleScrollView2 setSelectItemAction:^(NSInteger index) {
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
        
        [_cycleScrollView3 setSelectItemAction:^(NSInteger index) {
            NSLog(@"点击了 _cycleScrollView3 上 索引%ld的item",index);
        }];
    }
    return _cycleScrollView3;
}

@end
