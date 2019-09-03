// MGC
//
// CoinDealIndexVM.m
// MGCEX
//
// Created by MGC on 2018/6/9.
// Copyright © 2018年 MGCion. All rights reserved.
//
// @ description <#描述#> 

#import "CoinDealIndexVM.h"


@interface CoinDealIndexVM()
@property (nonatomic, strong) NSMutableArray * currencyArray;
@property (nonatomic, strong) NSMutableArray * buySellArray;
@property (nonatomic, strong) NSMutableArray * buyArray;
@property (nonatomic, strong) NSMutableArray * sellArray;
@property (nonatomic, assign) float CcaleWodth;
@end

@implementation CoinDealIndexVM

//获取盘面详情
- (RACSignal *)quotesSignal
{
    @weakify(self);
    _quotesSignal= [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        @strongify(self);
        NSString * urlStr = @"quotes/surface";
        NSMutableDictionary * dic =[NSMutableDictionary new];
        [dic setValue:self.transPares forKey:@"transPares"];
        
        [TTWNetworkManager getQuotationsWithUrl:urlStr params:dic success:^(id  _Nullable response) {
            
            NSArray * arr = response[response_data];
            if(arr.count>0){
                QuotesModel *model = [QuotesModel yy_modelWithJSON:arr[0]];
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
    
    return _quotesSignal;
}

//获取可用币种数量
- (RACSignal *)getCoinRemainSignal
{
    @weakify(self);
    _getCoinRemainSignal= [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        @strongify(self);
        NSString * urlStr = @"coin/getCoinFundsInfo";
        NSMutableDictionary * dic =[NSMutableDictionary new];
        [dic setValue:self.remainCoin forKey:@"tradeCode"];
        
        [TTWNetworkManager getQuotationsWithUrl:urlStr params:dic success:^(id  _Nullable response) {
            
            CoinRemainModel *model = [CoinRemainModel yy_modelWithJSON:response[response_data]];
            
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
    
    return _getCoinRemainSignal;
}



//买卖五档
- (RACSignal *)unsettledGearSignal
{
    @weakify(self);
    _unsettledGearSignal= [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        @strongify(self);
        NSString * urlStr = @"quotes/unsettledGear";
        
        NSMutableDictionary * dic =[NSMutableDictionary new];
        [dic setValue:self.tradeCode forKey:@"tradeCode"];
        [dic setValue:s_number(@"5") forKey:@"gearNum"];
        
        
        [TTWNetworkManager getQuotationsWithUrl:urlStr params:dic success:^(id  _Nullable response) {
            
            [self.buySellArray removeAllObjects];
            [self.buyArray removeAllObjects];
            [self.sellArray removeAllObjects];
            NSString *market = [self.tradeCode componentsSeparatedByString:@":"].firstObject;
            NSString *symbol = [self.tradeCode componentsSeparatedByString:@":"].lastObject;
            NSArray * sellArr = response[response_data][@"sell"];
            NSArray * buyArr = response[response_data][@"buy"];
            
            float maxValue = 0.0;
            float minValue = 0.0;
            
            for (NSDictionary * dic in sellArr) {
                UnsettledGearModel * sellModel = [[UnsettledGearModel alloc]init];
                sellModel.buySell = 2;
                sellModel.price = [NSString stringWithFormat:@"%.16f",[dic[@"price"] doubleValue]];
                sellModel.value = [NSString stringWithFormat:@"%.16f",[dic[@"val"] doubleValue]];
                sellModel.market = market;
                sellModel.symbol = symbol;
                sellModel.limitNumber = 8;//默认8位小数
                maxValue = (maxValue>[sellModel.value doubleValue])? maxValue : [sellModel.value floatValue];
                minValue = (minValue<[sellModel.value doubleValue])? minValue : [sellModel.value floatValue];
                
                [self.sellArray addObject:sellModel];
            }
            //排序
            [self.sellArray sortUsingComparator:^NSComparisonResult(UnsettledGearModel *obj1, UnsettledGearModel *obj2) {
                
                return [@([obj1.price floatValue]) compare:@([obj2.price floatValue])];
            }];
            
            
            for (NSDictionary * dic in buyArr) {
                UnsettledGearModel * buyModel = [[UnsettledGearModel alloc]init];
                buyModel.buySell = 1;
                buyModel.price = [NSString stringWithFormat:@"%.16f",[dic[@"price"] doubleValue]];
                buyModel.value = [NSString stringWithFormat:@"%.16f",[dic[@"val"] doubleValue]];
                buyModel.market = market;
                buyModel.symbol = symbol;
                buyModel.limitNumber = 8;//默认8位小数
                maxValue = (maxValue>[buyModel.value doubleValue])? maxValue : [buyModel.value floatValue];
                minValue = (minValue<[buyModel.value doubleValue])? minValue : [buyModel.value floatValue];
                [self.buyArray addObject:buyModel];
            }
            //排序
            [self.buyArray sortUsingComparator:^NSComparisonResult(UnsettledGearModel *obj1, UnsettledGearModel *obj2) {
                return -[@([obj1.price floatValue]) compare:@([obj2.price floatValue])];
            }];
            
            
            for (UnsettledGearModel * sellModel in self.sellArray) {
                sellModel.scaleValue = [sellModel.value floatValue]/maxValue * 0.7;
                
            }
            
            for (UnsettledGearModel * buyModel in self.buyArray) {
                buyModel.scaleValue = [buyModel.value floatValue]/maxValue *0.7;
                
            }
                        
            NSMutableDictionary * mutabDic = [NSMutableDictionary new];
            [mutabDic setValue:self.buyArray forKey:@"buyArr"];
            [mutabDic setValue:self.sellArray forKey:@"sellArr"];
            
            [subscriber sendNext:mutabDic];
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
    
    return _unsettledGearSignal;
}

//委托下单
- (RACSignal *)addEntrustmentSignal
{
    @weakify(self);
    _addEntrustmentSignal= [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        @strongify(self);
        NSString * urlStr = @"c2c/addEntrustment";
        
        NSMutableDictionary * dic =[NSMutableDictionary new];
        [dic setValue:s_number(self.type) forKey:@"type"];
        [dic setValue:s_number(self.buysell) forKey:@"buysell"];
        [dic setValue:self.market forKey:@"market"];
        [dic setValue:self.symbol forKey:@"symbol"];
        [dic setValue:self.price forKey:@"price"];
        [dic setValue:self.volume forKey:@"volume"];
        [dic setValue:self.amount forKey:@"amount"];
        
        [TTWNetworkManager coinDealBuySellOrderWithUrl:urlStr params:dic success:^(id  _Nullable response) {
            
            
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
    
    return _addEntrustmentSignal;
}


//撤单
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

//获取交易队列
- (RACSignal *)getcurrencysSignal
{
    @weakify(self);
    _getcurrencysSignal= [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        @strongify(self);
        NSString * urlStr = @"currencybase/getcurrencysubchail";
        
        NSMutableDictionary * dic =[NSMutableDictionary new];
        
        [TTWNetworkManager getcurrencylListWithUrl:urlStr params:dic success:^(id  _Nullable response) {
            
            [self.currencyArray removeAllObjects];
            
            NSArray * dataArr = response[response_data];
            
            for (int i=0;i<dataArr.count;i++) {
                
                NSDictionary * dic = dataArr[i];
                
                CoinDealMarkModel * model = [[CoinDealMarkModel alloc]init];
                model.markTitle = dic[@"main"][0];
                
                NSArray * arr = dic[@"privates"];
                
                for (int j=0;j<arr.count ;j++) {
                    
                    CoinDealPrivateModel * primodel = [[CoinDealPrivateModel alloc]init];
                    
                    primodel.title = arr[j];
                    
                    [model.privateArray addObject:primodel];
                }
                
                [self.currencyArray addObject:model];
                
            }
            
            
            
            
            
            [subscriber sendNext:self.currencyArray];
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
    
    return _getcurrencysSignal;
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
        
        //用在币币交易获取交易对
        if(self.markStr){
            [dic setValue:self.markStr forKey:@"market"];
        }
        if(self.trocodeStr){
            [dic setValue:self.trocodeStr forKey:@"symbol"];
        }
        
        [dic setObject:[NSNumber numberWithInteger:self.currentPage] forKey:@"page"];
        [dic setObject:[NSNumber numberWithInteger:PageSize] forKey:@"size"];
        
        [TTWNetworkManager getCoinDealweituoOrderWithUrl:urlStr params:dic success:^(id  _Nullable response) {
            
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


//获取我的自选
- (RACSignal *)getMyChoiceSignal
{
    @weakify(self);
    _getMyChoiceSignal= [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        @strongify(self);
        NSString * urlStr = @"c2c/selfSelected";
        
        NSMutableDictionary * dic =[NSMutableDictionary new];
        [TTWNetworkManager getCoinDealMyChoiceListWithUrl:urlStr params:dic success:^(id  _Nullable response) {
            
            NSArray * arr = [NSArray yy_modelArrayWithClass:[OptionalModel class] json:response[response_data]];
            
            [subscriber sendNext:arr];
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
    
    return _getMyChoiceSignal;
}

//添加我的自选
- (RACSignal *)addMyChoiceSignal
{
    @weakify(self);
    _addMyChoiceSignal= [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        @strongify(self);
        
        NSString * urlStr = @"c2c/addSelfSelected";
        NSMutableDictionary * dic =[NSMutableDictionary new];
        [dic setValue:self.transPare forKey:@"transPare"];
        if (kUserIsLogin) {
            [TTWNetworkManager addOrCancelMyChoiceListWithUrl:urlStr params:dic success:^(id  _Nullable response) {
                
                [subscriber sendNext:@"1"];
                [subscriber sendCompleted];
                
            } failure:^(id  _Nullable response){
                [subscriber sendCompleted];
            } reqError:^(NSError * _Nullable error) {
                [subscriber sendCompleted];
            }];
        }else{
            //验证是否需要登录
            [TWAppTool permissionsValidationHandleFinish:^{
            }];
        }
        
        // 在信号量作废时，取消网络请求
        return [RACDisposable disposableWithBlock:^{
            [TTWNetworkHandler cancelRequestWithURL:urlStr];
        }];
        
    }];
    
    return _addMyChoiceSignal;
}


//取消我的自选
- (RACSignal *)cancelMyChoiceSignal
{
    @weakify(self);
    _cancelMyChoiceSignal= [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        @strongify(self);
        NSString * urlStr = @"c2c/delSelfSelected";
        
        NSMutableDictionary * dic =[NSMutableDictionary new];
        [dic setValue:self.transPare forKey:@"transPare"];
        if (kUserIsLogin) {
            [TTWNetworkManager addOrCancelMyChoiceListWithUrl:urlStr params:dic success:^(id  _Nullable response) {
                
                [subscriber sendNext:@"1"];
                [subscriber sendCompleted];
                
            } failure:^(id  _Nullable response){
                [subscriber sendCompleted];
            } reqError:^(NSError * _Nullable error) {
                [subscriber sendCompleted];
            }];
        }else{
            //验证是否需要登录
            [TWAppTool permissionsValidationHandleFinish:^{
            }];
        }
        
        
        // 在信号量作废时，取消网络请求
        return [RACDisposable disposableWithBlock:^{
            [TTWNetworkHandler cancelRequestWithURL:urlStr];
        }];
    }];
    
    return _cancelMyChoiceSignal;
}

//获取最小交易量
- (RACSignal *)minVolumeSignal
{
    @weakify(self);
    _minVolumeSignal= [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        @strongify(self);
        NSString * urlStr = @"c2c/getMinVolume";
        
        NSMutableDictionary * dic =[NSMutableDictionary new];
        
        [TTWNetworkManager getMinVolumeWithUrl:urlStr params:dic success:^(id  _Nullable response) {
            
            NSArray * arr = [NSArray yy_modelArrayWithClass:[MinVolumeModel class] json:response[response_data]];
            
            [subscriber sendNext:arr];
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
    
    return _minVolumeSignal;
}


//获取最小变动单位
- (RACSignal *)minWaveSignal
{
    @weakify(self);
    _minWaveSignal= [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        @strongify(self);
        NSString * urlStr = @"c2c/getMinWave";
        
        NSMutableDictionary * dic =[NSMutableDictionary new];
        
        
        [TTWNetworkManager getMinWaveWithUrl:urlStr params:dic success:^(id  _Nullable response) {
            
            NSArray * arr = [NSArray yy_modelArrayWithClass:[MinWaveModel class] json:response[response_data]];
            
            [subscriber sendNext:arr];
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
    
    return _minWaveSignal;
}



-(NSMutableArray *)currencyArray{
    if(!_currencyArray){
        _currencyArray = [NSMutableArray new];
    }
    return _currencyArray;
}

-(NSMutableArray *)buySellArray{
    if(!_buySellArray){
        _buySellArray = [NSMutableArray new];
    }
    return _buySellArray;
}

-(NSMutableArray *)buyArray{
    if(!_buyArray){
        _buyArray = [NSMutableArray new];
    }
    return _buyArray;
}

-(NSMutableArray *)sellArray{
    if(!_sellArray){
        _sellArray = [NSMutableArray new];
    }
    return _sellArray;
}

@end
