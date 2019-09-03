//
//  PlaceOrderVM.h
//  MGCEX
//
//  Created by HFW on 2018/7/13.
//  Copyright © 2018年 MGCion. All rights reserved.
//

#import "BaseViewModel.h"
#import "FiatDealBuyOrSellModel.h"

@interface PlaceOrderVM : BaseViewModel

//处理数据信号
@property (nonatomic, strong) RACSignal *getDataSignal;
@property (nonatomic, strong) FiatDealBuyOrSellModel *model;
@property (nonatomic, assign) BOOL isBuy;//买入 or 卖出

//下单
@property (nonatomic, strong) RACSignal * orderSignal;
@property (nonatomic, copy) NSString * orderBuysell;
@property (nonatomic, copy) NSString * orderAdvertisingOrderId;
@property (nonatomic, copy) NSString * orderTradeAmount;
@property (nonatomic, copy) NSString * orderTradeQuantity;
@property (nonatomic, copy) NSString * orderTradeCode;
@property (nonatomic, copy) NSString * adUserId;
@property (nonatomic, copy) NSString * payBuySell;

@end
