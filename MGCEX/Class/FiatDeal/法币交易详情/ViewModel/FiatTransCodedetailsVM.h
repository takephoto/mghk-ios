// MGC
//
// FiatTransCodedetailsVM.h
// MGCEX
//
// Created by MGC on 2018/6/3.
// Copyright © 2018年 MGCion. All rights reserved.
//
// @ description <#描述#> 

#import "BaseViewModel.h"
#import "FiatTradingModel.h"

@interface FiatTransCodedetailsVM : BaseViewModel

///刷新数据命令
@property (nonatomic, strong) RACCommand * refreshCommand;
//获取法币交易记录详情
@property (nonatomic, strong) RACSignal * recordDetailSignal;
@property (nonatomic, assign) NSInteger  currentPage;
@property (nonatomic, assign) BOOL  isRefresh;

@property (nonatomic, copy) NSString * tradeOrderId;

//标记为已付款 已收款
@property (nonatomic, strong) RACSignal * markedPaySignal;

// 取消交易
@property (nonatomic, strong) RACSignal * cancelTransSignal;
@end
