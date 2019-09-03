//
//  MarketIndexCell.h
//  MGCEX
//
//  Created by Joblee on 2018/6/4.
//  Copyright © 2018年 MGCion. All rights reserved.
//

#import "ContentTableViewCell.h"
#import "MGMarketIndexModel.h"
#import "MGMarketIndexRealTimeModel.h"

@interface MarketIndexCell : ContentTableViewCell
@property (nonatomic, assign) BOOL isOptional;
@property (nonatomic, strong) MGMarketIndexModel *marketIndexModel;
@property (nonatomic, strong) MGMarketIndexRealTimeModel *marketIndexRealTimeModel;
@property (nonatomic, copy) void(^selectBlock)(BOOL selected);

@property (nonatomic, strong) UIImageView * tagImgV;
@property (nonatomic, strong) UILabel * titleLabel;
@property (nonatomic, strong) UILabel * subLabel;
@property (nonatomic, strong) UILabel * ratioLabel;
@property (nonatomic, strong) UILabel * priceLabel;
@property (nonatomic, strong) UILabel * subPriceLabel;

@end
