// MGC
//
// SecondaryValidationView.m
// MGCEX
//
// Created by MGC on 2018/5/20.
// Copyright © 2018年 MGCion. All rights reserved.
//
// @ description <#描述#> 

#import "SecondaryValidationView.h"
#import "RegisterIndexVM.h"

@interface SecondaryValidationView()
@property (nonatomic, strong)UIView *alertView;
@property (nonatomic, strong) UIButton *nextBtn;
@property (nonatomic, strong) UITextField * enterText;
@property (nonatomic, strong) UITextField * enterText2;
@property (nonatomic, strong) UIView * toView;
@property (nonatomic, strong) UIButton * codeButton;
@property (nonatomic, strong) RegisterIndexVM * viewModel;
@property (nonatomic, assign) NSInteger codeType;
@property (nonatomic, copy) NSString * message;
@property (nonatomic, strong) UserModel * userModel;
@property (nonatomic, strong) UILabel * msgLabel;
@end

@implementation SecondaryValidationView

-(void)dealloc{
    //防止倒计时没结束就返回，导致计时器不销毁
    if(self.codeButton.timer&&self.codeButton.timeOutNumber>0){
        //保存时间戳
        NSDate * date = [NSDate date];
        [[NSUserDefaults standardUserDefaults] setObject:@(self.codeButton.timeOutNumber) forKey:SecondaryValidationNumberdown];
        [[NSUserDefaults standardUserDefaults] setObject:date forKey:SecondaryValidationNumberdownTime];
        [[NSUserDefaults standardUserDefaults] synchronize];
        //销毁定时器
        dispatch_source_cancel(self.codeButton.timer);
        self.codeButton.timer = nil;
    }
    
    
}


-(instancetype)initWithSupView:(UIView *)toView Title:(NSString *)title message:(NSString *)message coeType:(NSInteger )coeType  sureBtnTitle:(NSString *)sureBtnTitle sureBtnClick:(verifierSureBlock)sureBlock cancelBtnClick:(cancelBlock)cancelBlock
{
    self=[super init];
    if (self) {
        self.userModel = [TWUserDefault UserDefaultObjectForUserModel];
        self.frame = [UIScreen mainScreen].bounds;
        self.toView = toView;
        self.codeType = coeType;
        self.message = message;
        self.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.5f];
        self.alertView = [[UIView alloc]init];
        self.alertView.backgroundColor = white_color;
        [self addSubview:self.alertView];
        [self.alertView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(self);
            make.centerY.mas_equalTo(self).offset(Adapted(-64));
            make.width.mas_equalTo(Adapted(300));
            make.height.mas_equalTo(Adapted(300));
        }];
        
        UIView * headView = [[UIView alloc]init];
        [self.alertView addSubview:headView];
        headView.backgroundColor = UIColorFromRGB(0xf3efef);
        [headView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.top.right.mas_equalTo(self.alertView);
            make.height.mas_equalTo(Adapted(44));
        }];
        
        UILabel * titleLabel = [[UILabel alloc]init];
        [headView addSubview:titleLabel];
        titleLabel.textAlignment = NSTextAlignmentCenter;
        titleLabel.textColor = kTextColor;
        titleLabel.font = H15;
        titleLabel.text = title;
        [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(Adapted(40));
            make.right.mas_equalTo(Adapted(-40));
            make.centerY.mas_equalTo(headView);
        }];
        
        UIButton * cancelBtn = [UIButton buttonWithType:0];
        [headView addSubview:cancelBtn];
        [cancelBtn setImage:IMAGE(@"guanbi") forState:UIControlStateNormal];
        [cancelBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(headView);
            make.width.height.mas_equalTo(Adapted(40));
            make.centerY.mas_equalTo(headView);
        }];
        @weakify(self);
        [cancelBtn mg_addTapBlock:^(UIButton *button) {
            @strongify(self);
            if(cancelBlock){
                cancelBlock();
            }
            [self hidden];
        }];
        
        UILabel * msgLabel = [[UILabel alloc]init];
        [self.alertView addSubview:msgLabel];
        self.msgLabel = msgLabel;
        msgLabel.textColor = kTextColor;
        msgLabel.text = [TWAppTool mg_securePhoneMailText:message];
        [msgLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(Adapted(15));
            make.top.mas_equalTo(headView.mas_bottom).offset(Adapted(38));
            make.right.mas_equalTo(Adapted(-15));
            
        }];
        
        UITextField * enterText = [[UITextField alloc]init];
        [self.alertView addSubview:enterText];
        enterText.secureTextEntry = YES;
        enterText.tintColor = kAssistColor;
        enterText.textColor = kTextColor;
        enterText.font = H15;
        enterText.placeholder = kLocalizedString(@"验证码");
        self.enterText = enterText;
        self.enterText.keyboardType = UIKeyboardTypeNumberPad;
        self.enterText.limitTextLength = KVerificationNumber;
        [enterText mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(Adapted(15));
            make.top.mas_equalTo(msgLabel.mas_bottom).offset(Adapted(38));
            make.width.mas_equalTo(Adapted(150));
        }];
        enterText.didChangeBlock = ^(NSString *text) {
            @strongify(self);
            if(text.length>0){
                self.nextBtn.enabled = YES;
            }else{
                self.nextBtn.enabled = NO;
            }
            
        };
        
        UIView  *lineView = [[UIView alloc]init];
        [self.alertView addSubview:lineView];
        lineView.backgroundColor = UIColorFromRGB(0xe7e7e7);
        [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(Adapted(15));
            make.right.mas_equalTo(Adapted(-15));
            make.top.mas_equalTo(enterText.mas_bottom).offset(Adapted(5));
            make.height.mas_equalTo(1);
        }];
        
        
        //验证码竖线
        UIView * shuxian = [[UIView alloc]init];
        [self.alertView addSubview:shuxian];
        shuxian.backgroundColor = UIColorFromRGB(0xe7e7e7);
        [shuxian mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(enterText);
            make.width.mas_equalTo(1);
            make.height.mas_equalTo(20);
            make.left.mas_equalTo(enterText.mas_right).offset(2);
        }];
        
        //验证码按钮
        UIButton * codeButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.alertView addSubview:codeButton];
        [codeButton setTitle:kLocalizedString(@"获取验证码") forState:UIControlStateNormal];
        codeButton.titleLabel.font = H15;
        [codeButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(shuxian.mas_right).offset(Adapted(5));
            make.centerY.mas_equalTo(enterText);
            make.right.mas_equalTo(self.alertView.mas_right).offset(Adapted(-5));
            make.height.mas_equalTo(Adapted(40));
            
        }];
        [codeButton addTarget:self action:@selector(getVerificationCode:) forControlEvents:UIControlEventTouchUpInside];
        self.codeButton = codeButton;
        [self.codeButton setTitleColor:kRedColor forState:UIControlStateNormal];
        [TWAppTool startTheCountdownWithPhoneCountdown:SecondaryValidationNumberdown Time:SecondaryValidationNumberdownTime btn:codeButton];
        
        
        UIButton * nextBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.alertView addSubview:nextBtn];
        [nextBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(self.alertView);
            make.top.mas_equalTo(lineView.mas_bottom).offset(Adapted(30));
            make.width.mas_equalTo(Adapted(180));
            make.height.mas_equalTo(Adapted(36));
        }];
