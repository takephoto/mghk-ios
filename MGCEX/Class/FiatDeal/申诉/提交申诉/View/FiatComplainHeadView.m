// MGC
//
// FiatComplainHeadView.m
// MGCEX
//
// Created by MGC on 2018/5/29.
// Copyright © 2018年 MGCion. All rights reserved.
//
// @ description <#描述#> 

#import "FiatComplainHeadView.h"

@implementation FiatComplainHeadView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setUpViews];
    }
    return self;
}

-(void)setUpViews{
    self.backgroundColor = kBackGroundColor;
    
    //标题
    NSArray * arrayText = @[kLocalizedString(@"提交申诉材料    "),kLocalizedString(@"请认真对照实际转账记录填写")];
    NSArray * arrayFont = @[H15,H15];
    NSArray * arrayColor = @[kTextColor,kRedColor];
    
    UILabel * titleLabel = [[UILabel alloc]init];
    [self addSubview:titleLabel];
    
    NSAttributedString * att = [UILabel mg_attributedTextArray:arrayText textColors:arrayColor textfonts:arrayFont];
    titleLabel.attributedText = att;
    titleLabel.numberOfLines = 0;
 
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self);
        make.left.mas_equalTo(Adapted(15));
        make.right.mas_equalTo(self.mas_right).offset(Adapted(-15));
    }];
}

@end
