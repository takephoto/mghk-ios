//
//  NSString+MD5.m
//  myTest
//
//  Created by apple on 2017/9/22.
//  Copyright © 2017年 apple. All rights reserved.
//

#import "NSString+MD5.h"

#import <CommonCrypto/CommonDigest.h>

@implementation NSString (MD5)

/**
 *  32位MD5加密
 */
-(NSString *)md5{
    
    const char *cStr = [self UTF8String];
    unsigned char digest[CC_MD5_DIGEST_LENGTH];
    
    CC_MD5(cStr, (CC_LONG)strlen(cStr), digest);
    
    NSMutableString *result = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
    
    for(int i = 0; i < CC_MD5_DIGEST_LENGTH; i++) {
        [result appendFormat:@"%02x", digest[i]];
    }
    
    return [result copy];
}




/**
 *  SHA1加密
 */
-(NSString *)sha1{
    
    const char *cStr = [self UTF8String];
    NSData *data = [NSData dataWithBytes:cStr length:self.length];
    uint8_t digest[CC_SHA1_DIGEST_LENGTH];
    
    CC_SHA1(data.bytes, (CC_LONG)data.length, digest);
    
    NSMutableString *result = [NSMutableString stringWithCapacity:CC_SHA1_DIGEST_LENGTH * 2];
    
    for(int i = 0; i < CC_SHA1_DIGEST_LENGTH; i++) {
        [result appendFormat:@"%02x", digest[i]];
    }
    
    return [result copy];
}


/**
 *  MD5加密, 32位 小写
 */
+ (NSString *)MD5_lower32Bit:(NSString *)str{
    
    // 要进行UTF8的转码
    const char* input = [str UTF8String];
    unsigned char result[CC_MD5_DIGEST_LENGTH];
    CC_MD5(input, (CC_LONG)strlen(input), result);
    
    NSMutableString *digest = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
    for (NSInteger i = 0; i < CC_MD5_DIGEST_LENGTH; i++) {
        [digest appendFormat:@"%02x", result[i]];
    }
    
    return digest;
}

/**
 *  MD5加密, 32位 大写
 */
+ (NSString *)MD5_upper32Bit:(NSString *)str{
    
    // 要进行UTF8的转码
    const char* input = [str UTF8String];
    unsigned char result[CC_MD5_DIGEST_LENGTH];
    CC_MD5(input, (CC_LONG)strlen(input), result);
    
    NSMutableString *digest = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
    for (NSInteger i = 0; i < CC_MD5_DIGEST_LENGTH; i++) {
        [digest appendFormat:@"%02X", result[i]];
    }
    
    return digest;
}

/**
 *  自定义MD5加密
 */
+ (NSString *)MD5_custom:(NSString *)string
{
    char hexDigits[] = {'0', '1', '2', '4', '5', '6', '7', '8', '9', 'a', 'b', 'c', 'd', 'e', 'f','M','n','i','G','R'};
    
    const char *cString = [string UTF8String];
    unsigned char digest[CC_MD5_DIGEST_LENGTH];
    
    CC_MD5(cString, (CC_LONG)strlen(cString), digest);
    
    char str[CC_MD5_DIGEST_LENGTH * 2];
    int k = 0;
    for (int i = 0; i < CC_MD5_DIGEST_LENGTH; i++) {
        
        char byte = digest[i];
        char byte1 = digest[i];
        str[k++] = hexDigits[(byte >> 4) & 0xf];
        str[k++] = hexDigits[byte1 & 0xf];
    }
    NSString *encryptedString = @"";
    for (int i = 0; i < CC_MD5_DIGEST_LENGTH * 2; i++) {
        encryptedString = [encryptedString stringByAppendingFormat:@"%c",str[i]];
    }
    
    return encryptedString;
}
@end
