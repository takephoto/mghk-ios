// MGC
//
// TTWColorMacro.h
// kachi
//
// Created by MGC on 2017/12/28.
// Copyright © 2017年 qw. All rights reserved.
//
// @ description <#描述#> 

#ifndef TTWColorMacro_h
#define TTWColorMacro_h

/// 颜色(RGB)
#define RGBCOLOR(r, g, b)       [UIColor colorWithRed:(r)/255.0f green:(g)/255.0f blue:(b)/255.0f alpha:1]
/// 颜色(RGB)透明度
#define RGBACOLOR(r, g, b, a)   [UIColor colorWithRed:(r)/255.0f green:(g)/255.0f blue:(b)/255.0f alpha:(a)]

//rgb颜色转换（十六进制>>十进制）
#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

//rgb颜色转换（十六进制>>十进制）透明度
#define UIColorFromRGBA(rgbValue,a) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:(a)]

//rbg颜色转换（十六进制字符串>>十进制）
#define UIColorFromRGBString(rgbValueString) UIColorFromRGB(strtoul([rgbValueString UTF8String], 0, 0))

///常用颜色
#define black_color     [UIColor blackColor]
#define blue_color      [UIColor blueColor]
#define brown_color     [UIColor brownColor]
#define clear_color     [UIColor clearColor]
#define darkGray_color  [UIColor darkGrayColor]
#define darkText_color  [UIColor darkTextColor]
#define white_color     [UIColor whiteColor]
#define yellow_color    [UIColor yellowColor]
#define red_color       [UIColor redColor]
#define orange_color    [UIColor orangeColor]
#define purple_color    [UIColor purpleColor]
#define lightText_color [UIColor lightTextColor]
#define lightGray_color [UIColor lightGrayColor]
#define green_color     [UIColor greenColor]
#define gray_color      [UIColor grayColor]
#define magenta_color   [UIColor magentaColor]


#define kMaskColor [UIColor colorWithRed:((float)((0x000000 & 0xFF0000) >> 16))/255.0 \
green:((float)((0x000000 & 0xFF00) >> 8))/255.0 \
blue:((float)(0x000000 & 0xFF))/255.0 \
alpha:0.5]

///主题色（黄色）
#define kMainColor [UIColor colorWithHexString:@"#F7B700"]

///背景颜色
#define kBackGroundColor [UIColor colorWithHexString:@"#f7f9fc"]
///主红颜色
#define kRedColor [UIColor colorWithHexString:@"#f73535"]
#define kDisableRedColor [UIColor colorWithHexString:@"#FFC4C4"]
///主绿颜色
#define kGreenColor [UIColor colorWithHexString:@"#0fc055"]
///灰色背景颜色
#define kBgGrayColor [UIColor colorWithRed:227/250.0f green:227/250.0f blue:227/250.0f alpha:1]
///首页内容区域底色
#define kBackAssistColor [UIColor colorWithHexString:@"#ffffff"]
///首页内容区域底色
#define kTextBlackColor [UIColor colorWithHexString:@"#2b2c2f"]
//正文色,黑色
#define kTextColor [UIColor colorWithHexString:@"#202020"]
//文字辅助 浅灰
#define kAssistTextColor [UIColor colorWithHexString:@"#666666"]
//辅助正文色
#define kAssistColor [UIColor colorWithHexString:@"#A6A6A6"]
//极淡分割线
#define kSLineClolor [UIColor colorWithHexString:@"#E5E5E5"];
//偏灰分割线
#define kLineColor [UIColor colorWithHexString:@"#DCDCDC"]
//偏黑分割线
#define kLineAssistColor [UIColor colorWithHexString:@"#393a3d"]
//导航颜色
//#define kNavTintColor [UIColor colorWithHexString:@"#212226"]
#define kNavTintColor [UIColor colorWithHexString:@"#F7F7F7"]
//999999颜色(灰色字体)
#define k99999Color [UIColor colorWithHexString:@"#999999"]

//币种详情界面
#define kKLineBGColor [UIColor colorWithHexString:@"#09193F"]

#endif /* TTWColorMacro_h */
