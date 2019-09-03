// MGC
//
// TTWLogMacro.h
// kachi
//
// Created by MGC on 2017/12/28.
// Copyright © 2017年 qw. All rights reserved.
//
// @ description

#ifndef TTWLogMacro_h
#define TTWLogMacro_h

#ifdef DEBUG
#define DLog(format, ...) printf("class: <%p %s:(%d) > method: %s \n%s\n", self, [[[NSString stringWithUTF8String:__FILE__] lastPathComponent] UTF8String], __LINE__, __PRETTY_FUNCTION__, [[NSString stringWithFormat:(format), ##__VA_ARGS__] UTF8String] )
#else
#define DLog(format, ...)
#endif



#endif /* TTWLogMacro_h */
