// MGC
//
// RegisterIndexVC.m
// MGCEX
//
// Created by MGC on 2018/5/10.
// Copyright © 2018年 MGCion. All rights reserved.
//
// @ description <#描述#> 

#import "RegisterIndexVC.h"
#import "RegisterIndexVM.h"
#import "ChangeCountryIndexVC.h"
#import "UserAgreementVC.h"

@interface RegisterIndexVC ()
@property (nonatomic, strong) UITextField * textPassword;
@property (nonatomic, strong) UITextField * textName;
@property (nonatomic, strong) UIButton * registerBtn;
@property (nonatomic, strong) UITextField * textVerification;
@property (nonatomic, strong) UIButton * codeButton;
@property (nonatomic, strong) UIButton * nameLogoBtn;
@property (nonatomic, strong) RegisterIndexVM * viewModel;
@property (nonatomic, copy) NSString * regFromCode;
@end

@implementation RegisterIndexVC

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.view.backgroundColor = white_color;
    self.navigationController.navigationBar.barTintColor = white_color;
    
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    if([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.navigationController.interactivePopGestureRecognizer.enabled = NO;
    }
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    if([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.navigationController.interactivePopGestureRecognizer.enabled = YES;
    }
}


-(void)dealloc{
    //防止倒计时没结束就返回，导致计时器不销毁
    if(self.codeButton.timer&&self.codeButton.timeOutNumber>0){
        //保存时间戳
        NSDate * date = [NSDate date];
        [[NSUserDefaults standardUserDefaults] setObject:@(self.codeButton.timeOutNumber) forKey:PhoneRegisterCountdown];
        [[NSUserDefaults standardUserDefaults] setObject:date forKey:PhoneRegisterCountdownTime];
        [[NSUserDefaults standardUserDefaults] synchronize];
        //销毁定时器
        dispatch_source_cancel(self.codeButton.timer);
        self.codeButton.timer = nil;
    }
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.regFromCode = @"86";
    
    UIImageView * logImageV = [[UIImageView alloc]init];
    [self.view addSubview:logImageV];
    logImageV.image = IMAGE(@"logo");
    [logImageV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.view);
        make.top.mas_offset(Adapted(5));
    }];
    [self.view layoutIfNeeded];
    
    UILabel *lab = [[UILabel alloc] init];
    [self.view addSubview:lab];
    [lab mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.mas_offset(Adapted(32));
        make.top.mas_equalTo(logImageV.mas_bottom).offset(Adapted(17));
    }];
    lab.font = HB17;
    lab.textColor = UIColorFromRGB(0x454545);
    lab.text = kLocalizedString(@"注册");
    
    //账号log
    UIButton * nameLogoBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.view addSubview:nameLogoBtn];
    self.nameLogoBtn = nameLogoBtn;
    [nameLogoBtn mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.left.mas_offset(Adapted(30));
        make.top.mas_equalTo(lab.mas_bottom).offset(Adapted(39));
    }];
    [nameLogoBtn setTitleColor:kTextColor forState:UIControlStateNormal];
    [nameLogoBtn setTitle:@" +86" forState:UIControlStateNormal];
    [nameLogoBtn setTitle:@" +86" forState:UIControlStateSelected];
    nameLogoBtn.titleLabel.font = H18;
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
    textName.font = H18;
    textName.textColor = kTextColor;
    textName.placeholder = kLocalizedString(@"手机号码");
    textName.tintColor = kTextColor;
    textName.keyboardType = UIKeyboardTypeNumberPad;
    [textName setValue:kLineColor forKeyPath:@"_placeholderLabel.textColor"];
    [textName setValue:H18 forKeyPath:@"_placeholderLabel.font"];
    self.textName = textName;
    
    //下划线
    UIView * nameLine = [[UIView alloc]init];
    [self.view addSubview:nameLine];
    nameLine.backgroundColor = kLineColor;
    [nameLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.view);
        make.width.mas_equalTo(MAIN_SCREEN_WIDTH-Adapted(60));
        make.height.mas_equalTo(1);
        make.top.mas_equalTo(textName.mas_bottom).mas_offset(Adapted(10));
    }];
    
    @weakify(self);
    textName.didChangeBlock = ^(NSString *text) {
        @strongify(self);
        
        [self changeRegisStatus];
        self.codeButton.enabled = text.length;
        if (kStringIsEmpty(text)) {
            nameLine.backgroundColor = kLineColor;
        }else{
            nameLine.backgroundColor = kMainColor;
        }
    };
    
    //验证码UITextField
    UITextField * textVerification = [[UITextField alloc]init];
    [self.view addSubview:textVerification];
    [textVerification mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(nameLogoBtn);
        make.top.mas_equalTo(nameLine.mas_bottom).offset(Adapted(42));
        make.width.mas_equalTo(Adapted(188));
    }];
    textVerification.font = H15;
    textVerification.textColor = kTextColor;
    textVerification.placeholder = kLocalizedString(@"验证码");
    textVerification.tintColor = kTextColor;
    [textVerification setValue:kLineColor forKeyPath:@"_placeholderLabel.textColor"];
    [textVerification setValue:H18 forKeyPath:@"_placeholderLabel.font"];
    self.textVerification = textVerification;
    self.textVerification.keyboardType = UIKeyboardTypeNumberPad;
    self.textVerification.limitTextLength = KVerificationNumber;
    
    //验证码竖线
    UIView * shuxian = [[UIView alloc]init];
    [self.view addSubview:shuxian];
    shuxian.backgroundColor = kLineColor;
    [shuxian mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(textVerification);
        make.width.mas_equalTo(1);
        make.height.mas_equalTo(20);
        make.left.mas_equalTo(textVerification.mas_right);
    }];
    
    //验证码下划线
    UIView * textVerificationLine = [[UIView alloc]init];
    [self.view addSubview:textVerificationLine];
    textVerificationLine.backgroundColor = kLineColor;
    [textVerificationLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.view);
        make.width.mas_equalTo(MAIN_SCREEN_WIDTH-Adapted(60));
        make.height.mas_equalTo(1);
        make.top.mas_equalTo(textVerification.mas_bottom).mas_offset(Adapted(10));
    }];
    textVerification.didChangeBlock = ^(NSString *text) {
        @strongify(self);
        [self changeRegisStatus];
        
        if (kStringIsEmpty(text)) {
            textVerificationLine.backgroundColor = kLineColor;
        }else{
            textVerificationLine.backgroundColor = kMainColor;
        }
    };
    
    //验证码按钮
    UIButton * codeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.view addSubview:codeButton];
    codeButton.enabled = NO;
    codeButton.selected = NO;
    [codeButton setTitle:kLocalizedString(@"获取验证码") forState:UIControlStateNormal];
    [codeButton setTitleColor:kLineColor forState:UIControlStateDisabled];
    [codeButton setTitleColor:kMainColor forState:UIControlStateNormal];
    codeButton.enabled = NO;
    codeButton.titleLabel.font = H16;
    [codeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(shuxian.mas_right).offset(Adapted(5));
        make.centerY.mas_equalTo(textVerification);
        make.right.mas_equalTo(self.view.mas_right).offset(Adapted(-30));
        make.height.mas_equalTo(Adapted(40));
        
    }];
    [codeButton addTarget:self action:@selector(getVerificationCode:) forControlEvents:UIControlEventTouchUpInside];
    self.codeButton = codeButton;
    [TWAppTool startTheCountdownWithPhoneCountdown:PhoneRegisterCountdown Time:PhoneRegisterCountdownTime btn:codeButton];

    //密码
    UITextField * textPassword = [[UITextField alloc]init];
    [self.view addSubview:textPassword];
    [textPassword mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(nameLogoBtn);
        make.top.mas_equalTo(textVerificationLine.mas_bottom).offset(Adapted(42));
        make.width.mas_equalTo(Adapted(320));
    }];
    textPassword.font = H15;
    textPassword.textColor = kTextColor;
    textPassword.placeholder = kLocalizedString(@"密码");
    textPassword.secureTextEntry = YES;
    textPassword.tintColor = kTextColor;
    textPassword.placeholderColor = kLineColor;
    [textPassword setValue:H18 forKeyPath:@"_placeholderLabel.font"];
    self.textPassword = textPassword;
    
    //下划线
    UIView * passwordLine = [[UIView alloc]init];
    [self.view addSubview:passwordLine];
    passwordLine.backgroundColor = kLineColor;
    [passwordLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.view);
        make.width.mas_equalTo(MAIN_SCREEN_WIDTH-Adapted(60));
        make.height.mas_equalTo(1);
        make.top.mas_equalTo(textPassword.mas_bottom).mas_offset(Adapted(10));
    }];
    textPassword.didChangeBlock = ^(NSString *text) {
        @strongify(self);
        [self changeRegisStatus];
        
        if (kStringIsEmpty(text)) {
            passwordLine.backgroundColor = kLineColor;
        }else{
            passwordLine.backgroundColor = kMainColor;
        }
    };
    
    //密码眼睛
    UIButton * seeButton = [[UIButton alloc]init];
    [self.view addSubview:seeButton];
    [seeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(passwordLine.mas_right).mas_offset(Adapted(9));
        make.width.height.mas_equalTo(Adapted(40));
        make.centerY.mas_equalTo(textPassword);
    }];
    [seeButton addTarget:self action:@selector(showOrHiddenPassword:) forControlEvents:UIControlEventTouchUpInside];
    [seeButton setImage:[UIImage imageNamed:@"yinchang"] forState:UIControlStateNormal];
    [seeButton setImage:[UIImage imageNamed:@"xianshi"] forState:UIControlStateSelected];
    
    //注册按钮
    UIButton * registerBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.view addSubview:registerBtn];
    [registerBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.view);
        make.top.mas_equalTo(passwordLine.mas_bottom).offset(Adapted(40));
        make.left.mas_equalTo(passwordLine.mas_left);
        make.right.mas_equalTo(passwordLine.mas_right);
        make.height.mas_equalTo(Adapted(50));
    }];
    [registerBtn setTitle:kLocalizedString(@"注册") forState:UIControlStateNormal];
    [registerBtn setTitleColor:white_color forState:UIControlStateNormal];
    registerBtn.enabled = NO;
    [registerBtn setStatusWithEnableColor:kMainColor disableColor:k99999Color];
    [registerBtn addTarget:self action:@selector(registerClick) forControlEvents:UIControlEventTouchUpInside];
    self.registerBtn = registerBtn;
    
    //使用邮箱注册
    UIButton * mailBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.view addSubview:mailBtn];
    [mailBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(registerBtn);
        make.top.mas_equalTo(registerBtn.mas_bottom).offset(Adapted(15));
        make.height.mas_equalTo(Adapted(35));
    }];
    mailBtn.titleLabel.font = H15;
    mailBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    [mailBtn setTitleColor:kRedColor forState:UIControlStateNormal];
    [mailBtn setTitle:kLocalizedString(@"使用邮箱注册") forState:UIControlStateNormal];
    [mailBtn addTarget:self action:@selector(registeredMailClick) forControlEvents:UIControlEventTouchUpInside];
    
    //已有账号，登录
    UILabel *loginLab = [[UILabel alloc] init];
    [self.view addSubview:loginLab];
    [loginLab mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.right.mas_equalTo(registerBtn.mas_right);
        make.top.mas_equalTo(registerBtn.mas_bottom).offset(Adapted(15));
        make.height.mas_equalTo(Adapted(35));
    }];
    loginLab.font = H15;
    loginLab.textColor = kTextColor;
    loginLab.text = kLocalizedString(@"已有账号，登录");
    NSRange range = [loginLab.text rangeOfString:kLocalizedString(@"登录")];
    [loginLab qs_setTextColor:kLineColor atRange:NSMakeRange(0, range.location)];
    [loginLab qs_setTextColor:kRedColor atRange:range];
    [loginLab yb_addAttributeTapActionWithStrings:@[kLocalizedString(@"登录")] tapClicked:^(NSString *string, NSRange range, NSInteger index) {
        [self popToViewControllerWithClass:@"LoginIndexVC"];
    }];
    
    //协议
    UILabel * agreementLabel = [[UILabel alloc]init];
    [self.view addSubview:agreementLabel];
    agreementLabel.textAlignment = NSTextAlignmentCenter;
    agreementLabel.textColor = kTextColor;
    agreementLabel.font = H14;
    agreementLabel.numberOfLines = 0;
    agreementLabel.text = kLocalizedString(@"注册即代表已阅读并同意服务条款");
    NSRange agreeRange = [agreementLabel.text rangeOfString:kLocalizedString(@"服务条款")];
    [agreementLabel qs_setTextUnderLineAtRange:agreeRange andLineColor:kTextColor];
    [agreementLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.view);
        make.bottom.mas_equalTo(self.view.mas_bottom);
        make.left.mas_equalTo(Adapted(15));
        make.right.mas_equalTo(Adapted(-15));
        make.height.mas_equalTo(Adapted(60));
    }];
    
    agreementLabel.enabledTapEffect = NO;
    [agreementLabel yb_addAttributeTapActionWithStrings:@[kLocalizedString(@"服务条款")] tapClicked:^(NSString *string, NSRange range, NSInteger index) {
        [self userAgreementClick];
    }];
}


