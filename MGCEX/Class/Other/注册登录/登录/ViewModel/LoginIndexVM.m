// MGC
//
// LoginIndexVM.m
// MGCEX
//
// Created by MGC on 2018/5/17.
// Copyright © 2018年 MGCion. All rights reserved.
//
// @ description <#描述#> 

#import "LoginIndexVM.h"

@implementation LoginIndexVM

//登录
- (RACSignal *)loginSignal
{
    @weakify(self);
    _loginSignal= [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        @strongify(self);
        NSString * urlStr = @"user/userLogin";
        NSMutableDictionary * dic =[NSMutableDictionary new];
        [dic setValue:self.loginNum forKey:@"loginNum"];
        [dic setValue:self.password forKey:@"password"];
        [dic setValue:self.latitudePoint forKey:@"latitudePoint"];
        [dic setValue:self.longitudePint forKey:@"longitudePoint"];
        [dic setValue:@"3" forKey:@"device"];

        [TTWNetworkManager userLoginAccountWithUrl:urlStr params:dic success:^(id  _Nullable response) {

           UserModel *model = [UserModel yy_modelWithJSON:response[response_data]];
            
            [[NSUserDefaults standardUserDefaults]setObject:model.phone forKey:VerifierPhone];
            [[NSUserDefaults standardUserDefaults] setObject:model.email forKey:VerifierEmail];
            [[NSUserDefaults standardUserDefaults] setObject:model.userId forKey:UserID];
            [[NSUserDefaults standardUserDefaults] synchronize];
            
            //保存网络用户信息
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
    
    return _loginSignal;
}


//二次验证
- (RACSignal *)validationSignal
{
    @weakify(self);
    _validationSignal= [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        @strongify(self);
        NSString * urlStr = @"user/setLogin2";
        NSMutableDictionary * dic =[NSMutableDictionary new];
        [dic setValue:self.loginNum forKey:@"loginNum"];
        [dic setValue:self.secondCode forKey:@"code"];
        
        
        [TTWNetworkManager secondaryValidationWithUrl:urlStr params:dic success:^(id  _Nullable response) {
 
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
    
    return _validationSignal;
}

//谷歌二次验证
- (RACSignal *)secondGoogleSignal
{
    @weakify(self);
    _secondGoogleSignal= [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        @strongify(self);
        NSString * urlStr = @"user/validateGoogle";
        NSMutableDictionary * dic =[NSMutableDictionary new];
        [dic setValue:self.googleCode forKey:@"code"];
   
        [TTWNetworkManager GoogleSecondverifyLoginWithUrl:urlStr params:dic success:^(id  _Nullable response) {
   
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
    
    return _secondGoogleSignal;
}
@end
