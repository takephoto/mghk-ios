// MGC
//
// ResertMoneyPasswordVC.m
// MGCEX
//
// Created by MGC on 2018/5/19.
// Copyright © 2018年 MGCion. All rights reserved.
//
// @ description <#描述#> 

#import "ResertMoneyPasswordVC.h"
#import "RegisterIndexVM.h"
#import "ResertMoneyPasswordVM.h"

@interface ResertMoneyPasswordVC ()
@property (nonatomic, strong) UITextField * verificationTextFiled;//验证码
@property (nonatomic, strong) UITextField * currentPassword;//新密码
@property (nonatomic, strong) UITextField * againPassword;//再次确认密码
@property (nonatomic, strong) UIButton * nextBtn;
@property (nonatomic, strong) UIButton * codeButton;
@property (nonatomic, strong) RegisterIndexVM * viewModel;
@property (nonatomic, copy) NSString * accountStr;
@end

@implementation ResertMoneyPasswordVC

-(void)dealloc{
    //防止倒计时没结束就返回，导致计时器不销毁
    if(self.codeButton.timer&&self.codeButton.timeOutNumber>0){
        //保存时间戳
        NSDate * date = [NSDate date];
        [[NSUserDefaults standardUserDefaults] setObject:@(self.codeButton.timeOutNumber) forKey:SettingMoneyPasswordNumberdown];
        [[NSUserDefaults standardUserDefaults] setObject:date forKey:SettingMoneyPasswordNumberdownTime];
        [[NSUserDefaults standardUserDefaults] synchronize];
        //销毁定时器
        dispatch_source_cancel(self.codeButton.timer);
        self.codeButton.timer = nil;
    }
    
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = kLocalizedString(@"重置资金密码");
    //初始化为手机验证
    self.viewModel.registerType = 1;
    
    UILabel * titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(Adapted(15), Adapted(15), MAIN_SCREEN_WIDTH-Adapted(30), Adapted(30))];
    [self.view addSubview:titleLabel];
    titleLabel.text = @"";
    titleLabel.textColor = kTextColor;
    titleLabel.font = H15;
    self.accountStr = titleLabel.text;
    
    
    NSArray * titles = @[kLocalizedString(@"验证码"),kLocalizedString(@"重置资金密码"),kLocalizedString(@"再次确认资金密码")];
    UIView * backView = [[UIView alloc]initWithFrame:CGRectMake(0, Adapted(60), MAIN_SCREEN_WIDTH, 2+titles.count*Adapted(48))];
    backView.backgroundColor = kBackAssistColor;
    [self.view addSubview:backView];
    for(int i=0;i<titles.count;i++){
        UITextField * textfield = [[UITextField alloc]initWithFrame:CGRectMake(Adapted(15),Adapted(60)+ i*Adapted(48), Adapted(280), Adapted(48))];
        [self.view addSubview:textfield];
        textfield.placeholder = titles[i];
        textfield.placeholderColor = kLineColor;
        textfield.tintColor = kTextColor;
        textfield.textColor = kTextColor;
        textfield.font = H15;
        textfield.tag = 100+i;
        if(i==0){
            textfield.width = Adapted(200);
        }
        
        //下划线
        if(i<titles.count-1){
            UIView * Line = [[UIView alloc]initWithFrame:CGRectMake(Adapted(15),Adapted(60)+(i+1)*Adapted(48), MAIN_SCREEN_WIDTH-Adapted(30), 1)];
            [self.view addSubview:Line];
            Line.backgroundColor = kLineAssistColor;
        }
        
        
        //密码眼睛
        UIButton * seeButton = [[UIButton alloc]initWithFrame:CGRectMake(MAIN_SCREEN_WIDTH-Adapted(47), Adapted(60)+Adapted(4)+i*Adapted(48), Adapted(40), Adapted(40))];
        [self.view addSubview:seeButton];
        seeButton.tag = 200+i;
        [seeButton addTarget:self action:@selector(showOrHiddenPassword:) forControlEvents:UIControlEventTouchUpInside];
        [seeButton setImage:[UIImage imageNamed:@"yinchang"] forState:UIControlStateNormal];
        [seeButton setImage:[UIImage imageNamed:@"xianshi"] forState:UIControlStateSelected];
        if(i==0){
            seeButton.hidden = YES;
            
        }
       
    }
    
    self.verificationTextFiled = [self.view viewWithTag:100];
    self.currentPassword = [self.view viewWithTag:101];
    self.againPassword = [self.view viewWithTag:102];
    self.verificationTextFiled.keyboardType = UIKeyboardTypeNumberPad;
    self.verificationTextFiled.limitTextLength = KVerificationNumber;
    
    self.currentPassword.secureTextEntry = YES;
    self.againPassword.secureTextEntry = YES;
    
    //验证码竖线
    UIView * shuxian = [[UIView alloc]init];
    [self.view addSubview:shuxian];
    shuxian.backgroundColor = kLineColor;
    [shuxian mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.verificationTextFiled);
        make.width.mas_equalTo(1);
        make.height.mas_equalTo(20);
        make.left.mas_equalTo(self.verificationTextFiled.mas_right);
    }];
    
    //验证码按钮
    UIButton * codeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.view addSubview:codeButton];
    codeButton.selected = YES;
    [codeButton setTitle:kLocalizedString(@"获取验证码") forState:UIControlStateNormal];
    [codeButton setTitleColor:kRedColor forState:UIControlStateNormal];
    codeButton.titleLabel.font = H15;
    [codeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(shuxian.mas_right).offset(Adapted(5));
        make.centerY.mas_equalTo(self.verificationTextFiled);
        make.right.mas_equalTo(self.view.mas_right).offset(Adapted(-30));
        make.height.mas_equalTo(Adapted(40));
        
    }];
    [codeButton addTarget:self action:@selector(getVerificationCode:) forControlEvents:UIControlEventTouchUpInside];
    self.codeButton = codeButton;
    [TWAppTool startTheCountdownWithPhoneCountdown:SettingMoneyPasswordNumberdown Time:SettingMoneyPasswordNumberdownTime btn:codeButton];

    @weakify(self);
    self.currentPassword.didChangeBlock = ^(NSString *text) {
        @strongify(self);
        if(text.length>5&&self.againPassword.text.length>5){
            self.nextBtn.enabled = YES;
        }else{
            self.nextBtn.enabled = NO;
        }
    };
    
    self.againPassword.didChangeBlock = ^(NSString *text) {
        @strongify(self);
        if(text.length>5&&self.currentPassword.text.length>5){
            self.nextBtn.enabled = YES;
        }else{
            self.nextBtn.enabled = NO;
        }
    };
    
    
    //下一步
    UIButton * nextBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.view addSubview:nextBtn];
    [nextBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.view);
        make.top.mas_equalTo(self.againPassword.mas_bottom).offset(Adapted(40));
        make.width.mas_equalTo(MAIN_SCREEN_WIDTH-Adapted(30));
        make.height.mas_equalTo(Adapted(40));
    }];
    nextBtn.layer.cornerRadius = Adapted(40)/2.0;
    nextBtn.clipsToBounds = YES;
    [nextBtn setTitle:kLocalizedString(@"提交") forState:UIControlStateNormal];
    [nextBtn setTitleColor:kTextColor forState:UIControlStateNormal];
    nextBtn.enabled = NO;
    [nextBtn setStatusWithEnableColor:kRedColor disableColor:kDisableRedColor];
    [nextBtn addTarget:self action:@selector(nextBtnClick) forControlEvents:UIControlEventTouchUpInside];
    self.nextBtn = nextBtn;
    
    //切换邮箱/手机验证
    UIButton * changeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.view addSubview:changeBtn];
    [changeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(nextBtn.mas_left);
        make.top.mas_equalTo(nextBtn.mas_bottom).offset(Adapted(24));
        make.width.mas_equalTo(Adapted(120));
        make.height.mas_equalTo(Adapted(35));
    }];

    changeBtn.titleLabel.font = H15;
    changeBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [changeBtn setTitleColor:kRedColor forState:UIControlStateNormal];
    [changeBtn setTitle:kLocalizedString(@"邮箱验证") forState:UIControlStateNormal];
    [changeBtn setTitle:kLocalizedString(@"手机验证") forState:UIControlStateSelected];
    [changeBtn addTarget:self action:@selector(changeBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    
}


#pragma mark--按钮响应

//显示隐藏密码
-(void)showOrHiddenPassword:(UIButton *)btn{
    btn.selected = !btn.selected;
    UITextField * textField = [self.view viewWithTag:btn.tag-100];
    textField.secureTextEntry = !textField.secureTextEntry;
}

//下一步
-(void)nextBtnClick{
    
    [self.view endEditing:YES];
    if(![self.currentPassword.text isEqualToString:self.againPassword.text]){
        [TTWHUD showCustomMsg:kLocalizedString(@"旧密码与新密码不一致")];
        return;
    }
    
    
}

//获取验证码
-(void)getVerificationCode:(UIButton *)btn{
    [self.view endEditing:YES];
    
    
    self.viewModel.loginNum = self.accountStr;
    
    //订阅信号
    @weakify(self);
    [self.viewModel.sendPhoneCodeSignal subscribeNext:^(id x) {
        
        @strongify(self);
        [TTWHUD showCustomIcon:@"gou" title:kLocalizedString(@"已发送") toView:self.view];
        [self.codeButton mg_startCountDownTime:Countdown finishTitle:kLocalizedString(@"重新获取验证码") waitTittle:@"S" finishColor:nil waitColor:nil Finish:^(UIButton *button) {
                
        }];
        
        
    }];
    
}

//切换手机/邮箱验证
-(void)changeBtnClick:(UIButton *)btn{
    btn.selected = !btn.selected;
    if(btn.selected == NO){//跳手机验证
        self.viewModel.registerType = 1;
    }else{//跳邮箱验证
        self.viewModel.registerType = 2;
    }
}

-(RegisterIndexVM *)viewModel{
    if(!_viewModel){
        _viewModel = [[RegisterIndexVM alloc]init];
        
    }
    return _viewModel;
}

@end
