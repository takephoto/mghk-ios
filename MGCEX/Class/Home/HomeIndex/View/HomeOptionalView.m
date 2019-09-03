// MGC
//
// HomeOptionalView.m
// MGCEX
//
// Created by MGC on 2018/5/22.
// Copyright © 2018年 MGCion. All rights reserved.
//
// @ description <#描述#> 

#import "HomeOptionalView.h"
#import "MGKLineChartVC.h"
#import "MGMarketIndexRealTimeModel.h"
#import "MGMarketIndexRealTimeModel.h"


@implementation HomeOptionalView

#pragma mark -- life cycles
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setUpVIews];
        @weakify(self);
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] init];
        // 订阅信号处理推荐产品点击事件
        [[tap rac_gestureSignal] subscribeNext:^(id x) {
            @strongify(self);
            MGKLineChartVC *vc = [[MGKLineChartVC alloc]init];
            vc.symbols = self.model.symbol;
            vc.market = self.model.market;
            vc.model = self.model;
            [[TWAppTool currentViewController].navigationController pushViewController:vc animated:YES];
        }];
        self.userInteractionEnabled = YES;
        [self addGestureRecognizer:tap];
    }
    return self;
}

- (void)setUpVIews{
    self.backgroundColor = UIColorFromRGB(0xF6FAFF);
    CGFloat height = (self.height - Adapted(30)) / 4.0;
    // 生成产品数据标签
    for(int i = 0;i < 4;i++){
        UILabel * label = [[UILabel alloc]initWithFrame:CGRectMake(0, Adapted(15) + i * height, self.width,height)];
        label.textAlignment = NSTextAlignmentCenter;
        label.font = H15;
        label.tag = 10 + i;
        label.adjustsFontSizeToFitWidth = YES;
        [self addSubview:label];
    }
    
    self.label1 = [self viewWithTag:10];
    self.label2 = [self viewWithTag:11];
    self.label3 = [self viewWithTag:12];
    self.label4 = [self viewWithTag:13];
    
    self.label1.textColor = kTextColor;
    self.label2.textColor = UIColorFromRGB(0x0fc055);
    self.label3.textColor = UIColorFromRGB(0x999999);
    self.label4.textColor = UIColorFromRGB(0xA2A2A2);
    
    self.label2.font = H13;
    self.label3.font = H12;
}

#pragma mark -- public methods
- (void)update:(MGMarketIndexRealTimeModel *)model
{
    self.model = model;
    if (!kStringIsEmpty(model.symbol)) {
        NSString *fee = [NSString stringWithFormat:@"%f",[model.gains doubleValue] *100];
        fee = fee.removeFloatAllZero;
        self.label1.text = string(string(model.symbol, @"/"), model.market);
        self.label2.text = [model.c keepDecimal:8];
        self.label4.text = string(@"≈", string([model.valuation keepDecimal:2], @"CNY"));
        self.label3.text = string([fee keepDecimal:2], @"%");
        self.label2.textColor = self.label3.textColor = [ self.label4.text hasPrefix:@"-"]?kRedColor:kGreenColor;
        if (![ self.label3.text hasPrefix:@"-"]) {
            self.label3.text = string(@"+", self.label3.text);
        }
    }
}

@end
