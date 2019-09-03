// MGC
//
// TTWNetworkHandler.h
// AFNNetworkingDemo
//
// Created by MGC on 2018/2/23.
// Copyright © 2018年 MGCion. All rights reserved.
//
// @ description <#描述#> 

#import <Foundation/Foundation.h>
#import "TTWNetworkDefine.h"
#import <UIKit/UIKit.h>
#import "TTWUploadParam.h"


@interface TTWNetworkHandler : NSObject
/**
 *  networkError
 */
@property(nonatomic,assign)BOOL networkError;

@property (nonatomic, copy) NSString * host_api;
/**
 *  单例
 *
 *  @return TTWNetworkHandler的单例对象
 */
+ (TTWNetworkHandler *)sharedInstance;


/**
 *    取消所有请求
 */
+ (void)cancelAllRequest;

/**
 *    移除所有缓存
 */
+ (void)removeAllCaches;

/**
 检测网络状态,当网络状态改变，就会调用这个block,这个方法放在didFinishLaunchingWithOptions中
 */
+ (void)startMonitoring;

/**
 *    @brief 取消某个请求。如果是要取消某个请求，最好是引用接口所返回来的JLURLSessionTask对象，
 *  然后调用对象的cancel方法。如果不想引用对象，这里额外提供了一种方法来实现取消某个请求
 *
 *    @param url                URL，可以是绝对URL，也可以是path（也就是不包括baseurl）
 */
+ (void)cancelRequestWithURL:(NSString *)url;

/**
 取消指定控制器发起的所有请求（用于点击返回时，取消当前控制器的请求）

 @param controllerName 控制器名称
 */
+ (void)cancelRequestWithControllerName:(NSString *)controllerName;


#pragma mark -- GET/POST

//dataSourceType:默认 kJLFromServerOnly  requestMethod:默认kJLRequestByGet

/**
 不带除默认参数外的其它参数，默认get方法，默认只从服务器读取数据
 
 @param url 接口路径，如/path/getFriendList
 @param success 接口成功请求到数据的回调
 @param fail 接口请求数据失败的回调
 @return 回的对象中有可取消请求的API
 */
+ (TTWURLSessionTask *)requestWithUrl:(NSString *)url
                            isShowHUD:(BOOL)isShowHUD
                             success:(TTWResponseSuccess)success
                                fail:(TTWResponseError)fail;


/**
 默认get方法,默认只从服务器读取数据
 
 @param url 接口路径，如/path/getFriendList
 @param params 接口中所需的参数，如@{"userID" : @(12)}
 @param success 接口成功请求到数据的回调
 @param fail 接口请求数据失败的回调
 @return 回的对象中有可取消请求的API
 */
+ (TTWURLSessionTask *)requestWithUrl:(NSString *)url
                              params:(NSDictionary *)params
                            isShowHUD:(BOOL)isShowHUD
                             success:(TTWResponseSuccess)success
                                fail:(TTWResponseError)fail;


/**
 默认只从服务器读取数据
 
 @param url 接口路径，如/path/getFriendList
 @param requestMethod post/get方法
 @param params 接口中所需的参数，如@{"userID" : @(12)}
 @param success 接口成功请求到数据的回调
 @param fail 接口请求数据失败的回调
 @return 回的对象中有可取消请求的API
 */
+ (TTWURLSessionTask *)requestWithUrl:(NSString *)url
                       requestMethod:(TTWRequestMethod)requestMethod
                              params:(NSDictionary *)params
                            isShowHUD:(BOOL)isShowHUD
                             success:(TTWResponseSuccess)success
                                fail:(TTWResponseError)fail;
/**

 @param url 接口路径，如/path/getFriendList
 @param requestMethod post/get方法
 @param dataSourceType 缓存策略
 @param params 接口中所需的参数，如@{"userID" : @(12)}
 @param success 接口成功请求到数据的回调
 @param fail 接口请求数据失败的回调
 @return 回的对象中有可取消请求的API
 */
+ (TTWURLSessionTask *)requestWithUrl:(NSString *)url
                       requestMethod:(TTWRequestMethod)requestMethod
                      dataSourceType:(TWRequestCachePolicy)dataSourceType
                              params:(NSDictionary *)params
                            isShowHUD:(BOOL)isShowHUD
                             success:(TTWResponseSuccess)success
                                fail:(TTWResponseError)fail ;

/**
 带下载进度，全部参数可配置
 
 @param url 接口路径，如/path/getFriendList
 @param requestMethod post/get方法
 @param dataSourceType 缓存策略
 @param params 接口中所需的参数，如@{"userID" : @(12)}
 @param progress 数据下载进度
 @param success 接口成功请求到数据的回调
 @param fail 接口请求数据失败的回调
 @return 回的对象中有可取消请求的API
 */
+ (TTWURLSessionTask *)requestWithUrl:(NSString *)url
                       requestMethod:(TTWRequestMethod)requestMethod
                      dataSourceType:(TWRequestCachePolicy)dataSourceType
                              params:(NSDictionary *)params
                            isShowHUD:(BOOL)isShowHUD
                            progress:(TTWPostProgress)progress
                             success:(TTWResponseSuccess)success
                                fail:(TTWResponseError)fail;

#pragma mark -- 图片／视频上传
/**
 *
 *    @brief 图片上传接口，若不指定baseurl，可传完整的url
 *
 *    @param uploadParam        集合上传的对象
 *    @param url           url
 *    @param parameters    参数
 *    @param progress        上传进度
 *    @param success        上传成功回调
 *    @param fail                上传失败回调
 *
 *    @return JLURLSessionTask
 */
+ (TTWURLSessionTask *)uploadWithUrl:(NSString *)url
                         UploadParam:(TTWUploadParam *)uploadParam
                            parameters:(NSDictionary *)parameters
                             progress:(TTWUploadProgress)progress
                              success:(TTWResponseSuccess)success
                                 fail:(TTWResponseError)fail;


#pragma mark -- 文件上传
/**
 *
 *    @brief 上传文件操作
 *
 *    @param url                        上传路径
 *    @param uploadingFile    待上传文件的路径
 *    @param name            服务器命名的文件名参数
 *    @param progress            上传进度
 *    @param success                上传成功回调
 *    @param fail                    上传失败回调
 *
 *    @return JLURLSessionTask
 */
+ (TTWURLSessionTask *)uploadFileWithUrl:(NSString *)url
                          uploadingFile:(NSString *)uploadingFile
                             parameters:(NSDictionary *)parameters
                                    name:(NSString *)name
                               progress:(TTWUploadProgress)progress
                                success:(TTWResponseSuccess)success
                                   fail:(TTWResponseError)fail;

#pragma mark -- 文件/图片/视频下载
/**
 *
 *  @brief 下载文件
 *
 *  @param url           下载URL
 *  @param saveToPath    下载到哪个路径下
 *  @param progressBlock 下载进度
 *  @param success       下载成功后的回调
 *  @param failure       下载失败后的回调
 */
+ (TTWURLSessionTask *)downloadWithUrl:(NSString *)url
                           saveToPath:(NSString *)saveToPath
                             progress:(TTWDownloadProgress)progressBlock
                              success:(TTWResponseSuccess)success
                              failure:(TTWResponseError)failure;



@end
