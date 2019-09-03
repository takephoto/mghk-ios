// MGC
//
// FiatZfbWxCell.h
// MGCEX
//
// Created by MGC on 2018/5/28.
// Copyright © 2018年 MGCion. All rights reserved.
//
// @ description <#描述#> 

#import "BaseTableViewCell.h"
#import "accountZfbModel.h"
#import "accountWxModel.h"

@class BaseTableViewCell;
@protocol lookCodeImageDelegate // 代理传值方法
//2 支付宝。 3微信
- (void)lookCodeImageWithType:(NSInteger)index;

@end


typedef void (^LookCodeBtnClock)(void);

@interface FiatZfbWxCell : BaseTableViewCell
@property (nonatomic, strong) accountZfbModel * zfbModel;
@property (nonatomic, strong) accountWxModel * wxModel;
@property (nonatomic, copy) LookCodeBtnClock lookCodeBLock;
@property (nonatomic, weak) NSObject <lookCodeImageDelegate>* btnDelegate;
@end
