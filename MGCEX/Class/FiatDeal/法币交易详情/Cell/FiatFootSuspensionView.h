// MGC
//
// FiatFootSuspensionView.h
// MGCEX
//
// Created by MGC on 2018/5/28.
// Copyright © 2018年 MGCion. All rights reserved.
//
// @ description <#描述#> 

#import <UIKit/UIKit.h>
/*
 
 1--------买币
 1 标记为已付款
 2。等待卖家放币
 3. 已完成，已取消。 自身消失
 4. 我已付款，对方还没有放币。20分钟后才能申诉否则提醒倒计时
 5。发起申诉。按钮变提交 -》跳页面 按钮变提交
 6.提交申诉后，按钮变查看申诉记录
 7 申诉被驳回 重新申诉
 8.被对方申诉，按钮变 发起回诉。-》跳页面 按钮变提交
 9.发起回诉被驳回 重新回诉
 10.没有被驳回则-〉查看回诉记录
 
 2------卖币
 1 等待买家付款
 2 标记为已收款
 
 
 */

//交易者身份。买家/卖家
typedef enum : NSUInteger {
    Trading_Buy = 0, //收币,买币 红色
    Trading_Sell = 1, //卖币。绿色
    
} TradingRoleType;

//买币交易状态
typedef enum : NSUInteger {
    Buy_AlreadyPayment = 0,//已付款,等待卖家放币,未点击“标记已付款”
    Buy_AlreadyComplete = 1,//已完成交易，自身消失
    Buy_BeforeTime = 2,//没到20分钟发起申诉,提醒弹框
    Buy_AfterTime = 3,//已过20分钟发起申诉
    Buy_GotoComplaint = 4,//跳申诉页面，按钮：取消：提交，提交后返回
    Buy_ComplaintRecord = 5,//申诉成功-查看申诉记录
    Buy_ComplaintRejected = 6,//申诉驳回按钮变重新申诉
    Buy_BeComplaint = 7,//被对方申诉,按钮变发起回诉
    Buy_GotoBeComplaint = 8,//跳回诉界面
    Buy_BeComplaintRejected = 9,//回诉被驳回，按钮变重新回诉
    Buy_BeComplaintRecord = 10,//回诉成功，查看回诉记录
    Buy_cancelOrder = 11,//取消订单
    Buy_timeOutOrder = 12,//超时
    
} TradingBuyStatusType;

//卖币交易状态
typedef enum : NSUInteger {
    Sell_AlreadyPayment = 0,//我已卖币,等待买家付款 无任何按钮
    Sell_AlreadyComplete = 1,//已完成交易，自身消失
    Sell_BeforeTime = 2,//没到20分钟发起申诉,提醒弹框
    Sell_AfterTime = 3,//已过20分钟发起申诉
    Sell_Complaint = 4,//卖家跳申诉界面 取消 提交
    Sell_ComplaintRecord = 5,//申诉完成 查看申诉记录
    Sell_ComplaintRejected = 6,//申诉驳回 重新申诉
    Sell_BeComplaint = 7,//被申诉 发起回诉
    Sell_GotoBeComplaint = 8,//跳回诉界面
    Sell_BeComplaintRejected = 9,//回诉被驳回 重新回诉
    Sell_ResertComplaintRecord = 10,//回诉成功 查看回诉记录
    Sell_cancelOrder = 11,//取消订单
    Sell_timeOutOrder = 12,//超时
 
} TradingSellStatusType;


@class FiatFootSuspensionView;
@protocol FiatFootSuspensionDelegate // 代理传值方法
- (void)sendValueRightClick;//点击右边按钮
- (void)sendValueLeftClick;//点击左边按钮
@end

@interface FiatFootSuspensionView : UIView
@property (nonatomic, strong) UIButton * buttonOne;
@property (nonatomic, strong) UIButton * buttonTwo;
@property (nonatomic, assign) TradingBuyStatusType tradingBuyStatusType;
@property (nonatomic, assign) TradingSellStatusType tradingSellStatusType;
@property (nonatomic, assign) TradingRoleType tradingRoleType;
@property (nonatomic, weak) NSObject <FiatFootSuspensionDelegate>* btnDelegate;
@end
