// MGC
//
// FiatFootSuspensionView.m
// MGCEX
//
// Created by MGC on 2018/5/28.
// Copyright © 2018年 MGCion. All rights reserved.
//
// @ description <#描述#> 


#define OriginalTopHeight 32//topVIew初始高度
#define NarrowTopHeight 3//topVIew隐藏的高度
#define LowOneBtnWidth Adapted(104)//右一最短宽度
#define LowTwoBtnWidth Adapted(74)//右二最短宽度

#import "FiatFootSuspensionView.h"

@interface FiatFootSuspensionView()



@property (nonatomic, strong) UIView * topView;
@property (nonatomic, strong) UILabel * topTitle;
@property (nonatomic, strong) UILabel * bottomTitle;

@end

@implementation FiatFootSuspensionView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setUpViews];
    }
    return self;
}

-(void)setUpViews{
    
    self.backgroundColor = white_color;
    
    //顶部VIew
    UIView * topView = [[UIView alloc]init];
    topView.backgroundColor = UIColorFromRGB(0xf1f1f1);
    [self addSubview:topView];
    self.topView = topView;
    [topView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(self);
        make.bottom.mas_equalTo(self.mas_top).offset(0);
        make.height.mas_equalTo(OriginalTopHeight);
    }];
    
    
    //顶部提示文字
    UILabel * topTitle = [[UILabel alloc]init];
    [topView addSubview:topTitle];
    self.topTitle = topTitle;
    topTitle.textAlignment = NSTextAlignmentCenter;
    topTitle.textColor = kBackAssistColor;
    topTitle.numberOfLines = 0;
    topTitle.font = H13;
    [topTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(Adapted(15));
        make.right.mas_equalTo(topView.mas_right).offset(Adapted(-15));
        make.centerY.mas_equalTo(topView);
        
    }];
    
    //右边第一个按钮
    UIButton * oneBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self addSubview:oneBtn];
    self.buttonOne = oneBtn;
    oneBtn.titleLabel.font = H13;
    oneBtn.clipsToBounds = YES;
    oneBtn.layer.cornerRadius = Adapted(2);
    [oneBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(Adapted(-15));
        make.centerY.mas_equalTo(self);
        make.width.mas_equalTo(Adapted(129));
        make.height.mas_equalTo(Adapted(44));
    }];
    [oneBtn addTarget:self action:@selector(oneBtnClick) forControlEvents:UIControlEventTouchUpInside];
    
    //右边第二个按钮
    UIButton * twoBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self addSubview:twoBtn];
    self.buttonTwo = twoBtn;
    twoBtn.titleLabel.font = H13;
    twoBtn.clipsToBounds = YES;
    twoBtn.layer.cornerRadius = Adapted(2);
    [twoBtn setTitleColor:white_color forState:UIControlStateNormal];
    [twoBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(oneBtn.mas_left).offset(Adapted(-8));
        make.centerY.mas_equalTo(self);
        make.width.mas_equalTo(Adapted(129));
        make.height.mas_equalTo(Adapted(44));
    }];
    [twoBtn addTarget:self action:@selector(twoBtnClick) forControlEvents:UIControlEventTouchUpInside];
    
    //底部状态文字
    UILabel * bottomTitle = [[UILabel alloc]init];
    [self addSubview:bottomTitle];
    self.bottomTitle = bottomTitle;
    bottomTitle.numberOfLines = 0;
    bottomTitle.font = H13;
    [bottomTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(Adapted(15));
        make.right.mas_equalTo(twoBtn.mas_left).offset(Adapted(-8));
        make.centerY.mas_equalTo(self);
    }];
}

-(void)oneBtnClick{
    if([self.btnDelegate respondsToSelector:@selector(sendValueRightClick)]){
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.btnDelegate sendValueRightClick];
        });
        
    }
}

-(void)twoBtnClick{
    if([self.btnDelegate respondsToSelector:@selector(sendValueLeftClick)]){
        [self.btnDelegate sendValueLeftClick];
    }
}

