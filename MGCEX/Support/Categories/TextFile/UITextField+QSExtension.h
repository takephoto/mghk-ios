//
//  UITextField+QSExtension.h
//  test
//
//  Created by apple on 2016/11/12.
//  Copyright © 2016年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UITextField (QSExtension)

/** 占位符颜色 */
@property (nonatomic, strong) UIColor *placeholderColor;

/** 是否允许开始编辑回调 */
@property (nonatomic,copy) BOOL (^shouldBeginEditBlock)(void);

/** 内容改变回调 */
@property (nonatomic, copy) void (^didChangeBlock)(NSString *text);

/** 结束编辑回调 */
@property (nonatomic,copy) void(^endEditBlock)(NSString * text);

/** return键事件回调 */
@property (nonatomic,copy) void(^returnKeyBlock)(NSString * text);

/** 字数超出限制 */
@property (nonatomic,copy) void(^textLengthOverLimitedBlock)(NSInteger limitLength);

/** 限制输入的长度 */
@property (nonatomic, assign) NSInteger limitTextLength;

/** 限制小数的长度 */
@property (nonatomic, copy) NSString *limitDecimalDigitLength;


/** 每隔多少位加一个空格 */
@property (nonatomic, assign) NSInteger divideStringIntervalCount;

/** 不能输入emoji表情 */
@property (nonatomic, assign) BOOL canNotEnterEmoji;
@end
