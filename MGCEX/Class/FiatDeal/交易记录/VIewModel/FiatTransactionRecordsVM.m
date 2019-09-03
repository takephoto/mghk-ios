// MGC
//
// FiatTransactionRecordsVM.m
// MGCEX
//
// Created by MGC on 2018/6/1.
// Copyright © 2018年 MGCion. All rights reserved.
//
// @ description <#描述#> 

#import "FiatTransactionRecordsVM.h"
#import "FiatTransactionRecordsModel.h"

@interface FiatTransactionRecordsVM()

@property (nonatomic, strong) NSMutableArray * adsSource;//广告
@property (nonatomic, strong) NSMutableArray * dataSource;//法币交易
@property (nonatomic, strong) NSMutableArray * currencySource;//所有币种
@end

@implementation FiatTransactionRecordsVM

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

//获取法币交易记录
- (RACSignal *)recordSignal
{
    @weakify(self);
    _recordSignal= [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        @strongify(self);
        
        NSString * urlStr = @"fiatDealTradeOrder/getFiatDealTradeOrderList";
        NSMutableDictionary * dic =[NSMutableDictionary new];
        [dic setValue:self.tradeCode forKey:@"tradeCode"];
        [dic setValue:self.orderTime forKey:@"orderTime"];
        if(self.orderStatus){
          [dic setValue:s_number(self.orderStatus)  forKey:@"orderStatus"];
        }
        
        [dic setValue:self.tradeOrderId forKey:@"tradeOrderId"];
        [dic setObject:s_number(self.buysell) forKey:@"buysell"];
        
        [dic setObject:[NSNumber numberWithInteger:self.currentPage] forKey:@"page"];
        [dic setObject:[NSNumber numberWithInteger:PageSize] forKey:@"size"];
        
        [TTWNetworkManager getFiatTransactionListWithUrl:urlStr params:dic success:^(id  _Nullable response) {
            
            FiatTRecordsModels * model = [FiatTRecordsModels yy_modelWithJSON:response[response_data]];
            
            self.hasMoreData = !(self.currentPage >= [model.totalRecord integerValue]/PageSize);
            
            if (self.isRefresh) {// 下拉刷新
                self.dataSource = (NSMutableArray *)model.listreslt;
            } else {
                // 上拉加载更多
                [self.dataSource addObjectsFromArray:model.listreslt];
                
            }
            
            [subscriber sendNext:self.dataSource];
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
    
    return _recordSignal;
}

//提币记录刷新命令
- (RACCommand *)takeOutCoinCommand
{
    @weakify(self);
    if (!_takeOutCoinCommand) {
        _takeOutCoinCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
            @strongify(self);
            self.isRefresh = [input boolValue];
            self.currentPage = self.isRefresh ? 1 : self.currentPage;
            return self.takeOutCoinSignal;
        }];
    }
    return _takeOutCoinCommand;
}

//提币记录
- (RACSignal *)takeOutCoinSignal
{
    @weakify(self);
    _takeOutCoinSignal= [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        @strongify(self);
        
        NSString * urlStr = @"coin/drawCoinList";
        NSMutableDictionary * dic =[NSMutableDictionary new];
   
        [dic setValue:self.orderStatus forKey:@"status"];
        [dic setValue:self.tradeCode forKey:@"tradeCode"];
        
        [dic setObject:[NSNumber numberWithInteger:self.currentPage] forKey:@"page"];
        [dic setObject:[NSNumber numberWithInteger:PageSize] forKey:@"size"];
        
        [TTWNetworkManager fillingCurrencyCurrencyWithUrl:urlStr params:dic success:^(id  _Nullable response) {
            
            TakeCoinRecordModel * model = [TakeCoinRecordModel yy_modelWithJSON:response[response_data]];
            
            self.hasMoreData = !(self.currentPage >= [model.totalRecord integerValue]/PageSize);
            
            if (self.isRefresh) {// 下拉刷新
                self.dataSource = (NSMutableArray *)model.drawList;
            } else {
                // 上拉加载更多
                [self.dataSource addObjectsFromArray:model.drawList];
                
            }
            
            [subscriber sendNext:self.dataSource];
            [subscriber sendCompleted];
            self.currentPage++;
        }failure:^(id  _Nullable response){
            [subscriber sendCompleted];
        } reqError:^(NSError * _Nullable error) {
            [subscriber sendCompleted];
        }];
        
        
        // 在信号量作废时，取消网络请求
        return [RACDisposable disposableWithBlock:^{
            [TTWNetworkHandler cancelRequestWithURL:urlStr];
        }];
        
        
    }];
    
    return _takeOutCoinSignal;
}


