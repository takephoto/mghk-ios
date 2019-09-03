// MGC
//
// NSURLSessionTask+TTWTask.m
// AFNNetworkingDemo
//
// Created by MGC on 2018/2/24.
// Copyright © 2018年 MGCion. All rights reserved.
//
// @ description <#描述#> 

#import "NSURLSessionTask+TTWTask.h"
#import <objc/runtime.h>

@implementation NSURLSessionTask (TTWTask)
- (NSString *)shouldShowHUD{
    NSString *_shouldShowHUD = objc_getAssociatedObject(self, @selector(shouldShowHUD));
    
    return _shouldShowHUD;
}
//setter
- (void)setShouldShowHUD:(NSString *)shouldShowHUD{
    objc_setAssociatedObject(self, @selector(shouldShowHUD), shouldShowHUD, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
- (NSString *)currentVC{
    NSString *_currentVC = objc_getAssociatedObject(self, @selector(currentVC));
    
    return _currentVC;
}
- (void)setCurrentVC:(NSString *)currentVC{
    objc_setAssociatedObject(self, @selector(currentVC), currentVC, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
@end
