// MGC
//
// AppDelegate+AppService.m
// IOSFrameWork
//
// Created by MGC on 2018/4/28.
// Copyright © 2018年 MGCion. All rights reserved.
//
// @ description <#描述#> 

#import "AppDelegate+AppService.h"
#import "GuidView.h"
#import "LoginIndexVC.h"
#import "GestureViewController.h"
#import "TestViewController.h"
#import "MGTransferTVC.h"
#import "MGWithdrawTVC.h"
#import "RechargeAddressVC.h"

@implementation AppDelegate (AppService)

-(void)initWindows{
    
    
    if(kFirst == NO){
        
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:kIsFirst];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        [NSBundle setLanguage:@"zh-Hant"];
        // 然后将设置好的语言存储好，下次进来直接加载
        [[NSUserDefaults standardUserDefaults] setObject:@"zh-Hant" forKey:myLanguage];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
 

    if ([[NSUserDefaults standardUserDefaults] objectForKey:myLanguage] && ![[[NSUserDefaults standardUserDefaults] objectForKey:myLanguage] isEqualToString:@""]) {
        
        [NSBundle setLanguage:[[NSUserDefaults standardUserDefaults] objectForKey:myLanguage]];
    }else{
        
        
        [NSBundle setLanguage:@"zh-Hant"];
        
        // 然后将设置好的语言存储好，下次进来直接加载
        [[NSUserDefaults standardUserDefaults] setObject:@"zh-Hant" forKey:myLanguage];
        [[NSUserDefaults standardUserDefaults] synchronize];
 
    }

    //设置国际化
    //[NSBundle setLanguage:[NSBundle getPreferredLanguage]];

    self.window = [[UIWindow alloc]initWithFrame:[[UIScreen mainScreen]bounds]];
    self.baseTabBar = [BaseTabBarController new];
    self.window.rootViewController = self.baseTabBar;
    [self.window makeKeyAndVisible];
    self.window.backgroundColor = white_color;

    //引导页
    NSString * yingdao = [[NSUserDefaults standardUserDefaults] objectForKey:@"isyingdao"];

    if(yingdao.length == 0){
        GuidView *guidView = [[GuidView alloc]initWithFrame:[UIScreen mainScreen].bounds];
        [guidView show];
        guidView.disappear = ^{

        };
    }
    

    if (@available(iOS 11.0, *)){
        [[UIScrollView appearance] setContentInsetAdjustmentBehavior:UIScrollViewContentInsetAdjustmentNever];
    }
}



- (void)setUpIQKeyboard{
    IQKeyboardManager *manager = [IQKeyboardManager sharedManager];
    manager.enable = YES;
    manager.shouldResignOnTouchOutside = YES;
    manager.toolbarTintColor = kLineAssistColor;
    manager.enableAutoToolbar = YES;
}

//获取后台状态
- (void)getSystemState{
    
    [TTWNetworkHandler requestWithUrl:@"c2c/getSystemStatus" requestMethod:RequestByPost params:nil isShowHUD:NO success:^(id  _Nullable response) {

        if (MGStatus(response) == NetStatusSuccess) {
            if([response[response_data][@"status"] intValue] == 1){
            //系统正常
            [self.systemView hidden];

            }else if ([response[response_data][@"status"] intValue] == 2){
             //系统异常
             self.systemView = [[MGSystemMaintenanceView alloc]initWithFrame:[UIScreen mainScreen].bounds];
             [self.systemView show];

            }

        }

    } fail:^(NSError * _Nullable error) {


    }];
}


@end
