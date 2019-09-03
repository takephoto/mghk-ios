// MGC
//
// UserInformationVM.h
// MGCEX
//
// Created by MGC on 2018/5/21.
// Copyright © 2018年 MGCion. All rights reserved.
//
// @ description <#描述#> 

#import <Foundation/Foundation.h>
#import "FiatAccountModel.h"
#import "CoinAccountModel.h"

@interface UserInformationVM : NSObject
///个人用户信息
@property (nonatomic, strong) RACSignal * userInfoSignal;

///法币信息
@property (nonatomic, strong) RACSignal * fiatInfoSignal;
///币币信息
@property (nonatomic, strong) RACSignal * coinInfoSignal;

//是否隐藏小于0的币种 Y隐藏 N不隐藏
@property (nonatomic, copy) NSString * type;

@property (nonatomic, copy) NSString * tradeCode;

// 传 1 则只显示BTC总数量和CNY总估值。 传空则显示所有数量
@property (nonatomic, copy) NSString * istrue;

@end
