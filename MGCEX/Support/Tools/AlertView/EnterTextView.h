// MGC
//
// EnterTextView.h
// MGCEX
//
// Created by MGC on 2018/5/19.
// Copyright © 2018年 MGCion. All rights reserved.
//
// @ description 验证登录密码 

#import "BaseView.h"
//确定按钮点击事件
typedef void(^sureBlock)(NSString * password);

//取消按钮点击事件
typedef void(^cancelBlock)(void);

@interface EnterTextView : BaseView

@property (nonatomic, strong) UITextField * enterText;
@property(nonatomic,copy)cancelBlock cancel_block;
@property(nonatomic,copy)sureBlock sure_block;
-(instancetype)initWithSupView:(UIView *)toView Title:(NSString *)title message:(NSString *)message placeholder:(NSString *)placeholder sureBtnTitle:(NSString *)sureBtnTitle sureBtnClick:(sureBlock)sureBlock cancelBtnClick:(cancelBlock)cancelBlock;



- (void)show;

-(void)hidden;
@end
