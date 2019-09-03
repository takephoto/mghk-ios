//
//  MGCapitalTransferNumberCell.m
//  MGCEX
//
//  Created by 汪跃山 on 2018/7/10.
//  Copyright © 2018年 MGCion. All rights reserved.
//

#import "MGCapitalTransferNumberCell.h"

@interface MGCapitalTransferNumberCell ()

@property (nonatomic, strong) UILabel *availableLabel;



@end

@implementation MGCapitalTransferNumberCell

- (void)setUpViews
{
    self.backgroundColor = [UIColor colorWithHexString:@"#f1f1f1"];
    self.contentView.backgroundColor = white_color;
    [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(Adapted(0));
        make.left.right.mas_equalTo(0);
        make.bottom.mas_equalTo(Adapted(-6.0));
        //make.height.mas_equalTo(Adapted(123));
    }];
    
    //划转数量
    UILabel *numLab = [[UILabel alloc]init];
    numLab.text = kLocalizedString(@"转移数量");
    numLab.textColor = kBackAssistColor;
    numLab.font = H15;
    [self.contentView addSubview:numLab];
    [numLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.mas_equalTo(Adapted(16));
        make.height.mas_equalTo(Adapted(16));
    }];

    //输入框
    UITextField * numberTextFiled = [[UITextField alloc]init];
    [self.contentView addSubview:numberTextFiled];
    numberTextFiled.placeholder = kLocalizedString(@"请输入划转数量");
    numberTextFiled.textColor = k99999Color;
    numberTextFiled.font = H15;
    numberTextFiled.limitDecimalDigitLength = @"8";
    numberTextFiled.keyboardType = UIKeyboardTypeDecimalPad;
    [numberTextFiled mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(Adapted(-16.0));
        make.left.mas_equalTo(numLab);
        make.top.mas_equalTo(numLab.mas_bottom).offset(Adapted(24-15));
        make.height.mas_equalTo(Adapted(44.0));
    }];
    self.numberTextFiled = numberTextFiled;
    //分割线
    UIView * lineView = [[UIView alloc]init];
    [self.contentView addSubview:lineView];
    lineView.backgroundColor = [UIColor colorWithHexString:@"#DDDDDD"];
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(numberTextFiled);
        make.height.mas_equalTo(0.5);
        make.top.mas_equalTo(numberTextFiled.mas_bottom).offset(Adapted(-3));
    }];
  
    //可用数量
    UILabel *availableLabel = [[UILabel alloc]init];
    availableLabel.textColor = k99999Color;
    availableLabel.font = H13;
    [self.contentView addSubview:availableLabel];
    [availableLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(Adapted(16));
        make.top.mas_equalTo(lineView.mas_bottom).offset(Adapted(16));
        make.bottom.mas_equalTo(self.contentView).offset(Adapted(-15));
    }];
    self.availableLabel = availableLabel;
    //全部划转
    UIButton *allTransferButton = [[UIButton alloc]init];
    [allTransferButton setTitleColor:kRedColor forState:UIControlStateNormal];
    [allTransferButton setTitle:kLocalizedString(@"全部转移") forState:UIControlStateNormal];
    [allTransferButton.titleLabel setFont:H13];
    [self.contentView addSubview:allTransferButton];
    [allTransferButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(availableLabel);
        make.right.mas_equalTo(lineView);
        make.bottom.mas_equalTo(Adapted(-14));
    }];
    self.allTransferButton = allTransferButton;
}

- (void)configWithViewModel:(MGCapitalTransferVM *)viewModel
{
    self.availableLabel.text = [NSString stringWithFormat:@"%@:%@%@",kLocalizedString(@"可用数量"),viewModel.availableBalance,viewModel.tradeCode];
}

@end
