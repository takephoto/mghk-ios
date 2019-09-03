//
/*! 文件信息

 * @project   MGCPay

 * @header    QSAppTool.m

 * @abstract  描述

 * @author    Song

 * @version   1.00 2017/12/12

 * @copyright Copyright © 2017年 Joblee. All rights reserved..

*/

#import "TWAppTool.h"
#import "TouchIDViewController.h"
#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import "AppDelegate.h"
#import "LoginIndexVC.h"
#import "ForcedUpdateView.h"
#import "MandatoryUpDataVC.h"
@interface TWAppTool()


@end



@implementation TWAppTool



//检查更新
+(void)CheckWhetherTheMandatoryUpdate{

    NSString * urlStr = @"versionMage/update";
    
    NSMutableDictionary * dic = [NSMutableDictionary new];
    [dic setValue:@"1" forKey:@"system"];
    NSString *buildVersion = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"];
    [dic setValue:buildVersion forKey:@"version"];
    
    NSString * downUrl = @"itms-services://?action=download-manifest&url=https://down.mgcex.com/mgcex.plist";
    
    @weakify(self);
    [TTWNetworkManager mandatoryUpdateManagerWithUrl:urlStr params:dic success:^(id  _Nullable response) {
        @strongify(self);
        
        if (isSuccess(response)) {
            NSString * msg = response[response_data][@"versionup"];
            NSString * isUpdate = response[response_data][@"isUpdate"];
            
            ForcedUpdateView * view  = [[ForcedUpdateView alloc]initWithMessage:msg isUpDate:isUpdate sureBtnClick:^(void) {
                
                UIApplication *application = [UIApplication sharedApplication];
                NSURL *URL = [NSURL URLWithString:downUrl];
                if ([application respondsToSelector:@selector(openURL:options:completionHandler:)]) {
                    // iOS 10之后
                    [application openURL:URL options:@{}
                       completionHandler:^(BOOL success) {
                           
                       }];
                } else {
                    // ios 10之前
                    BOOL success = [application openURL:URL];
                    
                }
                
            } cancelBtnClick:^{
                
            }];
            
            [view show];
        }
    }failure:^(id  _Nullable response){
        
    } reqError:^(NSError * _Nullable error) {
        
    }];
    
   
}


