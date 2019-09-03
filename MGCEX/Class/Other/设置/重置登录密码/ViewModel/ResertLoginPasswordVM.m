// MGC
//
// ResertLoginPasswordVM.m
// MGCEX
//
// Created by MGC on 2018/5/21.
// Copyright © 2018年 MGCion. All rights reserved.
//
// @ description <#描述#> 

#import "ResertLoginPasswordVM.h"

@implementation ResertLoginPasswordVM


//重置登录
- (RACSignal *)validationLoginSignal
{
    @weakify(self);
    _validationLoginSignal= [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        @strongify(self);
        NSString * urlStr = @"user/modifyPassword";
        NSMutableDictionary * dic =[NSMutableDictionary new];
        [dic setValue:self.password forKey:@"password"];
        [dic setValue:self.currentPassword forKey:@"newPassword"];

        
        [TTWNetworkManager changeLoginPasswordWithUrl:urlStr params:dic success:^(id  _Nullable response) {
   
            [subscriber sendNext:@"1"];
            [subscriber sendCompleted];
            
        }  failure:^(id  _Nullable response){
            [subscriber sendCompleted];
        } reqError:^(NSError * _Nullable error) {
            [subscriber sendCompleted];
        }];
        
        // 在信号量作废时，取消网络请求
        return [RACDisposable disposableWithBlock:^{
            [TTWNetworkHandler cancelRequestWithURL:urlStr];
        }];
    }];
    
    return _validationLoginSignal;
}


@end
