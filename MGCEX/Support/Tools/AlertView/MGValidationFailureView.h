// MGC
//
// MGValidationFailureView.h
// MGCEX
//
// Created by MGC on 2018/7/3.
// Copyright © 2018年 MGCion. All rights reserved.
//
// @ description <#描述#> 

#import <UIKit/UIKit.h>

//确定按钮点击事件
typedef void(^sureBlock)(void);
//取消按钮点击事件
typedef void(^cancelBlock)(void);


@interface MGValidationFailureView : UIView


@property(nonatomic,copy)sureBlock sure_block;
@property(nonatomic,copy)cancelBlock cancel_block;

-(instancetype)initWithMessage:(NSString *)message sureBtnClick:(sureBlock)sureBlock cancelBtnClick:(cancelBlock)cancelBlock;


- (void)show;

-(void)hidden;

@end
