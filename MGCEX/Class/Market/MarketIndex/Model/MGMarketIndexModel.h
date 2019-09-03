//
//  MGMarketIndexModel.h
//  MGCEX
//
//  Created by Joblee on 2018/6/6.
//  Copyright © 2018年 MGCion. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MGMarketIndexModel : NSObject
///市场
@property (nonatomic, strong) NSString *market;
///币种
@property (nonatomic, strong) NSString *symbol;
///时间
@property (nonatomic, strong) NSString *time;
///最高价
@property (nonatomic, strong) NSString *high;
///最低价
@property (nonatomic, strong) NSString *low;
///开盘价
@property (nonatomic, strong) NSString *open;
///收盘价
@property (nonatomic, strong) NSString *close;
///成交量
@property (nonatomic, strong) NSString *vol;
///成交额
@property (nonatomic, strong) NSString *amount;
//涨幅
@property (nonatomic, strong) NSString *gains;
@end
