// MGC
//
// LabguageRegionCell.m
// MGCEX
//
// Created by MGC on 2018/5/17.
// Copyright © 2018年 MGCion. All rights reserved.
//
// @ description <#描述#> 

#import "LabguageRegionCell.h"

@implementation LabguageRegionCell

-(void)setUpViews{
    self.backgroundColor = kBackAssistColor;
    
    UILabel * titleLabel = [[UILabel alloc]init];
    [self.contentView addSubview:titleLabel];
    titleLabel.textColor = kAssistColor;
    titleLabel.font = H15;
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(Adapted(15));
        make.centerY.mas_equalTo(self.contentView);
        make.width.mas_equalTo(MAIN_SCREEN_WIDTH/2.0);
    }];
    self.titleLabel = titleLabel;
    
    UIImageView * arrowImageV = [[UIImageView alloc]init];
    [self.contentView addSubview:arrowImageV];
    arrowImageV.image = IMAGE(@"gou");
    [arrowImageV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.mas_right).offset(Adapted(-15));
        make.centerY.mas_equalTo(self);
        make.width.mas_equalTo(Adapted(14));
        make.height.mas_equalTo(Adapted(14));
    }];
    arrowImageV.hidden = YES;
    self.arrowImageV = arrowImageV;
}

-(void)setIsSelect:(BOOL)isSelect{
    _isSelect = isSelect;
    if(isSelect){
        self.arrowImageV.hidden = NO;
        self.titleLabel.textColor = kRedColor;
    }else{
        self.arrowImageV.hidden = YES;
        self.titleLabel.textColor = kAssistColor;
    }
}

@end
