// MGC
//
// SubFiatDealHeadView.h
// MGCEX
//
// Created by MGC on 2018/5/24.
// Copyright © 2018年 MGCion. All rights reserved.
//
// @ description <#描述#> 

#import "BaseView.h"

@class SubFiatDealHeadView;
@protocol SubFiatDealHeadViewDelegate // 代理传值方法
- (void)sendSubFrameValue:(SubFiatDealHeadView *)headV withBtnTag:(NSInteger)tag;

@end

@interface SubFiatDealHeadView : BaseView
@property (nonatomic, weak) NSObject <SubFiatDealHeadViewDelegate>* btnDelegate;
@property (nonatomic, strong) QSButton * leftBtn;
@property (nonatomic, strong) QSButton * middleBtn;
@property (nonatomic, strong) QSButton * rightBtn;
@end
