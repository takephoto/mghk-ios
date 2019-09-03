//
//  UIImage+scale.h
//  IconClipDemo
//
//  Created by maple on 16/8/23.
//  Copyright © 2016年 maple. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (scale)

/**
 上传身份证使用

 @return 图片
 */
- (instancetype)scaleImage;

/**
 压缩图片至指定大小

 @param maxLength 指定大小
 @return 数据
 */
- (NSData *)compressQualityWithMaxLength:(NSInteger)maxLength;

/**压缩图片到指定size*/
+(UIImage *)mg_compressImage:(UIImage *)image toSize:(CGSize)size;

/**按比例压缩大小 width:指定宽或高*/
+(UIImage *)mg_compressImage:(UIImage *)image toMaxWidthOrHeight:(CGFloat)width;

/** 切圆角 */
- (UIImage *)mg_cornetRadius:(CGFloat)radius size:(CGSize)size;

/** 生成带边框的图片 */
- (UIImage *)mg_cornetRadius:(CGFloat)radius size:(CGSize)size borderW:(CGFloat)borderW borderColor:(UIColor *)color;

/**
 * 去圆角 + 边框
 *@param  radius   圆角值
 *@param  corners   圆角方向
 *@param  borderWidth   边框宽度
 *@param  borderColor   边框颜色
 *@param  borderLineJoin   边框类型
 */
+ (UIImage *)mg_imageByRoundCornerWithImage:(UIImage *)image
                                     Radius:(CGFloat)radius
                                    corners:(UIRectCorner)corners
                                borderWidth:(CGFloat)borderWidth
                                borderColor:(UIColor *)borderColor
                             borderLineJoin:(CGLineJoin)borderLineJoin;

/** 图片水印 */
- (UIImage *)mg_watermarkWithWatermarkImage:(UIImage *)watermarkImage rect:(CGRect)rect;

/** 文字水印 */
- (UIImage *)mg_watermarkWithWatermark:(NSString *)watermarkString rect:(CGRect)rect attributes:(NSDictionary *)attributes;
//生成一张颜色图片
+ (UIImage *)imageWithColor:(UIColor *)color;

/**
 *  生成一张纯色的图片
 *
 *  @param color  图片颜色
 *  @param width  图片宽度
 *  @param height 图片高度
 *  @return 生成的图片
 */
+ (instancetype)createImageWithColor:(UIColor*)color width:(CGFloat)width andHeight:(CGFloat)height;

/**
 * 全屏截图
 */
+ (UIImage*)mg_screenshot;

/**
 * 指定view截屏
 */
+ (UIImage*)mg_captureView:(UIView *)theView;

/**
 *  从给定UIImage和指定Frame截图：
 */
-(UIImage *)mg_cutWithFrame:(CGRect)frame;

/**
 * 按rect裁剪图片
 
 */
- (UIImage *) mg_imageByCropToRect:(CGRect)rect;

/**
 * 图片模糊
 *@param  blur   0 - 1.0 数值越大越模糊，超过1.0和小于0都默认为0.5
 
 */
-(UIImage *)mg_boxblurImageWithBlur:(CGFloat)blur;

/**
 *  合并两个Image。
 *  @param  image1、image2: 两张图片。
 *  @param  frame1、frame2: 两张图片放置的位置。
 *  @param  size:返回图片的尺寸。
 *  return  合并后的两个图片的Image。
 */
+ (UIImage *)mg_ss_mergeWithImage1:(UIImage *)image1 image2:(UIImage *)image2 frame1:(CGRect)frame1 frame2:(CGRect)frame2 size:(CGSize)size;

/** 图片水印 */
+ (UIImage *)mg_watermarkWithTargetImage:(UIImage *)targetImage watermarkImage:(UIImage *)watermarkImage rect:(CGRect)rect;

/** 文字水印 */
+ (UIImage *)mg_watermarkWithTargetImage:(UIImage *)targetImage watermark:(NSString *)watermarkString rect:(CGRect)rect attributes:(NSDictionary *)attributes;

@end
