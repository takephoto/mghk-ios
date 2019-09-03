// MGC
//
// NSURLSessionTask+TTWTask.h
// AFNNetworkingDemo
//
// Created by MGC on 2018/2/24.
// Copyright © 2018年 MGCion. All rights reserved.
//
// @ description <#描述#> 

#import <Foundation/Foundation.h>

@interface NSURLSessionTask (TTWTask)
///是否显示菊花
@property (nonatomic, strong) NSString *shouldShowHUD;
///该请求发起时的当前控制器（用于点击返回时，取消当前控制器的所以请求）
@property (nonatomic, strong) NSString *currentVC;
@end
