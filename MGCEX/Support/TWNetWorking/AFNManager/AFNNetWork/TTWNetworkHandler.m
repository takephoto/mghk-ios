// MGC
//
// TTWNetworkHandler.m
// AFNNetworkingDemo
//
// Created by MGC on 2018/2/23.
// Copyright © 2018年 MGCion. All rights reserved.
//
// @ description <#描述#> 

#import "TTWNetworkHandler.h"
#import <AFNetworking/AFNetworking.h>
#import <MBProgressHUD/MBProgressHUD.h>
#import "AFNetworkActivityIndicatorManager.h"
#import "TTWNetwork.h"
#import <YYCache/YYCache.h>
#import "NSDictionary+JLDeepCopy.h"
#import "LoginIndexVC.h"
#import "PersonalSettingsIndexVC.h"

//公共请求头
//static NSString * const HOST = @"http://192.168.22.38:8021/api/";
//缓存路径的名字
static NSString * const TTWRequestCache = @"TTWRequestCache";
///请求队列
static NSMutableArray *requestTasks;
///取消请求时是否回调
static BOOL shouldCallbackOnCancelRequest = YES;

static AFHTTPSessionManager *sg_sharedManager = nil;

@interface TTWNetworkHandler ()


@end

@implementation TTWNetworkHandler

+ (TTWNetworkHandler *)sharedInstance
{
    static TTWNetworkHandler *handler = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        handler = [[TTWNetworkHandler alloc] init];
    });
    return handler;
}

#pragma mark -- 获取任务队列
+ (NSMutableArray *)allTasks {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (requestTasks == nil) {
            requestTasks = [[NSMutableArray alloc] init];
        }
    });
    
    return requestTasks;
}
#pragma mark -- 取消全部请求
+ (void)cancelAllRequest {
    @synchronized(self) {
        [[self allTasks] enumerateObjectsUsingBlock:^(NSURLSessionTask * _Nonnull task, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([task isKindOfClass:[NSURLSessionTask class]]) {
                [task cancel];
            }
        }];
        
        [[self allTasks] removeAllObjects];
    };
}

/**
 *    取消所有缓存
 */
+ (void)removeAllCaches{
    YYCache *yyCache=[YYCache cacheWithName:TTWRequestCache];

    [yyCache removeAllObjects];

}
#pragma mark -- 取消指定请求
+ (void)cancelRequestWithURL:(NSString *)url {
    if (url == nil) {
        return;
    }
    @synchronized(self) {
        [[self allTasks] enumerateObjectsUsingBlock:^(NSURLSessionTask * _Nonnull task, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([task isKindOfClass:[NSURLSessionTask class]]
                && [task.currentRequest.URL.absoluteString hasSuffix:url]) {
                DLog(@"页面返回，取消请求URL：%@ \n",task.currentRequest.URL.absoluteString);
                [task cancel];
                [[self allTasks] removeObject:task];
                return;
            }
        }];
    };
}
#pragma mark -- 取消指定控制器的所以请求
+ (void)cancelRequestWithControllerName:(NSString *)controllerName
{
    if (controllerName == nil) {
        return;
    }
    @synchronized(self) {
        [[self allTasks] enumerateObjectsUsingBlock:^(NSURLSessionTask * _Nonnull task, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([task isKindOfClass:[NSURLSessionTask class]]
                && [task.currentVC isEqualToString:controllerName]) {
                DLog(@"取消请求URL：%@ \n 控制器：%@",task.currentRequest.URL.absoluteString,controllerName);
                [task cancel];
                [[self allTasks] removeObject:task];
                return;
            }
        }];
    };
}

