//
//  UIImage+scale.m
//  IconClipDemo
//
//  Created by maple on 16/8/23.
//  Copyright © 2016年 maple. All rights reserved.
//

#import "UIImage+scale.h"
#import <Accelerate/Accelerate.h>
#import <QuartzCore/QuartzCore.h>
#define kDefaultWidth 600.0f

@implementation UIImage (scale)

- (instancetype)scaleImage {
    if (self.size.width < kDefaultWidth) {
        return self;
    }
    //计算缩放的高
    CGFloat newHeight = kDefaultWidth * self.size.height / self.size.width;
    CGSize newSize = CGSizeMake(kDefaultWidth, newHeight);
    //开启上下文绘制
    UIGraphicsBeginImageContext(newSize);
    [self drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}
- (NSData *)compressQualityWithMaxLength:(NSInteger)maxLength {
    CGFloat compression = 1;
    NSData *data = UIImageJPEGRepresentation(self, compression);
    if (data.length < maxLength) return data;
    CGFloat max = 1;
    CGFloat min = 0;
    for (int i = 0; i < 6; ++i) {
        compression = (max + min) / 2;
        data = UIImageJPEGRepresentation(self, compression);
        if (data.length < maxLength * 0.9) {
            min = compression;
        } else if (data.length > maxLength) {
            max = compression;
        } else {
            break;
        }
    }
    return data;
}


+(UIImage *)mg_compressImage:(UIImage *)image toSize:(CGSize)size{
    UIGraphicsBeginImageContext(size);
    [image drawInRect:CGRectMake(0, 0, size.width, size.height)];
    UIImage * newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

+(UIImage *)mg_compressImage:(UIImage *)image toMaxWidthOrHeight:(CGFloat)width{
    CGFloat newWidth = 0;
    CGFloat newHeight = 0;
    if (image.size.width < width && image.size.height < width) {
        return image;
    }
    if (image.size.width > image.size.height) {
        newHeight = image.size.height * (width / image.size.width);
        newWidth = width;
    }else{
        newWidth = image.size.width * (width / image.size.height);
        newHeight = width;
    }
    return  [self mg_compressImage:image toSize:CGSizeMake(newWidth, newHeight)];
}


/** 切圆角 */
- (UIImage *)mg_cornetRadius:(CGFloat)radius size:(CGSize)size{

    CGRect rect = (CGRect){0.0f, 0.0f, size};
    UIGraphicsBeginImageContextWithOptions(size, NO, [UIScreen mainScreen].scale);
    
    UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:rect cornerRadius:radius];
    [path addClip];

    [self drawInRect:rect];
    
    UIImage * cornetRadiusImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return cornetRadiusImage;
}


+ (UIImage *)mg_imageByRoundCornerWithImage:(UIImage *)image
                                     Radius:(CGFloat)radius
                                    corners:(UIRectCorner)corners
                                borderWidth:(CGFloat)borderWidth
                                borderColor:(UIColor *)borderColor
                             borderLineJoin:(CGLineJoin)borderLineJoin; {
    
    UIGraphicsBeginImageContextWithOptions(image.size, NO, image.scale);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGRect rect = CGRectMake(0, 0, image.size.width, image.size.height);
    CGContextScaleCTM(context, 1, -1);
    CGContextTranslateCTM(context, 0, -rect.size.height);
    
    CGFloat minSize = MIN(image.size.width, image.size.height);
    if (borderWidth < minSize / 2) {
        UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:CGRectInset(rect, borderWidth, borderWidth) byRoundingCorners:corners cornerRadii:CGSizeMake(radius, borderWidth)];
        [path closePath];
        
        CGContextSaveGState(context);
        [path addClip];
        CGContextDrawImage(context, rect, image.CGImage);
        CGContextRestoreGState(context);
    }
    
    if (borderColor && borderWidth < minSize / 2 && borderWidth > 0) {
        CGFloat strokeInset = (floor(borderWidth * image.scale) + 0.5) / image.scale;
        CGRect strokeRect = CGRectInset(rect, strokeInset, strokeInset);
        CGFloat strokeRadius = radius > image.scale / 2 ? radius - image.scale / 2 : 0;
        UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:strokeRect byRoundingCorners:corners cornerRadii:CGSizeMake(strokeRadius, borderWidth)];
        [path closePath];
        
        path.lineWidth = borderWidth;
        path.lineJoinStyle = borderLineJoin;
        [borderColor setStroke];
        [path stroke];
    }
    UIImage *Nimage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return Nimage;
}

