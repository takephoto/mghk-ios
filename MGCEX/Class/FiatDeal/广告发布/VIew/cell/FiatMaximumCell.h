// MGC
//
// FiatMaximumCell.h
// MGCEX
//
// Created by MGC on 2018/5/30.
// Copyright © 2018年 MGCion. All rights reserved.
//
// @ description <#描述#> 

#import "BaseTableViewCell.h"

@interface FiatMaximumCell : BaseTableViewCell
@property (nonatomic, strong) UITextField *maxNumberTextField;
@property (nonatomic, strong) UITextField *maxAountField;
@property (nonatomic, strong) NSString *price;
@property (nonatomic, strong) UILabel * unitRight;
@end
