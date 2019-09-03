// MGC
//
// TakeCoinRecordModel.m
// MGCEX
//
// Created by MGC on 2018/6/15.
// Copyright © 2018年 MGCion. All rights reserved.
//
// @ description <#描述#> 

#import "TakeCoinRecordModel.h"

@implementation TakeCoinRecordModel
+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{
             @"drawList" : [TakeCoinRecordListModel class]
             
             };
}
@end
