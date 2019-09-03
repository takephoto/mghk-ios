// MGC
//
// FiatSetCommonCell.m
// MGCEX
//
// Created by MGC on 2018/5/31.
// Copyright © 2018年 MGCion. All rights reserved.
//
// @ description <#描述#> 

#import "FiatSetCommonCell.h"

@implementation FiatSetCommonCell

-(void)setUpViews{
    
    self.backgroundColor = white_color;
    
    UILabel * titleLabel = [[UILabel alloc]init];
    titleLabel.numberOfLines = 0;
    titleLabel.textColor = kTextColor;
    titleLabel.font = H15;
    [self.contentView addSubview:titleLabel];
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(Adapted(15));
        make.centerY.mas_equalTo(self.contentView);
        make.width.mas_equalTo(Adapted(100));
    }];
    self.titleLabel = titleLabel;
    
    UITextField * subTextFiled = [[UITextField alloc]init];
    subTextFiled.textColor = kTextColor;
    subTextFiled.font = H15;
    [self.contentView addSubview:subTextFiled];
    [subTextFiled mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(titleLabel.mas_right).offset(Adapted(5));
        make.centerY.mas_equalTo(self.contentView);
        make.right.mas_equalTo(Adapted(-15));
    }];
    self.subTextFiled = subTextFiled;
}

@end
