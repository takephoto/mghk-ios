// MGC
//
// BuyFiatDealTableViewCell.h
// MGCEX
//
// Created by MGC on 2018/5/24.
// Copyright © 2018年 MGCion. All rights reserved.
//
// @ description <#描述#> 

#import "BaseTableViewCell.h"
#import "FiatDealBuyOrSellmodels.h"
#import "FiatDealBuyOrSellModel.h"

@class BuyFiatDealTableViewCell;
@protocol BuyFiatDealDelegate // 代理传值方法
- (void)BuyFiatDealWithBuy:(FiatDealBuyOrSellModel * )model;

@end

@interface BuyFiatDealTableViewCell : BaseTableViewCell
@property (nonatomic, weak) NSObject <BuyFiatDealDelegate>* buyDelegate;
@property (nonatomic, strong) FiatDealBuyOrSellmodels * model;
@end
