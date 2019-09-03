// MGC
//
// ResertLoginPasswordVC.m
// MGCEX
//
// Created by MGC on 2018/5/18.
// Copyright © 2018年 MGCion. All rights reserved.
//
// @ description <#描述#> 

#import "ResertLoginPasswordVC.h"
#import "ResertLoginPasswordVM.h"

@interface ResertLoginPasswordVC ()
@property (nonatomic, strong) UITextField * oldPassword;
@property (nonatomic, strong) UITextField * currentPassword;
@property (nonatomic, strong) UITextField * againPassword;
@property (nonatomic, strong) UIButton * nextBtn;
@property (nonatomic, strong) ResertLoginPasswordVM * viewModel;
@end

@implementation ResertLoginPasswordVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = kLocalizedString(@"重置登录密码");
    
    NSArray * titles = @[kLocalizedString(@"原登录密码"),kLocalizedString(@"重置密码"),kLocalizedString(@"再次确认密码")];
    UIView * backView = [[UIView alloc]initWithFrame:CGRectMake(0, Adapted(30), MAIN_SCREEN_WIDTH, 2+titles.count*Adapted(48))];
    backView.backgroundColor = kBackGroundColor;
    [self.view addSubview:backView];
    for(int i=0;i<titles.count;i++){
        UITextField * textfield = [[UITextField alloc]initWithFrame:CGRectMake(Adapted(15),Adapted(30)+ i*Adapted(48), Adapted(280), Adapted(48))];
        [self.view addSubview:textfield];
        textfield.placeholder = titles[i];
        textfield.placeholderColor = kLineColor;
        textfield.tintColor = kTextColor;
        textfield.textColor = kTextColor;
        textfield.font = H15;
        textfield.tag = 100+i;
        
        //下划线
//        if(i<titles.count-1){
            UIView * Line = [[UIView alloc]initWithFrame:CGRectMake(Adapted(15),Adapted(30)+(i+1)*Adapted(48), MAIN_SCREEN_WIDTH-Adapted(30), 1)];
            [self.view addSubview:Line];
            Line.backgroundColor = kLineColor;
//        }
        
        
        
        //密码眼睛
        UIButton * seeButton = [[UIButton alloc]initWithFrame:CGRectMake(MAIN_SCREEN_WIDTH-Adapted(45), Adapted(30)+Adapted(4)+i*Adapted(48), Adapted(40), Adapted(40))];
        [self.view addSubview:seeButton];
        seeButton.tag = 200+i;
        [seeButton addTarget:self action:@selector(showOrHiddenPassword:) forControlEvents:UIControlEventTouchUpInside];
        [seeButton setImage:[UIImage imageNamed:@"yinchang"] forState:UIControlStateNormal];
        [seeButton setImage:[UIImage imageNamed:@"xianshi"] forState:UIControlStateSelected];
    }
    
    self.oldPassword = [self.view viewWithTag:100];
    self.currentPassword = [self.view viewWithTag:101];
    self.againPassword = [self.view viewWithTag:102];
    self.againPassword.limitTextLength = 22;
    self.currentPassword.limitTextLength = 22;
    
    self.oldPassword.secureTextEntry = YES;
    self.currentPassword.secureTextEntry = YES;
    self.againPassword.secureTextEntry = YES;
    
    @weakify(self);
    self.oldPassword.didChangeBlock = ^(NSString *text) {
        @strongify(self);
        if(text.length>5&&self.currentPassword.text.length>5&&self.againPassword.text.length>5){
            self.nextBtn.enabled = YES;
        }else{
            self.nextBtn.enabled = NO;
        }
    };
    
    self.currentPassword.didChangeBlock = ^(NSString *text) {
        @strongify(self);
        if(text.length>5&&self.oldPassword.text.length>5&&self.againPassword.text.length>5){
            self.nextBtn.enabled = YES;
        }else{
            self.nextBtn.enabled = NO;
        }
    };
    
    self.againPassword.didChangeBlock = ^(NSString *text) {
        @strongify(self);
        if(text.length>5&&self.currentPassword.text.length>5&&self.oldPassword.text.length>5){
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
    nextBtn.layer.cornerRadius = Adapted(2);
    nextBtn.clipsToBounds = YES;
    [nextBtn setTitle:kLocalizedString(@"提交") forState:UIControlStateNormal];
    [nextBtn setTitleColor:white_color forState:UIControlStateNormal];
    nextBtn.enabled = NO;
    [nextBtn setStatusWithEnableColor:kRedColor disableColor:kDisableRedColor];
    nextBtn.alpha = 1;
    [nextBtn addTarget:self action:@selector(nextBtnClick) forControlEvents:UIControlEventTouchUpInside];
    self.nextBtn = nextBtn;
}

//显示隐藏密码
-(void)showOrHiddenPassword:(UIButton *)btn{
    btn.selected = !btn.selected;
    UITextField * textField = [self.view viewWithTag:btn.tag-100];
    textField.secureTextEntry = !textField.secureTextEntry;
}


-(void)nextBtnClick{
    
    [self.view endEditing:YES];
    if(![self.currentPassword.text isEqualToString:self.againPassword.text]){
        [TTWHUD showCustomMsg:kLocalizedString(@"重置密码不一致")];
        return;
    }
    if ([self.currentPassword.text rangeOfString:@" "].location != NSNotFound) {
        [TTWHUD showCustomMsg:kLocalizedString(@"密码不能包含空格")];
        return;
    }
    self.viewModel.password = self.oldPassword.text;
    self.viewModel.currentPassword = self.againPassword.text;
    //订阅信号
    @weakify(self);
    [self.viewModel.validationLoginSignal subscribeNext:^(id x) {
        @strongify(self);
        [TTWHUD showCustomMsg:kLocalizedString(@"重置成功")];
        [self.navigationController popViewControllerAnimated:YES];
    }];
}


-(ResertLoginPasswordVM *)viewModel{
    if(!_viewModel){
        _viewModel = [[ResertLoginPasswordVM alloc]init];
    }
    return _viewModel;
}
@end
