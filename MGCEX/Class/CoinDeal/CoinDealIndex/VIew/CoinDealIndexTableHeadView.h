// MGC
//
// CoinDealIndexTableHeadView.h
// MGCEX
//
// Created by MGC on 2018/6/6.
// Copyright © 2018年 MGCion. All rights reserved.
//
// @ description <#描述#> 

#import <UIKit/UIKit.h>
#import "CoinDealSegHeadView.h"

#import "MGCoinDealRecordView.h"
#import "CoinDealBuySellSubView.h"

@class CoinDealIndexTableHeadView;
@protocol PriceValueDelegate // 代理传值方法


@end

@interface CoinDealIndexTableHeadView : UIView
@property (nonatomic, weak) NSObject <PriceValueDelegate>* priceDelegate;
@property (nonatomic, strong) CoinDealSegHeadView * segMentView;
@property (nonatomic, strong) CoinDealBuySellSubView * leftView;
@property (nonatomic, strong) MGCoinDealRecordView * rightView;
@end
