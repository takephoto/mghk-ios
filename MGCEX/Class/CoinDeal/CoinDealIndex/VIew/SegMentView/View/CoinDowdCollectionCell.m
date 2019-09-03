// MGC
//
// CoinDowdCollectionCell.m
// MGCEX
//
// Created by MGC on 2018/6/7.
// Copyright © 2018年 MGCion. All rights reserved.
//
// @ description <#描述#> 

#import "CoinDowdCollectionCell.h"

@interface CoinDowdCollectionCell()

@end

@implementation CoinDowdCollectionCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setUpViews];
    }
    return self;
}

-(void)setUpViews{
    
    UILabel * titleLabel = [[UILabel alloc]init];
    [self.contentView addSubview:titleLabel];
    self.titleLabel = titleLabel;
    titleLabel.text = @"";
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.font = H18;
    titleLabel.textColor = kTextColor;
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsMake(0, 0, 2, 0));
    }];

    UIImageView * lineImageV = [[UIImageView alloc]init];
    [self.contentView addSubview:lineImageV];
    self.lineImageV = lineImageV;
    lineImageV.image = [UIImage imageWithColor:kMainColor];
    [lineImageV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(0);
        make.width.mas_equalTo(self);
        make.height.mas_equalTo(Adapted(2));
    }];
    lineImageV.hidden = YES;
}

-(void)setModel:(CoinDealMarkModel *)model{
    _model = model;
    
    if(model.isSelect == YES){
        self.titleLabel.text = model.markTitle;
        self.titleLabel.textColor = kMainColor;
        self.lineImageV.hidden = NO;
    }else{
        self.titleLabel.text = model.markTitle;
        self.titleLabel.textColor = UIColorFromRGB(0xA2A2A2);
        self.lineImageV.hidden = YES;
    }
    
}


@end
