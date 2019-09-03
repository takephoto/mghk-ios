// MGC
//
// TTWHUD.m
// AFNNetworkingDemo
//
// Created by MGC on 2018/2/23.
// Copyright © 2018年 MGCion. All rights reserved.
//
// @ description <#描述#> 

#import "TTWHUD.h"

#define TIME_OUT 2.0

@implementation TTWHUD



/**
 *  自定义图片的提示，1s后自动消息
 *
 *  @param title 要显示的文字
 *  @param iconName 图片地址(建议不要太大的图片)
 *  @param view 要添加的view
 */
+ (void)showCustomIcon:(NSString *)iconName title:(NSString *)title toView:(UIView *)view
{
    
    __block typeof(view) weakself = view;
    dispatch_async(dispatch_get_main_queue(), ^{
    if (weakself == nil) weakself = (UIView*)[UIApplication sharedApplication].delegate.window;
        // 快速显示一个提示信息
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:weakself animated:YES];
        hud.label.text = title;
        // 设置图片
        if ([iconName isEqualToString:@"error.png"] || [iconName isEqualToString:@"success.png"]) {
            hud.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:[NSString stringWithFormat:@"MBProgressHUD.bundle/%@", iconName]]];
        }else{
            hud.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:iconName]];
        }
        // 再设置模式
        hud.mode = MBProgressHUDModeCustomView;
        hud.userInteractionEnabled = NO;
        // 隐藏时候从父控件中移除
        hud.removeFromSuperViewOnHide = YES;
        
        // 1秒之后再消失
        [hud hideAnimated:YES afterDelay:1.5];
        
    });
    

}

/**
 *  自动消失成功提示，带默认图
 *
 *  @param title 要显示的文字
 *  @param view    要添加的view
 */
+ (void)showSuccess:(NSString *)title toView:(UIView *)view
{
    dispatch_async(dispatch_get_main_queue(), ^{
        [[UIApplication sharedApplication].keyWindow endEditing:YES];
      [self showCustomIcon:@"success.png" title:title toView:view];
    });
    
}
/**
 *  自动消失错误提示,带默认图
 *
 *  @param title 要显示的错误文字
 *  @param view  要添加的View
 */
+ (void)showError:(NSString *)title toView:(UIView *)view{
    dispatch_async(dispatch_get_main_queue(), ^{
        [self showCustomIcon:@"error.png" title:title toView:view];
    });
    
}

/**
 *  文字+菊花提示,不自动消失
 *
 *  @param message 要显示的文字
 *  @param view    要添加的View
 */
+ (void)showMessage:(NSString *)message toView:(UIView *)view{

    __block typeof(view) weakself = view;
    dispatch_async(dispatch_get_main_queue(), ^{
      if (weakself == nil) weakself = (UIView*)[UIApplication sharedApplication].delegate.window;
        // 快速显示一个提示信息
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:weakself animated:YES];
        hud.label.text = message;
        // 隐藏时候从父控件中移除
        hud.removeFromSuperViewOnHide = YES;
  
    });
    
    
}

//快速显示一条提示信息
+ (void)showAutoMessage:(NSString *)message{
    dispatch_async(dispatch_get_main_queue(), ^{
      [self showAutoMessage:message toView:nil];
    });
    
}

/**
 *  自定义纯文字提示，2s后自动消失(自定义),显示在window中
 */
+ (void)showCustomMsg:(NSString *)msg{

    dispatch_async(dispatch_get_main_queue(), ^{
      
        // 快速显示一个提示信息
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:[UIApplication sharedApplication].delegate.window animated:YES];
        hud.bezelView.style = MBProgressHUDBackgroundStyleSolidColor;
        hud.detailsLabel.text = msg;
        hud.detailsLabel.font = H15;
        hud.bezelView.backgroundColor = kLineColor;
        hud.bezelView.layer.cornerRadius = Adapted(23);
        hud.userInteractionEnabled = NO;
        //模式
        hud.mode = MBProgressHUDModeText;
        // 隐藏时候从父控件中移除
        hud.removeFromSuperViewOnHide = YES;
        // 隐藏时候从父控件中移除
        hud.removeFromSuperViewOnHide = YES;
        // X秒之后再消失
        [hud hideAnimated:YES afterDelay:2.0];
        hud.alpha = 0.9;
        hud.detailsLabel.textColor = kTextColor;
        hud.animationType = MBProgressHUDAnimationZoomOut;
        hud.margin = Adapted(15);
        [hud setOffset:CGPointMake(0, MAIN_SCREEN_HEIGHT/3.0)];
        


    });
    
}

