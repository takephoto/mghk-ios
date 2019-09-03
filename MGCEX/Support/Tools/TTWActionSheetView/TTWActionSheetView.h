// MGC
//
// TTWActionSheetView.h
// MGCPay
//
// Created by MGC on 2018/2/5.
// Copyright © 2018年 Joblee. All rights reserved.
//
// @ description <#描述#> 

#import <UIKit/UIKit.h>
@class TTWActionSheetView;

/**
 * @brief 点击按钮回掉
 * @param actionSheetView 自己
 * @param buttonIndex 按钮的tag
 */
typedef void (^TTWActionSheetViewDidSelectButtonBlock)(TTWActionSheetView *actionSheetView, NSInteger buttonIndex);

@interface TTWActionSheetView : UIView

@property (nonatomic, strong) UIButton *btn;
/**
 * @brief 类方法
 * @param title 标题
 * @param cancelButtonTitle 取消
 * @param destructiveButtonTitle 描述提醒
 * @param index 默认index
 * @param otherButtonTitles 其他按钮,数组
 * @return TTWActionSheetView对象
 */
+ (TTWActionSheetView *)showActionSheetWithTitle:(NSString *)title selectIndex:(NSInteger )index cancelButtonTitle:(NSString *)cancelButtonTitle destructiveButtonTitle:(NSString *)destructiveButtonTitle otherButtonTitles:(NSArray *)otherButtonTitles handler:(TTWActionSheetViewDidSelectButtonBlock)block;

/**
 * @brief 实例化
 * @param title 标题
 * @param cancelButtonTitle 取消
 * @param destructiveButtonTitle 描述提醒
 * @param index 默认index
 * @param otherButtonTitles 其他按钮,数组
 * @return TTWActionSheetView对象
 */
- (instancetype)initWithTitle:(NSString *)title selectIndex:(NSInteger )index cancelButtonTitle:(NSString *)cancelButtonTitle destructiveButtonTitle:(NSString *)destructiveButtonTitle otherButtonTitles:(NSArray *)otherButtonTitles handler:(TTWActionSheetViewDidSelectButtonBlock)block;

- (void)show;
- (void)dismiss;

@end