-(void)setTradingBuyStatusType:(TradingBuyStatusType)tradingBuyStatusType{
    
    
    switch (tradingBuyStatusType) {
        case Buy_AlreadyPayment://0已付款,等待卖家放币
        {
            [self AlreadyPaymentHandle];
        }
            break;
        case Buy_AlreadyComplete://1 已完成交易，自身消失
        {
            [self removeFromSuperview];
        }
            break;
        case Buy_BeforeTime://2 没到20分钟发起申诉,提醒弹框
        {
            [self AlreadyCompleteHandle];
        }
            break;
        case Buy_AfterTime://3 已过20分钟发起申诉
        {
            [self AlreadyCompleteHandle];
        }
            break;
        case Buy_GotoComplaint://4 跳申诉页面，按钮：取消：提交，提交后返回
        {
            [self GotoComplaintHandle];
        }
            break;
        case Buy_ComplaintRecord://5 申诉成功-查看申诉记录
        {
            [self ComplaintRecordHandle];
        }
            break;
        case Buy_ComplaintRejected://6 申诉驳回按钮变重新申诉
        {
            [self ComplaintRejectedHandle];
        }
            break;
        case Buy_BeComplaint:// 7被对方申诉,按钮变发起回诉
        {
            [self BeComplaintHandle];
        }
            break;
        case Buy_GotoBeComplaint:// //跳回诉界面 按钮：取消：提交，提交后返回
        {
            [self GotoComplaintHandle];
        }
            break;
        case Buy_BeComplaintRejected://回诉被驳回，按钮变重新回诉
        {
            [self BeComplaintRejectedHandle];
        }
            break;
        case Buy_BeComplaintRecord://回诉成功，查看回诉记录://回诉被驳回，按钮变重新回诉
        {
            [self BeComplaintRecordHandle];
        }
            break;
        case Buy_cancelOrder://取消订单
        {
            [self removeFromSuperview];
        }
            break;
        case Buy_timeOutOrder://超时
        {
            self.buttonOne.enabled = NO;
        }
            break;
            
        default:
            break;
    }
}


-(void)setTradingSellStatusType:(TradingSellStatusType)tradingSellStatusType{
    
    switch (tradingSellStatusType) {
        case Sell_AlreadyPayment:
        {
            [self Sell_AlreadyPaymentHandle];
        }
            break;
        case Sell_AlreadyComplete://已完成交易，自身消失:
        {
            [self removeFromSuperview];
        }
            break;
        case Sell_BeforeTime://没到20分钟发起申诉,提醒弹框
        {
            [self Sell_BeforeTimeHandle];
        }
            break;
        case Sell_AfterTime://已过20分钟发起申诉
        {
            [self Sell_BeforeTimeHandle];
        }
            break;
        case Sell_Complaint://卖家跳申诉界面 取消 提交
        {
            [self Sell_ComplaintHandle];
        }
            break;
        case Sell_ComplaintRecord://申诉完成 查看申诉记录
        {
            [self Sell_ComplaintRecordHandle];
        }
            break;
        case Sell_ComplaintRejected://申诉驳回 重新申诉
        {
            [self Sell_ComplaintRejectedHandle];
        }
            break;
        case Sell_BeComplaint: //被申诉 发起回诉
        {
            [self Sell_BeComplaintHandle];
        }
            break;
        case Sell_GotoBeComplaint://跳回诉界面
        {
            [self Sell_ComplaintHandle];
        }
            break;
        case Sell_BeComplaintRejected://回诉被驳回 重新回诉
        {
            [self Sell_BeComplaintRejectedHandle];
        }
            break;
        case Sell_ResertComplaintRecord://回诉成功 查看回诉记录
        {
            [self Sell_ResertComplaintRecordHandle];
        }
            break;
        case Sell_cancelOrder://取消订单
        {
            [self removeFromSuperview];
        }
            break;
        case Sell_timeOutOrder://超时
        {
            self.buttonOne.enabled = NO;
        }
            break;
            
        default:
            break;
    }
    
    
    
    
}

///////////////********************************************BUY

