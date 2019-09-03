// MGC
//
// FiatpriceAmountCell.h
// MGCEX
//
// Created by MGC on 2018/5/30.
// Copyright © 2018年 MGCion. All rights reserved.
//
// @ description <#描述#> 

#import "BaseTableViewCell.h"

@interface FiatpriceAmountCell : BaseTableViewCell
@property (nonatomic, strong) UIView * priceBgView;
@property (nonatomic, strong) UITextField * prictTextFiled;
@property (nonatomic, strong) UIView * priceLineView;
@property (nonatomic, strong) UITextField * numberTextFiled;
@property (nonatomic, strong) UITextField * priceUnit;
@property (nonatomic, strong) UITextField * numberUnit;
//币种
@property (nonatomic, strong) UILabel *coinTypeLab;
//可用数量
@property (nonatomic, strong) UILabel * hintLabel;
@end
