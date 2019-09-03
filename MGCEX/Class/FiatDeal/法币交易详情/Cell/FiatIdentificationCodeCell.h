// MGC
//
// FiatIdentificationCodeCell.h
// MGCEX
//
// Created by MGC on 2018/5/28.
// Copyright © 2018年 MGCion. All rights reserved.
//
// @ description <#描述#> 

#import "BaseTableViewCell.h"
typedef void (^CloseBtnBlock)(void);

@interface FiatIdentificationCodeCell : BaseTableViewCell
@property (nonatomic, copy) CloseBtnBlock closeBlock;

@end
