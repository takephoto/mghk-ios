// MGC
//
// AppDelegate+LocalNotification.m
// AFNNetworkingDemo
//
// Created by MGC on 2018/3/14.
// Copyright © 2018年 MGCion. All rights reserved.
//
// @ description <#描述#> 

#import "AppDelegate+LocalNotification.h"
#import <UserNotifications/UserNotifications.h>

#define IS_IOS10ORLATER ([[[UIDevice currentDevice] systemVersion] floatValue] >= 10)

typedef void(^CompletionHandlerType)(void);

@interface AppDelegate ()<UNUserNotificationCenterDelegate>

@end

@implementation AppDelegate (LocalNotification)



//创建本地通知
- (void)requestAuthor
{
    
    if ([UIDevice currentDevice].systemVersion.floatValue >= 8.0) {
        
        // 设置通知的类型可以为弹窗提示,声音提示,应用图标数字提示
        UIUserNotificationSettings *setting = [UIUserNotificationSettings settingsForTypes:UIUserNotificationTypeBadge | UIUserNotificationTypeSound | UIUserNotificationTypeAlert categories:nil];
        // 授权通知
        [[UIApplication sharedApplication] registerUserNotificationSettings:setting];
    }
}
@end
