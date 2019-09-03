// MGC
//
// FiatSetAccountModel.h
// MGCEX
//
// Created by MGC on 2018/5/31.
// Copyright © 2018年 MGCion. All rights reserved.
//
// @ description <#描述#> 

#import <Foundation/Foundation.h>
#import "accountBankModel.h"
#import "accountZfbModel.h"
#import "accountWxModel.h"

@interface FiatSetAccountModel : NSObject

@property (nonatomic, strong) accountBankModel * bank;//银行
@property (nonatomic, strong) accountWxModel * micro;//微信
@property (nonatomic, strong) accountZfbModel * pay;//支付宝

@end
