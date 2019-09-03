//
// UILabel+QSAttribute.h
//
// Created by Song on 2017/10/23.
// Copyright © 2017年 Song. All rights reserved.
//

#import "UILabel+QSAttribute.h"

#import <objc/runtime.h>
#import <CoreText/CoreText.h>

#ifndef kUILabel_PhoneVersion
/** 获取手机系统版本 */
#define kUILabel_PhoneVersion ([[UIDevice currentDevice] systemVersion])
#endif

@implementation MGAttributeModel

@end

@implementation UILabel (QSAttribute)
/**
 *  设置特定区域的字体大小
 */
- (void)qs_setTextFont:(UIFont *)font atRange:(NSRange)range
{
    [self qs_setTextAttributes:@{NSFontAttributeName : font}
                       atRange:range];
}

/**
 *  设置特定区域的字体颜色
 */
- (void)qs_setTextColor:(UIColor *)color atRange:(NSRange)range
{
    [self qs_setTextAttributes:@{NSForegroundColorAttributeName : color}
                       atRange:range];
}

/**
 *  设置行间距
 */
- (void)qs_setTextLineSpace:(float)space
{
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setLineSpacing:space];
    
    NSMutableAttributedString *attributedString = [self.attributedText mutableCopy];
    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [self.text length])];
    self.attributedText = attributedString;
}

/**
 *  设置特定区域的字体大小和颜色
 *
 *  @param font 字体
 *  @param color 颜色
 *  @param range 范围
 */
- (void)qs_setTextFont:(UIFont *)font color:(UIColor *)color atRange:(NSRange)range
{
    [self qs_setTextAttributes:@{NSFontAttributeName : font,
                                 NSForegroundColorAttributeName : color}
                       atRange:range];
}

/**
 *  设置下划线
 */
- (void)qs_setTextUnderLineAtRange:(NSRange)range andLineColor:(UIColor *)lineColor
{
    NSMutableAttributedString *attributedString = [self.attributedText mutableCopy];
    [attributedString addAttribute:NSUnderlineStyleAttributeName value:[NSNumber numberWithInteger:NSUnderlineStyleSingle] range:range];
    [attributedString addAttribute:NSUnderlineColorAttributeName value:lineColor range:range];
    self.attributedText = attributedString;
}

/**
 *  设置删除线
 */
- (void)qs_setTextRemoveLineAtRange:(NSRange)range andLineColor:(UIColor *)lineColor
{
    NSMutableAttributedString *attributedString = [self.attributedText mutableCopy];
    [attributedString addAttribute:NSStrikethroughColorAttributeName value:lineColor range:range];
    [attributedString addAttribute:NSStrikethroughStyleAttributeName value:@(NSUnderlineStyleSingle | NSUnderlinePatternSolid) range:range];
    
    NSString *pVersion = kUILabel_PhoneVersion;
    if (pVersion.floatValue >= 10.3) {  // ios10.3之后删除线的处理
        [attributedString addAttribute:NSBaselineOffsetAttributeName value:@0 range:range];
    } else if (pVersion.floatValue <= 9.0) {    // ios9.0之前删除线的处理
        [attributedString addAttribute:NSStrikethroughStyleAttributeName value:@(NSUnderlineStyleNone) range:range];
    }
    
    self.attributedText = attributedString;
}

/**
 *  同时设置多个属性
 */
- (void)qs_setTextAttributes:(NSDictionary *)attributes atRange:(NSRange)range
{
    NSMutableAttributedString *mutableAttributedString = [[NSMutableAttributedString alloc] initWithAttributedString:self.attributedText];
    
    for (NSString *name in attributes)
    {
        [mutableAttributedString addAttribute:name value:[attributes objectForKey:name] range:range];
    }
    
    self.attributedText = mutableAttributedString;
}

/**
 *  辨别电话号码
 */