+ (NSString *)imageToString:(UIImage *)image {
    
    //NSData *imagedata = UIImagePNGRepresentation(image);
    NSData *imagedata = UIImageJPEGRepresentation(image, 0.1);
    NSString *image64 = [imagedata base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
    
    return image64;
    
}

//权限验证处理,返回NO，代表没有权限必须做手势指纹或者跳登录界面。返回YES 代表可以做下一步操作
+(BOOL)permissionsValidationHandleFinish:(void(^)(void) )completion{
    
    if(!kUserIsLogin){
        LoginIndexVC * vc = [[LoginIndexVC alloc]init];
        UIViewController *rootVC = [self currentViewController];
//        [rootVC.navigationController pushViewController:vc animated:YES];
        [rootVC.tabBarController presentViewController:[[TWBaseNavigationController alloc]initWithRootViewController:vc]  animated:YES completion:^{
//
        }];
        return NO;
        
    }else{
        
        BOOL timeout = NO;
        if([[NSUserDefaults standardUserDefaults] objectForKey:@"endAppTime"]&&
           [[self getCurrentDate] integerValue] - [[[NSUserDefaults standardUserDefaults] objectForKey:@"endAppTime"] integerValue] > BackTimeOut){
            timeout = YES;
        }
        
        if([[NSUserDefaults standardUserDefaults]boolForKey: KillLogin] || timeout){
            
            if([[PCCircleViewConst getGestureWithKey:gestureFinalSaveKey] length]||[[NSUserDefaults standardUserDefaults] boolForKey:@"touchID"]){
                //是否开启指纹或手势
                [self openGesturesOrFingerprints];
                return NO;
            }else{
                //跳登录界面处理二次验证，如果开启了谷歌验证，也要跳登录界面
                LoginIndexVC * vc = [[LoginIndexVC alloc]init];
                UIViewController *rootVC = [self currentViewController];
                //        [rootVC.navigationController pushViewController:vc animated:YES];
                [rootVC.tabBarController presentViewController:[[TWBaseNavigationController alloc]initWithRootViewController:vc]  animated:YES completion:^{
                    //
                }];
                return NO;
            }
            
        }
        
    }
    
    if(completion){
        completion();
    }
    return YES;
        
}

//检查是否已经实名 开通资金密码
+ (void)passRealNameAuthenticationOrAccountPwd:(void(^)(BOOL isAuthenticated, BOOL isSetAccountPwd))completion{
    
    if(!kUserIsLogin) {
        NSLog(@"未登录");
        return;
    }
    
    NSString * urlStr = @"user/userList";
    
    [TTWNetworkManager logOntoCheckWithUrl:urlStr params:nil success:^(id  _Nullable response) {
        
        UserModel *model = [UserModel yy_modelWithJSON:response[response_data]];
        
        if(completion) completion([model.isidentity isEqualToString:@"2"], [model.issetacc isEqualToString:@"1"]);
        
        [[NSUserDefaults standardUserDefaults]setObject:model.phone forKey:VerifierPhone];
        [[NSUserDefaults standardUserDefaults] setObject:model.email forKey:VerifierEmail];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        //本地保持用户信息
        [TWUserDefault UserDefaultSaveUserModel:model];
    
        
    } failure:^(id  _Nullable response){
      
    } reqError:^(NSError * _Nullable error) {
    
    }];
}

//开启手势或指纹
+(void)openGesturesOrFingerprints{
  
    //开启手势解锁
    if ([[PCCircleViewConst getGestureWithKey:gestureFinalSaveKey] length]) {
        
        GestureViewController *gestureVc = [[GestureViewController alloc] init];
        [gestureVc setType:GestureViewControllerTypeLogin];
//        [[TWAppTool currentViewController].navigationController pushViewController:gestureVc animated:YES];
        
        UIViewController *rootVC = [self currentViewController];
        [rootVC.tabBarController presentViewController:[[TWBaseNavigationController alloc]initWithRootViewController:gestureVc]  animated:YES completion:^{
            //
        }];
    }
    
    //开启指纹解锁
    if ([[NSUserDefaults standardUserDefaults] boolForKey:@"touchID"]) {
    
        TouchIDViewController * vc = [[TouchIDViewController alloc]init];
        UIViewController *rootVC = [self currentViewController];
        [rootVC.tabBarController presentViewController:[[TWBaseNavigationController alloc]initWithRootViewController:vc]  animated:YES completion:^{
            //
        }];
//        [[TWAppTool currentViewController].navigationController pushViewController:vc animated:YES];


    }
}

+ (NSString *)getCurrentDate {
    NSDate *currentDate = [NSDate date];//获取当前时间，日期
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"MMddhhmmss"];
    NSString *dateString = [dateFormatter stringFromDate:currentDate];
    return dateString;
}

//回退登录界面处理，退出登录,一般用于异常退出
+(void)gotoIndexVCLoginRootVc{

    [[NSUserDefaults standardUserDefaults] setBool:NO forKey:isLogin];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    [TWUserDefault DeleSaveUserModel];
    
    dispatch_async(dispatch_get_main_queue(), ^{
//        //先跳转到首页再跳转到登录页面（Joblee）
//        UITabBarController *tabVC = [TWAppTool currentViewController].navigationController.tabBarController;
//        tabVC.selectedIndex = 0;
//        UINavigationController *homeNAC = tabVC.selectedViewController;
//        [homeNAC popToRootViewControllerAnimated:NO];
//        LoginIndexVC * vc = [[LoginIndexVC alloc]init];
//        [homeNAC pushViewController:vc animated:YES];
        
        
        // 我们要把系统windown的rootViewController替换掉
        AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
        BaseTabBarController *tabVC = [[BaseTabBarController alloc] init];
        delegate.window.rootViewController = tabVC;
        
        LoginIndexVC * vc = [[LoginIndexVC alloc]init];
        [[self currentViewController].navigationController presentViewController:[[TWBaseNavigationController alloc] initWithRootViewController:vc] animated:YES completion:nil];
        
    });
}

