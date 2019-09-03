//
//  MGCapitalTransferVM.m
//  MGCEX
//
//  Created by 汪跃山 on 2018/7/10.
//  Copyright © 2018年 MGCion. All rights reserved.
//

#import "MGCapitalTransferVM.h"

@implementation MGCapitalTransferVM

- (instancetype)initWithTradeCode:(NSString *)tradeCode availableBalance:(NSString *)availableBalance
{
    if (self = [super init]) {
        self.tradeCode = tradeCode;
        self.availableBalance = availableBalance;
    }
    return self;
}

- (NSString *)navTitleText
{
    return kLocalizedString(@"资金转移");
}

- (NSString *)footerButtonTitleText
{
    return kLocalizedString(@"提交");
}

- (RACSignal *)coinMoveSignal
{
    @weakify(self);
    _coinMoveSignal = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        @strongify(self);
        NSString * urlStr = @"coin/move";
        NSMutableDictionary *params = [NSMutableDictionary dictionary];
        [params setValue:self.tradeCode forKey:@"tradeCode"];
        [params setValue:self.capitalNum forKey:@"capitalNum"];
        [params setValue:self.code forKey:@"code"];
        [params setValue:self.pwd forKey:@"pwd"];
        [params setValue:self.loginNum forKey:@"loginNum"];
        [params setValue:self.account forKey:@"account"];

        [TTWNetworkManager commitCoinMoveWithUrl:urlStr params:params success:^(id  _Nullable response) {
            [subscriber sendNext:response[response_data]];
            [subscriber sendCompleted];
        } failure:^(id  _Nullable response) {
            [subscriber sendCompleted];

        } reqError:^(NSError * _Nullable error) {
            [subscriber sendError:error];

        }];
    
        // 在信号量作废时，取消网络请求
        return [RACDisposable disposableWithBlock:^{
            [TTWNetworkHandler cancelRequestWithURL:urlStr];
        }];
    }];
    
    return _coinMoveSignal;
}

@end