- (void)qs_distinguishPhoneNumerComplete:(void (^)(MGAttributeModel *))completeBlack
{
    // 获取字符串中的电话号码
    NSString *regulaStr = @"\\d{3,4}[- ]?\\d{7,8}";
    NSRange stringRange = NSMakeRange(0, self.text.length);
    
    // 正则匹配
    NSError *error;
    NSMutableAttributedString *attributedString = [self.attributedText mutableCopy];
    
    NSRegularExpression *regexps = [NSRegularExpression regularExpressionWithPattern:regulaStr options:0 error:&error];
    if (!error && regexps != nil) {
        [regexps enumerateMatchesInString:self.text options:0 range:stringRange usingBlock:^(NSTextCheckingResult * _Nullable result, NSMatchingFlags flags, BOOL * _Nonnull stop) {
            
            NSRange phoneRange = result.range;
            // 接收电话号码字符串
            NSString *phoneNumber = [[attributedString attributedSubstringFromRange:phoneRange] string];
            // 判断是否是电话号码
            BOOL isPhoneNumber = [self qs_checkPhoneNumber:phoneNumber];
            if (isPhoneNumber) {
                MGAttributeModel *model = [[MGAttributeModel alloc] init];
                model.str = phoneNumber;
                model.range = phoneRange;
                model.strType = QSLabStringType_PhoneNumber;
                
                completeBlack(model);
            }
        }];
    }
}

/**
 *  辨别网络地址
 */
- (void)qs_distinguishWebUrlComplete:(void (^)(MGAttributeModel *))completeBlack
{
    // 获取字符串中的电话号码
    NSString *regulaStr = @"((http[s]{0,1}|ftp)://[a-zA-Z0-9\\.\\-]+\\.([a-zA-Z]{2,4})(:\\d+)?(/[a-zA-Z0-9\\.\\-~!@#$%^&*+?:_/=<>]*)?)|(www.[a-zA-Z0-9\\.\\-]+\\.([a-zA-Z]{2,4})(:\\d+)?(/[a-zA-Z0-9\\.\\-~!@#$%^&*+?:_/=<>]*)?)";
    NSRange stringRange = NSMakeRange(0, self.text.length);
    
    // 正则匹配
    NSError *error;
    NSMutableAttributedString *attributedString = [self.attributedText mutableCopy];
    
    NSRegularExpression *regexps = [NSRegularExpression regularExpressionWithPattern:regulaStr options:0 error:&error];
    if (!error && regexps != nil) {
        [regexps enumerateMatchesInString:self.text options:0 range:stringRange usingBlock:^(NSTextCheckingResult * _Nullable result, NSMatchingFlags flags, BOOL * _Nonnull stop) {
            
            NSRange phoneRange = result.range;
            // 接收网址字符串
            NSString *webUrl = [[attributedString attributedSubstringFromRange:phoneRange] string];
            
            MGAttributeModel *model = [[MGAttributeModel alloc] init];
            model.str = webUrl;
            model.range = phoneRange;
            model.strType = QSLabStringType_WebUrl;
            
            completeBlack(model);
        }];
    }
}

/**
 *  对字符添加点击事件
 */
- (void)qs_addTapActionWithAttributeModels:(NSArray<MGAttributeModel *> *)attributeModels stringClickedBlock:(void (^)(MGAttributeModel *))stringClickedBlock
{
    self.userInteractionEnabled = YES;
    
    [self qs_getRangesWithStrings:attributeModels];
    
    if (self.tapBlock != stringClickedBlock) {
        self.tapBlock = stringClickedBlock;
    }
}

/**
 *  添加图片
 */
- (void)qs_addImage:(UIImage *)img imgBound:(CGRect)imgBound andImgIndex:(NSInteger)imgIndex
{
    NSMutableAttributedString *attributedString = [self.attributedText mutableCopy];
    
    // NSTextAttachment可以将要插入的图片作为特殊字符处理
    NSTextAttachment *attch = [[NSTextAttachment alloc] init];
    // 定义图片内容及位置和大小
    attch.image = img;
    attch.bounds = imgBound;
    //创建带有图片的富文本
    NSAttributedString *string = [NSAttributedString attributedStringWithAttachment:attch];
    
    // 将图片放在第一位
    [attributedString insertAttributedString:string atIndex:imgIndex];
    // 用label的attributedText属性来使用富文本
    self.attributedText = attributedString;
}

/**
 * 生成富文本字符串，
 *@param texts 数组文字，不同属性的文字数组
 *@param colors 数组颜色，不同属性的颜色数组
 *@return fonts 数组字号，不同属性的字号数组
 */
