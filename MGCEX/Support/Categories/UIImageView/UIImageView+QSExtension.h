//
//  UIImageView+QSExtension.h
//  TestTouchEvent
//
//  Created by apple on 2016/11/17.
//  Copyright © 2016年 MGCoin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImageView (QSExtension)


/**
 *  根据屏幕宽度放大图片（图片宽度等于屏幕宽度，图片高度根据原图片的宽高比放大）
 */
- (void)qs_enlargeImageBasedOnScreenWidth;

/**
 *  捏合手势缩放图片
 */
- (void)qs_enlargeImageWithGesture;
@end
