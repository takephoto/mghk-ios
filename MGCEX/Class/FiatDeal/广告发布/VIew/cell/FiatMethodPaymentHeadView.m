// MGC
//
// FiatMethodPaymentHeadView.m
// MGCEX
//
// Created by MGC on 2018/5/30.
// Copyright © 2018年 MGCion. All rights reserved.
//
// @ description <#描述#> 

#import "FiatMethodPaymentHeadView.h"

@implementation FiatMethodPaymentHeadView

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
    //标题
    NSArray * arrayText = @[kLocalizedString(@"选择支付方式"),kLocalizedString(@"(可多选)")];
    NSArray * arrayFont = @[H15,H15];
    NSArray * arrayColor = @[kTextColor,kAssistTextColor];
    UILabel * msgLabel = [[UILabel alloc]init];
    [self addSubview:msgLabel];
    NSAttributedString * att = [UILabel mg_attributedTextArray:arrayText textColors:arrayColor textfonts:arrayFont];
    msgLabel.attributedText = att;
    msgLabel.numberOfLines = 0;
    [msgLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self);
        make.left.mas_equalTo(Adapted(15));
        make.right.mas_equalTo(Adapted(-15));
    }];
    
    UIView *lineView = [[UIView alloc]init];
    [self addSubview:lineView];
    lineView.backgroundColor = UIColorFromRGB(0xe7e7e7);
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(Adapted(0));
        make.right.mas_equalTo(Adapted(0));
        make.height.mas_equalTo(1);
        make.bottom.mas_equalTo(Adapted(0));
    }];
    self.lineView = lineView;
}
@end
