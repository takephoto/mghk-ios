//
//  MGKLineChartHeader.h
//  MGCEX
//
//  Created by Joblee on 2018/6/6.
//  Copyright © 2018年 MGCion. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseView.h"
#import "Y_StockChartView.h"
#import "TopDisplayView.h"
#import "MGKLineChartVM.h"

@interface MGKLineChartHeader : BaseView
///k线图
@property (nonatomic, strong) Y_StockChartView *stockChartView;
///顶部展示数据视图
@property (nonatomic, strong) TopDisplayView *displayView;
///k线图数据
@property (nonatomic, strong) NSArray *kLineChartDataArr;
- (void)updateDataWithArray:(NSArray *)dataArr;
- (void)remakeStockViewContraint;
@property (nonatomic, strong) MGKLineChartVM *viewModel;
///代币类型
@property (nonatomic, strong) NSString *symbols;
///市场
@property (nonatomic, strong) NSString *market;
@end
