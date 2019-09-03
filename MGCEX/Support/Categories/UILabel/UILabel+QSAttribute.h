//
// UILabel+QSAttribute.h
//
// Created by Song on 2017/10/23.
// Copyright © 2017年 Song. All rights reserved.
//
// 参考YBAttributeTextTapAction实现Label的点击（https://github.com/lyb5834/YBAttributeTextTapAction）
//

#import <UIKit/UIKit.h>

typedef enum : NSUInteger {
    QSLabStringType_PhoneNumber,
    QSLabStringType_WebUrl,
    QSLabStringType_Other
} QSLabStringType;

@interface MGAttributeModel : NSObject

/** 字符串 */
@property (nonatomic, copy) NSString *str;
/** 字符串范围 */
@property (nonatomic, assign) NSRange range;
/** 字符串类型 */
@property (nonatomic, assign) QSLabStringType strType;

@end

@interface UILabel (QSAttribute)

/**
 *  设置特定区域的字体大小
 *
 *  @param font 字体
 *  @param range 范围
 */
- (void)qs_setTextFont:(UIFont *)font atRange:(NSRange)range;

/**
 *  设置特定区域的字体颜色
 *
 *  @param color 颜色
 *  @param range 范围
 */
- (void)qs_setTextColor:(UIColor *)color atRange:(NSRange)range;

/**
 *  设置行间距
 *
 *  @param space 行间距大小
 */
- (void)qs_setTextLineSpace:(float)space;

/**
 *  设置特定区域的字体大小和颜色
 *
 *  @param font 字体
 *  @param color 颜色
 *  @param range 范围
 */
- (void)qs_setTextFont:(UIFont *)font color:(UIColor *)color atRange:(NSRange)range;

/**
 *  设置下划线
 *
 *  @param range 范围
 *  @param lineColor 下划线颜色
 */
- (void)qs_setTextUnderLineAtRange:(NSRange)range andLineColor:(UIColor *)lineColor;

/**
 *  设置删除线
 *
 *  @param range 范围
 *  @param lineColor 删除线颜色
 */
- (void)qs_setTextRemoveLineAtRange:(NSRange)range andLineColor:(UIColor *)lineColor;

/**
 *  同时设置多个属性
 *
 *  @param attributes 属性的字典
 *  @param range 范围
 */
- (void)qs_setTextAttributes:(NSDictionary *)attributes atRange:(NSRange)range;

/**
 *  辨别电话号码
 *
 *  @param completeBlack 辨别完成的Block
 */
-(void)qs_distinguishPhoneNumerComplete:(void(^)(MGAttributeModel *model))completeBlack;

/**
 *  辨别网络地址
 *
 *  如果网址后面还有字母，需要使用空格隔开
 *  @param completeBlack 辨别完成的Block
 */
- (void)qs_distinguishWebUrlComplete:(void(^)(MGAttributeModel *model))completeBlack;

/**
 *  对字符添加点击事件  使用UILabel+YBAttributeTextTapAction
 *
 *  @param attributeModels 要添加点击事件的字符模型数组
 *  @param stringClickedBlock 字符点击事件回调
 */
- (void)qs_addTapActionWithAttributeModels:(NSArray <MGAttributeModel *> *)attributeModels stringClickedBlock:(void (^)(MGAttributeModel *model))stringClickedBlock;

/**
 *  添加图片
 *
 *  @param img 图片
 *  @param imgBound 图片大小
 *  @param imgIndex 图片在文字中的位置
 */
- (void)qs_addImage:(UIImage *)img imgBound:(CGRect)imgBound andImgIndex:(NSInteger)imgIndex;

/**
 * 生成富文本字符串，
 *@param texts 数组文字，不同属性的文字数组
 *@param colors 数组颜色，不同属性的颜色数组
 *@return fonts 数组字号，不同属性的字号数组
 */
+ (NSAttributedString *)mg_attributedTextArray:(NSArray *)texts
                                    textColors:(NSArray *)colors
                                     textfonts:(NSArray *)fonts;

@end