//已付款,等待卖家放币
-(void)AlreadyPaymentHandle{
    //顶部VIew及文字
    self.topView.hidden = NO;
    self.topTitle.textColor = k99999Color;
    self.topTitle.text = kLocalizedString(@"付款成功后，请点击“我已付款”按钮告知对方");
    [self.topView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(OriginalTopHeight);
    }];
    
    //底部文字
    self.bottomTitle.hidden = YES;
    self.bottomTitle.text = @"";
    self.bottomTitle.textColor = kBackAssistColor;
    
    //第二个按钮
    [self.buttonTwo setTitleColor:white_color forState:UIControlStateNormal];
    self.buttonTwo.backgroundColor = kLineColor;
    [self.buttonTwo setTitle:kLocalizedString(@"取消交易") forState:UIControlStateNormal];
    
    
    //第一个按钮
    NSString * btnTitle = kLocalizedString(@"我已付款");
    self.buttonOne.backgroundColor = kGreenColor;
    [self.buttonOne setTitleColor:white_color forState:UIControlStateNormal];
    [self.buttonOne setTitle:btnTitle forState:UIControlStateNormal];
    float btnWidth = [UIView getLabelWidthByHeight:20 Title:btnTitle font:H13]+Adapted(20);
    if(btnWidth<LowOneBtnWidth){
        btnWidth = LowOneBtnWidth;
    }
    [self.buttonOne mas_updateConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(btnWidth);
    }];
}

//3 没到20分钟发起申诉,提醒弹框
-(void)AlreadyCompleteHandle{
    //顶部VIew及文字
    [self.topView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(NarrowTopHeight);
    }];
    self.topTitle.text = @"";
    
    //底部文字
    self.bottomTitle.hidden = NO;
    self.bottomTitle.text = kLocalizedString(@"请耐心等待卖家放币...");
    self.bottomTitle.textColor = kBackAssistColor;
    
    //第二个按钮
    [self.buttonTwo setTitleColor:white_color forState:UIControlStateNormal];
    self.buttonTwo.backgroundColor = kLineColor;
    [self.buttonTwo setTitle:kLocalizedString(@"取消交易") forState:UIControlStateNormal];
    
    //第一个按钮
    NSString * btnTitle = kLocalizedString(@"发起申诉");
    self.buttonOne.backgroundColor = red_color;
    //self.buttonOne.layer.borderWidth = 1;
    [self.buttonOne setTitleColor:white_color forState:UIControlStateNormal];
    [self.buttonOne setTitle:btnTitle forState:UIControlStateNormal];
    float btnWidth = [UIView getLabelWidthByHeight:20 Title:btnTitle font:H13]+Adapted(20);
    if(btnWidth<LowOneBtnWidth){
        btnWidth = LowOneBtnWidth;
    }
    [self.buttonOne mas_updateConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(btnWidth);
    }];
}


//4 跳申诉页面，按钮：取消：提交，提交后返回
-(void)GotoComplaintHandle{
    //顶部VIew及文字
    [self.topView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(NarrowTopHeight);
    }];
    self.topTitle.text = @"";
    
    
    //底部文字
    self.bottomTitle.hidden = YES;
    
    //第二个按钮
    [self.buttonTwo setTitleColor:white_color forState:UIControlStateNormal];
    self.buttonTwo.backgroundColor = kLineColor;
    [self.buttonTwo setTitle:kLocalizedString(@"取消") forState:UIControlStateNormal];
    
    //第一个按钮
    NSString * btnTitle = kLocalizedString(@"提交");
    [self.buttonOne setTitleColor:white_color forState:UIControlStateNormal];
    [self.buttonOne setTitle:btnTitle forState:UIControlStateNormal];
    self.buttonOne.backgroundColor = kRedColor;
    //self.buttonOne.layer.borderColor = [UIColor clearColor].CGColor;
    float btnWidth = [UIView getLabelWidthByHeight:20 Title:btnTitle font:H13]+Adapted(20);
    if(btnWidth<LowOneBtnWidth){
        btnWidth = LowOneBtnWidth;
    }
    [self.buttonOne mas_updateConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(btnWidth);
    }];
}

//申诉成功-查看申诉记录
-(void)ComplaintRecordHandle{
    //顶部VIew及文字
    self.topView.hidden = NO;
    self.topTitle.textColor = k99999Color;
    self.topTitle.text = kLocalizedString(@"申诉中");
    [self.topView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(OriginalTopHeight);
    }];
    
    //底部文字
    self.bottomTitle.hidden = NO;
    self.bottomTitle.text = kLocalizedString(@"请耐心等待卖家放币...");
    self.bottomTitle.textColor = kBackAssistColor;
    
    //第二个按钮
    [self.buttonTwo setTitleColor:kBackAssistColor forState:UIControlStateNormal];
    [self.buttonTwo setTitle:kLocalizedString(@"取消交易") forState:UIControlStateNormal];
    
    
    //第一个按钮
    NSString * btnTitle = kLocalizedString(@"查看申诉记录");
    self.buttonOne.backgroundColor = red_color;
    [self.buttonOne setTitleColor:white_color forState:UIControlStateNormal];
    [self.buttonOne setTitle:btnTitle forState:UIControlStateNormal];
    float btnWidth = [UIView getLabelWidthByHeight:20 Title:btnTitle font:H13]+Adapted(20);
    if(btnWidth<LowOneBtnWidth){
        btnWidth = LowOneBtnWidth;
    }
    [self.buttonOne mas_updateConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(btnWidth);
    }];
}

