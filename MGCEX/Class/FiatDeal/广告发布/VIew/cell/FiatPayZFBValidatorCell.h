// MGC
//
// FiatPayZFBValidatorCell.h
// MGCEX
//
// Created by MGC on 2018/5/30.
// Copyright © 2018年 MGCion. All rights reserved.
//
// @ description <#描述#> 

#import "BaseTableViewCell.h"
#import "MGAdPayWayModel.h"
@interface FiatPayZFBValidatorCell : BaseTableViewCell
@property (nonatomic, copy) void(^selectBlock)(BOOL selected);
@property (nonatomic, strong) MGAdPayWayModel *model;
@property (nonatomic, strong) UIButton * logImageBtn;
@property (nonatomic, strong) UIView *lineView;
@end
