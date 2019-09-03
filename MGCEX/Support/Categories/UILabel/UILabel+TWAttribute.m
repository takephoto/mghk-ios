// MGC
//
// UILabel+TWAttribute.m
// Label高度计算图文混排
//
// Created by MGC on 2017/10/27.
// Copyright © 2017年 MGCion. All rights reserved.
//
// @ description <#描述#> 

#import "UILabel+TWAttribute.h"

@implementation UILabel (TWAttribute)


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


+ (NSAttributedString *)mg_attributedTextArray:(NSArray *)texts
                                 textColors:(NSArray *)colors
                                  textfonts:(NSArray *)fonts
                                lineSpacing:(CGFloat)l_spacing
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
    
    if(l_spacing>0){
        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
        paragraphStyle.lineSpacing = l_spacing;
        [resultAttributedStr addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, resultAttributedStr.length)];
    }
    
    
    return resultAttributedStr;
}


+ (CGSize)mg_sizeLabelWidth:(CGFloat)width
          attributedText:(NSAttributedString *)attributted
{
    if(width<=0){
        return CGSizeZero;
    }
    

    UILabel *lab = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, width, 1000)];
    lab.attributedText = attributted;
    lab.numberOfLines = 0;
    
    CGSize labSize = [lab sizeThatFits:lab.bounds.size];
    return labSize;
}

+ (CGSize)mg_sizeLabelWidth:(CGFloat)width
                    text:(NSString *)text
                    font:(UIFont *)font
{
    if(width<=0 || text.length == 0){
        return CGSizeZero;
    }
    
   
    UILabel *lab = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, width, 1000)];
    lab.text = text;
    if(font){
        lab.font = font;
    }
    
    CGSize labSize = [lab sizeThatFits:lab.bounds.size];
    return labSize;
}


+ (CGSize)mg_sizeLabelWidth:(CGFloat)width
                    text:(NSString *)text
                    font:(UIFont *)font
             lineSpacing:(CGFloat)l_spacing
{
    if(width<=0 || text.length == 0){
        return CGSizeZero;
    }
    
    
    if(l_spacing<=0){
        UILabel *lab = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, width, 1000)];
        lab.text = text;
        lab.numberOfLines = 0;
        if(font){
            lab.font = font;
        }
        
        CGSize labSize = [lab sizeThatFits:lab.bounds.size];
        return labSize;
    }
    else
    {
        UILabel *lab = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, width, 1000)];
        lab.numberOfLines = 0;
        if(font){
            lab.font = font;
        }
        NSMutableAttributedString *mAttriStr = [[NSMutableAttributedString alloc] initWithString:text];
        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
        paragraphStyle.lineSpacing = l_spacing;
        [mAttriStr addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, text.length)];
        lab.attributedText = mAttriStr;
        
        CGSize labSize = [lab sizeThatFits:lab.bounds.size];
        return labSize;
    }
}

@end
