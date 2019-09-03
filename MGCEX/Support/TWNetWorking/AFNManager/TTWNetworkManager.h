// MGC
//
// TTWNetworkManager.h
// AFNNetworkingDemo
//
// Created by MGC on 2018/2/24.
// Copyright © 2018年 MGCion. All rights reserved.
//
// @ description <#描述#> 

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "TTWNetworkDefine.h"
#import "TTWUploadParam.h"

@interface TTWNetworkManager : NSObject

///////////////////测试////////////////////

+ (void)requestTestInfoWithSuccess:(TTWResponseSuccess)success failure:(MGResponseFailed)failure reqError:(TTWResponseError)reqError;

/**
*  图片上传
*/
+ (void)uploadWithUrl:(NSString *)url uploadParam:(TTWUploadParam *)uploadParam params:(NSDictionary *)params success:(TTWResponseSuccess)success failure:(TTWResponseError)failure;



/**
 *  文件下载
 */
+ (void)downFileWithUrl:(NSString *)url params:(NSDictionary *)params filePath:(NSString *)filePath success:(TTWResponseSuccess)success failure:(TTWResponseError)failure;


////////////////////////////////////正式开发接口///////////////////////////////

#pragma mark-- 发送手机验证码
+(void)phoneVerificationCodeWithUrl:(NSString *)url params:(NSDictionary *)params success:(TTWResponseSuccess)success failure:(MGResponseFailed)failure reqError:(TTWResponseError)reqError;

#pragma mark-- 注册手机或邮箱
+(void)RegisterPhoneOrMailWithUrl:(NSString *)url params:(NSDictionary *)params success:(TTWResponseSuccess)success failure:(MGResponseFailed)failure reqError:(TTWResponseError)reqError;

#pragma mark-- 登录
+(void)userLoginAccountWithUrl:(NSString *)url params:(NSDictionary *)params success:(TTWResponseSuccess)success failure:(MGResponseFailed)failure reqError:(TTWResponseError)reqError;

#pragma mark-- 重置／忘记密码
+(void)resetPasswordWithUrl:(NSString *)url params:(NSDictionary *)params success:(TTWResponseSuccess)success failure:(MGResponseFailed)failure reqError:(TTWResponseError)reqError;


#pragma mark --  身份证/护照最终提交认证
+ (void)theIdentityAuthenticationWithUrl:(NSString *)url params:(NSDictionary *)params success:(TTWResponseSuccess)success failure:(MGResponseFailed)failure reqError:(TTWResponseError)reqError;

#pragma mark --  手机号和邮箱认证
+ (void)phoneMailAuthenticationWithUrl:(NSString *)url params:(NSDictionary *)params success:(TTWResponseSuccess)success failure:(MGResponseFailed)failure reqError:(TTWResponseError)reqError;

#pragma mark --  获取用户信息
+ (void)getUserInfomationWithUrl:(NSString *)url params:(NSDictionary *)params success:(TTWResponseSuccess)success failure:(MGResponseFailed)failure reqError:(TTWResponseError)reqError;

#pragma mark --  二次验证
+ (void)secondaryValidationWithUrl:(NSString *)url params:(NSDictionary *)params success:(TTWResponseSuccess)success failure:(MGResponseFailed)failure reqError:(TTWResponseError)reqError;

#pragma mark --  用户登录校验
+ (void)logOntoCheckWithUrl:(NSString *)url params:(NSDictionary *)params success:(TTWResponseSuccess)success failure:(MGResponseFailed)failure reqError:(TTWResponseError)reqError;

#pragma mark --  设置里的更改密码
+ (void)changeLoginPasswordWithUrl:(NSString *)url params:(NSDictionary *)params success:(TTWResponseSuccess)success failure:(MGResponseFailed)failure reqError:(TTWResponseError)reqError;

#pragma mark --  获取谷歌Key
+ (void)getGoogleKeyWithUrl:(NSString *)url params:(NSDictionary *)params success:(TTWResponseSuccess)success failure:(MGResponseFailed)failure reqError:(TTWResponseError)reqError;

