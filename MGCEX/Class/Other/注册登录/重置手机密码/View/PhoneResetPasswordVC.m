// MGC
//
// PhoneResetPasswordVC.m
// MGCEX
//
// Created by MGC on 2018/5/12.
// Copyright © 2018年 MGCion. All rights reserved.
//
// @ description <#描述#> 

#import "PhoneResetPasswordVC.h"
#import "RegisterIndexVM.h"
#import "ResetPasswordVM.h"
#import "ChangeCountryIndexVC.h"

@interface PhoneResetPasswordVC ()
@property (nonatomic, strong) UITextField * textPassword;
@property (nonatomic, strong) UITextField * ResetPassword;
@property (nonatomic, strong) UITextField * textName;
@property (nonatomic, strong) UIButton * registerBtn;
@property (nonatomic, strong) UITextField * textVerification;
@property (nonatomic, strong) UIButton * codeButton;
@property (nonatomic, strong) UIButton * nameLogoBtn;
@property (nonatomic, strong) UIView * lineView1;
@property (nonatomic, strong) UIView * lineView2;
@property (nonatomic, strong) UIView * lineView3;
@property (nonatomic, strong) UIView * lineView4;
@property (nonatomic, strong) RegisterIndexVM * viewModel;
@property (nonatomic, strong) ResetPasswordVM * resertViewModel;
@end

@implementation PhoneResetPasswordVC


