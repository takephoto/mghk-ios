//
//  MGCapitalTransferVM.h
//  MGCEX
//
//  Created by 汪跃山 on 2018/7/10.
//  Copyright © 2018年 MGCion. All rights reserved.
//

#import "BaseViewModel.h"

@interface MGCapitalTransferVM : BaseViewModel

// 导航标题
@property (nonatomic, strong) NSString *navTitleText;
// 导航标题
@property (nonatomic, strong) NSString *footerButtonTitleText;
// 请求信号
@property (nonatomic, strong) RACSignal *coinMoveSignal;
// 币种
@property (nonatomic, strong) NSString *tradeCode;
// 可用数量
@property (nonatomic, strong) NSString *availableBalance;
// 数量
@property (nonatomic, strong) NSString *capitalNum;
// 验证码
@property (nonatomic, strong) NSString *code;
// 资金密码
@property (nonatomic, strong) NSString *pwd;
// 邮箱或手机号
@property (nonatomic, strong) NSString *loginNum;
// 转移账户
@property (nonatomic, strong) NSString *account;



- (instancetype)initWithTradeCode:(NSString *)tradeCode  availableBalance:(NSString *)availableBalance;

@end
