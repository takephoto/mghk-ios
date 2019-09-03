// MGC
//
// AppDelegate+AppService.h
// IOSFrameWork
//
// Created by MGC on 2018/4/28.
// Copyright © 2018年 MGCion. All rights reserved.
//
// @ description <#描述#> 

#import "AppDelegate.h"


@interface AppDelegate (AppService)

//初始化
-(void)initWindows;

/**设置IQ键盘*/
- (void)setUpIQKeyboard;

//获取后台状态
- (void)getSystemState;

@end
