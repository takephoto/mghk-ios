// MGC
//
// AppDelegate.m
// IOSFrameWork
//
// Created by MGC on 2018/3/15.
// Copyright © 2018年 MGCion. All rights reserved.
//
// @ description <#描述#> 

#import "AppDelegate.h"
#import "AppDelegate+AppService.h"
#import "LoginIndexVC.h"
#import "TouchIDViewController.h"
#import "AppDelegate+LocalNotification.h"
#import "AppDelegate+JPUSHService.h"


@interface AppDelegate ()


@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // 允许摇一摇功能
#ifdef DEBUG
    application.applicationSupportsShakeToEdit = YES;
    //网络API  默认测试
    [TTWNetworkHandler sharedInstance].host_api = @"http://112.74.179.88/api/";
#else
    [TTWNetworkHandler sharedInstance].host_api = HOST;
#endif
    //初始化
    [self initWindows];

    //初始化IQKeyboard
    [self setUpIQKeyboard];
    
    //极光推送
    [self setUpJPushWithOptions:launchOptions];
   
    [TTWNetworkHandler startMonitoring];//监听网络
    
    
    return YES;
}


- (UIInterfaceOrientationMask)application:(UIApplication *)application supportedInterfaceOrientationsForWindow:(nullable UIWindow *)window

{
    
    if (self.allowRotation == YES) {
        //横屏
        return UIInterfaceOrientationMaskLandscape;
        
    }else{
        //竖屏
        return UIInterfaceOrientationMaskPortrait;
        
    }
    
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    [application setApplicationIconBadgeNumber:0];
    [application cancelAllLocalNotifications];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:krelodeOrderTime object:nil];
    
}


- (void)applicationDidBecomeActive:(UIApplication *)application {

#ifdef DEBUG
   
#else
    //系统维护中
    [self getSystemState];
#endif
    
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    //进入后台
    if ([[NSUserDefaults standardUserDefaults] boolForKey:@"touchID"] || [[NSUserDefaults standardUserDefaults]objectForKey:gestureFinalSaveKey]) {
        [[NSUserDefaults standardUserDefaults] setObject:[self getCurrentDate] forKey:@"endAppTime"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
}

- (void)applicationWillTerminate:(UIApplication *)application {

    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:KillLogin];//杀掉进程
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (NSString *)getCurrentDate {
    NSDate *currentDate = [NSDate date];//获取当前时间，日期
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"MMddhhmmss"];
    NSString *dateString = [dateFormatter stringFromDate:currentDate];
    return dateString;
}



@end
