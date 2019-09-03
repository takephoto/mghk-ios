//
//  MGComplainVM.m
//  MGCEX
//
//  Created by Joblee on 2018/6/4.
//  Copyright © 2018年 MGCion. All rights reserved.
//

#import "MGComplainVM.h"


@implementation MGComplainVM


- (RACSignal *)commitComplainSignal
{
    @weakify(self);
    _commitComplainSignal= [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        @strongify(self);
        NSString * urlStr = @"coin/setLawsuitRecord";
        NSMutableDictionary * dic =[NSMutableDictionary new];
        [dic setValue:self.fiatDealTradeOrderId forKey:@"fiatDealTradeOrderId"];
        [dic setValue:self.sellBuy forKey:@"sellBuy"];
        [dic setValue:self.bankName forKey:@"bankName"];
        [dic setValue:self.bankBrachName forKey:@"bankBrachName"];
        [dic setValue:self.payeeAccount forKey:@"payeeAccount"];
        [dic setValue:self.model.imgList forKey:@"payeeAccountUrl"];
        [dic setValue:self.summary forKey:@"summary"];
        [dic setValue:self.payType forKey:@"payType"];
        [dic setValue:self.payeeName forKey:@"payeeName"];
        [dic setValue:self.transactionNum forKey:@"transactionNum"];
        [dic setValue:self.evidenceAUrl forKey:@"evidenceAUrl"];
        
        [TTWNetworkManager commitComplainWithUrl:urlStr params:dic success:^(id  _Nullable response) {
            
            if ([response[@"code"] integerValue] == 1) {
                [subscriber sendNext:@"1"];
            }else{
                [TTWHUD showCustomMsg:kLocalizedString(@"提交")];
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
    return _commitComplainSignal;
}
//************************
//url = http://192.168.22.24:8021/api/coin/setLawsuitRecord
//参数 = {"summary":"时尚家居设计","bankName":"是啊我们","bankBrachName":"阿根廷的是","payeeAccount":"223444","payeeAccountUrl":["067a772e-9d13-43bf-a062-2a03c30ee99520180612154331.jpg","607d9a46-c7e1-469b-9259-edb5c447ea7020180612154331.jpg"],"fiatDealTradeOrderId":"1528786671531602658","evidenceAUrl":"","payType":"3","device":"3","transactionNum":"233445"}
//responseObject=={"msg":"参数格式错误","data":null,"code":201}
//************************
- (RACSignal *)uploadImagesSignal
{
    @weakify(self);
    _uploadImagesSignal= [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        @strongify(self);
        NSString * urlStr = @"upload/uploadImgMoreBase64";
        NSMutableDictionary * dic =[NSMutableDictionary new];
        [dic setValue:self.imageArr forKey:@"imageArr"];
        
        [TTWNetworkManager uploadPicturesWithUrl:urlStr params:dic success:^(id  _Nullable response) {
            if ([response[@"code"] integerValue] == 1) {
                MGComplainModel *model = [MGComplainModel yy_modelWithJSON:response[response_data]];
                self.model = model;
                [subscriber sendNext:model];
            }else{
                [TTWHUD showCustomMsg:kLocalizedString(@"提交")];
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
    return _uploadImagesSignal;
}

- (NSMutableArray *)imageArr
{
    if (!_imageArr) {
        _imageArr = [NSMutableArray new];
    }
    return _imageArr;
}







@end
