// MGC
//
// BindingGoogleVM.m
// MGCEX
//
// Created by MGC on 2018/5/25.
// Copyright © 2018年 MGCion. All rights reserved.
//
// @ description <#描述#> 

#import "BindingGoogleVM.h"
#import "BindingGoogleModel.h"

@implementation BindingGoogleVM

//获取谷歌Key
- (RACSignal *)googleSignal
{
    @weakify(self);
    _googleSignal= [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        @strongify(self);
        NSString * urlStr = @"user/getGoogleSecret";
        
        NSMutableDictionary * dic =[NSMutableDictionary new];
        NSString * loginName = [[NSUserDefaults standardUserDefaults] objectForKey:CurrentLogin];
        [dic setValue:loginName forKey:@"loginNum"];
        [TTWNetworkManager getGoogleKeyWithUrl:urlStr params:dic success:^(id  _Nullable response) {
      
           BindingGoogleModel * model = [BindingGoogleModel yy_modelWithJSON:response[@"data"]];
            
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
    
    return _googleSignal;
}


//谷歌验证提交
- (RACSignal *)verifyGoogleSignal
{
    @weakify(self);
    _verifyGoogleSignal= [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        @strongify(self);
        NSString * urlStr = @"user/setGoogle";
        
        NSMutableDictionary * dic =[NSMutableDictionary new];
        [dic setValue:self.secret forKey:@"secret"];
        [dic setValue:self.code forKey:@"code"];
        
        [TTWNetworkManager verifyGoogleKeyWithUrl:urlStr params:dic success:^(id  _Nullable response) {
          
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
    
    return _verifyGoogleSignal;
}

@end
