// MGC
//
// UnsettledGearModel.m
// MGCEX
//
// Created by MGC on 2018/6/9.
// Copyright © 2018年 MGCion. All rights reserved.
//
// @ description <#描述#> 

#import "UnsettledGearModel.h"

@implementation UnsettledGearModel

-(void)setBuySell:(NSInteger)buySell{
    _buySell = buySell;
    
    if(_buySell == 2){//卖
        self.labelColor = kRedColor;
        self.backColor = UIColorFromRGB(0xFFF4F6);
        
    }else{//买
        self.labelColor = kGreenColor;
        self.backColor = UIColorFromRGB(0xEFFFF5);
    }
}





@end
