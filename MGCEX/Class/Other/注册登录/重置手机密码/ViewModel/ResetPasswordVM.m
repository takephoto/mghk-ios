// MGC
//
// ResetPasswordVM.m
// MGCEX
//
// Created by MGC on 2018/5/18.
// Copyright © 2018年 MGCion. All rights reserved.
//
// @ description <#描述#> 

#import "ResetPasswordVM.h"

@implementation ResetPasswordVM


//重置
- (RACSignal *)resetCodeSignal
{
    @weakify(self);
    _resetCodeSignal= [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        @strongify(self);
        NSString * urlStr = @"user/resetPassword";
        NSMutableDictionary * dic =[NSMutableDictionary new];
        [dic setValue:self.loginNum forKey:@"loginNum"];
        [dic setValue:self.password forKey:@"password"];
        [dic setValue:self.code forKey:@"code"];

        
        [TTWNetworkManager resetPasswordWithUrl:urlStr params:dic success:^(id  _Nullable response) {
            
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
    
    return _resetCodeSignal;
}
@end
