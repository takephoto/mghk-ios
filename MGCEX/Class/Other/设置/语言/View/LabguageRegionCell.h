// MGC
//
// LabguageRegionCell.h
// MGCEX
//
// Created by MGC on 2018/5/17.
// Copyright © 2018年 MGCion. All rights reserved.
//
// @ description <#描述#> 

#import "BaseTableViewCell.h"

@interface LabguageRegionCell : BaseTableViewCell
@property (nonatomic, strong) UILabel * titleLabel;
@property (nonatomic, strong) UIImageView * arrowImageV;
@property (nonatomic, assign) BOOL isSelect;
@end
