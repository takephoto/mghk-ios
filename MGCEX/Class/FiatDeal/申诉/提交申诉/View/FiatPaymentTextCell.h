// MGC
//
// FiatPaymentTextCell.h
// MGCEX
//
// Created by MGC on 2018/5/29.
// Copyright © 2018年 MGCion. All rights reserved.
//
// @ description <#描述#> 

#import "BaseTableViewCell.h"

@interface FiatPaymentTextCell : BaseTableViewCell
@property (nonatomic, strong) UIView * lineView;
@property (nonatomic, strong) UITextField *textField;
///是否查看申诉记录
@property (nonatomic, assign) BOOL isRecord;
@end
