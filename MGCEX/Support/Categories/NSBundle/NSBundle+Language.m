//
//  NSBundle+Language.m
//  GreatChef
//
//  Created by 赵赤赤 on 16/8/4.
//  Copyright © 2016年 early bird international. All rights reserved.
//

#import "NSBundle+Language.h"
#import <objc/runtime.h>

static const char _bundle = 0;

@interface BundleEx : NSBundle

@end

@implementation BundleEx

- (NSString *)localizedStringForKey:(NSString *)key value:(NSString *)value table:(NSString *)tableName {
    NSBundle *bundle = objc_getAssociatedObject(self, &_bundle);
    return bundle ? [bundle localizedStringForKey:key value:value table:tableName] : [super localizedStringForKey:key value:value table:tableName];
}

@end

@implementation NSBundle (Language)

+ (void)setLanguage:(NSString *)language {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        object_setClass([NSBundle mainBundle], [BundleEx class]);
    });
    
    objc_setAssociatedObject([NSBundle mainBundle], &_bundle, language ? [NSBundle bundleWithPath:[[NSBundle mainBundle] pathForResource:language ofType:@"lproj"]] : nil, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

//获取当前语言
+ (NSString*)getPreferredLanguage

{
    //获取手机用户App内部改变的语言
    if ([[NSUserDefaults standardUserDefaults] objectForKey:myLanguage] && ![[[NSUserDefaults standardUserDefaults] objectForKey:myLanguage] isEqualToString:@""]) {
        
        return [[NSUserDefaults standardUserDefaults] objectForKey:myLanguage];
    }else{

        //获取当前设备语言
        NSArray *appLanguages = [[NSUserDefaults standardUserDefaults] objectForKey:@"AppleLanguages"];
        NSString *languageName = [appLanguages objectAtIndex:0];
        
        [[NSUserDefaults standardUserDefaults] setObject:languageName forKey:myLanguage];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        return languageName;
    }
  
}


@end
