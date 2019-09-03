// MGC
//
// ChangeCountryCell.m
// MGCEX
//
// Created by MGC on 2018/5/14.
// Copyright © 2018年 MGCion. All rights reserved.
//
// @ description <#描述#> 

#import "ChangeCountryCell.h"

@implementation ChangeCountryCell

-(void)setUpViews{
    UILabel * titleLabel = [[UILabel alloc]init];
    [self.contentView addSubview:titleLabel];
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.contentView).offset(Adapted(8));
        make.left.mas_equalTo(Adapted(15));
        make.width.mas_equalTo(MAIN_SCREEN_WIDTH/2);
    }];
    titleLabel.textColor = kAssistColor;
    self.titleLabel = titleLabel;
    
    UILabel * subLabel = [[UILabel alloc]init];
    [self.contentView addSubview:subLabel];
    [subLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.contentView).offset(Adapted(-8));
        make.left.mas_equalTo(Adapted(15));
        make.width.mas_equalTo(MAIN_SCREEN_WIDTH/2);
    }];
    subLabel.font = H11;
    subLabel.textColor = kAssistColor;
    self.subLabel = subLabel;
    
    UILabel * areaCode = [[UILabel alloc]init];
    [self.contentView addSubview:areaCode];
    self.areaCode = areaCode;
    [areaCode mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.contentView);
        make.right.mas_equalTo(Adapted(-15));
        make.width.mas_equalTo(MAIN_SCREEN_WIDTH/2);
    }];
    areaCode.textAlignment = NSTextAlignmentRight;
    areaCode.textColor = kAssistColor;
}

@end
