// MGC
//
// RechargeAddressCell.h
// MGCEX
//
// Created by MGC on 2018/6/7.
// Copyright © 2018年 MGCion. All rights reserved.
//
// @ description <#描述#> 

#import "BaseTableViewCell.h"


@interface RechargeAddressCell : BaseTableViewCell
@property (nonatomic, strong) UILabel * codeArrress;
@property (nonatomic, strong) UIImageView * codeImageV;
@property (nonatomic, strong) NSString *addressStr;
@property (nonatomic, strong) NSString *tradeCode;
@end