#pragma mark --  谷歌Key验证
+ (void)verifyGoogleKeyWithUrl:(NSString *)url params:(NSDictionary *)params success:(TTWResponseSuccess)success failure:(MGResponseFailed)failure reqError:(TTWResponseError)reqError;

#pragma mark --  开启关闭谷歌验证
+ (void)openCloseverifyGoogleKeyWithUrl:(NSString *)url params:(NSDictionary *)params success:(TTWResponseSuccess)success failure:(MGResponseFailed)failure reqError:(TTWResponseError)reqError;

#pragma mark --  验证登录密码是否正确
+ (void)verifyLoginPasswordWithUrl:(NSString *)url params:(NSDictionary *)params success:(TTWResponseSuccess)success failure:(MGResponseFailed)failure reqError:(TTWResponseError)reqError;

#pragma mark --  谷歌二次验证
+ (void)GoogleSecondverifyLoginWithUrl:(NSString *)url params:(NSDictionary *)params success:(TTWResponseSuccess)success failure:(MGResponseFailed)failure reqError:(TTWResponseError)reqError;

#pragma mark --  设置资金密码
+ (void)SettingMoneyPasswordWithUrl:(NSString *)url params:(NSDictionary *)params success:(TTWResponseSuccess)success failure:(MGResponseFailed)failure reqError:(TTWResponseError)reqError;

#pragma mark --  单张图片以参数形式上传
+ (void)uploadPicturesImageWithUrl:(NSString *)url params:(NSDictionary *)params success:(TTWResponseSuccess)success failure:(MGResponseFailed)failure reqError:(TTWResponseError)reqError;
#pragma mark --  多张张图片以参数形式上传
+ (void)uploadPicturesWithUrl:(NSString *)url params:(NSDictionary *)params success:(TTWResponseSuccess)success failure:(MGResponseFailed)failure reqError:(TTWResponseError)reqError;

#pragma mark --  设置绑定银行卡，支付宝，微信
+ (void)bindingBankCardZfbWxWithUrl:(NSString *)url params:(NSDictionary *)params success:(TTWResponseSuccess)success failure:(MGResponseFailed)failure reqError:(TTWResponseError)reqError;

#pragma mark --  获取绑定银行卡，支付宝，微信
+ (void)getBindingBankCardZfbWxWithUrl:(NSString *)url params:(NSDictionary *)params success:(TTWResponseSuccess)success failure:(MGResponseFailed)failure reqError:(TTWResponseError)reqError;

#pragma mark --  获取法币交易列表
+ (void)getFiatTransactionListWithUrl:(NSString *)url params:(NSDictionary *)params success:(TTWResponseSuccess)success failure:(MGResponseFailed)failure reqError:(TTWResponseError)reqError;

#pragma mark --  获取所有币种
+ (void)getAllcurrencyWithUrl:(NSString *)url params:(NSDictionary *)params success:(TTWResponseSuccess)success failure:(MGResponseFailed)failure reqError:(TTWResponseError)reqError;

#pragma mark --  获取法币交易首页数据
+ (void)getFiatDealHomepageWithUrl:(NSString *)url params:(NSDictionary *)params success:(TTWResponseSuccess)success failure:(MGResponseFailed)failure reqError:(TTWResponseError)reqError;

//#pragma mark --  获取自己发布的广告列表数据
//+ (void)getMyFiatDealHomepageWithUrl:(NSString *)url params:(NSDictionary *)params success:(TTWResponseSuccess)success failure:(TTWResponseError)failure;

#pragma mark-- 发布广告
+ (void)publicAdvertismentWithUrl:(NSString *)url params:(NSDictionary *)params success:(TTWResponseSuccess)success failure:(MGResponseFailed)failure reqError:(TTWResponseError)reqError;
#pragma mark-- 获取支付方式
+ (void)getPayWayWithUrl:(NSString *)url params:(NSDictionary *)params success:(TTWResponseSuccess)success failure:(MGResponseFailed)failure reqError:(TTWResponseError)reqError;
#pragma mark-- 获取某个币种可用数量
+ (void)getCoinNumberWithUrl:(NSString *)url params:(NSDictionary *)params success:(TTWResponseSuccess)success failure:(MGResponseFailed)failure reqError:(TTWResponseError)reqError;

