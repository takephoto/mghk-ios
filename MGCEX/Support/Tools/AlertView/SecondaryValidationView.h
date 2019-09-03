// MGC
//
// SecondaryValidationView.h
// MGCEX
//
// Created by MGC on 2018/5/20.
// Copyright © 2018年 MGCion. All rights reserved.
//
// @ description <#描述#> 

#import <UIKit/UIKit.h>

//确定按钮点击事件
typedef void(^verifierSureBlock)(NSString * loginNum, NSString * password);

//取消按钮点击事件
typedef void(^cancelBlock)(void);


@interface SecondaryValidationView : UIView

@property(nonatomic,copy)cancelBlock cancel_block;
@property(nonatomic,copy)verifierSureBlock sure_block;

-(instancetype)initWithSupView:(UIView *)toView Title:(NSString *)title message:(NSString *)message coeType:(NSInteger )coeType sureBtnTitle:(NSString *)sureBtnTitle sureBtnClick:(verifierSureBlock)sureBlock cancelBtnClick:(cancelBlock)cancelBlock;

- (void)show;

-(void)hidden;

@end
