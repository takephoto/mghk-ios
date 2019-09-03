// MGC
//
// DepthLinePositionModel.h
// 深度图demo
//
// Created by MGC on 2018/6/5.
// Copyright © 2018年 MGCion. All rights reserved.
//
// @ description <#描述#> 

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface DepthLinePositionModel : NSObject

@property (nonatomic,assign) CGFloat xPosition;
@property (nonatomic,assign) CGFloat yPosition;
@property (nonatomic,strong) UIColor *lineColor;

+ (instancetype)initPositon:(CGFloat)xPositon yPosition:(CGFloat)yPosition color:(UIColor*)color;

@end
