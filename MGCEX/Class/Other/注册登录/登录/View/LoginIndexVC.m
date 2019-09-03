// MGC
//
// LoginIndexVC.m
// MGCEX
//
// Created by MGC on 2018/5/10.
// Copyright © 2018年 MGCion. All rights reserved.
//
// @ description <#描述#> 

#import "LoginIndexVC.h"
#import "TTWHUD.h"
#import "LoginIndexVM.h"
#import "BaseTabBarController.h"
#import "AppDelegate.h"
#import "GestureViewController.h"
#import "SecondaryValidationView.h"
#import "QSLocationTool.h"
#import "EnterTextView.h"
#import "PhoneResetPasswordVC.h"

@interface LoginIndexVC ()
@property (nonatomic, strong) UITextField * textPassword;
@property (nonatomic, strong) UITextField * textName;
@property (nonatomic, strong) UIButton * loginBtn;
@property (nonatomic, strong) UIButton * nameLogoBtn;
@property (nonatomic, strong) LoginIndexVM * viewModel;
@property (nonatomic, assign) float latitude;
@property (nonatomic, assign) float longitude;
@property (nonatomic, strong) UserModel * userModel;
@end

@implementation LoginIndexVC

- (void)back{
    
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    self.view.backgroundColor = white_color;
    [self setNavBarStyle:NavigationBarStyleWhite backBtn:YES];
//    [self setNavBarWithTextColor:black_color barTintColor:white_color tintColor:black_color statusBarStyle:UIStatusBarStyleDefault];
    
    //显示登录账号
    if(self.textName.text.length==0){
        if([[NSUserDefaults standardUserDefaults] objectForKey:CurrentLogin]){
          self.textName.text =[[NSUserDefaults standardUserDefaults] objectForKey:CurrentLogin];
        }
    }

    //获取经纬度
    QSLocationTool * tool = [QSLocationTool new];
    @weakify(self);
    [tool startLocationSuccess:^(NSString *cityName, float latitude, float longitude) {
        @strongify(self);
        self.latitude = latitude;
        self.longitude = longitude;
    } failed:^{
        
    }];
    
  
}
-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
//    self.navigationController.navigationBar.barTintColor = kBackGroundColor;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIImageView * logImageV = [[UIImageView alloc]init];
    [self.view addSubview:logImageV];
    logImageV.image = IMAGE(@"logo");
    [logImageV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.view);
        make.top.mas_equalTo(Adapted(5));
    }];
    
    UILabel *lab = [[UILabel alloc] init];
    [self.view addSubview:lab];
    [lab mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.mas_offset(Adapted(32));
        make.top.mas_equalTo(logImageV.mas_bottom).offset(Adapted(17));
    }];
    lab.font = HB17;
    lab.textColor = UIColorFromRGB(0x454545);
    lab.text = kLocalizedString(@"登录");
    
    //账号
    UITextField * textName = [[UITextField alloc]init];
    [self.view addSubview:textName];
    [textName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.view);
        make.top.mas_equalTo(lab.mas_bottom).offset(Adapted(34));
        make.width.mas_equalTo(MAIN_SCREEN_WIDTH-Adapted(56));
    }];
    textName.font = H18;
    textName.textColor = UIColorFromRGB(0x454545);
    textName.placeholder = kLocalizedString(@"请输入手机号码或邮箱");
    textName.tintColor = black_color;
    textName.clearButtonMode = UITextFieldViewModeWhileEditing;
    [textName setValue:UIColorFromRGB(0xA6A6A6) forKeyPath:@"_placeholderLabel.textColor"];
    [textName setValue:H18 forKeyPath:@"_placeholderLabel.font"];
    self.textName = textName;
    
    //下划线
    UIView * nameLine = [[UIView alloc]init];
    [self.view addSubview:nameLine];
    nameLine.backgroundColor = UIColorFromRGB(0xDCDCDC);
    [nameLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.view);
        make.width.mas_equalTo(textName);
        make.height.mas_equalTo(1);
        make.top.mas_equalTo(textName.mas_bottom).mas_offset(Adapted(14));
    }];
    
    self.textName.didChangeBlock = ^(NSString *text) {
        
        if(kStringIsEmpty(text)){
            nameLine.backgroundColor = UIColorFromRGB(0xDCDCDC);
        }else{
            nameLine.backgroundColor = kMainColor;
        }
    };
    
    @weakify(self);
    RAC(self.nameLogoBtn,selected) =[ [RACObserve(self.textName, text)  merge:self.textName.rac_textSignal ] map:^id(NSString *value) {
        @strongify(self);
        if(value.length>0&&self.textPassword.text.length>5){
            self.loginBtn.enabled = YES;
        }else{
            self.loginBtn.enabled = NO;
        }
        
        return @(value.length>0);
    }];
    
    //密码
    UITextField * textPassword = [[UITextField alloc]init];
    [self.view addSubview:textPassword];
    [textPassword mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(textName);
        make.top.mas_equalTo(nameLine.mas_bottom).offset(Adapted(42));
    }];
    textPassword.font = H18;
    textPassword.textColor = black_color;
    textPassword.placeholder = kLocalizedString(@"请输入密码");
    textPassword.secureTextEntry = YES;
    textPassword.tintColor = black_color;
    textPassword.placeholderColor = UIColorFromRGB(0xA6A6A6);
    [textPassword setValue:H18 forKeyPath:@"_placeholderLabel.font"];
    self.textPassword = textPassword;
    textPassword.limitTextLength = 22;
    
    //下划线
    UIView * passwordLine = [[UIView alloc]init];
    [self.view addSubview:passwordLine];
    passwordLine.backgroundColor = UIColorFromRGB(0xDCDCDC);
    [passwordLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.view);
        make.width.mas_equalTo(MAIN_SCREEN_WIDTH-Adapted(60));
        make.height.mas_equalTo(1);
        make.top.mas_equalTo(textPassword.mas_bottom).mas_offset(Adapted(10));
    }];
    
    textPassword.didChangeBlock = ^(NSString *text) {
        @strongify(self);
        if(text.length>5&&self.textName.text.length>0){
            self.loginBtn.enabled = YES;
        }else{
            self.loginBtn.enabled = NO;
        }
        if(kStringIsEmpty(text)){
            passwordLine.backgroundColor = UIColorFromRGB(0xDCDCDC);
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
    
    //登录按钮
    UIButton * loginBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.view addSubview:loginBtn];
    [loginBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.view);
        make.top.mas_equalTo(passwordLine.mas_bottom).offset(Adapted(40));
        make.left.mas_equalTo(passwordLine.mas_left);
        make.right.mas_equalTo(passwordLine.mas_right);
        make.height.mas_equalTo(Adapted(50));
    }];
    [loginBtn setTitle:kLocalizedString(@"登录") forState:UIControlStateNormal];
    [loginBtn setTitleColor:white_color forState:UIControlStateNormal];
    loginBtn.enabled = NO;
    [loginBtn setStatusWithEnableColor:UIColorFromRGB(0xF7B700) disableColor:k99999Color];
    [loginBtn addTarget:self action:@selector(loginClick) forControlEvents:UIControlEventTouchUpInside];
    ViewRadius(loginBtn, Adapted(2.0));
    self.loginBtn = loginBtn;
    
    //注册
    UIButton * registerBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.view addSubview:registerBtn];
    [registerBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(loginBtn.mas_right);
        make.top.mas_equalTo(loginBtn.mas_bottom).offset(Adapted(20));
        make.width.mas_equalTo(Adapted(100));
        make.height.mas_equalTo(Adapted(35));
    }];
    registerBtn.titleLabel.font = H15;
    registerBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    [registerBtn setTitleColor:kRedColor forState:UIControlStateNormal];
    [registerBtn setTitle:kLocalizedString(@"注册") forState:UIControlStateNormal];
    [registerBtn addTarget:self action:@selector(registerClick) forControlEvents:UIControlEventTouchUpInside];
    
    
    //重置密码
    UIButton * forgetBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.view addSubview:forgetBtn];
    [forgetBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(loginBtn.mas_left);
        make.top.mas_equalTo(loginBtn.mas_bottom).offset(Adapted(20));
        make.height.mas_equalTo(Adapted(35));
    }];
    forgetBtn.titleLabel.font = H15;
    forgetBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [forgetBtn setTitleColor:kRedColor forState:UIControlStateNormal];
    [forgetBtn setTitle:kLocalizedString(@"忘记密码") forState:UIControlStateNormal];
    [forgetBtn addTarget:self action:@selector(forgetClick) forControlEvents:UIControlEventTouchUpInside];
    
    
    /*
    //底部背景图
    UIImageView * bottomImageV = [[UIImageView alloc]init];
    [self.view addSubview:bottomImageV];
    bottomImageV.image = IMAGE(@"bg");
    [bottomImageV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.left.right.mas_equalTo(self.view);
        make.height.mas_equalTo(Adapted(90));
    }];
    */
}

