// MGC
//
// CoinAccountModel.h
// MGCEX
//
// Created by MGC on 2018/6/7.
// Copyright © 2018年 MGCion. All rights reserved.
//
// @ description <#描述#> 

#import <Foundation/Foundation.h>
#import "CoinCapListModel.h"

@interface CoinAccountModel : NSObject
@property (nonatomic, copy) NSString * btcCount;
@property (nonatomic, copy) NSString * cnySum;
@property (nonatomic, strong) NSArray * ufflist;
@end