-(void)dealloc{
    //防止倒计时没结束就返回，导致计时器不销毁
    if(self.codeButton.timer&&self.codeButton.timeOutNumber>0){
        //保存时间戳
//        NSDate * date = [NSDate date];
//        [[NSUserDefaults standardUserDefaults] setObject:@(self.codeButton.timeOutNumber) forKey:ResertPhoneRegisterCountdown];
//        [[NSUserDefaults standardUserDefaults] setObject:date forKey:ResertPhoneRegisterCountdownTime];
//        [[NSUserDefaults standardUserDefaults] synchronize];
        //销毁定时器
        dispatch_source_cancel(self.codeButton.timer);
        self.codeButton.timer = nil;
    }
    
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = kLocalizedString(self.navTitle);
    
    self.view.backgroundColor = white_color;
    
    for(int i=0;i<4;i++){
        UIView * lineView = [[UIView alloc]initWithFrame:CGRectMake(Adapted(30), Adapted(93)+i*Adapted(70), MAIN_SCREEN_WIDTH-Adapted(60), 1)];
        lineView.backgroundColor = kLineColor;
        [self.view addSubview:lineView];
        lineView.tag = 100+i;
    }
    self.lineView1 = [self.view viewWithTag:100];
    self.lineView2 = [self.view viewWithTag:101];
    self.lineView3 = [self.view viewWithTag:102];
    self.lineView4 = [self.view viewWithTag:103];
    
    //账号log
    UIButton * nameLogoBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.view addSubview:nameLogoBtn];
    [nameLogoBtn mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.bottom.mas_equalTo(self.lineView1.mas_top).offset(Adapted(-5));
        make.left.mas_equalTo(self.lineView1.mas_left);
        make.width.mas_offset(Adapted(43));
    }];
    self.nameLogoBtn = nameLogoBtn;
    [nameLogoBtn setTitleColor:black_color forState:UIControlStateNormal];
    [nameLogoBtn setTitle:@" +86" forState:UIControlStateNormal];
    [nameLogoBtn setTitle:@" +86" forState:UIControlStateSelected];
    nameLogoBtn.titleLabel.font = H15;
    [nameLogoBtn sizeToFit];
    [nameLogoBtn mg_setEnlargeEdgeWithTop:Adapted(30) right:Adapted(20) bottom:Adapted(20) left:Adapted(20)];
    [nameLogoBtn addTarget:self action:@selector(changeCountClick) forControlEvents:UIControlEventTouchUpInside];
    
    //下箭头
    UIImageView * arrowImageV = [[UIImageView alloc]init];
    [self.view addSubview:arrowImageV];
    arrowImageV.image = IMAGE(@"spread");
    [arrowImageV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(nameLogoBtn.mas_right).offset(Adapted(5));
        make.height.mas_equalTo(Adapted(6));
        make.width.mas_equalTo(Adapted(10));
        make.centerY.mas_equalTo(nameLogoBtn);
    }];
    
    //手机号,邮箱
    UITextField * textName = [[UITextField alloc]init];
    [self.view addSubview:textName];
    [textName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(arrowImageV.mas_right).offset(Adapted(10));
        make.centerY.mas_equalTo(nameLogoBtn);
        make.right.mas_equalTo(self.view.mas_right).offset(Adapted(-30));
        
    }];
    textName.font = H15;
    textName.textColor = black_color;
    textName.placeholder = kLocalizedString(@"手机号码");
    textName.tintColor = black_color;
    textName.keyboardType = UIKeyboardTypeNumberPad;
    [textName setValue:kAssistColor forKeyPath:@"_placeholderLabel.textColor"];
    [textName setValue:H18 forKeyPath:@"_placeholderLabel.font"];
    self.textName = textName;
    
    @weakify(self);
    textName.didChangeBlock = ^(NSString *text) {
        @strongify(self);
        [self changeRegisStatus];
        self.codeButton.enabled = text.length;
        
        if (kStringIsEmpty(text)) {
            self.lineView1.backgroundColor = kLineColor;
        } else{
            self.lineView1.backgroundColor = kMainColor;
        }
    };
    
    //验证码UITextField
    UITextField * textVerification = [[UITextField alloc]init];
    [self.view addSubview:textVerification];
    [textVerification mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(nameLogoBtn);
        make.top.mas_equalTo(self.lineView1.mas_bottom).offset(Adapted(38));
        make.width.mas_equalTo(Adapted(188));
    }];
    textVerification.font = H18;
    textVerification.textColor = black_color;
    textVerification.placeholder = kLocalizedString(@"验证码");
    textVerification.tintColor = black_color;
    [textVerification setValue:kAssistColor forKeyPath:@"_placeholderLabel.textColor"];
    [textVerification setValue:H18 forKeyPath:@"_placeholderLabel.font"];
    self.textVerification = textVerification;
    self.textVerification.keyboardType = UIKeyboardTypeNumberPad;
    self.textVerification.limitTextLength = KVerificationNumber;
    textVerification.didChangeBlock = ^(NSString *text) {
        @strongify(self);
        [self changeRegisStatus];
        
        if (kStringIsEmpty(text)) {
            self.lineView2.backgroundColor = kLineColor;
        } else{
            self.lineView2.backgroundColor = kMainColor;
        }
    };
    
    //验证码竖线
    UIView * shuxian = [[UIView alloc]init];
    [self.view addSubview:shuxian];
    shuxian.backgroundColor = UIColorFromRGB(0xB5B5B5);
    [shuxian mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(textVerification);
        make.width.mas_equalTo(1);
        make.height.mas_equalTo(20);
        make.left.mas_equalTo(textVerification.mas_right);
    }];

    //验证码按钮
    UIButton * codeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.view addSubview:codeButton];
    codeButton.enabled = NO;
    codeButton.selected = NO;
    [codeButton setTitle:kLocalizedString(@"获取验证码") forState:UIControlStateNormal];
    [codeButton setTitleColor:kLineColor forState:UIControlStateDisabled];
    [codeButton setTitleColor:kMainColor forState:UIControlStateNormal];
    codeButton.titleLabel.font = H16;
    [codeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(shuxian.mas_right).offset(Adapted(5));
        make.centerY.mas_equalTo(textVerification);
        make.right.mas_equalTo(self.view.mas_right).offset(Adapted(-30));
        make.height.mas_equalTo(Adapted(40));
    }];
    [codeButton addTarget:self action:@selector(getVerificationCode:) forControlEvents:UIControlEventTouchUpInside];
    codeButton.enabled = NO;
    self.codeButton = codeButton;