//退回登录界面,这个情况已经退出登录了
+(void)gotoIndexVCLogin{

    dispatch_async(dispatch_get_main_queue(), ^{
        LoginIndexVC * vc = [[LoginIndexVC alloc]init];
        [[TWAppTool currentViewController].navigationController pushViewController:vc animated:YES];

    });
}

+(UIViewController *)currentViewController {
    UIViewController *result = nil;
    
    UIWindow * window = [[UIApplication sharedApplication] keyWindow];
    if (window.windowLevel != UIWindowLevelNormal){
        NSArray *windows = [[UIApplication sharedApplication] windows];
        for(UIWindow * tmpWin in windows){
            if (tmpWin.windowLevel == UIWindowLevelNormal){
                window = tmpWin;
                break;
            }
        }
    }
    
    UIView *frontView = [[window subviews] objectAtIndex:0];
    id nextResponder = [frontView nextResponder];
    
    if ([nextResponder isKindOfClass:[UIViewController class]])
        result = nextResponder;
    else if([nextResponder isKindOfClass:[UINavigationController class]]){
        
        result = [nextResponder viewControllers].lastObject;
    } else
        result = window.rootViewController;
    
    return [self getCurrentVCFrom:result];
}

+ (UIViewController *)getCurrentVCFrom:(UIViewController *)rootVC{
    
    UIViewController *currentVC;
    
    if ([rootVC presentedViewController]) {
        // 视图是被presented出来的
        
        rootVC = [rootVC presentedViewController];
    }
    
    if ([rootVC isKindOfClass:[UITabBarController class]]) {
        // 根视图为UITabBarController
        
        currentVC = [self getCurrentVCFrom:[(UITabBarController *)rootVC selectedViewController]];
        
    } else if ([rootVC isKindOfClass:[UINavigationController class]]){
        // 根视图为UINavigationController
        
        currentVC = [self getCurrentVCFrom:[(UINavigationController *)rootVC visibleViewController]];
        
        //    } else if([rootVC isKindOfClass:[MGTabBarController class]]){
        //
        //        currentVC = [self getCurrentVCFrom:[(UITabBarController *)rootVC selectedViewController]];
        //
    }else{
        // 根视图为非导航类
        
        currentVC = rootVC;
    }
    
    return currentVC;
}

/**从类中获取属性和值
 *@param model 实体类
 *@param completion 完成后的回调
 */

+(void )getPropertiesAndValueFromModel:(id)model completion:(void (^)(NSString * key, id value)) completion{
    unsigned int count = 0;
    objc_property_t * properties = class_copyPropertyList([model class], &count);
    for (unsigned int i = 0; i < count; i++) {
        objc_property_t property = properties[i];
        NSString * key = [NSString stringWithUTF8String:property_getName(property)];
        id value = [model valueForKey:key];
        if(completion) completion(key,value);
    }
    free(properties);
}


//添加水印和文字
+(UIImage *)addWatermarkWithImage:(UIImage *)image supImageV:(UIImageView *)imageV{
    float imageWidth = image.size.width;
    float imageHeight = image.size.height;
    
    float scaleWidth = imageWidth/imageV.width;
    float scaleHeight = imageHeight/imageV.height;
    
    UIImage * waterImage = [UIImage imageNamed:@"shuiyin"];
    float waterWidth = waterImage.size.width * scaleWidth;
    float waterHeight = waterImage.size.height * scaleHeight;
    
    NSDate * date = [NSDate date];
    NSString * timeStr = [date stringWithFormat:@"YYYY-MM-dd"];
    
    
    //水印文字
    UIImage * newImage = [UIImage mg_watermarkWithTargetImage:image watermark:timeStr rect:CGRectMake((imageWidth-waterWidth)/2.0,imageHeight-Adapted(20)*scaleHeight, waterWidth + 20, waterHeight) attributes:@{NSStrokeWidthAttributeName : @(-5),NSStrokeColorAttributeName : [UIColor clearColor],NSFontAttributeName : [UIFont boldSystemFontOfSize:12*scaleWidth],NSForegroundColorAttributeName : UIColorFromRGBA(0x191a1e, 0.3)}];
    //水印图片
    newImage = [UIImage mg_watermarkWithTargetImage:newImage watermarkImage:waterImage rect:CGRectMake((imageWidth-waterWidth)/2.0, (imageHeight-waterHeight)/2.0, waterWidth, waterHeight)];
    
    return newImage;
}

