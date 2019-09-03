//
//  NSString+MD5.h
//  myTest
//
//  Created by apple on 2017/9/22.
//  Copyright © 2017年 apple. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (MD5)
/**
 *  32位MD5加密
 */
@property (nonatomic,copy,readonly) NSString *md5;

/**
 *  SHA1加密
 */
@property (nonatomic,copy,readonly) NSString *sha1;
/**
 *  MD5加密, 32位 小写
 *
 *  @param str 传入要加密的字符串
 *
 *  @return 返回加密后的字符串
 */
+ (NSString *)MD5_lower32Bit:(NSString *)str;

/**
 *  MD5加密, 32位 大写
 *
 *  @param str 传入要加密的字符串
 *
 *  @return 返回加密后的字符串
 */
+ (NSString *)MD5_upper32Bit:(NSString *)str;

/**
 *  自定义MD5加密
 */
+ (NSString *)MD5_custom:(NSString *)str;
@end
