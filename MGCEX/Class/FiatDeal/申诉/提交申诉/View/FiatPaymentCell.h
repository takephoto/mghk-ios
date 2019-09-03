// MGC
//
// FiatPaymentCell.h
// MGCEX
//
// Created by MGC on 2018/5/29.
// Copyright © 2018年 MGCion. All rights reserved.
//
// @ description <#描述#> 

#import "BaseTableViewCell.h"

@interface FiatPaymentCell : BaseTableViewCell
@property (nonatomic, strong) UIButton * pointButton;
@property (nonatomic, strong) UILabel * titleLabel;
@property (nonatomic, strong) UIView * lineView;
@property (nonatomic, copy) void(^selectBlock)(BOOL selected);
- (void)didBtnClicked:(UIButton*)btn;
///是否查看申诉记录
@property (nonatomic, assign) BOOL isRecord;
@end
