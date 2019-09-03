// MGC
//
// HomeNestTableViewCell.h
// MGCEX
//
// Created by MGC on 2018/5/10.
// Copyright © 2018年 MGCion. All rights reserved.
//
// @ description <#描述#> 

#import "BaseTableViewCell.h"
#import "MGMarketIndexRealTimeModel.h"

@interface HomeNestTableViewCell : BaseTableViewCell
@property (nonatomic, strong) NSArray *dataSource;
@property (nonatomic, strong) UIButton * riseFallBtn;
@property (nonatomic, strong) UIButton * dollarsBtn;
@end
