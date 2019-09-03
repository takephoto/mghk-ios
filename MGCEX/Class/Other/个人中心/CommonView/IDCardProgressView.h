// MGC
//
// IDCardProgressView.h
// MGCEX
//
// Created by MGC on 2018/5/16.
// Copyright © 2018年 MGCion. All rights reserved.
//
// @ description <#描述#> 

#import "BaseView.h"

/**
 * 进度页面
 *@param step  步骤
 *@param style 1 身份证认证  2:护照认证
 */
@interface IDCardProgressView : BaseView
-(id)initWithImage:(NSString *)imageName step:(NSInteger )step style:(NSInteger)style frame:(CGRect)frame;
@end
