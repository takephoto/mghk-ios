//
//  NSArray+Extend.h
//  Wifi
//
//  Created by muxi on 14/11/27.
//  Copyright (c) 2014年 muxi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSArray (Extend)


/**
 *  数组转字符串
 */
-(NSString *)string;


/**
 *  数组比较
 */
-(BOOL)compareIgnoreObjectOrderWithArray:(NSArray *)array;


/**
 *  数组计算交集
 */
-(NSArray *)arrayForIntersectionWithOtherArray:(NSArray *)otherArray;

/**
 *  数据计算差集
 */
-(NSArray *)arrayForMinusWithOtherArray:(NSArray *)otherArray;

/**
 安全获取对象，防止越界
 */
- (id)mg_safetyGetObjIndex:(NSInteger)index;

@end

#pragma mark --NSMutableArray

@interface NSMutableArray (Extend)
/**
 安全获取对象，防止越界
 */
- (id)mg_safetyGetObjIndex:(NSInteger)index;
/**
 安全添加对象，防止添加空对象导致crash
 */
- (void)mg_safetAddObj:(id)obj;

@end



