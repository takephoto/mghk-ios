// MGC
//
// CoinEntrustModelList.m
// MGCEX
//
// Created by MGC on 2018/6/8.
// Copyright © 2018年 MGCion. All rights reserved.
//
// @ description <#描述#> 

#import "CoinEntrustModelList.h"

@implementation CoinEntrustModelList
+ (NSDictionary *)modelCustomPropertyMapper {
    return@{@"Id" :@"id"};
}


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
        _statusString = kLocalizedString(@"未成交");
    }else if ([self.status integerValue] == 2){
        _statusString = kLocalizedString(@"部分成交");
    }else if ([self.status integerValue] == 3){
        _statusString = kLocalizedString(@"完全成交");
    }else if ([self.status integerValue] == 4){
        _statusString = kLocalizedString(@"撤单中");
    }else if ([self.status integerValue] == 5){
        _statusString = kLocalizedString(@"已撤单");
    }
    
    return _statusString;
}
@end