//        nextBtn.layer.cornerRadius = Adapted(36)/2.0;
//        nextBtn.clipsToBounds = YES;
        [nextBtn setTitle:kLocalizedString(@"提交") forState:UIControlStateNormal];
        [nextBtn setTitleColor:white_color forState:UIControlStateNormal];
        nextBtn.enabled = NO;
        self.nextBtn = nextBtn;
        [nextBtn setStatusWithEnableColor:kMainColor disableColor:k99999Color];
        [nextBtn mg_addTapBlock:^(UIButton *button) {
            @strongify(self);
            if(sureBlock){
                sureBlock(self.message,enterText.text);
            }
            [self hidden];
            
        }];
        
        
        //手机/邮箱切换
        UIButton * changeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.alertView addSubview:changeBtn];
        [changeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(self.alertView);
            make.top.mas_equalTo(nextBtn.mas_bottom).offset(Adapted(20));
            make.width.mas_equalTo(Adapted(100));
            make.height.mas_equalTo(Adapted(36));
        }];
        [changeBtn setTitle:kLocalizedString(@"邮箱验证") forState:UIControlStateNormal];
        [changeBtn setTitle:kLocalizedString(@"手机验证") forState:UIControlStateSelected];
        [changeBtn setTitleColor:kRedColor forState:UIControlStateNormal];
        [changeBtn addTarget:self action:@selector(changeBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        
        if(self.codeType == 1 || self.codeType == 2){
            changeBtn.hidden = YES;
        }
        
        self.viewModel.loginNum = self.message;
        if(self.codeType == 1){
            self.viewModel.registerType = 1;
        }else if (self.codeType == 2){
            self.viewModel.registerType = 2;
        }else if (self.codeType == 3){
            self.viewModel.registerType = 1;
        }
        
    }
    
    return self;
    
}

-(void)changeBtnClick:(UIButton *)button{
    button.selected = !button.selected;

    if(button.selected == YES){
      self.viewModel.registerType = 2;
        self.msgLabel.text = [TWAppTool mg_securePhoneMailText:_userModel.email];
        self.message = _userModel.email;
        
        
    }else{
        self.viewModel.registerType = 1;
        self.msgLabel.text = [TWAppTool mg_securePhoneMailText:_userModel.phone];
        self.message = _userModel.phone;
    }
    
}

//获取验证码
-(void)getVerificationCode:(UIButton *)btn{

    [self endEditing:YES];
 
    self.viewModel.loginNum = self.message;
    //订阅信号
    @weakify(self);
    [self.viewModel.sendPhoneCodeSignal subscribeNext:^(id x) {

        @strongify(self);
            [TTWHUD showCustomIcon:@"gou" title:kLocalizedString(@"已发送") toView:self.superview];
            [self.codeButton mg_startCountDownTime:Countdown finishTitle:kLocalizedString(@"重新获取验证码") waitTittle:@"S" finishColor:nil waitColor:nil Finish:^(UIButton *button) {

            }];


    }];
    
}



-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self endEditing:YES];
}

-(void)show
{
    
    self.alpha = 0;
    [UIView animateWithDuration:0.3 animations:^{
        self.alpha = 1;
    }];
    
    
    [self.toView addSubview:self];
    
    self.alertView.transform = CGAffineTransformMakeScale(1.3, 1.3);
    self.alertView.alpha = 0;
    [UIView animateWithDuration:.35 animations:^{
        self.alertView.alpha = 1;
        self.alertView.transform = CGAffineTransformMakeScale(1, 1);
    }];
    
}

-(void)hidden{
    [[[UIApplication sharedApplication] keyWindow] endEditing:YES];
    [UIView animateWithDuration:.2 animations:^{
        self.transform = CGAffineTransformMakeScale(1.0, 1.0);
        self.alpha = 0.0;
    } completion:^(BOOL finished) {
        if (finished) {
            
            [self removeFromSuperview];
        }
    }];
}

-(RegisterIndexVM *)viewModel{
    if(!_viewModel){
        _viewModel = [[RegisterIndexVM alloc]init];
        
    }
    return _viewModel;
}
@end
