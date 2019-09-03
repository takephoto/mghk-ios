//
//  PlaceOrderHeader.h
//  MGCEX
//
//  Created by HFW on 2018/7/12.
//  Copyright © 2018年 MGCion. All rights reserved.
//

#import "BaseView.h"
#import "FiatDealBuyOrSellModel.h"

@interface PlaceOrderHeader : BaseView
@property (nonatomic, strong) FiatDealBuyOrSellModel *model;
@end
