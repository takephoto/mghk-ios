//
//  AdvertisingPublicViewModel.h
//  MGCEX
//
//  Created by Joblee on 2018/6/3.
//  Copyright © 2018年 MGCion. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AdvertisingPublicViewModel : NSObject
@property (nonatomic, strong) NSString *frozen;
@property (nonatomic, strong) NSString *accountName;
@property (nonatomic, strong) NSString *singlePrice;
@property (nonatomic, strong) NSString *number;
@property (nonatomic, strong) NSString *limitPrice;
@property (nonatomic, strong) NSString *payWay;
///币种
@property (nonatomic, strong) NSString *symbols;
//买卖方式
@property (nonatomic, assign) BOOL isBuy;
@end
