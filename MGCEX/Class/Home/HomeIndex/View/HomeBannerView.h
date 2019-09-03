// MGC
//
// HomeBannerView.h
// MGCEX
//
// Created by MGC on 2018/5/10.
// Copyright © 2018年 MGCion. All rights reserved.
//
// @ description <#描述#> 

#import "BaseView.h"
#import "SDCycleScrollView.h"

typedef void (^picUrlBlock)(NSDictionary *dic,NSInteger index);
@interface HomeBannerView : BaseView
///轮播图
@property (nonatomic, strong) SDCycleScrollView *cycleScrollView;
@property (nonatomic, strong) NSMutableArray * picArr;
@property (nonatomic, copy) picUrlBlock picBlock;
@end
