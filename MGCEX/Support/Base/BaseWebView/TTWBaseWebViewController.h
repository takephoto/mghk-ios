// MGC
//
// TTWBaseWebViewController.h
// WKWebView
//
// Created by MGC on 2018/1/23.
// Copyright © 2018年 MGCion. All rights reserved.
//
// @ description <#描述#> 

#import <UIKit/UIKit.h>
#import <WebKit/WebKit.h>
#import <JavaScriptCore/JavaScriptCore.h>
#import <WebKit/WebKit.h>

@interface TTWBaseWebViewController : TWBaseViewController
@property (nonatomic, strong) WKWebView *webView;//webview
@property (nonatomic, strong) NSURL *fileURL;//本地链接
@property (nonatomic, strong) UIProgressView *progressView;//进度条
@property (nonatomic, assign) NSInteger minimumFontSize;//最小字体大小

///加载页面失败
@property (nonatomic, copy) void(^loadErrorBlock)(NSError *error);


/**
 * @brief 添加JS方法
 * @param names 添加的方法名数组
 */
- (void)addScriptMessageSelName:(NSArray *)names;
/**
 * @brief 加载url
 * @param urlString 链接
 */
- (void)loadUrlWithString:(NSString *)urlString;

/**
 * @brief 加载url
 * @param url 链接
 */
- (void)loadUrlWithUrl:(NSURL *)url;
@end
