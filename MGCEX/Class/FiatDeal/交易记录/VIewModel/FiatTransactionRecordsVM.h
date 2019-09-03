// MGC
//
// FiatTransactionRecordsVM.h
// MGCEX
//
// Created by MGC on 2018/6/1.
// Copyright © 2018年 MGCion. All rights reserved.
//
// @ description <#描述#> 

#import <Foundation/Foundation.h>
#import "BaseViewModel.h"
#import "FiatTRecordsModels.h"
#import "AllCurrencyModels.h"
#import "FiatDealBuyOrSellmodels.h"
#import "FiatDealBuyOrSellModelList.h"
#import "CoinEntrusHistoryModel.h"
#import "CoinEntrustModelList.h"
#import "FillCoinRecodeModel.h"
#import "TakeCoinRecordModel.h"

@interface FiatTransactionRecordsVM : BaseViewModel

//获取法币订单列表
@property (nonatomic, strong) RACSignal * recordSignal;
//获取发布广告
@property (nonatomic, strong) RACSignal * publicAdsSignal;
///刷新C2C/B2C数据命令
@property (nonatomic, strong) RACCommand * refreshCommand;
///刷新发布广告命令
@property (nonatomic, strong) RACCommand * adsRefreshCommand;

@property (nonatomic, assign) NSInteger  currentPage;
@property (nonatomic, assign) BOOL  isRefresh;

//获取所有币种
@property (nonatomic, copy) NSString * tradeCode;
@property (nonatomic, copy) NSString * market;
@property (nonatomic, copy) NSString * orderTime;
@property (nonatomic, copy) NSString * orderStatus;
@property (nonatomic, copy) NSString * tradeOrderId;
@property (nonatomic, copy) NSString * buysell;


//获取广告
@property (nonatomic, copy) NSString * advertisingOrderId;
@property (nonatomic, copy) NSString * merchartType;
@property (nonatomic, copy) NSString * payVal;
@property (nonatomic, copy) NSString * frozenStatus;
@property (nonatomic, copy) NSString * showCurrentUsers;
@property (nonatomic, copy) NSString * amountMin;
@property (nonatomic, copy) NSString * amountMax;

//获取所有币种
@property (nonatomic, strong) RACSignal * allCurrencySignal;
@property (nonatomic, copy) NSString * isVaild;

//我的委托列表
@property (nonatomic, strong) RACSignal *myEntrustmentsSignal;
///我的委托列表命令
@property (nonatomic, strong) RACCommand * entrustRefreshCommand;


//我的委托列表历史记录
@property (nonatomic, strong) RACSignal *myEntrHistorySignal;
///我的历史记录委托列表命令
@property (nonatomic, strong) RACCommand * entrHistoryRefreshCommand;
@property (nonatomic, copy) NSString * markStr;
@property (nonatomic, copy) NSString * trocodeStr;
//是否全部历币币史记录
@property (nonatomic, assign) BOOL isAllHistory;
//广告撤单
@property (nonatomic, strong) RACSignal * removeSignal;

///币币交易历史记录
@property (nonatomic, strong) RACCommand * entrHistoryCommand;
///获取历史记录
@property (nonatomic, strong) RACSignal *tradeRecordSignal;
//币币委托撤单
@property (nonatomic, strong) RACSignal * removrOrderSignal;
@property (nonatomic, copy) NSString * orderId;


//提币记录列表刷新命令
@property (nonatomic, strong) RACCommand * takeOutCoinCommand;
//提币记录列表
@property (nonatomic, strong) RACSignal * takeOutCoinSignal;



//充币记录列表刷新命令
@property (nonatomic, strong) RACCommand * fillCoinCommand;
//充币记录列表
@property (nonatomic, strong) RACSignal * fillCoinSignal;
@end