+ (TTWURLSessionTask *)requestWithUrl:(NSString *)url
                            isShowHUD:(BOOL)isShowHUD
                             success:(TTWResponseSuccess)success
                                fail:(TTWResponseError)fail
{
    return [self requetWithUrl:url httpMethod:RequestByGet dataSourceType:FromServerOnly params:nil isShowHUD:(BOOL)isShowHUD progress:nil success:success fail:fail];
}
+ (TTWURLSessionTask *)requestWithUrl:(NSString *)url
                              params:(NSDictionary *)params
                            isShowHUD:(BOOL)isShowHUD
                             success:(TTWResponseSuccess)success
                                fail:(TTWResponseError)fail
{
    return [self requetWithUrl:url httpMethod:RequestByGet dataSourceType:FromServerOnly params:params isShowHUD:(BOOL)isShowHUD progress:nil success:success fail:fail];
}
+ (TTWURLSessionTask *)requestWithUrl:(NSString *)url
                       requestMethod:(TTWRequestMethod)requestMethod
                              params:(NSDictionary *)params
                            isShowHUD:(BOOL)isShowHUD
                             success:(TTWResponseSuccess)success
                                fail:(TTWResponseError)fail {
    return [self requetWithUrl:url httpMethod:requestMethod dataSourceType:FromServerOnly params:params isShowHUD:(BOOL)isShowHUD progress:nil success:success fail:fail];
}
+ (TTWURLSessionTask *)requestWithUrl:(NSString *)url
                       requestMethod:(TTWRequestMethod)requestMethod
                      dataSourceType:(TWRequestCachePolicy)dataSourceType
                              params:(NSDictionary *)params
                            isShowHUD:(BOOL)isShowHUD
                             success:(TTWResponseSuccess)success
                                fail:(TTWResponseError)fail {
    return [self requetWithUrl:url httpMethod:requestMethod dataSourceType:dataSourceType params:params isShowHUD:(BOOL)isShowHUD progress:nil success:success fail:fail];
}

+ (TTWURLSessionTask *)requestWithUrl:(NSString *)url
                       requestMethod:(TTWRequestMethod)requestMethod
                      dataSourceType:(TWRequestCachePolicy)dataSourceType
                              params:(NSDictionary *)params
                            isShowHUD:(BOOL)isShowHUD
                            progress:(TTWPostProgress)progress
                             success:(TTWResponseSuccess)success
                                fail:(TTWResponseError)fail {
    return [self requetWithUrl:url httpMethod:requestMethod dataSourceType:dataSourceType  params:params isShowHUD:(BOOL)isShowHUD progress:progress success:success fail:fail];
}

