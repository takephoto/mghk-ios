// MGC
//
// TTWHUD.h
// AFNNetworkingDemo
//
// Created by MGC on 2018/2/23.
// Copyright © 2018年 MGCion. All rights reserved.
//
// @ description <#描述#> 

#import <MBProgressHUD/MBProgressHUD.h>


@interface TTWHUD : MBProgressHUD


/**
 *  自定义纯文字提示，2s后自动消失(自定义),显示在window中
 */
+ (void)showCustomMsg:(NSString *)msg;

/**
 *  自定义图片的提示，2s后自动消失(自定义)
 *
 *  @param title 要显示的文字
 *  @param iconName 图片地址(建议不要太大的图片)
 *  @param view 要添加的view
 */
+ (void)showCustomIcon:(NSString *)iconName title:(NSString *)title toView:(UIView *)view;

/**
 *  自动消失成功提示，带默认图(一般用来上传成功)
 *
 *  @param title 要显示的文字
 *  @param view    要添加的view
 */
+ (void)showSuccess:(NSString *)title toView:(UIView *)view;

/**
 *  自动消失错误提示,带默认图(一般用来上传失败)
 *
 *  @param title 要显示的错误文字
 *  @param view  要添加的View
 */
+ (void)showError:(NSString *)title toView:(UIView *)view;

/**
 *  文字+菊花提示,不自动消失(加载中。。。)
 *
 *  @param message 要显示的文字
 *  @param view    要添加的View
 */
+ (void)showMessage:(NSString *)message toView:(UIView *)view;

/**
 *  快速显示一条提示信息,自动消失(提示文字，比如“请先注册”)
 *
 *  @param message 要显示的文字
 */
+ (void)showAutoMessage:(NSString *)message;

/**
 *  自动消失提示，无图(提示文字，比如“请先注册”)
 *
 *  @param message 要显示的文字
 *  @param view    要添加的View
 */
+ (void)showAutoMessage:(NSString *)message toView:(UIView *)view;

/**
 *  自定义停留时间，有图(带菊花和文字，自动消失)
 *
 *  @param message 要显示的文字
 *  @param view    要添加的View
 *  @param time    停留时间
 */
+(void)showIconMessage:(NSString *)message toView:(UIView *)view remainTime:(CGFloat)time;

/**
 *  自定义停留时间，无图
 *
 *  @param message 要显示的文字
 *  @param view 要添加的View
 *  @param time 停留时间
 */
+(void)showMessage:(NSString *)message toView:(UIView *)view remainTime:(CGFloat)time;

/**
 *  加载视图
 *
 *  @param view 要添加的View
 */
+ (void)showLoadToView:(UIView *)view;

/**
 *  进度条View（图片视频上传进度或者下载进度）
 *
 *  @param view     要添加的View
 *  @param model    进度条的样式
 *  @param text     显示的文字
 */
+ (void)showProgressToView:(UIView *)view ProgressModel:(MBProgressHUDMode)model Text:(NSString *)text;


/**
 *  隐藏ProgressView
 *
 *  @param view superView
 */
+ (void)hideHUDForView:(UIView *)view;


/**
 *  快速从window中隐藏ProgressView
 */
+ (void)hideHUD;
@end
