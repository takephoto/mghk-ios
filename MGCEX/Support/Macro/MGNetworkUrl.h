//
//  MGNetworkUrl.h
//  MGCEX
//
//  Created by Joblee on 2018/6/7.
//  Copyright © 2018年 MGCion. All rights reserved.
//

#ifndef MGNetworkUrl_h
#define MGNetworkUrl_h

///k线图-----------------
#define kUrlKline @"quotes/history"
///商品名称或代码
#define kParamKlineSymbol @"symbol"
///开始时间,不含毫秒数
#define kParamKlineFrom @"from"
///结束时间
#define kParamKlineTo @"to"
///K线分辨率,1、5、15、30、60、D、2D等
#define kParamKlineResolution @"resolution"
///k线图，页面成交记录（指定交易对）-----------------
#define kUrlKlineRecord @"c2c/dealRecords"
///k线图，页面币种信息           -----------------
#define kUrlKlineCoinInfo @"c2c/getCoinInfoApp"
//市场
#define kParamKlineMarket @"market"
//币种
#define kParamKlineSymbol @"symbol"

///获取币种充值地址----------------
#define kGetRechargeUrl @"coin/getCoinAddress"
///提币-----------------
#define kWithdrawUrl @"coin/drawCoin"
///根据该用户的币种获取币币的详情信息----------------
#define ketCoinFundsInfoUrl @"coin/getCoinFundsInfo"
///币种
#define kTradeCode @"tradeCode"


#endif /* MGNetworkUrl_h */
