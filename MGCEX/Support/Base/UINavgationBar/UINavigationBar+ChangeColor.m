// MGC
//
// SearchTableViewController.m
// MGCPay
//
// Created by MGC on 2017/12/19.
// Copyright © 2017年 Joblee. All rights reserved.
//
// @ description 改变导航透明度

#import "UINavigationBar+ChangeColor.h"

@implementation UINavigationBar (ChangeColor)


- (void)star {
    UIImageView *shadowImg = [self findNavLineImageViewOn:self];
    shadowImg.hidden = YES;
    [self setBackgroundColor:nil];
}

- (void)changeColor:(UIColor *)color WithScrollView:(UIScrollView *)scrollView AndValue:(CGFloat)value {
    if (scrollView.contentOffset.y < 0) {
        //下拉时导航栏隐藏
        //self.hidden = YES;
        //计算透明度
        CGFloat alpha = fabs(scrollView.contentOffset.y)/20 >1.0f ? 0:(1-fabs(scrollView.contentOffset.y)/20);
        self.alpha = alpha;
        
     [self setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor colorWithWhite:1.0 alpha:0]}];
        [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
    }else {
        self.hidden = NO;
        self.alpha = 1;
    
        //计算透明度
        CGFloat alpha = scrollView.contentOffset.y /value >1.0f ? 1:scrollView.contentOffset.y/value;
        //设置一个颜色并转化为图片
        UIImage *image = [UIImage imageWithColor:[color colorWithAlphaComponent:alpha]];
        [self setBackgroundImage:image forBarMetrics:UIBarMetricsDefault];
        
        [self setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor colorWithWhite:0.6 alpha:alpha]}];
        
        if(alpha>=1){
            if(self.translucent==YES)
            self.translucent = NO;
        }else{
            if(self.translucent==NO)
            self.translucent = YES;
        }
        
        if(scrollView.contentOffset.y == 0){
            [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
        } else {
            [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
        }
    }
}

- (void)reset {
    UIImageView *shadowImg = [self findNavLineImageViewOn:self];
    shadowImg.hidden = NO;
    [self setBackgroundImage:nil forBarMetrics:UIBarMetricsDefault];
}

//寻找导航栏下的横线
- (UIImageView *)findNavLineImageViewOn:(UIView *)view {
    if ([view isKindOfClass:UIImageView.class] && view.bounds.size.height <= 1.0) {
        return (UIImageView *)view;
    }
    for (UIView *subview in view.subviews) {
        UIImageView *imageView = [self findNavLineImageViewOn:subview];
        if (imageView) {
            return imageView;
        }
    }
    return nil;
}

@end
