// MGC
//
// FillCoinRecodeModel.m
// MGCEX
//
// Created by MGC on 2018/6/14.
// Copyright © 2018年 MGCion. All rights reserved.
//
// @ description <#描述#> 

#import "FillCoinRecodeModel.h"

@implementation FillCoinRecodeModel
+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{
             @"listreslt" : [FillCoinRecodeListModel class]
             
             };
}
@end
