// MGC
//
// FiatTransactionRecordHeadView.h
// MGCEX
//
// Created by MGC on 2018/5/29.
// Copyright © 2018年 MGCion. All rights reserved.
//
// @ description <#描述#> 

#import <UIKit/UIKit.h>
#import "CustomSegmentedView.h"

//确定按钮点击事件
typedef void(^BuyBlock)(void);

//取消按钮点击事件
typedef void(^SellBlock)(void);

@class FiatTransactionRecordHeadView;
@protocol TransactionRecordHeadDelegate // 代理传值方法
- (void)sendHeadFrameValue:(FiatTransactionRecordHeadView *)headV index:(NSInteger)index;
//1 法币交易。2币币交易 3广告发布。4积分兑换
- (void)sendSelectItemValue:(NSInteger )index;

@end


@interface FiatTransactionRecordHeadView : UIView
@property (nonatomic, copy) BuyBlock buyBlock;
@property (nonatomic, copy) SellBlock sellBlock;
@property (nonatomic, strong) QSButton * leftBtn;
@property (nonatomic, strong) QSButton * rightBtn;
@property (nonatomic, strong) UIButton * buyBtn;
@property (nonatomic, strong) UIButton * sellBtn;
@property (nonatomic, weak) NSObject <TransactionRecordHeadDelegate>* btnDelegate;
@property (nonatomic, strong) CustomSegmentedView * segMentview;
@property (nonatomic, assign) NSInteger selectedIndex;
@end
