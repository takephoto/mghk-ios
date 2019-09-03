//
//  MGKLineChartVM.h
//  MGCEX
//
//  Created by Joblee on 2018/6/7.
//  Copyright © 2018年 MGCion. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MGKLineChartVM : NSObject
//--------------k线图----------
///获取k线图数据
@property (nonatomic, copy) RACSignal *kLineDataSignal;
//代币
@property (nonatomic, strong) NSString *symbols;
///K线分辨率,1、5、15、30、60、D、2D等
@property (nonatomic, strong) NSString *resolution;
//--------------成交记录----------
///获取成交记录
@property (nonatomic, copy) RACSignal *getDealRecordSignal;
///获取币种信息
@property (nonatomic, copy) RACSignal *getCoinInfoSignal;
///市场
@property (nonatomic, strong) NSString *market;

@end
