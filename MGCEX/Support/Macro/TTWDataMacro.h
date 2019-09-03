// MGC
//
// TTWDataMacro.h
// kachi
//
// Created by MGC on 2017/12/28.
// Copyright © 2017年 qw. All rights reserved.
//
// @ description <#描述#> 

#ifndef TTWDataMacro_h
#define TTWDataMacro_h

#ifdef DEBUG
#define Countdown 5 //倒计时
#else
#define Countdown 60 //倒计时

#endif

#define Compression 0.1 //图片压缩比例

#define response_data @"data" //图片压缩比例
///请求状态
#define response_status @"code"
#define KFiatDealSectionHeight Adapted(48) //法币section高
#define isSuccess(response) [response[response_status] integerValue] == NetStatusSuccess
#define ShowError(response) [TTWHUD showCustomMsg:response[response_data]]
#define PageSize 5.0 //每一页数据
#define number_PageSize s_number(@"5")

///验证码输入字数限制
#define KVerificationNumber 6

///是否刷新操作
#define kIsRefreshY @"YES"
#define kIsRefreshN @"NO"

#define BackTimeOut 1*10 //后台多少时间开启二次验证--手势指纹或谷歌
//60*10
//国际化
#define kLocalizedString(key) NSLocalizedString(key, nil)

//当前版本
#define Current_Version @"1"

#endif /* TTWDataMacro_h */
