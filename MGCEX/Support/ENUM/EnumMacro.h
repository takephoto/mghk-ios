// MGC
//
// EnumMacro.h
// IOSFrameWork
//
// Created by MGC on 2018/3/17.
// Copyright © 2018年 MGCion. All rights reserved.
//
// @ description <#描述#> 

#ifndef EnumMacro_h
#define EnumMacro_h
///支付渠道
typedef NS_ENUM(NSInteger, MGPayWay) {
    ViaBankCard = 1,///银行卡支付
    ViaAliPay,///支付宝支付
    ViaWeChat///微信支付
};
///行情币种
typedef NS_ENUM(NSInteger,MGMarketCoinType){
     MarketKBC = 0,
     MarketMGC,
     MarketBTC,
     MarketETH,
     MarketCustom,
};
///网络请求状态
typedef NS_ENUM(NSInteger, NetStatus) {
    NetStatusSuccess = 1, /// 请求成功
    NetStatusFailed = 0, /// 请求失败
    NetStatusTokenInvalid = 208, /// token失效
};
///商家认证状态
typedef NS_ENUM(NSInteger,MGMerchantsApplyStatus){
    MGMerchantsNotApply = 0,///未申请
    MGMerchantsApplying = 1,///申请中
    MGMerchantsApplySuccess = 2,//申请通过
    MGMerchantsApplyFailed = 3,//申请失败
};

#endif /* EnumMacro_h */
