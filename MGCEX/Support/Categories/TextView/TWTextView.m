//
//  XDTextView.m
//  weibo
//
//  Created by dxd on 16/6/13.
//  Copyright © 2016年 dxd. All rights reserved.
//

#import "TWTextView.h"

@implementation TWTextView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self == [super initWithFrame:frame]) {
        // 通知 当UITextView的文字发生改变时，UITextView自己会发出一个UITextViewTextDidChangeNotification通知
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textDidChange:) name:UITextViewTextDidChangeNotification object:self];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textDidBeginEditing:) name:UITextViewTextDidBeginEditingNotification object:self];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textDidEndEditing:) name:UITextViewTextDidEndEditingNotification object:self];
        self.delegate = self;
        self.x = 0;
    }
    return self;
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    // 通知 当UITextView的文字发生改变时，UITextView自己会发出一个UITextViewTextDidChangeNotification通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textDidChange:) name:UITextViewTextDidChangeNotification object:self];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textDidBeginEditing:) name:UITextViewTextDidBeginEditingNotification object:self];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textDidEndEditing:) name:UITextViewTextDidEndEditingNotification object:self];
    self.delegate = self;
    self.x = 0;
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    
    if (text.length == 0) return YES;
    
    NSInteger existedLength = textView.text.length;
    NSInteger selectedLength = range.length;
    NSInteger replaceLength = text.length;
    
    if (existedLength - selectedLength + replaceLength > self.limitLength) {
        
        return NO;
    }
    
    return YES;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

//开始编辑
-(void)textDidBeginEditing:(NSNotification *)noti{
    if(self.isBeginBlock){
        self.isBeginBlock(self.text);
    }
    
}

//结束编辑
-(void)textDidEndEditing:(NSNotification *)noti{
    if(self.isEndBlock){
        self.isEndBlock(self.text);
    }
    
}

/**
 *  监听文字改变
 */
- (void)textDidChange:(NSNotification *)noti
{
    if(self.isChangeBlock){
        self.isChangeBlock(self.text);
    }
    // 重绘 （重新调用）
    [self setNeedsDisplay];
}

/**
 *  占位文字
 */
- (void)setPlaceholder:(NSString *)placeholder
{
    _placeholder = [placeholder copy];
    
    [self setNeedsDisplay];
}

- (void)setX:(NSInteger)x
{
    _x = x;
    [self setNeedsDisplay];
}

/**
 *  占位文字的颜色
 */
- (void)setPlaceholderColor:(UIColor *)placeholderColor
{
    _placeholderColor = placeholderColor;
    
    [self setNeedsDisplay];
}


- (void)setAttributedText:(NSAttributedString *)attributedText
{
    [super setAttributedText:attributedText];
    // 当输入的是属性文字时，重绘即消除占位文字
    [self setNeedsDisplay];
}

- (void)setText:(NSString *)text
{
    [super setText:text];
    
    // setNeedsDisplay会在下一个消息循环时刻，调用drawRect;
    [self setNeedsDisplay];
}

- (void)setFont:(UIFont *)font
{
    [super setFont:font];
    
    [self setNeedsDisplay];
}



- (void)drawRect:(CGRect)rect
{
    // 如果有输入文字，就直接返回，不画占位文字
    if (self.hasText) return;
    
    // 文字属性
    NSMutableDictionary *attrs = [NSMutableDictionary dictionary];
    attrs[NSFontAttributeName] = self.font;
    attrs[NSForegroundColorAttributeName] = self.placeholderColor?self.placeholderColor:[UIColor grayColor];
    // 画文字
   
    CGFloat w = rect.size.width - 2 * self.x;
    CGFloat y = 8;
    CGFloat h = rect.size.height - 2 * y;
    CGRect placeholderRect = CGRectMake(self.x, y, w, h);
    [self.placeholder drawInRect:placeholderRect withAttributes:attrs];
}



@end
