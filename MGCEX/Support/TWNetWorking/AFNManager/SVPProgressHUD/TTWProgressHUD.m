//
//  ALiProgressHUD.m
//  ALiProgressHUD
//
//  Created by LeeWong on 16/9/8.
//  Copyright © 2016年 LeeWong. All rights reserved.
//

#import "TTWProgressHUD.h"
#import <objc/runtime.h>
//#import <CoreMotion/CoreMotion.h>

#define WEAKSELF(weakSelf)  __weak __typeof(&*self)weakSelf = self;


@interface TTWProgressHUD ()
//传感器
//@property (nonatomic, strong) CMMotionManager *motionManager;
//最终旋转方向
@property (nonatomic, assign) UIInterfaceOrientation lastOrientation;
@end

@implementation TTWProgressHUD
/**
 *  SVProgressHUDMaskTypeNone：默认图层样式，当HUD显示的时候，允许用户交互。
 *  SVProgressHUDMaskTypeClear：当HUD显示的时候，不允许用户交互。
 *  SVProgressHUDMaskTypeBlack：当HUD显示的时候，不允许用户交互，且显示黑色背景图层。
 *  SVProgressHUDMaskTypeGradient：当HUD显示的时候，不允许用户交互，且显示渐变的背景图层。
 *  SVProgressHUDMaskTypeCustom：当HUD显示的时候，不允许用户交互，且显示背景图层自定义的颜色。
 */
// Customization
+ (void)initialize
{
//    [self setSuccessImage:[UIImage imageNamed:@"HUD_success"]];
//    [self setInfoImage:[UIImage imageNamed:@"HUD_info"]];
//    [self setErrorImage:[UIImage imageNamed:@"HUD_error"]];
//    [self setMinimumDismissTimeInterval:2.0];
//
//    [self setDefaultAnimationType:SVProgressHUDAnimationTypeFlat];//转圈还是菊花
//    [self setDefaultStyle:SVProgressHUDStyleCustom];
//    [self setForegroundColor:kTextColor];
//    [self setBackgroundColor:white_color];
//    [self setCornerRadius:8.0];
//
//
    [SVProgressHUD setDefaultAnimationType:SVProgressHUDAnimationTypeFlat];//转圈还是菊花
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeCustom];// 整个后面的背景选择
    [SVProgressHUD setBackgroundColor:kAssistColor];// 弹出框颜色
    [SVProgressHUD setForegroundColor:kLineAssistColor];// 弹出框内容颜色
 
    /*
     当设置setDefaultStyle:SVProgressHUDStyleCustom时，才能设置前置和后置颜色
     [self setDefaultStyle:SVProgressHUDStyleCustom];
     [self setForegroundColor:[UIColor redColor]];//设置HUD和文本的颜色
     [self setBackgroundColor:[UIColor magentaColor]];
     
     */
    
  
}



// 根据 提示文字字数，判断 HUD 显示时间
- (NSTimeInterval)displayDurationForString:(NSString*)string
{
    return MIN((float)string.length*0.1 + 0.5, 2.0);
}

// 修改 HUD 颜色，需要取消混合效果(使`backgroundColroForStyle`方法有效)
- (void)updateBlurBounds{
}

// HUD 颜色
- (UIColor*)backgroundColorForStyle{
    return [UIColor colorWithWhite:0 alpha:0.8];
}

//跟随屏幕旋转
//// 当视图即将加入父视图时 / 当视图即将从父视图移除时调用
//- (void)willMoveToSuperview:(UIView *)newSuperview
//{
//    if([self.motionManager isAccelerometerAvailable]){
//        [self orientationChange];
//    }
//}
//// 当子视图从本视图移除时调用
//- (void)willRemoveSubview:(UIView *)subview
//{
//    if (self.motionManager) {
//        [self.motionManager stopAccelerometerUpdates];
//        self.motionManager = nil;
//    }
//}

//#pragma mark - 屏幕方向旋转
//- (void)orientationChange
//{
//    WEAKSELF(weakSelf);
//    [self.motionManager startAccelerometerUpdatesToQueue:[NSOperationQueue currentQueue] withHandler:^(CMAccelerometerData * _Nullable accelerometerData, NSError * _Nullable error) {//当采集到加速计信息后执行
//        // 4.获取加速计信息
//        CMAcceleration acceleration = accelerometerData.acceleration;
//        __block UIInterfaceOrientation orientation;
//        if (acceleration.x >= 0.75) {
//            orientation = UIInterfaceOrientationLandscapeLeft;
//        }
//        else if (acceleration.x <= -0.75) {
//            orientation = UIInterfaceOrientationLandscapeRight;
//
//        }
//        else if (acceleration.y <= -0.75) {
//            orientation = UIInterfaceOrientationPortrait;
//
//        }
//        else if (acceleration.y >= 0.75) {
//            orientation = UIInterfaceOrientationPortraitUpsideDown;
//            return ;
//        }
//        else {
//
//            return;
//        }
//
//        if (orientation != weakSelf.lastOrientation) {//如果方向变了
//            [weakSelf configHUDOrientation:orientation];
//            weakSelf.lastOrientation = orientation;
//            NSLog(@"%tu=-------%tu",orientation,weakSelf.lastOrientation);
//        }
//
//    }];
//}
//
////改变hud方向
//- (void)configHUDOrientation:(UIInterfaceOrientation )orientation
//{
//    CGFloat angle = [self calculateTransformAngle:orientation];
//    self.transform = CGAffineTransformRotate(self.transform, angle);
//}
//
//
//- (CGFloat)calculateTransformAngle:(UIInterfaceOrientation )orientation
//{
//    CGFloat angle = 0.0;
//    if (self.lastOrientation == UIInterfaceOrientationPortrait) {
//        switch (orientation) {
//            case UIInterfaceOrientationLandscapeRight:
//                angle = M_PI_2;
//                break;
//            case UIInterfaceOrientationLandscapeLeft:
//                angle = -M_PI_2;
//                break;
//            default:
//                break;
//        }
//    } else if (self.lastOrientation == UIInterfaceOrientationLandscapeRight) {
//        switch (orientation) {
//            case UIInterfaceOrientationPortrait:
//                angle = -M_PI_2;
//                break;
//            case UIInterfaceOrientationLandscapeLeft:
//                angle = M_PI;
//                break;
//            default:
//                break;
//        }
//    } else if (self.lastOrientation == UIInterfaceOrientationLandscapeLeft) {
//        switch (orientation) {
//            case UIInterfaceOrientationPortrait:
//                angle = M_PI_2;
//                break;
//            case UIInterfaceOrientationLandscapeRight:
//                angle = M_PI;
//                break;
//            default:
//                break;
//        }
//    }
//    return angle;
//}
//
//#pragma mark - Lazy Load
//- (CMMotionManager *)motionManager
//{
//    if (_motionManager == nil) {
//        _motionManager = [[CMMotionManager alloc] init];
//        _motionManager.accelerometerUpdateInterval = 1./15.;
//
//    }
//    return _motionManager;
//}
@end
