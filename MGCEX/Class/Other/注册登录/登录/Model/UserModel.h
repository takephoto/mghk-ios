// MGC
//
// userModel.h
// MGCEX
//
// Created by MGC on 2018/5/21.
// Copyright © 2018年 MGCion. All rights reserved.
//
// @ description <#描述#> 

#import <Foundation/Foundation.h>
#import "TWSerializeModel.h"
#import "EnumMacro.h"

@interface UserModel : NSObject<NSCoding>

#pragma mark - 网络数据
/**币币*/
@property (nonatomic,copy) NSString *coin2CoinFunds;
/**邮箱*/
@property (nonatomic,copy) NSString *email;
/**法币*/
@property (nonatomic,copy) NSString *fiatFunds;
/**邮箱已注册*/
@property (nonatomic,copy) NSString *isemail;
/**是否谷歌认证，不能开关*/
@property (nonatomic,copy) NSString *isgoogle;
/**是否开启谷歌二次验证*/
@property (nonatomic,copy) NSString *google;
/**是否身份认证过*/
@property (nonatomic, copy) NSString *isidentity;
/**是否手机认证*/
@property (nonatomic, copy) NSString *isphone;
/**手机号*/
@property (nonatomic, copy) NSString *phone;
/**用户ID*/
@property (nonatomic, copy) NSString *userId;
/**用户token*/
@property (nonatomic, copy) NSString *token;
/**是否开启资金*/
@property (nonatomic, copy) NSString *issetacc;
/**目前没用*/
@property (nonatomic, copy) NSString *setacc;
/**当前账号*/
@property (nonatomic, copy) NSString *userName;
/**是否商家：1是，2不是*/
@property (nonatomic, assign) NSInteger isMerchants;
/**商家申请状态*/
@property (nonatomic, assign) MGMerchantsApplyStatus isApplyForMerchart;
/**审核不过原因*/
@property (nonatomic, strong) NSString *summary;
/**我的邀请码*/
@property (nonatomic, strong) NSString *myInviteCode;

@end
