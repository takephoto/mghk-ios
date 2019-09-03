// MGC
//
// TWBaseViewController.h
// IOSFrameWork
//
// Created by MGC on 2018/4/26.
// Copyright © 2018年 MGCion. All rights reserved.
//
// @ description <#描述#> 

#import <UIKit/UIKit.h>
#import "TableViewErrorView.h"
//拦截导航
#import "UIViewController+BackButtonHandler.h"

@interface TWBaseViewController : UIViewController

///绑定数据
- (void)bindViewModel;
-(void)setupSubviews;
/**
 *VIEW是否渗透导航栏
 */
@property (nonatomic,assign) BOOL isExtendLayout;
//导航栏黑线
@property (nonatomic, strong) UIImageView *navBarHairlineImageView;

#pragma mark 重载
// 返回箭头事件默认处理，可重载自定义
- (void)back;

#pragma mark 界面切换

//不需要传参数的push 只需告诉类名字符串
- (void)pushViewControllerWithName:(id)classOrName;
//回到当前模块导航下的某一个页面
- (void)popToViewControllerWithClass:(id)classOrName;
//切到指定模块下
- (void)popToHomePageWithTabIndex:(NSInteger)index completion:(void (^)(void))completion;
@end
