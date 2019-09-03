// MGC
//
// TWSlider.m
// MGCEX
//
// Created by MGC on 2018/6/20.
// Copyright © 2018年 MGCion. All rights reserved.
//
// @ description <#描述#> 

#import "TWSlider.h"

@implementation TWSlider

- (CGRect)thumbRectForBounds:(CGRect)bounds trackRect:(CGRect)rect value:(float)value
{
    //y轴方向改变手势范围
    rect.origin.y = rect.origin.y - Adapted(10);
    rect.size.height = rect.size.height + Adapted(20);
    rect.origin.x = rect.origin.x - Adapted(10);
    rect.size.width = rect.size.width + Adapted(20);
    return CGRectInset ([super thumbRectForBounds:bounds trackRect:rect value:value], 10 ,10);
}

@end
