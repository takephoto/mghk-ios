// MGC
//
// TTWNetwork.h
// AFNNetworkingDemo
//
// Created by MGC on 2018/2/24.
// Copyright © 2018年 MGCion. All rights reserved.
//
// @ description <#描述#> 

#ifndef TTWNetwork_h
#define TTWNetwork_h

#ifdef DEBUG
#   define DTLog(format, ...) printf("class: <%p %s:(%d) > method: %s \n%s\n", self, [[[NSString stringWithUTF8String:__FILE__] lastPathComponent] UTF8String], __LINE__, __PRETTY_FUNCTION__, [[NSString stringWithFormat:(format), ##__VA_ARGS__] UTF8String] )

#else
#   define DTLog(...)
#endif

#define SHOW_ALERT(_msg_)  UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:_msg_ delegate:nil cancelButtonTitle:nil otherButtonTitles:kLocalizedString(@"确定"), nil];\
[alert show];


#import "TTWNetworkDefine.h"
#import "TTWNetworkHandler.h"
#import "TTWNetworkManager.h"
#import "NSObject+TTWHUD.h"
#import "NSURLSessionTask+TTWTask.h"
#import <AFNetworking/AFNetworking.h>
#import "TTWUploadParam.h"

//生产
#define IP @"https://www.MEIB.IO"

#define HOST string(IP, @"/api/")

#endif /* TTWNetwork_h */
