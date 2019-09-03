// MGC
//
// TWBaseLayoutConstraint.m
// IOSFrameWork
//
// Created by MGC on 2018/4/27.
// Copyright © 2018年 MGCion. All rights reserved.
//
// @ description <#描述#> 

#import "TWBaseLayoutConstraint.h"
//xib适配
@implementation TWBaseLayoutConstraint
- (void)awakeFromNib
{
    [super awakeFromNib];
    self.constant = Adapted(self.constant);
}
@end
