// MGC
//
// PersonalAccountCell.m
// MGCEX
//
// Created by MGC on 2018/5/15.
// Copyright © 2018年 MGCion. All rights reserved.
//
// @ description <#描述#> 

#import "PersonalAccountCell.h"

@implementation PersonalAccountCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = kBackGroundColor;
        [self setUpViews];
    }
    return self;
}

-(void)setUpViews{
    UILabel * accountLabel = [[UILabel alloc]init];
    [self addSubview:accountLabel];
    self.accountLabel = accountLabel;
    accountLabel.text = @"";
    accountLabel.font = H15;
    accountLabel.textColor = kTextColor;
    [accountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(Adapted(12));
        make.right.mas_equalTo(Adapted(-12));
        make.top.mas_equalTo(Adapted(15));
    }];
    
    UILabel * amountLabel = [[UILabel alloc]init];
    [self addSubview:amountLabel];
    self.amountLabel = amountLabel;
    amountLabel.text = @"0.00000000";
    amountLabel.font = H14;
    amountLabel.textColor = kRedColor;
    [amountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(Adapted(12));
        make.right.mas_equalTo(Adapted(-12));
        make.centerY.mas_equalTo(self.contentView);
    }];
    
    UILabel * rmbLabel = [[UILabel alloc]init];
    [self addSubview:rmbLabel];
    self.rmbLabel = rmbLabel;
    rmbLabel.text = @"0.00 CNY";
    rmbLabel.font = H12;
    rmbLabel.textColor = UIColorFromRGB(0x999999);
    [rmbLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(Adapted(12));
        make.right.mas_equalTo(Adapted(-12));
        make.bottom.mas_equalTo(self.mas_bottom).offset(Adapted(-15));
    }];
}
@end
