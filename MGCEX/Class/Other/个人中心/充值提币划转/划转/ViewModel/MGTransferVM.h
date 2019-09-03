//
//  MGTransferVM.h
//  MGCEX
//
//  Created by Joblee on 2018/6/8.
//  Copyright © 2018年 MGCion. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MGTransferVM : NSObject
///自己划转
@property (nonatomic, copy) RACSignal *transferSignal;
///交易代码
@property (nonatomic, strong) NSString *tradeCode;
///要转数量
@property (nonatomic, strong) NSString *availableBalance;
///区分法币和币币:法币转逼逼：uff 币币转法币：ucc
@property (nonatomic, strong) NSString *type;
///获取当前币种可用数量（币币账户）
@property (nonatomic, copy) RACSignal *getAvailableNumSignal;
@end
