// MGC
//
// CoinDealSegHeadView.h
// MGCEX
//
// Created by MGC on 2018/6/6.
// Copyright © 2018年 MGCion. All rights reserved.
//
// @ description <#描述#> 

#import <UIKit/UIKit.h>
#import "CustomSegmentedView.h"
typedef void (^SegmentHeadBlock)(NSInteger index);

@interface CoinDealSegHeadView : UIView
@property (nonatomic, copy) SegmentHeadBlock segmentBlock;
@property (nonatomic, strong) CustomSegmentedView * segMentview;
@property (nonatomic, strong) QSButton * optionalBtn;
@end
