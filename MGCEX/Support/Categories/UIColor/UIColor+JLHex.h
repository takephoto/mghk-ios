//
//  UIColor+JLHex.h
//  MGCPay
//
//  Created by Joblee on 2017/11/2.
//  Copyright © 2017年 Joblee. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (JLHex)
// 颜色转换：iOS中（以#开头）十六进制的颜色转换为UIColor(RGB)
+ (UIColor *) colorWithHexString: (NSString *)color;
+ (UIColor *) colorWithHexString: (NSString *)color alpha:(float)alpha;
@end
