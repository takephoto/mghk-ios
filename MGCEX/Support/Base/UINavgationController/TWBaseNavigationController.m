// MGC
//
// TWBaseNavigationController.m
// IOSFrameWork
//
// Created by MGC on 2018/4/27.
// Copyright © 2018年 MGCion. All rights reserved.
//
// @ description <#描述#> 

#import "TWBaseNavigationController.h"

@interface TWBaseNavigationController ()<UIGestureRecognizerDelegate>

@end

@implementation TWBaseNavigationController

- (void)loadView {
    [super loadView];
}



// 重载push方法
- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    
    if (self.childViewControllers.count==1) {
        viewController.hidesBottomBarWhenPushed = YES; //viewController是将要被push的控制器
    }

    [super pushViewController:viewController animated:animated];

}



- (void)viewDidLoad {
    [super viewDidLoad];
    
}




@end
