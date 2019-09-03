// MGC
//
// BindingIdentityVM.m
// MGCEX
//
// Created by MGC on 2018/5/21.
// Copyright © 2018年 MGCion. All rights reserved.
//
// @ description <#描述#> 

#import "BindingIdentityVM.h"

@implementation BindingIdentityVM

//绑定
- (RACSignal *)bindingSignal
{
    @weakify(self);
    _bindingSignal= [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        @strongify(self);
        NSString * urlStr = @"user/setEmailOrPhone";
        NSMutableDictionary * dic =[NSMutableDictionary new];
        [dic setValue:self.loginNum forKey:@"loginNum"];
        [dic setValue:self.code forKey:@"code"];
        [dic setValue:self.regDev forKey:@"regDev"];
        
        [TTWNetworkManager phoneMailAuthenticationWithUrl:urlStr params:dic success:^(id  _Nullable response) {
            [subscriber sendNext:@"1"];
            [subscriber sendCompleted];
            
        }failure:^(id  _Nullable response){
            [subscriber sendCompleted];
        } reqError:^(NSError * _Nullable error) {
            [subscriber sendCompleted];
        }];
        
        // 在信号量作废时，取消网络请求
        return [RACDisposable disposableWithBlock:^{
            [TTWNetworkHandler cancelRequestWithURL:urlStr];
        }];
    }];
    
    return _bindingSignal;
}


@end
