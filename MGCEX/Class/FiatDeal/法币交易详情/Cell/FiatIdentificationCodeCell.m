// MGC
//
// FiatIdentificationCodeCell.m
// MGCEX
//
// Created by MGC on 2018/5/28.
// Copyright © 2018年 MGCion. All rights reserved.
//
// @ description <#描述#> 

#import "FiatIdentificationCodeCell.h"

@implementation FiatIdentificationCodeCell

-(void)setUpViews{
    
    self.backgroundColor = white_color;
    
    UILabel * titleLabel1 = [[UILabel alloc]init];
    [self addSubview:titleLabel1];
    titleLabel1.text = kLocalizedString(@"1、为了保障您在平台的交易权益，请在支付备注/附言中备注好付款标识码");
    titleLabel1.font = H15;
    titleLabel1.textColor = kRedColor;
    titleLabel1.numberOfLines = 0;
    [titleLabel1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(Adapted(15));
        make.right.mas_equalTo(Adapted(-15));
        make.top.mas_equalTo(Adapted(15));
    }];
    
    UILabel * titleLabel2 = [[UILabel alloc]init];
    [self addSubview:titleLabel2];
    titleLabel2.text = kLocalizedString(@"2、您的汇款将直接进入卖方账户，交易过程中卖方出售的数字资产由平台托管保护。");
    titleLabel2.font = H15;
    titleLabel2.textColor = UIColorFromRGB(0x666666);
    titleLabel2.numberOfLines = 0;
    [titleLabel2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(Adapted(15));
        make.right.mas_equalTo(Adapted(-15));
        make.top.mas_equalTo(titleLabel1.mas_bottom).offset(Adapted(12));
    }];
    
    UILabel * titleLabel3 = [[UILabel alloc]init];
    [self addSubview:titleLabel3];
    titleLabel3.text = kLocalizedString(@"3、请在规定时间内完成付款，并务必点击“我已付款”，卖方确认收款后，系统会将数字资产划转到您的账户。");
    titleLabel3.font = H15;
    titleLabel3.textColor = UIColorFromRGB(0x666666);
    titleLabel3.numberOfLines = 0;
    [titleLabel3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(Adapted(15));
        make.right.mas_equalTo(Adapted(-15));
        make.top.mas_equalTo(titleLabel2.mas_bottom).offset(Adapted(12));
    }];
    
    UILabel * titleLabel4 = [[UILabel alloc]init];
    [self addSubview:titleLabel4];
    titleLabel4.numberOfLines = 0;
    titleLabel4.text = kLocalizedString(@"4、如果买方当日取消交易达3次，将会被限制当日的买入功能");
    titleLabel4.font = H15;
    titleLabel4.textColor = UIColorFromRGB(0x666666);
    [titleLabel4 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(Adapted(15));
        make.right.mas_equalTo(Adapted(-15));
        make.top.mas_equalTo(titleLabel3.mas_bottom).offset(Adapted(12));
    }];
    
    QSButton * closeBtn = [QSButton buttonWithType:0];
    [self addSubview:closeBtn];
    [closeBtn setTitle:kLocalizedString(@"收起") forState:UIControlStateNormal];
    [closeBtn setImage:IMAGE(@"jt_xs_up") forState:UIControlStateNormal];
    [closeBtn setTitleColor:k99999Color forState:UIControlStateNormal];
    closeBtn.titleLabel.font = H15;
    closeBtn.space = Adapted(5);
    closeBtn.style = QSButtonImageStyleRight;
    [closeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self);
        make.top.mas_equalTo(titleLabel4.mas_bottom).offset(Adapted(20));
        make.bottom.mas_equalTo(self.mas_bottom).offset(Adapted(-20));
        make.width.mas_equalTo(Adapted(150));
        
    }];
    [closeBtn addTarget:self action:@selector(closeCellClick) forControlEvents:UIControlEventTouchUpInside];
    
}

-(void)closeCellClick{
    if(self.closeBlock){
        self.closeBlock();
    }
}

@end
