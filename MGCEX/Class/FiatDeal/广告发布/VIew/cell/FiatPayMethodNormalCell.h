// MGC
//
// FiatPayMethodNormalCell.h
// MGCEX
//
// Created by MGC on 2018/5/30.
// Copyright © 2018年 MGCion. All rights reserved.
//
// @ description <#描述#> 

#import "BaseTableViewCell.h"

@interface FiatPayMethodNormalCell : BaseTableViewCell
@property (nonatomic, strong) UIView * lineView;
@property (nonatomic, assign) MGPayWay payWay;
@end