#pragma mark -- post get 网络请求
+ (TTWURLSessionTask *)requetWithUrl:(NSString *)url
                         httpMethod:(TTWRequestMethod)requestMethod
                     dataSourceType:(TWRequestCachePolicy)dataSourceType
                             params:(NSDictionary *)params
                           isShowHUD:(BOOL)isShowHUD
                           progress:(TTWGetProgress)progress
                            success:(TTWResponseSuccess)success
                               fail:(TTWResponseError)fail
{
    
    
    //检查网络
    if( [self checkTheNetwork] == NO&&dataSourceType==FromServerOnly){
        if(fail){
          fail(nil);
        }
        return nil;
    }
    //加上公共请求头
    url = [NSString stringWithFormat:@"%@%@",[TTWNetworkHandler sharedInstance].host_api,url];
    //url转码
    NSCharacterSet *encodeUrlSet = [NSCharacterSet URLQueryAllowedCharacterSet];
    NSString *encodeUrl = [url stringByAddingPercentEncodingWithAllowedCharacters:encodeUrlSet];
    
    
    //缓存策略
    switch (dataSourceType) {
        case FromCacheAndServer: {//先返回缓存，同时请求
            id object = [self YYCacheInitializeWithUrl:encodeUrl];
            if (object) {
                success(object);
            }
            break;
        }
        case FromServerOnly: {//忽略本地缓存直接请求
            //不做处理，直接请求
            break;
        }
        case FromCacheFirst: {//有缓存就返回缓存，没有就请求
            id object = [self YYCacheInitializeWithUrl:encodeUrl];
            
            if (object) {//有缓存
                success(object);
                return nil;
            }
            break;
        }
        case FromCacheOnly: {//有缓存就返回缓存,从不请求（用于没有网络）
            id object = [self YYCacheInitializeWithUrl:encodeUrl];
            if (object) {//有缓存
                success(object);
            }
            return nil;//退出从不请求
        }
        case FromServerThenCache: {//访问服务器，如果访问失败，则读缓存
            break;
        }
        default: {
            break;
        }
    }
   
    //处理参数,这里可以做一些公共参数处理
    NSMutableDictionary *paramsDefault;
    if(params){
        paramsDefault = [NSMutableDictionary  dictionaryWithDictionary:params];
    }else{
        paramsDefault = [NSMutableDictionary new];
    }
    
    //添加默认参数
    [self setDefaultParamsWithParameters:paramsDefault];

    AFHTTPSessionManager *manager = [self manager];
    NSURLSessionTask *session = nil;
    
    //发起网络请求
    //用于打印
    NSString *pramasString = paramsDefault[@"jsonString"];
 
    if (requestMethod == RequestByGet) {
        session = [manager GET:encodeUrl parameters:paramsDefault progress:^(NSProgress * _Nonnull downloadProgress) {
            if (progress) {
                progress(downloadProgress,downloadProgress.completedUnitCount, downloadProgress.totalUnitCount);
            }
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            DTLog(@"\n************************ \n url = %@ \n 参数 = %@ \n responseObject==%@ \n ************************ \n",url,pramasString,[responseObject yy_modelToJSONString]);
            [self removeTask:task];
            [self handleResultWithSuccessResponse:responseObject url:encodeUrl dataSourceType:dataSourceType params:params callBack:success];
            
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            
            DTLog(@"\n************************ \n url = %@ \n 参数 = %@ \n \n error==%@ \n \n ************************ \n",url,pramasString,error);
            
            if ([error code] == MGRepeatedRequests) {//重复请求被取消
                [self removeTask:task];
            }else{
                [self removeTask:task];
                //请求失败
                if (dataSourceType == FromServerThenCache) {// 获取缓存
                    id object = [self YYCacheInitializeWithUrl:encodeUrl];
                    if (object) {//有缓存返回缓存
                        if(success){
                            [self handleResultWithSuccessResponse:object url:encodeUrl dataSourceType:dataSourceType params:params callBack:success];
                        }
                    }else {
                        [self handleLogWithError:error url:url params:paramsDefault fail:fail];
                    }
                }else {
                    [self handleLogWithError:error url:url params:paramsDefault fail:fail];
                    
                }
            }
        }];
    }else if (requestMethod == RequestByPost){
        session = [manager POST:encodeUrl parameters:paramsDefault progress:^(NSProgress * _Nonnull downloadProgress) {
            if (progress) {
                progress(downloadProgress,downloadProgress.completedUnitCount, downloadProgress.totalUnitCount);
            }
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            DTLog(@"\n************************ \n url = %@  \n 参数 = %@ \n responseObject==%@ \n ************************ \n",url,pramasString,[responseObject yy_modelToJSONString]);
            [self removeTask:task];
            [self handleResultWithSuccessResponse:responseObject url:encodeUrl dataSourceType:dataSourceType params:params callBack:success];
            
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            
           DTLog(@"\n************************ \n url = %@ \n 参数 = %@ \n error==%@ \n ************************ \n ",url,pramasString,error);
            if ([error code] == MGRepeatedRequests) {//重复请求被取消
                [self removeTask:task];
            }else{
                [self removeTask:task];
                //请求失败
                if (dataSourceType == FromServerThenCache) {// 获取缓存
                    id object = [self YYCacheInitializeWithUrl:encodeUrl];
                    if (object) {//有缓存返回缓存
                        if(success){
                            [self handleResultWithSuccessResponse:object url:encodeUrl dataSourceType:dataSourceType params:params callBack:success];
                        }
                    }else {
                        [self handleLogWithError:error url:url params:paramsDefault fail:fail];
                    }
                }else {
                    [self handleLogWithError:error url:url params:paramsDefault fail:fail];
                    
                }
            }
            
        }];
    }
    session.shouldShowHUD = isShowHUD?@"YES":@"NO";
    session.currentVC = NSStringFromClass([[TWAppTool currentViewController] class]);
    if ([session.shouldShowHUD boolValue]) {
        [self showLoadingWithMaskView:YES];
    }
    if (session) {
        [[self allTasks] addObject:session];
    }
    return session;
}