//    [TWAppTool startTheCountdownWithPhoneCountdown:ResertPhoneRegisterCountdown Time:ResertPhoneRegisterCountdownTime btn:codeButton];
    
    //密码
    UITextField * textPassword = [[UITextField alloc]init];
    [self.view addSubview:textPassword];
    [textPassword mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(nameLogoBtn);
        make.top.mas_equalTo(self.lineView2.mas_bottom).offset(Adapted(38));
        make.width.mas_equalTo(Adapted(300));
    }];
    textPassword.font = H18;
    textPassword.textColor = black_color;
    textPassword.placeholder = kLocalizedString(@"重置密码");
    textPassword.secureTextEntry = YES;
    textPassword.tintColor = black_color;
    [textPassword setValue:kAssistColor forKeyPath:@"_placeholderLabel.textColor"];
    [textPassword setValue:H18 forKeyPath:@"_placeholderLabel.font"];
    self.textPassword = textPassword;
    textPassword.didChangeBlock = ^(NSString *text) {
        @strongify(self);
        [self changeRegisStatus];
        
        if (kStringIsEmpty(text)) {
            self.lineView3.backgroundColor = kLineColor;
        } else{
            self.lineView3.backgroundColor = kMainColor;
        }
    };
    
    //密码眼睛
    UIButton * seeButton = [[UIButton alloc]init];
    [self.view addSubview:seeButton];
    [seeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.lineView3.mas_right).mas_offset(Adapted(9));
        make.width.height.mas_equalTo(Adapted(40));
        make.centerY.mas_equalTo(textPassword);
    }];
    [seeButton addTarget:self action:@selector(showOrHiddenPassword:) forControlEvents:UIControlEventTouchUpInside];
    [seeButton setImage:[UIImage imageNamed:@"yinchang"] forState:UIControlStateNormal];
    [seeButton setImage:[UIImage imageNamed:@"xianshi"] forState:UIControlStateSelected];
    
    //重置密码
    UITextField * ResetPassword = [[UITextField alloc]init];
    [self.view addSubview:ResetPassword];
    [ResetPassword mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(nameLogoBtn);
        make.top.mas_equalTo(self.lineView3.mas_bottom).offset(Adapted(35));
        make.width.mas_equalTo(Adapted(300));
    }];
    ResetPassword.font = H18;
    ResetPassword.textColor = black_color;
    ResetPassword.placeholder = kLocalizedString(@"再次确认密码");
    ResetPassword.secureTextEntry = YES;
    ResetPassword.tintColor = black_color;
    [ResetPassword setValue:kAssistColor forKeyPath:@"_placeholderLabel.textColor"];
    [ResetPassword setValue:H18 forKeyPath:@"_placeholderLabel.font"];
    self.ResetPassword = ResetPassword;
    ResetPassword.didChangeBlock = ^(NSString *text) {
        @strongify(self);
        [self changeRegisStatus];
        
        if (kStringIsEmpty(text)) {
            self.lineView4.backgroundColor = kLineColor;
        } else{
            self.lineView4.backgroundColor = kMainColor;
        }
    };
    
    
    //重置密码眼睛
    UIButton * resetSeeButton = [[UIButton alloc]init];
    [self.view addSubview:resetSeeButton];
    [resetSeeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.lineView4.mas_right).mas_offset(Adapted(9));
        make.width.height.mas_equalTo(Adapted(40));
        make.centerY.mas_equalTo(ResetPassword);
    }];
    [resetSeeButton addTarget:self action:@selector(showOrHiddenResetPassword:) forControlEvents:UIControlEventTouchUpInside];
    [resetSeeButton setImage:[UIImage imageNamed:@"yinchang"] forState:UIControlStateNormal];
    [resetSeeButton setImage:[UIImage imageNamed:@"xianshi"] forState:UIControlStateSelected];
    
    
    //注册按钮
    UIButton * registerBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.view addSubview:registerBtn];
    [registerBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.view);
        make.top.mas_equalTo(self.lineView4.mas_bottom).offset(Adapted(40));
        make.left.mas_equalTo(self.lineView1.mas_left);
        make.right.mas_equalTo(self.lineView1.mas_right);
        make.height.mas_equalTo(Adapted(50));
    }];
    [registerBtn setTitle:kLocalizedString(@"提交") forState:UIControlStateNormal];
    [registerBtn setTitleColor:white_color forState:UIControlStateNormal];
    registerBtn.enabled = NO;
    [registerBtn setStatusWithEnableColor:kMainColor disableColor:k99999Color];
    [registerBtn addTarget:self action:@selector(submitClick) forControlEvents:UIControlEventTouchUpInside];
    self.registerBtn = registerBtn;
    
    //使用邮箱重置密码
    UIButton * mailBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.view addSubview:mailBtn];
    [mailBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(registerBtn.mas_right);
        make.top.mas_equalTo(registerBtn.mas_bottom).offset(Adapted(15));
        make.height.mas_equalTo(Adapted(35));
    }];
    mailBtn.titleLabel.font = H15;
    mailBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    [mailBtn setTitleColor:kRedColor forState:UIControlStateNormal];
    [mailBtn setTitle:kLocalizedString(@"使用邮箱重置密码") forState:UIControlStateNormal];
    [mailBtn addTarget:self action:@selector(userMailResetClick) forControlEvents:UIControlEventTouchUpInside];
}



