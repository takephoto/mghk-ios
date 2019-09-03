// MGC
//
// CoinDealIndexVC.h
// MGCEX
//
// Created by MGC on 2018/5/10.
// Copyright © 2018年 MGCion. All rights reserved.
//
// @ description <#描述#> 

#import "BaseTableViewController.h"
#import "BaseTableViewGroup.h"

@interface CoinDealIndexVC : BaseTableViewGroup

@property (nonatomic, copy) NSString * markStr;//市场
@property (nonatomic, copy) NSString * trCode;//币种
///买/卖
@property (nonatomic, assign) BOOL isBuy;
@end
