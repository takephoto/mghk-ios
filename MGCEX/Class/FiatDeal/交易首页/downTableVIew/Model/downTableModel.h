// MGC
//
// downTableModel.h
// MGCEX
//
// Created by MGC on 2018/5/24.
// Copyright © 2018年 MGCion. All rights reserved.
//
// @ description <#描述#> 

#import <Foundation/Foundation.h>

@interface downTableModel : NSObject

@property (nonatomic, copy) NSString * tradeCode;
@property (nonatomic, copy) NSString * image;
@property (nonatomic, copy) NSString * title;
@property (nonatomic, copy) NSString * currency;
@property (nonatomic, assign) BOOL selected;
@end
