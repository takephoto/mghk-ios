// MGC
//
// TTWBaseWebViewController.m
// WKWebView
//
// Created by MGC on 2018/1/23.
// Copyright © 2018年 MGCion. All rights reserved.
//
// @ description <#描述#> 

#import "TTWBaseWebViewController.h"
#import "TTWMessageHandler.h"

///系统导航和tabbar高度
#define web_StatusBarHeight [[UIApplication sharedApplication] statusBarFrame].size.height //状态栏高度
#define web_NavBarHeight 44.0
#define web_TabBarHeight ([[UIApplication sharedApplication] statusBarFrame].size.height>20?83:49) //底部tabbar高度
#define web_TopHeight (web_StatusBarHeight + web_NavBarHeight) //整个导航栏高度

@interface TTWBaseWebViewController ()<WKNavigationDelegate,WKUIDelegate,WKDelegate>
{
    NSTimer *_timer;
}
@property (nonatomic, copy) NSString * reloadUrlString;
@property (nonatomic, strong) NSArray * messageSelNames;
@property (nonatomic, copy) NSString *urlString;//网页链接
@end

@implementation TTWBaseWebViewController

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    //添加KVO监听
    [self.webView addObserver:self
                   forKeyPath:@"loading"
                      options:NSKeyValueObservingOptionNew
                      context:nil];
    [self.webView addObserver:self
                   forKeyPath:@"title"
                      options:NSKeyValueObservingOptionNew
                      context:nil];
    [self.webView addObserver:self
                   forKeyPath:@"estimatedProgress"
                      options:NSKeyValueObservingOptionNew
                      context:nil];
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    //移除监听
    [self.webView removeObserver:self forKeyPath:@"loading"];
    [self.webView removeObserver:self forKeyPath:@"title"];
    [self.webView removeObserver:self forKeyPath:@"estimatedProgress"];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self creatWebView];
    [self creatProgressView];
    
    
}

