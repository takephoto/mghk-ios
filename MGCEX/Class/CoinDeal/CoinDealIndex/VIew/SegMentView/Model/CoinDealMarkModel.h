// MGC
//
// CoinDealMarkModel.h
// MGCEX
//
// Created by MGC on 2018/6/9.
// Copyright © 2018年 MGCion. All rights reserved.
//
// @ description <#描述#> 

#import <Foundation/Foundation.h>
#import "CoinDealPrivateModel.h"

@interface CoinDealMarkModel : NSObject
@property (nonatomic, assign) BOOL isSelect;
@property (nonatomic, copy) NSString * markTitle;
@property (nonatomic, strong) NSMutableArray * privateArray;
@end
