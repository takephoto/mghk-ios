// MGC
//
// TakeCoinRecordListModel.h
// MGCEX
//
// Created by MGC on 2018/6/15.
// Copyright © 2018年 MGCion. All rights reserved.
//
// @ description <#描述#> 

#import <Foundation/Foundation.h>

@interface TakeCoinRecordListModel : NSObject
@property (nonatomic, copy) NSString * address;
@property (nonatomic, copy) NSString * amount;
@property (nonatomic, copy) NSString * status;
@property (nonatomic, copy) NSString * tradeCode;
@property (nonatomic, copy) NSString * userId;
@property (nonatomic, copy) NSString * orderNo;
@property (nonatomic, copy) NSString * phone;
@property (nonatomic, copy) NSString * orderTime;
@property (nonatomic, copy) NSString * fee;
@property (nonatomic, copy) NSString * timeStr;
@property (nonatomic, copy) NSString * email;
@property (nonatomic, copy) NSString * cellType;
@property (nonatomic, copy) NSString * statusString;
/// 高度
@property (nonatomic, readonly) CGFloat cellHeight;
@end
