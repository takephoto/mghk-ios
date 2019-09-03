//
//  MGTransferCoinTypeCell.m
//  MGCEX
//
//  Created by Joblee on 2018/6/7.
//  Copyright © 2018年 MGCion. All rights reserved.
//

#import "MGTransferCoinTypeCell.h"


@implementation MGTransferCoinTypeCell

-(void)bindModel
{
    
}
- (void)setUpViews
{
    self.backgroundColor = white_color;
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
    typeLab.textColor = kTextColor;
    typeLab.font = H15;
    [self.contentView addSubview:typeLab];
    [typeLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.mas_equalTo(0);
        make.left.bottom.mas_equalTo(Adapted(16.0));
    }];
    
    //币种选择按钮
    QSButton *changeBtn = [[QSButton alloc]init];
    [changeBtn setTitleColor:kTextColor forState:UIControlStateNormal];
    [changeBtn setImage:IMAGE(@"icon_gdown") forState:UIControlStateNormal];
    changeBtn.style = QSButtonImageStyleRight;
    changeBtn.space = Adapted(5.0);
    [changeBtn.titleLabel setFont:H13];
    [self.contentView addSubview:changeBtn];
    [changeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(Adapted(- 21));
        make.centerY.mas_equalTo(self.contentView);
    }];
    self.changeBtn = changeBtn;
}
@end
