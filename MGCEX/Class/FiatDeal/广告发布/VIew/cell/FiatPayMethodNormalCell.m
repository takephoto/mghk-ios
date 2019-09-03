// MGC
//
// FiatPayMethodNormalCell.m
// MGCEX
//
// Created by MGC on 2018/5/30.
// Copyright © 2018年 MGCion. All rights reserved.
//
// @ description <#描述#> 

#import "FiatPayMethodNormalCell.h"
@interface FiatPayMethodNormalCell(){
    UILabel * titleLabel;
    UILabel * subLabel;
}
@end
@implementation FiatPayMethodNormalCell

/**
 绑定属性
 */
- (void)bindModel{
    @weakify(self);
    [RACObserve(self, payWay)subscribeNext:^(id x) {
        @strongify(self);
        switch (self.payWay) {
            case ViaBankCard:
            {
                self->titleLabel.text = kLocalizedString(@"银行卡");
                self->subLabel.text = kLocalizedString(@"前往添加银行卡账号");
            }
                break;
            case ViaWeChat:
            {
                self->titleLabel.text = kLocalizedString(@"支付宝");
                self->subLabel.text = kLocalizedString(@"前往添加支付宝账号");
            }
                break;
            case ViaAliPay:
            {
                self->titleLabel.text = kLocalizedString(@"微信");
                self->subLabel.text = kLocalizedString(@"前往添加微信账号");
            }
                break;
                
            default:
                break;
        }
    }];
}

-(void)setUpViews{
    

    self.backgroundColor = white_color;
    
    UIButton * selectBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self addSubview:selectBtn];
    [selectBtn setImage:IMAGE(@"icon_choice_more_no") forState:UIControlStateNormal];
    [selectBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(Adapted(15));
        make.centerY.mas_equalTo(self);
        make.width.height.mas_equalTo(30);
    }];
    
    titleLabel = [[UILabel alloc]init];
    [self.contentView addSubview:titleLabel];
    titleLabel.textColor = k99999Color;
    titleLabel.font = H15;
    titleLabel.text = kLocalizedString(kLocalizedString(@"微信"));
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(selectBtn.mas_right).offset(Adapted(5));
        make.top.mas_equalTo(17);
        make.bottom.mas_equalTo(-17);
        make.width.mas_equalTo(MAIN_SCREEN_WIDTH/3.0);
    }];

    UIImageView * arrowImageV = [[UIImageView alloc]init];
    [self.contentView addSubview:arrowImageV];
    arrowImageV.image = IMAGE(@"jiantou-heng");
    [arrowImageV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.mas_right).offset(Adapted(-16));
        make.centerY.mas_equalTo(self);
        make.width.mas_equalTo(Adapted(8));
        make.height.mas_equalTo(Adapted(14));
    }];
    
    subLabel = [[UILabel alloc]init];
    [self.contentView addSubview:subLabel];
    subLabel.textColor = kBackAssistColor;
    subLabel.font = H15;
    subLabel.text = kLocalizedString(@"前往添加微信账号");
    subLabel.textAlignment = NSTextAlignmentRight;
    [subLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(arrowImageV.mas_left).offset(Adapted(-5));
        make.top.mas_equalTo(Adapted(17));
        make.bottom.mas_equalTo(Adapted(-17));
        make.width.mas_equalTo(MAIN_SCREEN_WIDTH/2.0);
    }];
    
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

@end