+ (NSAttributedString *)mg_attributedTextArray:(NSArray *)texts
                                    textColors:(NSArray *)colors
                                     textfonts:(NSArray *)fonts
{
    if(texts.count == 0){
        return nil;
    }
    
    NSMutableAttributedString *resultAttributedStr = [[NSMutableAttributedString alloc] init];
    for(int i=0; i<texts.count; i++)
    {
        NSString *text = texts[i];
        NSMutableAttributedString *mAttributedStr = [[NSMutableAttributedString alloc] initWithString:text];
        [mAttributedStr addAttribute:NSForegroundColorAttributeName value:colors[i] range:NSMakeRange(0, text.length)];
        [mAttributedStr addAttribute:NSFontAttributeName value:fonts[i] range:NSMakeRange(0, text.length)];
        [resultAttributedStr appendAttributedString:mAttributedStr];
    }
    
    return resultAttributedStr;
    
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    
    CGPoint point = [touch locationInView:self];
    
    __weak typeof(self) weakSelf = self;
    [self qs_getTapFrameWithTouchPoint:point result:^(MGAttributeModel *attModel) {
        if (weakSelf.tapBlock) {
            weakSelf.tapBlock(attModel);
        }
    }];
}

#pragma mark - private
/**
 *  验证手机号以及固话方法
 */
- (BOOL)qs_checkPhoneNumber:(NSString *)number
{
    NSString *phoneNum = [number stringByReplacingOccurrencesOfString:@"-" withString:@""];
    
    // 验证输入的固话中不带 "-"符号
    NSString * strNum = @"^(0[0-9]{2,3})?([2-9][0-9]{6,7})+(-[0-9]{1,4})?$|(^(13[0-9]|15[0|3|6|7|8|9]|18[8|9])\\d{8}$)";
    
    NSPredicate *checktest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", strNum];
    
    return [checktest evaluateWithObject:phoneNum];
}

- (void)qs_getRangesWithStrings:(NSArray <MGAttributeModel *>  *)models
{
    __block  NSString *totalStr = self.attributedText.string;
    
    self.attributeStrings = [NSMutableArray array];
    
    __weak typeof(self) weakSelf = self;
    
    [models enumerateObjectsUsingBlock:^(MGAttributeModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        MGAttributeModel *attrModel = (MGAttributeModel *)obj;
        NSRange range = [totalStr rangeOfString:attrModel.str];
        
        if (range.length != 0) {
            
            totalStr = [totalStr stringByReplacingCharactersInRange:range withString:[weakSelf qs_getStringWithRange:range]];
            
            MGAttributeModel *model = [MGAttributeModel new];
            model.range = range;
            model.str = attrModel.str;
            model.strType = attrModel.strType;
            
            [weakSelf.attributeStrings addObject:model];
        }
    }];
}

- (NSString *)qs_getStringWithRange:(NSRange)range
{
    NSMutableString *string = [NSMutableString string];
    
    for (int i = 0; i < range.length ; i++) {
        
        [string appendString:@" "];
    }
    return string;
}

