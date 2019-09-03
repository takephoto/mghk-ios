// MGC
//
// RegisterIndexVM.m
// MGCEX
//
// Created by MGC on 2018/5/17.
// Copyright © 2018年 MGCion. All rights reserved.
//
// @ description <#描述#> 

#import "RegisterIndexVM.h"

@implementation RegisterIndexVM


/**
 *  刷新信号
 */
//- (RACCommand *)sendCommand
//{
//    @weakify(self);
//    if (!_sendCommand) {
//        _sendCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
//            @strongify(self);
//            return self.sendPhoneCodeSignal;
//        }];
//    }
//    return _sendCommand;
//}

//发送手机或邮箱验证码
- (RACSignal *)sendPhoneCodeSignal
{
    @weakify(self);
    _sendPhoneCodeSignal= [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        @strongify(self);
        NSString * urlStr = (self.registerType == 1)? @"user/sendCode": @"user/sendEmailCode";

        NSMutableDictionary * dic = [NSMutableDictionary new];
        if(self.registerType == 1){
            [dic setValue:self.loginNum forKey:@"phone"];
        
        }else{
            [dic setValue:self.loginNum forKey:@"email"];
      
        }
        [dic setValue:@"3" forKey:@"device"];
        
        [TTWNetworkManager phoneVerificationCodeWithUrl:urlStr params:dic success:^(id  _Nullable response) {
            
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
    
    return _sendPhoneCodeSignal;
}

//注册手机或邮箱
- (RACSignal *)registerPhoneSignal
{
    _registerPhoneSignal= [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        
        NSString * urlStr = @"user/userRegister";
        NSMutableDictionary * dic =[NSMutableDictionary new];
        [dic setValue:@"3" forKey:@"regDev"];
        [dic setValue:self.loginNum forKey:@"loginNum"];
        [dic setValue:self.password forKey:@"password"];
        [dic setValue:self.code forKey:@"code"];
        [dic setValue:self.regFromCode forKey:@"regFromCode"];
        @weakify(self);
        [TTWNetworkManager RegisterPhoneOrMailWithUrl:urlStr params:dic success:^(id  _Nullable response) {
            @strongify(self);
       
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
    
    return _registerPhoneSignal;
}
@end
