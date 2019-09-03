//
//  DWFingerprintUNlock.m
//  DWUNlock
//
//  Created by dwang_sui on 2016/10/23.
//  Copyright © 2016年 dwang. All rights reserved.
//

#import "DWTouchIDUNlock.h"
#import <sys/utsname.h>
#import "LoginIndexVC.h"

@interface DWDeviceModel : NSObject
/** 获取设备型号 */
+ (NSString *)dwToolsDeviceModelName;
@end


#define IOS_VERSION [[[UIDevice currentDevice] systemVersion] floatValue]

static BOOL dw_MandatoryUseTouchID = YES;

@implementation DWTouchIDUNlock

#pragma mark ---指纹解锁
+ (void)dw_touchIDWithMsg:(NSString *)msg
        cancelTitle:(NSString *)cancelTitle
        otherTitle:(NSString *)otherTitle
        enabled:(BOOL)enabled
        touchIDAuthenticationSuccessBlock:(void(^)(BOOL success))touchIDAuthenticationSuccessBlock
        operatingrResultBlock:(void(^)(DWOperatingTouchIDResult operatingTouchIDResult,
                                   NSError *error,
                                   NSString *errorMsg))operatingrResultBlock {
    
    [DWTouchIDUNlock dw_validationTouchIDIsSupportWithBlock:^(BOOL isSupport, LAContext *context, NSInteger policy, NSError *error) {
        context.localizedFallbackTitle = !otherTitle?@"":otherTitle;
        if(IOS_VERSION>=10) context.localizedCancelTitle = cancelTitle;
        NSInteger policy2 = enabled?LAPolicyDeviceOwnerAuthenticationWithBiometrics:LAPolicyDeviceOwnerAuthentication;
        if (isSupport || dw_MandatoryUseTouchID) {
            [context evaluatePolicy:policy2 localizedReason:msg reply:^(BOOL success, NSError * _Nullable error) {
                if (success) {
                    dispatch_sync(dispatch_get_main_queue(), ^{
                        touchIDAuthenticationSuccessBlock(success);
                    });
                    return;
                }else if (error) {
                    switch (error.code) {
                        case LAErrorAuthenticationFailed:
                            operatingrResultBlock(DWTouchIDResultTypeFailed, error, @"TouchID 验证失败");
                            break;
                        case LAErrorUserCancel:
                            operatingrResultBlock(DWTouchIDResultTypeUserCancel, error, @"TouchID 被用户取消");
                            break;
                        case LAErrorSystemCancel:
                            operatingrResultBlock(DWTouchIDResultTypeSystemCancel, error, @"TouchID 被系统取消");
                            break;
                        case LAErrorAppCancel:
                            operatingrResultBlock(DWTouchIDResultTypeAppCancel, error, @"当前软件被挂起并取消了授权(如App进入了后台等)");
                            if (enabled)[context evaluatePolicy:policy localizedReason:msg reply:^(BOOL success, NSError * _Nullable error) {}];
                            break;
                        case LAErrorInvalidContext:
                            operatingrResultBlock(DWTouchIDResultTypeAppCancel, error, @"当前软件被挂起并取消了授权(LAContext对象无效)");
                            if (enabled)[context evaluatePolicy:policy localizedReason:msg reply:^(BOOL success, NSError * _Nullable error) {}];
                            break;
                        case LAErrorUserFallback:
                            operatingrResultBlock(DWTouchIDResultTypeInputPassword, error, @"手动输入密码");
                            break;
                        case LAErrorPasscodeNotSet:
                            operatingrResultBlock(DWTouchIDResultTypeInputPassword, error, @"TouchID 无法启动,因为用户没有设置密码");
                            break;
                        case LAErrorTouchIDNotEnrolled:
                            operatingrResultBlock(DWTouchIDResultTypeNotSet, error, @"TouchID 无法启动,因为用户没有设置TouchID");
                            break;
                        case LAErrorTouchIDNotAvailable:
                            operatingrResultBlock(DWTouchIDResultTypeNotAvailable, error, @"TouchID 无效");
                            break;
                        case LAErrorTouchIDLockout:
                            NSLog(@"我要怎么办呢");
                            operatingrResultBlock(DWTouchIDResultTypeLockout, error, @"TouchID 被锁定(连续多次验证TouchID失败,系统需要用户手动输入密码");
                            
                            if (enabled)[context evaluatePolicy:policy localizedReason:msg reply:^(BOOL success, NSError * _Nullable error) {
                                NSLog(@"我输入密码了,成功");
                    
                            }];
            
                            
                            [TWAppTool gotoIndexVCLoginRootVc];
                         
                            break;
                        default:
                            operatingrResultBlock(DWTouchIDResultTyoeUnknown, error, @"未知情况");
                            if (enabled)[context evaluatePolicy:policy localizedReason:msg reply:^(BOOL success, NSError * _Nullable error) {}];
                            break;
                    }
                }
            }];
        }else {
            operatingrResultBlock(DWTouchIDResultTypeVersionNotSupport, error, [NSString stringWithFormat:@"此设备不支持TouchID:\n设备操作系统:%@\n设备系统版本号:%@\n设备型号:%@", [[UIDevice currentDevice] systemVersion], [[UIDevice currentDevice] systemName], [DWDeviceModel dwToolsDeviceModelName]]);
        }
    }];
}
    

