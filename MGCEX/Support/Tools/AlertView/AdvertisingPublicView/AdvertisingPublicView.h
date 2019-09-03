// MGC
//
// AdvertisingPublicView.h
// MGCEX
//
// Created by MGC on 2018/5/30.
// Copyright © 2018年 MGCion. All rights reserved.
//
// @ description <#描述#> 

#import <UIKit/UIKit.h>
#import "AdvertisingPublicViewModel.h"

//确定按钮点击事件
typedef void(^sureBlock)(NSString * password);

//取消按钮点击事件
typedef void(^cancelBlock)(void);

@interface AdvertisingPublicView : UIView

@property (nonatomic, strong) UILabel *msgLabel;
@property(nonatomic,copy)cancelBlock cancel_block;
@property(nonatomic,copy)sureBlock sure_block;
-(instancetype)initWithSupView:(UIView *)toView model:(AdvertisingPublicViewModel*)model sureBtnTitle:(NSString *)sureBtnTitle sureBtnClick:(sureBlock)sureBlock cancelBtnClick:(cancelBlock)cancelBlock;

- (void)show;

-(void)hidden;

@end
