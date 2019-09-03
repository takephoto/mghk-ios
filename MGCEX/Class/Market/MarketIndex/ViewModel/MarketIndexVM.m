//
//  MarketIndexVM.m
//  MGCEX
//
//  Created by Joblee on 2018/6/4.
//  Copyright © 2018年 MGCion. All rights reserved.
//

#import "MarketIndexVM.h"
#import "MGMarketIndexModel.h"
#import "MGMarketIndexRealTimeModel.h"
#import "OptionalModel.h"


///市场
#define kMarketKey @"AMDD"
//币种
#define kCoinTypeKey @"AUC"

@interface MarketIndexVM()
@property (nonatomic, strong) NSDictionary *tradeKVDic;

@end
@implementation MarketIndexVM
- (RACCommand *)refreshCommand
{
    @weakify(self);
    if (!_refreshCommand) {
        _refreshCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
            @strongify(self);
            self.isRefresh = [input boolValue];
            return self.getListSignal;
        }];
    }
    return _refreshCommand;
}


- (RACSignal *)getListSignal
{
    @weakify(self);
    _getListSignal = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        @strongify(self);
        
        NSString * urlStr = @"currencybase/getcurrencylList";
        NSMutableDictionary * dic =[NSMutableDictionary new];
        
        [TTWNetworkManager getFiatDealHomepageWithUrl:urlStr params:dic success:^(id  _Nullable response) {
            [subscriber sendNext:response[response_data]];
            [subscriber sendCompleted];
        } failure:^(id  _Nullable response){
            [subscriber sendNext:nil];
            [subscriber sendCompleted];
        } reqError:^(NSError * _Nullable error) {
            [subscriber sendNext:nil];
            [subscriber sendCompleted];
        }];
        // 在信号量作废时，取消网络请求
        return [RACDisposable disposableWithBlock:^{
            [TTWNetworkHandler cancelRequestWithURL:urlStr];
        }];
        
        
    }];
    
    return _getListSignal;
}

#pragma mark -- 获取普通实时行情
- (RACSignal *)getRealtimeDataSignal
{
    _getRealtimeDataSignal = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        NSMutableArray *tradeKV = [NSMutableArray new];
//        self.coinTypeArr = @[@[@"BTC",@"ETH"],@[@"KBC"]];
//        self.Symbols = @"KBC";
        for (NSArray *array in self.coinTypeArr ) {
            for (NSString *coinType in array) {
                [tradeKV addObject:string(self.Symbols, string(@":", coinType))];
            }
        }
        NSString * urlStr = @"quotes/surface";
        NSMutableDictionary * dic =[NSMutableDictionary new];
        [dic setValue:tradeKV forKey:@"transPares"];

        [TTWNetworkManager getQuotationsWithUrl:urlStr params:dic success:^(id  _Nullable response) {
            if ([response[response_status] integerValue] == NetStatusSuccess) {
                NSArray * dataArr =[NSArray yy_modelArrayWithClass:[MGMarketIndexRealTimeModel class] json:response[response_data]];
                NSMutableArray *arrayTemp = [NSMutableArray new];
                //主区
                NSMutableArray *mainArray = [NSMutableArray new];
                //创新区
                NSMutableArray *innovateArray = [NSMutableArray new];
                for (MGMarketIndexRealTimeModel *model in dataArr) {
                    //判断属于主区还是创新区
                    if (self.coinTypeArr.count == 1) {
                        [mainArray addObject:model];
                    }else if (self.coinTypeArr.count == 2){
                        NSArray *mainTempArr = self.coinTypeArr[0];
                        NSArray *innovateTempArr = self.coinTypeArr[1];
                        if ([mainTempArr containsObject:model.symbol]) {
                            [mainArray addObject:model];
                        }else if([innovateTempArr containsObject:model.symbol]){
                            [innovateArray addObject:model];
                        }
                    }
                }
                [self checkIsContainOptional:mainArray];
                [self checkIsContainOptional:innovateArray];
                [arrayTemp addObject:mainArray];
                [arrayTemp addObject:innovateArray];
                [subscriber sendNext:arrayTemp];
            }
            
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
    
    return _getRealtimeDataSignal;
}
#pragma mark -- 获取自选实时行情
- (RACSignal *)getOptionalRealtimeDataSignal
{
    _getOptionalRealtimeDataSignal = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        
        NSString * urlStr = @"quotes/surface";
        NSMutableDictionary * dic =[NSMutableDictionary new];
        [dic setValue:self.optionalCoinTypeArr forKey:@"transPares"];
        
        [TTWNetworkManager getQuotationsWithUrl:urlStr params:dic success:^(id  _Nullable response) {
            if ([response[response_status] integerValue] == NetStatusSuccess) {
                NSArray * dataArr =[NSArray yy_modelArrayWithClass:[MGMarketIndexRealTimeModel class] json:response[response_data]];
                NSMutableArray *arrayTemp = [NSMutableArray new];
                //主区
                NSMutableArray *mainArray = [NSMutableArray new];
                //创新区
                NSMutableArray *innovateArray = [NSMutableArray new];
                //全部标明为自选
                for (MGMarketIndexRealTimeModel *model in dataArr) {
                    model.isOptional = YES;
                    if ([self checkWhetherArea:model] == 1) {
                        [mainArray addObject:model];
                    }else{
                        [innovateArray addObject:model];
                    }
                }
                [arrayTemp addObject:mainArray];
                [arrayTemp addObject:innovateArray];
                [subscriber sendNext:arrayTemp];
            }
            
            [subscriber sendCompleted];
        } failure:^(id  _Nullable response){
            NSMutableArray *arrayTemp = [NSMutableArray new];
            //主区
            NSMutableArray *mainArray = [NSMutableArray new];
            //创新区
            NSMutableArray *innovateArray = [NSMutableArray new];
            [arrayTemp addObject:mainArray];
            [arrayTemp addObject:innovateArray];
            [subscriber sendNext:arrayTemp];
            [subscriber sendCompleted];
        } reqError:^(NSError * _Nullable error) {
            NSMutableArray *arrayTemp = [NSMutableArray new];
            //主区
            NSMutableArray *mainArray = [NSMutableArray new];
            //创新区
            NSMutableArray *innovateArray = [NSMutableArray new];
            [arrayTemp addObject:mainArray];
            [arrayTemp addObject:innovateArray];
            [subscriber sendNext:arrayTemp];
            [subscriber sendCompleted];
        }];
        
        
        // 在信号量作废时，取消网络请求
        return [RACDisposable disposableWithBlock:^{
            [TTWNetworkHandler cancelRequestWithURL:urlStr];
        }];
        
        
    }];
    
    return _getOptionalRealtimeDataSignal;
}
#pragma mark -- 自选实时行情检查是主区还是创新区
- (BOOL)checkWhetherArea:(MGMarketIndexRealTimeModel *)model
{
    if (self.optionalCoinTypeArr.count < 1) {
        return NO;
    }
    
    for (NSString *tradePair in self.optionalCoinTypeAreaArr[0]) {//主区
        NSArray *tradePairArr = [tradePair componentsSeparatedByString:@":"];
        NSString *market = tradePairArr.firstObject;
        NSString *symbol = tradePairArr.lastObject;
        if (([symbol isEqualToString:model.symbol] && [market isEqualToString:model.market])) {
            return YES;
        }
    }
    return NO;
}
#pragma mark -- 检查是否包含自选实时行情，如果包含则标明是自选
- (void)checkIsContainOptional:(NSMutableArray *)dataSource
{
    if (kArrayIsEmpty(self.optionalCoinTypeArr)) {
        return;
    }
    for (MGMarketIndexRealTimeModel *model in dataSource) {
        BOOL isContain = NO;
        for (NSString *tradePairArrStr in self.optionalCoinTypeArr) {
            NSArray *tradePairArr = [tradePairArrStr componentsSeparatedByString:@":"];
            NSString *market = tradePairArr.firstObject;
            NSString *symbol = tradePairArr.lastObject;
            if (([symbol isEqualToString:model.symbol] && [market isEqualToString:model.market])) {
                isContain = YES;
                break;
            }
        }
        if (isContain) {
            model.isOptional = YES;
        }
        
    }
    
}

