// MGC
//
// CoinDealIndexTableHeadView.m
// MGCEX
//
// Created by MGC on 2018/6/6.
// Copyright © 2018年 MGCion. All rights reserved.
//
// @ description <#描述#> 

#import "CoinDealIndexTableHeadView.h"
#import "CustomSegmentedView.h"
#import "CoinDealSegHeadView.h"
#import "MGCoinDealRecordView.h"

@interface CoinDealIndexTableHeadView()

@end

@implementation CoinDealIndexTableHeadView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
       
        [self setUpViews];
    }
    return self;
}

-(void)setUpViews{
    
    self.backgroundColor = kBackGroundColor;
    
    //头部选择器
    self.segMentView = [[CoinDealSegHeadView alloc]initWithFrame:CGRectMake(0, 0, self.width, Adapted(43))];
    [self addSubview:self.segMentView];
    
    
    
    //左边
    self.leftView = [[CoinDealBuySellSubView alloc]initWithFrame:CGRectMake(0, self.segMentView.height, MAIN_SCREEN_WIDTH * 0.55, Adapted(390))];
    [self addSubview:self.leftView];
    
    
    //右边
    self.rightView = [[MGCoinDealRecordView alloc]initWithFrame:CGRectMake(self.leftView.width+Adapted(3), self.leftView.y, MAIN_SCREEN_WIDTH-self.leftView.width-Adapted(6), self.leftView.height)];
    [self addSubview:self.rightView];
}

@end
