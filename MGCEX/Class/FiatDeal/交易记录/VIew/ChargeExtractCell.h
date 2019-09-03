// MGC
//
// ChargeExtractCell.h
// MGCEX
//
// Created by MGC on 2018/6/12.
// Copyright © 2018年 MGCion. All rights reserved.
//
// @ description <#描述#> 

#import "BaseTableViewCell.h"
#import "FillCoinRecodeListModel.h"
#import "TakeCoinRecordListModel.h"

@interface ChargeExtractCell : BaseTableViewCell
@property (nonatomic, strong) FillCoinRecodeListModel * fillModel;
@property (nonatomic, strong) TakeCoinRecordListModel * takeModel;
@end
