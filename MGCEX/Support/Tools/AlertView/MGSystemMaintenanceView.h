// MGC
//
// MGSystemMaintenanceView.h
// MGCEX
//
// Created by MGC on 2018/7/10.
// Copyright © 2018年 MGCion. All rights reserved.
//
// @ description <#描述#> 

#import <UIKit/UIKit.h>


@interface MGSystemMaintenanceView : UIView

singletonInterface(MGSystemMaintenanceView);

-(instancetype)initWithSupView:(UIView *)toView;

- (void)show;

-(void)hidden;

@end
