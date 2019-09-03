//
//  UILabel+JLAttributed.h
//  MGCPay
//
//  Created by Joblee on 2017/11/18.
//  Copyright © 2017年 Joblee. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UILabel (JLAttributed)
/**
 *  改变行间距
 */
+ (void)changeLineSpaceForLabel:(UILabel *)label WithSpace:(float)space;

/**
 *  改变字间距
 */
+ (void)changeWordSpaceForLabel:(UILabel *)label WithSpace:(float)space;

/**
 *  改变行间距和字间距
 */
+ (void)changeSpaceForLabel:(UILabel *)label withLineSpace:(float)lineSpace WordSpace:(float)wordSpace;

@end
