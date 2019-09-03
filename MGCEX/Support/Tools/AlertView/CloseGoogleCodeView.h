// MGC
//
// CloseGoogleCodeView.h
// MGCEX
//
// Created by MGC on 2018/5/19.
// Copyright © 2018年 MGCion. All rights reserved.
//
// @ description 验证谷歌

#import <UIKit/UIKit.h>

@interface CloseGoogleCodeView : UIView
//确定按钮点击事件
typedef void(^sure2Block)(NSString * password, NSString * code);
//取消按钮点击事件
typedef void(^cancelBlock)(void);

@property(nonatomic,copy)cancelBlock cancel_block;
@property(nonatomic,copy)sure2Block sure_block;
-(instancetype)initWithSupView:(UIView *)toView Title:(NSString *)title message:(NSString *)message placeholder:(NSString *)placeholder sureBtnTitle:(NSString *)sureBtnTitle sureBtnClick:(sure2Block)sureBlock cancelBtnClick:(cancelBlock)cancelBlock;

- (void)show;

-(void)hidden;
@end