#pragma mark--按钮响应
//切换国家地区
-(void)changeCountClick{
    
    // 创建第二个控制器
    ChangeCountryIndexVC *vc = [[ChangeCountryIndexVC alloc] init];
    // 设置代理信号
    vc.delegateSignal = [RACSubject subject];
    // 订阅代理信号
    @weakify(self);
    [vc.forgetPwdSignal subscribeNext:^(NSString * x) {
        //代替代理，如果twoVc做了某件事，这里就知道
        
        @strongify(self);
        self.viewModel.regFromCode = x;
        [self.nameLogoBtn setTitle:x forState:UIControlStateNormal];
    }];
    // 跳转到第二个控制器
    [self.navigationController pushViewController:vc animated:YES];
}
//改变注册按钮状态
-(void)changeRegisStatus{
    if(self.textVerification.text.length>0&&self.textPassword.text.length>0&&self.textName.text.length>0&&self.ResetPassword.text.length>0){
        
        self.registerBtn.enabled = YES;
    }else{
        self.registerBtn.enabled = NO;
    }
}

//获取验证码
-(void)getVerificationCode:(UIButton *)btn{
    [self.view endEditing:YES];
    if(![PredicateTool validatePhoneNumber:self.textName.text]){
        [TTWHUD showCustomMsg:kLocalizedString(@"手机号码格式错误")];
        return;
    }
    
    self.viewModel.loginNum = self.textName.text;
    self.viewModel.registerType = 1;
    
    
    //订阅信号
    @weakify(self);
    [self.viewModel.sendPhoneCodeSignal subscribeNext:^(id x) {
        
        @strongify(self);
   
        [TTWHUD showCustomIcon:@"gou" title:kLocalizedString(@"已发送") toView:self.view];
        [self.codeButton mg_startCountDownTime:Countdown finishTitle:kLocalizedString(@"重新获取验证码") waitTittle:@"S" finishColor:nil waitColor:nil Finish:^(UIButton *button) {
   
        }];
        
        
    }];
    
    
}

//邮箱重置密码
-(void)userMailResetClick{
    [self pushViewControllerWithName:@"MailResetPasswordVC"];
}


//提交
-(void)submitClick{
    if(![PredicateTool validatePhoneNumber:self.textName.text]){
        [TTWHUD showCustomMsg:kLocalizedString(@"手机号码格式错误")];
        return;
    }else if(_textPassword.text.length<6){
        [TTWHUD showCustomMsg:kLocalizedString(@"您的密码不能少于6位")];
        return;
    }else if(![self.textPassword.text isEqualToString:self.ResetPassword.text]){
        [TTWHUD showCustomMsg:kLocalizedString(@"重置的密码不一致，请重新输入")];
        return;
    }
    if ([self.textPassword.text rangeOfString:@" "].location != NSNotFound) {
        [TTWHUD showCustomMsg:kLocalizedString(@"密码不能包含空格")];
        return;
    }
    self.resertViewModel.loginNum = self.textName.text;
    self.resertViewModel.password = self.textPassword.text;
    self.resertViewModel.code = self.textVerification.text;
    
    //订阅信号
    @weakify(self);
    [self.resertViewModel.resetCodeSignal subscribeNext:^(id x) {
        
        @strongify(self);

        [TTWHUD showCustomMsg:kLocalizedString(@"重置成功")];
        [self popToViewControllerWithClass:@"LoginIndexVC"];
       
        
    }];
}

//显示隐藏密码
-(void)showOrHiddenResetPassword:(UIButton *)btn{
    btn.selected = !btn.selected;
    self.ResetPassword.secureTextEntry = !self.ResetPassword.secureTextEntry;
}

//显示隐藏密码
-(void)showOrHiddenPassword:(UIButton *)btn{
    btn.selected = !btn.selected;
    self.textPassword.secureTextEntry = !self.textPassword.secureTextEntry;
}

-(RegisterIndexVM *)viewModel{
    if(!_viewModel){
        _viewModel = [[RegisterIndexVM alloc]init];
        
    }
    return _viewModel;
}

-(ResetPasswordVM *)resertViewModel{
    if(!_resertViewModel){
        _resertViewModel = [[ResetPasswordVM alloc]init];
        
    }
    return _resertViewModel;
}
@end
