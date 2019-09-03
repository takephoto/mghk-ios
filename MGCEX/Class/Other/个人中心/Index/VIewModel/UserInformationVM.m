// MGC
//
// UserInformationVM.m
// MGCEX
//
// Created by MGC on 2018/5/21.
// Copyright © 2018年 MGCion. All rights reserved.
//
// @ description <#描述#> 

#import "UserInformationVM.h"

@implementation UserInformationVM

//获取用户信息
- (RACSignal *)userInfoSignal
{
    @weakify(self);
    _userInfoSignal= [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        @strongify(self);
        NSString * urlStr = @"user/userList";
    
        [TTWNetworkManager getUserInfomationWithUrl:urlStr params:nil success:^(id  _Nullable response) {

           UserModel *model = [UserModel yy_modelWithJSON:response[response_data]];
            
            [[NSUserDefaults standardUserDefaults]setObject:model.phone forKey:VerifierPhone];
            [[NSUserDefaults standardUserDefaults] setObject:model.email forKey:VerifierEmail];
            [[NSUserDefaults standardUserDefaults] synchronize];
            
            //本地保持用户信息
            [TWUserDefault UserDefaultSaveUserModel:model];
            
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
    
    return _userInfoSignal;
}

//获取法币
- (RACSignal *)fiatInfoSignal
{
    @weakify(self);
    _fiatInfoSignal= [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        @strongify(self);
        NSString * urlStr = @"capitalaccount/getuff";
        NSMutableDictionary * dic = [NSMutableDictionary new];
        [dic setValue:self.type forKey:@"type"];
        //[dic setObject:self.tradeCode forKey:@"tradeCode"];
        [dic setValue:self.istrue forKey:@"istrue"];

        
        [TTWNetworkManager getFiatInfoWithUrl:urlStr params:dic success:^(id  _Nullable response) {

            FiatAccountModel * model = [FiatAccountModel yy_modelWithJSON:response[response_data]];
            
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
    
    return _fiatInfoSignal;
}

//获取币币
- (RACSignal *)coinInfoSignal
{
    @weakify(self);
    _coinInfoSignal= [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        @strongify(self);
        NSString * urlStr = @"capitalaccount/getucc";
        NSMutableDictionary * dic = [NSMutableDictionary new];
        [dic setValue:self.type forKey:@"type"];
        //[dic setObject:self.tradeCode forKey:@"tradeCode"];
        [dic setValue:self.istrue forKey:@"istrue"];
        
        [TTWNetworkManager getFiatInfoWithUrl:urlStr params:dic success:^(id  _Nullable response) {
            
            CoinAccountModel * model = [CoinAccountModel yy_modelWithJSON:response[response_data]];
            
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
    
    return _coinInfoSignal;
}

@end
