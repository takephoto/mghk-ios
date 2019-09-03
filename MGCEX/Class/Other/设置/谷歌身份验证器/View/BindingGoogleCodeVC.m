// MGC
//
// BindingGoogleCodeVC.m
// MGCEX
//
// Created by MGC on 2018/5/19.
// Copyright © 2018年 MGCion. All rights reserved.
//
// @ description <#描述#> 

#import "BindingGoogleCodeVC.h"
#import "BindingGoogleVM.h"

@interface BindingGoogleCodeVC ()
@property (nonatomic, strong) UIButton *nextBtn;
@property (nonatomic, strong) BindingGoogleVM * viewModel;
@property (nonatomic, strong) UITextField * textPassword;

@end

@implementation BindingGoogleCodeVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = kLocalizedString(@"谷歌验证码");
    
    UIView * backView = [[UIView alloc]init];
    [self.view addSubview:backView];
    backView.backgroundColor = kBackAssistColor;
    [backView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(self.view);
        make.top.mas_equalTo(Adapted(15));
        make.height.mas_equalTo(Adapted(48));
        
    }];
    
    //密码
    UITextField * textPassword = [[UITextField alloc]init];
    [backView addSubview:textPassword];
    self.textPassword = textPassword;
    [textPassword mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(Adapted(15));
        make.top.bottom.mas_equalTo(backView);
        make.right.mas_equalTo(Adapted(-15));
    }];
    textPassword.font = H15;
    textPassword.textColor = kTextColor;
    textPassword.placeholder = kLocalizedString(@"请输入谷歌验证密码");
    textPassword.tintColor = kTextColor;
    textPassword.placeholderColor = kLineColor;
    [textPassword setValue:[UIFont boldSystemFontOfSize:Adapted(15)] forKeyPath:@"_placeholderLabel.font"];
    @weakify(self);
    textPassword.didChangeBlock = ^(NSString *text) {
        @strongify(self);
        if(text.length>0){
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
        make.top.mas_equalTo(backView.mas_bottom).offset(Adapted(40));
        make.width.mas_equalTo(MAIN_SCREEN_WIDTH-Adapted(30));
        make.height.mas_equalTo(Adapted(40));
    }];
    nextBtn.layer.cornerRadius = Adapted(40)/2.0;
    nextBtn.clipsToBounds = YES;
    [nextBtn setTitle:kLocalizedString(@"下一步") forState:UIControlStateNormal];
    [nextBtn setTitleColor:kTextColor forState:UIControlStateNormal];
    nextBtn.enabled = NO;
    self.nextBtn = nextBtn;
    [nextBtn setStatusWithEnableColor:kRedColor disableColor:kDisableRedColor];
    [nextBtn addTarget:self action:@selector(nextClick) forControlEvents:UIControlEventTouchUpInside];
  
    
}


-(void)nextClick{
    
    self.viewModel.secret = self.miyaoStr;
    self.viewModel.code = self.textPassword.text;
    //订阅信号
    @weakify(self);
    [self.viewModel.verifyGoogleSignal subscribeNext:^(id x) {
        @strongify(self);
        [TTWHUD showCustomMsg:kLocalizedString(@"验证成功")];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self popToViewControllerWithClass:@"PersonalSettingsIndexVC"];
        });
        
    }];
    
}

-(BindingGoogleVM *)viewModel{
    if(!_viewModel){
        _viewModel = [[BindingGoogleVM alloc]init];
    }
    return _viewModel;
}

@end
