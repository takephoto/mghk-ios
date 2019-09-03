//
//  FiatadvertisingPublishVM.h
//  MGCEX
//
//  Created by Joblee on 2018/6/2.
//  Copyright © 2018年 MGCion. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, PublicationType) {
    PublicationMarketPriceType = 1,// 市价
    PublicationLimitedPriceType // 限价
};

@interface FiatadvertisingPublishVM : BaseViewModel
//买卖方式
@property (nonatomic, strong) NSString *buysell;
//交易代码
@property (nonatomic, strong) NSString *tradeCode;
//支持支付方式
@property (nonatomic, strong) NSString *payVal;
//价格
@property (nonatomic, strong) NSString *priceVal;
//数量
@property (nonatomic, strong) NSString *salesVal;
//最低数量
@property (nonatomic, strong) NSString *lowVal;
//最高数量
@property (nonatomic, strong) NSString *hightVal;
//广告类型 市价 1 限价2
@property (nonatomic, assign) PublicationType type;

@property (nonatomic, assign) MGMerchantsApplyStatus applyStatus;

@property (nonatomic, strong) NSString *summary;


///发布信号
@property (nonatomic, copy) RACSignal *publicSignal;
///获取支持的支付方式信号
@property (nonatomic, copy) RACSignal *payWaySignal;
///获取某个币种可用数量（法币账户）
@property (nonatomic, copy) RACSignal *getCionNumberSignal;
///获取国际行情价
@property (nonatomic, copy) RACSignal *getPriceSignal;
// 获取商家申请信息
@property (nonatomic, copy) RACSignal *getForMerChartSignal;



@end
