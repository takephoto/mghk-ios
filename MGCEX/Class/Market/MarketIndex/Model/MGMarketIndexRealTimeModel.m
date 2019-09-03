//
//  MGMarketIndexRealTimeModel.m
//  MGCEX
//
//  Created by Joblee on 2018/6/6.
//  Copyright © 2018年 MGCion. All rights reserved.
//

#import "MGMarketIndexRealTimeModel.h"

@implementation MGMarketIndexRealTimeModel
///映射
+ (NSDictionary *)modelCustomPropertyMapper {
    return @{@"latestPrice" : @"newPrice",
             @"latestVolume" : @"newVolume"};
}

@end