//充币记录刷新命令
- (RACCommand *)fillCoinCommand
{
    @weakify(self);
    if (!_fillCoinCommand) {
        _fillCoinCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
            @strongify(self);
            self.isRefresh = [input boolValue];
            self.currentPage = self.isRefresh ? 1 : self.currentPage;
            return self.fillCoinSignal;
        }];
    }
    return _fillCoinCommand;
}

//充币记录
- (RACSignal *)fillCoinSignal
{
    @weakify(self);
    _fillCoinSignal= [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        @strongify(self);
        
        NSString * urlStr = @"usertransaction/querytransactionlist";
        NSMutableDictionary * dic =[NSMutableDictionary new];
        [dic setValue:self.orderStatus forKey:@"status"];
        [dic setValue:self.tradeCode forKey:@"tradeCode"];
        
        [dic setObject:[NSNumber numberWithInteger:self.currentPage] forKey:@"page"];
        [dic setObject:[NSNumber numberWithInteger:PageSize] forKey:@"size"];
        
        [TTWNetworkManager fillingCurrencyCurrencyWithUrl:urlStr params:dic success:^(id  _Nullable response) {
            
            FillCoinRecodeModel * model = [FillCoinRecodeModel yy_modelWithJSON:response[response_data]];
            
            self.hasMoreData = !(self.currentPage >= [model.totalRecord integerValue]/PageSize);
            
            if (self.isRefresh) {// 下拉刷新
                self.dataSource = (NSMutableArray *)model.listreslt;
            } else {
                // 上拉加载更多
                [self.dataSource addObjectsFromArray:model.listreslt];
            }
            [subscriber sendNext:self.dataSource];
            [subscriber sendCompleted];
            self.currentPage++;
        }failure:^(id  _Nullable response){
            [subscriber sendCompleted];
        } reqError:^(NSError * _Nullable error) {
            [subscriber sendCompleted];
        }];
        
        
        // 在信号量作废时，取消网络请求
        return [RACDisposable disposableWithBlock:^{
            [TTWNetworkHandler cancelRequestWithURL:urlStr];
        }];
        
        
    }];
    
    return _fillCoinSignal;
}



