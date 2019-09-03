// MGC
//
// SellFiatDealTableViewCell.h
// MGCEX
//
// Created by MGC on 2018/5/24.
// Copyright © 2018年 MGCion. All rights reserved.
//
// @ description <#描述#> 

#import "BaseTableViewCell.h"
#import "FiatDealBuyOrSellmodels.h"
#import "FiatDealBuyOrSellModel.h"

@class SellFiatDealTableViewCell;
@protocol SellFiatDealDelegate // 代理传值方法
- (void)SellFiatDealWithBuy:(FiatDealBuyOrSellModel *)model;

@end

@interface SellFiatDealTableViewCell : BaseTableViewCell
@property (nonatomic, weak) NSObject <SellFiatDealDelegate>* sellDelegate;
@property (nonatomic, strong) FiatDealBuyOrSellmodels * model;
@end