- (UIImage *)mg_cornetRadius:(CGFloat)radius size:(CGSize)size borderW:(CGFloat)borderW borderColor:(UIColor *)color{
    
    CGRect rect = (CGRect){borderW, borderW, size};
    CGRect borderRect = (CGRect){0.0f, 0.0f, size.width + 2 * borderW, size.height + 2 * borderW};
    UIGraphicsBeginImageContextWithOptions(borderRect.size,NO,0);
    
    UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:borderRect cornerRadius:radius];
    [color set];
    [path fill];
    
    path = [UIBezierPath bezierPathWithRoundedRect:rect cornerRadius:radius];
    [path addClip];
    
    [self drawInRect:rect];
    
    UIImage *clipImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return clipImage;
}

/** 图片水印 */
- (UIImage *)mg_watermarkWithWatermarkImage:(UIImage *)watermarkImage rect:(CGRect)rect{
    
    UIGraphicsBeginImageContext(self.size);
    [self drawInRect:CGRectMake(0, 0, self.size.width, self.size.height)];
    [watermarkImage drawInRect:rect];
    
    UIImage *resultImg = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return resultImg;
}

/** 文字水印 */
- (UIImage *)mg_watermarkWithWatermark:(NSString *)watermarkString rect:(CGRect)rect attributes:(NSDictionary *)attributes{
    
    UIGraphicsBeginImageContext(self.size);
    [self drawInRect:CGRectMake(0, 0, self.size.width, self.size.height)];
    
    if ([UIDevice currentDevice].systemVersion.floatValue >= 7.0) {
        
        [watermarkString drawInRect:rect withAttributes:attributes];
    }else{
        
        UIFont *font = [attributes valueForKey:NSFontAttributeName];
        [watermarkString drawInRect:rect withFont:font];
    }
    
    UIImage *resultImg = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return resultImg;
}

/**
 *  生成一张纯色的图片
 */
+ (instancetype)createImageWithColor:(UIColor*)color width:(CGFloat)width andHeight:(CGFloat)height
{
    CGRect r= CGRectMake(0.0f, 0.0f, width, height);
    UIGraphicsBeginImageContext(r.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, r);
    
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return img;
}

