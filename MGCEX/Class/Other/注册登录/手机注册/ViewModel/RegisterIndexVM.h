// MGC
//
// RegisterIndexVM.h
// MGCEX
//
// Created by MGC on 2018/5/17.
// Copyright © 2018年 MGCion. All rights reserved.
//
// @ description <#描述#> 

#import "BaseViewModel.h"
#import "RACStream.h"

@interface RegisterIndexVM : BaseViewModel

///发送手机/邮箱验证码信号
@property (nonatomic, strong) RACSignal * sendPhoneCodeSignal;

///发送手机验证码命令
//@property (nonatomic, strong) RACCommand * sendCommand;

///注册手机/邮箱信号
@property (nonatomic, strong) RACSignal * registerPhoneSignal;

//类型 1:手机号 2:邮箱
@property (nonatomic, assign) NSInteger registerType;
//手机或邮箱号
@property (nonatomic, copy) NSString * loginNum;
//密码
@property (nonatomic, copy) NSString * password;
//验证码
@property (nonatomic, copy) NSString * code;
//地区编号+86 手机。其他是邮箱
@property (nonatomic, copy) NSString * regFromCode;
@end
