// MGC
//
// FillPassportInformationVC.m
// MGCEX
//
// Created by MGC on 2018/5/16.
// Copyright © 2018年 MGCion. All rights reserved.
//
// @ description <#描述#> 

#import "FillPassportInformationVC.h"
#import "IDCardProgressView.h"
#import "FrontPassportVC.h"

@interface FillPassportInformationVC ()
@property (nonatomic, strong) UIButton * nextBtn;
@property (nonatomic, strong) UITextField * nameTextFile;
@property (nonatomic ,strong) UITextField * surnameFile;
@property (nonatomic ,strong) UITextField * passportFile;
@property (nonatomic, strong) UIView * bottomLlineView;
@end

@implementation FillPassportInformationVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = white_color;
    self.title = kLocalizedString(@"护照认证");
    [self setUpHeadViews];
    [self setUpBottomViews];
}

-(void)setUpHeadViews{
    
    IDCardProgressView * headView = [[IDCardProgressView alloc]initWithImage:@"hzjd1" step:1 style:2 frame:CGRectMake(0, 0, MAIN_SCREEN_WIDTH, Adapted(80))];
    [self.view addSubview:headView];
    
    UILabel * titleLabel = [[UILabel alloc]init];
    [self.view addSubview:titleLabel];
    titleLabel.textColor = kTextColor;
    titleLabel.font = H15;
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.text = kLocalizedString(@"请填写您的护照信息");
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(Adapted(15));
        make.right.mas_equalTo(Adapted(-15));
        make.top.mas_equalTo(Adapted(90));
    }];
    
}

-(void)setUpBottomViews{
    
    NSArray * titleArr = @[kLocalizedString(@"名字"),kLocalizedString(@"姓"),kLocalizedString(@"护照号码")];
    for(int i=0;i<titleArr.count;i++){
        
        UILabel * nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(Adapted(15), Adapted(164)+i*Adapted(60), Adapted(100), Adapted(20))];
        [self.view addSubview:nameLabel];
        nameLabel.text = titleArr[i];
        nameLabel.textColor = kTextColor;
        nameLabel.font = H15;
        
        UITextField * textField = [[UITextField alloc]initWithFrame:CGRectMake(Adapted(115), Adapted(154)+Adapted(60)*i, MAIN_SCREEN_WIDTH-Adapted(130), Adapted(40))];
        [self.view addSubview:textField];
        textField.placeholder = kLocalizedString(@"请输入");
        textField.tag = 100+i;
        textField.font = H15;
        [textField setValue:k99999Color forKeyPath:@"_placeholderLabel.textColor"];

        UIView * nameLine = [[UIView alloc]initWithFrame:CGRectMake(Adapted(15), Adapted(195)+i*Adapted(60), MAIN_SCREEN_WIDTH-Adapted(30), 1)];
        [self.view addSubview:nameLine];
        nameLine.backgroundColor = kAssistColor;
        nameLine.alpha = 0.5;
        nameLine.tag = 200+i;
        
    }
    self.nameTextFile = [self.view viewWithTag:100];
    self.surnameFile = [self.view viewWithTag:101];
    self.passportFile = [self.view viewWithTag:102];
    self.bottomLlineView = [self.view viewWithTag:202];
    @weakify(self);
    self.nameTextFile.didChangeBlock = ^(NSString *text) {
        @strongify(self);
        [self changeRegisStatus];
        
    };
    
    self.surnameFile.didChangeBlock = ^(NSString *text) {
        @strongify(self);
        [self changeRegisStatus];
        
    };
    
    self.passportFile.didChangeBlock = ^(NSString *text) {
        @strongify(self);
        [self changeRegisStatus];
        
    };
    
    //下一步
    UIButton * nextBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.view addSubview:nextBtn];
    [nextBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.view);
        make.top.mas_equalTo(self.bottomLlineView.mas_bottom).offset(Adapted(40));
        make.width.mas_equalTo(MAIN_SCREEN_WIDTH-Adapted(30));
        make.height.mas_equalTo(Adapted(40));
    }];
    nextBtn.layer.cornerRadius = Adapted(2);
    nextBtn.clipsToBounds = YES;
    [nextBtn setTitle:kLocalizedString(@"下一步") forState:UIControlStateNormal];
    [nextBtn setTitleColor:white_color forState:UIControlStateNormal];
    nextBtn.enabled = NO;
    [nextBtn setStatusWithEnableColor:kRedColor disableColor:kDisableRedColor];
    nextBtn.alpha = 1;
    [nextBtn addTarget:self action:@selector(nextBtnClick) forControlEvents:UIControlEventTouchUpInside];
    self.nextBtn = nextBtn;
}

//下一步
-(void)nextBtnClick{
    
    [[NSUserDefaults standardUserDefaults]setObject:self.nameTextFile.text forKey:PassportName];
    [[NSUserDefaults standardUserDefaults]setObject:self.surnameFile.text forKey:PassportsUrname];
    [[NSUserDefaults standardUserDefaults]setObject:self.passportFile.text forKey:PassportNumber];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    FrontPassportVC * vc = [[FrontPassportVC alloc]init];
    [self.navigationController pushViewController:vc animated:NO];
}

//改变下一步按钮状态
-(void)changeRegisStatus{
    if(self.nameTextFile.text.length>0&&self.passportFile.text.length>0&&self.surnameFile.text.length>0){
        self.nextBtn.enabled = YES;
    }else{
        self.nextBtn.enabled = NO;
    }
}

@end
