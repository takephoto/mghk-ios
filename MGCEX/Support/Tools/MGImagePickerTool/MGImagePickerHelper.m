//
//  MGImagePickerHelper.m
//  MGWallet
//
//  Created by HFW on 2017/3/22.
//  Copyright © 2017年 HFW. All rights reserved.
//

#import "MGImagePickerHelper.h"
#import <objc/runtime.h>
#import <MobileCoreServices/UTCoreTypes.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import <AVFoundation/AVFoundation.h>

#define iOS7Later ([UIDevice currentDevice].systemVersion.floatValue >= 7.0f)
#define iOS8Later ([UIDevice currentDevice].systemVersion.floatValue >= 8.0f)
#define iOS9Later ([UIDevice currentDevice].systemVersion.floatValue >= 9.0f)
#define iOS9_1Later ([UIDevice currentDevice].systemVersion.floatValue >= 9.1f)

@interface MGImagePickerHelper ()

/**拍照后照片的方向*/
@property (nonatomic, assign) TTWSysOrientationStyle OrientationStyle;

/**选择图片后的回调*/
@property (nonatomic,copy) selectedImagecompletion completion;

/**取消选择图片回调*/
@property (nonatomic,copy) cancleImageBlock cancle;
@end

@implementation MGImagePickerHelper

/**
 *调起相机或者相册
 */
+ (void)mg_openCameraOrAlbum:(UIImagePickerControllerSourceType)type orientationStyle:(TTWSysOrientationStyle)imageOrientation  didSelectImage:(selectedImagecompletion)completion didCancle:(cancleImageBlock)cancle;{
    
    if (TARGET_IPHONE_SIMULATOR == 1 && TARGET_OS_IPHONE == 1) {
        
       // NSLog(@"请在真机下运行");
        
    }else{
   
        //验证相机权限
        AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
        if (authStatus == AVAuthorizationStatusDenied || //程序未被授权
            authStatus == AVAuthorizationStatusRestricted) {//用户明确禁止访问
            
            [self setCameraPermissions];
            
        }else{
            
            [self takePhotograph:type imageOrientation:(TTWSysOrientationStyle)imageOrientation  completion:completion didCancle:cancle];
            
        }
        
    }
 
   
}

+ (void)setCameraPermissions
{
    
    UIAlertController *alertDialog = [UIAlertController alertControllerWithTitle:nil message:kLocalizedString(@"未打开照相机权限，请前往开启") preferredStyle:UIAlertControllerStyleAlert];
    
    // 确认
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:kLocalizedString(@"设置") style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        
        NSURL *url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
        if ([[UIApplication sharedApplication] canOpenURL:url]) {
            
            [[UIApplication sharedApplication] openURL:url];
        }
    }];
    
    // 取消
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:kLocalizedString(@"取消") style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
        
    }];
    
    // 添加操作
    [alertDialog addAction:okAction];
    [alertDialog addAction:cancelAction];
    // 呈现警告视图
    [[self getCurrentVC] presentViewController:alertDialog animated:YES completion:nil];
}

+ (void)takePhotograph:(UIImagePickerControllerSourceType )ttwType imageOrientation:(TTWSysOrientationStyle)imageOrientation    completion:(selectedImagecompletion)completion didCancle:(cancleImageBlock)cancle
{
    //当前显示的ViewController
    UIViewController *currentVC = [self getCurrentVC];
    
    MGImagePickerHelper *picker = [MGImagePickerHelper new];
    picker.delegate = picker;
    //picker.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
    picker.sourceType = ttwType;
    picker.allowsEditing = NO;
    picker.OrientationStyle = imageOrientation;
    
    picker.completion = completion;
    picker.cancle = cancle;
    
 
    picker.navigationBar.translucent = NO;
    [currentVC presentViewController:picker animated:YES completion:nil];
    
}

#pragma mark - UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{
    /*
    1. 导入库  MobileCoreServices.framework
    2. 引用 import <MobileCoreServices/UTCoreTypes.h>
    */
    NSString *mediaType = [info objectForKey:UIImagePickerControllerMediaType];
   
    // 判断获取类型：图片
    if ([mediaType isEqualToString:( NSString *)kUTTypeImage]){

        UIImage *theImage = nil;
        // 判断，图片是否允许修改
        if ([picker allowsEditing]){
            //获取用户编辑之后的图像
            theImage = [info objectForKey:UIImagePickerControllerEditedImage];
        } else {
            // 照片的元数据参数
            theImage = [info objectForKey:UIImagePickerControllerOriginalImage];
            
        }
        
       theImage = [self changeImageOrientation:theImage];
        
        if (self.completion) {
            
        self.completion(theImage);
            [self dismissViewControllerAnimated:YES completion:nil];
        }
        
      
    }
   
}
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    
    if (self.cancle) {
        
        self.cancle(picker);
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

-(UIImage *)changeImageOrientation:(UIImage *)ima{
    
    switch (self.OrientationStyle) {
        case TTWSysOrientadefault:
        {
            return ima;
         
        }
            break;
            
        case TTWSysOrientationPortrait:
        {
            if(ima.imageOrientation==UIImageOrientationUp || ima.imageOrientation==UIImageOrientationDown){
                
                UIImage * image = [UIImage imageWithCGImage:ima.CGImage scale:1 orientation:UIImageOrientationRight];
                
                return image;
            }else{
                
                return ima;
                
            }
        }
            break;
        case TTWSysOrientationLandscape:
            {
                if(ima.imageOrientation==UIImageOrientationRight || ima.imageOrientation==UIImageOrientationLeft){
                    
                    UIImage * image = [UIImage imageWithCGImage:ima.CGImage scale:1 orientation:UIImageOrientationUp];
                    
                    return image;
                }else{
                    
                    return ima;
                    
                }
             
            }
            break;
        
            
        default:
            break;
    }
}

//获取当前屏幕显示的viewcontroller
+ (UIViewController *)getCurrentVC
{
    UIViewController *rootViewController = [UIApplication sharedApplication].keyWindow.rootViewController;
    
    UIViewController *currentVC = [self getCurrentVCFrom:rootViewController];
    
    return currentVC;
}

+ (UIViewController *)getCurrentVCFrom:(UIViewController *)rootVC
{
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
        
    } else {
        // 根视图为非导航类
        
        currentVC = rootVC;
    }
    
    return currentVC;
}


@end
