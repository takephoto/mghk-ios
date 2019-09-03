// MGC
//
// SettingViewModel.h
// MGCEX
//
// Created by MGC on 2018/5/22.
// Copyright © 2018年 MGCion. All rights reserved.
//
// @ description <#描述#> 

#import <Foundation/Foundation.h>

@interface SettingViewModel : NSObject

@property (nonatomic, strong) RACSignal * settingLoginSignal;//获取个人信息
@property (nonatomic, strong) RACCommand * settingLoginCommand;
@property (nonatomic, copy) NSString * password;

@property (nonatomic, strong) RACSignal * openCloseGoogleSignal;//开启关闭谷歌验证

@property (nonatomic, copy) NSString * GooglePassword;
@property (nonatomic, copy) NSString * GoogleCode;
@property (nonatomic, copy) NSString * GoogleStatus;

@property (nonatomic, strong) RACSignal * verifyLoainSignal;//验证登录密码是否正确
@property (nonatomic, copy) NSString * loginPasswoed;
@end
