// MGC
//
// TableViewErrorView.h
// IOSFrameWork
//
// Created by MGC on 2018/4/28.
// Copyright © 2018年 MGCion. All rights reserved.
//
// @ description <#描述#> 

#import <UIKit/UIKit.h>
#import "TTWUtilsMacro.h"

@interface TableViewErrorView : UIView

singletonInterface(TableViewErrorView);

/**
 * 页面没数据处理
 */
+(void)showErrorWithImage:(UIImage *)image msg:(NSString *)msg toView:(UIView *)toView;

+(void)hidden;
@end