#pragma mark--按钮响应


//登录
-(void)loginClick{

    [self.view endEditing:YES];
    self.viewModel.loginNum = self.textName.text;
    self.viewModel.password = self.textPassword.text;
    self.viewModel.latitudePoint = [NSString stringWithFormat:@"%f",self.latitude];
    self.viewModel.longitudePint = [NSString stringWithFormat:@"%f",self.longitude];
    //是否第一次登录

    if(kUserIsLogin){//已登录,进程被杀掉,属于正常退出(没有开启手势或指纹)
        //先登录
        @weakify(self);
        [self.viewModel.loginSignal subscribeNext:^(UserModel *model) {
            @strongify(self);
            self.userModel = model;
            //是否开启了谷歌验证
            if([self.userModel.google boolValue]&&[self.userModel.isgoogle boolValue]){
                [self openGoogleSecurityVerification];
            }else{//手机邮箱验证
                [self SecondaryValidation];
            }
            
        }];
        
    }else{//没有登录,属于退出或异常登录
        
        //先登录
        @weakify(self);
        [self.viewModel.loginSignal subscribeNext:^(UserModel *model) {
            @strongify(self);
            self.userModel = model;
            //判断是否开启谷歌
            if ([self.userModel.google boolValue]&&[self.userModel.isgoogle boolValue]){
                [self openGoogleSecurityVerification];
            }else{
                //手机短信邮箱二次验证
                [self SecondaryValidation];
            }
  
        }];
        
        
    }
 
}

