// MGC
//
// FiatDealHeadView.h
// MGCEX
//
// Created by MGC on 2018/5/24.
// Copyright © 2018年 MGCion. All rights reserved.
//
// @ description <#描述#> 

#import "BaseView.h"
#import <UIKit/UIKit.h>

@class FiatDealHeadView;
@protocol FiatDealHeadViewDelegate // 代理传值方法
- (void)sendFrameValue:(FiatDealHeadView *)headV;

- (void)selectSegmentWithIndex:(NSInteger )index;
- (void)transactionRecords;
@end

@interface FiatDealHeadView : BaseView

@property (nonatomic , strong) QSButton * leftBtn;
@property (nonatomic, weak) NSObject <FiatDealHeadViewDelegate>* btnDelegate;
@property (nonatomic, strong) UILabel * rightLabel;
@end
