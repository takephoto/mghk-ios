// MGC
//
// FiatDealBuyOrSellModelList.m
// MGCEX
//
// Created by MGC on 2018/6/1.
// Copyright © 2018年 MGCion. All rights reserved.
//
// @ description <#描述#> 

#import "FiatDealBuyOrSellModelList.h"

@implementation FiatDealBuyOrSellModelList
+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{
             @"list" : [FiatDealBuyOrSellmodels class]
             
             };
}
@end
