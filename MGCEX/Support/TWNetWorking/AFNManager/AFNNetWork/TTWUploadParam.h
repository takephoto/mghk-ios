// MGC
//
// TTWUploadParam.h
// AFNNetworkingDemo
//
// Created by MGC on 2018/2/23.
// Copyright © 2018年 MGCion. All rights reserved.
//
// @ description <#描述#> 

#import <Foundation/Foundation.h>

@interface TTWUploadParam : NSObject

/**
 *  上传文件的二进制数据
 */
@property (nonatomic, strong) NSData *data;
/**
 *  上传的参数名称
 */
@property (nonatomic, copy) NSString *name;

/**
 *  上传到服务器的文件名称
 */
@property (nonatomic, copy) NSString *fileName;

/**
 *  上传文件的类型,图片:image/png  视频:video/quicktime 语音：audio/amr 文件:application/octet-stream
 */
@property (nonatomic, copy) NSString *mimeType;


@end
