//
//  UITextField+Shake.h
//  UITextField+Shake
//
//  Created by Andrea Mazzini on 08/02/14.
//  Copyright (c) 2015 Fancy Pixel. All rights reserved.
//

#import <UIKit/UIKit.h>

/** @enum 枚举指定的方向摇动
 *
 *
 */
typedef NS_ENUM(NSInteger, ShakeDirection) {
    /** 左和右 */
    ShakeDirectionHorizontal,
    /** 上和下 */
    ShakeDirectionVertical
};


@interface UITextField (Shake)

//默认左右震动
- (void)shake;

//震动次数和左右跨度（宽度）
- (void)shake:(int)times withDelta:(CGFloat)delta;

//震动次数和左右跨度（宽度）+完成后回掉
- (void)shake:(int)times withDelta:(CGFloat)delta completion:(nullable void (^)(void))handler;

//震动次数和左右跨度（宽度）+速度适中(0.05-1)
- (void)shake:(int)times withDelta:(CGFloat)delta speed:(NSTimeInterval)interval;

//震动次数和左右跨度（宽度）+速度适中(0.05-1)+完成后回掉
- (void)shake:(int)times withDelta:(CGFloat)delta speed:(NSTimeInterval)interval completion:(nullable void (^)(void))handler;

//震动次数和左右跨度（宽度）+速度适中(0.05-1)+上下或者左右
- (void)shake:(int)times withDelta:(CGFloat)delta speed:(NSTimeInterval)interval shakeDirection:(ShakeDirection)shakeDirection;

//震动次数和左右跨度（宽度）+速度适中(0.05-1)+上下或者左右+完成后回掉
- (void)shake:(int)times withDelta:(CGFloat)delta speed:(NSTimeInterval)interval shakeDirection:(ShakeDirection)shakeDirection completion:(nullable void (^)(void))handler;

@end
