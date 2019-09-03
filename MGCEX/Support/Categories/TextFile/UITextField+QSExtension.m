//
//  UITextField+QSExtension.m
//  test
//
//  Created by apple on 2016/11/12.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "UITextField+QSExtension.h"
#import <objc/runtime.h>

@interface UITextField()<UITextFieldDelegate>

@end

/** 占位文字颜色的属性 */
static NSString * const QSPlaceholderColorKey = @"placeholderLabel.textColor";

#pragma mark - 新增属性key
static NSString *shouldBeginEditBlockKey = @"shouldBeginEditBlockKey";
static NSString *didChangeBlockKey = @"didChangeBlockKey";
static NSString *endEditBlockKey = @"endEditBlockKey";
static NSString *returnKeyBlockKey = @"returnKeyBlockKey";
static NSString *limitTextLengthKey = @"limitTextLengthKey";
static NSString *textLengthOverLimitedBlockKey = @"textLengthOverLimitedBlockKey";
static NSString *limitDecimalDigitLengthKey = @"limitDecimalDigitLengthKey";
static NSString *divideStringIntervalCountKey = @"divideStringIntervalCountKey";
static NSString *canNotEnterEmojiKey = @"canNotEnterEmojiKey";


@implementation UITextField (QSExtension)
/**
 *  设置占位符颜色
 */
- (void)setPlaceholderColor:(UIColor *)placeholderColor
{
    BOOL change = NO;
    
    // 保证有占位文字
    if (self.placeholder == nil) {
        self.placeholder = @" ";
        change = YES;
    }
    
    // 设置占位文字颜色
    [self setValue:placeholderColor forKeyPath:QSPlaceholderColorKey];
    
    // 恢复原状
    if (change) {
        self.placeholder = nil;
    }
}

/**
 *  获取占位符颜色
 */
- (UIColor *)placeholderColor
{
    return [self valueForKeyPath:QSPlaceholderColorKey];
}

#pragma mark - 是否允许开始编辑回调
- (void)setShouldBeginEditBlock:(BOOL (^)(void))shouldBeginEditBlock
{
    self.delegate = self.delegate ? self.delegate : self;
    objc_setAssociatedObject(self, &shouldBeginEditBlockKey, shouldBeginEditBlock, OBJC_ASSOCIATION_COPY);
}

- (BOOL (^)(void))shouldBeginEditBlock
{
    return objc_getAssociatedObject(self, &shouldBeginEditBlockKey);
}

#pragma mark - 内容改变回调
- (void)setDidChangeBlock:(void (^)(NSString *))didChangeBlock
{
    self.delegate = self.delegate ? self.delegate : self;
    objc_setAssociatedObject(self, &didChangeBlockKey, didChangeBlock, OBJC_ASSOCIATION_COPY);
}

- (void (^)(NSString *))didChangeBlock
{
    return objc_getAssociatedObject(self, &didChangeBlockKey);
}

#pragma mark - 结束编辑回调
- (void)setEndEditBlock:(void (^)(NSString *))endEditBlock
{
    self.delegate = self.delegate ? self.delegate : self;
    objc_setAssociatedObject(self, &endEditBlockKey, endEditBlock, OBJC_ASSOCIATION_COPY);
}

- (void (^)(NSString *))endEditBlock
{
    return objc_getAssociatedObject(self, &endEditBlockKey);
}

#pragma mark - return键事件回调
- (void)setReturnKeyBlock:(void (^)(NSString *))returnKeyBlock
{
    self.delegate = self.delegate ? self.delegate : self;
    objc_setAssociatedObject(self, &returnKeyBlockKey, returnKeyBlock, OBJC_ASSOCIATION_COPY);
}

- (void (^)(NSString *))returnKeyBlock
{
    return objc_getAssociatedObject(self, &returnKeyBlockKey);
}

#pragma mark - 限制输入的长度
- (void)setLimitTextLength:(NSInteger)limitTextLength
{
    [self addTarget:self action:@selector(limitTheTextLength:) forControlEvents:UIControlEventEditingChanged];
    objc_setAssociatedObject(self, &limitTextLengthKey, @(limitTextLength), OBJC_ASSOCIATION_COPY);
}

- (NSInteger)limitTextLength
{
    NSNumber *number = objc_getAssociatedObject(self, &limitTextLengthKey);
    return [number integerValue];
}

#pragma mark - 能否输入emoji表情
- (void)setCanNotEnterEmoji:(BOOL)canNotEnterEmoji
{
    self.delegate = self.delegate ? self.delegate : self;
    objc_setAssociatedObject(self, &canNotEnterEmojiKey, @(canNotEnterEmoji), OBJC_ASSOCIATION_COPY);
}

