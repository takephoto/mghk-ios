//
//  MGLineChartFooterView.m
//  MGCEX
//
//  Created by Joblee on 2018/6/6.
//  Copyright © 2018年 MGCion. All rights reserved.
//

#import "MGLineChartFooterView.h"

@implementation MGLineChartFooterView

- (void)setupSubviews
{
    
    //买入
    UIButton *buyBtn = [[UIButton alloc]init];
    buyBtn.backgroundColor = kGreenColor;
    [buyBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [buyBtn setTitle:kLocalizedString(@"买入") forState:UIControlStateNormal];
    buyBtn.titleLabel.font = HB18;
    [self addSubview:buyBtn];
    [buyBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_offset(Adapted(15));
        make.width.mas_offset(Adapted(120));
        make.height.mas_offset(Adapted(44));
        make.centerY.mas_offset(0);
    }];
    [buyBtn.superview layoutIfNeeded];
    self.buyBtn = buyBtn;
    
    //卖出
    UIButton *sellBtn = [[UIButton alloc]init];
    sellBtn.backgroundColor = UIColorFromRGB(0xFF4F4F);
    [sellBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [sellBtn setTitle:kLocalizedString(@"卖出") forState:UIControlStateNormal];
    sellBtn.titleLabel.font = HB18;
    [self addSubview:sellBtn];
    [sellBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(Adapted(120));
        make.height.mas_offset(Adapted(44));
        make.centerY.mas_offset(0);
        make.left.mas_equalTo(buyBtn.mas_right).offset(Adapted(15));
    }];
    self.sellBtn = sellBtn;

    //自选
    QSButton *collectBtn = [[QSButton alloc]init];
    [collectBtn setTitleColor:UIColorFromRGB(0x879CCD) forState:UIControlStateNormal];
    [collectBtn setImage:IMAGE(@"icon_optional_off") forState:UIControlStateNormal];
    [collectBtn setImage:IMAGE(@"icon_optional_on") forState:UIControlStateSelected];
    collectBtn.style = QSButtonImageStyleTop;
    collectBtn.space = Adapted(8.0);
    [collectBtn setTitle:kLocalizedString(@"自选") forState:UIControlStateNormal];
    [collectBtn.titleLabel setFont:H12];
    [self addSubview:collectBtn];
    [collectBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-Adapted(15));
        make.centerY.mas_offset(0);
    }];
    self.collectBtn = collectBtn;
    
    self.backgroundColor = kKLineBGColor;
}
@end
