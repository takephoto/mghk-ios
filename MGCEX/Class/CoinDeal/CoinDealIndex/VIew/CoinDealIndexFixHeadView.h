// MGC
//
// CoinDealIndexFixHeadView.h
// MGCEX
//
// Created by MGC on 2018/6/6.
// Copyright © 2018年 MGCion. All rights reserved.
//
// @ description <#描述#> 

#import <UIKit/UIKit.h>

@class CoinDealIndexFixHeadView;

typedef void (^segMentBackBlock)(CoinDealIndexFixHeadView *headV);

@interface CoinDealIndexFixHeadView : UIView
@property (nonatomic, copy) segMentBackBlock segBlock;
@property (nonatomic , strong) QSButton * leftBtn;
@property (nonatomic, strong) UILabel * midLabel;
@property (nonatomic, strong) UILabel * submidLabel;
@property (nonatomic, strong) UILabel * rightLabel;
@end