/**
 *  自动消失提示，无图
 *
 *  @param message 要显示的文字
 *  @param view    要添加的View
 */
+ (void)showAutoMessage:(NSString *)message toView:(UIView *)view{
    dispatch_async(dispatch_get_main_queue(), ^{
       [self showMessage:message toView:view RemainTime:TIME_OUT Model:MBProgressHUDModeText];
    });
    
}

+(void)showMessage:(NSString *)message toView:(UIView *)view RemainTime:(CGFloat)time Model:(MBProgressHUDMode)model{
    __block typeof(view) weakself = view;
    
    dispatch_async(dispatch_get_main_queue(), ^{
        if (weakself == nil) weakself = (UIView*)[UIApplication sharedApplication].delegate.window;
        
        // 快速显示一个提示信息
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:weakself animated:YES];
        hud.bezelView.style = MBProgressHUDBackgroundStyleSolidColor;
        hud.label.text = message;
        hud.bezelView.backgroundColor = [UIColor blackColor];
        hud.bezelView.layer.cornerRadius = Adapted(23);

        //模式
        hud.mode = model;
        // 隐藏时候从父控件中移除
        hud.removeFromSuperViewOnHide = YES;
        // 隐藏时候从父控件中移除
        hud.removeFromSuperViewOnHide = YES;
        // X秒之后再消失
        [hud hideAnimated:YES afterDelay:time];
        hud.alpha = 0.9;
        hud.label.textColor = white_color;
        hud.animationType = MBProgressHUDAnimationZoomOut;
        hud.minSize = CGSizeMake(MAIN_SCREEN_WIDTH, 25);
        hud.margin = Adapted(15);
        [hud setOffset:CGPointMake(0, MAIN_SCREEN_HEIGHT/3.0)];
        /*
         MBProgressHUDAnimationFade,    // 淡入、淡出模式
         MBProgressHUDAnimationZoomOut  // 淡入、淡出 + 缩小消失
         MBProgressHUDAnimationZoomIn   // 淡入、淡出 + 放大消失
         */
        
        //hud.color = [UIColor redColor]; //背景颜色
        // HUD的相对于父视图 x 的偏移，默认居中
        //[hud setOffset:CGPointMake(10, 10)];
    });
    
    
}

/**
 *  自定义停留时间，有图
 *
 *  @param message 要显示的文字
 *  @param view    要添加的View
 *  @param time    停留时间
 */
+(void)showIconMessage:(NSString *)message toView:(UIView *)view remainTime:(CGFloat)time{
    dispatch_async(dispatch_get_main_queue(), ^{
        [self showMessage:message toView:view RemainTime:time Model:MBProgressHUDModeIndeterminate];
    });
    
}

/**
 *  自定义停留时间，无图
 *
 *  @param message 要显示的文字
 *  @param view 要添加的View
 *  @param time 停留时间
 */
+(void)showMessage:(NSString *)message toView:(UIView *)view remainTime:(CGFloat)time{
    dispatch_async(dispatch_get_main_queue(), ^{
        [self showMessage:message toView:view RemainTime:time Model:MBProgressHUDModeText];
    });
    
}

/**
 *  进度条View
 */
+(void)showProgressToView:(UIView *)view ProgressModel:(MBProgressHUDMode)model Text:(NSString *)text{
    
    __block typeof(view) weakself = view;
    dispatch_async(dispatch_get_main_queue(), ^{
        if (weakself == nil) weakself = (UIView*)[UIApplication sharedApplication].delegate.window;
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:weakself animated:YES];
        hud.mode = model;
        hud.label.text = text;
       
    });
    
    
}

//加载视图
+(void)showLoadToView:(UIView *)view{
    
    dispatch_async(dispatch_get_main_queue(), ^{
      [self showMessage:@"Loading..." toView:view];
    });
    
}

+ (void)hideHUDForView:(UIView *)view
{
    __block typeof(view) weakself = view;
    
    dispatch_async(dispatch_get_main_queue(), ^{
        if (weakself == nil) weakself = (UIView*)[UIApplication sharedApplication].delegate.window;
        [self hideHUDForView:weakself animated:YES];
    });
    
}

+ (void)hideHUD
{
    dispatch_async(dispatch_get_main_queue(), ^{
       [self hideHUDForView:nil];
    });
    
}
@end
