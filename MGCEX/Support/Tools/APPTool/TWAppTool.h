//
/*! 文件信息
*/

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "LoginIndexVC.h"

@interface TWAppTool : NSObject

//检查更新 YES 代表更新 NO代表不用强制更新
+(void)CheckWhetherTheMandatoryUpdate;


//权限验证处理,返回NO，代表没有权限必须做手势指纹或者跳登录界面。返回YES 代表可以做下一步操作
+(BOOL)permissionsValidationHandleFinish:(void(^)(void) )completion;

//检查是否已经实名 并开通资金密码
+ (void)passRealNameAuthenticationOrAccountPwd:(void(^)(BOOL isAuthenticated, BOOL isSetAccountPwd))completion;

//开启手势或指纹
+(void)openGesturesOrFingerprints;

//回退登录界面处理，可以返回
+(void)gotoIndexVCLogin;

//回退登录界面处理，退出登录
+(void)gotoIndexVCLoginRootVc;

//图片转base64
+ (NSString *)imageToString:(UIImage *)image;

//获取当前时间
+ (NSString *)getCurrentDate;
/**
 *  获取当前视图控制器
 */
+ (UIViewController *)currentViewController;

/**从类中获取属性和值
 *@param model 实体类
 *@param completion 完成后的回调
 */
+(void )getPropertiesAndValueFromModel:(id)model completion:(void (^)(NSString * key, id value)) completion;

+(UIImage *)addWatermarkWithImage:(UIImage *)image supImageV:(UIImageView *)imageV;

/**
 * 倒计时处理
 *@param countdown 倒计时数字
 *@param time 倒计时时间戳
 *@param button 倒计时按钮
 */
+(void)startTheCountdownWithPhoneCountdown:(NSString *)countdown Time:(NSString *)time btn:(UIButton *)button;

/**
 *  加密指定区域字符串, 即替换为 *
 */
+ (NSString *)mg_secureText:(NSString *)string range:(NSRange)range;
/**
 *  phone  mail加密即替换为 *
 */
+ (NSString *)mg_securePhoneMailText:(NSString *)string;

/**
 *  名字替换星
 */
+ (NSString *)mg_secureNameText:(NSString *)string;

/**
 view 添加圆角，描边
 */
+(void)cornerWithRadius:(float)radius view:(UIView *)view border:(float)borderWidth borderColor:(UIColor*)borderColor;

@end