+(id)YYCacheInitializeWithUrl:(NSString *)url{
    YYCache *cache = [[YYCache alloc] initWithName:TTWRequestCache];
    cache.memoryCache.shouldRemoveAllObjectsOnMemoryWarning = YES;
    cache.memoryCache.shouldRemoveAllObjectsWhenEnteringBackground = YES;
    NSString *cacheKey = url;
    id object = [cache objectForKey:cacheKey];
    DTLog(@"age缓存在内存：%d", [cache.memoryCache containsObjectForKey:TTWRequestCache]);
    DTLog(@"age缓存在文件：%d", [cache.diskCache containsObjectForKey:TTWRequestCache]);
    return object;
}

/**
 移除任务
 
 @param task 任务
 */
+ (void)removeTask:(NSURLSessionTask *)task
{
    NSMutableArray *taskArr = [self allTasks];
    [taskArr removeObject:task];
    BOOL shouldHideHUD = YES;
    //遍历是否还有需要显示HUD的任务
    for (NSURLSessionTask *taskTemp in taskArr) {
        if ([taskTemp.shouldShowHUD boolValue]) {
            shouldHideHUD = NO;
            break;
        }
    }
    if (shouldHideHUD) {
        [self dismissLoading];
    }

}
+ (void)handleResultWithSuccessResponse:(id)response
                                    url:(NSString *)absolute
                         dataSourceType:(TWRequestCachePolicy)dataSourceType
                                 params:(NSDictionary *)params callBack:(TTWResponseSuccess)success
{
    NSInteger code = [[response objectForKey:@"code"] integerValue];
    switch (code) {
        case MGSuccess:
            break;
        case MGTokenError:
            //异常处理
            [self disableLoginHandlingMethod];
            return;
        case MGNotLogin:
            //没登录
            [self disableLoginHandlingMethod];
            return;
        case MGTokenInvalid:
            [self disableLoginHandlingMethod];
            return;
    }
    if(dataSourceType != FromServerOnly){//缓存数据
        YYCache *cache = [[YYCache alloc] initWithName:TTWRequestCache];
        cache.memoryCache.shouldRemoveAllObjectsOnMemoryWarning = YES;
        cache.memoryCache.shouldRemoveAllObjectsWhenEnteringBackground = YES;
        [cache setObject:[self tryToParseData:response] forKey:absolute];
    }
   
    [self successResponse:response  callback:success];
 
}

+ (void)handleCallbackWithErrorFail:(TTWResponseError)fail{

    if (fail) {
     fail(nil);
    }
    
}

+ (void)handleLogWithError:(NSError *)error url:(NSString *)url params:(NSDictionary *)params fail:(TTWResponseError)fail
{
    [self handleCallbackWithError:error fail:fail];
  
}


//异常退出处理方法
+(void)disableLoginHandlingMethod{
    [self cancelAllRequest];
    [TTWHUD showCustomMsg:kLocalizedString(@"登录异常")];
    //保存异常退出状态
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:TokenDisabled];
    [[NSUserDefaults standardUserDefaults] synchronize];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.4 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        //跳回登录
        if (![NSStringFromClass([[TWAppTool currentViewController] class]) isEqualToString:@"LoginIndexVC"]) {
            [TWAppTool gotoIndexVCLoginRootVc];
        };
    });
 
}

