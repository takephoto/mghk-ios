// MGC
//
// FiatSetZFBVC.h
// MGCEX
//
// Created by MGC on 2018/5/31.
// Copyright © 2018年 MGCion. All rights reserved.
//
// @ description <#描述#> 

#import "TWBaseViewController.h"

@interface FiatSetZFBVC : TWBaseViewController
//2 支付宝。3微信
@property (nonatomic, copy) NSString * payType;
//1  新增。2修改
@property (nonatomic, copy) NSString * changeStatus;
@end
