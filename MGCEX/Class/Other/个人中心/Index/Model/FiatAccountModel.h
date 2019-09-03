// MGC
//
// FiatAccountModel.h
// MGCEX
//
// Created by MGC on 2018/6/7.
// Copyright © 2018年 MGCion. All rights reserved.
//
// @ description <#描述#> 

#import <Foundation/Foundation.h>
#import "FiatCapListModel.h"

@interface FiatAccountModel : NSObject
//个人中心的数据
@property (nonatomic, copy) NSString * btcCount;
@property (nonatomic, copy) NSString * cnySum;
@property (nonatomic, strong) NSArray * ufflist;



@end