#pragma mark -- 上传文件
+ (TTWURLSessionTask *)uploadFileWithUrl:(NSString *)url
                          uploadingFile:(NSString *)uploadingFile
                             parameters:(NSDictionary *)parameters
                                   name:(NSString *)name
                               progress:(TTWUploadProgress)progress
                                success:(TTWResponseSuccess)success
                                   fail:(TTWResponseError)fail {
  
    //检查网络
    if( [self checkTheNetwork] == NO){
        if(fail){
            fail(nil);
        }
        return nil;
    }
    
    //加上公共请求头
    url = [NSString stringWithFormat:@"%@%@",[TTWNetworkHandler sharedInstance].host_api,url];
    //url转码
    NSCharacterSet *encodeUrlSet = [NSCharacterSet URLQueryAllowedCharacterSet];
    NSString *encodeUrl = [url stringByAddingPercentEncodingWithAllowedCharacters:encodeUrlSet];

    AFHTTPSessionManager *manager = [self manager];
    TTWURLSessionTask *session = nil;
    [manager POST:encodeUrl parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        //这个方法跟图片上传方法对比，少了文件类型判断,afn会自动判断 
        [formData appendPartWithFileURL:[NSURL fileURLWithPath:uploadingFile] name:name error:nil];
        
        //[formData appendPartWithFileURL:[NSURL fileURLWithPath:uploadingFile] name:name fileName:@"123.png" mimeType:@"image/png" error:nil];
        
       // [formData appendPartWithFileData:[NSData dataWithContentsOfFile:uploadingFile] name:name fileName:@"xxxx.png" mimeType:@"application/octet-stream"];
    
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        if (progress) {
            progress( uploadProgress,uploadProgress.completedUnitCount, uploadProgress.totalUnitCount);
        }
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        DTLog(@"responseObject== %@",responseObject);
        [[self allTasks] removeObject:task];
        [self successResponse:responseObject callback:success];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [[self allTasks] removeObject:task];
        [self handleCallbackWithError:error fail:fail];
        
    }];
    
    [session resume];

    
    if (session) {
        [[self allTasks] addObject:session];
    }
    
    return session;
}

#pragma mark-- 图片／视频/文件上传
+ (TTWURLSessionTask *)uploadWithUrl:(NSString *)url
                         UploadParam:(TTWUploadParam *)uploadParam
                          parameters:(NSDictionary *)parameters
                            progress:(TTWUploadProgress)progress
                             success:(TTWResponseSuccess)success
                                fail:(TTWResponseError)fail {

    //检查网络
    if( [self checkTheNetwork] == NO){
        if(fail){
            fail(nil);
        }
        return nil;
    }
    
    //加上公共请求头
    url = [NSString stringWithFormat:@"%@%@",[TTWNetworkHandler sharedInstance].host_api,url];
    //url转码
    NSCharacterSet *encodeUrlSet = [NSCharacterSet URLQueryAllowedCharacterSet];
    NSString *encodeUrl = [url stringByAddingPercentEncodingWithAllowedCharacters:encodeUrlSet];
    
    if (!parameters) {
        parameters = [NSDictionary new];
    }
    NSMutableDictionary *paramsDefault = [NSMutableDictionary  dictionaryWithDictionary:parameters];
    //添加默认参数
    [self setDefaultParamsWithParameters:paramsDefault];

    AFHTTPSessionManager *manager = [self manager];
    TTWURLSessionTask *session = [manager POST:encodeUrl parameters:paramsDefault constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        DTLog(@"图片/视频/文件大小%f kb",uploadParam.data.length/1000.0f);
        // 上传图片，以文件流的格式
        [formData appendPartWithFileData:uploadParam.data name:uploadParam.name fileName:uploadParam.fileName mimeType:uploadParam.mimeType];
        
        
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        if (progress) {
            progress( uploadProgress,uploadProgress.completedUnitCount, uploadProgress.totalUnitCount);
        }

    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        DTLog(@"responseObject== %@",responseObject);
        [self dismissLoading];
        [[self allTasks] removeObject:task];
        [self successResponse:responseObject callback:success];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [[self allTasks] removeObject:task];
        [self dismissLoading];
        [self handleCallbackWithError:error fail:fail];
      
    }];
    
    [session resume];
    if (session) {
        [[self allTasks] addObject:session];
    }
    
    return session;
}

