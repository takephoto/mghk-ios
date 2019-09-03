//
//  UIViewController+JLNavButton.h
//  MGCPay
//
//  Created by Joblee on 2017/11/2.
//  Copyright © 2017年 Joblee. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, NavigationBarStyle) {
    
    NavigationBarStyleWhite,//黑字白底
    NavigationBarStyleBlack,//白字黑底
    NavigationBarStyleModena //白字深紫色底
};

@interface UIViewController (JLNavButton)
///左侧一个图片按钮的情况
- (void)addLeftBarButtonWithImage:(UIImage *)image action:(SEL)action;

///左侧一个文字按钮的情况
- (void)addLeftBarButtonItemWithTitle:(NSString *)itemTitle action:(SEL)action;

///右侧一个图片按钮的情况
- (void)addRightBarButtonWithFirstImage:(UIImage *)firstImage action:(SEL)action;

///右侧一个文字按钮的情况
- (void)addRightBarButtonItemWithTitle:(NSString *)itemTitle action:(SEL)action;

///标题颜色 导航颜色 状态栏样式
- (void)setNavBarWithTextColor:(UIColor *)textColor barTintColor:(UIColor *)barTintColor tintColor:(UIColor *)tintColor statusBarStyle:(UIStatusBarStyle)style;
//标题颜色 导航颜色  返回按钮图片 状态栏样式
- (void)setNavBarWithTextColor:(UIColor *)textColor barTintColor:(UIColor *)barTintColor backBtnImg:(UIImage *)img statusBarStyle:(UIStatusBarStyle)style;
//设置navBar 类型 是否需要backBtn
- (void)setNavBarStyle:(NavigationBarStyle)style backBtn:(BOOL)need;

#pragma mark 左边按钮定制,可以扩大响应范围

/**
 *  自定义左边按钮
 *
 *  @param icon     图标 非必填
 *  @param title    标题 非必填
 *  @param titleColor 标题颜色 非必填
 *  @param selector 事件
 */
- (void)setLeftItemWithIcon:(UIImage *)icon title:(NSString *)title titleColor:(UIColor *)titleColor selector:(SEL)selector;
#pragma mark 右边按钮定制
/**
 *  通过文字设置右侧导航按钮
 *
 *  @param title    文字
 *  @param selector 事件
 */
- (void)setRightItemWithTitle:(NSString *)title selector:(SEL)selector;
/**
 *  通过ico定制右侧按钮
 *
 *  @param icon     图标
 *  @param selector 事件
 */
- (void)setRightItemWithIcon:(UIImage *)icon selector:(SEL)selector;

@end
