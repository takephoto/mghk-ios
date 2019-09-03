// MGC
//
// BindingGoogleVM.h
// MGCEX
//
// Created by MGC on 2018/5/25.
// Copyright © 2018年 MGCion. All rights reserved.
//
// @ description <#描述#> 

#import <Foundation/Foundation.h>

@interface BindingGoogleVM : NSObject
@property (nonatomic, strong) RACSignal * googleSignal;//获取谷歌Key

@property (nonatomic, strong) RACSignal * verifyGoogleSignal;//谷歌验证

@property (nonatomic, copy) NSString * secret;

@property (nonatomic, copy) NSString * code;
@end
