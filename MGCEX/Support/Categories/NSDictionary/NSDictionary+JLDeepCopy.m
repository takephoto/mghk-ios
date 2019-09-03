//
/*! 文件信息

 * @project   MGCPay

 * @header    NSDictionary+JLDeepCopy.m

 * @abstract  描述

 * @author    Joblee

 * @version   1.00 2017/12/3

 * @copyright Copyright © 2017年 Joblee. All rights reserved.

*/

#import "NSDictionary+JLDeepCopy.h"

@implementation NSDictionary (JLDeepCopy)



-(NSMutableDictionary *)mutableDeepCopy
{
    NSMutableDictionary *dict=[[NSMutableDictionary alloc] initWithCapacity:[self count]];
    //新建一个NSMutableDictionary对象，大小为原NSDictionary对象的大小
    NSArray *keys=[self allKeys];
    for(id key in keys)
    {//循环读取复制每一个元素
        id value=[self objectForKey:key];
        id copyValue;
        if ([value respondsToSelector:@selector(mutableDeepCopy)]) {
            //如果key对应的元素可以响应mutableDeepCopy方法(还是NSDictionary)，调用mutableDeepCopy方法复制
            copyValue=[value mutableDeepCopy];
        }
        else if([value respondsToSelector:@selector(mutableCopy)]){
            copyValue=[value mutableCopy];
        }
        if(copyValue==nil)
            copyValue=[value copy];
        [dict setObject:copyValue forKey:key];
        
    }
    return dict;
}


/**
 *  字典转 json字符串
 *
 *  @return json字符串
 */
-(NSString *)dictionaryToJsonString
{
    NSError *error = nil;
    
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:self options:NSJSONWritingPrettyPrinted error:&error];
    
    if (error) {
        return nil;
    }
    
    return [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
}

@end
