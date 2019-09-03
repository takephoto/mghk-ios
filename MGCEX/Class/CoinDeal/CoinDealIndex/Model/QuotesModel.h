// MGC
//
// QuotesModel.h
// MGCEX
//
// Created by MGC on 2018/6/9.
// Copyright © 2018年 MGCion. All rights reserved.
//
// @ description <#描述#> 

#import <Foundation/Foundation.h>
//盘面行情
@interface QuotesModel : NSObject
@property (nonatomic, strong) NSString * market;
@property (nonatomic, strong) NSString * symbol;
@property (nonatomic, strong) NSString * date;
@property (nonatomic, strong) NSString * refClose;
@property (nonatomic, strong) NSString * o;
@property (nonatomic, strong) NSString * h;
@property (nonatomic, strong) NSString * l;
@property (nonatomic, strong) NSString * c;
@property (nonatomic, strong) NSString * gains;
@property (nonatomic, strong) UIColor * gainsColor;
@property (nonatomic, strong) NSString * gainSymbol;//正负号
@property (nonatomic, strong) NSString * NewPrice;
@property (nonatomic, strong) NSString * NewVolume;
@property (nonatomic, strong) NSString * sellPrice;
@property (nonatomic, strong) NSString * buyPrice;
@property (nonatomic, strong) NSString * valuation;
@property (nonatomic, strong) NSString * marketPrice;
@property (nonatomic, strong) NSString * accVolume;
@property (nonatomic, strong) NSString * accAmount;
@property (nonatomic, strong) NSString * accGains;


@end
