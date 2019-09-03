// MGC
//
// SettingViewModel.m
// MGCEX
//
// Created by MGC on 2018/5/22.
// Copyright © 2018年 MGCion. All rights reserved.
//
// @ description <#描述#> 

#import "SettingViewModel.h"

@implementation SettingViewModel


- (RACCommand *)settingLoginCommand
{
    @weakify(self);
    if (!_settingLoginCommand) {
        _settingLoginCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
            @strongify(self);
 
            return self.settingLoginSignal;
        }];
    }
    return _settingLoginCommand;
}

//获取个人信息
- (RACSignal *)settingLoginSignal{
 
    @weakify(self);
    _settingLoginSignal= [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        @strongify(self);
        NSString * urlStr = @"user/userList";
 
        [TTWNetworkManager logOntoCheckWithUrl:urlStr params:nil success:^(id  _Nullable response) {
            
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
    
    return _settingLoginSignal;
}


//开启关闭谷歌验证
- (RACSignal *)openCloseGoogleSignal
{
    
    @weakify(self);
    _openCloseGoogleSignal= [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        @strongify(self);
        NSString * urlStr = @"user/closeOrOpenGoogle";
        
        NSMutableDictionary * dic = [NSMutableDictionary new];
        [dic setValue:self.GoogleCode forKey:@"code"];
        [dic setValue:self.GooglePassword forKey:@"password"];
        [dic setValue:self.GoogleStatus forKey:@"status"];
        
        [TTWNetworkManager openCloseverifyGoogleKeyWithUrl:urlStr params:dic success:^(id  _Nullable response) {
            
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
    
    return _openCloseGoogleSignal;
}

//验证登录密码是否正确
- (RACSignal *)verifyLoainSignal
{
    
    @weakify(self);
    _verifyLoainSignal= [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        @strongify(self);
        NSString * urlStr = @"user/validatePassword";
        
        NSMutableDictionary * dic = [NSMutableDictionary new];
        [dic setValue:self.loginPasswoed forKey:@"password"];

        [TTWNetworkManager verifyLoginPasswordWithUrl:urlStr params:dic success:^(id  _Nullable response) {
            
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
    
    return _verifyLoainSignal;
}


@end