/**
 * 倒计时处理
 *@param countdown 倒计时数字
 *@param time 倒计时时间戳
 *@param button 倒计时按钮
 */
+(void)startTheCountdownWithPhoneCountdown:(NSString *)countdown Time:(NSString *)time btn:(UIButton *)button{
    
    //判断倒计时是否走完60秒
    NSUserDefaults * user = [NSUserDefaults standardUserDefaults];
    if([user objectForKey:countdown]){
        //获取倒计时中断的秒数
        NSString * string = [user objectForKey:countdown];
        NSInteger oldNumber = [string integerValue];
        //获取倒计时中断时的时间戳
        NSDate *oldDate = (NSDate *)[user objectForKey:time];
        //获取当前时间戳
        NSDate *nowDate = [NSDate date];
        //超过保存的时间戳多少秒
        NSInteger inter = [nowDate timeIntervalSinceDate:oldDate];
        //时间还可以继续走
        if(oldNumber - inter>1){
            [button mg_startCountDownTime:(oldNumber - inter) finishTitle:kLocalizedString(@"获取验证码") waitTittle:@"S" finishColor:nil waitColor:nil Finish:^(UIButton *button) {
            }];
        }
        
    }
}



/**
 *  加密指定区域字符串, 即替换为 *
 */
+ (NSString *)mg_secureText:(NSString *)string range:(NSRange)range
{
    
    if(string.length < range.location + range.length) return nil;
    NSString *star = @"";
    for (NSInteger i = 0; i < range.length; i++) {
        
        star = [star stringByAppendingString:@"*"];
    }
    return  [string stringByReplacingCharactersInRange:range withString:star];
}

/**
 *  加密即替换为 *
 */
+ (NSString *)mg_securePhoneMailText:(NSString *)string{
    
    if(string.length<7)  return @"***";
    NSString *star = @"";
    NSRange range = NSMakeRange(3, 3);
    for (NSInteger i = 0; i < 3; i++) {
        star = [star stringByAppendingString:@"*"];
    }
    return [string stringByReplacingCharactersInRange:range withString:star];
    

}

/**
 *  名字替换星
 */
+ (NSString *)mg_secureNameText:(NSString *)string{

    if(string.length == 0) return @"***";

    if([self unicodeLengthOfString:string]<1)  return @"***";
    
    NSString * nameStr = [string substringToIndex:1];
    if([self unicodeLengthOfString:string] == 4){
        return [NSString stringWithFormat:@"%@*",nameStr];
    }else if ([self unicodeLengthOfString:string] >4){
        return [NSString stringWithFormat:@"%@**",nameStr];
    }else{
        return @"***";
    }
    
}


+(NSUInteger) unicodeLengthOfString: (NSString *) text {
    NSUInteger asciiLength = 0;
    for (NSUInteger i = 0; i < text.length; i++) {
        unichar uc = [text characterAtIndex: i];
        asciiLength += isascii(uc) ? 1 : 2;
    }
    NSUInteger unicodeLength = asciiLength / 2;
    if(asciiLength % 2) {
        unicodeLength++;
    }
    return asciiLength;
}

+(void)cornerWithRadius:(float)radius view:(UIView *)view border:(float)borderWidth borderColor:(UIColor*)borderColor
{
    view.layer.cornerRadius = radius;
    view.layer.masksToBounds = YES;
    if (borderWidth > 0) {
        view.layer.borderWidth = borderWidth;
    }
    if (borderColor) {
        view.layer.borderColor = borderColor.CGColor;
    }
}

@end
