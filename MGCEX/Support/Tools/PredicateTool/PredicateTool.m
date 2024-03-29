//
//  PredicateTool.m
//  tongneiwangBusiness
//
//  Created by  MGCion on 16/11/10.
//  Copyright © 2016年  MGCion. All rights reserved.
//

#import "PredicateTool.h"

@implementation PredicateTool

//对手机号码进行正则判断
+(BOOL)validatePhoneNumber:(NSString *)phoneNumber{
    
    NSString* number=@"^1[3|4|5|7|8][0-9]\\d{8}$";
    NSPredicate *numberPre = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",number];
    return [numberPre evaluateWithObject:phoneNumber];
}

/**
 *  邮箱验证
 */
+ (BOOL)validateEmail:(NSString *)email
{
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:email];
}

/**对6 -20位必须包含字母数字的密码进行正则判断*/
+ (BOOL)validatePassword:(NSString *)password{
    
    NSString* passwordStr = @"^(?!^\\d+$)(?!^[a-zA-Z]+$)[0-9a-zA-Z]{6,20}$";
    NSPredicate *passwordPre = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",passwordStr];
    return [passwordPre evaluateWithObject:password];
}

/**对数字进行正则判断*/
+ (BOOL)validateNumber:(NSString *)number{
    
    if (kStringIsEmpty(number)) return NO;
    NSString * tNumber = @"^[-\\+]?[\\d]*$";
    NSPredicate *numberPre = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",tNumber];
    return [numberPre evaluateWithObject:number];
}

/**对6位纯数字进行正则判断*/
+ (BOOL)validateSixNumber:(NSString *)number{
    
    NSString * tNumber = @"^\\d{0,6}$";
    NSPredicate *numberPre = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",tNumber];
    return [numberPre evaluateWithObject:number];
}
/**对2位小数进行正则判断*/
+(BOOL)validateDoubleNumber:(NSString *)number{
    
    NSString * tNumber = @"^\\d+(\\.\\d{0,2})|\\.\\d{0,2}|\\d+$";
    NSPredicate *numberPre = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",tNumber];
    return [numberPre evaluateWithObject:number];
}

/**对身份证号码正则判断*/
+(BOOL)validateIDCardNumber:(NSString *)idCardNumber{

    NSString * tNumber = @"^(\\d{15}$|^\\d{18}$|^\\d{17}(\\d|X|x))$";
    NSPredicate *numberPre = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",tNumber];
    return [numberPre evaluateWithObject:idCardNumber];
}

/**对银行卡号进行正则判断 （16 - 19位）*/
+(BOOL)validateBankCardNumber:(NSString *)bankCardNumber{
    
    bankCardNumber = [bankCardNumber stringByReplacingOccurrencesOfString:@" " withString:@""];
    /* 步骤1
     按照从右往左的顺序，从这串数字的右边开始，包含校验码，将偶数位数字乘以2，
     如果每次乘二操作的结果大于9（如 8 × 2 = 16），然后计算个位和十位数字的和
     （如 1 ＋ 6 = 7）或者用这个结果减去9（如 16 - 9 ＝ 7）  */
    NSMutableArray* newNumArray = [NSMutableArray array];
    NSString* cardNoChar = nil;
    for(long i = bankCardNumber.length - 2; i >= 0; i -= 2){
        // 奇数位
        cardNoChar = [bankCardNumber substringWithRange:NSMakeRange(i + 1, 1)];
        [newNumArray addObject:cardNoChar];
        // 偶数位
        cardNoChar = [bankCardNumber substringWithRange:NSMakeRange(i, 1)];
        int k = [cardNoChar intValue]*2;
        // 处理大于9的情况
        k = k % 10 + k / 10;
        [newNumArray addObject:[NSString stringWithFormat:@"%d", k]];
        if (i == 1) {
            // 奇数位
            cardNoChar = [bankCardNumber substringWithRange:NSMakeRange(i - 1, 1)];
            [newNumArray addObject:cardNoChar];
        }
    }
    
    /* 步骤2 第一步操作过后会得到新的一串数字，计算所有数字的和（包含校验码） */
    int sum = [[newNumArray valueForKeyPath:@"@sum.integerValue"] intValue];
    
    /* 步骤3 用第二步操作得到的和进行“模10”运算，如果结果位0，表示校验通过，否则失败 */
    
    return sum % 10 == 0;
}

/**url正则判断*/
+(BOOL)validateUrlString:(NSString *)urlString{
    
//    NSString *tUrl = @"^((http[s]{0,1}|ftp)://[a-zA-Z0-9\\.\\-]+\\.([a-zA-Z]{2,4})(:\\d+)?(/[a-zA-Z0-9\\.\\-~!@#$%^&*+?:_/=<>]*)?)|(www.[a-zA-Z0-9\\.\\-]+\\.([a-zA-Z]{2,4})(:\\d+)?(/[a-zA-Z0-9\\.\\-~!@#$%^&*+?:_/=<>]*)?)$";
    NSString *tUrl = @"^((HTTPS?|FTP|FILE|https?|ftp|file)://[-A-Za-z0-9+&@#/%?=~_|!:,.;]+[-A-Za-z0-9+&@#/%=~_|])$";
    NSPredicate *urlPre = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",tUrl];
    return [urlPre evaluateWithObject:urlString];
}

/**非法字符正则判断 */
+ (BOOL)validateIllegalLetter:(NSString *)string{
    
    NSString *illegalLetterPre = @"^[A-Za-z0-9\\u4e00-\u9fa5]+$";
    NSPredicate *illegalPre = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",illegalLetterPre];
    return ![illegalPre evaluateWithObject:string];
}

@end
