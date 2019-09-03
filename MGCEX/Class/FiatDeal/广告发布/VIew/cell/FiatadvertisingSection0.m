// MGC
//
// FiatadvertisingSection0.m
// MGCEX
//
// Created by MGC on 2018/5/30.
// Copyright © 2018年 MGCion. All rights reserved.
//
// @ description <#描述#> 

#import "FiatadvertisingSection0.h"

@implementation FiatadvertisingSection0

-(void)setUpViews{
    self.backgroundColor = white_color;
    
    UILabel * titleLabel = [[UILabel alloc]init];
    [self.contentView addSubview:titleLabel];
    titleLabel.textColor = kTextColor;
    titleLabel.font = H15;
    titleLabel.text = kLocalizedString(@"交易类型");
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(Adapted(15));
        make.centerY.mas_equalTo(self.contentView);
        make.width.mas_equalTo(MAIN_SCREEN_WIDTH/2.0 -Adapted(15));
    }];
    self.titleLabel = titleLabel;

    UIButton * selectBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.contentView addSubview:selectBtn];
    [selectBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.contentView.mas_right).offset(Adapted(-15));
        make.centerY.mas_equalTo(self.contentView);
        make.height.mas_equalTo(Adapted(6));
        make.width.mas_equalTo(Adapted(10));
    }];
    [selectBtn setImage:IMAGE(@"jt_xs_down") forState:UIControlStateNormal];
    [selectBtn setImage:IMAGE(@"jt_xs_up") forState:UIControlStateSelected];


    UILabel * subLabel = [[UILabel alloc]init];
    [self addSubview:subLabel];
    subLabel.textColor = k99999Color;
    subLabel.text = kLocalizedString(@"卖出");
    subLabel.font = H15;
    subLabel.textAlignment = NSTextAlignmentRight;
    [subLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(selectBtn.mas_left).offset(Adapted(-5));
        make.centerY.mas_equalTo(self);
        make.width.mas_equalTo(MAIN_SCREEN_WIDTH/2.0);
    }];
    self.subLabel = subLabel;
    
    //分割线
    UIView *lineView = [[UIView alloc]init];
    [self.contentView addSubview:lineView];
    lineView.backgroundColor = UIColorFromRGB(0xe7e7e7);
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(Adapted(15));
        make.right.mas_equalTo(Adapted(-15));
        make.height.mas_equalTo(1);
        make.bottom.mas_equalTo(Adapted(0));
    }];
    self.lineView = lineView;
}

-(void)selectBtnClick:(UIButton *)btn{
    btn.selected = !btn.selected;
    
}

@end
