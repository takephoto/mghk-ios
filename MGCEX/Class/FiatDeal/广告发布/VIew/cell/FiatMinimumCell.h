// MGC
//
// FiatMinimumCell.h
// MGCEX
//
// Created by MGC on 2018/5/30.
// Copyright © 2018年 MGCion. All rights reserved.
//
// @ description <#描述#> 

#import "BaseTableViewCell.h"

@interface FiatMinimumCell : BaseTableViewCell
@property (nonatomic, strong) UITextField *minNumerTextField;
@property (nonatomic, strong) UITextField *minAountField;
@property (nonatomic, strong) NSString *price;
@property (nonatomic, strong) UILabel * unitRight;
@end
