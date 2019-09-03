//
//  MGKLinechartRecordModel.h
//  MGCEX
//
//  Created by Joblee on 2018/6/10.
//  Copyright © 2018年 MGCion. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MGKLinechartRecordModel : NSObject
///记录ID
@property (nonatomic, strong) NSString *ID;
///用户ID
@property (nonatomic, strong) NSString *userId;
///委托单ID
@property (nonatomic, strong) NSString *entrustmentId;
///市场
@property (nonatomic, strong) NSString *market;
///币种
@property (nonatomic, strong) NSString *symbol;
///成交ID
@property (nonatomic, strong) NSString *dealId;
///成交量
@property (nonatomic, strong) NSString *volume;
///价格
@property (nonatomic, strong) NSString *price;
///估值
@property (nonatomic, strong) NSString *valuation;
///买卖
@property (nonatomic, strong) NSString *buysell;
///手续费
@property (nonatomic, strong) NSString *fee;
///创建日期
@property (nonatomic, strong) NSString *createDate;
///时间
@property (nonatomic, strong) NSString *time;
@end