#pragma mark--按钮响应

//注册用户协议
-(void)userAgreementClick{
    NSString *currentLanguage = [NSBundle getPreferredLanguage];
    
    if([currentLanguage rangeOfString:@"zh-Hans"].location != NSNotFound)
    {
        //简体中文
        NSString *path = [[NSBundle mainBundle] pathForResource:@"MGCEX.Z用户协议-简体" ofType:@"pdf"];
        NSURL * url = [NSURL fileURLWithPath:path];
        
        UserAgreementVC * vc = [[UserAgreementVC alloc]init];
        vc.url = url;
        [self.navigationController pushViewController:vc animated:YES];
    }
    else if([currentLanguage rangeOfString:@"zh-Hant"].location != NSNotFound)
    {
        //繁体
        NSString *path = [[NSBundle mainBundle] pathForResource:@"MGCEX.Z用户协议繁体" ofType:@"pdf"];
        NSURL * url = [NSURL fileURLWithPath:path];
        
        UserAgreementVC * vc = [[UserAgreementVC alloc]init];
        vc.url = url;
        [self.navigationController pushViewController:vc animated:YES];
   
    }else if ([currentLanguage rangeOfString:@"en"].location != NSNotFound){
        //英语
        NSString *path = [[NSBundle mainBundle] pathForResource:@"MGCEX.Z用户协议_English" ofType:@"pdf"];
        NSURL * url = [NSURL fileURLWithPath:path];
        
        UserAgreementVC * vc = [[UserAgreementVC alloc]init];
        vc.url = url;
        [self.navigationController pushViewController:vc animated:YES];
     
    }
    
    
    
}

