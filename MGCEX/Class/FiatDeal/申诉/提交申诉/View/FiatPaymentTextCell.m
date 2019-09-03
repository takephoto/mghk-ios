// MGC
//
// FiatPaymentTextCell.m
// MGCEX
//
// Created by MGC on 2018/5/29.
// Copyright © 2018年 MGCion. All rights reserved.
//
// @ description <#描述#> 

#import "FiatPaymentTextCell.h"
#import "UITextField+QSExtension.h"

@implementation FiatPaymentTextCell

-(void)setUpViews{
    
    self.backgroundColor = white_color;
    
    UITextField * textFiled = [[UITextField alloc]init];
    [self.contentView addSubview:textFiled];
    [textFiled mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.contentView).offset(Adapted(15));
        make.right.mas_equalTo(self.contentView).offset(Adapted(-15));
        make.centerY.mas_equalTo(self.contentView);
    }];
    textFiled.textColor = kTextColor;
    textFiled.placeholderColor = k99999Color;
    textFiled.font = H15;
    self.textField = textFiled;
    
    UIView * lineView = [[UIView alloc]init];
    [self.contentView addSubview:lineView];
    self.lineView = lineView;
    lineView.backgroundColor = UIColorFromRGB(0xe7e7e7);
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(Adapted(15));
        make.right.mas_equalTo(Adapted(-15));
        make.height.mas_equalTo(0.5);
        make.bottom.mas_equalTo(self.mas_bottom);
    }];
}
@end
