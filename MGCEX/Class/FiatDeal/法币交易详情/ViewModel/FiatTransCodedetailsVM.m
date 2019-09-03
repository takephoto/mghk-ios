// MGC
//
// FiatTransCodedetailsVM.m
// MGCEX
//
// Created by MGC on 2018/6/3.
// Copyright  2018年 MGCion. All rights reserved.
//
// @ description <#描述#>

#import "FiatTransCodedetailsVM.h"
@interface FiatTransCodedetailsVM()

@property (nonatomic, strong) NSMutableArray * dataSource;
@end


@implementation FiatTransCodedetailsVM

- (RACCommand *)refreshCommand
{
    @weakify(self);
    if (!_refreshCommand) {
        _refreshCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
            @strongify(self);
            self.isRefresh = [input boolValue];
            self.currentPage = self.isRefresh ? 1 : self.currentPage;
            return self.recordDetailSignal;
        }];
    }
    return _refreshCommand;
}


- (RACSignal *)recordDetailSignal
{
    @weakify(self);
    _recordDetailSignal= [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        @strongify(self);
        
        NSString * urlStr = @"fiatDealTradeOrder/getFiatDealTradeOrder";
        NSMutableDictionary * dic =[NSMutableDictionary new];
        [dic setValue:self.tradeOrderId forKey:@"tradeOrderId"];
        [dic setValue:[NSNumber numberWithInteger:self.currentPage] forKey:@"page"];
        [dic setValue:[NSNumber numberWithInteger:PageSize] forKey:@"size"];
        
        [TTWNetworkManager getFiatCodeDetaiWithUrl:urlStr params:dic success:^(id  _Nullable response) {
            
            FiatTradingModel * model =[FiatTradingModel yy_modelWithJSON:response[response_data]];
            
            [subscriber sendNext:model];
            [subscriber sendCompleted];
            self.currentPage++;
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
    
    return _recordDetailSignal;
}

//标记为已付款 已收款
- (RACSignal *)markedPaySignal
{
    @weakify(self);
    _markedPaySignal= [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        @strongify(self);
        
        NSString * urlStr = @"fiatDealTradeOrder/updateFiatDealTradeOrder";
        NSMutableDictionary * dic =[NSMutableDictionary new];
        [dic setValue:self.tradeOrderId forKey:@"tradeOrderId"];
        
        [TTWNetworkManager markedPaymentReceivedWithUrl:urlStr params:dic success:^(id  _Nullable response) {
            
            [subscriber sendNext:@"1"];
            [subscriber sendCompleted];
            self.currentPage++;
        } failure:^(id  _Nullable response){
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [subscriber sendNext:@"1"];
                [subscriber sendCompleted];
            });
        } reqError:^(NSError * _Nullable error) {
            [subscriber sendCompleted];
        }];
        
        
        // 在信号量作废时，取消网络请求
        return [RACDisposable disposableWithBlock:^{
            [TTWNetworkHandler cancelRequestWithURL:urlStr];
        }];
        
        
    }];
    
    return _markedPaySignal;
}


//取消交易
- (RACSignal *)cancelTransSignal
{
    @weakify(self);
    _cancelTransSignal= [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        @strongify(self);
        
        NSString * urlStr = @"fiatDealTradeOrder/closeFiatTradeOrder";
        NSMutableDictionary * dic =[NSMutableDictionary new];
        [dic setValue:self.tradeOrderId forKey:@"tradeOrderId"];
        
        [TTWNetworkManager markedPaymentReceivedWithUrl:urlStr params:dic success:^(id  _Nullable response) {
            
            [subscriber sendNext:@"1"];
            [subscriber sendCompleted];
            self.currentPage++;
        } failure:^(id  _Nullable response){
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [subscriber sendNext:@"1"];
                [subscriber sendCompleted];
            });
        } reqError:^(NSError * _Nullable error) {
            [subscriber sendCompleted];
        }];
        
        
        // 在信号量作废时，取消网络请求
        return [RACDisposable disposableWithBlock:^{
            [TTWNetworkHandler cancelRequestWithURL:urlStr];
        }];
        
        
    }];
    
    return _cancelTransSignal;
}


- (NSMutableArray *)dataSource
{
    if (!_dataSource) {
        _dataSource = [[NSMutableArray alloc]init];
    }
    return _dataSource;
}

@end
