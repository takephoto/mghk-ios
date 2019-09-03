//
//  MGWithdrawVM.m
//  MGCEX
//
//  Created by Joblee on 2018/6/8.
//  Copyright © 2018年 MGCion. All rights reserved.
//

#import "MGWithdrawVM.h"
#import "MGWithdrawModel.h"

@implementation MGWithdrawVM
//提币限额、可用金额
- (RACSignal *)withdrawLimitSignal
{
    //    @weakify(self);
    _withdrawLimitSignal = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        NSMutableDictionary * dic =[NSMutableDictionary new];
        [dic setValue:self.tradeCode forKey:kTradeCode];
        [TTWNetworkManager getCoinFundsInfoWithUrl:ketCoinFundsInfoUrl params:dic success:^(id  _Nullable response) {
            MGWithdrawModel *model = [MGWithdrawModel yy_modelWithJSON:response[response_data]];
            if (isSuccess(response)) {
                [subscriber sendNext:model];
            }else{
                ShowError(response);
            }
            [subscriber sendCompleted];
        } failure:^(id  _Nullable response){
            [subscriber sendCompleted];
        } reqError:^(NSError * _Nullable error) {
            [subscriber sendCompleted];
        }];
        
        // 在信号量作废时，取消网络请求
        return [RACDisposable disposableWithBlock:^{
            [TTWNetworkHandler cancelRequestWithURL:ketCoinFundsInfoUrl];
        }];
    }];
    return _withdrawLimitSignal;
}
//提币
- (RACSignal *)withdrawSignal
{
    //    @weakify(self);
    _withdrawSignal = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        NSMutableDictionary * dic =[NSMutableDictionary new];
        [dic setValue:self.loginNum forKey:@"loginNum"];
        [dic setValue:self.amount forKey:@"amount"];
        [dic setValue:self.authCode forKey:@"authCode"];
        [dic setValue:self.address forKey:@"address"];
        [dic setValue:self.tradeCode forKey:@"tradeCode"];
        [dic setValue:self.reMoneyPassword forKey:@"reMoneyPassword"];
        [TTWNetworkManager withdrawWithUrl:kWithdrawUrl params:dic success:^(id  _Nullable response) {
            [TTWHUD showCustomMsg:kLocalizedString(@"操作成功")];
            [subscriber sendNext:response[response_data]];
            [subscriber sendCompleted];
        } failure:^(id  _Nullable response){
            [subscriber sendCompleted];
        } reqError:^(NSError * _Nullable error) {
            [subscriber sendCompleted];
        }];
        
        // 在信号量作废时，取消网络请求
        return [RACDisposable disposableWithBlock:^{
            [TTWNetworkHandler cancelRequestWithURL:kWithdrawUrl];
        }];
    }];
    return _withdrawSignal;
}

@end