//6 申诉驳回按钮变重新申诉
-(void)ComplaintRejectedHandle{
    
    //顶部VIew及文字
    self.topView.hidden = NO;
    self.topTitle.textColor = kRedColor;
    self.topTitle.text = kLocalizedString(@"申诉审核不通过，请重新申诉");
    [self.topView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(OriginalTopHeight);
    }];
    
    //底部文字
    self.bottomTitle.hidden = NO;
    self.bottomTitle.text = kLocalizedString(@"请耐心等待卖家放币...");
    self.bottomTitle.textColor = kBackAssistColor;
    
    //第二个按钮
    [self.buttonTwo setTitleColor:white_color forState:UIControlStateNormal];
    self.buttonTwo.backgroundColor = kLineColor;
    [self.buttonTwo setTitle:kLocalizedString(@"取消交易") forState:UIControlStateNormal];
    
    
    //第一个按钮
    NSString * btnTitle = kLocalizedString(@"重新申诉");
    self.buttonOne.backgroundColor = kRedColor;
    [self.buttonOne setTitleColor:white_color forState:UIControlStateNormal];
    [self.buttonOne setTitle:btnTitle forState:UIControlStateNormal];
    //self.buttonOne.layer.borderWidth = 1;
    //self.buttonOne.layer.borderColor = kRedColor.CGColor;
    float btnWidth = [UIView getLabelWidthByHeight:20 Title:btnTitle font:H13]+Adapted(20);
    if(btnWidth<LowOneBtnWidth){
        btnWidth = LowOneBtnWidth;
    }
    [self.buttonOne mas_updateConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(btnWidth);
    }];
}

// 7被对方申诉,按钮变发起回诉
-(void)BeComplaintHandle{
    
    //顶部VIew及文字
    self.topView.hidden = NO;
    self.topTitle.textColor = kRedColor;
    self.topTitle.text = kLocalizedString(@"您已被卖家申诉，可发起回诉");
    [self.topView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(OriginalTopHeight);
    }];
    
    //底部文字
    self.bottomTitle.hidden = NO;
    self.bottomTitle.text = kLocalizedString(@"请耐心等待卖家放币...");
    self.bottomTitle.textColor = kTextColor;
    
    //第二个按钮
    [self.buttonTwo setTitleColor:white_color forState:UIControlStateNormal];
    self.buttonTwo.backgroundColor = kLineColor;
    [self.buttonTwo setTitle:kLocalizedString(@"取消交易") forState:UIControlStateNormal];
    
    
    //第一个按钮
    NSString * btnTitle = kLocalizedString(@"发起回诉");
    self.buttonOne.backgroundColor = kRedColor;
    [self.buttonOne setTitleColor:white_color forState:UIControlStateNormal];
    [self.buttonOne setTitle:btnTitle forState:UIControlStateNormal];
    //self.buttonOne.layer.borderWidth = 1;
    //self.buttonOne.layer.borderColor = kRedColor.CGColor;
    float btnWidth = [UIView getLabelWidthByHeight:20 Title:btnTitle font:H13]+Adapted(20);
    if(btnWidth<LowOneBtnWidth){
        btnWidth = LowOneBtnWidth;
    }
    [self.buttonOne mas_updateConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(btnWidth);
    }];
}
//回诉被驳回，按钮变重新回诉
-(void)BeComplaintRejectedHandle{
    //顶部VIew及文字
    self.topView.hidden = NO;
    self.topTitle.textColor = kRedColor;
    self.topTitle.text = kLocalizedString(@"您的回诉被驳回，请重新发起回诉");
    [self.topView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(OriginalTopHeight);
    }];
    
    //底部文字
    self.bottomTitle.hidden = NO;
    self.bottomTitle.text = kLocalizedString(@"请耐心等待卖家放币...");
    self.bottomTitle.textColor = kBackAssistColor;
    
    //第二个按钮
    [self.buttonTwo setTitleColor:white_color forState:UIControlStateNormal];
    self.buttonTwo.backgroundColor = kLineColor;
    [self.buttonTwo setTitle:kLocalizedString(@"取消交易") forState:UIControlStateNormal];
    
    
    //第一个按钮
    NSString * btnTitle = kLocalizedString(@"重新回诉");
    self.buttonOne.backgroundColor = kRedColor;
    [self.buttonOne setTitleColor:white_color forState:UIControlStateNormal];
    [self.buttonOne setTitle:btnTitle forState:UIControlStateNormal];
    //self.buttonOne.layer.borderWidth = 1;
    //self.buttonOne.layer.borderColor = kRedColor.CGColor;
    float btnWidth = [UIView getLabelWidthByHeight:20 Title:btnTitle font:H13]+Adapted(20);
    if(btnWidth<LowOneBtnWidth){
        btnWidth = LowOneBtnWidth;
    }
    [self.buttonOne mas_updateConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(btnWidth);
    }];
}

