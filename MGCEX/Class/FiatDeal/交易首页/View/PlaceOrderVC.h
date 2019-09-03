//
//  PlaceOrderVC.h
//  MGCEX
//
//  Created by HFW on 2018/7/12.
//  Copyright © 2018年 MGCion. All rights reserved.
//

#import "TWBaseViewController.h"
#import "FiatDealBuyOrSellModel.h"

@interface PlaceOrderVC : BaseTableViewController

@property (nonatomic, strong) FiatDealBuyOrSellModel *model;
@property (nonatomic, assign) BOOL isBuy;//是否是买入Y  卖出N

@end
