// MGC
//
// HandIdentityCardVM.m
// MGCEX
//
// Created by MGC on 2018/5/21.
// Copyright © 2018年 MGCion. All rights reserved.
//
// @ description <#描述#> 

#import "HandIdentityCardVM.h"

@implementation HandIdentityCardVM

//发送手机或邮箱验证码
- (RACSignal *)authenticationSignal
{
    @weakify(self);
    _authenticationSignal= [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        @strongify(self);
    
        NSString * urlStr = @"user/setUserIdentity";
        NSMutableDictionary * dic =[NSMutableDictionary new];
        [dic setValue:self.type forKey:@"cardType"];
        [dic setValue:self.identityNum forKey:@"cardNumber"];
        [dic setValue:self.surname forKey:@"familyName"];
        [dic setValue:self.name forKey:@"userName"];
        [dic setValue:self.fullName forKey:@"userAllName"];
        [dic setValue:self.frontCardUrl forKey:@"frontCardUrl"];
        [dic setValue:self.backCardUrl forKey:@"backCardUrl"];
        [dic setValue:self.holdCardurl forKey:@"holdCardurl"];
        
        [TTWNetworkManager theIdentityAuthenticationWithUrl:urlStr params:dic success:^(id  _Nullable response) {
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
    
    return _authenticationSignal;
}


@end
