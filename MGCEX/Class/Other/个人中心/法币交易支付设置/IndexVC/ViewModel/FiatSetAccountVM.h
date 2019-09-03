// MGC
//
// FiatSetAccountVM.h
// MGCEX
//
// Created by MGC on 2018/5/31.
// Copyright © 2018年 MGCion. All rights reserved.
//
// @ description <#描述#> 

#import <Foundation/Foundation.h>

@interface FiatSetAccountVM : NSObject
///设置账号
@property (nonatomic, strong) RACSignal * setAccountSignal;

//收款人姓名
@property (nonatomic, copy) NSString * payeeName;

//支付类型
@property (nonatomic, copy) NSString * payType;

//银行
@property (nonatomic, copy) NSString * bankName;

//支行
@property (nonatomic, copy) NSString * bankBrachName;

//账户
@property (nonatomic, copy) NSString * payeeAccount;

//支付图片
@property (nonatomic, copy) NSString * payeeAccountUrl;

//备注
@property (nonatomic, copy) NSString * summary;

//状态：1 新增  2 修改
@property (nonatomic, copy) NSString * status;

//资金密码
@property (nonatomic, copy) NSString * reMoneyPassword;

//验证码
@property (nonatomic, copy) NSString * code;

//设备号
@property (nonatomic, copy) NSString * device;

//验证的账号
@property (nonatomic, copy) NSString * loginNum;

//获取账户信息 
@property (nonatomic, strong) RACSignal * getAccountSignal;

//获取账户绑定信息的userid参数。不传默认是自己的
@property (nonatomic, copy) NSString * tradingUserid;

@end
