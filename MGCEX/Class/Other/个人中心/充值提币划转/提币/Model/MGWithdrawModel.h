//
//  MGWithdrawModel.h
//  MGCEX
//
//  Created by Joblee on 2018/6/10.
//  Copyright © 2018年 MGCion. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MGWithdrawModel : NSObject
///可用余额
@property (nonatomic, strong) NSString *availableBalance;
///销毁比例
@property (nonatomic, assign) double destructionRate;
///提现手续费
@property (nonatomic, strong) NSString *drawFee;
///当日限额上限（总额）
@property (nonatomic, strong) NSString *drawHigh;
///现最低额度（单笔）
@property (nonatomic, strong) NSString *drawLow;
///手续费单位
@property (nonatomic, strong) NSString *feeUnit;
///币种
@property (nonatomic, strong) NSString *tradeCode;
///地址
@property (nonatomic, strong) NSString *walletAddress;
@end
