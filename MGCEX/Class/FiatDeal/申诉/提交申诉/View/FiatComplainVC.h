// MGC
//
// FiatComplainVC.h
// MGCEX
//
// Created by MGC on 2018/5/29.
// Copyright © 2018年 MGCion. All rights reserved.
//
// @ description <#描述#> 

#import "TWBaseViewController.h"

@interface FiatComplainVC : TWBaseViewController
///买入/卖出
@property (nonatomic, strong) NSString *sellBuy;
///订单id
@property (nonatomic, strong) NSString *fiatDealTradeOrderId;
///用户名
@property (nonatomic, strong) NSString *payeeName;

@end