#pragma mark-- 法币交易下单
+ (void)gotoBuyOrSellOrderWithUrl:(NSString *)url params:(NSDictionary *)params success:(TTWResponseSuccess)success failure:(MGResponseFailed)failure reqError:(TTWResponseError)reqError;

#pragma mark-- 获取法币交易记录详情
+ (void)getFiatCodeDetaiWithUrl:(NSString *)url params:(NSDictionary *)params success:(TTWResponseSuccess)success failure:(MGResponseFailed)failure reqError:(TTWResponseError)reqError;
#pragma mark-- 申诉
+ (void)commitComplainWithUrl:(NSString *)url params:(NSDictionary *)params success:(TTWResponseSuccess)success failure:(MGResponseFailed)failure reqError:(TTWResponseError)reqError;
#pragma mark-- 查看申诉信息
+ (void)checkComplainWithUrl:(NSString *)url params:(NSDictionary *)params success:(TTWResponseSuccess)success failure:(MGResponseFailed)failure reqError:(TTWResponseError)reqError;

#pragma mark-- 标记为已付款/已收款
+ (void)markedPaymentReceivedWithUrl:(NSString *)url params:(NSDictionary *)params success:(TTWResponseSuccess)success failure:(MGResponseFailed)failure reqError:(TTWResponseError)reqError;

#pragma mark-- 取消交易
+ (void)cancelTradingWithUrl:(NSString *)url params:(NSDictionary *)params success:(TTWResponseSuccess)success failure:(MGResponseFailed)failure reqError:(TTWResponseError)reqError;

#pragma mark-- 获取法币账户信息
+ (void)getFiatInfoWithUrl:(NSString *)url params:(NSDictionary *)params success:(TTWResponseSuccess)success failure:(MGResponseFailed)failure reqError:(TTWResponseError)reqError;

#pragma mark-- 获取法币交易记录委托列表
+ (void)getFiatEntrustListWithUrl:(NSString *)url params:(NSDictionary *)params success:(TTWResponseSuccess)success failure:(MGResponseFailed)failure reqError:(TTWResponseError)reqError;

#pragma mark-- 广告发布撤销
+ (void)removeAdsOrdertWithUrl:(NSString *)url params:(NSDictionary *)params success:(TTWResponseSuccess)success failure:(MGResponseFailed)failure reqError:(TTWResponseError)reqError;

#pragma mark --  获取盘面行情/买卖五档
+ (void)getQuotationsWithUrl:(NSString *)url params:(NSDictionary *)params success:(TTWResponseSuccess)success failure:(MGResponseFailed)failure reqError:(TTWResponseError)reqError;
#pragma mark-- 资金划转
+(void)transferWithUrl:(NSString *)url params:(NSDictionary *)params success:(TTWResponseSuccess)success failure:(MGResponseFailed)failure reqError:(TTWResponseError)reqError;

#pragma mark-- 币币盘面详情
+(void)getQuotesSurfaceWithUrl:(NSString *)url params:(NSDictionary *)params success:(TTWResponseSuccess)success failure:(MGResponseFailed)failure reqError:(TTWResponseError)reqError;

