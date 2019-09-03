// MGC
//
// PersonalCenterCell.h
// MGCEX
//
// Created by MGC on 2018/5/15.
// Copyright © 2018年 MGCion. All rights reserved.
//
// @ description <#描述#> 

#import "BaseTableViewCell.h"

typedef enum : NSUInteger {
    withArrow = 0,//titleLabel+subLabel+右箭
    noArrow,//titleLabel+subLabel
    withSwitch,//titleLabel+Switch开关
} PersonalCellType;

typedef void (^SwitchBlock)(UISwitch * sw);
@interface PersonalCenterCell : BaseTableViewCell
@property (nonatomic, strong) UILabel * titleLabel;
@property (nonatomic, strong) UILabel * subLabel;
@property (nonatomic, strong) UIImageView * arrowImageV;
@property (nonatomic, assign) PersonalCellType personCellType;
@property (nonatomic, strong) UISwitch * cellSwitch;
@property (nonatomic, copy) SwitchBlock  switchBlock;
@end
