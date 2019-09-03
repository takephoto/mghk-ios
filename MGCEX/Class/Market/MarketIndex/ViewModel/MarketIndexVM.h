//
//  MarketIndexVM.h
//  MGCEX
//
//  Created by Joblee on 2018/6/4.
//  Copyright © 2018年 MGCion. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MarketIndexVM : BaseViewModel
///市场类型
@property (nonatomic, strong) NSString *Symbols;
//选中的市场下代币类型
@property (nonatomic, strong) NSMutableArray *coinTypeArr;
//选中的市场下代币类型
@property (nonatomic, strong) NSArray *optionalCoinTypeArr;
//选中的市场下代币类型：区分主区创新区
@property (nonatomic, strong) NSArray *optionalCoinTypeAreaArr;
//获取法币订单列表
@property (nonatomic, strong) RACSignal * getListSignal;
///刷新数据命令
@property (nonatomic, strong) RACCommand * refreshCommand;
///是否刷新
@property (nonatomic, assign) BOOL  isRefresh;
//获取实时行情数据
@property (nonatomic, strong) RACSignal * getRealtimeDataSignal;
//首页获取实时行情数据
@property (nonatomic, strong) RACSignal * getHomePageRealtimeDataSignal;
//获取指定的实时行情
@property (nonatomic, strong) RACSignal *quotesSignal;
@property (nonatomic, strong) NSArray *optinalTradePair;
//获取自选实时行情数据
@property (nonatomic, strong) RACSignal * getOptionalRealtimeDataSignal;
@end