- (RACCommand *)adsRefreshCommand
{
    @weakify(self);
    if (!_adsRefreshCommand) {
        _adsRefreshCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
            @strongify(self);
            self.isRefresh = [input boolValue];
            self.currentPage = self.isRefresh ? 1 : self.currentPage;
            return self.publicAdsSignal;
        }];
    }
    return _adsRefreshCommand;
}
//发布广告列表
- (RACSignal *)publicAdsSignal
{
    @weakify(self);
    _publicAdsSignal= [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        @strongify(self);
        
        NSString * urlStr = @"advertising/list";
        NSMutableDictionary * dic =[NSMutableDictionary new];
        
        [dic setValue:s_number(self.buysell) forKey:@"buysell"];
        [dic setValue:nil forKey:@"advertisingOrderId"];
        [dic setValue:self.tradeCode forKey:@"tradeCode"];
        [dic setValue:nil forKey:@"merchartType"];
        [dic setValue:nil forKey:@"payVal"];
        if([self.orderStatus integerValue]>0){
            [dic setValue:s_number(self.orderStatus) forKey:@"orderStatus"];
        }else{
            [dic setValue:nil forKey:@"orderStatus"];
        }
        
        [dic setValue:nil forKey:@"frozenStatus"];
        [dic setValue:s_number(self.showCurrentUsers) forKey:@"showCurrentUsers"];
        [dic setValue:nil forKey:@"amountMin"];
        [dic setValue:nil forKey:@"amountMax"];
        
        
        [dic setValue:[NSNumber numberWithInteger:self.currentPage] forKey:@"page"];
        [dic setValue:[NSNumber numberWithInteger:PageSize] forKey:@"size"];
        
        [TTWNetworkManager getFiatDealHomepageWithUrl:urlStr params:dic success:^(id  _Nullable response) {
            
            FiatDealBuyOrSellModelList * model =[FiatDealBuyOrSellModelList yy_modelWithJSON:response[response_data]];
            
            for (FiatDealBuyOrSellmodels * models in model.list) {
                [self.adsSource addObject:models];
            }
            
            self.hasMoreData = !(self.currentPage >= [model.totalPage integerValue]/PageSize);
            
            if (self.isRefresh) {// 下拉刷新
                self.adsSource = (NSMutableArray *)model.list;
            } else {
                // 上拉加载更多
                [self.adsSource addObjectsFromArray:model.list];
                
            }
            
            [subscriber sendNext:self.adsSource];
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
    
    return _publicAdsSignal;
}

//获取bi币交易委托记录命令
- (RACCommand *)entrustRefreshCommand
{
    @weakify(self);
    if (!_entrustRefreshCommand) {
        _entrustRefreshCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
            @strongify(self);
            self.isRefresh = [input boolValue];
            self.currentPage = self.isRefresh ? 1 : self.currentPage;
            return self.myEntrustmentsSignal;
        }];
    }
    return _entrustRefreshCommand;
}

//获取币币交易委托
- (RACSignal *)myEntrustmentsSignal
{
    @weakify(self);
    _myEntrustmentsSignal= [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        @strongify(self);
        
        NSString * urlStr = @"c2c/myEntrustments";
        NSMutableDictionary * dic =[NSMutableDictionary new];
        //用在交易记录里面
        if(self.tradeCode){
           [dic setValue:self.tradeCode forKey:@"symbol"];
        }

        [dic setObject:[NSNumber numberWithInteger:self.currentPage] forKey:@"page"];
        [dic setObject:[NSNumber numberWithInteger:PageSize] forKey:@"size"];
        
        [TTWNetworkManager getFiatEntrustListWithUrl:urlStr params:dic success:^(id  _Nullable response) {
            
            NSArray * arr = [NSArray yy_modelArrayWithClass:[CoinEntrustModelList class] json:response[response_data]];
            
            
            [subscriber sendNext:arr];
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
    
    return _myEntrustmentsSignal;
}



//获取历币币史记录命令
- (RACCommand *)entrHistoryRefreshCommand
{
    @weakify(self);
    if (!_entrHistoryRefreshCommand) {
        _entrHistoryRefreshCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
            @strongify(self);
            self.isRefresh = [input boolValue];
            self.currentPage = self.isRefresh ? 1 : self.currentPage;
            return self.myEntrHistorySignal;
        }];
    }
    return _entrHistoryRefreshCommand;
}

//获取币币交易历史
- (RACSignal *)myEntrHistorySignal
{
    @weakify(self);
    _myEntrHistorySignal= [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        @strongify(self);
        //获取所有币币交易历史不需要传交易对，获取某个交易对的历史记录需要传交易对
        NSString * urlStr = @"c2c/historyEntrustments";
        NSMutableDictionary * dic =[NSMutableDictionary new];
        
        [dic setValue:self.tradeCode forKey:@"symbol"];
        
        [dic setObject:[NSNumber numberWithInteger:self.currentPage] forKey:@"page"];
        [dic setObject:[NSNumber numberWithInteger:PageSize] forKey:@"size"];
        
        [TTWNetworkManager getFiatEntrustListWithUrl:urlStr params:dic success:^(id  _Nullable response) {
            
            NSArray * arr = [NSArray yy_modelArrayWithClass:[CoinEntrusHistoryModelList class] json:response[response_data]];
            if (self.isRefresh) {// 下拉刷新
                [self.dataSource removeAllObjects];
            }
            [self.dataSource addObjectsFromArray:arr];
            [subscriber sendNext:self.dataSource];
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
    
    return _myEntrHistorySignal;
}
///币币交易交易历史/joblee
- (RACCommand *)entrHistoryCommand
{
    @weakify(self);
    if (!_entrHistoryCommand) {
        _entrHistoryCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
            @strongify(self);
            self.isRefresh = [input boolValue];
            self.currentPage = self.isRefresh ? 1 : self.currentPage;
            return self.tradeRecordSignal;
        }];
    }
    return _entrHistoryCommand;
}
//获取币币交易历史
- (RACSignal *)tradeRecordSignal
{
    @weakify(self);
    _tradeRecordSignal= [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        @strongify(self);
        //获取所有币币交易历史不需要传交易对，获取某个交易对的历史记录需要传交易对
        NSString * urlStr = @"c2c/historyEntrustments";
        NSMutableDictionary * dic =[NSMutableDictionary new];
        [dic setValue:self.market forKey:@"market"];
        [dic setValue:self.tradeCode forKey:@"symbol"];
        [dic setObject:[NSNumber numberWithInteger:self.currentPage] forKey:@"page"];
        [dic setObject:[NSNumber numberWithInteger:PageSize] forKey:@"size"];
        
        [TTWNetworkManager getFiatEntrustListWithUrl:urlStr params:dic success:^(id  _Nullable response) {
            
            NSArray * arr = [NSArray yy_modelArrayWithClass:[CoinEntrustModelList class] json:response[response_data]];
            if (self.isRefresh) {// 下拉刷新
                [self.dataSource removeAllObjects];
            }
            [self.dataSource addObjectsFromArray:arr];
            [subscriber sendNext:self.dataSource];
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
    
    return _tradeRecordSignal;
}
//获取所有币种
- (RACSignal *)allCurrencySignal
{
    @weakify(self);
    _allCurrencySignal= [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        @strongify(self);
        NSString * urlStr = @"advertising/initCoinProperty";
        NSMutableDictionary * dic =[NSMutableDictionary new];
        [dic setValue:@"1" forKey:@"isVaild"];
        
        
        [TTWNetworkManager getAllcurrencyWithUrl:urlStr params:dic success:^(id  _Nullable response) {
            
            [self.currencySource removeAllObjects];
            NSArray * arr = response[response_data];
            for (NSDictionary * dic in arr) {
                AllCurrencyModels * model =[AllCurrencyModels yy_modelWithJSON:dic];
                [self.currencySource addObject:model];
            }
            
            [subscriber sendNext:self.currencySource];
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
    
    return _allCurrencySignal;
}


//广告撤单
- (RACSignal *)removeSignal
{
    @weakify(self);
    _removeSignal= [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        @strongify(self);
        NSString * urlStr = @"advertising/cancel";
        NSMutableDictionary * dic =[NSMutableDictionary new];
        [dic setValue:self.advertisingOrderId forKey:@"advertisingOrderId"];
        
        
        [TTWNetworkManager removeAdsOrdertWithUrl:urlStr params:dic success:^(id  _Nullable response) {
            
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
    
    return _removeSignal;
}



//币币委托撤单
- (RACSignal *)removrOrderSignal
{
    @weakify(self);
    _removrOrderSignal= [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        @strongify(self);
        NSString * urlStr = @"c2c/updateEntrustment";
        
        NSMutableDictionary * dic =[NSMutableDictionary new];
        [dic setValue:self.orderId forKey:@"id"];
        [dic setValue:s_number(@"5") forKey:@"status"];
        
        [TTWNetworkManager cancelCoinWeituoWithUrl:urlStr params:dic success:^(id  _Nullable response) {
            
            
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
    
    return _removrOrderSignal;
}

- (NSMutableArray *)dataSource
{
    if (!_dataSource) {
        _dataSource = [[NSMutableArray alloc]init];
    }
    return _dataSource;
}

-(NSMutableArray *)currencySource{
    if(!_currencySource){
        _currencySource = [NSMutableArray new];
    }
    return _currencySource;
}

-(NSMutableArray *)adsSource{
    if(!_adsSource){
        _adsSource = [NSMutableArray new];
    }
    return _adsSource;
}
@end
