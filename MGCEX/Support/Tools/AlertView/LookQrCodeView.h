// MGC
//
// LookQrCodeView.h
// MGCEX
//
// Created by MGC on 2018/6/4.
// Copyright © 2018年 MGCion. All rights reserved.
//
// @ description <#描述#> 

#import <UIKit/UIKit.h>

//确定按钮点击事件
typedef void(^sureBlock)(void);

//取消按钮点击事件
typedef void(^cancelBlock)(void);

@interface LookQrCodeView : UIView

@property(nonatomic,copy)cancelBlock cancel_block;
@property(nonatomic,copy)sureBlock sure_block;

-(instancetype)initWithSupView:(UIView *)toView imageUrl:(NSString *)imageUrl sureBtnClick:(sureBlock)sureBlock cancelBtnClick:(cancelBlock)cancelBlock;

- (void)show;

-(void)hidden;

@end
