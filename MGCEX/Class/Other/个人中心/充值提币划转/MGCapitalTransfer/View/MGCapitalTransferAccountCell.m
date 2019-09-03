//
//  MGCapitalTransferAccountCell.m
//  MGCEX
//
//  Created by 汪跃山 on 2018/7/10.
//  Copyright © 2018年 MGCion. All rights reserved.
//

#import "MGCapitalTransferAccountCell.h"

@interface MGCapitalTransferAccountCell ()

@property (nonatomic, strong) UILabel *accountLabel;

@end

@implementation MGCapitalTransferAccountCell

- (void)setUpViews
{
    self.backgroundColor = [UIColor colorWithHexString:@"#f1f1f1"];
    self.contentView.backgroundColor = white_color;
    [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(Adapted(6.0));
        make.left.right.mas_equalTo(0);
        make.bottom.mas_equalTo(Adapted(-6.0));
    }];
    
    //转移至账户
    UILabel *accountLabel = [[UILabel alloc]init];
    accountLabel.text = kLocalizedString(@"转移至账户");
    accountLabel.textColor = kBackAssistColor;
    accountLabel.font = H15;
    [self.contentView addSubview:accountLabel];
    [accountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.mas_equalTo(Adapted(16));
        make.height.mas_equalTo(Adapted(16));
    }];
    self.accountLabel = accountLabel;
    
    //输入框
    UITextField * accountTextField = [[UITextField alloc]init];
    [self.contentView addSubview:accountTextField];
    accountTextField.placeholder = kLocalizedString(@"请输入对方手机号码/邮箱");
    accountTextField.textColor = k99999Color;
    accountTextField.font = H15;
    [accountTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(Adapted(-16.0));
        make.left.mas_equalTo(accountLabel);
        make.top.mas_equalTo(accountLabel.mas_bottom).offset(Adapted(24-15));
        make.height.mas_equalTo(Adapted(44.0));
    }];
    self.accountTextField = accountTextField;
    
    //分割线
    UIView * lineView = [[UIView alloc]init];
    [self.contentView addSubview:lineView];
    lineView.backgroundColor = [UIColor colorWithHexString:@"#DDDDDD"];
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(accountTextField);
        make.height.mas_equalTo(0.5);
        make.top.mas_equalTo(accountTextField.mas_bottom).offset(Adapted(-3));
        make.bottom.mas_equalTo(Adapted(-16));
    }];
    
}
@end
