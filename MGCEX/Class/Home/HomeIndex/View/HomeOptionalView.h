// MGC
//
// HomeOptionalView.h
// MGCEX
//
// Created by MGC on 2018/5/22.
// Copyright © 2018年 MGCion. All rights reserved.
//
// @ description <#描述#> 

#import "BaseView.h"
#import "MGMarketIndexRealTimeModel.h"


/**
 @brief 首页推荐或自选涨幅产品视图
 */
@interface HomeOptionalView : BaseView
@property (nonatomic, strong) MGMarketIndexRealTimeModel *model;
@property (nonatomic, strong) UILabel *label1;
@property (nonatomic, strong) UILabel *label2;
@property (nonatomic, strong) UILabel *label3;
@property (nonatomic, strong) UILabel *label4;

/**
 @brief 更新推荐产品

 @param model 推荐产品模型
 */
- (void)update:(MGMarketIndexRealTimeModel *)model;
@end