-(void)creatProgressView{
    self.progressView = [[UIProgressView alloc]initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 5)];
    self.progressView.transform = CGAffineTransformMakeScale(1.0f, 1.5f);
    self.progressView.tintColor = [UIColor blueColor];
    self.progressView.trackTintColor = [UIColor clearColor];
    [self.view addSubview:self.progressView];
}
//创建webView
-(void)creatWebView{
    
    WKWebViewConfiguration *config = [WKWebViewConfiguration new];
    config.preferences = [WKPreferences new];
    config.preferences.javaScriptEnabled = YES;
    config.preferences.javaScriptCanOpenWindowsAutomatically = YES;
    config.userContentController = [WKUserContentController new];
    
    WKPreferences *preferences = [WKPreferences new];
    config.preferences = preferences;
    preferences.javaScriptCanOpenWindowsAutomatically = YES;
    
    self.webView = [[WKWebView alloc]initWithFrame:self.view.bounds configuration:config];
    [self.view addSubview:self.webView];
    self.webView.scrollView.showsVerticalScrollIndicator = NO;
    self.webView.scrollView.showsHorizontalScrollIndicator = NO;
    self.webView.navigationDelegate = self;
    self.webView.UIDelegate = self;
    //[self.webView addSubview:self.errorView];
    
    if (@available(iOS 11.0, *)) {
        self.webView.scrollView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    } else {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
}


#pragma mark - KVO监听函数
-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context{
    if ([keyPath isEqualToString:@"title"]) {
        self.title = self.webView.title;
    }else if([keyPath isEqualToString:@"loading"]){
        
    }
    if (object == self.webView && [keyPath isEqualToString:@"estimatedProgress"]) {
        CGFloat newprogress = [[change objectForKey:NSKeyValueChangeNewKey] doubleValue];
        
        if (newprogress >= 0.8) {
            [self.progressView setProgress:0.8 animated:YES];
            [UIView animateWithDuration:0.5 animations:^{
                self.progressView.alpha = 0;
            } completion:^(BOOL finished) {
                [self.progressView setProgress:0 animated:NO];
            }];
            
        }else {
            self.progressView.alpha = 1.0;
            [self.progressView setProgress:newprogress animated:YES];
        }
    }
    
}

#pragma mark - WKNavigationDelegate

/**
 *  页面开始加载时调用
 */
- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation {
    //self.errorView.hidden = YES;
}

/**
 *  当内容开始返回时调用
 */
- (void)webView:(WKWebView *)webView didCommitNavigation:(WKNavigation *)navigation {
    //self.errorView.hidden = YES;
}

/**
 *  页面加载完成之后调用
 */
- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation {
    //self.errorView.hidden = YES;
    
  
}

/**
 *  加载失败时调用
 */
- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(WKNavigation *)navigation withError:(NSError *)error {
    
    NSURL *url = [error.userInfo valueForKey:@"NSErrorFailingURLKey"];
    self.reloadUrlString = url.absoluteString;
    if ([url.scheme isEqualToString:@"tel"]) return;
    
    if(self.loadErrorBlock) self.loadErrorBlock(error);
    //self.errorView.hidden = NO;
}

/* 网页在提交数据加载失败时调用 */
- (void)webView:(WKWebView *)webView didFailNavigation:(null_unspecified WKNavigation *)navigation withError:(NSError *)error{
    self.reloadUrlString = webView.URL.absoluteString;
    
}

/**
 *  接收到服务器跳转请求之后调用
 */
- (void)webView:(WKWebView *)webView didReceiveServerRedirectForProvisionalNavigation:(WKNavigation *)navigation {
    
}

/**
 *  在收到响应后，决定是否跳转
 */
- (void)webView:(WKWebView *)webView decidePolicyForNavigationResponse:(WKNavigationResponse *)navigationResponse decisionHandler:(void (^)(WKNavigationResponsePolicy))decisionHandler {
    
    decisionHandler(WKNavigationResponsePolicyAllow);
    
}

/**
 *  在发送请求之前，决定是否跳转
 */
- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler {
    
    NSString *hostname = navigationAction.request.URL.host.lowercaseString;
    WKFrameInfo *frameInfo = navigationAction.targetFrame;
    BOOL isMainframe =[frameInfo isMainFrame];
    if (!isMainframe) {//打开新页面显示
        
        NSURL *url = navigationAction.request.URL;
        UIApplication *app = [UIApplication sharedApplication];
        if ([app canOpenURL:url])  [app openURL:url];
        
        decisionHandler(WKNavigationActionPolicyCancel);
    }else  {
            self.progressView.alpha = 1.0;
            decisionHandler(WKNavigationActionPolicyAllow);
        }
    
    
}

#pragma mark - WKUIDelegate js处理
//js调用原生弹框
// 创建一个新的WebView
- (WKWebView *)webView:(WKWebView *)webView createWebViewWithConfiguration:(WKWebViewConfiguration *)configuration forNavigationAction:(WKNavigationAction *)navigationAction windowFeatures:(WKWindowFeatures *)windowFeatures{
    
    //强制让webView加载打开的链接
    if (!navigationAction.targetFrame.isMainFrame) {
        [webView loadRequest:navigationAction.request];
    }
    if (navigationAction.targetFrame == nil) {
        [webView loadRequest:navigationAction.request];
    }
    return nil;
    
    
}
// 输入框
- (void)webView:(WKWebView *)webView runJavaScriptTextInputPanelWithPrompt:(NSString *)prompt defaultText:(nullable NSString *)defaultText initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(NSString * __nullable result))completionHandler{
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"textinput" message:@"JS调用输入框" preferredStyle:UIAlertControllerStyleAlert];
    [alert addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.textColor = [UIColor redColor];
    }];
    
    [alert addAction:[UIAlertAction actionWithTitle:kLocalizedString(@"确定") style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        completionHandler([[alert.textFields lastObject] text]);
    }]];
    
    [self presentViewController:alert animated:YES completion:NULL];
}
// 确认框
- (void)webView:(WKWebView *)webView runJavaScriptConfirmPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(BOOL result))completionHandler{
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"confirm" message:message preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:kLocalizedString(@"确定") style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        completionHandler(YES);
    }]];
    [alert addAction:[UIAlertAction actionWithTitle:kLocalizedString(@"取消") style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        completionHandler(NO);
    }]];
    [self presentViewController:alert animated:YES completion:NULL];
    
}
// 警告框
- (void)webView:(WKWebView *)webView runJavaScriptAlertPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(void))completionHandler{
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"alert" message:message preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:kLocalizedString(@"确定") style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        completionHandler();
    }]];
    
    [self presentViewController:alert animated:YES completion:NULL];
    
}

