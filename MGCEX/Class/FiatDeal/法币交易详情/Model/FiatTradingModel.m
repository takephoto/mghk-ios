// MGC
//
// FiatTradingModel.m
// MGCEX
//
// Created by MGC on 2018/5/28.
// Copyright © 2018年 MGCion. All rights reserved.
//
// @ description <#描述#> 

#import "FiatTradingModel.h"

@implementation FiatTradingModel

-(NSString *)tradeStatusString{
    
    if([self.buysell integerValue] == 1){//买家
        
        if([self.orderStatus integerValue] == 1){
            _tradeStatusString = kLocalizedString(@"待付款");
        }else if([self.orderStatus integerValue] == 2){
            _tradeStatusString = kLocalizedString(@"已付款");
        }else if([self.orderStatus integerValue] == 3){
            _tradeStatusString = @"已完成";
        }else if([self.orderStatus integerValue] == 6){
            _tradeStatusString = @"已取消";
        }
        
    }else{//卖家
        
        if([self.orderStatus integerValue] == 1){
            _tradeStatusString = kLocalizedString(@"待付款");
        }else if([self.orderStatus integerValue] == 2){
            _tradeStatusString = kLocalizedString(@"已付款");
        }else if([self.orderStatus integerValue] == 3){
            _tradeStatusString = @"已完成";
        }else if([self.orderStatus integerValue] == 6){
            _tradeStatusString = @"已取消";
        }
        
    }
    
 
    return _tradeStatusString;
}


-(NSString *)reTime{
    
    return s_Integer([_reTime integerValue]/1000) ;
}

- (void)setOrderTime:(NSString *)orderTime{
    
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:[orderTime doubleValue] / 1000];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.timeZone = [NSTimeZone timeZoneWithName:@"shanghai"];
    [dateFormatter setDateStyle:NSDateFormatterMediumStyle];
    [dateFormatter setTimeStyle:NSDateFormatterShortStyle];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *timeStr = [dateFormatter stringFromDate:date];
    _orderTime = timeStr;
}
@end
