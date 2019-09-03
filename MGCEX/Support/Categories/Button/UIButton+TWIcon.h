// MGC
//
// UIButton+TWIcon.h
// categortdemo
//
// Created by MGC on 2017/10/24.
// Copyright © 2017年 MGCion. All rights reserved.
//
// @ description 内嵌角标 和 删除按钮

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, TWIconPositionStyle){
    TWIconRightTop = 0,            //右上角
    TWIconRightBottom = 1,           //右下角
    TWIconLeftTop = 2,             //左上角
    TWIconLeftBottom = 3,          //左下角
};

typedef void (^ActionBlock)(UIButton * button);

@interface UIButton (TWIcon)

//显示，隐藏删除按钮。显示图标时默认开启抖动动画
@property(nonatomic,assign) BOOL showDele;
//显示，隐藏角标
@property(nonatomic,assign) BOOL showIcon;
//内嵌角标(比如勾)
@property(nonatomic,strong) UIImageView * IconImageV;
//删除按钮的ImageView
@property(nonatomic,strong) UIImageView * DeleImageV;
//点击删除响应
@property(nonatomic,copy) ActionBlock actionBlock;

/**
 * 右上角添加图标（删除按钮） 添加后默认是隐藏的状态
 *@param image 图标image
 *@param size 图标大小
 */
-(void)mg_addDeleBtnWithImage:(UIImage *)image size:(CGSize )size ActionBlock:(ActionBlock )block;

/**
 * 显示或隐藏图标，若不想抖动，则 Animate= no。
 * showDele 属性可以显示和隐藏图标.但是显示时默认为抖动动画
 *@param show 是否显示图标yes：开启，no：关闭 。Animate：按钮是否抖动
 *@param Animate 按钮是否抖动
 */
-(void)mg_showDeleBtn:(BOOL)show Animate:(BOOL)Animate;
/**
 * 删除删除按钮,
 */
-(void)mg_deleDeleImageV;

/////------------------------------------------//////

/**
 * 添加内嵌图标 添加后默认隐藏图标
 * showIcon 属性可以显示和隐藏图标
 *@param image
 *@param size 图标大小
 *@param type 枚举
 */
-(void)mg_addIconWithimage:(UIImage *)image size:(CGSize )size type:(TWIconPositionStyle)type;

/**
 * 删除角标（不包括上面的删除按钮）
 */
-(void)mg_deleIcon;


@end
