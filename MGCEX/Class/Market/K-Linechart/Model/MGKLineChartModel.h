//
//  MGKLineChartModel.h
//  MGCEX
//
//  Created by Joblee on 2018/6/7.
//  Copyright © 2018年 MGCion. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MGKLineChartModel : NSObject
///K线时间戳
@property (nonatomic, strong) NSString *t;
///收盘价
@property (nonatomic, strong) NSString *c;
///开盘价
@property (nonatomic, strong) NSString *o;
///最高价
@property (nonatomic, strong) NSString *h;
///最低价
@property (nonatomic, strong) NSString *l;
///成交量
@property (nonatomic, strong) NSString *v;

@end
