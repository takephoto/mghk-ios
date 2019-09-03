// MGC
//
// FiatTransactionRecordsModel.h
// MGCEX
//
// Created by MGC on 2018/6/1.
// Copyright © 2018年 MGCion. All rights reserved.
//
// @ description <#描述#> 

#import <Foundation/Foundation.h>

@interface FiatTransactionRecordsModel : NSObject

@property (nonatomic, copy) NSString * advuserId;
@property (nonatomic, copy) NSString * isAdvertising;
@property (nonatomic, copy) NSString * isMerchart;
@property (nonatomic, copy) NSString * orderStatus;
@property (nonatomic, copy) NSString * orderTime;
@property (nonatomic, copy) NSString * payType;
@property (nonatomic, copy) NSString * priceVal;
@property (nonatomic, copy) NSString * shopName;
@property (nonatomic, copy) NSString * tradeAmount;
@property (nonatomic, copy) NSString * tradeOrderId;
@property (nonatomic, copy) NSString * tradeQuantity;
@property (nonatomic, copy) NSString * userId;
@property (nonatomic, copy) NSString * tradeCode;
@property (nonatomic, copy) NSString * tradingUserid;
@property (nonatomic, copy) NSString * nikeName;
@property (nonatomic, copy) NSString * statusString;
@property (nonatomic, strong) UIColor * statusColor;
@end
