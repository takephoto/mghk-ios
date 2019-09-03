//
//  MGMarketIndexRealTimeModel.h
//  MGCEX
//
//  Created by Joblee on 2018/6/6.
//  Copyright © 2018年 MGCion. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MGMarketIndexRealTimeModel : NSObject
@property (nonatomic, strong) NSString *market;//市场
@property (nonatomic, strong) NSString *symbol;//币种
@property (nonatomic, strong) NSString *date;//日期
@property (nonatomic, strong) NSString *RefClose;//昨日收盘价
@property (nonatomic, strong) NSString *o;//开盘价
@property (nonatomic, strong) NSString *h;//最高价
@property (nonatomic, strong) NSString *l;//最低价
@property (nonatomic, strong) NSString *c;//收盘价
@property (nonatomic, strong) NSString *gains;//涨幅
@property (nonatomic, strong) NSString *latestPrice;//最新价
@property (nonatomic, strong) NSString *latestVolume;//最新成交量
@property (nonatomic, strong) NSString *sellPrice;//卖价
@property (nonatomic, strong) NSString *buyPrice;//买价
@property (nonatomic, strong) NSString *accVolume;//24H累积交易量
@property (nonatomic, strong) NSString *accAmount;//24H累积交易额
@property (nonatomic, strong) NSString *accGains;//24H累积涨幅
@property (nonatomic, strong) NSString *valuation;//估值
@property (nonatomic, assign) BOOL isOptional;//是否自选

@end
