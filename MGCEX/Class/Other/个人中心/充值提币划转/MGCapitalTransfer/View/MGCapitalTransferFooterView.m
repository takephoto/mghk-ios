//
//  MGCapitalTransferFooterView.m
//  MGCEX
//
//  Created by 汪跃山 on 2018/7/10.
//  Copyright © 2018年 MGCion. All rights reserved.
//

#import "MGCapitalTransferFooterView.h"

@implementation MGCapitalTransferFooterView

- (void)setupSubviews
{
    QSButton * summitBtn = [[UIButton alloc]init];
    [summitBtn setTitleColor:white_color forState:UIControlStateNormal];
    [summitBtn setBackgroundColor:kRedColor];
    ViewRadius(summitBtn, Adapted(40.0/2));
    [_summitBtn setTitle:kLocalizedString(@"提交") forState:UIControlStateNormal];
    [_summitBtn.titleLabel setFont:H15];
    [self addSubview:summitBtn];
    self.summitBtn = summitBtn;
    
    [_summitBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(Adapted(30));
        make.left.mas_equalTo(Adapted(16));
        make.right.mas_equalTo(Adapted(-16));
        make.bottom.mas_equalTo(0);
    }];
}

@end
