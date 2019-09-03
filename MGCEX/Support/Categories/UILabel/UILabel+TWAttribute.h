// MGC
//
// UILabel+TWAttribute.h
// Label高度计算图文混排
//
// Created by MGC on 2017/10/27.
// Copyright © 2017年 MGCion. All rights reserved.
//
// @ description label的富文本简化

#import <UIKit/UIKit.h>

@interface UILabel (TWAttribute)

/**
 * 生成富文本字符串，
 *@param texts 数组文字，不同属性的文字数组
 *@param colors 数组颜色，不同属性的颜色数组
 *@return fonts 数组字号，不同属性的字号数组
 */
+ (NSAttributedString *)mg_attributedTextArray:(NSArray *)texts
                                 textColors:(NSArray *)colors
                                  textfonts:(NSArray *)fonts;

/**
 * 同上，比上面方法多了行间距参数
 */
+ (NSAttributedString *)mg_attributedTextArray:(NSArray *)texts
                                 textColors:(NSArray *)colors
                                  textfonts:(NSArray *)fonts
                                lineSpacing:(CGFloat)l_spacing;

/**
 * 富文本高度计算 label的numberOfLines必须设置为0
 *@param width 富文本固定的宽
 *@param attributted 富文本/或者UILabel的attributedText属性
 *@return  高
 */
+ (CGSize)mg_sizeLabelWidth:(CGFloat)width
          attributedText:(NSAttributedString *)attributted;

/**
 * 获取label 的自适应高度大小 label的numberOfLines必须设置为0
 *@param width label的宽
 *@param text label的文字
 *@return label高
 */
+ (CGSize)mg_sizeLabelWidth:(CGFloat)width
                    text:(NSString *)text
                    font:(UIFont *)font;

//同上，多了行间距参数:l_spacing
+ (CGSize)mg_sizeLabelWidth:(CGFloat)width
                    text:(NSString *)text
                    font:(UIFont *)font
             lineSpacing:(CGFloat)l_spacing;
@end
