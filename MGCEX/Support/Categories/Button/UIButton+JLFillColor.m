//
//  UIButton+JLFillColor.m
//  MGCPay
//
//  Created by Joblee on 2017/11/21.
//  Copyright © 2017年 Joblee. All rights reserved.
//

#import "UIButton+JLFillColor.h"

@implementation UIButton (JLFillColor)

- (void)setBackgroundColor:(UIColor *)backgroundColor forState:(UIControlState)state {
    
    [self setBackgroundImage:[UIButton imageWithColor:backgroundColor] forState:state];
    
}



+ (UIImage *)imageWithColor:(UIColor *)color {
    
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    
    UIGraphicsBeginImageContext(rect.size);
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    
    
    CGContextSetFillColorWithColor(context, [color CGColor]);
    
    CGContextFillRect(context, rect);
    
    
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    
    
    return image;
    
}
@end
