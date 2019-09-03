// MGC
//
// FrontPhotographVM.m
// MGCEX
//
// Created by MGC on 2018/5/21.
// Copyright © 2018年 MGCion. All rights reserved.
//
// @ description <#描述#> 

#import "FrontPhotographVM.h"
#import "TTWUploadParam.h"

@implementation FrontPhotographVM


//上传单张图片
- (RACSignal *)upImageSignal
{
    
    @weakify(self);
    _upImageSignal= [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        @strongify(self);
        
        NSString * urlStr = @"upload/uploadImgBase64";
        NSMutableDictionary * dic =[NSMutableDictionary new];
        [dic setValue:self.image forKey:@"imageFile"];
     
        [TTWNetworkManager uploadPicturesImageWithUrl:urlStr params:dic success:^(id  _Nullable response) {
            
           UpImageModel * model = [UpImageModel yy_modelWithJSON:response[response_data]];
            
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
    
    return _upImageSignal;
}

@end
