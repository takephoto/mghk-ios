// MGC
//
// FiatDealBuyOrSellModel.h
// MGCEX
//
// Created by MGC on 2018/5/25.
// Copyright © 2018年 MGCion. All rights reserved.
//
// @ description <#描述#> 

#import <Foundation/Foundation.h>



@interface FiatDealBuyOrSellModel : NSObject
singletonInterface(FiatDealBuyOrSellModel);

@property (nonatomic, copy) NSString * adUserId;//广告用户ID
@property (nonatomic, copy) NSString * advertisingOrderId;//广告id
@property (nonatomic, copy) NSString * title;
@property (nonatomic, copy) NSString * unitPrice;//单价
@property (nonatomic, copy) NSString * number;
@property (nonatomic, copy) NSString * limitMin;
@property (nonatomic, copy) NSString * limitMax;
@property (nonatomic, copy) NSString * currency;
@property (nonatomic, copy) NSString * payString;
@property (nonatomic, assign) BOOL isVip;
@property (nonatomic, assign) BOOL isBuy;




@end
