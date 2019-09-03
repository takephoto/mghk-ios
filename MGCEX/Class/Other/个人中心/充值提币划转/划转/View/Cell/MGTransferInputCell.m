//
//  MGTransferInputCell.m
//  MGCEX
//
//  Created by Joblee on 2018/6/7.
//  Copyright © 2018年 MGCion. All rights reserved.
//

#import "MGTransferInputCell.h"

@implementation MGTransferInputCell

-(void)bindModel
{
    
}
- (void)setUpViews
{
    self.backgroundColor = kBackGroundColor;
    self.contentView.backgroundColor = white_color;
    
    //划转数量
    UILabel *numLab = [[UILabel alloc]init];
    numLab.text = kLocalizedString(@"划转数量");
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
    numTextFiled.placeholder = kLocalizedString(@"请输入划转数量");
    numTextFiled.textColor = k99999Color;
    numTextFiled.font = H15;
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
    lineView.backgroundColor = [UIColor colorWithHexString:@"#DDDDDD"];
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(numTextFiled);
        make.height.mas_equalTo(0.5);
        make.top.mas_equalTo(numTextFiled.mas_bottom).offset(Adapted(-3));
    }];
    self.lineView = lineView;
    //可用数量
    UILabel *availableLab = [[UILabel alloc]init];
    availableLab.textColor = k99999Color;
    availableLab.font = H13;
    [self.contentView addSubview:availableLab];
    [availableLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(Adapted(16));
        make.top.mas_equalTo(lineView.mas_bottom).offset(Adapted(16));
        make.bottom.mas_equalTo(self.contentView).offset(Adapted(-15));
    }];
    self.availableLab = availableLab;
    //全部划转
    UIButton *allBtn = [[UIButton alloc]init];
    [allBtn setTitleColor:kRedColor forState:UIControlStateNormal];
    [allBtn setTitle:kLocalizedString(@"全部划转") forState:UIControlStateNormal];
    [allBtn.titleLabel setFont:H13];
    [self.contentView addSubview:allBtn];
    [allBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(availableLab);
        make.right.mas_equalTo(lineView);
        make.bottom.mas_equalTo(Adapted(-14));
    }];
    self.allBtn = allBtn;
}

@end
