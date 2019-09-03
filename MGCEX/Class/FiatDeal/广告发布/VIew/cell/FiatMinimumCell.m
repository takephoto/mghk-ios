// MGC
//
// FiatMinimumCell.m
// MGCEX
//
// Created by MGC on 2018/5/30.
// Copyright © 2018年 MGCion. All rights reserved.
//
// @ description <#描述#> 

#import "FiatMinimumCell.h"

@implementation FiatMinimumCell
/**
 绑定属性
 */
- (void)bindModel{

}
-(void)setUpViews{
    
    self.backgroundColor = white_color;
    
    UILabel * titleLabel = [[UILabel alloc]init];
    [self.contentView addSubview:titleLabel];
    titleLabel.textColor = kTextColor;
    titleLabel.font = H15;
    titleLabel.text = kLocalizedString(@"交易最小额度");
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(Adapted(15));
        make.top.mas_equalTo(Adapted(15));
        make.right.mas_equalTo(self.mas_right).offset(-15);
    }];
    //交换imageV
    UIImageView * changeImageV = [[UIImageView alloc]init];
    [self.contentView addSubview:changeImageV];
    changeImageV.image = IMAGE(@"icon_fb_zhtb");
    [changeImageV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(titleLabel.mas_bottom).offset(Adapted(18));
        make.centerX.mas_equalTo(self);
        make.width.mas_equalTo(Adapted(15));
        make.height.mas_equalTo(Adapted(11));
    }];
    
    //右边
    self.unitRight = [[UILabel alloc]init];
    [self.contentView addSubview:self.unitRight];
    self.unitRight.textColor = k99999Color;
    self.unitRight.font = H15;
    self.unitRight.text = @"BTC";
    self.unitRight.textAlignment = NSTextAlignmentRight;
    [self.unitRight mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(Adapted(-15));
        make.centerY.mas_equalTo(changeImageV);
        make.width.mas_equalTo(Adapted(40));
    }];

    
    UITextField * textFiled = [[UITextField alloc]init];
    [self.contentView addSubview:textFiled];
    textFiled.placeholder = kLocalizedString(@"请输入数量");
    textFiled.textColor = kTextColor;
    [textFiled mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.unitRight.mas_left).offset(0);
        make.left.mas_equalTo(changeImageV.mas_right).offset(15);
        make.centerY.mas_equalTo(changeImageV);
    }];
    self.minNumerTextField = textFiled;
    
    
    UIView * lineView = [[UIView alloc]init];
    [self.contentView addSubview:lineView];
    lineView.backgroundColor = kLineColor;
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(changeImageV.mas_right).offset(15);
        make.right.mas_equalTo(Adapted(-15));
        make.height.mas_equalTo(1);
        make.top.mas_equalTo(textFiled.mas_bottom).offset(Adapted(10));
    }];
    
    //左边
    UILabel * unitLeft = [[UILabel alloc]init];
    [self.contentView addSubview:unitLeft];
    unitLeft.textAlignment = NSTextAlignmentRight;
    unitLeft.textColor = k99999Color;
    unitLeft.font = H15;
    unitLeft.text = @"CNY";
    [unitLeft mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(changeImageV.mas_left).offset(-15);
        make.centerY.mas_equalTo(changeImageV);
        make.width.mas_equalTo([UIView getLabelWidthByHeight:20 Title:unitLeft.text font:H15]);
    }];


    UITextField * textFiled2 = [[UITextField alloc]init];
    self.minAountField = textFiled2;
    [self.contentView addSubview:textFiled2];
    textFiled2.placeholder = kLocalizedString(@"请输入金额");
    textFiled2.textColor = kTextColor;
    [textFiled2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(unitLeft.mas_left).offset(-5);
        make.left.mas_equalTo(Adapted(15));
        make.centerY.mas_equalTo(changeImageV);
    }];


    UIView * lineView2 = [[UIView alloc]init];
    [self.contentView addSubview:lineView2];
    lineView2.backgroundColor = kLineColor;
    [lineView2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(Adapted(15));
        make.right.mas_equalTo(changeImageV.mas_left).offset(-15);
        make.height.mas_equalTo(1);
        make.top.mas_equalTo(textFiled2.mas_bottom).offset(Adapted(10));
        make.bottom.mas_equalTo(Adapted(-15));
    }];
    
    
    textFiled.keyboardType = UIKeyboardTypeDecimalPad;
    textFiled2.keyboardType = UIKeyboardTypeDecimalPad;
    @weakify(self)
    self.minNumerTextField.didChangeBlock = ^(NSString *text) {
       @strongify(self)
        if ([self.price doubleValue] > 0) {
            double amount = [textFiled.text doubleValue] * [self.price doubleValue];
            textFiled2.text = [NSString stringWithFormat:@"%.2f",amount];
        }else{
            [TTWHUD showCustomMsg:kLocalizedString(@"请先设置单价")];
        }
        
    };
    self.minAountField.didChangeBlock = ^(NSString *text) {
        @strongify(self)
        if ([self.price doubleValue] > 0) {
            double amount = [textFiled2.text doubleValue] / [self.price doubleValue];
            textFiled.text = [NSString stringWithFormat:@"%.8f",amount];
        }else{
            [TTWHUD showCustomMsg:kLocalizedString(@"请先设置单价")];
        }
        
        
    };
    textFiled.limitDecimalDigitLength = s_Integer(8);
    textFiled2.limitDecimalDigitLength = s_Integer(2);

    
}

@end
