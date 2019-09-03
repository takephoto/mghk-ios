// MGC
//
// QuotesModel.m
// MGCEX
//
// Created by MGC on 2018/6/9.
// Copyright © 2018年 MGCion. All rights reserved.
//
// @ description <#描述#> 

#import "QuotesModel.h"

@implementation QuotesModel

-(NSString *)gainSymbol{
    if([self.gains floatValue]>0){
        return @"+";
    }else{
        return @"";
    }
}

-(UIColor *)gainsColor{
    if([self.gains floatValue]>0){
        return kGreenColor;
    }else{
        return kRedColor;
    }
}

+ (NSDictionary *)modelCustomPropertyMapper {
    return@{@"NewPrice" :@"newPrice",@"NewVolume" :@"newVolume"};
}
@end
