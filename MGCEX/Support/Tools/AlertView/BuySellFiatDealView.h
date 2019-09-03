// MGC
//
// BuySellFiatDealView.h
// MGCEX
//
// Created by MGC on 2018/5/25.
// Copyright © 2018年 MGCion. All rights reserved.
//
// @ description <#描述#> 

#import <UIKit/UIKit.h>
#import "FiatDealBuyOrSellModel.h"

//确定按钮点击事件
typedef void(^sureBlock)(NSString * tradeAmount,NSString * tradeQuantity,NSString * tradeCode);

//取消按钮点击事件
typedef void(^cancelBlock)(void);

@interface BuySellFiatDealView : UIView

@property(nonatomic,copy)cancelBlock cancel_block;
@property(nonatomic,copy)sureBlock sure_block;

-(instancetype)initWithSupView:(UIView *)toView model:(FiatDealBuyOrSellModel *)model sureBtnTitle:(NSString *)sureBtnTitle sureBtnClick:(sureBlock)sureBlock cancelBtnClick:(cancelBlock)cancelBlock;

- (void)show;

-(void)hidden;

@end
