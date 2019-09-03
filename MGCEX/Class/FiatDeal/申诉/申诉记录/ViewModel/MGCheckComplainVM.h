//
//  MGCheckComplainVM.h
//  MGCEX
//
//  Created by Joblee on 2018/6/5.
//  Copyright © 2018年 MGCion. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MGCheckComplainVM : NSObject
///查看申诉
@property (nonatomic, copy) RACSignal *checkComplainSignal;
///订单id
@property (nonatomic, strong) NSString *fiatDealTradeOrderId;
///买/卖
@property (nonatomic, strong) NSString *sellBuy;
@end
