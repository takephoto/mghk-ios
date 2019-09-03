// MGC
//
// ChangeCountryIndexVC.h
// MGCEX
//
// Created by MGC on 2018/5/14.
// Copyright © 2018年 MGCion. All rights reserved.
//
// @ description <#描述#> 

#import "BaseTableViewController.h"

@interface ChangeCountryIndexVC : BaseTableViewController
//注册入口
@property (nonatomic, strong) RACSubject *delegateSignal;
@property (nonatomic, strong) RACSubject *forgetPwdSignal;
@end
