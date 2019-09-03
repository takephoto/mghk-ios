// MGC
//
// TTWMacro.h
// kachi
//
// Created by MGC on 2017/12/28.
// Copyright © 2017年 qw. All rights reserved.
//
// @ description <#描述#> 

#ifndef TTWMacro_h
#define TTWMacro_h

#define kFileManager [NSFileManager defaultManager]
#define kUserDefaults   [NSUserDefaults standardUserDefaults]

#define KWeakSelf __weak typeof(self) weakSelf = self;
#define KStrongSelf __strong typeof(self) strongSelf = self;
#define kWeakRefrence(type)  __weak typeof(type) weak##type = type
#define kWindow         [(AppDelegate *)[UIApplication sharedApplication].delegate mainWindow]


// 获取屏幕 宽度、高度 bounds就是屏幕的全部区域
#define MAIN_SCREEN_WIDTH ([UIScreen mainScreen].bounds.size.width)
#define MAIN_SCREEN_HEIGHT ([UIScreen mainScreen].bounds.size.height)
#define MAIN_SCREEN_BOUNDS [[UIScreen mainScreen] bounds]

//以iphone6 为准
#define kAutoWidthRatio (MAIN_SCREEN_WIDTH / 375.0)
#define kAutoHeightRatio ((IS_IPHONEX ? (MAIN_SCREEN_HEIGHT - SafeAreaBottomHeight - kStatusBarHeight) : MAIN_SCREEN_HEIGHT) / 667.0)
#define Adapted(x) (x * kAutoWidthRatio)
//#define AdaptedW(x) (x * kAutoWidthRatio)
//#define AdaptedH(x) (x * kAutoHeightRatio)



///系统导航和tabbar高度
#define TW_StatusBarHeight [[UIApplication sharedApplication] statusBarFrame].size.height //状态栏高度
#define TW_NavBarHeight 44.0
#define TW_TabBarHeight ([[UIApplication sharedApplication] statusBarFrame].size.height>20?83:49) //底部tabbar高度
#define TW_TopHeight (TW_StatusBarHeight + TW_NavBarHeight) //整个导航栏高度

#pragma mark - 系统控件默认高度

#define kStatusBarHeight       (IS_IPHONEX ? (44.0f) : (20.f))

#define kTopBarHeight           (44.f)
#define kBottomBarHeight        (49.f)
#define SafeAreaBottomHeight (IS_IPHONEX ? 34.0f : 0)

#define kCellDefaultHeight      (44.f)

#define kEnglishKeyboardHeight  (216.f)
#define kChineseKeyboardHeight  (252.f)


/// View 坐标(x,y)和宽高(width,height)
#define X(v)                    (v).frame.origin.x
#define Y(v)                    (v).frame.origin.y
#define WIDTH(v)                (v).frame.size.width
#define HEIGHT(v)               (v).frame.size.height

#define MinX(v)                 CGRectGetMinX((v).frame)
#define MinY(v)                 CGRectGetMinY((v).frame)

#define MidX(v)                 CGRectGetMidX((v).frame)
#define MidY(v)                 CGRectGetMidY((v).frame)

#define MaxX(v)                 CGRectGetMaxX((v).frame)
#define MaxY(v)                 CGRectGetMaxY((v).frame)

#define CenterX(v)              (v).center.x
#define CenterY(v)              (v).center.y
///网络请求状态
#define MGStatus(response) [[response objectForKey:@"code"] integerValue]
///错误提示
#define MGMsg(response) [response objectForKey:@"msg"]


#endif /* TTWMacro_h */
