//
//  MGCapitalTransferNameCell.m
//  MGCEX
//
//  Created by 汪跃山 on 2018/7/10.
//  Copyright © 2018年 MGCion. All rights reserved.
//

#import "MGCapitalTransferNameCell.h"

@interface MGCapitalTransferNameCell ()

@property (nonatomic, strong) UILabel *coinNameLabel;

@end

@implementation MGCapitalTransferNameCell

- (void)setUpViews
{
    self.backgroundColor = [UIColor colorWithHexString:@"#f1f1f1"];
    self.contentView.backgroundColor = white_color;
    [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(Adapted(6.0));
        make.left.right.mas_equalTo(0);
        make.height.mas_equalTo(Adapted(48.0));
        make.bottom.mas_equalTo(0);
    }];
    //币种
    UILabel *typeLab = [[UILabel alloc]init];
    typeLab.text = kLocalizedString(@"币种");
    typeLab.textColor = kBackAssistColor;
    typeLab.font = H15;
    [self.contentView addSubview:typeLab];
    [typeLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(Adapted(16.0));
        make.top.mas_equalTo(Adapted(15.0));
    }];
    
    //币种选择按钮
    UILabel *coinNameLabel = [[UILabel alloc]init];
    coinNameLabel.textColor = kBackAssistColor;
    coinNameLabel.textAlignment = NSTextAlignmentRight;
    coinNameLabel.font = H15;
    [self.contentView addSubview:coinNameLabel];
    [coinNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(Adapted(-16));
        make.centerY.mas_equalTo(self.contentView);
    }];
    self.coinNameLabel = coinNameLabel;
}

- (void)configWithViewModel:(MGCapitalTransferVM *)viewModel
{
    self.coinNameLabel.text = viewModel.tradeCode;
}

@end
