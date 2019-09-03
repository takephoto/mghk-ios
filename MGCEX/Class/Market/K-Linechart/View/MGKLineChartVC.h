//
//  MGKLineChartVC.h
//  MGCEX
//
//  Created by Joblee on 2018/6/5.
//  Copyright © 2018年 MGCion. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TopDisplayView.h"
#import "MGMarketIndexRealTimeModel.h"
@interface MGKLineChartVC : TWBaseViewController
@property (nonatomic, assign) NSInteger tt;
///代币类型
@property (nonatomic, strong) NSString *symbols;
///市场
@property (nonatomic, strong) NSString *market;
///对应的model
@property (nonatomic, strong) MGMarketIndexRealTimeModel *model;
@end

