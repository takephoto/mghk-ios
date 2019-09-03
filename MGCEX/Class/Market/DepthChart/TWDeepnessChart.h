// MGC
//
// TWDeepnessChart.h
// 深度图demo
//
// Created by MGC on 2018/6/4.
// Copyright © 2018年 MGCion. All rights reserved.
//
// @ description <#描述#> 

#import <UIKit/UIKit.h>
#import "DepthChartModel.h"

@interface TWDeepnessChart : UIView
@property (nonatomic,assign) NSInteger timesCount;
@property (nonatomic,strong) UIColor *fillBuyColor;
@property (nonatomic,strong) UIColor *fillSellColor;
@property (nonatomic,strong) NSArray<__kindof DepthChartModel*> *dataArray;

@property (nonatomic,strong) NSArray<__kindof DepthChartModel*> *buyArray;
@property (nonatomic,strong) NSArray<__kindof DepthChartModel*> *sellArray;

@property (nonatomic,assign) CGFloat maxY;
@property (nonatomic,assign) CGFloat minY;
@property (nonatomic,assign) CGFloat maxX;
@property (nonatomic,assign) CGFloat minX;
@property (nonatomic,assign) CGFloat scaleY;
@property (nonatomic,assign) CGFloat scaleX;
@property (nonatomic,assign) CGFloat lineWidth;  //线宽  默认2
@property (nonatomic,assign) CGFloat leftMargin; //左间隙
@property (nonatomic,assign) CGFloat rightMargin; //右间隙
@property (nonatomic,assign) CGFloat topMargin;   //顶部间隙
@property (nonatomic,assign) CGFloat bottomMargin; // 底部间隙
@property (nonatomic,strong) UIColor *buyLineColor;//买 背景色
@property (nonatomic,strong) UIColor *sellLineColor;//卖。背景色
@property (nonatomic,strong) UIColor *volumeColor;//纵坐标成交量字体颜色
@property (nonatomic,strong) UIColor *bottomPriceColor;//横坐标价格字体颜色

-(void)stockFill;





@end
