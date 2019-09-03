// MGC
//
// FiatSetRemarkCell.m
// MGCEX
//
// Created by MGC on 2018/5/31.
// Copyright © 2018年 MGCion. All rights reserved.
//
// @ description <#描述#> 

#import "FiatSetRemarkCell.h"
#import "TWTextView.h"

@implementation FiatSetRemarkCell

-(void)setUpViews{
    
    self.backgroundColor = white_color;
    
    //标题
    NSArray * arrayText = @[kLocalizedString(@"其他备注"),kLocalizedString(@"(用于提醒买家)")];
    NSArray * arrayFont = @[H15,H15];
    NSArray * arrayColor = @[kTextColor,k99999Color];
    UILabel * msgLabel = [[UILabel alloc]init];
    [self addSubview:msgLabel];
    NSAttributedString * att = [UILabel mg_attributedTextArray:arrayText textColors:arrayColor textfonts:arrayFont];
    msgLabel.attributedText = att;
    msgLabel.numberOfLines = 0;
    [msgLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(Adapted(15));
        make.top.mas_equalTo(Adapted(15));
        make.right.mas_equalTo(Adapted(-15));
    }];
  
    //输入框
    TWTextView * textView = [[TWTextView alloc]initWithFrame:CGRectZero];
    textView.placeholder = kLocalizedString(@"   请输入其他备注信息");
    textView.placeholderColor = kLineColor;
    textView.limitLength = 1000;
    textView.font = H15;
    textView.layer.borderColor = UIColorFromRGB(0xe7e7e7).CGColor;
    textView.layer.borderWidth = 0.5;
    [self.contentView addSubview:textView];
    textView.textColor = kTextColor;
    [textView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsMake(Adapted(49), Adapted(15), Adapted(15), Adapted(15)));
    }];
    self.remarkTextView = textView;
}

@end
