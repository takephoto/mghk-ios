// MGC
//
// ContentTableViewCell.h
// MGCEX
//
// Created by MGC on 2018/5/22.
// Copyright © 2018年 MGCion. All rights reserved.
//
// @ description <#描述#> 

#import "BaseTableViewCell.h"
#import "MGMarketIndexRealTimeModel.h"
@interface ContentTableViewCell : BaseTableViewCell
@property (nonatomic, strong) MGMarketIndexRealTimeModel*model;
@property (nonatomic, strong) UILabel * tagLab;
@property (nonatomic, strong) UILabel * titleLabel;
@property (nonatomic, strong) UILabel * subLabel;
@property (nonatomic, strong) UILabel * ratioLabel;
@property (nonatomic, strong) UILabel * priceLabel;
@property (nonatomic, strong) UILabel * subPriceLabel;
@end