//回诉成功，查看回诉记录
-(void)BeComplaintRecordHandle{
    
    //顶部VIew及文字
    [self.topView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(OriginalTopHeight);
    }];
    self.topTitle.text = kLocalizedString(@"回诉中");
    self.topTitle.textColor = kBackAssistColor;
    self.topView.hidden = NO;
    
    //底部文字
    self.bottomTitle.hidden = NO;
    self.bottomTitle.text = kLocalizedString(@"请耐心等待卖家放币...");
    self.bottomTitle.textColor = kBackAssistColor;
    
    //第二个按钮
    [self.buttonTwo setTitleColor:white_color forState:UIControlStateNormal];
    self.buttonTwo.backgroundColor = kLineColor;
    [self.buttonTwo setTitle:kLocalizedString(@"取消交易") forState:UIControlStateNormal];
    
    //第一个按钮
    NSString * btnTitle =kLocalizedString(@"查看回诉记录");
    self.buttonOne.backgroundColor = kMainColor;
    [self.buttonOne setTitleColor:white_color forState:UIControlStateNormal];
    [self.buttonOne setTitle:btnTitle forState:UIControlStateNormal];
    float btnWidth = [UIView getLabelWidthByHeight:20 Title:btnTitle font:H13]+Adapted(20);
    if(btnWidth<LowOneBtnWidth){
        btnWidth = LowOneBtnWidth;
    }
    [self.buttonOne mas_updateConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(btnWidth);
    }];
    
}


///////////////********************************************SELL

//等待对方打款
-(void)Sell_AlreadyPaymentHandle{
    
    //顶部VIew及文字
    self.topView.hidden = NO;
    self.topTitle.textColor = k99999Color;
    self.topTitle.text = @"";
    [self.topView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(NarrowTopHeight);
    }];
    
    //底部文字
    self.bottomTitle.hidden = NO;
    self.bottomTitle.text = kLocalizedString(@"请耐心等待买方打款...");
    self.bottomTitle.textColor = kBackAssistColor;
    
    //第二个按钮
    self.buttonTwo.hidden = YES;
    
    //第一个按钮
    self.buttonOne.hidden = YES;
    
    
}

//没到20分钟发起申诉,提醒弹框
-(void)Sell_BeforeTimeHandle{
    
    //顶部VIew及文字
    self.topView.hidden = NO;
    self.topTitle.textColor = k99999Color;
    self.topTitle.text = kLocalizedString(@"收款成功后，请点击“标记为已收款”按钮告知对方");
    [self.topView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(OriginalTopHeight);
    }];
    
    //底部文字
    self.bottomTitle.hidden = YES;
    self.bottomTitle.text = @"";
    self.bottomTitle.textColor = kTextColor;
    
    //第二个按钮
    NSString * btnTitle0 = kLocalizedString(@"发起申诉");
    float btnWidth0 = [UIView getLabelWidthByHeight:20 Title:btnTitle0 font:H13]+Adapted(20);
    if(btnWidth0<LowOneBtnWidth){
        btnWidth0 = LowOneBtnWidth;
    }
    self.buttonTwo.hidden = NO;
    [self.buttonTwo setTitleColor:white_color forState:UIControlStateNormal];
    self.buttonTwo.backgroundColor = kLineColor;
    [self.buttonTwo setTitle:btnTitle0 forState:UIControlStateNormal];
    [self.buttonTwo mas_updateConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(btnWidth0);
    }];
    
    //第一个按钮
    NSString * btnTitle = kLocalizedString(@"标记为已收款");
    self.buttonOne.hidden = NO;
    self.buttonOne.backgroundColor = kGreenColor;
    [self.buttonOne setTitleColor:white_color forState:UIControlStateNormal];
    [self.buttonOne setTitle:btnTitle forState:UIControlStateNormal];
    //self.buttonOne.layer.borderColor = [UIColor clearColor].CGColor;
    float btnWidth = [UIView getLabelWidthByHeight:20 Title:btnTitle font:H13]+Adapted(20);
    if(btnWidth<LowOneBtnWidth){
        btnWidth = LowOneBtnWidth;
    }
    [self.buttonOne mas_updateConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(btnWidth);
    }];
}

