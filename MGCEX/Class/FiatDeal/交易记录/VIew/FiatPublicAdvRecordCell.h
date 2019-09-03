// MGC
//
// FiatPublicAdvRecordCell.h
// MGCEX
//
// Created by MGC on 2018/6/3.
// Copyright © 2018年 MGCion. All rights reserved.
//
// @ description <#描述#> 

#import "BaseTableViewCell.h"
#import "FiatDealBuyOrSellmodels.h"

@interface FiatPublicAdvRecordCell : BaseTableViewCell
@property (nonatomic, strong) FiatDealBuyOrSellmodels * model;
@property (nonatomic, strong) UIButton * undoButton;
@end
