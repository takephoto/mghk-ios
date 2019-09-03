//
//  FiatadvertisingPublishVM.m
//  MGCEX
//
//  Created by Joblee on 2018/6/2.
//  Copyright © 2018年 MGCion. All rights reserved.
//

#import "FiatadvertisingPublishVM.h"
#import "MGAdPayWayModel.h"
#import "MGInternationalPriceModel.h"

@implementation FiatadvertisingPublishVM

//发布广告
- (RACSignal *)publicSignal
{
    @weakify(self);
    _publicSignal= [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        @strongify(self);
        NSString * urlStr = @"advertising/addAdvertising";
        NSMutableDictionary * dic =[NSMutableDictionary new];
        [dic setObject:s_number(self.buysell) forKey:@"buysell"];
        [dic setValue:self.tradeCode forKey:@"tradeCode"];
        [dic setValue:self.payVal forKey:@"payVal"];
        [dic setValue:self.priceVal forKey:@"priceVal"];
        [dic setValue:self.salesVal forKey:@"salesVal"];
        [dic setValue:self.lowVal forKey:@"lowVal"];
        [dic setValue:self.hightVal forKey:@"hightVal"];
        [dic setValue:@""forKey:@"summary"];
        [dic setObject:@(self.type) forKey:@"type"];

        
        
        [TTWNetworkManager publicAdvertismentWithUrl:urlStr params:dic success:^(id  _Nullable response) {
            
            if ([response[@"code"] integerValue] == 1) {
                [subscriber sendNext:@"1"];
                [subscriber sendCompleted];
            }else{
                [TTWHUD showCustomMsg:kLocalizedString(@"发布失败")];
            }

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
    return _publicSignal;
}

//获取支付方式
- (RACSignal *)payWaySignal
{
//    @weakify(self);
    _payWaySignal= [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        NSString * urlStr = @"coin/getPayWayApp";
        [TTWNetworkManager publicAdvertismentWithUrl:urlStr params:nil success:^(id  _Nullable response) {
            
            NSDictionary *dicTemp = [NSDictionary yy_modelDictionaryWithClass:[MGAdPayWayModel class] json:response[response_data]];

            [subscriber sendNext:dicTemp];
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
    return _payWaySignal;
}
//获取某个币种所用数量
- (RACSignal *)getCionNumberSignal
{
    //    @weakify(self);
    _getCionNumberSignal= [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        NSString * urlStr = @"advertising/userFiatFundsInfo";
        NSMutableDictionary * dic =[NSMutableDictionary new];
        [dic setValue:self.tradeCode forKey:@"tradeCode"];
        [TTWNetworkManager getCoinNumberWithUrl:urlStr params:dic success:^(id  _Nullable response) {
            
            [subscriber sendNext:response[response_data][@"availableBalance"]];
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
    return _getCionNumberSignal;
}
//获取国际行情价
- (RACSignal *)getPriceSignal
{
    //    @weakify(self);
    _getPriceSignal= [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        NSString * urlStr = @"quotes/international";
        NSMutableDictionary * dic =[NSMutableDictionary new];
        [dic setValue:@[self.tradeCode] forKey:@"symbols"];
        [TTWNetworkManager getCoinNumberWithUrl:urlStr params:dic success:^(id  _Nullable response) {
            NSArray *array = response[response_data];
            if (array && array.count > 0) {
                MGInternationalPriceModel *model = [MGInternationalPriceModel yy_modelWithDictionary:array[0]];
                model.close = [model.close keepDecimal:2];
                [subscriber sendNext:model];
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
    return _getPriceSignal;
}

- (RACSignal *)getForMerChartSignal
{
    _getForMerChartSignal= [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        NSString * urlStr = @"coin/getForMerchart";

        [TTWNetworkManager getCoinNumberWithUrl:urlStr params:nil success:^(id  _Nullable response) {
            
            [subscriber sendNext:response];
            [subscriber sendCompleted];
            
        } failure:^(id  _Nullable response) {
            NSError *error = [NSError errorWithDomain:@"" code:1 userInfo:response];
            [subscriber sendError:error];
            [subscriber sendCompleted];
        } reqError:^(NSError * _Nullable error) {
            [subscriber sendCompleted];
            
        }];
        
        // 在信号量作废时，取消网络请求
        return [RACDisposable disposableWithBlock:^{
            [TTWNetworkHandler cancelRequestWithURL:urlStr];
        }];
    }];
    return _getForMerChartSignal;
}




@end
