// MGC
//
// CoinEntrustModelList.h
// MGCEX
//
// Created by MGC on 2018/6/8.
// Copyright © 2018年 MGCion. All rights reserved.
//
// @ description <#描述#> 

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

@interface CoinEntrustModelList : NSObject
@property (nonatomic, copy) NSString * Id;
@property (nonatomic, copy) NSString * userId;
@property (nonatomic, copy) NSString * type;
@property (nonatomic, copy) NSString * buysell;
@property (nonatomic, copy) NSString * market;
@property (nonatomic, copy) NSString * symbol;
@property (nonatomic, copy) NSString * price;
@property (nonatomic, copy) NSString * volume;
@property (nonatomic, copy) NSString * amount;
@property (nonatomic, copy) NSString * doneVolume;
@property (nonatomic, copy) NSString * remainVolume;
@property (nonatomic, copy) NSString * status;
@property (nonatomic, copy) NSString * fee;
@property (nonatomic, copy) NSString * finishDate;
@property (nonatomic, copy) NSString * createDate;

@property (nonatomic, copy) NSString * statusString;
@property (nonatomic, copy) NSString * buySellString;
@property (nonatomic, strong) UIColor * buySellColor;
@end
