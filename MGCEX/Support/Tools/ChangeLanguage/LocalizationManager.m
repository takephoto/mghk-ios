//
//  LocalizationManager.m
//  LocalizationDemo
//
//  Created by maple on 2016/12/20.
//  Copyright © 2016年 maple. All rights reserved.
//

#import "LocalizationManager.h"
#import "AppDelegate.h"


@implementation LocalizationManager

static NSString *TableName = @"localization";
static NSBundle *bundle = nil;
static NSString *UserLanguage = @"UserLanguage";

+ (NSBundle *)bundle
{
    if(!bundle)
    {
        [self initUserLanguage];
    }
    return bundle;
}
//获取当前资源文件
+ (void)initUserLanguage{
    NSUserDefaults *def = [NSUserDefaults standardUserDefaults];
    NSString *string = [def valueForKey:UserLanguage];
    if(string.length == 0)
    {
        //获取系统当前语言版本(中文zh-Hans,英文en，繁体 zh-HK)
        NSArray *languages = [NSLocale preferredLanguages];
        
        NSString *current = [languages objectAtIndex:0];
        string = [self languageFormat:current];
        [def setValue:current forKey:UserLanguage];
        [def synchronize];//持久化，不加的话不会保存
    }
    
    //获取文件路径
    NSString *path = [[NSBundle mainBundle] pathForResource:[self languageFormat:string] ofType:@"lproj"];
    
    bundle = [NSBundle bundleWithPath:path];//生成bundle
}

+ (void)setUserlanguage:(NSString *)language{
    
//    if([[self userLanguage] isEqualToString:language]){
//        return;
//    }
    NSUserDefaults *def = [NSUserDefaults standardUserDefaults];

    //1.第一步改变bundle的值
    NSString *path = [[NSBundle mainBundle] pathForResource:[self languageFormat:language] ofType:@"lproj" ];
    
    bundle = [NSBundle bundleWithPath:path];
    
    //2.持久化
    [def setValue:language forKey:UserLanguage];
    
    [def synchronize];
    [self resetRootViewController];
    
    
}

+ (NSString *)userLanguage
{
    NSString *userLanguage = [[NSUserDefaults standardUserDefaults] objectForKey:UserLanguage];
    return userLanguage;
}

+ (NSString *)localizedStringForKey:(NSString *)key
{
    return [[LocalizationManager bundle] localizedStringForKey:key value:nil table:TableName];
}

/// 通过Key获得对应的string  tableName:注释
+ (NSString *)localizedStringForKey:(NSString *)key tableName:(NSString *)tableName{
    if (!tableName) {
        tableName = TableName;
    }
    return [[LocalizationManager bundle] localizedStringForKey:key value:nil table:tableName];
}

///语言和语言对应的.lproj的文件夹前缀不一致时在这里做处理
+ (NSString *)languageFormat:(NSString*)language {
    if([language rangeOfString:@"zh-Hans"].location != NSNotFound)
    {
        return @"zh-Hans";//简体中文
    }
    else if([language rangeOfString:@"zh-Hant"].location != NSNotFound)
    {
        return @"zh-Hant";//繁体
    }
    else
    {
        //字符串查找
        if([language rangeOfString:@"-"].location != NSNotFound) {
            //除了中文以外的其他语言统一处理@"ru_RU" @"ko_KR"取前面一部分
            NSArray *ary = [language componentsSeparatedByString:@"-"];
            if (ary.count > 1) {
                NSString *str = ary[0];
                return str;
            }
        }
    }
    return language;
}

//重新设置
+ (void)resetRootViewController
{
    AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    BaseTabBarController *tabVC = [[BaseTabBarController alloc] init];
    delegate.window.rootViewController = tabVC;
    
}


@end