#pragma mark - WKScriptMessageHandler
//添加js方法
- (void)addScriptMessageSelName:(NSArray *)names{
    //注册方法
    TTWMessageHandler * delegateController = [[TTWMessageHandler alloc]init];
    delegateController.delegate = self;
    
    self.messageSelNames = [names copy];
    
    for(int i=0;i<names.count;i++){
        [self.webView.configuration.userContentController addScriptMessageHandler:delegateController  name:names[i]];
    }
}
//移除js方法
- (void)dealloc{
    //这里需要注意，前面增加过的方法一定要remove掉。
    for (NSString * name in self.messageSelNames) {
        [self.webView.configuration.userContentController removeScriptMessageHandlerForName:name];
    }
    
}
//js方法回掉
- (void)userContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(WKScriptMessage *)message{
    
    // NSLog(@"name:%@\\\\n body:%@\\\\n frameInfo:%@\\\\n",message.name,message.body,message.frameInfo);
    if ([message.name isEqualToString:@"ScanAction"]) {
        
    } else if ([message.name isEqualToString:@"Location"]) {
        //[self getLocation];
    } else if ([message.name isEqualToString:@"Share"]) {
       // [self shareWithParams:message.body];
    }
}


#pragma mark - private method
- (void)getLocation
{
    // 获取位置信息
    
    // 将结果返回给js
    NSString *jsStr = [NSString stringWithFormat:@"setLocation('%@')",@"广东省深圳市南山区学府路XXXX号"];
    [self.webView evaluateJavaScript:jsStr completionHandler:^(id _Nullable result, NSError * _Nullable error) {
        NSLog(@"%@----%@",result, error);
    }];
    
    NSString *jsStr2 = @"window.ctuapp_share_img";
    [self.webView evaluateJavaScript:jsStr2 completionHandler:^(id _Nullable result, NSError * _Nullable error) {
        NSLog(@"%@----%@",result, error);
    }];
}

- (void)shareWithParams:(NSDictionary *)tempDic
{
    if (![tempDic isKindOfClass:[NSDictionary class]]) {
        return;
    }
    
    NSString *title = [tempDic objectForKey:@"title"];
    NSString *content = [tempDic objectForKey:@"content"];
    NSString *url = [tempDic objectForKey:@"url"];
    // 在这里执行分享的操作
    
    // 将分享结果返回给js
    NSString *jsStr = [NSString stringWithFormat:@"shareResult('%@','%@','%@')",title,content,url];
    [self.webView evaluateJavaScript:jsStr completionHandler:^(id _Nullable result, NSError * _Nullable error) {
        NSLog(@"%@----%@",result, error);
    }];
}



#pragma mark - LazyLoad
//- (TTWErrorWebView *)errorView{
//
//    if (!_errorView) {
//        __weak typeof(self)weakSelf = self;
//        _errorView = [[TTWErrorWebView alloc] initErrorViewWithFrame:self.view.frame ReloadBlock:^{
//            __strong typeof(self)strongSelf = weakSelf;
//            strongSelf.progressView.progress = 0;
//            NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:strongSelf.reloadUrlString] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:20];
//            [strongSelf.webView loadRequest:request];
//
//        } ];
//        _errorView.hidden = YES;
//    }
//    return _errorView;
//}

#pragma 加载网络string
- (void)loadUrlWithString:(NSString *)urlString;
{
    
    self.urlString = urlString;
    self.reloadUrlString = urlString;
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:urlString] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:20];
    [self.webView loadRequest:request];
}

#pragma 直接加载url
- (void)loadUrlWithUrl:(NSURL *)url{

    NSURLRequest *request = [NSURLRequest requestWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:20];
    [self.webView loadRequest:request];
}

#pragma mark --set
//本地链接
-(void)setFileURL:(NSURL *)fileURL{
    _fileURL = fileURL;
    [self.webView loadFileURL:fileURL allowingReadAccessToURL:fileURL];
}



//设置最小字体
-(void)setMinimumFontSize:(NSInteger)minimumFontSize{
    _minimumFontSize = minimumFontSize;
    self.webView.configuration.preferences.minimumFontSize = minimumFontSize;
}



@end
