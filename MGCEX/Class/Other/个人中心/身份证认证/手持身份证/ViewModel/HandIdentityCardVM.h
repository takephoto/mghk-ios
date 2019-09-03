// MGC
//
// HandIdentityCardVM.h
// MGCEX
//
// Created by MGC on 2018/5/21.
// Copyright © 2018年 MGCion. All rights reserved.
//
// @ description <#描述#> 

#import <Foundation/Foundation.h>

@interface HandIdentityCardVM : NSObject
///注册手机/邮箱信号
@property (nonatomic, strong) RACSignal * authenticationSignal;

//类型 1 身份证  2护照
@property (nonatomic, copy) NSString * type;
//身份证号
@property (nonatomic, copy) NSString * identityNum;
//姓
@property (nonatomic, copy) NSString * surname;
//名
@property (nonatomic, copy) NSString * name;
//全名
@property (nonatomic, copy) NSString * fullName;
//证件照
@property (nonatomic, copy) NSString * frontCardUrl;
//反面照
@property (nonatomic, copy) NSString * backCardUrl;
//手持照
@property (nonatomic, copy) NSString * holdCardurl;

@end