- (RACSignal *)getHomePageRealtimeDataSignal
{
    _getHomePageRealtimeDataSignal = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {

        NSString * urlStr = @"quotes/surface";
        NSMutableDictionary * dic =[NSMutableDictionary new];
        [dic setValue:self.coinTypeArr forKey:@"transPares"];
        
        [TTWNetworkManager getQuotationsWithUrl:urlStr params:dic success:^(id  _Nullable response) {
            if ([response[response_status] integerValue] == NetStatusSuccess) {
                NSArray * dataArr =[NSArray yy_modelArrayWithClass:[MGMarketIndexRealTimeModel class] json:response[response_data]];
                //按降序排序
                NSArray *result = [dataArr sortedArrayUsingComparator:^NSComparisonResult(MGMarketIndexRealTimeModel *_Nonnull obj1, MGMarketIndexRealTimeModel * _Nonnull obj2) {
                    return [obj2.gains compare:obj1.gains]; //降序
                }];
                //负数按升序排序
                //正
                NSMutableArray *arr1 = [NSMutableArray new];
                //负
                NSMutableArray *arr2 = [NSMutableArray new];
                for (MGMarketIndexRealTimeModel *model in result) {
                    if ([model.gains hasPrefix: @"-"]) {
                        [arr2 addObject:model];
                    }else{
                        [arr1 addObject:model];
                    }
                }
                NSArray *result2 = [arr2 sortedArrayUsingComparator:^NSComparisonResult(MGMarketIndexRealTimeModel *_Nonnull obj1, MGMarketIndexRealTimeModel * _Nonnull obj2) {
                    return [obj1.gains compare:obj2.gains]; //降序
                }];
                NSMutableArray *result3 = [NSMutableArray new];
                for (id model in arr1) {
                    [result3 addObject:model];
                }
                for (id model in result2) {
                    [result3 addObject:model];
                }
                [subscriber sendNext:result3];
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
    
    return _getHomePageRealtimeDataSignal;
}
//获取盘面详情
- (RACSignal *)quotesSignal
{
    @weakify(self);
    _quotesSignal= [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        @strongify(self);
        NSString * urlStr = @"quotes/surface";
        NSMutableDictionary * dic =[NSMutableDictionary new];
        [dic setValue:self.optinalTradePair forKey:@"transPares"];
        
        [TTWNetworkManager getQuotationsWithUrl:urlStr params:dic success:^(id  _Nullable response) {
            
            NSArray *dataArr = [NSArray yy_modelArrayWithClass:[MGMarketIndexRealTimeModel class] json:response[response_data]];
            [self checkIsContainOptional:dataArr];
            [subscriber sendNext:dataArr];
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
    
    return _quotesSignal;
}
- (NSMutableArray *)coinTypeArr
{
    if (!_coinTypeArr) {
        _coinTypeArr = [NSMutableArray new];
    }
    return _coinTypeArr;
}

@end











