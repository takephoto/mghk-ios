// MGC
//
// SetMoneyPasswordVM.h
// MGCEX
//
// Created by MGC on 2018/5/26.
// Copyright © 2018年 MGCion. All rights reserved.
//
// @ description <#描述#> 

#import <Foundation/Foundation.h>

@interface SetMoneyPasswordVM : NSObject
@property (nonatomic, strong) RACSignal * resertMoneySignal;

@property (nonatomic, copy) NSString * password;//原密码
@property (nonatomic, copy) NSString * loginNum;//登录账号
@property (nonatomic, copy) NSString * code;//验证码
@end
