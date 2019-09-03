// MGC
//
// FiatCapitaAccountCell.h
// MGCEX
//
// Created by MGC on 2018/6/7.
// Copyright © 2018年 MGCion. All rights reserved.
//
// @ description <#描述#> 

#import "BaseTableViewCell.h"
#import "FiatCapListModel.h"

typedef void (^ButtonClickBlock)(NSInteger btnTag);

@interface FiatCapitaAccountCell : BaseTableViewCell
@property (nonatomic, strong) FiatCapListModel * model;
@property (nonatomic, copy) ButtonClickBlock btnClickBlock;
@property (nonatomic, strong) UILabel * statusLabel;
@end
