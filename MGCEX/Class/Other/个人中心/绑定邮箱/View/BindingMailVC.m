// MGC
//
// BindingMailVC.m
// MGCEX
//
// Created by MGC on 2018/5/15.
// Copyright © 2018年 MGCion. All rights reserved.
//
// @ description <#描述#> 

#import "BindingMailVC.h"
#import "BindingIdentityVM.h"
#import "RegisterIndexVM.h"

@interface BindingMailVC ()
@property (nonatomic, strong) UIButton * codeButton;
@property (nonatomic, strong) UITextField * textVerification;
@property (nonatomic, strong) UITextField * mailNumber;
@property (nonatomic, strong) UIButton * registerBtn;
@property (nonatomic, strong) BindingIdentityVM * viewModel;
@property (nonatomic, strong) RegisterIndexVM * yanzhengView;
@end

@implementation BindingMailVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = kLocalizedString(@"邮箱认证");
   
    UIView * backView = [[UIView alloc]init];
    [self.view addSubview:backView];
    backView.backgroundColor = white_color;
    [backView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(Adapted(10));
        make.left.right.mas_equalTo(self.view);
        make.height.mas_equalTo(Adapted(113));
    }];
    
    UIView * lineView = [[UIView alloc]init];
    [backView addSubview:lineView];
    lineView.backgroundColor = kLineColor;
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(Adapted(15));
        make.right.mas_equalTo(Adapted(-15));
        make.centerY.mas_equalTo(backView);
        make.height.mas_equalTo(1);
    }];
    
    
    //手机号
    UITextField * mailNumber = [[UITextField alloc]init];
    [backView addSubview:mailNumber];
    mailNumber.font = H16;
    mailNumber.textColor = kTextColor;
    mailNumber.placeholder = kLocalizedString(@"邮箱");
    mailNumber.placeholderColor = kLineColor;
    mailNumber.tintColor = kTextColor;
    [mailNumber mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(Adapted(15));
        make.bottom.mas_equalTo(backView.mas_centerY).offset(Adapted(-15));
        make.right.mas_equalTo(backView.mas_right).offset(Adapted(-15));
    }];
    self.mailNumber = mailNumber;
    @weakify(self);
    mailNumber.didChangeBlock = ^(NSString *text) {
        @strongify(self);
        [self changeRegisStatus];
        self.codeButton.selected = text.length;
        self.codeButton.enabled = text.length;
        [self.codeButton setTitleColor:kLineColor forState:UIControlStateNormal];
        [self.codeButton setTitleColor:kRedColor forState:UIControlStateSelected];
    };
    
    //验证码UITextField
    UITextField * textVerification = [[UITextField alloc]init];
    [backView addSubview:textVerification];
    [textVerification mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(Adapted(15));
        make.bottom.mas_equalTo(Adapted(-15));
        make.width.mas_equalTo(Adapted(220));
        
    }];
    textVerification.font = H16;
    textVerification.textColor = kTextColor;
    textVerification.placeholder = kLocalizedString(@"验证码");
    textVerification.placeholderColor = kLineColor;
    textVerification.tintColor = kTextColor;
    self.textVerification = textVerification;
    self.textVerification.keyboardType = UIKeyboardTypeNumberPad;
    self.textVerification.limitTextLength = KVerificationNumber;
    textVerification.didChangeBlock = ^(NSString *text) {
        @strongify(self);
        [self changeRegisStatus];
        
    };
    
    //验证码竖线
    UIView * shuxian = [[UIView alloc]init];
    [backView addSubview:shuxian];
    shuxian.backgroundColor = kLineColor;
    [shuxian mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(textVerification);
        make.width.mas_equalTo(1);
        make.height.mas_equalTo(20);
        make.left.mas_equalTo(textVerification.mas_right);
    }];
    
    //验证码按钮
    UIButton * codeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [backView addSubview:codeButton];
    codeButton.enabled = NO;
    codeButton.selected = NO;
    [codeButton setTitle:kLocalizedString(@"获取验证码") forState:UIControlStateNormal];
    [codeButton setTitleColor:kLineColor forState:UIControlStateNormal];
    codeButton.titleLabel.font = H16;
    [codeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(shuxian.mas_right).offset(Adapted(5));
        make.centerY.mas_equalTo(textVerification);
        make.right.mas_equalTo(self.view.mas_right).offset(Adapted(-15));
        make.height.mas_equalTo(Adapted(40));
        
    }];
    [codeButton addTarget:self action:@selector(getVerificationCode:) forControlEvents:UIControlEventTouchUpInside];
    self.codeButton = codeButton;
    [TWAppTool startTheCountdownWithPhoneCountdown:BingingMailNumberdown Time:BingingMailNumberdownTime btn:codeButton];
    
    //注册按钮
    UIButton * registerBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.view addSubview:registerBtn];
    [registerBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.view);
        make.top.mas_equalTo(backView.mas_bottom).offset(Adapted(40));
        make.width.mas_equalTo(MAIN_SCREEN_WIDTH-Adapted(30));
        make.height.mas_equalTo(Adapted(40));
    }];
    registerBtn.layer.cornerRadius = Adapted(2.0);
    registerBtn.clipsToBounds = YES;
    [registerBtn setTitle:kLocalizedString(@"绑定") forState:UIControlStateNormal];
    [registerBtn setTitleColor:white_color forState:UIControlStateNormal];
    registerBtn.enabled = NO;
    [registerBtn setStatusWithEnableColor:kRedColor disableColor:kDisableRedColor];
    [registerBtn addTarget:self action:@selector(registerClick) forControlEvents:UIControlEventTouchUpInside];
    self.registerBtn = registerBtn;
    
}

