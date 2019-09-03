// MGC
//
// CoinDealIndexVM.h
// MGCEX
//
// Created by MGC on 2018/6/9.
// Copyright © 2018年 MGCion. All rights reserved.
//
// @ description <#描述#> 

#import "BaseViewModel.h"
#import "QuotesModel.h"
#import "CoinDealMarkModel.h"
#import "CoinRemainModel.h"
#import "UnsettledGearModel.h"
#import "CoinEntrustModelList.h"
#import "OptionalModel.h"
#import "MinVolumeModel.h"
#import "MinWaveModel.h"

@interface CoinDealIndexVM : BaseViewModel

//盘面行情
@property (nonatomic, strong) RACSignal * quotesSignal;
@property (nonatomic, strong) NSArray * transPares;


//买卖五档
@property (nonatomic, strong) RACSignal * unsettledGearSignal;
@property (nonatomic, strong) NSString * tradeCode;
@property (nonatomic, strong) NSString * gearNum;

//委托下单
@property (nonatomic, strong) RACSignal * addEntrustmentSignal;
@property (nonatomic, copy) NSString * type;
@property (nonatomic, copy) NSString * buysell;
@property (nonatomic, copy) NSString * market;
@property (nonatomic, copy) NSString * symbol;
@property (nonatomic, copy) NSString * price;
@property (nonatomic, copy) NSString * volume;
@property (nonatomic, copy) NSString * amount;


//获取交易对
@property (nonatomic, strong) RACSignal * getcurrencysSignal;


//获取币币可用数量
@property (nonatomic, strong) RACSignal * getCoinRemainSignal;
@property (nonatomic, strong) NSString * remainCoin;

//撤单
@property (nonatomic, strong) RACSignal * removrOrderSignal;
@property (nonatomic, copy) NSString * orderId;

//我的委托列表
@property (nonatomic, strong) RACSignal *myEntrustmentsSignal;
///我的委托列表命令
@property (nonatomic, strong) RACCommand * entrustRefreshCommand;
@property (nonatomic, assign) NSInteger  currentPage;
@property (nonatomic, assign) BOOL  isRefresh;
@property (nonatomic, copy) NSString * markStr;
@property (nonatomic, copy) NSString * trocodeStr;


//获取我的自选
@property (nonatomic, strong) RACSignal *getMyChoiceSignal;
@property (nonatomic, copy) NSString * transPare;
//添加我的自选
@property (nonatomic, strong) RACSignal *addMyChoiceSignal;

//取消我的自选
@property (nonatomic, strong) RACSignal *cancelMyChoiceSignal;
@property (nonatomic, copy) NSString * transPareId;


//获取最小交易量
@property (nonatomic, strong) RACSignal *minVolumeSignal;

//获取最小变动单位
@property (nonatomic, strong) RACSignal *minWaveSignal;
@end
