//
//  MGRechargeVM.m
//  MGCEX
//
//  Created by Joblee on 2018/6/9.
//  Copyright © 2018年 MGCion. All rights reserved.
//

#import "MGRechargeVM.h"

@implementation MGRechargeVM
//充币
- (RACSignal *)rechargeSignal
{
    @weakify(self);
    _rechargeSignal = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        NSMutableDictionary * dic =[NSMutableDictionary new];
        [dic setValue:self.tradeCode forKey:@"tradeCode"];
        [TTWNetworkManager rechargeWithUrl:kGetRechargeUrl params:dic success:^(id  _Nullable response) {
            if (isSuccess(response)) {
                [subscriber sendNext:response[response_data]];
            }
            [subscriber sendCompleted];
        } failure:^(id  _Nullable response){
            [subscriber sendCompleted];
        } reqError:^(NSError * _Nullable error) {
            [subscriber sendCompleted];
        }];

        // 在信号量作废时，取消网络请求
        return [RACDisposable disposableWithBlock:^{
            [TTWNetworkHandler cancelRequestWithURL:kGetRechargeUrl];
        }];
    }];
    return _rechargeSignal;
}
@end
