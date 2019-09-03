// MGC
//
// FillCoinRecodeListModel.h
// MGCEX
//
// Created by MGC on 2018/6/14.
// Copyright © 2018年 MGCion. All rights reserved.
//
// @ description <#描述#> 

#import <Foundation/Foundation.h>

@interface FillCoinRecodeListModel : NSObject
@property (nonatomic, copy) NSString * userId;
@property (nonatomic, copy) NSString * addressTo;
@property (nonatomic, copy) NSString * hashStr;
@property (nonatomic, copy) NSString * status;
@property (nonatomic, copy) NSString * confirmNum;
@property (nonatomic, copy) NSString * orderNo;
@property (nonatomic, copy) NSString * addressFrom;
@property (nonatomic, copy) NSString * timeStamp;
@property (nonatomic, copy) NSString * tradeCode;
@property (nonatomic, copy) NSString * amount;
@property (nonatomic, copy) NSString * time;
@property (nonatomic, copy) NSString * statusString;
@property (nonatomic, copy) NSString * cellType;
/// 高度
@property (nonatomic, readonly) CGFloat cellHeight;
@end
