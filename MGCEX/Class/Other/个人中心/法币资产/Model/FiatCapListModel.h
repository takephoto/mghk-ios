// MGC
//
// FiatCapListModel.h
// MGCEX
//
// Created by MGC on 2018/6/8.
// Copyright © 2018年 MGCion. All rights reserved.
//
// @ description <#描述#> 

#import <Foundation/Foundation.h>

@interface FiatCapListModel : NSObject
//法币数据
@property (nonatomic, copy) NSString * availableBalance;
@property (nonatomic, copy) NSString * cny;
@property (nonatomic, copy) NSString * frozenBalance;
@property (nonatomic, copy) NSString * fundsStatus;
@property (nonatomic, copy) NSString * is;
@property (nonatomic, copy) NSString * isintegral;
@property (nonatomic, copy) NSString * logoUrl;
@property (nonatomic, copy) NSString * tradeCode;
@property (nonatomic, copy) NSString * userId;
///Y表示可以充币，null表示不可充币
@property (nonatomic, copy) NSString * isfuc;
@property (nonatomic, copy) NSString * isfucUrl;
@end
