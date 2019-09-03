//
//  PredicateTool.h
//  tongneiwangBusiness
//
//  Created by  MGCion on 16/11/10.
//  Copyright © 2016年  MGCion. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PredicateTool : NSObject

/**对手机号码进行正则判断*/
+(BOOL)validatePhoneNumber:(NSString *)phoneNumber;

/** 邮箱验证 */
+ (BOOL)validateEmail:(NSString *)email;

/**对6 -20位必须包含字母数字的密码进行正则判断*/
+ (BOOL)validatePassword:(NSString *)password;

/**对数字进行正则判断*/
+ (BOOL)validateNumber:(NSString *)number;

/**对6位纯数字进行正则判断*/
+ (BOOL)validateSixNumber:(NSString *)number;

/**对2位小数进行正则判断*/
+(BOOL)validateDoubleNumber:(NSString *)number;

/**对身份证号码正则判断*/
+(BOOL)validateIDCardNumber:(NSString *)idCardNumber;

/**对银行卡号进行正则判断*/
+(BOOL)validateBankCardNumber:(NSString *)bankCardNumber;

/**url正则判断*/
+(BOOL)validateUrlString:(NSString *)urlString;

/**非法字符正则判断*/
+ (BOOL)validateIllegalLetter:(NSString *)string;
@end