- (BOOL)canNotEnterEmoji
{
    return objc_getAssociatedObject(self, &canNotEnterEmojiKey);
}


#pragma mark - 限制输入小数位数的长度
- (void)setLimitDecimalDigitLength:(NSString*)limitDecimalDigitLength
{
    self.delegate = self.delegate ? self.delegate : self;
    objc_setAssociatedObject(self, &limitDecimalDigitLengthKey, limitDecimalDigitLength, OBJC_ASSOCIATION_COPY);
}

- (NSString *)limitDecimalDigitLength
{
    NSString *number = objc_getAssociatedObject(self, &limitDecimalDigitLengthKey);
    return number;
}

- (void)setDivideStringIntervalCount:(NSInteger)divideStringIntervalCount
{
    self.delegate = self.delegate ? self.delegate : self;
    objc_setAssociatedObject(self, &divideStringIntervalCountKey, @(divideStringIntervalCount), OBJC_ASSOCIATION_COPY);
}

- (NSInteger)divideStringIntervalCount
{
    NSNumber *number = objc_getAssociatedObject(self, &divideStringIntervalCountKey);
    return [number integerValue];
}

#pragma mark - 字符超过限制回调
- (void)setTextLengthOverLimitedBlock:(void (^)(NSInteger))textLengthOverLimitedBlock
{
    objc_setAssociatedObject(self, &textLengthOverLimitedBlockKey, textLengthOverLimitedBlock, OBJC_ASSOCIATION_COPY);
}

- (void (^)(NSInteger))textLengthOverLimitedBlock
{
    return objc_getAssociatedObject(self, &textLengthOverLimitedBlockKey);
}

/**
 *  限制字符长度
 */
- (void)limitTheTextLength:(UITextField *)textField
{
    if (textField == self) {
        
        if (textField.text.length > self.limitTextLength) {
            textField.text = [textField.text substringToIndex:self.limitTextLength];
            if (self.textLengthOverLimitedBlock) {
                self.textLengthOverLimitedBlock(self.limitTextLength);
            }
        }
    }
}

#pragma mark - UITextFieldDelegate
/**
 *  是否允许开始编辑
 *
 *  return yes：允许； no：不允许
 */
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    if (self.shouldBeginEditBlock) {
        return self.shouldBeginEditBlock();
    }
    return YES;
}

/**
 *  进入编辑状态
 */
-(void)textFieldDidBeginEditing:(UITextField *)textField{
    // 直接代码调用setText输入的会调用这个方法
    [textField addObserver:self forKeyPath:@"text" options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld context:NULL];
    
    // 监控数据改变
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFiledDidChange:) name:UITextFieldTextDidChangeNotification object:nil];
}

/**
 *  直接代码调用setText输入的会调用这个方法
 */
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context{
    
    NSString * string = [change valueForKey:@"new"];
    if (self.didChangeBlock) {
        self.didChangeBlock(string);
    }
}

/**
 *  在某个区域改变字符
 */
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if (self.canNotEnterEmoji) {
        if ([[[textField textInputMode] primaryLanguage] isEqualToString:@"emoji"] || ![[textField textInputMode] primaryLanguage]) {
            return NO;
        }
        
        //判断键盘是不是九宫格键盘
        if ([self isNineKeyBoard:string] ){
            return YES;
        }else{
            if ([self hasEmoji:string] || [self stringContainsEmoji:string]){
                return NO;
            }
        }
    }
    
    if (self.limitDecimalDigitLength.length > 0) {
        // 限制小数点后位数
        if ([self.limitDecimalDigitLength integerValue] > 0) {
            BOOL isHaveDian = false;
            if ([textField.text rangeOfString:@"."].location == NSNotFound) {
                isHaveDian = NO;
            } else {
                isHaveDian = YES;
            }
            
            if ([string length]>0) {
                unichar single = [string characterAtIndex:0];//当前输入的字符
                //首字母不能为小数点
                if([textField.text length]==0){
                    if(single == '.'){
                        [textField.text stringByReplacingCharactersInRange:range withString:@""];
                        return NO;
                    }
                }
                
                if (single=='.')
                {
                    if(!isHaveDian)//text中还没有小数点
                    {
                        isHaveDian=YES;
                        return YES;
                    } else {
                        [textField.text stringByReplacingCharactersInRange:range withString:@""];
                        return NO;
                    }
                } else {
                    NSMutableString * futureString = [NSMutableString stringWithString:textField.text];
                    [futureString  insertString:string atIndex:range.location];
                    NSInteger flag = 0;
                    const NSInteger limited = [self.limitDecimalDigitLength integerValue];
                    for (int i = (int)futureString.length - 1; i >= 0; i--) {
                        
                        if ([futureString characterAtIndex:i] == '.') {
                            if (flag > limited) {
                                return NO;
                            }
                            break;
                        }
                        flag++;
                    }
                }
            }
        }else{
            if ([string isEqualToString:@"."]) {
                return NO;
            }
        }
    }
    
    
    // 四位加一个空格
    if (self.divideStringIntervalCount > 0) {
        if ([string isEqualToString:@""]) { // 删除字符
            if ((textField.text.length - 2) % (self.divideStringIntervalCount + 1) == 0) {
                textField.text = [textField.text substringToIndex:textField.text.length - 1];
            }
            return YES;
        } else {
            if (textField.text.length % (self.divideStringIntervalCount + 1) == 0) {
                textField.text = [NSString stringWithFormat:@"%@ ", textField.text];
            }
        }
    }
    
    return YES;
}

