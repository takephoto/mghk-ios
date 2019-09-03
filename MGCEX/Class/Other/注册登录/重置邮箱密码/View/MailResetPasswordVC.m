// MGC
//
// MailResetPasswordVC.m
// MGCEX
//
// Created by MGC on 2018/5/12.
// Copyright © 2018年 MGCion. All rights reserved.
//
// @ description <#描述#> 

#import "MailResetPasswordVC.h"
#import "RegisterIndexVM.h"
#import "ResetPasswordVM.h"

@interface MailResetPasswordVC ()
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

@implementation MailResetPasswordVC

-(void)dealloc{
    //防止倒计时没结束就返回，导致计时器不销毁
    if(self.codeButton.timer&&self.codeButton.timeOutNumber>0){
        //保存时间戳
//        NSDate * date = [NSDate date];
//        [[NSUserDefaults standardUserDefaults] setObject:@(self.codeButton.timeOutNumber) forKey:ResertMailRegisterCountdown];
//        [[NSUserDefaults standardUserDefaults] setObject:date forKey:ResertMailRegisterCountdownTime];
//        [[NSUserDefaults standardUserDefaults] synchronize];
        //销毁定时器
        dispatch_source_cancel(self.codeButton.timer);
        self.codeButton.timer = nil;
    }
    
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = kLocalizedString(@"重置密码");
    
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
    
    //邮箱
    UITextField * textName = [[UITextField alloc]init];
    [self.view addSubview:textName];
    [textName mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.left.mas_offset(Adapted(30));
        make.top.mas_offset(Adapted(66));
        make.right.mas_offset(Adapted(-30));
    }];
    textName.font = H18;
    textName.textColor = kTextColor;
    textName.placeholder = kLocalizedString(@"邮箱");
    textName.tintColor = kTextColor;
    [textName setValue:kAssistColor forKeyPath:@"_placeholderLabel.textColor"];
    [textName setValue:H18 forKeyPath:@"_placeholderLabel.font"];
    self.textName = textName;
    
    @weakify(self);
    textName.didChangeBlock = ^(NSString *text) {
        @strongify(self);
        [self changeRegisStatus];
        self.codeButton.enabled = text.length;
    };
    
    //验证码UITextField
    UITextField * textVerification = [[UITextField alloc]init];
    [self.view addSubview:textVerification];
    [textVerification mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(textName);
        make.top.mas_equalTo(self.lineView1.mas_bottom).offset(Adapted(38));
        make.width.mas_equalTo(Adapted(188));
    }];
    textVerification.font = H18;
    textVerification.textColor = kTextColor;
    textVerification.placeholder = kLocalizedString(@"验证码");
    textVerification.tintColor = kTextColor;
    [textVerification setValue:kLineColor forKeyPath:@"_placeholderLabel.textColor"];
    [textVerification setValue:H18 forKeyPath:@"_placeholderLabel.font"];
    self.textVerification = textVerification;
    self.textVerification.keyboardType = UIKeyboardTypeNumberPad;
    self.textVerification.limitTextLength = KVerificationNumber;
    textVerification.didChangeBlock = ^(NSString *text) {
        @strongify(self);
        [self changeRegisStatus];
    };
    
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
    
    //验证码按钮
    UIButton * codeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.view addSubview:codeButton];
    codeButton.enabled = NO;
    codeButton.selected = NO;
    [codeButton setTitle:kLocalizedString(@"获取验证码") forState:UIControlStateNormal];
    [codeButton setTitleColor:kLineColor forState:UIControlStateDisabled];
    [codeButton setTitleColor:kMainColor forState:UIControlStateNormal];
    codeButton.titleLabel.font = H16;
    codeButton.titleLabel.adjustsFontSizeToFitWidth = YES;
    [codeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(shuxian.mas_right).offset(Adapted(5));
        make.centerY.mas_equalTo(textVerification);
        make.right.mas_offset(Adapted(-30));
        make.height.mas_equalTo(Adapted(40));
    }];
    [codeButton addTarget:self action:@selector(getVerificationCode:) forControlEvents:UIControlEventTouchUpInside];
    self.codeButton = codeButton;
//    [TWAppTool startTheCountdownWithPhoneCountdown:ResertMailRegisterCountdown Time:ResertMailRegisterCountdownTime btn:codeButton];
    
    //密码
    UITextField * textPassword = [[UITextField alloc]init];
    [self.view addSubview:textPassword];
    [textPassword mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(textName);
        make.top.mas_equalTo(self.lineView2.mas_bottom).offset(Adapted(42));
        make.width.mas_equalTo(Adapted(320));
    }];
    textPassword.font = H18;
    textPassword.textColor = kTextColor;
    textPassword.placeholder = kLocalizedString(@"重置密码");
    textPassword.secureTextEntry = YES;
    textPassword.tintColor = kTextColor;
    [textPassword setValue:kLineColor forKeyPath:@"_placeholderLabel.textColor"];
    [textPassword setValue:H18 forKeyPath:@"_placeholderLabel.font"];
    self.textPassword = textPassword;
    textPassword.didChangeBlock = ^(NSString *text) {
        @strongify(self);
        [self changeRegisStatus];
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
        make.left.mas_equalTo(textName);
        make.top.mas_equalTo(self.lineView3.mas_bottom).offset(Adapted(42));
        make.width.mas_equalTo(Adapted(320));
    }];
    ResetPassword.font = H18;
    ResetPassword.textColor = kTextColor;
    ResetPassword.placeholder = kLocalizedString(@"再次确认密码");
    ResetPassword.secureTextEntry = YES;
    ResetPassword.tintColor = kTextColor;
    [ResetPassword setValue:kLineColor forKeyPath:@"_placeholderLabel.textColor"];
    [ResetPassword setValue:H18 forKeyPath:@"_placeholderLabel.font"];
    self.ResetPassword = ResetPassword;
    ResetPassword.didChangeBlock = ^(NSString *text) {
        @strongify(self);
        [self changeRegisStatus];
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
    registerBtn.clipsToBounds = YES;
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
    [mailBtn setTitle:kLocalizedString(@"使用手机号重置密码") forState:UIControlStateNormal];
    [mailBtn addTarget:self action:@selector(userPhoneResetClick) forControlEvents:UIControlEventTouchUpInside];
    
    
}



#pragma mark--按钮响应

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
    if(![PredicateTool validateEmail:self.textName.text]){
        [TTWHUD showCustomMsg:kLocalizedString(@"邮箱号格式错误")];
        return;
    }
    
    self.viewModel.loginNum = self.textName.text;
    self.viewModel.registerType = 2;

    //订阅信号
    @weakify(self);
    [self.viewModel.sendPhoneCodeSignal subscribeNext:^(id x) {
        
        @strongify(self);
   
        [TTWHUD showCustomIcon:@"gou" title:kLocalizedString(@"已发送") toView:self.view];
        [self.codeButton mg_startCountDownTime:Countdown finishTitle:kLocalizedString(@"重新获取验证码") waitTittle:@"S" finishColor:nil waitColor:nil Finish:^(UIButton *button) {
                
        }];
        
        
    }];

}

//跳回手机号码找回
-(void)userPhoneResetClick{
    [self.navigationController popViewControllerAnimated:YES];
}



//提交
-(void)submitClick{
    if(![PredicateTool validateEmail:self.textName.text]){
        [TTWHUD showCustomMsg:kLocalizedString(@"邮箱号格式错误")];
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
