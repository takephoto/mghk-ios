// MGC
//
// TWSerializeModel.h
// IOSFrameWork
//
// Created by MGC on 2018/4/26.
// Copyright © 2018年 MGCion. All rights reserved.
//
// @ description 序列化model,如果哪个model需要遵守<NSCoding>协议，只要继承这个类

#import <Foundation/Foundation.h>

@interface TWSerializeModel : NSObject<NSCopying, NSCoding>

@end
