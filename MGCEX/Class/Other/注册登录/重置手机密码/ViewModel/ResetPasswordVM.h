// MGC
//
// ResetPasswordVM.h
// MGCEX
//
// Created by MGC on 2018/5/18.
// Copyright © 2018年 MGCion. All rights reserved.
//
// @ description <#描述#> 

#import "BaseViewModel.h"

@interface ResetPasswordVM : BaseViewModel
///重置手机/邮箱密码
@property (nonatomic, strong) RACSignal * resetCodeSignal;

//手机或邮箱号
@property (nonatomic, copy) NSString * loginNum;
//密码
@property (nonatomic, copy) NSString * password;
//验证码
@property (nonatomic, copy) NSString * code;
@end
