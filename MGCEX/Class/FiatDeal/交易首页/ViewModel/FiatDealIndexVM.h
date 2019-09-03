// MGC
//
// FiatDealIndexVM.h
// MGCEX
//
// Created by MGC on 2018/6/1.
// Copyright © 2018年 MGCion. All rights reserved.
//
// @ description <#描述#> 

#import "BaseViewModel.h"
#import "FiatDealBuyOrSellModel.h"
#import "FiatDealBuyOrSellModelList.h"

@interface FiatDealIndexVM : BaseViewModel

//获取法币订单列表
@property (nonatomic, strong) RACSignal * recordSignal;
///刷新数据命令
@property (nonatomic, strong) RACCommand * refreshCommand;
@property (nonatomic, assign) NSInteger  currentPage;
@property (nonatomic, assign) BOOL  isRefresh;

//下单
@property (nonatomic, strong) RACSignal * orderSignal;
@property (nonatomic, copy) NSString * orderBuysell;
@property (nonatomic, copy) NSString * orderAdvertisingOrderId;
@property (nonatomic, copy) NSString * orderTradeAmount;
@property (nonatomic, copy) NSString * orderTradeQuantity;
@property (nonatomic, copy) NSString * orderTradeCode;
@property (nonatomic, copy) NSString * adUserId;
@property (nonatomic, copy) NSString * payBuySell;

//法币交易
@property (nonatomic, copy) NSString * buysell;//买卖
@property (nonatomic, copy) NSString * advertisingOrderId;
@property (nonatomic, copy) NSString * tradeCode;
@property (nonatomic, copy) NSString * merchartType;
@property (nonatomic, copy) NSString * payVal;
@property (nonatomic, copy) NSString * orderStatus;
@property (nonatomic, copy) NSString * frozenStatus;
@property (nonatomic, copy) NSString * showCurrentUsers;
@property (nonatomic, copy) NSString * amountMin;
@property (nonatomic, copy) NSString * amountMax;

//获取国际行情价格
@property (nonatomic, strong) RACSignal * markPriceSignal;

@end