//生成一张颜色图片
+ (UIImage *)imageWithColor:(UIColor *)color
{
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

/**
 * 全屏截图
 */
+ (UIImage*)mg_screenshot {
    
    CGSize imageSize = [[UIScreen mainScreen] bounds].size;
    
    if (NULL != UIGraphicsBeginImageContextWithOptions) {
        UIGraphicsBeginImageContextWithOptions(imageSize, NO, 0);
    } else {
        UIGraphicsBeginImageContext(imageSize);
    }
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    for (UIWindow *window in [[UIApplication sharedApplication] windows]) {
        if (![window respondsToSelector:@selector(screen)] || [window screen] == [UIScreen mainScreen]) {
            CGContextSaveGState(context);
            
            CGContextTranslateCTM(context, [window center].x, [window center].y);
            
            CGContextConcatCTM(context, [window transform]);
            
            CGContextTranslateCTM(context,
                                  -[window bounds].size.width * [[window layer] anchorPoint].x,
                                  -[window bounds].size.height * [[window layer] anchorPoint].y);
            
            [[window layer] renderInContext:context];
            
            CGContextRestoreGState(context);
        }
    }
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return image;
    
    
}
/**
 * 指定view截屏
 */
+(UIImage*)mg_captureView:(UIView *)theView
{
    CGRect rect = theView.frame;
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    [theView.layer renderInContext:context];
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return img;
    
}
/**
 *  从给定UIImage和指定Frame截图：
 */
-(UIImage *)mg_cutWithFrame:(CGRect)frame{
    
    //创建CGImage
    CGImageRef cgimage = CGImageCreateWithImageInRect(self.CGImage, frame);
    
    //创建image
    UIImage *newImage=[UIImage imageWithCGImage:cgimage];
    
    //释放CGImage
    CGImageRelease(cgimage);
    
    return newImage;
    
    
}

/**
 * 图片模糊
 *@param  blur   0 - 1.0 数值越大越模糊，超过1.0和小于0都默认为0.5
 
 */
-(UIImage *)mg_boxblurImageWithBlur:(CGFloat)blur {
    if (blur < 0.f || blur > 1.f) {
        blur = 0.5f;
    }
    int boxSize = (int)(blur * 50);
    boxSize = boxSize - (boxSize % 2) + 1;
    
    CGImageRef img = self.CGImage;
    
    
    vImage_Buffer inBuffer, outBuffer;
    vImage_Error error;
    void *pixelBuffer;
    
    
    //create vImage_Buffer with data from CGImageRef
    
    CGDataProviderRef inProvider = CGImageGetDataProvider(img);
    CFDataRef inBitmapData = CGDataProviderCopyData(inProvider);
    
    inBuffer.width = CGImageGetWidth(img);
    inBuffer.height = CGImageGetHeight(img);
    inBuffer.rowBytes = CGImageGetBytesPerRow(img);
    
    inBuffer.data = (void*)CFDataGetBytePtr(inBitmapData);
    
    //create vImage_Buffer for output
    
    pixelBuffer = malloc(CGImageGetBytesPerRow(img) * CGImageGetHeight(img));
    
    if(pixelBuffer == NULL)
        NSLog(@"No pixelbuffer");
    
    outBuffer.data = pixelBuffer;
    outBuffer.width = CGImageGetWidth(img);
    outBuffer.height = CGImageGetHeight(img);
    outBuffer.rowBytes = CGImageGetBytesPerRow(img);
    
    //perform convolution
    error = vImageBoxConvolve_ARGB8888(&inBuffer, &outBuffer, NULL, 0, 0, boxSize, boxSize, NULL, kvImageEdgeExtend);
    
    
    if (error) {
        NSLog(@"error from convolution %ld", error);
    }
    
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef ctx = CGBitmapContextCreate(outBuffer.data,outBuffer.width,
                                             outBuffer.height,
                                             8,
                                             outBuffer.rowBytes,
                                             colorSpace,
                                             kCGImageAlphaNoneSkipLast);
    CGImageRef imageRef = CGBitmapContextCreateImage (ctx);
    UIImage *returnImage = [UIImage imageWithCGImage:imageRef];
    
    //clean up
    CGContextRelease(ctx);
    CGColorSpaceRelease(colorSpace);
    
    free(pixelBuffer);
    CFRelease(inBitmapData);
    
    CGColorSpaceRelease(colorSpace);
    CGImageRelease(imageRef);
    
    return returnImage;
}


/**
 * 按rect裁剪图片
 
 */
- (UIImage *)mg_imageByCropToRect:(CGRect)rect {
    rect.origin.x *= self.scale;
    rect.origin.y *= self.scale;
    rect.size.width *= self.scale;
    rect.size.height *= self.scale;
    if (rect.size.width <= 0 || rect.size.height <= 0) return nil;
    CGImageRef imageRef = CGImageCreateWithImageInRect(self.CGImage, rect);
    UIImage *image = [UIImage imageWithCGImage:imageRef scale:self.scale orientation:self.imageOrientation];
    CGImageRelease(imageRef);
    return image;
}

+ (UIImage *)mg_ss_mergeWithImage1:(UIImage*)image1 image2:(UIImage *)image2
                            frame1:(CGRect)frame1 frame2:(CGRect)frame2
                              size:(CGSize)size
{
    UIGraphicsBeginImageContext(size);
    [image1 drawInRect:frame1 blendMode:kCGBlendModeLuminosity alpha:1.0];
    [image2 drawInRect:frame2 blendMode:kCGBlendModeLuminosity alpha:0.2];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

/** 图片水印 */
+ (UIImage *)mg_watermarkWithTargetImage:(UIImage *)targetImage watermarkImage:(UIImage *)watermarkImage rect:(CGRect)rect{
    
    UIGraphicsBeginImageContext(targetImage.size);
    [targetImage drawInRect:CGRectMake(0, 0, targetImage.size.width, targetImage.size.height)];
    [watermarkImage drawInRect:rect];
    
    UIImage *resultImg = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return resultImg;
}

/** 文字水印 */
+ (UIImage *)mg_watermarkWithTargetImage:(UIImage *)targetImage watermark:(NSString *)watermarkString rect:(CGRect)rect attributes:(NSDictionary *)attributes{
    
    UIGraphicsBeginImageContext(targetImage.size);
    [targetImage drawInRect:CGRectMake(0, 0, targetImage.size.width, targetImage.size.height)];
    
    if ([UIDevice currentDevice].systemVersion.floatValue >= 7.0) {
        
        [watermarkString drawInRect:rect withAttributes:attributes];
    }else{
        
        UIFont *font = [attributes valueForKey:NSFontAttributeName];
        [watermarkString drawInRect:rect withFont:font];
    }
    
    UIImage *resultImg = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return resultImg;
}

@end
