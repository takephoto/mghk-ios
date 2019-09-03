// MGC
//
// FiatPaymentCell.m
// MGCEX
//
// Created by MGC on 2018/5/29.
// Copyright © 2018年 MGCion. All rights reserved.
//
// @ description <#描述#> 

#import "FiatPaymentCell.h"

@implementation FiatPaymentCell

-(void)setUpViews{
    
    self.backgroundColor = white_color;
    
    UIButton * pointButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self addSubview:pointButton];
    self.pointButton = pointButton;
    pointButton.userInteractionEnabled = NO;
    [pointButton setImage:IMAGE(@"icon_choice_off") forState:UIControlStateNormal];
    [pointButton setImage:IMAGE(@"icon_choice_on") forState:UIControlStateSelected];
    [pointButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self);
        make.left.mas_equalTo(Adapted(15));
        make.width.height.mas_equalTo(Adapted(15));
    }];
    
    UILabel * titleLabel = [[UILabel alloc]init];
    [self.contentView addSubview:titleLabel];
    self.titleLabel = titleLabel;
    titleLabel.text = kLocalizedString(@"支付方式");
    titleLabel.font = H15;
    titleLabel.textColor = kTextColor;
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(pointButton.mas_right).offset(Adapted(15));
        make.right.mas_equalTo(Adapted(-15));
        make.centerY.mas_equalTo(self);
    }];
    
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
- (void)didBtnClicked:(UIButton*)btn
{
    btn.selected = !btn.selected;
    self.selectBlock(btn.selected);
}

@end
