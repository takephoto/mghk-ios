// MGC
//
// DepthChartModel.h
// 深度图demo
//
// Created by MGC on 2018/6/4.
// Copyright © 2018年 MGCion. All rights reserved.
//
// @ description <#描述#> 

#import <Foundation/Foundation.h>

@interface DepthChartModel : NSObject
//单价
@property (nonatomic, assign) double price;
//成交量
@property (nonatomic, assign) double number;
//总成交量
@property (nonatomic, assign) double totalNumber;
@end
