// MGC
//
// FiatSetAccountModel.m
// MGCEX
//
// Created by MGC on 2018/5/31.
// Copyright © 2018年 MGCion. All rights reserved.
//
// @ description <#描述#> 

#import "FiatSetAccountModel.h"

@implementation FiatSetAccountModel
+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{
             @"bank" : [accountBankModel class],
             @"micro" : [accountWxModel class],
             @"pay" : [accountZfbModel class]
             
             };
}

//+ (nullable NSDictionary<NSString *, id> *)modelContainerPropertyGenericClass{
//    
//    return @{
//             @"bank"       : accountBankModel.class,
//             @"micro"   : accountWxModel.class,
//             @"pay" : accountZfbModel.class
//             };
//}


@end
