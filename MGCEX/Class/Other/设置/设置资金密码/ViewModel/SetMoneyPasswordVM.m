// MGC
//
// SetMoneyPasswordVM.m
// MGCEX
//
// Created by MGC on 2018/5/26.
// Copyright © 2018年 MGCion. All rights reserved.
//
// @ description <#描述#> 

#import "SetMoneyPasswordVM.h"

@implementation SetMoneyPasswordVM

//设置资金密码
- (RACSignal *)resertMoneySignal
{
    @weakify(self);
    _resertMoneySignal= [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        @strongify(self);
        NSString * urlStr = @"user/modifyMoneyPassword";
        NSMutableDictionary * dic =[NSMutableDictionary new];
        [dic setValue:self.password forKey:@"password"];
        [dic setValue:self.loginNum forKey:@"loginNum"];
        [dic setValue:self.code forKey:@"code"];
        
        
        [TTWNetworkManager SettingMoneyPasswordWithUrl:urlStr params:dic success:^(id  _Nullable response) {
            
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
    
    return _resertMoneySignal;
}

@end
