//
//  NSString+JLValid.h
//  MGCPay
//
//  Created by Joblee on 2017/10/13.
//  Copyright © 2017年 Joblee. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (JLValid)
/// 检测字符串是否包含中文
+( BOOL)jl_isContainChinese:(NSString *)str;

/// 整形
+ (BOOL)jl_isPureInt:(NSString *)string;

/// 浮点型
+ (BOOL)jl_isPureFloat:(NSString *)string;

/// 有效的手机号码
+ (BOOL)jl_isValidMobile:(NSString *)str;

/// 有效银行卡号
+ (BOOL)isValidBankCardNo:(NSString*)cardNo;

/// 纯数字
+ (BOOL)jl_isPureDigitCharacters:(NSString *)string;

/// 字符串为字母或者数字
+ (BOOL)jl_isValidCharacterOrNumber:(NSString *)str;
///身份证号验证
+ (BOOL)jl_checkIsIdentityCard: (NSString *)identityCard;
///判断您是否邮箱
+ (BOOL)jl_checkEmail:(NSString *)email;
@end
