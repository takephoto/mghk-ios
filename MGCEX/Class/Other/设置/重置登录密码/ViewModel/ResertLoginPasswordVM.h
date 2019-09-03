// MGC
//
// ResertLoginPasswordVM.h
// MGCEX
//
// Created by MGC on 2018/5/21.
// Copyright © 2018年 MGCion. All rights reserved.
//
// @ description <#描述#> 

#import <Foundation/Foundation.h>

@interface ResertLoginPasswordVM : NSObject

@property (nonatomic, strong) RACSignal * validationLoginSignal;

@property (nonatomic, copy) NSString * password;//原密码
@property (nonatomic, copy) NSString * currentPassword;//新密码

@end
