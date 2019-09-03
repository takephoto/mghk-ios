
//
//  MGTransferVM.m
//  MGCEX
//
//  Created by Joblee on 2018/6/8.
//  Copyright © 2018年 MGCion. All rights reserved.
//

#import "MGTransferVM.h"

@implementation MGTransferVM


//获取某个币种所用数量
//转账
- (RACSignal *)transferSignal
{
    //    @weakify(self);
    _transferSignal = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        NSString * urlStr = @"capitalaccount/uptransfer";
        NSMutableDictionary * dic =[NSMutableDictionary new];
        [dic setValue:self.tradeCode forKey:@"tradeCode"];
        [dic setValue:self.availableBalance forKey:@"availableBalance"];
        [dic setValue:self.type forKey:@"type"];
        [TTWNetworkManager transferWithUrl:urlStr params:dic success:^(id  _Nullable response) {
            if (isSuccess(response)) {
                [TTWHUD showCustomMsg:kLocalizedString(@"划转成功")];
                [subscriber sendNext:nil];
            }else{
                ShowError(response);
            }
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
    return _transferSignal;
}
- (RACSignal *)getAvailableNumSignal
{
    //    @weakify(self);
    _getAvailableNumSignal = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        NSString * urlStr = @"capitalaccount/getnumber";
        NSMutableDictionary * dic =[NSMutableDictionary new];
        [dic setValue:self.tradeCode forKey:@"tradeCode"];
        [dic setValue:self.type forKey:@"type"];
        [TTWNetworkManager transferWithUrl:urlStr params:dic success:^(id  _Nullable response) {
            if (isSuccess(response)) {
                [subscriber sendNext:response[response_data][@"balance"]];
            }else{
                ShowError(response);
            }
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
    return _getAvailableNumSignal;
}




@end
