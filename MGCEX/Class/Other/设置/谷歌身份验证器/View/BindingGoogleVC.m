// MGC
//
// BindingGoogleVC.m
// MGCEX
//
// Created by MGC on 2018/5/19.
// Copyright © 2018年 MGCion. All rights reserved.
//
// @ description <#描述#> 

#import "BindingGoogleVC.h"
#import "BindingGoogleVM.h"
#import "BindingGoogleModel.h"
#import "HGDQQRCodeView.h"
#import "BindingGoogleCodeVC.h"

@interface BindingGoogleVC ()
@property (nonatomic, strong) BindingGoogleVM * viewModel;
@property (nonatomic, strong) UIImageView * codeImageV;
@property (nonatomic, strong) UILabel * miyao;
@property (nonatomic, copy) NSString * miyaoStr;
@property (nonatomic, strong) UIButton * nextBtn;
@end

@implementation BindingGoogleVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUpViews];
    [self getGoogleKey];
}

-(void)setUpViews{
    
    self.title = kLocalizedString(@"绑定谷歌身份验证器");
    UILabel * titleLabel = [[UILabel alloc]init];
    [self.view addSubview:titleLabel];
    titleLabel.textColor = kRedColor;
    titleLabel.font = H15;
    titleLabel.numberOfLines = 0;
    titleLabel.text = kLocalizedString(@"切记!请妥备份并保管好密钥!以防丢失");
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(Adapted(15));
        make.top.mas_equalTo(Adapted(15));
        make.right.mas_equalTo(Adapted(-15));
    }];
    
    UIView * backView = [[UIView alloc]init];
    [self.view addSubview:backView];
    backView.backgroundColor = kBackAssistColor;
    [backView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.right.mas_equalTo(self.view);
        make.top.mas_equalTo(titleLabel.mas_bottom).offset(Adapted(15));
    }];
    
    UILabel * miyao = [[UILabel alloc]init];
    [backView addSubview:miyao];
    miyao.numberOfLines = 0;
    miyao.textColor = kTextColor;
    miyao.font = H17;
    miyao.textAlignment = NSTextAlignmentRight;
    miyao.text = @"";
    [miyao mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(Adapted(15));
        make.top.mas_equalTo(Adapted(35));
        make.right.mas_equalTo(Adapted(-120));
    }];
    self.miyao = miyao;
    
    UIButton * copyBtn = [UIButton buttonWithType:0];
    [backView addSubview:copyBtn];
    copyBtn.clipsToBounds = YES;
    copyBtn.layer.borderColor = kRedColor.CGColor;
    copyBtn.layer.borderWidth = 1;
    copyBtn.layer.cornerRadius = Adapted(28)/2.0;
    [copyBtn setTitle:kLocalizedString(@"复制") forState:UIControlStateNormal];
    [copyBtn setTitleColor:kRedColor forState:UIControlStateNormal];
    [copyBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(Adapted(-30));
        make.top.mas_equalTo(Adapted(30));
        make.width.mas_equalTo(Adapted(64));
        make.height.mas_equalTo(Adapted(28));
    }];
    @weakify(self);
    [copyBtn mg_addTapBlock:^(UIButton *button) {
        if(self.miyaoStr.length==0)  return;
        [TTWHUD showCustomMsg:kLocalizedString(@"复制成功")];
        UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
        pasteboard.string = self.miyaoStr;
    }];
    
    UIImageView * codeImageV = [[UIImageView alloc]init];
    [backView addSubview:codeImageV];
    [codeImageV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(backView);
        make.top.mas_equalTo(miyao.mas_bottom).offset(Adapted(30));
        make.width.height.mas_equalTo(Adapted(180));
    }];
    self.codeImageV = codeImageV;
    
    UILabel * hint1 = [[UILabel alloc]init];
    [backView addSubview:hint1];
    hint1.textColor = UIColorFromRGB(0x6e6f72);
    hint1.font = H15;
    hint1.numberOfLines = 0;
    hint1.text = kLocalizedString(@"您可以使用 Authenticator APP");
    [hint1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(Adapted(15));
        make.top.mas_equalTo(codeImageV.mas_bottom).offset(Adapted(30));
        make.right.mas_equalTo(Adapted(-15));
    }];
    
    UILabel * hint2 = [[UILabel alloc]init];
    [backView addSubview:hint2];
    hint2.textColor = UIColorFromRGB(0x6e6f72);
    hint2.font = H15;
    hint2.numberOfLines = 0;
    hint2.text = kLocalizedString(@"扫描二维码或手动添加账户并输入密钥进行验证");
    [hint2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(Adapted(15));
        make.top.mas_equalTo(hint1.mas_bottom).offset(Adapted(5));
        make.right.mas_equalTo(Adapted(-15));
    }];
    
    
    //下一步
    UIButton * nextBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [backView addSubview:nextBtn];
    [nextBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(backView);
        make.top.mas_equalTo(hint2.mas_bottom).offset(Adapted(40));
        make.width.mas_equalTo(MAIN_SCREEN_WIDTH-Adapted(30));
        make.height.mas_equalTo(Adapted(40));
    }];
    nextBtn.layer.cornerRadius = Adapted(2);
    nextBtn.clipsToBounds = YES;
    nextBtn.enabled = NO;
    [nextBtn setTitle:kLocalizedString(@"下一步") forState:UIControlStateNormal];
    [nextBtn setTitleColor:white_color forState:UIControlStateNormal];
    [nextBtn setStatusWithEnableColor:kRedColor disableColor:kDisableRedColor];
    [nextBtn mg_addTapBlock:^(UIButton *button) {
        @strongify(self);
        BindingGoogleCodeVC * vc = [[BindingGoogleCodeVC alloc]init];
        vc.miyaoStr = self.miyaoStr;
        [self.navigationController pushViewController:vc animated:YES];
   
    }];
    self.nextBtn = nextBtn;
}


-(void)getGoogleKey{

    //订阅信号
    @weakify(self);
    [self.viewModel.googleSignal subscribeNext:^(BindingGoogleModel *model) {
        @strongify(self);
        self.miyaoStr = model.secret;
        NSString * str =kLocalizedString(@"密钥");
        self.miyao.text = [NSString stringWithFormat:@"%@:%@",str,model.secret];
        self.nextBtn.enabled = YES;
        [HGDQQRCodeView creatQRCodeWithURLString:model.qrcode superView:self.codeImageV logoImage:nil logoImageSize:CGSizeZero logoImageWithCornerRadius:0];
        
    }];
}

-(BindingGoogleVM *)viewModel{
    if(!_viewModel){
        _viewModel = [[BindingGoogleVM alloc]init];
    }
    return _viewModel;
}



@end
