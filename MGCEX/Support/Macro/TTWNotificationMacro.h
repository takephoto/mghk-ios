// MGC
//
// TTWNotificationMacro.h
// kachi
//
// Created by MGC on 2017/12/28.
// Copyright © 2017年 qw. All rights reserved.
//
// @ description <#描述#> 

#ifndef TTWNotificationMacro_h
#define TTWNotificationMacro_h


///////////////////////////******倒计时********////////////////////
//保存手机注册倒计时时间戳
#define PhoneRegisterCountdown @"PhoneRegisterCountdown"
//保存手机注册倒计时秒
#define PhoneRegisterCountdownTime @"PhoneRegisterCountdownTime"


//保存邮箱注册倒计时时间戳
#define MailRegisterCountdown @"MailRegisterCountdown"
//保存邮箱注册倒计时秒
#define MailRegisterCountdownTime @"MailRegisterCountdownTime"

//保存重置手机注册倒计时时间戳
#define ResertPhoneRegisterCountdown @"ResertPhoneRegisterCountdown"
//保存重置手机注册倒计时秒
#define ResertPhoneRegisterCountdownTime @"ResertPhoneRegisterCountdownTime"

//保存重置邮箱注册倒计时时间戳
#define ResertMailRegisterCountdown @"ResertMailRegisterCountdown"
//保存重置邮箱注册倒计时秒
#define ResertMailRegisterCountdownTime @"ResertMailRegisterCountdownTime"

//绑定手机号倒计时时间戳
#define BingingPhoneNumberdown @"BingingPhoneNumberdown"
//绑定手机号倒计时秒
#define BingingPhoneNumberdownTime @"BingingPhoneNumberdownTime"

//绑定邮箱号倒计时时间戳
#define BingingMailNumberdown @"BingingMailNumberdown"
//绑定邮箱号倒计时秒
#define BingingMailNumberdownTime @"BingingMailNumberdownTime"

//设置资金密码倒计时时间戳
#define SettingMoneyPasswordNumberdown @"SettingMoneyPasswordNumberdown"
//设置资金密码计时秒
#define SettingMoneyPasswordNumberdownTime @"SettingMoneyPasswordNumberdownTime"


//二次验证倒计时时间戳
#define SecondaryValidationNumberdown @"SecondaryValidationNumberdown"
//二次验证计时秒
#define SecondaryValidationNumberdownTime @"SecondaryValidationNumberdownTime"

//绑定微信账号获取手机验证码时间戳
#define FiatbindingWXNumberdown @"FiatbindingWXNumberdown"
//绑定微信账号获取手机验证码计时秒
#define FiatbindingWXNumberdownTime @"FiatbindingWXNumberdownTime"


///////////////////////////******国际语言********////////////////////
//当前国际语言
#define myLanguage @"myLanguage"
//发送给后台的语言参数
#define SendLanguage @"SendLanguage"


///////////////////////////******证件上传********////////////////////
//身份证认证 姓名
#define IdentityName @"IdentityName"
//身份证认证 身份证号
#define IdentityNumber @"IdentityNumber"
//身份证认证 身份证正面
#define IdentityFront @"IdentityFront"
//身份证认证 身份证反面
#define IdentityReverse @"IdentityReverse"

//护照认证 名
#define PassportName @"PassportName"
//护照认证 姓
#define PassportsUrname @"PassportsUrname"
//护照认证 护照号码
#define PassportNumber @"PassportNumber"
//护照认证 护照正面
#define PassportPositive @"PassportPositive"
//护照认证 护照手持
#define PassportHand @"PassportHand"

/////////////////////个人信息/登录/////////////////
//是否登录key
#define isLogin @"isLogin"
//是否登录
#define kUserIsLogin [[NSUserDefaults standardUserDefaults] boolForKey:isLogin]
//是否异常退出
#define TokenDisabled @"TokenDisabled"
//当前账号
#define CurrentLogin @"CurrentLogin"
//第一次登录
#define AlreadyFirstLogin @"AlreadyFirstLogin"
//杀掉进程
#define KillLogin @"KillLogin"
//切换语言
#define isChangeLangue @"isChangeLangue"
//验证的手机号
#define VerifierPhone @"VerifierEmail"
//验证的邮箱号
#define VerifierEmail @"VerifierPhone"
//登录UserID
#define UserID @"UserID"
//切换买卖方式
#define changeDealTypeNoti @"changeDealTypeNoti"
//买卖
#define kIsbuy @"dealType"
//市场
#define kMarket @"market"
//代币
#define kSymbol @"symbol"
//代币s
#define kSymbols @"symbols"

#define kIsFirst @"kIsFirst"
#define kFirst [[NSUserDefaults standardUserDefaults] boolForKey:kIsFirst]

#define krelodeOrderTime @"krelodeOrderTime"

///////////////////////通知中心///////////
//币币交易首页点击价格
#define CoinDealprice  @"CoinDealprice"

#endif /* TTWNotificationMacro_h */
