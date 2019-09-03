// MGC
//
// IDCardPhotographView.h
// MGCEX
//
// Created by MGC on 2018/5/16.
// Copyright © 2018年 MGCion. All rights reserved.
//
// @ description <#描述#> 

#import "BaseView.h"
//上传图片按钮响应
typedef void(^TakeUpBtnBlock)(UIImageView *imageV);
//拍照上传
typedef void(^TakePictureBlock)(UIImageView *imageV);
//上一步
typedef void(^UpBtnBlock)(UIButton *button);
//下一步
typedef void(^NextBtnBlock)(UIButton *button);

@interface IDCardPhotographView : BaseView

@property (nonatomic, copy) TakeUpBtnBlock takeUpBtnBlock;
@property (nonatomic, copy) TakePictureBlock takePictureBlock;
@property (nonatomic, copy) UpBtnBlock upBtnBlock;
@property (nonatomic, copy) NextBtnBlock nextBtnBlock;

@property (nonatomic, strong) UIImageView * takeUpBtnImageV;
@property (nonatomic,strong) UIImageView * photographImageV;
@property (nonatomic, strong) UIButton * nextBtn;
/**
 *@param photograph 拍照按钮图片
 *@param titlemsg 标题
 */
-(id)initWithPhotograph:(NSString *)photograph titleLabel:(NSString *)titlemsg frame:(CGRect)frame;
@end
