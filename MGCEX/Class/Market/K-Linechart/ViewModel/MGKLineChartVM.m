//
//  MGKLineChartVM.m
//  MGCEX
//
//  Created by Joblee on 2018/6/7.
//  Copyright © 2018年 MGCion. All rights reserved.
//

#import "MGKLineChartVM.h"
#import "MGKLineChartModel.h"
#import "MGKLinechartRecordModel.h"
#import "MGKLinechartCoinInfoModel.h"

@implementation MGKLineChartVM
- (RACSignal *)kLineDataSignal
{
    _kLineDataSignal = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {

        NSDate* date = [NSDate dateWithTimeIntervalSinceNow:0];
        NSInteger to = [date timeIntervalSince1970];
        NSInteger from = to - [self.resolution integerValue]*60;
        NSMutableDictionary * params =[NSMutableDictionary new];
        [params setValue:[NSString stringWithFormat:@"%@:%@",self.market,self.symbols] forKey:kParamKlineSymbol];
        [params setValue:[NSString stringWithFormat:@"%d",from] forKey:kParamKlineFrom];//开始时间
        [params setValue:[NSString stringWithFormat:@"%d",to] forKey:kParamKlineTo];//结束时间(当前)
        [params setValue:self.resolution forKey:kParamKlineResolution];
        [TTWNetworkHandler requestWithUrl:kUrlKline requestMethod:RequestByGet params:params isShowHUD:YES success:^(id response) {
            
            NSMutableArray *dateTempArr = response[@"t"];
            NSMutableArray *openTempArr = response[@"o"];
            NSMutableArray *heighTempArr = response[@"h"];
            NSMutableArray *lowTempArr = response[@"l"];
            NSMutableArray *closeTempArr = response[@"c"];
            NSMutableArray *volmeTempArr = response[@"v"];

            NSInteger count = dateTempArr.count;
            NSMutableArray *dataArr = [NSMutableArray new];
            for (int i=0; i<count; i++) {
                NSMutableArray *arrayTemp = [NSMutableArray new];
  
                [arrayTemp addObject:[NSString stringWithFormat:@"%@000",dateTempArr[i]]];
                [arrayTemp addObject:openTempArr[i]];
                [arrayTemp addObject:heighTempArr[i]];
                [arrayTemp addObject:lowTempArr[i]];
                [arrayTemp addObject:closeTempArr[i]];
                [arrayTemp addObject:volmeTempArr[i]];
                
                [dataArr addObject:arrayTemp];
            }
            [subscriber sendNext:dataArr];
            [subscriber sendCompleted];
        } fail:^(NSError *error) {
            [subscriber sendCompleted];
        }];
        // 在信号量作废时，取消网络请求
        return [RACDisposable disposableWithBlock:^{
            [TTWNetworkHandler cancelRequestWithURL:kUrlKline];
        }];
        
        
    }];
    
    return _kLineDataSignal;
}


- (RACSignal *)getDealRecordSignal
{
    _getDealRecordSignal = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        NSMutableDictionary * params =[NSMutableDictionary new];
        [params setValue:self.symbols forKey:kParamKlineSymbol];
        [params setValue:self.market forKey:kParamKlineMarket];
        [TTWNetworkHandler requestWithUrl:kUrlKlineRecord requestMethod:RequestByPost params:params isShowHUD:NO success:^(id response) {
            NSArray *dataSourc =[NSArray  yy_modelArrayWithClass:[MGKLinechartRecordModel class] json:response[response_data]];
            [subscriber sendNext:dataSourc];
            [subscriber sendCompleted];
        } fail:^(NSError *error) {
            [subscriber sendCompleted];
        }];
        // 在信号量作废时，取消网络请求
        return [RACDisposable disposableWithBlock:^{
            [TTWNetworkHandler cancelRequestWithURL:kUrlKlineRecord];
        }];
        
        
    }];
    
    return _getDealRecordSignal;
}


- (RACSignal *)getCoinInfoSignal
{
    _getCoinInfoSignal = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        NSMutableDictionary * params =[NSMutableDictionary new];
        [params setValue:self.symbols forKey:kParamKlineSymbol];
        [params setValue:self.market forKey:kParamKlineMarket];
        
        [TTWNetworkManager getCoinInfoWithUrl:kUrlKlineCoinInfo params:params success:^(id  _Nullable response) {
            MGKLinechartCoinInfoModel *model =[MGKLinechartCoinInfoModel  yy_modelWithJSON:response[response_data]];
            [subscriber sendNext:model];
            [subscriber sendCompleted];
        } failure:^(id  _Nullable response) {
            [subscriber sendCompleted];
        } reqError:^(NSError * _Nullable error) {
             [subscriber sendError:error];
        }];
        
        // 在信号量作废时，取消网络请求
        return [RACDisposable disposableWithBlock:^{
            [TTWNetworkHandler cancelRequestWithURL:kUrlKlineCoinInfo];
        }];
        
        
    }];
    
    return _getCoinInfoSignal;
}


@end
