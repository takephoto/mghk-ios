//
//  MGAdPayWayModel.h
//  MGCEX
//
//  Created by Joblee on 2018/6/3.
//  Copyright © 2018年 MGCion. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MGAdPayWayModel : NSObject

//收款人
@property (nonatomic, strong) NSString * payeeName;
//支付类型
@property (nonatomic, strong) NSString * payType;
//银行
@property (nonatomic, strong) NSString * bankName;
//支行
@property (nonatomic, strong) NSString * bankBrachName;
//收款账号
@property (nonatomic, strong) NSString * payeeAccount;
//摘要
@property (nonatomic, strong) NSString * summary;
@end
