// MGC
//
// FiatSetCodeCell.m
// MGCEX
//
// Created by MGC on 2018/5/31.
// Copyright © 2018年 MGCion. All rights reserved.
//
// @ description <#描述#> 

#import "FiatSetCodeCell.h"

@implementation FiatSetCodeCell

-(void)setUpViews{
    
    self.backgroundColor = white_color;
    
    //标题
    NSArray * arrayText = @[kLocalizedString(@"上传收款码"),kLocalizedString(@"(只能上传一张)")];
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
    
    //查看示例
    UIButton * lookExample = [UIButton buttonWithType:UIButtonTypeCustom];
    [self addSubview:lookExample];
    [lookExample mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(Adapted(-15));
        make.centerY.mas_equalTo(msgLabel);
        make.width.mas_equalTo(Adapted(200));
        make.height.mas_equalTo(Adapted(35));
    }];
    lookExample.titleLabel.font = H15;
    lookExample.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    [lookExample setTitleColor:kRedColor forState:UIControlStateNormal];
    [lookExample setTitle:kLocalizedString(@"查看示例") forState:UIControlStateNormal];
    [lookExample addTarget:self action:@selector(lookExampleClick) forControlEvents:UIControlEventTouchUpInside];
    self.lookExampleBtn = lookExample;
    
    UIImageView * codeImageImageV = [[UIImageView alloc] init];
    [self.contentView addSubview:codeImageImageV];
    codeImageImageV.image = IMAGE(@"icon_ss_add");
    codeImageImageV.userInteractionEnabled = YES;
    [codeImageImageV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(Adapted(15));
        make.top.mas_equalTo(lookExample.mas_bottom).offset(Adapted(10));
        make.width.height.mas_equalTo(Adapted(76));
    }];
    self.codeImageImageV = codeImageImageV;
    
}



-(void)lookExampleClick{
    
}
@end
