//
//  PlaceOrderVM.m
//  MGCEX
//
//  Created by HFW on 2018/7/13.
//  Copyright © 2018年 MGCion. All rights reserved.
//

#import "PlaceOrderVM.h"
#import "PlaceOrderItemModel.h"

@implementation PlaceOrderVM

- (RACSignal *)getDataSignal{
    
    if (!_getDataSignal) {
        
        _getDataSignal = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
            
            NSMutableArray *arr = [NSMutableArray array];
            
            PlaceOrderItemModel *model1 = [PlaceOrderItemModel new];
            model1.title = self.isBuy ? kLocalizedString(@"买入价格") : kLocalizedString(@"卖出价格");
            model1.unit = @"CNY";
            model1.enable = NO;
            model1.content = self.model.unitPrice;
            [arr addObject:model1];
            
            PlaceOrderItemModel *model2 = [PlaceOrderItemModel new];
            model2.title = kLocalizedString(@"交易限额");
            model2.unit = @"CNY";
            model2.enable = NO;
            model2.content = [NSString stringWithFormat:@"%@~%@", self.model.limitMin, self.model.limitMax];
            [arr addObject:model2];
            
            PlaceOrderItemModel *model3 = [PlaceOrderItemModel new];
            model3.title = kLocalizedString(@"兑换金额");
            model3.unit = @"CNY";
            model3.enable = YES;
            [arr addObject:model3];
            
            PlaceOrderItemModel *model4 = [PlaceOrderItemModel new];
            model4.title = self.isBuy ? kLocalizedString(@"买入数量") : kLocalizedString(@"卖出数量");
            model4.unit = self.model.currency;
            model4.enable = YES;
            [arr addObject:model4];
            
            [subscriber sendNext:arr];
            [subscriber sendCompleted];
            
            return [RACDisposable disposableWithBlock:^{
                
            }];
        }];
    }
    return _getDataSignal;
}


//下单
- (RACSignal *)orderSignal{
    @weakify(self);
    _orderSignal= [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        @strongify(self);
        
        NSString * urlStr = @"fiatDealTradeOrder/add";
        NSMutableDictionary * dic =[NSMutableDictionary new];
        [dic setObject:s_number(self.payBuySell) forKey:@"buysell"];
        [dic setValue:self.orderAdvertisingOrderId forKey:@"advertisingOrderId"];
        [dic setValue:self.orderTradeAmount forKey:@"tradeAmount"];
        [dic setValue:self.orderTradeQuantity forKey:@"tradeQuantity"];
        [dic setValue:self.orderTradeCode forKey:@"tradeCode"];
        [dic setValue:self.adUserId forKey:@"adUserId"];
        
        [TTWNetworkManager gotoBuyOrSellOrderWithUrl:urlStr params:dic success:^(id  _Nullable response) {
            NSString * orderId = response[response_data][@"orderId"];
            [subscriber sendNext: orderId];
            [subscriber sendCompleted];
        }  failure:^(id  _Nullable response){
            [subscriber sendCompleted];
        } reqError:^(NSError * _Nullable error) {
            [subscriber sendCompleted];
        }];
        
        
        // 在信号量作废时，取消网络请求
        return [RACDisposable disposableWithBlock:^{
            [TTWNetworkHandler cancelRequestWithURL:urlStr];
        }];
        
        
    }];
    
    return _orderSignal;
}


@end
