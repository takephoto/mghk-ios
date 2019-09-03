// MGC
//
// TTWUtilsMacro.h
// kachi
//
// Created by MGC on 2017/12/28.
// Copyright © 2017年 qw. All rights reserved.
//
// @ description <#描述#> 

#ifndef TTWUtilsMacro_h
#define TTWUtilsMacro_h

#pragma mark - 判断系统版本高于或者低于某一个版本
///解决精度问题
#define kToDec(numberString) [[NSDecimalNumber decimalNumberWithString:numberString] stringValue]
///
//等于
#define SYSTEM_VERSION_EQUAL_TO(v) ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedSame)
//大于
#define SYSTEM_VERSION_GREATER_THAN(v) ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedDescending)
//大于等于
#define SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v) ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)
//小于
#define SYSTEM_VERSION_LESS_THAN(v) ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedAscending)
//小于等于
#define SYSTEM_VERSION_LESS_THAN_OR_EQUAL_TO(v) ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedDescending)

#pragma mark -  沙盒路径
#define PATH_OF_APP_HOME    NSHomeDirectory()
#define PATH_OF_TEMP        NSTemporaryDirectory()
#define PATH_OF_DOCUMENT    [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0]

#pragma mark - 圆角边框相关
// View 圆角和加边框
#define ViewBorderRadius(View, Radius, Width, Color)\
\
[View.layer setCornerRadius:(Radius)];\
[View.layer setMasksToBounds:YES];\
[View.layer setBorderWidth:(Width)];\
[View.layer setBorderColor:[Color CGColor]]

// View 圆角
#define ViewRadius(View, Radius)\
\
[View.layer setCornerRadius:(Radius)];\
[View.layer setMasksToBounds:YES]

// 是否iPad
#define isPad                   (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)

//获取系统版本
#define IOS_VERSION [[[UIDevice currentDevice] systemVersion] floatValue]

///项目版本号
#define PRO_VERSION [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"]

// 系统版本
#define IS_IOS7 (IOS_VERSION >= 7.0 ? YES : NO)
#define IS_IOS8 (IOS_VERSION >= 8.0 ? YES : NO)
#define IS_IOS9 (IOS_VERSION >= 9.0 ? YES : NO)
#define IS_IOS9_1 (IOS_VERSION >= 9.1 ? YES : NO)
#define IS_IOS9_Before (IOS_VERSION < 9.0 ? YES : NO)
#define IS_IOS10 (IOS_VERSION >= 10.0 ? YES : NO)
#define IS_IOS11 (IOS_VERSION >= 11.0 ? YES : NO)

///获取设备
//是否是iPhone X
#define IS_IPHONEX  ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? \
CGSizeEqualToSize(CGSizeMake(1125, 2436), \
[[UIScreen mainScreen] currentMode].size) : \
NO)

// 是否iPhone6p
#define IS_IPHONE6p               ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? \
CGSizeEqualToSize(CGSizeMake(1242, 2208), \
[[UIScreen mainScreen] currentMode].size) : \
NO)

// 是否iPhone6
#define IS_IPHONE6               ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? \
CGSizeEqualToSize(CGSizeMake(750, 1334), \
[[UIScreen mainScreen] currentMode].size) : \
NO)

// 是否iPhone5
#define IS_IPHONE5               ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? \
CGSizeEqualToSize(CGSizeMake(640, 1136), \
[[UIScreen mainScreen] currentMode].size) : \
NO)
// 是否iPhone4
#define IS_IPHONE4               ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? \
CGSizeEqualToSize(CGSizeMake(640, 960), \
[[UIScreen mainScreen] currentMode].size) : \
NO)


//图片设置
#define IMAGE(imgName) [UIImage imageNamed:imgName]

//2.iPhone5分辨率320x568，像素640x1136，@2x  0.853333   0.851574
//3.iPhone6分辨率375x667，像素750x1334，@2x   1   1
//4.iPhone6 Plus分辨率414x736，像素1242x2208，@3x  1.104  1.1034
//5.iPhonex 分辨率 375 x 812   像素 1125px * 2436px 1  1.21

///获取Xcode的版本号
#define XcodeAppVersion [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"]


/** 字符串是否为空 */
#define kStringIsEmpty(str) ([str isKindOfClass:[NSNull class]] || str == nil || [str length] < 1 ? YES : NO )
/** 设置一个非nil/Null字符串 */
#define kNotNull(str) (kStringIsEmpty(str) ? @"" : str)
/** 设置一个非nil/Null字符串 */
#define kNotNumber(str) (kStringIsEmpty(str) ? @"0" : str)
/** 数组是否为空 */
#define kArrayIsEmpty(array) (array == nil || [array isKindOfClass:[NSNull class]] || array.count == 0)
/** 字典是否为空 */
#define kDictionaryIsEmpty(dictionary) (dictionary == nil || [dictionary isKindOfClass:[NSNull class]] || dictionary.allKeys.count == 0)

