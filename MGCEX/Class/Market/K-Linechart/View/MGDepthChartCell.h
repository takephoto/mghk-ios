//
//  MGDepthChartCell.h
//  MGCEX
//
//  Created by Joblee on 2018/6/6.
//  Copyright © 2018年 MGCion. All rights reserved.
//

#import "BaseTableViewCell.h"
#import "TWDeepnessChart.h"
@interface MGDepthChartCell : BaseTableViewCell
/**UI数据源*/
@property (nonatomic,strong) NSMutableArray *buyAray;
@property (nonatomic,strong) NSMutableArray *sellArray;
@property (nonatomic,strong) TWDeepnessChart *depthChartView;
@property (nonatomic,strong) NSMutableArray * buyTotalNumber;
@property (nonatomic,strong) NSMutableArray * sellTotalNumber;
@end
