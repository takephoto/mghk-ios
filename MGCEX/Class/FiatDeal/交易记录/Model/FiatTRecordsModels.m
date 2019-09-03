// MGC
//
// FiatTRecordsModels.m
// MGCEX
//
// Created by MGC on 2018/6/1.
// Copyright © 2018年 MGCion. All rights reserved.
//
// @ description <#描述#> 

#import "FiatTRecordsModels.h"

@implementation FiatTRecordsModels
+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{
             @"listreslt" : [FiatTransactionRecordsModel class]
             
             };
}
@end
