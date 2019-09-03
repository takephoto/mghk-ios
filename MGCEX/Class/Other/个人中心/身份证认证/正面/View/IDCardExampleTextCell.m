// MGC
//
// IDCardExampleTextCell.m
// MGCEX
//
// Created by MGC on 2018/5/16.
// Copyright © 2018年 MGCion. All rights reserved.
//
// @ description <#描述#> 

#import "IDCardExampleTextCell.h"

@implementation IDCardExampleTextCell

-(void)setUpViews{
    
    self.backgroundColor = white_color;
    UILabel * titleLabel = [[UILabel alloc]init];
    [self.contentView addSubview:titleLabel];
    titleLabel.textColor = kTextColor;
    titleLabel.font = H15;
    titleLabel.text = kLocalizedString(@"上传要求");
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(Adapted(15));
        make.top.mas_equalTo(Adapted(10));
        make.right.mas_equalTo(Adapted(-15));
    }];
    
    UILabel * label1 = [[UILabel alloc]init];
    [self.contentView addSubview:label1];
    label1.textColor = kTextColor;
    label1.font = H13;
    label1.numberOfLines = 0;
    [label1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(Adapted(15));
        make.top.mas_equalTo(titleLabel.mas_bottom).offset(Adapted(12));
        make.right.mas_equalTo(Adapted(-15));
    }];
    self.textHint1 = label1;
    
    UILabel * label2 = [[UILabel alloc]init];
    [self.contentView addSubview:label2];
    label2.textColor = kTextColor;
    label2.font = H13;
    label2.numberOfLines = 0;
    [label2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(Adapted(15));
        make.top.mas_equalTo(label1.mas_bottom).offset(Adapted(5));
        make.right.mas_equalTo(Adapted(-15));
    }];
    self.textHint2 = label2;
    
    
    UILabel * label3 = [[UILabel alloc]init];
    [self.contentView addSubview:label3];
    label3.textColor = kTextColor;
    label3.font = H13;
    label3.numberOfLines = 0;
    [label3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(Adapted(15));
        make.top.mas_equalTo(label2.mas_bottom).offset(Adapted(5));
        make.right.mas_equalTo(Adapted(-15));
    }];
    self.textHint3 = label3;
}

@end
