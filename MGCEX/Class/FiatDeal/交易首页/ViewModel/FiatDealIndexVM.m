// MGC
//
// FiatDealIndexVM.m
// MGCEX
//
// Created by MGC on 2018/6/1.
// Copyright © 2018年 MGCion. All rights reserved.
//
// @ description <#描述#> 

#import "FiatDealIndexVM.h"
@interface FiatDealIndexVM()
@property (nonatomic, strong) NSMutableArray * dataSource;
@end

@implementation FiatDealIndexVM

- (RACCommand *)refreshCommand
{
    @weakify(self);
    if (!_refreshCommand) {
        _refreshCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
            @strongify(self);
            self.isRefresh = [input boolValue];
            self.currentPage = self.isRefresh ? 1 : self.currentPage;
            return self.recordSignal;
        }];
    }
    return _refreshCommand;
}


- (RACSignal *)recordSignal
{
    @weakify(self);
    _recordSignal= [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        @strongify(self);
        
        NSString * urlStr = @"advertising/list";
        NSMutableDictionary * dic =[NSMutableDictionary new];
        [dic setObject:s_number(self.buysell) forKey:@"buysell"];
        [dic setValue:self.advertisingOrderId forKey:@"advertisingOrderId"];
        [dic setValue:self.tradeCode forKey:@"tradeCode"];
        if(self.merchartType){
          [dic setValue:s_number(self.merchartType) forKey:@"merchartType"];
        }
        if(self.payVal){
           [dic setValue:s_number(self.payVal) forKey:@"payVal"];
        }
        if(self.orderStatus){
           [dic setValue:s_number(self.orderStatus) forKey:@"orderStatus"];
        }
        if(self.frozenStatus){
           [dic setValue:s_number(self.frozenStatus) forKey:@"frozenStatus"];
        }
        if(self.showCurrentUsers){
           [dic setValue:s_number(self.showCurrentUsers) forKey:@"showCurrentUsers"];
        }
        if(self.amountMin){
           [dic setValue:self.amountMin  forKey:@"amountMin"];
        }
        if(self.amountMax){
           [dic setValue:self.amountMax forKey:@"amountMax"];
        }
        

        
        [dic setValue:[NSNumber numberWithInteger:self.currentPage] forKey:@"page"];
        [dic setObject:number_PageSize forKey:@"size"];
        
        [TTWNetworkManager getFiatDealHomepageWithUrl:urlStr params:dic success:^(id  _Nullable response) {
          
            FiatDealBuyOrSellModelList * model =[FiatDealBuyOrSellModelList yy_modelWithJSON:response[response_data]];
            
            for (FiatDealBuyOrSellmodels * models in model.list) {
                [self.dataSource addObject:models];
            }
           
            self.hasMoreData = !(self.currentPage >= [model.totalPage integerValue]/PageSize);
            
            if (self.isRefresh) {// 下拉刷新
                self.dataSource = (NSMutableArray *)model.list;
            } else {
                // 上拉加载更多
                [self.dataSource addObjectsFromArray:model.list];
                
            }
            
            [subscriber sendNext:self.dataSource];
            [subscriber sendCompleted];
            self.currentPage++;
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
    
    return _recordSignal;
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
            self.currentPage++;
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

//获取国际行情价格
-(RACSignal *)markPriceSignal{
    @weakify(self);
    _markPriceSignal= [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        @strongify(self);
        
        NSString * urlStr = @"quotes/international";
        NSMutableDictionary * dic =[NSMutableDictionary new];

        [dic setValue:kStringIsEmpty(self.tradeCode)?@"":@[self.tradeCode, @"KBC"] forKey:@"symbols"];
        
        [TTWNetworkManager getInternationalMarketPriceWithUrl:urlStr params:dic success:^(id  _Nullable response) {
            NSArray * arr = response[response_data];
            NSString * orderId;
            if(arr.count>0){
               orderId = arr[0][@"close"];
            }else{
                orderId = @"0";
            }
            
            [subscriber sendNext: orderId];
            [subscriber sendCompleted];
            self.currentPage++;
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
    
    return _markPriceSignal;
    
}

- (NSMutableArray *)dataSource
{
    if (!_dataSource) {
        _dataSource = [[NSMutableArray alloc]init];
    }
    return _dataSource;
}
@end