#pragma mark - 字符串相关
#define string(str1,str2) [NSString stringWithFormat:@"%@%@",str1,str2]
#define s_str(str1) [NSString stringWithFormat:@"%@",str1]
#define s_Num(num1) [NSString stringWithFormat:@"%d",num1]
#define s_Integer(num1) [NSString stringWithFormat:@"%ld",num1]
#define s_Ffloat(num) [NSString stringWithFormat:@"%lf",num]
#define s_Longlong(num) [NSString stringWithFormat:@"%lld",num]
#define s_number(str) [NSNumber numberWithInt:[str intValue]]
#define s_Double(str) [NSNumber numberWithDouble:[str doubleValue]]

//number转String
#define IntTranslateStr(int_str) [NSString stringWithFormat:@"%d",int_str];
#define FloatTranslateStr(float_str) [NSString stringWithFormat:@"%.2d",float_str];

//弱引用：@weakify(self);
#ifndef weakify
#if DEBUG
#if __has_feature(objc_arc)
#define weakify(object) autoreleasepool{} __weak __typeof__(object) weak##_##object = object;
#else
#define weakify(object) autoreleasepool{} __block __typeof__(object) block##_##object = object;
#endif
#else
#if __has_feature(objc_arc)
#define weakify(object) try{} @finally{} {} __weak __typeof__(object) weak##_##object = object;
#else
#define weakify(object) try{} @finally{} {} __block __typeof__(object) block##_##object = object;
#endif
#endif
#endif
//强引用： @strongify(self);
#ifndef strongify
#if DEBUG
#if __has_feature(objc_arc)
#define strongify(object) autoreleasepool{} __typeof__(object) object = weak##_##object;
#else
#define strongify(object) autoreleasepool{} __typeof__(object) object = block##_##object;
#endif
#else
#if __has_feature(objc_arc)
#define strongify(object) try{} @finally{} __typeof__(object) object = weak##_##object;
#else
#define strongify(object) try{} @finally{} __typeof__(object) object = block##_##object;
#endif
#endif
#endif



#pragma mark - 单例宏
// 1. 解决.h文件
#define singletonInterface(className) \
+ (instancetype)shared##className;\
+ (void)destroyInstance;

// 2. 解决.m文件
// 判断 是否是 ARC
#if __has_feature(objc_arc)
#define singletonImplementation(className) \
static id instance = nil; \
static dispatch_once_t onceToken1; \
static dispatch_once_t onceToken2; \
+ (instancetype)allocWithZone:(struct _NSZone *)zone { \
dispatch_once(&onceToken1, ^{ \
if(instance == nil){\
instance = [super allocWithZone:zone]; \
}\
}); \
return instance; \
} \
+ (instancetype)shared##className { \
dispatch_once(&onceToken2, ^{ \
if(instance == nil){\
instance = [[self alloc] init]; \
}\
}); \
return instance; \
} \
- (id)copyWithZone:(NSZone *)zone { \
return instance; \
}\
+ (void)destroyInstance {\
instance = nil;\
onceToken1 = 0;\
onceToken2 = 0;\
}
#else
// MRC 部分
#define singletonImplementation(className) \
static id instance = nil; \
static dispatch_once_t onceToken1; \
static dispatch_once_t onceToken2; \
+ (instancetype)allocWithZone:(struct _NSZone *)zone { \
static dispatch_once_t onceToken; \
dispatch_once(&onceToken, ^{ \
if(instance == nil){\
instance = [super allocWithZone:zone]; \
}\
}); \
return instance; \
} \
+ (instancetype)shared##className { \
dispatch_once(&onceToken, ^{ \
if(instance == nil){\
instance = [[self alloc] init]; \
}\
}); \
return instance; \
} \
- (id)copyWithZone:(NSZone *)zone { \
return instance; \
} \
- (oneway void)release {} \
- (instancetype)retain {return instance;} \
- (instancetype)autorelease {return instance;} \
- (NSUInteger)retainCount {return ULONG_MAX;}\
+ (void)destroyInstance {\
[instance release];\
instance = nil;\
onceToken1 = 0;\
onceToken2 = 0;\
}

#endif


#endif /* TTWUtilsMacro_h */
