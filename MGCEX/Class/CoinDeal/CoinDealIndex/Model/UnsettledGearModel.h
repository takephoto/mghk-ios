// MGC
//
// UnsettledGearModel.h
// MGCEX
//
// Created by MGC on 2018/6/9.
// Copyright © 2018年 MGCion. All rights reserved.
//
// @ description <#描述#> 

#import <Foundation/Foundation.h>
//买卖五档
@interface UnsettledGearModel : NSObject
@property (nonatomic, copy) NSString * price;
@property (nonatomic, copy) NSString * value;
@property (nonatomic, strong) UIColor * labelColor;
@property (nonatomic, strong) UIColor * backColor;
@property (nonatomic, assign) NSInteger buySell;
@property (nonatomic, assign) float scaleValue;
@property (nonatomic, copy) NSString *market;
@property (nonatomic, copy) NSString *symbol;
@property (nonatomic, assign) NSInteger limitNumber;
@end
