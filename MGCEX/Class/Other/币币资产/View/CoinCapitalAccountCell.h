// MGC
//
// CoinCapitalAccountCell.h
// MGCEX
//
// Created by MGC on 2018/6/7.
// Copyright © 2018年 MGCion. All rights reserved.
//
// @ description <#描述#> 

#import "BaseTableViewCell.h"
#import "CoinCapListModel.h"
typedef void (^ButtonClickBlock)(NSInteger bynTag);
typedef void (^CapitalTransferClickBlock)(void);

@interface CoinCapitalAccountCell : BaseTableViewCell
@property(nonatomic , strong) CoinCapListModel * model;
@property (nonatomic, copy) ButtonClickBlock btnClickBlock;
@property (nonatomic, copy) CapitalTransferClickBlock capitalTransferClickBlock;

@end
