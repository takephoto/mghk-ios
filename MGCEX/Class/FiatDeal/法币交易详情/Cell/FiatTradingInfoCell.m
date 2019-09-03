// MGC
//
// FiatTradingInfoCell.m
// MGCEX
//
// Created by MGC on 2018/5/27.
// Copyright © 2018年 MGCion. All rights reserved.
//
// @ description <#描述#> 

#import "FiatTradingInfoCell.h"

@implementation FiatTradingInfoCell

-(void)setUpViews{
    
    self.backgroundColor = white_color;
    
    UILabel * leftLabel = [[UILabel alloc]init];
    [self.contentView addSubview:leftLabel];
    self.leftLabel = leftLabel;
    leftLabel.textColor = UIColorFromRGB(0x666666);
    leftLabel.font = H14;
    leftLabel.text = @"";
    leftLabel.numberOfLines = 0;
    [leftLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(Adapted(15));
        make.top.mas_equalTo(Adapted(15));
        make.bottom.mas_equalTo(Adapted(-15));
        make.width.mas_equalTo(Adapted(80));
    }];
 
    
    UILabel * rightLabel = [[UILabel alloc]init];
    [self.contentView addSubview:rightLabel];
    self.rightLabel = rightLabel;
    rightLabel.textColor = UIColorFromRGB(0x666666);;
    rightLabel.font = H14;
    rightLabel.numberOfLines = 0;
    [rightLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(leftLabel.mas_right).offset(Adapted(5));
        make.right.mas_equalTo(Adapted(-15));
//        make.top.mas_equalTo(Adapted(15));
//        make.bottom.mas_equalTo(Adapted(-15));
        make.centerY.mas_equalTo(self.contentView);

    }];
    
    //分割线
    UIView * lineView = [[UIView alloc]init];
    [self addSubview:lineView];
    self.lineView = lineView;
    lineView.backgroundColor = UIColorFromRGBA(0xdddddd, 0.6);
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.bottom.mas_equalTo(Adapted(0));
        make.height.mas_equalTo(Adapted(1));
    }];
    lineView.hidden = YES;
}

@end