- (BOOL)qs_getTapFrameWithTouchPoint:(CGPoint)point result:(void (^) (MGAttributeModel *attModel))resultBlock
{
    CTFramesetterRef framesetter = CTFramesetterCreateWithAttributedString((CFAttributedStringRef)self.attributedText);
    
    CGMutablePathRef Path = CGPathCreateMutable();
    
    CGPathAddRect(Path, NULL, CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height));
    
    CTFrameRef frame = CTFramesetterCreateFrame(framesetter, CFRangeMake(0, 0), Path, NULL);
    
    CFRange range = CTFrameGetVisibleStringRange(frame);
    
    if (self.attributedText.length > range.length) {
        
        UIFont *font ;
        
        if ([self.attributedText attribute:NSFontAttributeName atIndex:0 effectiveRange:nil]) {
            
            font = [self.attributedText attribute:NSFontAttributeName atIndex:0 effectiveRange:nil];
            
        }else if (self.font){
            font = self.font;
            
        }else {
            font = [UIFont systemFontOfSize:17];
        }
        
        CGPathRelease(Path);
        
        Path = CGPathCreateMutable();
        
        CGPathAddRect(Path, NULL, CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height + font.lineHeight));
        
        frame = CTFramesetterCreateFrame(framesetter, CFRangeMake(0, 0), Path, NULL);
    }
    
    CFArrayRef lines = CTFrameGetLines(frame);
    
    if (!lines) {
        CFRelease(frame);
        CFRelease(framesetter);
        CGPathRelease(Path);
        return NO;
    }
    
    CFIndex count = CFArrayGetCount(lines);
    
    CGPoint origins[count];
    
    CTFrameGetLineOrigins(frame, CFRangeMake(0, 0), origins);
    
    CGAffineTransform transform = [self qs_transformForCoreText];
    
    CGFloat verticalOffset = 0;
    
    for (CFIndex i = 0; i < count; i++) {
        CGPoint linePoint = origins[i];
        
        CTLineRef line = CFArrayGetValueAtIndex(lines, i);
        
        CGRect flippedRect = [self qs_getLineBounds:line point:linePoint];
        
        CGRect rect = CGRectApplyAffineTransform(flippedRect, transform);
        
        rect = CGRectInset(rect, 0, 0);
        
        rect = CGRectOffset(rect, 0, verticalOffset);
        
        NSParagraphStyle *style = [self.attributedText attribute:NSParagraphStyleAttributeName atIndex:0 effectiveRange:nil];
        
        CGFloat lineSpace;
        
        if (style) {
            lineSpace = style.lineSpacing;
        }else {
            lineSpace = 0;
        }
        
        CGFloat lineOutSpace = (self.bounds.size.height - lineSpace * (count - 1) -rect.size.height * count) / 2;
        
        rect.origin.y = lineOutSpace + rect.size.height * i + lineSpace * i;
        
        if (CGRectContainsPoint(rect, point)) {
            
            CGPoint relativePoint = CGPointMake(point.x - CGRectGetMinX(rect), point.y - CGRectGetMinY(rect));
            
            CFIndex index = CTLineGetStringIndexForPosition(line, relativePoint);
            
            CGFloat offset;
            
            CTLineGetOffsetForStringIndex(line, index, &offset);
            
            if (offset > relativePoint.x) {
                index = index - 1;
            }
            
            NSInteger link_count = self.attributeStrings.count;
            
            for (int j = 0; j < link_count; j++) {
                
                MGAttributeModel *model = self.attributeStrings[j];
                
                NSRange link_range = model.range;
                if (NSLocationInRange(index, link_range)) {
                    if (resultBlock) {
                        resultBlock(model);
                    }
                    CFRelease(frame);
                    CFRelease(framesetter);
                    CGPathRelease(Path);
                    return YES;
                }
            }
        }
    }
    CFRelease(frame);
    CFRelease(framesetter);
    CGPathRelease(Path);
    return NO;
}

- (CGAffineTransform)qs_transformForCoreText
{
    return CGAffineTransformScale(CGAffineTransformMakeTranslation(0, self.bounds.size.height), 1.f, -1.f);
}

- (CGRect)qs_getLineBounds:(CTLineRef)line point:(CGPoint)point
{
    CGFloat ascent = 0.0f;
    CGFloat descent = 0.0f;
    CGFloat leading = 0.0f;
    CGFloat width = (CGFloat)CTLineGetTypographicBounds(line, &ascent, &descent, &leading);
    CGFloat height = ascent + fabs(descent) + leading;
    
    return CGRectMake(point.x, point.y , width, height);
}

#pragma mark - getter
- (void (^)(MGAttributeModel *))tapBlock
{
    return objc_getAssociatedObject(self, _cmd);
}

- (NSMutableArray *)attributeStrings
{
    return objc_getAssociatedObject(self, _cmd);
}

#pragma mark - setter
- (void)setTapBlock:(void (^)(MGAttributeModel *))tapBlock
{
    objc_setAssociatedObject(self, @selector(tapBlock), tapBlock, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (void)setAttributeStrings:(NSMutableArray *)attributeStrings
{
    objc_setAssociatedObject(self, @selector(attributeStrings), attributeStrings, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
@end
