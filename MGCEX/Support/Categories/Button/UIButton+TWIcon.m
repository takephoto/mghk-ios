// MGC
//
// UIButton+TWIcon.m
// categortdemo
//
// Created by MGC on 2017/10/24.
// Copyright © 2017年 MGCion. All rights reserved.
//
// @ description <#描述#> 

#import "UIButton+TWIcon.h"
#import <objc/runtime.h>



@implementation UIButton (TWIcon)

-(void)setShowDele:(BOOL)showDele
{
    if(self.DeleImageV)
    {
     self.DeleImageV.hidden = showDele? NO:YES;
    }
    
    if(showDele&&self.DeleImageV)
    {
        [self shakingAnimation];
    }
    else
    {
        [self.layer removeAllAnimations];
    }
    NSNumber * number = [NSNumber numberWithBool:showDele];
    objc_setAssociatedObject(self, @selector(showDele), number, OBJC_ASSOCIATION_ASSIGN);
}

-(BOOL)showDele
{
    NSNumber * number = objc_getAssociatedObject(self, @selector(showDele));
    return number.boolValue;
}

-(void)setShowIcon:(BOOL)showIcon
{
    if(self.IconImageV)
    {
       self.IconImageV.hidden = showIcon? NO:YES;
    }
    
    NSNumber * number = [NSNumber numberWithBool:showIcon];
    objc_setAssociatedObject(self, @selector(showIcon), number, OBJC_ASSOCIATION_ASSIGN);
}

-(BOOL)showIcon
{
    NSNumber * number = objc_getAssociatedObject(self, @selector(showIcon));
    return number.boolValue;
}

-(UIImageView *)IconImageV
{
    return objc_getAssociatedObject(self, @selector(IconImageV));
}

-(void)setIconImageV:(UIImageView *)IconImageV
{
    objc_setAssociatedObject(self, @selector(IconImageV), IconImageV, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

-(void)setActionBlock:(ActionBlock)actionBlock
{
    objc_setAssociatedObject(self, @selector(actionBlock), actionBlock, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

-(ActionBlock)actionBlock
{
   return  objc_getAssociatedObject(self, @selector(actionBlock));
}


-(void)setDeleImageV:(UIImage *)DeleImageV
{
    objc_setAssociatedObject(self, @selector(DeleImageV), DeleImageV, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

-(UIImage *)DeleImageV
{
    return objc_getAssociatedObject(self, @selector(DeleImageV));
}

-(void)mg_addDeleBtnWithImage:(UIImage *)image size:(CGSize )size ActionBlock:(ActionBlock )block;
{

    if(!self.DeleImageV)
    {
        self.DeleImageV = [[UIImageView alloc]initWithFrame:CGRectMake(self.frame.size.width-size.width, 0, size.width, size.height)];
        self.DeleImageV.image = image;
        [self addSubview:self.DeleImageV];
        self.DeleImageV.hidden = YES;
        self.DeleImageV.userInteractionEnabled = YES;
        UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapRightTopIcon:)];
        [self.DeleImageV addGestureRecognizer:tap];
        self.actionBlock = block;
    }

    self.DeleImageV.image = image;
}

-(void)tapRightTopIcon:(UIGestureRecognizer *)tap
{
    if(self.actionBlock)
    {
        self.actionBlock((UIButton *)tap.view.superview);
    }
    
}

-(void)mg_showDeleBtn:(BOOL)show Animate:(BOOL)Animate;
{
    self.DeleImageV.hidden = show? NO:YES;
    if(show==NO)
    {
        //停止抖动
        [self.layer removeAllAnimations];
        
    }
    else if(show==YES&&Animate==YES)
    {
        //开始抖动，并显示图标
        [self shakingAnimation];
    }
   
}

#pragma mark - 抖动动画
#define Angle2Radian(angle) ((angle) / 180.0 * M_PI)
- (void)shakingAnimation {
    CAKeyframeAnimation *anim = [CAKeyframeAnimation animation];
    anim.keyPath = @"transform.rotation";
    
    anim.values = @[@(Angle2Radian(-5)), @(Angle2Radian(5)), @(Angle2Radian(-5))];
    anim.duration = 0.25;
    
    // 动画次数设置为最大
    anim.repeatCount = MAXFLOAT;
    // 保持动画执行完毕后的状态
    anim.removedOnCompletion = NO;
    anim.fillMode = kCAFillModeForwards;
    
    [self.layer addAnimation:anim forKey:@"shake"];
}

/**
 * 删除删除按钮
 */
-(void)mg_deleDeleImageV;
{
    [self.DeleImageV removeFromSuperview];
}


//////-------------------  内嵌角标  ------------------------------///////


-(void)mg_addIconWithimage:(UIImage *)image size:(CGSize )size type:(TWIconPositionStyle)type;
{
    switch (type) {
        case TWIconRightTop:
        {
             if(!self.IconImageV)
             {
                 self.IconImageV = [[UIImageView alloc]initWithFrame:CGRectMake(self.frame.size.width-size.width, 0, size.width, size.height)];
               
             }
            
            
        }
            break;
        case TWIconRightBottom:
        {
            if(!self.IconImageV)
            {
                self.IconImageV = [[UIImageView alloc]initWithFrame:CGRectMake(self.frame.size.width-size.width, self.frame.size.height-size.height, size.width, size.height)];
                
            }
           
        }
            break;
        case TWIconLeftTop:
        {
            if(!self.IconImageV)
            {
                self.IconImageV = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, size.width, size.height)];
                
            }
        }
            break;
        case TWIconLeftBottom:
        {
            if(!self.IconImageV)
            {
                self.IconImageV = [[UIImageView alloc]initWithFrame:CGRectMake(0, self.frame.size.height-size.height, size.width, size.height)];
                
            }
        }
            break;
            
        default:
            break;
    }
    
    [self addSubview:self.IconImageV];
    self.IconImageV.image = image;
    self.IconImageV.hidden = YES;
    
}

/**
 * 删除所有角标（不包括上面的删除按钮）
 */
-(void)mg_deleIcon;
{
    [self.IconImageV removeFromSuperview];
}


@end
