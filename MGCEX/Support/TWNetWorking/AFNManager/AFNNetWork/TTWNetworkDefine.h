// MGC
//
// TTWNetworkDefine.h
// AFNNetworkingDemo
//
// Created by MGC on 2018/2/23.
// Copyright © 2018年 MGCion. All rights reserved.
//
// @ description <#描述#> 

#ifndef TTWNetworkDefine_h
#define TTWNetworkDefine_h

/**
 *  请求类型
 */
typedef enum {
    AFNNetWorkGET = 1,   /**< GET请求 */
    AFNNetWorkPOST       /**< POST请求 */
} TTWNetWorkType;

/**
 *  网络请求超时的时间
 */
#define AFN_API_TIME_OUT 20


/*
 *  @brief 下载进度
 *
 *  @param bytesRead                 已下载的大小
 *  @param totalBytesRead            文件总大小
 *  @param totalBytesExpectedToRead 还有多少需要下载
 */
typedef void (^TTWDownloadProgress)(NSProgress * _Nonnull downLoadProgress,int64_t bytesWritten, int64_t totalBytesWritten);

typedef TTWDownloadProgress TTWGetProgress;
typedef TTWDownloadProgress TTWPostProgress;

/*
 *
 *  @brief 上传进度
 *
 *  @param bytesWritten              已上传的大小
 *  @param totalBytesWritten         总上传大小
 */
typedef void (^TTWUploadProgress)(NSProgress * _Nonnull uploadProgress,int64_t bytesWritten,int64_t totalBytesWritten);

/*
 *  @brief 请求类型
 */
typedef NS_ENUM(NSUInteger, TTWRequestMethod) {
    RequestByGet = 1, // get方法
    RequestByPost = 2 // post方法
};

/*
 *  @brief 缓存策略
 */
typedef NS_ENUM(NSUInteger, TWRequestCachePolicy) {
    FromCacheOnly = 1, // 只读缓存
    FromCacheFirst = 2, // 读缓存，无缓存则访问网络
    FromServerOnly  = 3,//只访问服务器，不读缓存
    FromCacheAndServer  = 4, //先返回缓存，然后同步访问服务器
    FromServerThenCache  = 5 //访问服务器，如果访问失败，则读缓存
    
};

/*
 *  @brief 网络状态
 */
typedef NS_ENUM(NSInteger, TTWNetworkStatus) {
    ///未知网络
    NetworkStatusUnknown          = -1,
    ///网络无连接
    NetworkStatusNotReachable     = 0,
    ///2，3，4G网络
    NetworkStatusReachableViaWWAN = 1,
    ///WIFI网络
    NetworkStatusReachableViaWiFi = 2,
};
/*
 *  @brief code类型
 */
typedef NS_ENUM(NSUInteger, MGCodeType) {
    MGSuccess = 1, // 接口访问成功
    MGTokenError = 228, // 登录状态异常
    MGNoUpdate = 223,//错做失败
    MGNotLogin = 224,//没有登录
    MGTokenInvalid = 208,//token失效
    MGRepeatedRequests = -999//请求时，队列中有相同的请求未返回，该请求被取消
};
/**
 *  @Note 所有接口返回的类型都是基类NSURLSessionTask，若要接收返回值且处理，
 *  请转换成对应的子类类型.
 *
 *  @since 1.0
 */
typedef NSURLSessionTask TTWURLSessionTask;
typedef void(^TTWResponseSuccess)(id _Nullable  response);
typedef void(^TTWResponseError)(NSError * _Nullable  error);
typedef void(^MGResponseFailed)(id _Nullable  response);


#endif /* TTWNetworkDefine_h */
