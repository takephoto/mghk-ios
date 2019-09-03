//
//  MGCoinDealTradeHeader.h
//  MGCEX
//
//  Created by HFW on 2018/7/20.
//  Copyright © 2018年 MGCion. All rights reserved.
//

#import "BaseView.h"

@interface MGCoinDealTradeHeader : BaseView

@property (nonatomic, copy) NSString *price;
@property (nonatomic, copy) NSString *cnyPrice;
@property (nonatomic, copy) NSString *rose;//涨幅

@end
