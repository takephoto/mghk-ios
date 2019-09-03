//
//  MGWithdrawTVCCell.m
//  MGCEX
//
//  Created by Joblee on 2018/6/7.
//  Copyright © 2018年 MGCion. All rights reserved.
//

#import "MGWithdrawTVCCell.h"

@implementation MGWithdrawTVCCell

-(void)bindModel
{
    
}
- (void)setUpViews
{
    self.backgroundColor = kBackGroundColor;
    self.contentView.backgroundColor = white_color;
    
    //提现地址
    UILabel *numLab = [[UILabel alloc]init];
    numLab.text = kLocalizedString(@"提现地址");
    numLab.textColor = kTextColor;
    numLab.font = H15;
    [self.contentView addSubview:numLab];
    [numLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.mas_equalTo(Adapted(16));
        make.height.mas_equalTo(Adapted(16));
    }];
    self.numLab = numLab;
    
    //输入框
    UITextField * numTextFiled = [[UITextField alloc]init];
    //    self.minAountField = textFiled2;
    [self.contentView addSubview:numTextFiled];
    numTextFiled.placeholder = kLocalizedString(@"提现地址");
    numTextFiled.textColor = kTextColor;
    numTextFiled.font = H14;
    [numTextFiled mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(Adapted(-16.0));
        make.left.mas_equalTo(numLab);
        make.top.mas_equalTo(numLab.mas_bottom).offset(Adapted(24-15));
        make.height.mas_equalTo(Adapted(44.0));
    }];
    self.numTextFiled = numTextFiled;
    //分割线
    UIView * lineView = [[UIView alloc]init];
    [self.contentView addSubview:lineView];
    lineView.backgroundColor = kLineColor;
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(numTextFiled);
        make.height.mas_equalTo(0.8);
        make.top.mas_equalTo(numTextFiled.mas_bottom).offset(Adapted(-3));
        make.bottom.mas_equalTo(self.contentView).offset(Adapted(-16));
    }];
    self.lineView = lineView;
}
@end
