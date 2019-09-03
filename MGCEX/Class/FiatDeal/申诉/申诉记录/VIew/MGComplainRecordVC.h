//
//  MGComplainRecordVC.h
//  MGCEX
//
//  Created by Joblee on 2018/6/5.
//  Copyright © 2018年 MGCion. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MGComplainRecordVC : TWBaseViewController
///买入/卖出
@property (nonatomic, strong) NSString *sellBuy;
///订单id
@property (nonatomic, strong) NSString *fiatDealTradeOrderId;
///用户名
@property (nonatomic, strong) NSString *payeeName;

@end
