// MGC
//
// FiatSetAccountVM.m
// MGCEX
//
// Created by MGC on 2018/5/31.
// Copyright © 2018年 MGCion. All rights reserved.
//
// @ description <#描述#> 

#import "FiatSetAccountVM.h"
#import "FiatSetAccountModel.h"
@implementation FiatSetAccountVM

//设置账户
- (RACSignal *)setAccountSignal
{
    @weakify(self);
    _setAccountSignal= [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        @strongify(self);
        NSString * urlStr = @"coin/setPayWay";
        NSMutableDictionary * dic =[NSMutableDictionary new];
        [dic setValue:self.payeeName forKey:@"payeeName"];
        [dic setValue:self.payType forKey:@"payType"];
        [dic setValue:self.bankName forKey:@"bankName"];
        [dic setValue:self.bankBrachName forKey:@"bankBrachName"];
        [dic setValue:self.payeeAccount forKey:@"payeeAccount"];
        [dic setValue:self.payeeAccountUrl forKey:@"payeeAccountUrl"];
        [dic setValue:self.summary forKey:@"summary"];
        [dic setValue:self.status forKey:@"status"];
        [dic setValue:self.reMoneyPassword forKey:@"reMoneyPassword"];
        [dic setValue:self.code forKey:@"code"];
        [dic setValue:self.loginNum forKey:@"loginNum"];

        [TTWNetworkManager bindingBankCardZfbWxWithUrl:urlStr params:dic success:^(id  _Nullable response) {
            
            [subscriber sendNext:@"1"];
            [subscriber sendCompleted];
            
        } failure:^(id  _Nullable response){
            [subscriber sendCompleted];
        } reqError:^(NSError * _Nullable error) {
            [subscriber sendCompleted];
        }];
        
        // 在信号量作废时，取消网络请求
        return [RACDisposable disposableWithBlock:^{
            [TTWNetworkHandler cancelRequestWithURL:urlStr];
        }];
    }];
    
    return _setAccountSignal;
}

//获取账户信息
- (RACSignal *)getAccountSignal
{
    @weakify(self);
    _getAccountSignal= [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        @strongify(self);
        NSString * urlStr = @"coin/getPayWayApp";
        NSMutableDictionary * dic =[NSMutableDictionary new];
        [dic setValue:self.tradingUserid forKey:@"userId"];
        
        [TTWNetworkManager getBindingBankCardZfbWxWithUrl:urlStr params:dic success:^(id  _Nullable response) {
       
            FiatSetAccountModel * model = [FiatSetAccountModel yy_modelWithJSON:[response valueForKey:response_data]];
          
            [subscriber sendNext:model];
            [subscriber sendCompleted];
            
        } failure:^(id  _Nullable response){
            [subscriber sendCompleted];
        } reqError:^(NSError * _Nullable error) {
            [subscriber sendCompleted];
        }];
        
        // 在信号量作废时，取消网络请求
        return [RACDisposable disposableWithBlock:^{
            [TTWNetworkHandler cancelRequestWithURL:urlStr];
        }];
    }];
    
    return _getAccountSignal;
}
@end
