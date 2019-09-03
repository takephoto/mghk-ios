// MGC
//
// FiatTradingModel.h
// MGCEX
//
// Created by MGC on 2018/5/28.
// Copyright © 2018年 MGCion. All rights reserved.
//
// @ description <#描述#> 

#import <Foundation/Foundation.h>

@interface FiatTradingModel : NSObject


@property (nonatomic, assign) BOOL isShow;


@property (nonatomic, copy) NSString * promptNote;//交易内容
@property (nonatomic, copy) NSString * advUserid;
@property (nonatomic, copy) NSString * advertisingOrderId;
@property (nonatomic, copy) NSString * appealStatus;//申诉状态
@property (nonatomic, copy) NSString * buysell;
@property (nonatomic, copy) NSString * cueName;
@property (nonatomic, copy) NSString * cueUserId;
@property (nonatomic, copy) NSString * finishTime;
@property (nonatomic, copy) NSString * isAdvertising;
@property (nonatomic, copy) NSString * isMerchant;
@property (nonatomic, copy) NSString * merchartType;
@property (nonatomic, copy) NSString * orderStatus;//订单状态
@property (nonatomic, copy) NSString * orderTime;
@property (nonatomic, copy) NSString * pageIndex;
@property (nonatomic, copy) NSString * payIdentificationCode;
@property (nonatomic, copy) NSString * payType;
@property (nonatomic, copy) NSString * priceVal;
@property (nonatomic, copy) NSString * reTime;
@property (nonatomic, copy) NSString * shopName;
@property (nonatomic, copy) NSString * tradeAmount;
@property (nonatomic, copy) NSString * tradeCode;
@property (nonatomic, copy) NSString * tradeOrderId;
@property (nonatomic, copy) NSString * tradeQuantity;
@property (nonatomic, copy) NSString * tradeStatus;
@property (nonatomic, copy) NSString * tradingUserid;
@property (nonatomic, copy) NSString * userId;
@property (nonatomic, copy) NSString * tradeStatusString;
@property (nonatomic, copy) NSString * promptRed;
@property (nonatomic, copy) NSString *phoneNumber;

@end