#pragma mark-- 获取交易队列
+(void)getcurrencylListWithUrl:(NSString *)url params:(NSDictionary *)params success:(TTWResponseSuccess)success failure:(MGResponseFailed)failure reqError:(TTWResponseError)reqError;
#pragma mark-- 充值
+ (void)rechargeWithUrl:(NSString *)url params:(NSDictionary *)params success:(TTWResponseSuccess)success failure:(MGResponseFailed)failure reqError:(TTWResponseError)reqError;
#pragma mark-- 提币
+ (void)withdrawWithUrl:(NSString *)url params:(NSDictionary *)params success:(TTWResponseSuccess)success failure:(MGResponseFailed)failure reqError:(TTWResponseError)reqError;
#pragma mark-- 根据该用户的币种获取币币的详情信息(提币)
+ (void)getCoinFundsInfoWithUrl:(NSString *)url params:(NSDictionary *)params success:(TTWResponseSuccess)success failure:(MGResponseFailed)failure reqError:(TTWResponseError)reqError;

#pragma mark-- 获取国际行情价
+(void)getInternationalMarketPriceWithUrl:(NSString *)url params:(NSDictionary *)params success:(TTWResponseSuccess)success failure:(MGResponseFailed)failure reqError:(TTWResponseError)reqError;

#pragma mark--  是否强制更新
+(void)mandatoryUpdateManagerWithUrl:(NSString *)url  params:(NSDictionary *)params success:(TTWResponseSuccess)success failure:(MGResponseFailed)failure reqError:(TTWResponseError)reqError;

#pragma mark--  充币/提币列表
+(void)fillingCurrencyCurrencyWithUrl:(NSString *)url  params:(NSDictionary *)params success:(TTWResponseSuccess)success failure:(MGResponseFailed)failure reqError:(TTWResponseError)reqError;

#pragma mark--  币币委托撤单
+(void)cancelCoinWeituoWithUrl:(NSString *)url  params:(NSDictionary *)params success:(TTWResponseSuccess)success failure:(MGResponseFailed)failure reqError:(TTWResponseError)reqError;

#pragma mark--  币币交易下单买/卖
+(void)coinDealBuySellOrderWithUrl:(NSString *)url  params:(NSDictionary *)params success:(TTWResponseSuccess)success failure:(MGResponseFailed)failure reqError:(TTWResponseError)reqError;

#pragma mark--  获取币币交易委托列表
+(void)getCoinDealweituoOrderWithUrl:(NSString *)url  params:(NSDictionary *)params success:(TTWResponseSuccess)success failure:(MGResponseFailed)failure reqError:(TTWResponseError)reqError;


#pragma mark--  获取我的自选列表
+(void)getCoinDealMyChoiceListWithUrl:(NSString *)url  params:(NSDictionary *)params success:(TTWResponseSuccess)success failure:(MGResponseFailed)failure reqError:(TTWResponseError)reqError;

#pragma mark--  添加/取消自选列表
+(void)addOrCancelMyChoiceListWithUrl:(NSString *)url  params:(NSDictionary *)params success:(TTWResponseSuccess)success failure:(MGResponseFailed)failure reqError:(TTWResponseError)reqError;

#pragma mark--  获取最小交易量
+(void)getMinVolumeWithUrl:(NSString *)url  params:(NSDictionary *)params success:(TTWResponseSuccess)success failure:(MGResponseFailed)failure reqError:(TTWResponseError)reqError;

#pragma mark--  获取最小变动单位
+(void)getMinWaveWithUrl:(NSString *)url  params:(NSDictionary *)params success:(TTWResponseSuccess)success failure:(MGResponseFailed)failure reqError:(TTWResponseError)reqError;

#pragma mark--  获取币种获取详情信息
+(void)getCoinInfoWithUrl:(NSString *)url  params:(NSDictionary *)params success:(TTWResponseSuccess)success failure:(MGResponseFailed)failure reqError:(TTWResponseError)reqError;

#pragma mark--  获取公告列表
+(void)getAnnouncementListWithUrl:(NSString *)url  params:(NSDictionary *)params success:(TTWResponseSuccess)success failure:(MGResponseFailed)failure reqError:(TTWResponseError)reqError;
#pragma mark--  资金转移
+(void)commitCoinMoveWithUrl:(NSString *)url  params:(NSDictionary *)params success:(TTWResponseSuccess)success failure:(MGResponseFailed)failure reqError:(TTWResponseError)reqError;
@end
