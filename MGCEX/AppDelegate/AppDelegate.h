// MGC
//
// AppDelegate.h
// IOSFrameWork
//
// Created by MGC on 2018/3/15.
// Copyright © 2018年 MGCion. All rights reserved.
//
// @ description <#描述#> 

#import <UIKit/UIKit.h>
#import "BaseTabBarController.h"
#import "MGSystemMaintenanceView.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate>
/**
 * 是否允许转向
 */
@property(nonatomic,assign)BOOL allowRotation;
@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) BaseTabBarController *baseTabBar;
@property (nonatomic, strong) MGSystemMaintenanceView * systemView;
@end

