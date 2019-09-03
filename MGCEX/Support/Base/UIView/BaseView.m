// MGC
//
// BaseView.m
// MGCEX
//
// Created by MGC on 2018/5/10.
// Copyright © 2018年 MGCion. All rights reserved.
//
// @ description <#描述#> 

#import "BaseView.h"

@implementation BaseView
-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self bindViewModel];
        [self setupSubviews];
    }
    return self;
}
- (void)bindViewModel{}
- (void)setupSubviews{
    
}
@end
