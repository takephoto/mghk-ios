//
//  MGImagePickerHelper.h
//  MGWallet
//
//  Created by HFW on 2017/3/22.
//  Copyright © 2017年 HFW. All rights reserved.
//

#import <UIKit/UIKit.h>

//拍照后照片的方向
typedef NS_ENUM(NSInteger, TTWSysOrientationStyle) {
    TTWSysOrientadefault,//默认
    TTWSysOrientationPortrait,//照片竖直
    TTWSysOrientationLandscape//照片水平
};

typedef void(^selectedImagecompletion)(UIImage *image);
typedef void(^cancleImageBlock)(UIImagePickerController *picker);

@interface MGImagePickerHelper : UIImagePickerController<UINavigationControllerDelegate, UIImagePickerControllerDelegate>



/**
 *调起相机或者相册
 *@param type 相机或者相册类型
 *@param completion 选择完图片后的回调
 */
+ (void)mg_openCameraOrAlbum:(UIImagePickerControllerSourceType)type orientationStyle:(TTWSysOrientationStyle)imageOrientation  didSelectImage:(selectedImagecompletion)completion didCancle:(cancleImageBlock)cancle;


@end