//卖家跳申诉界面 取消 提交
-(void)Sell_ComplaintHandle{
    
    //顶部VIew及文字
    [self.topView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(NarrowTopHeight);
    }];
    self.topTitle.text = @"";
    
    
    //底部文字
    self.bottomTitle.hidden = YES;
    
    //第二个按钮
    NSString * btnTitle0 = kLocalizedString(@"取消");
    float btnWidth0 = [UIView getLabelWidthByHeight:20 Title:btnTitle0 font:H13]+Adapted(20);
    if(btnWidth0<LowTwoBtnWidth){
        btnWidth0 = LowTwoBtnWidth;
    }
    self.buttonTwo.hidden = NO;
    [self.buttonTwo setTitleColor:white_color forState:UIControlStateNormal];
    self.buttonTwo.backgroundColor = kLineColor;
    [self.buttonTwo setTitle:btnTitle0 forState:UIControlStateNormal];
    self.buttonTwo.layer.borderColor = k99999Color.CGColor;
    [self.buttonTwo mas_updateConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(btnWidth0);
    }];

    
    //第一个按钮
    NSString * btnTitle = kLocalizedString(@"提交");
    self.buttonOne.hidden = NO;
    [self.buttonOne setTitleColor:white_color forState:UIControlStateNormal];
    [self.buttonOne setTitle:btnTitle forState:UIControlStateNormal];
    self.buttonOne.backgroundColor = kRedColor;
    //self.buttonOne.layer.borderColor = [UIColor clearColor].CGColor;
    float btnWidth = [UIView getLabelWidthByHeight:20 Title:btnTitle font:H13]+Adapted(20);
    if(btnWidth<LowOneBtnWidth){
        btnWidth = LowOneBtnWidth;
    }
    [self.buttonOne mas_updateConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(btnWidth);
    }];
    
    
}

//申诉完成 查看申诉记录
-(void)Sell_ComplaintRecordHandle{
    //顶部VIew及文字
    self.topView.hidden = NO;
    self.topTitle.textColor = k99999Color;
    self.topTitle.text = kLocalizedString(@"申诉中");
    [self.topView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(OriginalTopHeight);
    }];
    
    //底部文字
    self.bottomTitle.hidden = NO;
    self.bottomTitle.text = kLocalizedString(@"请耐心等待买方打款...");
    self.bottomTitle.textColor = kBackAssistColor;
    
    //第二个按钮
    NSString * btnTitle0 = kLocalizedString(@"查看申诉记录");
    float btnWidth0 = [UIView getLabelWidthByHeight:20 Title:btnTitle0 font:H13]+Adapted(20);
    if(btnWidth0<LowTwoBtnWidth){
        btnWidth0 = LowTwoBtnWidth;
    }
    self.buttonTwo.hidden = NO;
    [self.buttonTwo setTitleColor:white_color forState:UIControlStateNormal];
    self.buttonTwo.backgroundColor = kLineColor;
    [self.buttonTwo setTitle:btnTitle0 forState:UIControlStateNormal];
   // self.buttonTwo.layer.borderColor = k99999Color.CGColor;
    [self.buttonTwo mas_updateConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(btnWidth0);
    }];
    
    //第一个按钮
    NSString * btnTitle = kLocalizedString(@"标记为已收款");
    self.buttonOne.hidden = NO;
    self.buttonOne.backgroundColor = kGreenColor;
    [self.buttonOne setTitleColor:white_color forState:UIControlStateNormal];
    [self.buttonOne setTitle:btnTitle forState:UIControlStateNormal];
    //self.buttonOne.layer.borderColor = [UIColor clearColor].CGColor;
    float btnWidth = [UIView getLabelWidthByHeight:20 Title:btnTitle font:H13]+Adapted(20);
    if(btnWidth<LowOneBtnWidth){
        btnWidth = LowOneBtnWidth;
    }
    [self.buttonOne mas_updateConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(btnWidth);
    }];
    
}

