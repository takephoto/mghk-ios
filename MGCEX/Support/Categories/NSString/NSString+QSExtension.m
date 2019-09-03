//
//  NSString+QSExtension.m
//  ZengLongSeSha
//
//  Created by apple on 2017/6/22.
//  Copyright © 2017年 Song. All rights reserved.
//

#import "NSString+QSExtension.h"

@implementation NSString (QSExtension)
/**
 *  获取字符串文字的长度
 */
- (CGFloat)obtainWidthWithFont:(UIFont *)font andHeight:(CGFloat)height
{
    NSDictionary * dict=[NSDictionary dictionaryWithObject: font forKey:NSFontAttributeName];
    CGRect rect=[self boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, height) options:NSStringDrawingTruncatesLastVisibleLine|NSStringDrawingUsesFontLeading|NSStringDrawingUsesLineFragmentOrigin attributes:dict context:nil];
    return rect.size.width;
}

/**
 *  获取字符串文字的高度
 */
- (CGFloat)obtainHeightWithFont:(UIFont *)font andWidth:(CGFloat)width
{
    CGRect bounds;
    NSDictionary * parameterDict=[NSDictionary dictionaryWithObject:font forKey:NSFontAttributeName];
    bounds=[self boundingRectWithSize:CGSizeMake(width, CGFLOAT_MAX) options:NSStringDrawingTruncatesLastVisibleLine|NSStringDrawingUsesFontLeading|NSStringDrawingUsesLineFragmentOrigin attributes:parameterDict context:nil];
    return bounds.size.height;
}

/**
 *  按照字符分割字符串
 */
- (NSArray *)divisiveStringWithChar:(NSString *)divisiveChar
{
    return [self componentsSeparatedByString:divisiveChar];
}

/**
 *  过滤字符串中的html标签
 */
-(NSString *)stringFilterHTML:(NSString *)html
{
    NSScanner * scanner = [NSScanner scannerWithString:html];
    NSString * text = nil;
    while([scanner isAtEnd]==NO)
    {
        //找到标签的起始位置
        [scanner scanUpToString:@"<" intoString:nil];
        //找到标签的结束位置
        [scanner scanUpToString:@">" intoString:&text];
        //替换字符
        html = [html stringByReplacingOccurrencesOfString:[NSString stringWithFormat:@"%@>",text] withString:@""];
    }
    return html;
}

/**
 获取拼音首字母(传入汉字字符串, 返回大写拼音首字母)
 @return 大写首字母
 */
- (NSString *)firstCharactor
{
    //转成了可变字符串
    NSMutableString *str = [NSMutableString stringWithString:self];
    //先转换为带声调的拼音
    CFStringTransform((CFMutableStringRef)str,NULL, kCFStringTransformMandarinLatin,NO);
    //再转换为不带声调的拼音
    CFStringTransform((CFMutableStringRef)str,NULL, kCFStringTransformStripDiacritics,NO);
    //转化为大写拼音
    NSString *pinYin = [str capitalizedString];
    //获取并返回首字母
    return [pinYin substringToIndex:1];
}

- (CGSize)ex_sizeWithFont:(UIFont *)font constrainedToSize:(CGSize)size
{
    CGSize resultSize;
    if ([self respondsToSelector:@selector(boundingRectWithSize:options:attributes:context:)]) {
        NSMethodSignature *signature = [[self class] instanceMethodSignatureForSelector:@selector(boundingRectWithSize:options:attributes:context:)];
        NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:signature];
        [invocation setTarget:self];
        [invocation setSelector:@selector(boundingRectWithSize:options:attributes:context:)];
        NSDictionary *attributes = @{ NSFontAttributeName:font };
        NSStringDrawingOptions options = NSStringDrawingUsesLineFragmentOrigin;
        NSStringDrawingContext *context;
        [invocation setArgument:&size atIndex:2];
        [invocation setArgument:&options atIndex:3];
        [invocation setArgument:&attributes atIndex:4];
        [invocation setArgument:&context atIndex:5];
        [invocation invoke];
        CGRect rect;
        [invocation getReturnValue:&rect];
        resultSize = rect.size;
    } else {
        NSMethodSignature *signature = [[self class] instanceMethodSignatureForSelector:@selector(sizeWithFont:constrainedToSize:)];
        NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:signature];
        [invocation setTarget:self];
        [invocation setSelector:@selector(sizeWithFont:constrainedToSize:)];
        [invocation setArgument:&font atIndex:2];
        [invocation setArgument:&size atIndex:3];
        [invocation invoke];
        [invocation getReturnValue:&resultSize];
    }
    
    return resultSize;
}
/**
 保留小数点后位数，不足位数加0
 */
