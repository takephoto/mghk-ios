//
//  MGTraderVerificationCellVM.m
//  MGCEX
//
//  Created by 汪跃山 on 2018/6/26.
//  Copyright © 2018年 MGCion. All rights reserved.
//

#import "MGTraderVerificationCellVM.h"

@implementation MGTraderVerificationCellVM

- (id)initWithBgImage:(UIImage *)bgImage
            iconImage:(UIImage *)iconImage
            titleText:(NSString *)titleText
        subTitle1Text:(NSString *)subTitle1Text
        subTitle2Text:(NSString *)subTitle2Txet
{
    if (self = [super init]) {
        _bgImage = bgImage;
        _iconImage = iconImage;
        _titleText = titleText;
        _subTitle1Text = subTitle1Text;
        _subTitle2Text = subTitle2Txet;
    }
    return self;
}

@end