//申诉驳回 重新申诉
-(void)Sell_ComplaintRejectedHandle{
    //顶部VIew及文字
    self.topView.hidden = NO;
    self.topTitle.textColor = kRedColor;
    self.topTitle.text = kLocalizedString(@"申诉审核不通过，请重新申诉");
    [self.topView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(OriginalTopHeight);
    }];
    
    //底部文字
    self.bottomTitle.hidden = NO;
    self.bottomTitle.text = kLocalizedString(@"请耐心等待买方打款...");
    self.bottomTitle.textColor = kBackAssistColor;
    
    //第二个按钮
    NSString * btnTitle0 = kLocalizedString(@"重新申诉");
    float btnWidth0 = [UIView getLabelWidthByHeight:20 Title:btnTitle0 font:H13]+Adapted(20);
    if(btnWidth0<LowTwoBtnWidth){
        btnWidth0 = LowTwoBtnWidth;
    }
    self.buttonTwo.hidden = NO;
    [self.buttonTwo setTitleColor:kRedColor forState:UIControlStateNormal];
    [self.buttonTwo setTitle:btnTitle0 forState:UIControlStateNormal];
    [self.buttonTwo mas_updateConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(btnWidth0);
    }];
    
    
    //第一个按钮
    NSString * btnTitle = kLocalizedString(@"标记为已收款");
    self.buttonOne.hidden = NO;
    self.buttonOne.backgroundColor = kGreenColor;
    [self.buttonOne setTitleColor:white_color forState:UIControlStateNormal];
    [self.buttonOne setTitle:btnTitle forState:UIControlStateNormal];
    //self.buttonOne.layer.borderColor = [UIColor clearColor].CGColor;
    float btnWidth = [UIView getLabelWidthByHeight:20 Title:btnTitle font:H13]+Adapted(20);
    if(btnWidth<LowOneBtnWidth){
        btnWidth = LowOneBtnWidth;
    }
    [self.buttonOne mas_updateConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(btnWidth);
    }];
}

