// MGC
//
// DepthLinePositionModel.m
// 深度图demo
//
// Created by MGC on 2018/6/5.
// Copyright © 2018年 MGCion. All rights reserved.
//
// @ description <#描述#> 

#import "DepthLinePositionModel.h"

@implementation DepthLinePositionModel


+(instancetype)initPositon:(CGFloat)xPositon yPosition:(CGFloat)yPosition color:(UIColor*)color
{
    DepthLinePositionModel *model = [[DepthLinePositionModel alloc] init];
    model.xPosition = xPositon;
    model.yPosition = yPosition;
    model.lineColor = color;
    return model;
}
@end
