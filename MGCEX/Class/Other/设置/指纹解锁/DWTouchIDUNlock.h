//
//  DWFingerprintUNlock.h
//  DWUNlock
//
//  Created by dwang_sui on 2016/10/23.
//  Copyright © 2016年 dwang. All rights reserved.
//
/*****************************Github:https://github.com/dwanghello/DWUNlock******************************/
/*************Code Data:http://www.codedata.cn/cdetail/Objective-C/Demo/1478099529339492********/
/*****************************邮箱:dwang.hello@outlook.com***********************************************/
/*****************************QQ:739814184**************************************************************/
/*****************************QQ交流群:577506623*********************************************************/
/*****************************codedata官方群:157937068***************************************************/

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <LocalAuthentication/LocalAuthentication.h>

typedef NS_ENUM(NSUInteger, DWOperatingTouchIDResult) {
    /** 当前设备不支持TouchID */
    DWTouchIDResultTypeNotSupport = 0,
    
    /** TouchID 验证失败 */
    DWTouchIDResultTypeFailed,
    
    /** TouchID 被用户取消 */
    DWTouchIDResultTypeUserCancel,
    
    /** TouchID 被系统取消(如遇到来电,锁屏,按了Home键等) */
    DWTouchIDResultTypeSystemCancel,
    
    /** 当前软件被挂起并取消了授权 (如App进入了后台等) */
    DWTouchIDResultTypeAppCancel,
    
    /** 当前软件被挂起并取消了授权 (请求验证出错) */
    DWTouchIDResultTypeInvalidContext,
    
    /** 用户不使用TouchID,选择手动输入密码 */
    DWTouchIDResultTypeInputPassword,
    
    /** TouchID 无法启动,因为用户没有设置密码 */
    DWTouchIDResultTypePasswordNotSet,
    
    /** TouchID 无法启动,因为用户没有设置TouchID */
    DWTouchIDResultTypeNotSet,
    
    /** TouchID 无效 */
    DWTouchIDResultTypeNotAvailable,
    
    /** TouchID 被锁定(连续多次验证TouchID失败,系统需要用户手动输入密码) */
    DWTouchIDResultTypeLockout,
    
    /** TouchID 验证失败,未知原因 */
    DWTouchIDResultTyoeUnknown,
    
    /** 系统版本不支持TouchID (必须高于iOS 8.0才能使用) */
    DWTouchIDResultTypeVersionNotSupport
};


@interface DWTouchIDUNlock : NSObject
    
/** 是否强制性使用Touch ID，默认为YES
 (经使用发现，当touchid错误超限时也会走无法使用touchid回调，现增加此方法可以设置为不论如何只要调用dw_validationTouchIDIsSupportWithBlock:方法就会强制执行解锁方法)
 */
+ (void)dw_setMandatoryUseTouchID:(BOOL)mandatoryUseTouchID;
/** 获取当前是否强制使用Touch ID */
+ (BOOL)dw_getMandatoryStatus;
    
/**
 验证设备是否支持指纹解锁
 
 @param block block
 @return 返回结果
*/
+ (BOOL)dw_validationTouchIDIsSupportWithBlock:(void(^)(BOOL isSupport, LAContext *context, NSInteger policy, NSError *error))block;
    
/**
 指纹解锁
 
 @param msg 提示文本
 @param cancelTitle 取消按钮显示内容(此参数只有iOS10以上才能生效),默认显示：取消
 @param otherTitle 密码登录按钮显示内容(默认*密码登录*),如果传入空字符串@""/nil,则只会显示独立的取消按钮
 @param enabled 默认为NO点击密码使用系统解锁/YES时，自己操作点击密码登录
 @param touchIDAuthenticationSuccessBlock  验证成功
 @param operatingrResultBlock 返回状态码和错误
 */
+ (void)dw_touchIDWithMsg:(NSString *)msg
              cancelTitle:(NSString *)cancelTitle
               otherTitle:(NSString *)otherTitle
                  enabled:(BOOL)enabled
touchIDAuthenticationSuccessBlock:(void(^)(BOOL success))touchIDAuthenticationSuccessBlock
    operatingrResultBlock:(void(^)(DWOperatingTouchIDResult operatingTouchIDResult,
                                   NSError *error,
                                   NSString *errorMsg))operatingrResultBlock;
    @end

