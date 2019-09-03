//
//  MGTraderVerificationVM.m
//  MGCEX
//
//  Created by 汪跃山 on 2018/6/26.
//  Copyright © 2018年 MGCion. All rights reserved.
//

#import "MGTraderVerificationVM.h"
#import "MGTraderVerificationModel.h"

@implementation MGTraderVerificationVM


- (id)initWithSectionTitleText:(NSString *)sectionTitleText applyStatus:(MGMerchantsApplyStatus)applyStatus
{
    if (self = [super init]) {
        self.sectionTitleText = sectionTitleText;
        self.applyStatus = applyStatus;
    }
    return self;
}

#pragma mark -- Public Menthod

- (NSString *)navTitleText
{
    return kLocalizedString(@"商家认证");
}


- (NSString *)protocolText
{
    return kLocalizedString(@"我已阅读并同意《商家认证条款》");
}

- (NSString *)applyButtonText
{
    return kLocalizedString(@"立即申请");
}

- (NSString *)footerViewInputText
{
    return kLocalizedString(@"请输入商家名称");
}

- (NSString *)footerViewSubTitle1Text
{
    return kLocalizedString(@"便于用户快速识别你的名称");
}

- (NSString *)footerViewSubTitle2Text
{
    return kLocalizedString(@"字数要求：8个字以内；例如：BTC专卖店");
}

- (NSMutableArray *)cellVMs
{
    if (!_cellVMs) {
        
        _cellVMs = [NSMutableArray array];
        
        MGTraderVerificationCellVM *cellVM1 = [[MGTraderVerificationCellVM alloc] initWithBgImage:IMAGE(@"icon_sjrz_vip_bg") iconImage:IMAGE(@"icon_sjrz_vip") titleText:kLocalizedString(@"VIP服务") subTitle1Text:kLocalizedString(@"平台优先解决并跟进已认证商家的问题") subTitle2Text:kLocalizedString(@"协助商家安全、高效、快速完成交易")];
        
        MGTraderVerificationCellVM *cellVM2 = [[MGTraderVerificationCellVM alloc] initWithBgImage:IMAGE(@"icon_sjrz_icon_bg") iconImage:IMAGE(@"icon_sjrz_icon") titleText:kLocalizedString(@"尊贵图标") subTitle1Text:kLocalizedString(@"认证通过的商家可获尊贵图标") subTitle2Text:kLocalizedString(@"明显提升商家可信度及成交率")];
        
        MGTraderVerificationCellVM *cellVM3 = [[MGTraderVerificationCellVM alloc] initWithBgImage:IMAGE(@"icon_sjrz_limit_bg") iconImage:IMAGE(@"icon_sjrz_limit") titleText:kLocalizedString(@"额度开放") subTitle1Text:kLocalizedString(@"商家自由设置交易额度，金额无上限") subTitle2Text:kLocalizedString(@"买卖更高效，更快捷")];
        
        [_cellVMs addObject:cellVM1];
        [_cellVMs addObject:cellVM2];
        [_cellVMs addObject:cellVM3];
    }
    return _cellVMs;
}

//获取信息
- (RACSignal *)getFormerChartWaySignal
{
    @weakify(self);
    _getFormerChartWaySignal= [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        @strongify(self);
        NSString * urlStr = @"coin/getformerchartway";
        NSMutableDictionary * dic = [NSMutableDictionary new];
        [dic setObject:@"KBC" forKey:@"tradeCode"];
        
        [TTWNetworkManager getUserInfomationWithUrl:urlStr params:dic success:^(id  _Nullable response) {
            
            MGTraderVerificationModel *model = [MGTraderVerificationModel yy_modelWithJSON:response[response_data]];
            if (self.applyStatus == MGMerchantsApplySuccess) {
                self.cell0TitleText = kLocalizedString(@"您已成为MEIB.IO的尊贵商家");
            }else {
               self.cell0TitleText = [NSString stringWithFormat:@"%@ %ld %@ %@",kLocalizedString(@"需持有"),model.number,model.tradeCode,kLocalizedString(@"币方可进行商家申请")];
            }
    
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
    
    return _getFormerChartWaySignal;
}

//发送请求
- (RACSignal *)applySignal
{
    @weakify(self);
    _applySignal= [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        @strongify(self);
        NSString * urlStr = @"coin/forMerchart";
        NSMutableDictionary * dic = [NSMutableDictionary new];
        NSString *nikeName = self.nikeName ? self.nikeName : @"";
        [dic setObject:nikeName  forKey:@"nikeName"];
        [dic setObject:@(3)  forKey:@"device"];
        
        [TTWNetworkManager getUserInfomationWithUrl:urlStr params:dic success:^(id  _Nullable response) {
            
            
            [subscriber sendNext:@(1)];
            [subscriber sendCompleted];
            
        } failure:^(id  _Nullable response){
            [TTWHUD showCustomMsg:response[@"msg"]];
            [subscriber sendCompleted];
        } reqError:^(NSError * _Nullable error) {
            [subscriber sendCompleted];
        }];
        
        // 在信号量作废时，取消网络请求
        return [RACDisposable disposableWithBlock:^{
            [TTWNetworkHandler cancelRequestWithURL:urlStr];
        }];
    }];
    
    return _applySignal;
}

- (RACSignal *)getForMerChartSignal
{
    _getForMerChartSignal= [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        NSString * urlStr = @"coin/getForMerchart";
        
        [TTWNetworkManager getCoinNumberWithUrl:urlStr params:nil success:^(id  _Nullable response) {
            
            [subscriber sendNext:response];
            [subscriber sendCompleted];
            
        } failure:^(id  _Nullable response) {
            NSError *error = [NSError errorWithDomain:@"" code:1 userInfo:response];
            [subscriber sendError:error];
            [subscriber sendCompleted];
        } reqError:^(NSError * _Nullable error) {
            [subscriber sendCompleted];
            
        }];
        
        // 在信号量作废时，取消网络请求
        return [RACDisposable disposableWithBlock:^{
            [TTWNetworkHandler cancelRequestWithURL:urlStr];
        }];
    }];
    return _getForMerChartSignal;
}

@end
