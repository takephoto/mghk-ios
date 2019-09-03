// MGC
//
// CoinDowdCollectionCell.h
// MGCEX
//
// Created by MGC on 2018/6/7.
// Copyright © 2018年 MGCion. All rights reserved.
//
// @ description <#描述#> 

#import <UIKit/UIKit.h>
#import "CoinDealMarkModel.h"

@interface CoinDowdCollectionCell : UICollectionViewCell
@property (nonatomic, strong) CoinDealMarkModel * model;

@property (nonatomic, strong) UILabel * titleLabel;
@property (nonatomic, strong) UIImageView * lineImageV;
@end
