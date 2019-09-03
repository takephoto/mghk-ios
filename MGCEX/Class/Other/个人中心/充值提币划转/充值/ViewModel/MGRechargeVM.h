//
//  MGRechargeVM.h
//  MGCEX
//
//  Created by Joblee on 2018/6/9.
//  Copyright © 2018年 MGCion. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MGRechargeVM : NSObject
///获取充币地址
@property (nonatomic, copy) RACSignal *rechargeSignal;
///参数tradeCode":"ETH"
@property (nonatomic, copy) NSString *tradeCode;
@end