-(NSString *)keepDecimal:(NSInteger)length
{
    NSString *result = [handlerDecimalNumber(self, NSRoundDown, length) stringValue];
    NSString *decimalString = result;
    NSString *target = @"";
    NSString *stringA = [decimalString componentsSeparatedByString:@"."].lastObject;
    if (length == 0) {
        return [decimalString componentsSeparatedByString:@"."].firstObject;
    }
    if ([decimalString componentsSeparatedByString:@"."].count > 1) {
        if (stringA.length>=length) {//
            stringA = [stringA substringToIndex:length];
        }else{
            NSInteger stringALenth = stringA.length;
            for (int i=0;i< length-stringALenth;i++) {
                stringA = [stringA stringByAppendingString:@"0"];
            }
        }
        target = string( [decimalString componentsSeparatedByString:@"."].firstObject, string(@".", stringA));
    }else{
        target = string([decimalString componentsSeparatedByString:@"."].firstObject, @".");
        for (int i=0;i<length;i++) {
            target = [target stringByAppendingString:@"0"];
        }
    }
    
    return target;
}
/**
 删除末尾多余的0
 */
-(NSString*)removeFloatAllZero
{
    NSString * string = self;
    if ([string rangeOfString:@"."].location == NSNotFound) {
        return string;
    }
    //循环将末尾的0删除
    while ([string hasSuffix:@"0"]) {
        string = [string substringToIndex:[string length]-1];
    }
    //如果以.结尾，删除小数点
    if ([string hasSuffix:@"."]) {
        string = [string substringToIndex:[string length]-1];
    }
    return string;
}


-(NSString *)toTenThousandUnit
{
    NSString *result = self;
    double num = [result doubleValue];
    if (num >= 10000.0) {
        double numTemp = num/10000;
        NSString *result = [NSString stringWithFormat:@"%.2f",numTemp];
        return result = string(result, kLocalizedString(@"万"));
    }
    return [NSString stringWithFormat:@"%.0lf",num];
}
/**
 转换成以k为单位
 */
- (NSString *)toThousandUnit
{
    NSString *numberStr = [self keepDecimal:8];
    double number = numberStr.doubleValue;
    if (number < 10) {
        numberStr = [numberStr keepDecimal:3];
    }else if (number >= 10 && number < 1000){
        numberStr = [numberStr keepDecimal:0];
    }else{
        numberStr = [NSString stringWithFormat:@"%.1lfk",number/1000.0];
    }
    return numberStr;
}
#pragma mark -- 根据数值大小保留小数位
- (NSString *)autoLimitDecimals
{
    NSString *tempStr = [self keepDecimal:8];
    //整数部分
    NSString *integerStr = [tempStr componentsSeparatedByString:@"."].firstObject;
    //保留小数位数:整数位为1位，保留8位；整数位为两位，小数位保留7位，依次类推
    NSInteger length = 8 - integerStr.length + 1;
    if (length < 0) {
        length = 0;
    }
    return [tempStr keepDecimal:length];
}
-(NSMutableAttributedString *)changeSubStr:(NSString *)subStr subStrColor:(UIColor *)color{
    NSMutableAttributedString *mAttStri = [[NSMutableAttributedString alloc] initWithString:self];
    if(![self isBlankString:subStr] && color)
    {
        NSRange range = [self rangeOfString:subStr];
        [mAttStri addAttribute:NSForegroundColorAttributeName value:color range:range];
    }
    return mAttStri;
}

- (BOOL)isBlankString:(NSString *)str {
    if (!str) {
        return YES;
    }
    if ([str isKindOfClass:[NSNull class]]) {
        return YES;
    }
    if (!str.length) {
        return YES;
    }
    NSCharacterSet *set = [NSCharacterSet whitespaceAndNewlineCharacterSet];
    NSString *trimmedStr = [str stringByTrimmingCharactersInSet:set];
    if (!trimmedStr.length) {
        return YES;
    }
    return NO;
    
}

- (NSString *)clearAllBlankStr
{
    return [self stringByReplacingOccurrencesOfString:@" " withString:@""];
}

- (NSString *)handleTimeFormat:(NSString *)dateFormat
{
    if (![self isBlankString:dateFormat] ) {
        
       NSDate * date = [NSDate date:self WithFormat:@"yyyy-MM-dd'T'HH:mm:ss.SSSZ"];

       return  [date stringWithFormat:dateFormat];

    }
    return self;
}


- (NSString *)handleDefaultTimeFormat
{
    NSString *dateFormat = @"mm:ss MM/dd";
    return [self handleTimeFormat:dateFormat];
}

+ (NSString *)mg_handleTime:(NSString *)timeStr
{
    
    long long time = [timeStr longLongValue] / 1000;
    NSNumber *timer = [NSNumber numberWithLongLong:time];
    NSTimeInterval interval = [timer doubleValue];
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:interval];
    //设置日期格式
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    return [formatter stringFromDate:date];
}

///时间戳转化为字符
- (NSString *)time_timestampToStringFmt:(NSString *)changeFormat;{
    
    NSDate *confromTimesp = [NSDate dateWithTimeIntervalSince1970:[self integerValue]/1000.0];
    
    NSDateFormatter *dateFormat=[[NSDateFormatter alloc]init];
    
    [dateFormat setDateFormat:changeFormat];
    
    NSString* string=[dateFormat stringFromDate:confromTimesp];
    
    return string;
    
}
@end