+ (TTWURLSessionTask *)downloadWithUrl:(NSString *)url
                           saveToPath:(NSString *)saveToPath
                             progress:(TTWDownloadProgress)progressBlock
                              success:(TTWResponseSuccess)success
                              failure:(TTWResponseError)failure {
    
    //检查网络
    if( [self checkTheNetwork] == NO){
        if(failure){
            failure(nil);
        }
        return nil;
    }
    
    //加上公共请求头
    url = [NSString stringWithFormat:@"%@%@",[TTWNetworkHandler sharedInstance].host_api,url];
    //url转码
    NSCharacterSet *encodeUrlSet = [NSCharacterSet URLQueryAllowedCharacterSet];
    NSString *encodeUrl = [url stringByAddingPercentEncodingWithAllowedCharacters:encodeUrlSet];
    
    NSURLRequest *downloadRequest = [NSURLRequest requestWithURL:[NSURL URLWithString:encodeUrl]];
    AFHTTPSessionManager *manager = [self manager];
    
    TTWURLSessionTask *session = nil;
    
    session = [manager downloadTaskWithRequest:downloadRequest progress:^(NSProgress * _Nonnull downloadProgress) {
        if (progressBlock) {
            progressBlock(downloadProgress,downloadProgress.completedUnitCount, downloadProgress.totalUnitCount);
        }
    } destination:^NSURL * _Nonnull(NSURL * _Nonnull targetPath, NSURLResponse * _Nonnull response) {
        //返回的是文件存放在本地沙盒的地址
        return [NSURL fileURLWithPath:saveToPath];
    } completionHandler:^(NSURLResponse * _Nonnull response, NSURL * _Nullable filePath, NSError * _Nullable error) {
        [[self allTasks] removeObject:session];
        [self dismissLoading];
        if (error == nil) {
            if (success) {
                //下载到手机里的路径
                success(filePath.absoluteString);
            }
        
        } else {
            [self handleCallbackWithError:error fail:failure];
           
        }
    }];
    
    [session resume];
    if (session) {
        [[self allTasks] addObject:session];
    }
    
    return session;
}

#pragma mark - Private
+ (AFHTTPSessionManager *)manager {
    @synchronized (self) {
        // 只要不切换baseurl，就一直使用同一个session manager
        if (sg_sharedManager == nil) {
            // 开启转圈圈,自动显示和隐藏
            [AFNetworkActivityIndicatorManager sharedManager].enabled = YES;
            
            AFHTTPSessionManager *manager =  [AFHTTPSessionManager manager];
            manager.responseSerializer = [AFJSONResponseSerializer serializer];
            manager.requestSerializer.stringEncoding = NSUTF8StringEncoding;
            manager.responseSerializer.acceptableContentTypes = [NSSet setWithArray:@[@"application/json",@"text/html",@"text/json",@"text/plain",@"text/javascript",@"text/xml",@"image/*"]];
            manager.requestSerializer.timeoutInterval = AFN_API_TIME_OUT;
            // 设置允许同时最大并发数量，过大容易出问题
            manager.operationQueue.maxConcurrentOperationCount = 3;
            //设置https
            manager.securityPolicy.allowInvalidCertificates = YES;
            AFSecurityPolicy *securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeNone];
            [securityPolicy setValidatesDomainName:YES];
            manager.securityPolicy = securityPolicy;
            
            sg_sharedManager = manager;
            
            //添加请求头
            [self addHttpHead];
        }
    }
    
    return sg_sharedManager;
}


#pragma mark -- 添加默认参数，公共参数
/**
 添加必须的，需要签名的参数
 */
+ (void)setDefaultParamsWithParameters:(NSMutableDictionary *)params
{
    
    //默认添加token

    //时间戳
    
    //默认添加用户id
  
    //平台类型
    
    //添加设备号
    [params setValue:@"3" forKey:@"device"];
    //添加请求头
    [self addHttpHead];
    //json格式化

    NSString *jsonString = [params yy_modelToJSONString];
    [params removeAllObjects];
    [params setObject:jsonString forKey:@"jsonString"];

}