-(void)dealloc{
    //防止倒计时没结束就返回，导致计时器不销毁
    if(self.codeButton.timer&&self.codeButton.timeOutNumber>0){
        //保存时间戳
        NSDate * date = [NSDate date];
        [[NSUserDefaults standardUserDefaults] setObject:@(self.codeButton.timeOutNumber) forKey:BingingMailNumberdown];
        [[NSUserDefaults standardUserDefaults] setObject:date forKey:BingingMailNumberdownTime];
        [[NSUserDefaults standardUserDefaults] synchronize];
        //销毁定时器
        dispatch_source_cancel(self.codeButton.timer);
        self.codeButton.timer = nil;
    }
    
    
}


//获取验证码
-(void)getVerificationCode:(UIButton *)btn{
    
    [self.view endEditing:YES];
    if(![PredicateTool validateEmail:self.mailNumber.text]){
        [TTWHUD showCustomMsg:kLocalizedString(@"邮箱格式错误")];
        return;
    }
    
    self.yanzhengView.loginNum = self.mailNumber.text;
    self.yanzhengView.registerType = 2;
    //订阅信号
    @weakify(self);
    [self.yanzhengView.sendPhoneCodeSignal subscribeNext:^(id x) {
        
        @strongify(self);
        [TTWHUD showCustomIcon:@"gou" title:kLocalizedString(@"已发送") toView:self.view];
        [btn mg_startCountDownTime:Countdown finishTitle:kLocalizedString(@"重新获取验证码") waitTittle:@"S" finishColor:nil waitColor:nil Finish:^(UIButton *button) {
            
        }];
        
    }];
   
}


//改变注册按钮状态
-(void)changeRegisStatus{
    if(self.textVerification.text.length>0&&self.mailNumber.text.length>0){
        self.registerBtn.enabled = YES;
    }else{
        self.registerBtn.enabled = NO;
    }
}

//绑定
-(void)registerClick{
    
    if(![PredicateTool validateEmail:self.mailNumber.text]){
        [TTWHUD showCustomMsg:kLocalizedString(@"邮箱格式错误")];
        return;
    }
    self.viewModel.loginNum = self.mailNumber.text;
    self.viewModel.code = self.textVerification.text;
    //订阅信号
    @weakify(self);
    [self.viewModel.bindingSignal subscribeNext:^(id x) {
        @strongify(self);
        [TTWHUD showCustomMsg:kLocalizedString(@"绑定成功")];
        [self.navigationController popViewControllerAnimated:YES];
    }];
    
  
}


-(BindingIdentityVM *)viewModel{
    if(!_viewModel){
        _viewModel = [BindingIdentityVM new];
    }
    return _viewModel;
}

-(RegisterIndexVM *)yanzhengView{
    if(!_yanzhengView){
        _yanzhengView = [[RegisterIndexVM alloc]init];
    }
    return _yanzhengView;
}

@end
