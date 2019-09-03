// MGC
//
// FiatCapitalAccountHeadView.m
// MGCEX
//
// Created by MGC on 2018/6/6.
// Copyright © 2018年 MGCion. All rights reserved.
//
// @ description <#描述#> 

#import "FiatCapitalAccountHeadView.h"

@implementation FiatCapitalAccountHeadView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setUpViews];
    }
    return self;
}

-(void)setUpViews{
    
    self.backgroundColor = white_color;
    
    UILabel * titleLabel = [[UILabel alloc]init];
    [self addSubview:titleLabel];
    self.titleLabel = titleLabel;
    titleLabel.font = H13;
    titleLabel.textColor = k99999Color;
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.text = kLocalizedString(@"C2C/B2C资产估值");
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self);
        make.top.mas_equalTo(Adapted(20));
        make.left.mas_equalTo(Adapted(15));
        make.right.mas_equalTo(Adapted(-15));
    }];
    
    UILabel * accountLabel = [[UILabel alloc]init];
    [self addSubview:accountLabel];
    self.accountLabel = accountLabel;
    accountLabel.textColor = kRedColor;
    accountLabel.font = H19;
    accountLabel.textAlignment = NSTextAlignmentCenter;
    accountLabel.text = @"0 BTC";
    [accountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self);
        make.centerY.mas_equalTo(self);
        make.left.mas_equalTo(Adapted(15));
        make.right.mas_equalTo(Adapted(-15));
    }];
    
    UILabel * cuyLabel = [[UILabel alloc]init];
    [self addSubview:cuyLabel];
    self.cuyLabel = cuyLabel;
    cuyLabel.textColor = k99999Color;
    cuyLabel.font = H13;
    cuyLabel.textAlignment = NSTextAlignmentCenter;
    cuyLabel.text = @"0 CNY";
    [cuyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self);
        make.bottom.mas_equalTo(self.mas_bottom).offset(Adapted(-20));
        make.left.mas_equalTo(Adapted(15));
        make.right.mas_equalTo(Adapted(-15));
    }];    
}



@end
