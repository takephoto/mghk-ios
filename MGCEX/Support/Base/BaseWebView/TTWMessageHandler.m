// MGC
//
// TTWMessageHandler.m
// WKWebViewDemo
//
// Created by MGC on 2018/1/23.
// Copyright © 2018年 姜雨生. All rights reserved.
//
// @ description <#描述#> 

#import "TTWMessageHandler.h"

@implementation TTWMessageHandler

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)userContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(WKScriptMessage *)message{
    if ([self.delegate respondsToSelector:@selector(userContentController:didReceiveScriptMessage:)]) {
        [self.delegate userContentController:userContentController didReceiveScriptMessage:message];
    }
}

@end
