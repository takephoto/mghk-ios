// MGC
//
// CoinDealBuySellSubView.h
// MGCEX
//
// Created by MGC on 2018/6/6.
// Copyright © 2018年 MGCion. All rights reserved.
//
// @ description <#描述#> 

#import <UIKit/UIKit.h>
#import "QuotesModel.h"
#import "PPNumberButton.h"
#import "TWSlider.h"
#import "ASPopUpView.h"
#import "ASProgressPopUpView.h"

typedef void (^BuylimitBlock)(void);

@interface CoinDealBuySellSubView : UIView

@property (nonatomic, strong) QSButton * titleBtn;
@property (nonatomic, strong) BuylimitBlock buylimitBlock;
@property (nonatomic, strong) UIButton * nextBtn;
@property (nonatomic, strong) UILabel * turnoverLabel;
@property (nonatomic, strong) QuotesModel *model;
@property (nonatomic, strong) UIView * markView;
@property (nonatomic, strong) PPNumberButton * ppBtn1;
@property (nonatomic, strong) PPNumberButton * ppBtn2;
@property (nonatomic, strong) UILabel * cnyLabel;
@property (nonatomic, strong) UILabel * btcLabel;
@property (nonatomic, strong) TWSlider * slider;
@property (nonatomic, strong) UILabel * minLabel;
@property (nonatomic, strong) UILabel * maxLabel;
@property (nonatomic, copy) NSString * markStr;//市场
@property (nonatomic, copy) NSString * trCode;//币种
@property (nonatomic, assign) NSInteger buyOrSell;//1买入。2卖出
@property (nonatomic, assign) NSInteger buyLimitType;//0  限价。 1市价
@property (nonatomic, copy) NSString * availableBalance;//可用币种
@property (nonatomic, assign) double appraisement;//估值

@property (strong, nonatomic) ASPopUpView *popUpView;
@property (nonatomic, strong) ASProgressPopUpView * progressView;
@end
