// MGC
//
// CoinAccountModel.m
// MGCEX
//
// Created by MGC on 2018/6/7.
// Copyright © 2018年 MGCion. All rights reserved.
//
// @ description <#描述#> 

#import "CoinAccountModel.h"

@implementation CoinAccountModel

+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{
             @"ufflist" : [CoinCapListModel class]
             
             };
}

-(NSString *)btcCount{
    
    return kNotNumber(_btcCount);
}

-(NSString *)cnySum{
    return kNotNumber(_cnySum);
}

@end