//添加请求头
+(void)addHttpHead{
    NSString * token = [TWUserDefault UserDefaultObjectForUserModel].token;
    //获得build号:
    NSString *buildVersion = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"];
    //请求头添加参数
    [sg_sharedManager.requestSerializer setValue:token forHTTPHeaderField:@"token"];
    [sg_sharedManager.requestSerializer setValue:buildVersion forHTTPHeaderField:@"versions"];
    DTLog(@"token=== %@",token);
    //添加国际化语言
    NSString * currentLangue = [NSBundle getPreferredLanguage];
    NSString * sendLangue = @"0";
    if([currentLangue rangeOfString:@"zh-Hans"].location != NSNotFound)
    {
        sendLangue = @"1";//简体中文
    }else if ([currentLangue rangeOfString:@"en"].location != NSNotFound){
        
        sendLangue = @"2";//英语
    }
    else if([currentLangue rangeOfString:@"zh-Hant"].location != NSNotFound)
    {
        sendLangue = @"3";//繁体
    }
    NSString * oldSendLangue = [[NSUserDefaults standardUserDefaults] objectForKey:SendLanguage];
    if([sendLangue integerValue] != [oldSendLangue integerValue]){//如果语言改变则送给后台
        
        [sg_sharedManager.requestSerializer setValue:sendLangue forHTTPHeaderField:@"language"];
        [[NSUserDefaults standardUserDefaults] setObject:sendLangue forKey:SendLanguage];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    
   
}

/**
 检测网络状态,当网络状态改变，就会调用这个block,这个方法放在didFinishLaunchingWithOptions中
 */
+ (void)startMonitoring
{
    // 1.获得网络监控的管理者
    AFNetworkReachabilityManager *mgr = [AFNetworkReachabilityManager sharedManager];
    // 2.设置网络状态改变后的处理
    [mgr setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        // 当网络状态改变了, 就会调用这个block
        switch (status)
        {
            case AFNetworkReachabilityStatusUnknown: // 未知网络
                DTLog(@"未知网络");
                [TTWNetworkHandler sharedInstance].networkError = NO;
                break;
            case AFNetworkReachabilityStatusNotReachable: // 没有网络(断网)
                [TTWNetworkHandler sharedInstance].networkError = YES;
                break;
            case AFNetworkReachabilityStatusReachableViaWWAN: // 手机自带网络
                DTLog(@"手机自带网络");
                [TTWNetworkHandler sharedInstance].networkError = NO;
                break;
            case AFNetworkReachabilityStatusReachableViaWiFi: // WIFI
                DTLog(@"WIFI");
                [TTWNetworkHandler sharedInstance].networkError = NO;
                break;
        }
    }];
    [mgr startMonitoring];
}

+(BOOL)checkTheNetwork{

    if ([TTWNetworkHandler sharedInstance].networkError == YES) {//断网
        [self showErrorText:@"网络连接断开,请检查网络!" maskView:NO];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self dismissLoading];
        });
        
        return NO;
    }else{//有网
        return YES;
    }
}

/**
 数据解析
 
 @param responseData 需要进行解析的数据
 @return 解析后的数据
 */
+ (id)tryToParseData:(id)responseData {
    if ([responseData isKindOfClass:[NSData class]]) {
        // 尝试解析成JSON
        if (responseData == nil) {
            return responseData;
        } else {
            NSError *error = nil;
            NSDictionary *response = [NSJSONSerialization JSONObjectWithData:responseData
                                                                     options:NSJSONReadingMutableContainers
                                                                       error:&error];
            
            if (error != nil) {
                return responseData;
            } else {
                return response;
            }
        }
    } else {
        return responseData;
    }
}

+ (void)successResponse:(id)responseData  callback:(TTWResponseSuccess)success {
   
    if (success) {
        success([self tryToParseData:responseData]);
    }
}



+ (void)handleCallbackWithError:(NSError *)error fail:(TTWResponseError)fail{

    if ([error code] == NSURLErrorCancelled) {//取消请求，不需要弹框
        if (shouldCallbackOnCancelRequest) {
            if (fail) {
                fail(error);
            }
        }
    }
    else {
        DTLog(@"error==%@",error);

        if (fail) {
            fail(error);
        }
    }
}

@end
