// MGC
//
// CoinEntrusHistoryModel.m
// MGCEX
//
// Created by MGC on 2018/6/8.
// Copyright © 2018年 MGCion. All rights reserved.
//
// @ description <#描述#> 

#import "CoinEntrusHistoryModel.h"

@implementation CoinEntrusHistoryModel
+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{
             @"listreslt" : [CoinEntrusHistoryModelList class]
             
             };
}
@end
