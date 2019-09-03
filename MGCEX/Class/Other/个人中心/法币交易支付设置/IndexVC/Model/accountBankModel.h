// MGC
//
// accountBankModel.h
// MGCEX
//
// Created by MGC on 2018/5/31.
// Copyright © 2018年 MGCion. All rights reserved.
//
// @ description <#描述#> 

#import <Foundation/Foundation.h>

@interface accountBankModel : NSObject

//分支银行
@property (nonatomic, copy) NSString * bankBrachName;
//工商银行
@property (nonatomic, copy) NSString * bankName;

@property (nonatomic, copy) NSString * payType;
//卡号
@property (nonatomic, copy) NSString * payeeAccount;
//名字
@property (nonatomic, copy) NSString * payeeName;
//备注
@property (nonatomic, copy) NSString * summary;
@end
