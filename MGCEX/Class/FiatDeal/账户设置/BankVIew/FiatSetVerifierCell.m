// MGC
//
// FiatSetVerifierCell.m
// MGCEX
//
// Created by MGC on 2018/5/31.
// Copyright © 2018年 MGCion. All rights reserved.
//
// @ description <#描述#> 

#import "FiatSetVerifierCell.h"

@interface FiatSetVerifierCell()

@property (nonatomic, copy) NSString * email;
@property (nonatomic, copy) NSString * phone;
@end
@implementation FiatSetVerifierCell

-(void)setUpViews{
    
    self.backgroundColor = white_color;
    
    NSArray * titles = @[kLocalizedString(@"资金密码"),kLocalizedString(@"验证码")];
    NSArray * subTitles = @[kLocalizedString(@"请输入资金密码"),kLocalizedString(@"验证码")];
    
    for(int i=0;i<2;i++){
        
        UILabel * titleLabel = [[UILabel alloc]init];
        titleLabel.numberOfLines = 0;
        titleLabel.textColor = kTextColor;
        titleLabel.font = H15;
        titleLabel.text = titles[i];
        [self.contentView addSubview:titleLabel];
        [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(Adapted(15));
            make.top.mas_equalTo(Adapted(15)+Adapted(48)*i);
            make.width.mas_equalTo(Adapted(100));
        }];
        titleLabel.tag = 20+i;
        
        UITextField * subTextFiled = [[UITextField alloc]init];
        subTextFiled.textColor = kTextColor;
        subTextFiled.font = H15;
        subTextFiled.placeholder = subTitles[i];
        [self.contentView addSubview:subTextFiled];
        [subTextFiled mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(titleLabel.mas_right).offset(Adapted(5));
            make.centerY.mas_equalTo(titleLabel);
            make.width.mas_equalTo(Adapted(200));
        }];
        subTextFiled.tag = 10+i;
        
        UIView * lineView = [[UIView alloc]init];
        [self addSubview:lineView];
        lineView.backgroundColor = UIColorFromRGBA(0xdddddd, 0.8);
        [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(Adapted(15));
            make.right.mas_equalTo(Adapted(-15));
            make.height.mas_equalTo(0.8);
            make.top.mas_equalTo(titleLabel.mas_bottom).offset(Adapted(10));
        }];
        
    }
    
    self.password = [self viewWithTag:10];
    self.verifierCode = [self viewWithTag:11];
    self.titleLabel1 = [self viewWithTag:20];
    self.titleLabel2 = [self viewWithTag:21];
    self.verifierCode.keyboardType = UIKeyboardTypeNumberPad;
    self.verifierCode.limitTextLength = KVerificationNumber;
    self.password.secureTextEntry = YES;
    
    [self.verifierCode mas_updateConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(Adapted(100));
    }];
    
    //验证码竖线
    UIView * shuxian = [[UIView alloc]init];
    [self addSubview:shuxian];
    shuxian.backgroundColor = UIColorFromRGB(0xdddddd);
    [shuxian mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.verifierCode);
        make.width.mas_equalTo(0.8);
        make.height.mas_equalTo(20);
        make.left.mas_equalTo(self.verifierCode.mas_right).offset(5);
    }];
    
    //验证码按钮
    UIButton * codeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self addSubview:codeButton];
    [codeButton setTitle:kLocalizedString(@"获取验证码") forState:UIControlStateNormal];
    [codeButton setTitleColor:kRedColor forState:UIControlStateNormal];
    codeButton.titleLabel.font = H15;
    [codeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(shuxian.mas_right).offset(Adapted(5));
        make.centerY.mas_equalTo(self.verifierCode);
        make.right.mas_equalTo(self.mas_right).offset(Adapted(-15));
        make.height.mas_equalTo(Adapted(40));
        
    }];
    [codeButton addTarget:self action:@selector(getVerificationCode:) forControlEvents:UIControlEventTouchUpInside];
    self.codeButton = codeButton;
    [TWAppTool startTheCountdownWithPhoneCountdown:FiatbindingWXNumberdown Time:FiatbindingWXNumberdownTime btn:codeButton];

    
    //使用邮箱注册
    UIButton * mailBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self addSubview:mailBtn];
    [mailBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(Adapted(15));
        make.top.mas_equalTo(self.verifierCode.mas_bottom).offset(Adapted(17));
        make.width.mas_equalTo(Adapted(200));
        make.height.mas_equalTo(Adapted(35));
    }];
    mailBtn.titleLabel.font = H15;
    mailBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [mailBtn setTitleColor:kRedColor forState:UIControlStateNormal];
    [mailBtn setTitle:kLocalizedString(@"切换邮箱验证码") forState:UIControlStateNormal];
    [mailBtn setTitle:kLocalizedString(@"切换手机验证码") forState:UIControlStateSelected];
    [mailBtn addTarget:self action:@selector(changeBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    self.mailBtn = mailBtn;
    
    self.email = [[NSUserDefaults standardUserDefaults] objectForKey:VerifierEmail];
    self.phone = [[NSUserDefaults standardUserDefaults] objectForKey:VerifierPhone];
    
    if(_email.length>0&&_phone.length>0){
        mailBtn.hidden = NO;
        self.viewModel.registerType = 1;
        self.viewModel.loginNum = _phone;
    }else if(_email.length>0){
        mailBtn.hidden = YES;
        self.viewModel.registerType = 2;
        self.viewModel.loginNum = _email;
        self.titleLabel2.text = kLocalizedString(@"邮箱验证码");
    }else if (_phone.length>0){
        mailBtn.hidden = YES;
        self.viewModel.registerType = 1;
        self.viewModel.loginNum = _phone;
        self.titleLabel2.text = kLocalizedString(@"手机验证码");
    }else{
        mailBtn.hidden = YES;
    }
    
}

-(void)changeBtnClick:(UIButton *)button{
    button.selected = !button.selected;
    
    if(button.selected == YES){
        self.viewModel.registerType = 2;
        self.titleLabel2.text = kLocalizedString(@"邮箱验证码");
        self.verifierCode.placeholder = kLocalizedString(@"邮箱验证码");
        self.viewModel.loginNum = self.email;
        
    }else{
        self.viewModel.registerType = 1;
        self.titleLabel2.text = kLocalizedString(@"手机验证码");
        self.verifierCode.placeholder = kLocalizedString(@"手机验证码");
        self.viewModel.loginNum = self.phone;
        
    }
    
}

//获取验证码
-(void)getVerificationCode:(UIButton *)btn{

    
    //订阅信号
    @weakify(self);
    [self.viewModel.sendPhoneCodeSignal subscribeNext:^(id x) {
        
        @strongify(self);
     
        if(self.verifierBlock){
            self.verifierBlock(self.viewModel.loginNum);
        }
        [TTWHUD showCustomIcon:@"gou" title:kLocalizedString(@"已发送") toView:self.superview];
        [self.codeButton mg_startCountDownTime:Countdown finishTitle:kLocalizedString(@"重新获取验证码") waitTittle:@"S" finishColor:nil waitColor:nil Finish:^(UIButton *button) {
            
        }];
        
        
    }];


}



-(RegisterIndexVM *)viewModel{
    if(!_viewModel){
        _viewModel = [[RegisterIndexVM alloc]init];
    }
    return _viewModel;
}
@end
