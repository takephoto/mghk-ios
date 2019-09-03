// MGC
//
// BindingIdentityVM.h
// MGCEX
//
// Created by MGC on 2018/5/21.
// Copyright © 2018年 MGCion. All rights reserved.
//
// @ description <#描述#> 

#import <Foundation/Foundation.h>

@interface BindingIdentityVM : NSObject
///登录信号
@property (nonatomic, strong) RACSignal * bindingSignal;
//手机或邮箱号
@property (nonatomic, copy) NSString * loginNum;
//验证码
@property (nonatomic, copy) NSString * code;
//设备
@property (nonatomic, copy) NSString * regDev;
@end
