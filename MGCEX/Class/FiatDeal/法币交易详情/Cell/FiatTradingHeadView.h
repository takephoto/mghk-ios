// MGC
//
// FiatTradingHeadView.h
// MGCEX
//
// Created by MGC on 2018/5/27.
// Copyright © 2018年 MGCion. All rights reserved.
//
// @ description <#描述#> 

#import "BaseView.h"
#import "FiatTradingModel.h"

@interface FiatTradingHeadView : BaseView
@property (nonatomic, strong)FiatTradingModel * model;
@property (nonatomic, strong) UIView * frontView;
@property (nonatomic, assign) NSInteger complaintsTimeout;
@property (nonatomic, strong) UILabel * msgLabel;
@end
