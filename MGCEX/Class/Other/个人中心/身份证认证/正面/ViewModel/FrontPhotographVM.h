// MGC
//
// FrontPhotographVM.h
// MGCEX
//
// Created by MGC on 2018/5/21.
// Copyright © 2018年 MGCion. All rights reserved.
//
// @ description <#描述#> 

#import <Foundation/Foundation.h>
#import "UpImageModel.h"

@interface FrontPhotographVM : NSObject
///发送手机/邮箱验证码信号
@property (nonatomic, strong) RACSignal * upImageSignal;

@property (nonatomic, strong) UIImage * image;
@end
