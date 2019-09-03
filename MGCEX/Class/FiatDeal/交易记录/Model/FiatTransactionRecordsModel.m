// MGC
//
// FiatTransactionRecordsModel.m
// MGCEX
//
// Created by MGC on 2018/6/1.
// Copyright © 2018年 MGCion. All rights reserved.
//
// @ description <#描述#> 

#import "FiatTransactionRecordsModel.h"

@implementation FiatTransactionRecordsModel

-(NSString *)statusString{
    
    if([self.orderStatus integerValue ]== 1){
        _statusString = kLocalizedString(@"未付款");
        self.statusColor = kRedColor;
        
    }else if([self.orderStatus integerValue ]== 2){
        _statusString = kLocalizedString(@"未发货");
        self.statusColor = kGreenColor;
        
    }else if([self.orderStatus integerValue ]== 3){
        _statusString = @"已完成";
        self.statusColor = kTextColor;
        
    }
    else if([self.orderStatus integerValue ]== 6){
        _statusString = @"已取消";
        self.statusColor = k99999Color;
        
    }
   
    return _statusString;
}



@end
