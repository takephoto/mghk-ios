//
//  TopDisplayView.h
//  BTC-Kline
//
//  Created by Joblee on 2018/6/5.
//  Copyright © 2018年 yate1996. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "QuotesModel.h"
#import "MGMarketIndexRealTimeModel.h"
@interface TopDisplayView : UIView
@property (nonatomic, strong) MGMarketIndexRealTimeModel *model;
@end
