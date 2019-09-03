//
//  NSString+QSExtension.h
//  ZengLongSeSha
//
//  Created by apple on 2017/6/22.
//  Copyright © 2017年 Song. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface NSString (QSExtension)
/**
 *  获取字符串文字的长度
 *
 *  @param font 字体
 *  @param height 固定高度
 *  return 宽度
 */
- (CGFloat)obtainWidthWithFont:(UIFont *)font andHeight:(CGFloat)height;

/**
 *  获取字符串文字的高度
 *
 *  @param font 字体
 *  @param width 固定宽度
 *  return 高度
 */
- (CGFloat)obtainHeightWithFont:(UIFont *)font andWidth:(CGFloat)width;

/**
 *  按照字符分割字符串
 *
 *  @param divisiveChar 分割的特定字符
 */
- (NSArray *)divisiveStringWithChar:(NSString *)divisiveChar;

/**
 *  过滤字符串中的html标签
 *
 *  @param html 带html标签的字符串
 *  return 没有带html标签的字符串
 */
- (NSString *)stringFilterHTML:(NSString *)html;
/**
 获取拼音首字母,返回大写拼音首字母
  @return 大写首字母
 */
- (NSString *)firstCharactor;

//计算字符串的CGSize
- (CGSize)ex_sizeWithFont:(UIFont *)font constrainedToSize:(CGSize)size;
/**
 保留小数点后位数，不足位数加0
 */
-(NSString *)keepDecimal:(NSInteger)length;
/**
 删除末尾多余的0
 */
-(NSString*)removeFloatAllZero;

/**
 转换为万为单位

 @return
 */
-(NSString *)toTenThousandUnit;

/**
 转换成以千为单位
 */
-(NSString *)toThousandUnit;


/**
 设置子字符串的颜色

 @param subStr 子字符串
 @param color 子字符串颜色
 */
-(NSMutableAttributedString *)changeSubStr:(NSString *)subStr subStrColor:(UIColor *)color;


/**
 判断字符串是否为空

 @param str 字符串
 @return YES 为空 NO 不为空
 */
- (BOOL)isBlankString:(NSString *)str;

/**
 根据数值大小保留小数位
 */
- (NSString *)autoLimitDecimals;


/**
 去除所以空格

 @return self
 */
- (NSString *)clearAllBlankStr;


/**
 处理时间格式

 @param handleDefaultTimeFormat 时间格式
 @return 格式化后的字符串
 */
- (NSString *)handleTimeFormat:(NSString *)dateFormat;


/**
 处理默认的时间格式（@"mm:ss MM/dd"）

 @return 格式化后的字符串
 */
- (NSString *)handleDefaultTimeFormat;


/**
 将时间戳转换为日期格式(yyyy-MM-dd)

 @param timeStr 时间戳字符串
 @return 日期格式字符串
 */
+ (NSString *)mg_handleTime:(NSString *)timeStr;

///时间戳转化为字符转0000-00-00 00:00
- (NSString *)time_timestampToStringFmt:(NSString *)changeFormat;

@end