//开启谷歌安全验证
-(void)openGoogleSecurityVerification{

    @weakify(self);
    EnterTextView * open = [[EnterTextView alloc]initWithSupView:self.view Title:kLocalizedString(@"谷歌二次安全验证") message:kLocalizedString(@"验证码") placeholder:kLocalizedString(@"谷歌验证码") sureBtnTitle:kLocalizedString(@"提交") sureBtnClick:^(NSString *password){
        @strongify(self);
        [self getGoogleSecondWith:password];
  
    }cancelBtnClick:^{
            
    }];
    open.enterText.keyboardType = UIKeyboardTypeNumberPad;
    [open show];
    
}

-(void)getGoogleSecondWith:(NSString *)code{
    self.viewModel.googleCode = code;
    @weakify(self);
    [self.viewModel.secondGoogleSignal subscribeNext:^(id x) {
        @strongify(self);
        [self configUserInfo];
        
        AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
        BaseTabBarController *tabVC = [[BaseTabBarController alloc] init];
        delegate.window.rootViewController = tabVC;
        
    }];
}


//二次验证
-(void)SecondaryValidation{
    
    NSString * titleStr = @"";
    NSInteger coeType = 0;//3：有手机和邮箱。2只有邮箱  1 只有手机
 
    if(!kStringIsEmpty(self.userModel.phone)&&!kStringIsEmpty(self.userModel.email)){//手机号邮箱号都有验证过
        titleStr = self.userModel.phone;
        coeType = 3;
    }else if (!kStringIsEmpty(self.userModel.phone)&&kStringIsEmpty(self.userModel.email)){//只有手机号验证过
        titleStr = self.userModel.phone;
        coeType = 1;
    }else if (kStringIsEmpty(self.userModel.phone)&&!kStringIsEmpty(self.userModel.email))//只有邮箱号验证过
    {
        titleStr = self.userModel.email;
        coeType = 2;
    }else{
        return;
    }
    
    SecondaryValidationView * view = [[SecondaryValidationView alloc]initWithSupView:self.view Title:kLocalizedString(@"进行二次安全验证") message:titleStr coeType:coeType sureBtnTitle:@"提交" sureBtnClick:^(NSString * loginNum, NSString * password){
        
        [self secondaryValidationNextClickLoginNum:loginNum code:password];
        
    } cancelBtnClick:^{
        
    }];
    
    [view show];
    
    
    
}

//二次验证提交
-(void)secondaryValidationNextClickLoginNum:(NSString *)loginNum code:(NSString *)code{
    
    self.viewModel.loginNum = loginNum;
    self.viewModel.secondCode = code;
    //订阅信号
    @weakify(self);
    [self.viewModel.validationSignal subscribeNext:^(id x) {
        @strongify(self);
        [self configUserInfo];
        AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
        BaseTabBarController *tabVC = [[BaseTabBarController alloc] init];
        delegate.window.rootViewController = tabVC;
        
    }];
}


//登录成功，配置基本信息
-(void)configUserInfo{
    
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:AlreadyFirstLogin];
    [[NSUserDefaults standardUserDefaults] setBool:NO forKey:TokenDisabled];
    [[NSUserDefaults standardUserDefaults] setBool:NO forKey:KillLogin];
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:isLogin];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"endAppTime"];
    [[NSUserDefaults standardUserDefaults] setObject:self.textName.text forKey:CurrentLogin];
    [[NSUserDefaults standardUserDefaults] synchronize];
}


//找回密码
-(void)forgetClick{
    PhoneResetPasswordVC *vc = [PhoneResetPasswordVC new];
    vc.navTitle = @"忘记密码";
    [self pushViewControllerWithName:vc];
}

//注册
-(void)registerClick{
    [self pushViewControllerWithName:@"MailRegisterVC"];
}

//显示隐藏密码
-(void)showOrHiddenPassword:(UIButton *)btn{
    btn.selected = !btn.selected;
    self.textPassword.secureTextEntry = !self.textPassword.secureTextEntry;
}

-(LoginIndexVM *)viewModel{
    if(!_viewModel){
        _viewModel = [[LoginIndexVM alloc]init];
        
    }
    return _viewModel;
}

@end
