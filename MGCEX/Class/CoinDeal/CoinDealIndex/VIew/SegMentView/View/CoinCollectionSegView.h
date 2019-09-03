// MGC
//
// CoinCollectionSegView.h
// MGCEX
//
// Created by MGC on 2018/6/7.
// Copyright © 2018年 MGCion. All rights reserved.
//
// @ description <#描述#> 

#import <UIKit/UIKit.h>
#import "CoinCollectionModel.h"

@interface CoinCollectionSegView : UIView
@property (nonatomic, copy) void(^itemBlock)(NSInteger index);
@property (nonatomic, strong) NSArray <CoinCollectionModel *>* dataArray;


@end
