//
//  MGCheckComplainVM.m
//  MGCEX
//
//  Created by Joblee on 2018/6/5.
//  Copyright © 2018年 MGCion. All rights reserved.
//

#import "MGCheckComplainVM.h"
#import "MGCheckComplainModel.h"

@implementation MGCheckComplainVM

- (RACSignal *)checkComplainSignal
{
    @weakify(self);
    _checkComplainSignal= [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        @strongify(self);
        NSString * urlStr = @"coin/getLawsuitRecord";
        NSMutableDictionary * dic =[NSMutableDictionary new];
        [dic setValue:self.fiatDealTradeOrderId forKey:@"fiatDealTradeOrderId"];
        [dic setValue:self.sellBuy forKey:@"sellBuy"];
        
        [TTWNetworkManager checkComplainWithUrl:urlStr params:dic success:^(id  _Nullable response) {
            
            if ([response[@"code"] integerValue] == 1) {
                MGCheckComplainModel *model = [MGCheckComplainModel yy_modelWithJSON:response[response_data]];
                [subscriber sendNext:model];
            }else{
                [TTWHUD showCustomMsg:kLocalizedString(@"提交")];
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
    return _checkComplainSignal;
}
@end
