// MGC
//
// RechargeAddressVC.h
// MGCEX
//
// Created by MGC on 2018/6/7.
// Copyright © 2018年 MGCion. All rights reserved.
//
// @ description <#描述#> 

#import "BaseTableViewController.h"

@interface RechargeAddressVC : BaseTableViewController
///参数tradeCode":"ETH"
@property (nonatomic, copy) NSString *tradeCode;
///充币地址
@property (nonatomic, copy) NSString *isfucUrl;
@end
