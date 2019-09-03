// MGC
//
// LoginIndexVM.h
// MGCEX
//
// Created by MGC on 2018/5/17.
// Copyright © 2018年 MGCion. All rights reserved.
//
// @ description <#描述#> 

#import "BaseViewModel.h"

@interface LoginIndexVM : BaseViewModel

///二次验证
@property (nonatomic, strong) RACSignal * validationSignal;
///二次验证code
@property (nonatomic, copy) NSString * secondCode;
///登录信号
@property (nonatomic, strong) RACSignal * loginSignal;
//手机或邮箱号
@property (nonatomic, copy) NSString * loginNum;
//密码
@property (nonatomic, copy) NSString * password;
//验证码
@property (nonatomic, copy) NSString * code;
//设备
@property (nonatomic, copy) NSString * device;
//纬度
@property (nonatomic, copy) NSString * longitudePint;
//经度
@property (nonatomic, copy) NSString * latitudePoint;

///谷歌二次验证
@property (nonatomic, strong) RACSignal * secondGoogleSignal;
//谷歌验证码
@property (nonatomic, copy) NSString * googleCode;
@end