//被申诉 发起回诉
-(void)Sell_BeComplaintHandle{
    
    //顶部VIew及文字
    self.topView.hidden = NO;
    self.topTitle.textColor = kRedColor;
    self.topTitle.text = kLocalizedString(@"您已被买家申诉，可发起回诉");
    [self.topView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(OriginalTopHeight);
    }];
    
    //底部文字
    self.bottomTitle.hidden = NO;
    self.bottomTitle.text = kLocalizedString(@"请耐心等待买家打款...");
    self.bottomTitle.textColor = kBackAssistColor;
    
    
    //第二个按钮
    NSString * btnTitle0 = kLocalizedString(@"发起回诉");
    float btnWidth0 = [UIView getLabelWidthByHeight:20 Title:btnTitle0 font:H13]+Adapted(20);
    if(btnWidth0<LowTwoBtnWidth){
        btnWidth0 = LowTwoBtnWidth;
    }
    self.buttonTwo.hidden = NO;
    [self.buttonTwo setTitleColor:kRedColor forState:UIControlStateNormal];
    [self.buttonTwo setTitle:btnTitle0 forState:UIControlStateNormal];
   // self.buttonTwo.layer.borderColor = kRedColor.CGColor;
    [self.buttonTwo mas_updateConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(btnWidth0);
    }];
    
    
    //第一个按钮
    NSString * btnTitle = kLocalizedString(@"标记为已收款");
    self.buttonOne.hidden = NO;
    self.buttonOne.backgroundColor = kGreenColor;
    [self.buttonOne setTitleColor:white_color forState:UIControlStateNormal];
    [self.buttonOne setTitle:btnTitle forState:UIControlStateNormal];
    //self.buttonOne.layer.borderColor = [UIColor clearColor].CGColor;
    float btnWidth = [UIView getLabelWidthByHeight:20 Title:btnTitle font:H13]+Adapted(20);
    if(btnWidth<LowOneBtnWidth){
        btnWidth = LowOneBtnWidth;
    }
    [self.buttonOne mas_updateConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(btnWidth);
    }];
}
//回诉被驳回 重新回诉
-(void)Sell_BeComplaintRejectedHandle{
    
    //顶部VIew及文字
    self.topView.hidden = NO;
    self.topTitle.textColor = kRedColor;
    self.topTitle.text = kLocalizedString(@"您的回诉被驳回，请重新发起回诉");
    [self.topView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(OriginalTopHeight);
    }];
    
    //底部文字
    self.bottomTitle.hidden = NO;
    self.bottomTitle.text = kLocalizedString(@"请耐心等待买家打款...");
    self.bottomTitle.textColor = kBackAssistColor;
    
    
    //第二个按钮
    NSString * btnTitle0 = kLocalizedString(@"重新回诉");
    float btnWidth0 = [UIView getLabelWidthByHeight:20 Title:btnTitle0 font:H13]+Adapted(20);
    if(btnWidth0<LowTwoBtnWidth){
        btnWidth0 = LowTwoBtnWidth;
    }
    self.buttonTwo.hidden = NO;
    [self.buttonTwo setTitleColor:kRedColor forState:UIControlStateNormal];
    [self.buttonTwo setTitle:btnTitle0 forState:UIControlStateNormal];
   // self.buttonTwo.layer.borderColor = kRedColor.CGColor;
    [self.buttonTwo mas_updateConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(btnWidth0);
    }];
    
    
    //第一个按钮
    NSString * btnTitle = kLocalizedString(@"标记为已收款");
    self.buttonOne.hidden = NO;
    self.buttonOne.backgroundColor = kGreenColor;
    [self.buttonOne setTitleColor:white_color forState:UIControlStateNormal];
    [self.buttonOne setTitle:btnTitle forState:UIControlStateNormal];
    //self.buttonOne.layer.borderColor = [UIColor clearColor].CGColor;
    float btnWidth = [UIView getLabelWidthByHeight:20 Title:btnTitle font:H13]+Adapted(20);
    if(btnWidth<LowOneBtnWidth){
        btnWidth = LowOneBtnWidth;
    }
    [self.buttonOne mas_updateConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(btnWidth);
    }];
    
}

//回诉成功 查看回诉记录
-(void)Sell_ResertComplaintRecordHandle{
    
    //顶部VIew及文字
    self.topView.hidden = NO;
    self.topTitle.textColor = kBackAssistColor;
    self.topTitle.text = kLocalizedString(@"回诉中");
    [self.topView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(OriginalTopHeight);
    }];
    
    //底部文字
    self.bottomTitle.hidden = NO;
    self.bottomTitle.text = kLocalizedString(@"请耐心等待买家打款...");
    self.bottomTitle.textColor = kBackAssistColor;
    
    
    //第二个按钮
    NSString * btnTitle0 = kLocalizedString(@"查看回诉记录");
    float btnWidth0 = [UIView getLabelWidthByHeight:20 Title:btnTitle0 font:H13]+Adapted(20);
    if(btnWidth0<LowTwoBtnWidth){
        btnWidth0 = LowTwoBtnWidth;
    }
    self.buttonTwo.hidden = NO;
    [self.buttonTwo setTitleColor:white_color forState:UIControlStateNormal];
    self.buttonTwo.backgroundColor = kLineColor;
    [self.buttonTwo setTitle:btnTitle0 forState:UIControlStateNormal];
    //self.buttonTwo.layer.borderColor = k99999Color.CGColor;
    [self.buttonTwo mas_updateConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(btnWidth0);
    }];
    
    
    //第一个按钮
    NSString * btnTitle = kLocalizedString(@"标记为已收款");
    self.buttonOne.hidden = NO;
    self.buttonOne.backgroundColor = kGreenColor;
    [self.buttonOne setTitleColor:white_color forState:UIControlStateNormal];
    [self.buttonOne setTitle:btnTitle forState:UIControlStateNormal];
    //self.buttonOne.layer.borderColor = [UIColor clearColor].CGColor;
    float btnWidth = [UIView getLabelWidthByHeight:20 Title:btnTitle font:H13]+Adapted(20);
    if(btnWidth<LowOneBtnWidth){
        btnWidth = LowOneBtnWidth;
    }
    [self.buttonOne mas_updateConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(btnWidth);
    }];
    
}
@end
