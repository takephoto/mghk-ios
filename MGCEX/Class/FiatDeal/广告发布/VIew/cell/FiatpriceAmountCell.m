// MGC
//
// FiatpriceAmountCell.m
// MGCEX
//
// Created by MGC on 2018/5/30.
// Copyright © 2018年 MGCion. All rights reserved.
//
// @ description <#描述#> 

#import "FiatpriceAmountCell.h"

@implementation FiatpriceAmountCell

-(void)setUpViews{
    
    self.backgroundColor = white_color;
    
    NSArray * titleArr = @[kLocalizedString(@"单价"),kLocalizedString(kLocalizedString(@"数量"))];
    NSArray * unitArr = @[@"CNY",@"BTC"];
    UIView *lineView = nil;
    
    self.priceBgView = [[UIView alloc] init];
    self.priceBgView.backgroundColor = self.backgroundColor;
    [self.contentView addSubview:self.priceBgView];
    [self.priceBgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.mas_equalTo(0);
        make.height.mas_equalTo(Adapted(46));
    }];
    
    for(int i=0;i<2;i++){
        
        UILabel * titleLabel = [[UILabel alloc]init];
        [self.contentView addSubview:titleLabel];
        titleLabel.text = titleArr[i];
        titleLabel.textColor = kTextColor;
        titleLabel.font = H15;
        [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(Adapted(15));
            make.top.mas_equalTo(Adapted(15)+Adapted(48)*i);
            make.width.mas_equalTo(Adapted(80));
        }];
        
        UILabel * unitLabel = [[UILabel alloc]init];
        [self.contentView addSubview:unitLabel];
        unitLabel.text = titleArr[i];
        unitLabel.textColor = kAssistTextColor;
        unitLabel.font = H15;
        unitLabel.textAlignment = NSTextAlignmentRight;
        unitLabel.text = unitArr[i];
        [unitLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(Adapted(-15));
            make.centerY.mas_equalTo(titleLabel);
            make.width.mas_equalTo(Adapted(40));
        }];
        unitLabel.tag = 10+i;
        if (i == 1) {
            self.coinTypeLab = unitLabel;
        }
        UITextField * textFiled = [[UITextField alloc]init];
        [self.contentView addSubview:textFiled];
        textFiled.textAlignment = NSTextAlignmentRight;
        if(i == 0){
            textFiled.placeholder = kLocalizedString(@"请输入单价");
        }else {
            textFiled.placeholder = kLocalizedString(@"请输入数量");
        }
        textFiled.textColor = kTextColor;
        [textFiled mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(titleLabel.mas_right);
            make.right.mas_equalTo(unitLabel.mas_left).offset(Adapted(0));
            make.centerY.mas_equalTo(titleLabel);
        }];
        textFiled.tag = 20+i;
        //分割线
        lineView = [[UIView alloc]init];
        [self.contentView addSubview:lineView];
        lineView.backgroundColor = kLineColor;
        [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(Adapted(15));
            make.right.mas_equalTo(Adapted(-15));
            make.height.mas_equalTo(1);
            make.top.mas_equalTo(titleLabel.mas_bottom).offset(Adapted(12));
        }];
        if (i == 0) {
            self.priceLineView = lineView;
        }
    }
    
    self.priceUnit = [self viewWithTag:10];
    self.numberUnit = [self viewWithTag:11];
    self.prictTextFiled = [self viewWithTag:20];
    self.numberTextFiled = [self viewWithTag:21];
    
    self.prictTextFiled.limitDecimalDigitLength = s_Integer(2);
    self.numberTextFiled.limitDecimalDigitLength = s_Integer(6);
    self.prictTextFiled.keyboardType = UIKeyboardTypeDecimalPad;
    self.numberTextFiled.keyboardType = UIKeyboardTypeDecimalPad;
    @weakify(self);
    self.prictTextFiled.endEditBlock = ^(NSString *text) {
        @strongify(self);
        if(text.length>0){
            NSString *last = [text substringFromIndex:text.length-1];
            if([last isEqualToString:@"."]){
                self.prictTextFiled.text = [text substringToIndex:([text length]-1)];
                
            }
        }
        
    };
    

    self.numberTextFiled.endEditBlock = ^(NSString *text) {
        @strongify(self);
        if(text.length>0){
            NSString *last = [text substringFromIndex:text.length-1];
            if([last isEqualToString:@"."]){
                self.numberTextFiled.text = [text substringToIndex:([text length]-1)];
                
            }
        }
        
    };
    
    UILabel * hintLabel = [[UILabel alloc]init];
    [self.contentView addSubview:hintLabel];
    hintLabel.textColor = k99999Color;
    hintLabel.font = H15;
    hintLabel.text = kLocalizedString(@"该币种可用数量:");
    hintLabel.numberOfLines = 2;
    [hintLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(lineView.mas_bottom).offset(Adapted(12));
        make.left.mas_equalTo(Adapted(15));
        make.bottom.mas_equalTo(Adapted(-15));
        make.right.mas_equalTo(Adapted(-15));
    }];
    self.hintLabel = hintLabel;
    self.prictTextFiled.limitDecimalDigitLength = s_Integer(2);
}

@end