//切换国家地区
-(void)changeCountClick{
    
    // 创建第二个控制器
    ChangeCountryIndexVC *vc = [[ChangeCountryIndexVC alloc] init];
    // 设置代理信号
    vc.delegateSignal = [RACSubject subject];
    // 订阅代理信号
    @weakify(self);
    [vc.delegateSignal subscribeNext:^(NSString * x) {
        //代替代理，如果twoVc做了某件事，这里就知道
        
        @strongify(self);
        self.regFromCode = x;
   
    }];
    // 跳转到第二个控制器
    [self.navigationController pushViewController:vc animated:YES];
    
}

//改变注册按钮状态
-(void)changeRegisStatus{
    if(self.textVerification.text.length>0&&self.textPassword.text.length>0&&self.textName.text.length>0){
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

//跳邮箱注册
-(void)registeredMailClick{
    [self popToViewControllerWithClass:@"MailRegisterVC"];
}

-(void)back{
    [self popToViewControllerWithClass:@"LoginIndexVC"];
}

//注册
-(void)registerClick{
    
    if(![PredicateTool validatePhoneNumber:self.textName.text]){
        [TTWHUD showCustomMsg:kLocalizedString(@"手机号码格式错误")];
        return;
    }else if(_textPassword.text.length<6){
        [TTWHUD showCustomMsg:kLocalizedString(@"您的密码不能少于6位")];
        return;
    }
    
    self.viewModel.loginNum = self.textName.text;
    self.viewModel.code = self.textVerification.text;
    self.viewModel.password = self.textPassword.text;
    
    self.viewModel.regFromCode = self.regFromCode;
    if(self.regFromCode.length==0){
        self.viewModel.regFromCode = @"86";
    }
    //订阅信号
    @weakify(self);
    [self.viewModel.registerPhoneSignal subscribeNext:^(id x) {
        
        @strongify(self);
        
        [TTWHUD showCustomMsg:kLocalizedString(@"注册成功")];
        [self popToViewControllerWithClass:@"LoginIndexVC"];
        
        
    }];
    
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

@end
