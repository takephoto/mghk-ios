//
//  MGWithdrawVM.h
//  MGCEX
//
//  Created by Joblee on 2018/6/8.
//  Copyright © 2018年 MGCion. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MGWithdrawVM : NSObject
///获取提币限额、可用数量
@property (nonatomic, copy) RACSignal *withdrawLimitSignal;
///提币
@property (nonatomic, copy) RACSignal *withdrawSignal;
///注册号码
@property (nonatomic, strong) NSString *loginNum;
///提币金额
@property (nonatomic, strong) NSString *amount;
///验证码
@property (nonatomic, strong) NSString *authCode;
///提币地址
@property (nonatomic, strong) NSString *address;
///币种
@property (nonatomic, strong) NSString *tradeCode;
///资金密码
@property (nonatomic, strong) NSString *reMoneyPassword;
@end
