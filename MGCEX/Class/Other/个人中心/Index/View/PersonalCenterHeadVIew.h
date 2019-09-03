// MGC
//
// PersonalCenterHeadVIew.h
// MGCEX
//
// Created by MGC on 2018/5/15.
// Copyright © 2018年 MGCion. All rights reserved.
//
// @ description <#描述#> 

#import "BaseView.h"

@interface PersonalCenterHeadVIew : BaseView
@property (nonatomic, strong) UILabel * userName;
@property (nonatomic, copy) void (^itemBlock)(NSInteger index);

@property (nonatomic,strong) UICollectionView *collectionView;
@property (nonatomic,copy) NSString * FiatbtcCount;
@property (nonatomic,copy) NSString * FiatcnySum;

@property (nonatomic,copy) NSString * CoinbtcCount;
@property (nonatomic,copy) NSString * CoincnySum;
@end
