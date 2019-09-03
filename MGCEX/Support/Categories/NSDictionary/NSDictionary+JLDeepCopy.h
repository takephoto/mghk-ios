//
/*! 文件信息

 * @project   MGCPay

 * @header    NSDictionary+JLDeepCopy.h

 * @abstract  描述

 * @author    Joblee

 * @version   1.00 2017/12/3

 * @copyright Copyright © 2017年 Joblee. All rights reserved.

*/

#import <Foundation/Foundation.h>

@interface NSDictionary (JLDeepCopy)

/**
 增加mutableDeepCopy方法
 */
-(NSMutableDictionary *)mutableDeepCopy;

/**
 *  字典转 json字符串
 *
 *  @return json字符串
 */
-(NSString *)dictionaryToJsonString;

@end


