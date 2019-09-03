// MGC
//
// CoinEntrusHistoryModelList.m
// MGCEX
//
// Created by MGC on 2018/6/8.
// Copyright © 2018年 MGCion. All rights reserved.
//
// @ description <#描述#> 

#import "CoinEntrusHistoryModelList.h"

@implementation CoinEntrusHistoryModelList

-(NSString *)buySellString{
    if([self.buysell integerValue] == 1){
        _buySellString = kLocalizedString(@"买入");
        self.buySellColor = kGreenColor;
    }else{
        _buySellString = kLocalizedString(@"卖出");
        self.buySellColor = kRedColor;
    }
    return _buySellString;
}

-(NSString *)statusString{
    if([self.status integerValue] == 1){
        _statusString = @"未成交";
    }else if ([self.status integerValue] == 2){
        _statusString = @"部分成交";
    }else if ([self.status integerValue] == 3){
        _statusString = @"完全成交";
    }else if ([self.status integerValue] == 4){
        _statusString = @"撤单中";
    }else if ([self.status integerValue] == 5){
        _statusString = @"已撤单";
    }
    
    return _statusString;
}


+ (NSDictionary *)modelCustomPropertyMapper {
    return@{@"Id" :@"id"};
}
@end
