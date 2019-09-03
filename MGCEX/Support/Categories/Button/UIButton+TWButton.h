//
//  UIButton+TWButton.h
//  sdaasda
//
//  Created by MGCion on 2017/10/18.
//  Copyright © 2017年 MGCion. All rights reserved.
// @ description --图文排列
// @ description --block回掉
// @ description --扩大响应范围
// @ description --倒计时
// @ description --菊花
// @ description --使用颜色代替image设置背景和状态
// @ description --切半角

#import <UIKit/UIKit.h>

typedef void (^CallBackBlock)(UIButton * button);
typedef void (^TimeFinishBlock)(UIButton * button);

typedef NS_ENUM(NSInteger, TWImagePositionStyle){
    TWImagePositionLeft = 0,            //图片在左，文字在右，默认
    TWImagePositionRight = 1,           //图片在右，文字在左
    TWImagePositionTop = 2,             //图片在上，文字在下
    TWImagePositionBottom = 3,          //图片在下，文字在上
};

@interface UIButton (TWButton)
//点击事件block
@property (nonatomic, copy) CallBackBlock callBackBlock;
//倒计时
@property (nonatomic, strong) dispatch_source_t timer;
//倒计时完成block
@property (nonatomic, strong) TimeFinishBlock timeFinishBlock;
@property (nonatomic, assign) NSInteger timeOutNumber;

/**
 * button block回掉
 */
-(void)mg_addTapBlock:( CallBackBlock )block;

/**
 *  利用UIButton的titleEdgeInsets和imageEdgeInsets来实现文字和图片的自由排列
 *  注意：这个方法需要在设置图片和文字之后才可以调用，且button的大小要大于 图片大小+文字大小+spacing
 *@param type 枚举
 *@param spacing 图文间距
 */
- (void)mg_setbuttonType:(TWImagePositionStyle)type spacing:(CGFloat )spacing;

/**
 *  扩大 UIButton 的响应范围
 *  控制上下左右的延長範圍  适用于界面按钮比较小的情况
    @param top 顶部扩大
 *  @param right 右边扩大
 *  @param bottom 下面扩大
 *  @param left 左边扩大
 */
- (void)mg_setEnlargeEdgeWithTop:(CGFloat)top right:(CGFloat)right bottom:(CGFloat)bottom left:(CGFloat)left;

/**
 * 倒计时
 *@param timeout 倒计时秒数
 *@param tittle 倒计时完成后button的文字，比如：重新获取验证码
 *@param waitTittle 倒计时单位 s m h
 *@param FColor 倒计时完成后button的颜色
 *@param WColor 倒计时过程中的button颜色
 */
- (void)mg_startCountDownTime:(NSInteger )timeout finishTitle:(NSString *)tittle waitTittle:(NSString *)waitTittle finishColor:(UIColor *)FColor waitColor:(UIColor *)WColor Finish:(TimeFinishBlock)timeBlock;

/**
 * 显示菊花 按钮失能
 */
- (void)mg_showIndicator;

/**
 * 隐藏菊花。按钮使能
 */
- (void)mg_hideIndicator;

/**
 *  @brief  使用颜色设置按钮背景
 *
 *  @param backgroundColor 背景颜色
 *  @param state           按钮状态
 */
- (void)mg_setBackgroundColor:(UIColor *)backgroundColor forState:(UIControlState)state;

/**
 * 切半角
 *@param type 枚举，切哪个半角
 *@param radius 值
 */
-(void)mg_RoundedRectWithType:(UIRectCorner)type Radius:(CGFloat)radius;

/**
 * 使能失能按钮改变颜色
 *@param enableColor 使能颜色
 *@param disableColor 失能颜色
 */
-(void)setStatusWithEnableColor:(UIColor *)enableColor disableColor:(UIColor *)disableColor;



/**
 * @brief 设置按钮边框样式
 @param cornerRadius 圆角半径
 @param borderColor 边框样式
 @param borderWidth 边框粗细
 */
- (void)setButtonCornerRadius:(CGFloat)cornerRadius borderColor:(UIColor *)borderColor borderWidth:(CGFloat)borderWidth;

@end
