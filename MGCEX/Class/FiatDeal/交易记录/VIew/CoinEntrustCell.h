// MGC
//
// CoinEntrustCell.h
// MGCEX
//
// Created by MGC on 2018/6/8.
// Copyright © 2018年 MGCion. All rights reserved.
//
// @ description <#描述#> 

#import "BaseTableViewCell.h"
#import "CoinEntrustModelList.h"

@interface CoinEntrustCell : BaseTableViewCell
@property (nonatomic, strong) UIButton *button;
@property (nonatomic, strong) CoinEntrustModelList * model;
@end
