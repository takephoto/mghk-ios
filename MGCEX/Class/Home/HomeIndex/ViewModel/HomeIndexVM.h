// MGC
//
// HomeIndexVM.h
// MGCEX
//
// Created by MGC on 2018/7/6.
// Copyright © 2018年 MGCion. All rights reserved.
//
// @ description <#描述#> 

#import "BaseViewModel.h"
#import "HomeIndexModel.h"

@interface HomeIndexVM : BaseViewModel
///获取公告列表
@property (nonatomic, copy) RACSignal *getAnmentSignal;
@property (nonatomic, copy) NSString * num;
@property (nonatomic, copy) NSString * h5;
@end
