//
//  BKCycleScrollPlayerFailureView.m
//  DSCnliveShopSDK
//
//  Created by zhaolin on 2019/5/9.
//  Copyright © 2019 BIKE. All rights reserved.
//

#import "BKCycleScrollPlayerFailureView.h"

@interface BKCycleScrollPlayerFailureView()

@property (nonatomic,strong) UILabel * titleLab;
@property (nonatomic,strong) UIButton * refreshBtn;

@end

@implementation BKCycleScrollPlayerFailureView

-(instancetype)init
{
    self = [super init];
    if (self) {
        self.backgroundColor = [UIColor blackColor];
        [self initUI];
    }
    return self;
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    
    self.titleLab.frame = CGRectMake(5, (self.frame.size.height - (20 + 12 + 32))/2, self.frame.size.width - 5*2, 20);
    self.refreshBtn.frame = CGRectMake((self.frame.size.width - 70)/2, CGRectGetMaxY(self.titleLab.frame) + 12, 80, 32);
}

#pragma mark - initUI

-(void)initUI
{
    self.titleLab = [[UILabel alloc] init];
    self.titleLab.textAlignment = NSTextAlignmentCenter;
    self.titleLab.font = [UIFont systemFontOfSize:14];
    self.titleLab.textColor = [UIColor whiteColor];
    [self addSubview:self.titleLab];
    
    self.refreshBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.refreshBtn.layer.cornerRadius = 32/2;
    self.refreshBtn.clipsToBounds = YES;
    [self.refreshBtn setTitle:@"刷新重试" forState:UIControlStateNormal];
    [self.refreshBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.refreshBtn setBackgroundColor:[UIColor colorWithRed:255/255.0f green:114/255.0f blue:92/255.0f alpha:1]];
    self.refreshBtn.titleLabel.font = [UIFont systemFontOfSize:13];
    [self.refreshBtn addTarget:self action:@selector(refreshBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.refreshBtn];
}

#pragma mark - 触发事件

-(void)refreshBtnClick
{
    if (self.clickRefreshCallBack) {
        self.clickRefreshCallBack();
    }
}

#pragma mark - 赋值

-(void)setErrorMessage:(NSString *)errorMessage
{
    _errorMessage = errorMessage;
    self.titleLab.text = errorMessage;
}

@end
