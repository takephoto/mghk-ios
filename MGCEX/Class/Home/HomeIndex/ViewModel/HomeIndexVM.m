// MGC
//
// HomeIndexVM.m
// MGCEX
//
// Created by MGC on 2018/7/6.
// Copyright © 2018年 MGCion. All rights reserved.
//
// @ description <#描述#> 

#import "HomeIndexVM.h"
@interface HomeIndexVM()
@property (nonatomic, strong) NSMutableArray * anmArray;
@end

@implementation HomeIndexVM
///获取公告列表
- (RACSignal *)getAnmentSignal
{
    
    @weakify(self);
    _getAnmentSignal= [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        @strongify(self);
        NSString * urlStr = @"noticemage/getnoticeall";
        NSMutableDictionary * dic =[NSMutableDictionary new];
        [dic setValue:self.num forKey:@"numbaer"];
        [dic setValue:self.h5 forKey:@"h5"];
        
        [TTWNetworkManager getAnnouncementListWithUrl:urlStr params:dic success:^(id  _Nullable response) {
            NSArray *array = response[response_data];
            if (array && array.count > 0) {
                self.anmArray = [NSMutableArray arrayWithArray:[NSArray yy_modelArrayWithClass:[HomeIndexModel class] json:response[response_data]]];
               
            }
            [subscriber sendNext:self.anmArray];
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
    return _getAnmentSignal;
}

-(NSMutableArray *)anmArray{
    if(!_anmArray){
        _anmArray = [NSMutableArray new];
    }
    return _anmArray;
}
@end
