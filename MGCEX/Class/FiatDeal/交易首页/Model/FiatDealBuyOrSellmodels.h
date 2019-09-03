// MGC
//
// FiatDealBuyOrSellmodels.h
// MGCEX
//
// Created by MGC on 2018/6/1.
// Copyright © 2018年 MGCion. All rights reserved.
//
// @ description <#描述#> 

#import <Foundation/Foundation.h>

@interface FiatDealBuyOrSellmodels : NSObject

@property (nonatomic, copy) NSString * advertisingOrderId;
@property (nonatomic, copy) NSString * advertisingTime;
@property (nonatomic, copy) NSString * amountMax;
@property (nonatomic, copy) NSString * amountMin;
/// 买卖方式 1-买，2-卖
@property (nonatomic, copy) NSString * buysell;
@property (nonatomic, copy) NSString * completionOrderVal;
@property (nonatomic, copy) NSString * doneTime;
@property (nonatomic, copy) NSString * frozenStatus;
@property (nonatomic, copy) NSString * hightVal;
@property (nonatomic, copy) NSString * lowVal;
@property (nonatomic, copy) NSString * merchartType;
@property (nonatomic, copy) NSString * nickname;
@property (nonatomic, copy) NSString * orderStatus;
@property (nonatomic, copy) NSString * pageIndex;
@property (nonatomic, copy) NSString * payVal;
@property (nonatomic, copy) NSString * priceVal;
/// 剩余数量
@property (nonatomic, copy) NSString * remainOrderNumber;
@property (nonatomic, copy) NSString * salesVal;
@property (nonatomic, copy) NSString * showCurrentUsers;
@property (nonatomic, copy) NSString * summary;
@property (nonatomic, copy) NSString * tradeCode;
@property (nonatomic, copy) NSString * userId;
// 广告发布类型
@property (nonatomic, assign) NSInteger type;


@end