/**
 *  输入内容改变
 */
-(void)textFiledDidChange:(NSNotification *)not
{
    // 获取输入框中的内容
    NSString * string = [not.object description];
    NSRange range = [string rangeOfString:@"\'"];
    NSString * subStr = [string substringFromIndex:range.location + 1];
    NSRange subRange = [subStr rangeOfString:@"\'"];
    NSString * text = [subStr substringToIndex:subRange.location];
    
    if (self.didChangeBlock) {
        self.didChangeBlock(text);
    }
}

/**
 *  结束编辑
 */
- (void)textFieldDidEndEditing:(UITextField *)textField
{
    // 删除通知监听者
    [textField removeObserver:self forKeyPath:@"text"];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    if (self.endEditBlock) {
        self.endEditBlock(textField.text);
    }
}

/**
 *  是否响应键盘的return按钮点击
 *
 *  return yes：响应； no：忽略
 */
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self.superview endEditing:YES];
    if (self.returnKeyBlock) {
        self.returnKeyBlock(textField.text);
    }
    return NO;
}

#pragma mark - Private Methods
/**
 *  判断字符串中是否存在emoji
 * @param string 字符串
 * @return YES(含有表情)
 */
- (BOOL)stringContainsEmoji:(NSString *)string {
    
    __block BOOL returnValue = NO;
    
    [string enumerateSubstringsInRange:NSMakeRange(0, [string length]) options:NSStringEnumerationByComposedCharacterSequences usingBlock:
     ^(NSString *substring, NSRange substringRange, NSRange enclosingRange, BOOL *stop) {
         
         const unichar hs = [substring characterAtIndex:0];
         // surrogate pair
         if (0xd800 <= hs && hs <= 0xdbff) {
             if (substring.length > 1) {
                 const unichar ls = [substring characterAtIndex:1];
                 const int uc = ((hs - 0xd800) * 0x400) + (ls - 0xdc00) + 0x10000;
                 if (0x1d000 <= uc && uc <= 0x1f77f) {
                     returnValue = YES;
                 }
             }
         } else if (substring.length > 1) {
             const unichar ls = [substring characterAtIndex:1];
             if (ls == 0x20e3) {
                 returnValue = YES;
             }
             
         } else {
             // non surrogate
             if (0x2100 <= hs && hs <= 0x27ff) {
                 returnValue = YES;
             } else if (0x2B05 <= hs && hs <= 0x2b07) {
                 returnValue = YES;
             } else if (0x2934 <= hs && hs <= 0x2935) {
                 returnValue = YES;
             } else if (0x3297 <= hs && hs <= 0x3299) {
                 returnValue = YES;
             } else if (hs == 0xa9 || hs == 0xae || hs == 0x303d || hs == 0x3030 || hs == 0x2b55 || hs == 0x2b1c || hs == 0x2b1b || hs == 0x2b50) {
                 returnValue = YES;
             }
         }
     }];
    
    return returnValue;
}

/**
 *  判断字符串中是否存在emoji
 * @param string 字符串
 * @return YES(含有表情)
 */
- (BOOL)hasEmoji:(NSString*)string;
{
    NSString *pattern = @"[^\\u0020-\\u007E\\u00A0-\\u00BE\\u2E80-\\uA4CF\\uF900-\\uFAFF\\uFE30-\\uFE4F\\uFF00-\\uFFEF\\u0080-\\u009F\\u2000-\\u201f\r\n]";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", pattern];
    BOOL isMatch = [pred evaluateWithObject:string];
    return isMatch;
}

/**
 判断是不是九宫格
 @param string  输入的字符
 @return YES(是九宫格拼音键盘)
 */
-(BOOL)isNineKeyBoard:(NSString *)string
{
    NSString *other = @"➋➌➍➎➏➐➑➒";
    int len = (int)string.length;
    for(int i=0;i<len;i++)
    {
        if(!([other rangeOfString:string].location != NSNotFound))
            return NO;
    }
    return YES;
}
@end
