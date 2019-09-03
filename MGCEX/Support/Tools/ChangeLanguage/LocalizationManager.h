//
//  LocalizationManager.h
//  LocalizationDemo
//
//  Created by maple on 2016/12/20.
//  Copyright © 2016年 maple. All rights reserved.
//

#import <Foundation/Foundation.h>

//#define kLocalizedString(key) [LocalizationManager localizedStringForKey:key]
//#define kLocalizedTableString(key,tableN) [LocalizationManager localizedStringForKey:key tableName:tableN]

/// 国际化管理者
@interface LocalizationManager : NSObject
/// 获取当前资源文件
+ (NSBundle *)bundle;
/// 初始化语言文件
+ (void)initUserLanguage;
/// 获取应用当前语言
+ (NSString *)userLanguage;
/// 设置当前语言
+ (void)setUserlanguage:(NSString *)language;
/// 通过Key获得对应的string
+ (NSString *)localizedStringForKey:(NSString *)key;
/// 通过Key获得对应的string  tableName:注释
+ (NSString *)localizedStringForKey:(NSString *)key tableName:(NSString *)tableName;
    
@end
