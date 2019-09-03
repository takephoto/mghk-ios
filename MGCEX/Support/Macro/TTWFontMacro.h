// MGC
//
// TTWFontMacro.h
// kachi
//
// Created by MGC on 2017/12/28.
// Copyright © 2017年 qw. All rights reserved.
//
// @ description <#描述#> 

#ifndef TTWFontMacro_h
#define TTWFontMacro_h

#import "TTWMacro.h"

#define FONT_TING(FONTSIZE) [UIFont systemFontOfSize:KWidth(FONTSIZE)]

//#define FONT_TING(FONTSIZE) FONT(IS_IOS9_Before ? @".PingFang-SC-Regular" : @"PingFangSC-Regular", FONTSIZE)

//字体
#define FONT(NAME, FONTSIZE)    [UIFont fontWithName:(NAME) size:KWidth(FONTSIZE)]

//正常字体
#define H30 [UIFont systemFontOfSize:Adapted(30)]
#define H29 [UIFont systemFontOfSize:Adapted(29)]
#define H28 [UIFont systemFontOfSize:Adapted(28)]
#define H27 [UIFont systemFontOfSize:Adapted(27)]
#define H26 [UIFont systemFontOfSize:Adapted(26)]
#define H25 [UIFont systemFontOfSize:Adapted(25)]
#define H24 [UIFont systemFontOfSize:Adapted(24)]
#define H23 [UIFont systemFontOfSize:Adapted(23)]
#define H22 [UIFont systemFontOfSize:Adapted(22)]
#define H20 [UIFont systemFontOfSize:Adapted(20)]
#define H19 [UIFont systemFontOfSize:Adapted(19)]
#define H18 [UIFont systemFontOfSize:Adapted(18)]
#define H17 [UIFont systemFontOfSize:Adapted(17)]
#define H16 [UIFont systemFontOfSize:Adapted(16)]
#define H15 [UIFont systemFontOfSize:Adapted(15)]
#define H14 [UIFont systemFontOfSize:Adapted(14)]
#define H13 [UIFont systemFontOfSize:Adapted(13)]
#define H12 [UIFont systemFontOfSize:Adapted(12)]
#define H11 [UIFont systemFontOfSize:Adapted(11)]
#define H10 [UIFont systemFontOfSize:Adapted(10)]
#define H8 [UIFont systemFontOfSize:Adapted(8)]
#define H7 [UIFont systemFontOfSize:Adapted(7)]
#define H6 [UIFont systemFontOfSize:Adapted(6)]

///粗体
#define HB20 [UIFont boldSystemFontOfSize:Adapted(20)]
#define HB18 [UIFont boldSystemFontOfSize:Adapted(18)]
#define HB17 [UIFont boldSystemFontOfSize:Adapted(17)]
#define HB16 [UIFont boldSystemFontOfSize:Adapted(16)]
#define HB14 [UIFont boldSystemFontOfSize:Adapted(14)]
#define HB15 [UIFont boldSystemFontOfSize:Adapted(15)]
#define HB13 [UIFont boldSystemFontOfSize:Adapted(13)]
#define HB12 [UIFont boldSystemFontOfSize:Adapted(12)]
#define HB11 [UIFont boldSystemFontOfSize:Adapted(11)]
#define HB10 [UIFont boldSystemFontOfSize:Adapted(10)]
#define HB8 [UIFont boldSystemFontOfSize:Adapted(8)]

///方正黑体简体字体定义
#define FONT_SDGothicNeo(F)    [UIFont fontWithName:@"AppleSDGothicNeo-Regular" size:F]
#define FONTMic(F)                 [UIFont fontWithName:@"MicrosoftYaHei" size:F]

///字体加粗
#define FontBig(F) [UIFont fontWithName:@"Helvetica-Bold" size:F]

#endif /* TTWFontMacro_h */