#pragma mark - 判断设备是否支持指纹解锁
+ (BOOL)dw_validationTouchIDIsSupportWithBlock:(void(^)(BOOL isSupport, LAContext *context, NSInteger policy, NSError *error))block {
    LAContext* context = [[LAContext alloc] init];
    context.maxBiometryFailures = @(5);//最大的错误次数,9.0后失效
    NSInteger policy = IOS_VERSION<9.0&&IOS_VERSION>=8.0?LAPolicyDeviceOwnerAuthenticationWithBiometrics:LAPolicyDeviceOwnerAuthentication;
    NSError *error = nil;
    BOOL isSupport = [context canEvaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics error:&error];//实测中发现如果使用LAPolicyDeviceOwnerAuthentication,则每次返回的结果都是true,使用LAPolicyDeviceOwnerAuthenticationWithBiometrics则可以返回真实的结果
    block(isSupport, context, policy, error);
    return isSupport;
}

+ (void)dw_setMandatoryUseTouchID:(BOOL)mandatoryUseTouchID {
    dw_MandatoryUseTouchID = mandatoryUseTouchID;
}
    
+ (BOOL)dw_getMandatoryStatus {
    return dw_MandatoryUseTouchID;
}
    
@end


@implementation DWDeviceModel
#pragma mark ---获取设备型号
+ (NSString *)dwToolsDeviceModelName {
    struct utsname systemInfo;
    uname(&systemInfo);
    NSString *deviceModel = [NSString stringWithCString:systemInfo.machine encoding:NSUTF8StringEncoding];
    //iPhone 系列
    if ([deviceModel isEqualToString:@"iPhone1,1"])    return @"iPhone1G";
    if ([deviceModel isEqualToString:@"iPhone1,2"])    return @"iPhone3G";
    if ([deviceModel isEqualToString:@"iPhone2,1"])    return @"iPhone3GS";
    if ([deviceModel isEqualToString:@"iPhone3,1"])    return @"iPhone4";
    if ([deviceModel isEqualToString:@"iPhone3,2"])    return @"VerizoniPhone4";
    if ([deviceModel isEqualToString:@"iPhone4,1"])    return @"iPhone4S";
    if ([deviceModel isEqualToString:@"iPhone5,1"])    return @"iPhone5";
    if ([deviceModel isEqualToString:@"iPhone5,2"])    return @"iPhone5";
    if ([deviceModel isEqualToString:@"iPhone5,3"])    return @"iPhone5C";
    if ([deviceModel isEqualToString:@"iPhone5,4"])    return @"iPhone5C";
    if ([deviceModel isEqualToString:@"iPhone6,1"])    return @"iPhone5S";
    if ([deviceModel isEqualToString:@"iPhone6,2"])    return @"iPhone5S";
    if ([deviceModel isEqualToString:@"iPhone7,1"])    return @"iPhone6Plus";
    if ([deviceModel isEqualToString:@"iPhone7,2"])    return @"iPhone6";
    if ([deviceModel isEqualToString:@"iPhone8,1"])    return @"iPhone6s";
    if ([deviceModel isEqualToString:@"iPhone8,2"])    return @"iPhone6sPlus";
    if ([deviceModel isEqualToString:@"iPhone9,1"])    return @"iPhone7(CDMA)";
    if ([deviceModel isEqualToString:@"iPhone9,3"])    return @"iPhone7(GSM)";
    if ([deviceModel isEqualToString:@"iPhone9,2"])    return @"iPhone7Plus(CDMA)";
    if ([deviceModel isEqualToString:@"iPhone9,4"])    return @"iPhone7Plus(GSM)";
    
    //iPod 系列
    if ([deviceModel isEqualToString:@"iPod1,1"])      return @"iPodTouch1G";
    if ([deviceModel isEqualToString:@"iPod2,1"])      return @"iPodTouch2G";
    if ([deviceModel isEqualToString:@"iPod3,1"])      return @"iPodTouch3G";
    if ([deviceModel isEqualToString:@"iPod4,1"])      return @"iPodTouch4G";
    if ([deviceModel isEqualToString:@"iPod5,1"])      return @"iPodTouch5G";
    
    //iPad 系列
    if ([deviceModel isEqualToString:@"iPad1,1"])      return @"iPad";
    if ([deviceModel isEqualToString:@"iPad2,1"])      return @"iPad2(WiFi)";
    if ([deviceModel isEqualToString:@"iPad2,2"])      return @"iPad2(GSM)";
    if ([deviceModel isEqualToString:@"iPad2,3"])      return @"iPad2(CDMA)";
    if ([deviceModel isEqualToString:@"iPad2,4"])      return @"iPad2(32nm)";
    if ([deviceModel isEqualToString:@"iPad2,5"])      return @"iPadMini(WiFi)";
    if ([deviceModel isEqualToString:@"iPad2,6"])      return @"iPadMini(GSM)";
    if ([deviceModel isEqualToString:@"iPad2,7"])      return @"iPadMini(CDMA)";
    if ([deviceModel isEqualToString:@"iPad3,1"])      return @"iPad3(WiFi)";
    if ([deviceModel isEqualToString:@"iPad3,2"])      return @"iPad3(CDMA)";
    if ([deviceModel isEqualToString:@"iPad3,3"])      return @"iPad3(4G)";
    if ([deviceModel isEqualToString:@"iPad3,4"])      return @"iPad4 WiFi)";
    if ([deviceModel isEqualToString:@"iPad3,5"])      return @"iPad4(4G)";
    if ([deviceModel isEqualToString:@"iPad3,6"])      return @"iPad4(CDMA)";
    if ([deviceModel isEqualToString:@"iPad4,1"])      return @"iPadAir";
    if ([deviceModel isEqualToString:@"iPad4,2"])      return @"iPadAir";
    if ([deviceModel isEqualToString:@"iPad4,3"])      return @"iPadAir";
    if ([deviceModel isEqualToString:@"iPad5,3"])      return @"iPadAir2";
    if ([deviceModel isEqualToString:@"iPad5,4"])      return @"iPadAir2";
    if ([deviceModel isEqualToString:@"i386"])         return @"Simulator";
    if ([deviceModel isEqualToString:@"x86_64"])       return @"Simulator";
    if ([deviceModel isEqualToString:@"iPad4,4"]
        ||[deviceModel isEqualToString:@"iPad4,5"]
        ||[deviceModel isEqualToString:@"iPad4,6"])      return @"iPadMini2";
    if ([deviceModel isEqualToString:@"iPad4,7"]
        ||[deviceModel isEqualToString:@"iPad4,8"]
        ||[deviceModel isEqualToString:@"iPad4,9"])      return @"iPadMini3";
    return deviceModel;
}

@end
