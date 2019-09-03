// MGC
//
// OptionalModel.h
// MGCEX
//
// Created by MGC on 2018/6/21.
// Copyright © 2018年 MGCion. All rights reserved.
//
// @ description <#描述#> 

#import <Foundation/Foundation.h>

@interface OptionalModel : NSObject
@property (nonatomic, copy) NSString * Id;
@property (nonatomic, copy) NSString * userId;
@property (nonatomic, copy) NSString * transPare;
///市场
@property (nonatomic, strong) NSString *market;
///币种
@property (nonatomic, strong) NSString *symbol;
///主区1,创新区2
@property (nonatomic, assign) NSInteger area;
@end
